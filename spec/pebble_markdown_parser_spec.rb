# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative './spec_helper'
require 'redcarpet'
require 'jekyll'
require 'nokogiri'

require_relative '../plugins/pebble_markdown_parser'

describe Jekyll::Converters::Markdown::PebbleMarkdownParser, '#convert' do
  it 'renders normal markdown properly' do
    expect(parser.convert('**Bold Text**').strip)
      .to eql('<p><strong>Bold Text</strong></p>')
  end

  it 'adds anchors to headers' do
    doc = md2doc("# Header 1\n## Header 2")
    expect(doc.at_css('h1').attribute('id').value).to eql('header-1')
    expect(doc.at_css('h1').content).to eql('Header 1')
    expect(doc.at_css('h2').attribute('id').value).to eql('header-2')
    expect(doc.at_css('h2').content).to eql('Header 2')
  end

  describe 'links' do
    it 'prepends the site base URL to absolute links' do
      links = [
        ['/link1/', '/BASEURL/link1/'],
        ['link2/', 'link2/'],
        ['//link3/', '//link3/']
      ]
      doc = md2doc(links.map { |link| "[link](#{link[0]})" }.join('\n'))
      links.each_with_index do |link, index|
        expect(doc.at_css("a:nth-child(#{index + 1})").attribute('href').value)
          .to eql(link[1])
      end
    end

    describe 'buttons' do
      it 'can generate a simple button' do
        doc = md2doc('[button >](http://google.com)')
        expect(doc.at_css('a').attribute('class').value)
          .to eql('btn btn--markdown')
        expect(doc.at_css('a').content).to eql('button')
      end

      it 'can generate a button with additional classes' do
        doc = md2doc('[button >{large,pink}](http://google.com)')
        expect(doc.at_css('a').attribute('class').value)
          .to eql('btn btn--markdown btn--large btn--pink')
        expect(doc.at_css('a').content).to eql('button')
      end
    end

    describe 'data attributes' do
      it 'can add a single data attribute to a link' do
        doc = md2doc('[link](http://google.com "title >{item:foo}")')
        expect(doc.at_css('a').attribute('data-item').value).to eql('foo')
        expect(doc.at_css('a').attribute('title').value).to eql('title')
      end

      it 'can add a multiple data attributes to a link' do
        doc = md2doc('[link](http://google.com "title >{item:foo,item2:bar}")')
        expect(doc.at_css('a').attribute('data-item').value).to eql('foo')
        expect(doc.at_css('a').attribute('data-item2').value).to eql('bar')
        expect(doc.at_css('a').attribute('title').value).to eql('title')
      end

      it 'can add data attributes without a title' do
        doc = md2doc('[link](http://google.com " >{item:foo}")')
        expect(doc.at_css('a').attribute('data-item').value).to eql('foo')
        expect(doc.at_css('a').attribute('title').value).to eql('')
      end
    end

    describe 'embeds' do
      it 'generates YouTube video embeds' do
        id = 'dQw4w9WgXcQ'
        doc = md2doc("[EMBED](https://www.youtube.com/watch?v=#{id})")
        expect(doc.at_css('iframe').attribute('src').value)
          .to eql("//www.youtube.com/embed/#{id}?rel=0")
        doc = md2doc("[EMBED](https://www.youtube.com/v/#{id})")
        expect(doc.at_css('iframe').attribute('src').value)
          .to eql("//www.youtube.com/embed/#{id}?rel=0")
        doc = md2doc("[EMBED](//www.youtube.com/v/#{id})")
        expect(doc.at_css('iframe').attribute('src').value)
          .to eql("//www.youtube.com/embed/#{id}?rel=0")
      end

      it 'generates YouTube playlist embeds' do
        id = 'PLDPHNsf1sb4-EXiIUOGqsX81etZepB7C0'
        doc = md2doc("[EMBED](https://www.youtube.com/playlist?list=#{id})")
        expect(doc.at_css('iframe').attribute('src').value)
          .to eql("//www.youtube.com/embed/videoseries?list=#{id}")
      end

      it 'generates Vimeo video embeds' do
        id = '0581081381803'
        doc = md2doc("[EMBED](//player.vimeo.com/video/#{id}?title=0&byline=0)")
        expect(doc.at_css('iframe').attribute('src').value)
          .to eql("//player.vimeo.com/video/#{id}")
      end

      it 'generated Gist embeds' do
        id = '57a8c2b8670b9a6b7119'
        doc = md2doc("[EMBED](https://gist.github.com/matthewtole/#{id})")
        expect(doc.at_css('script').attribute('src').value)
          .to eql("//gist.github.com/matthewtole/#{id}.js")
      end
    end
  end

  describe 'images' do
    it 'prepends the asset path for absolute paths' do
      images = [
        ['/img1.png', '//ASSETS/img1.png'],
        ['img2.png', 'img2.png'],
        ['//img3.png', '//img3.png']
      ]
      doc = md2doc(images.map { |img| "![](#{img[0]})" }.join(' '))
      images.each_with_index do |img, index|
        expect(doc.at_css("img:nth-child(#{index + 1})").attribute('src').value)
          .to eql(img[1])
      end
    end

    describe 'size' do
      it 'can specify the width of an image' do
        doc = md2doc('![Alt Text](image_url =300)')
        expect(doc.at_css('img').attribute('width').value).to eql('300')
      end

      it 'can specify the width and height of an image' do
        doc = md2doc('![Alt Text](image_url =300x200)')
        expect(doc.at_css('img').attribute('width').value).to eql('300')
        expect(doc.at_css('img').attribute('height').value).to eql('200')
      end
    end
  end

  describe 'paragraphs' do
    it 'adds a data attribute for sdk platforms' do
      doc = md2doc("^LC^ Local SDK instructions\n\n^CP^CloudPebble instructions\n\nRegular old paragraph")
      expect(doc.at_css('p:nth-child(1)').attribute('data-sdk-platform').value).to eql('local')
      expect(doc.at_css('p:nth-child(1)').content).to eql('Local SDK instructions')
      expect(doc.at_css('p:nth-child(1)')['class']).to include('platform-specific')
      expect(doc.at_css('p:nth-child(2)').attribute('data-sdk-platform').value).to eql('cloudpebble')
      expect(doc.at_css('p:nth-child(2)').content).to eql('CloudPebble instructions')
      expect(doc.at_css('p:nth-child(2)')['class']).to include('platform-specific')
      expect(doc.at_css('p:nth-child(3)').attribute('data-sdk-platform')).to eql(nil)
      expect(doc.at_css('p:nth-child(3)').content).to eql('Regular old paragraph')
    end
  end

  describe 'block code' do
    it 'processes code blocks with Pygments' do
      doc = md2doc("```\nvar a = 1;\n```")
      expect(doc.at_css('div.highlight')).to_not be_nil
      expect(doc.css('div.highlight span').size).to be > 0
    end

    it 'skips highlighting if language is text' do
      doc = md2doc("```text\nvar a = 1;\n```")
      expect(doc.at_css('div.highlight > pre')).to_not be_nil
      expect(doc.css('div.highlight span').size).to be(0)
    end

    it 'adds no-copy to classes if nc prefix' do
      doc = md2doc("```nc|js\nvar a = 1;\n```")
      div = doc.at_css('div.highlight')
      expect(div['class']).to include('no-copy')
    end
  end

  describe 'documentation auto-linking' do
    before do
      allow(Jekyll.logger).to receive(:warn)
    end
    it 'should convert double backticks into documentation links' do
      doc = md2doc("``Window``")
      link = doc.at_css('a')
      expect(link).to_not be_nil
      expect(link.attribute('href').value).to eql('/BASEURL/docs/c/Window/')
      expect(link['class']).to include('link--docs')
      expect(link.at_css('code').content).to eql('Window')
    end

    it 'should use the language prefix where available' do
      doc = md2doc("``pebblejs:Window``")
      link = doc.at_css('a')
      expect(link).to_not be_nil
      expect(link.attribute('href').value).to eql('/BASEURL/docs/pebblejs/Window/')
      expect(link['class']).to include('link--docs')
      expect(link.at_css('code').content).to eql('Window')
    end

    it 'should print a warning if symbol not found' do
      expect(Jekyll.logger).to receive(:warn).once
      doc = md2doc("``pebblejs:NotASymbol``")
    end

    it 'should remove the prefix  if symbol not found' do
      doc = md2doc("``pebblejs:NotASymbol``")
      code = doc.at_css('code')
      expect(code.content).to eql('NotASymbol')
    end

    it 'should convert double backticks from inside links' do
      doc = md2doc("[LinkTitle](``window``)")
      link = doc.at_css('a')
      expect(link).to_not be_nil
      expect(link.attribute('href').value).to eql('/BASEURL/docs/c/Window/')
      expect(link['class']).to include('link--docs')
      expect(link.content).to eql('LinkTitle')
    end

    it 'should handle missing link uses' do
      doc = md2doc("[LinkTitle](``DoesNotExist``)")
      code = doc.at_css('p')
      expect(code.content).to eql('LinkTitle')
    end

  end

  def md2doc(markdown)
    html = parser.convert(markdown)
    Nokogiri::HTML.fragment(html)
  end

  def parser
    site = {
      'baseurl' => '/BASEURL',
      'asset_path' => '//ASSETS',
      docs: {
        symbols: fake_symbols
      }
    }
    Jekyll::Converters::Markdown::PebbleMarkdownParser.new(site)
  end

  def fake_symbols
    [
      { name: 'Window', url: '/docs/c/Window/', language: 'c' },
      { name: 'Window', url: '/docs/pebblejs/Window/', language: 'pebblejs' }
    ]
  end
end

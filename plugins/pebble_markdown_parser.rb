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

require 'redcarpet'
require 'pygments'
require 'slugize'
require 'nokogiri'

module Jekyll
  module Converters
    # Jekyll Markdown Converter wrapper for Redcarpet using the PebbleMarkdown
    # HTML render class.
    class Markdown::PebbleMarkdownParser
      def initialize(config)
        @site_config = config
      end

      def convert(content)
        content = '' if content.nil?
        pbl_md = PebbleMarkdown.new(@site_config)
        Redcarpet::Markdown.new(pbl_md,
                                fenced_code_blocks: true,
                                autolink: true,
                                tables: true,
                                no_intra_emphasis: true,
                                strikethrough: true,
                                highlight: true).render(+content)
      end

      # Redcarpet HTML render class to handle the extra functionality.
      class PebbleMarkdown < Redcarpet::Render::HTML
        def initialize(config)
          @site_config = config
          super()
        end

        def preprocess(document)
          process_links_with_double_backticks(document)
          process_double_backticks(document)
          document
        end

        # Add ID and anchors to all headers.
        def header(text, header_level)
          if text.include?('<')
            id = Nokogiri::HTML(text).text.slugize
          else
            id = text.slugize
          end
          str = "<h#{header_level} id=\"#{id}\" class=\"anchor\">"
          str += text
          str += "</h#{header_level}>"
          str
        end

        def paragraph(text)
          if (match = /^\^(CP|LC)\^/.match(text))
            "<p class=\"platform-specific\" data-sdk-platform=\"#{shortcode_to_platform(match[1])}\">#{text[(match[1].length + 2)..-1].strip}</p>"
          else
            "<p>#{text}</p>"
          end
        end

        # Use Pygments to generate the syntax highlighting markup.
        def block_code(code, language)
          classes = ['highlight']
          if /^nc\|/.match(language)
            classes << 'no-copy'
            language = language[3..-1]
          end
          if language == 'text'
            "<div class=\"#{classes.join(' ')}\"><pre>#{code}</pre></div>"
          else
            set_classes(Pygments.highlight(code, lexer: language), classes)
          end
        end

        def link(url, title, content)
          if content == 'EMBED'
            embed(url)
          else
            classes = []
            if /^DOCS:/.match(title)
              title = title[5..-1]
              classes << 'link--docs'
            end
            # URL begins with a single slash (but not double slash)
            url = baseurl + url if %r{^/[^/]}.match(url)
            data_str = ''
            if (match = regex_button.match(content))
              classes << 'btn'
              classes << 'btn--markdown'
              classes.concat(match[3].split(',').map { |cls| 'btn--' + cls })
              content = match[1]
            end
            if (match = regex_link_data.match(title))
              match[3].split(',').each do |item|
                item = item.split(':')
                data_str += ' data-' + item[0] + '="' + item[1] + '"'
              end
              title = match[1]
            end
            "<a href=\"#{url}\"" \
              " title=\"#{title}\"" \
              " class=\"#{classes.join(' ')}\"#{data_str}>#{content}</a>"
          end
        end

        # Better image handling.
        # * Add size specificiations (taken from RDiscount)
        # * Prepend the site baselink to images that beings with /
        # TODO: Handle the cases where image link begins with //
        # TODO: Maybe add additional style choices (centered, inline, etc)
        def image(link, title, alt_text)
          if (size_match = /^(.*)\ =([0-9]+)x?([0-9]*)$/.match(link))
            link = size_match[1]
            width = size_match[2]
            height = size_match[3]
          end

          classes = []
          if (match = regex_button.match(alt_text))
            classes.concat(match[3].split(','))
            alt_text = match[1]
          end

          link = asset_path + link if %r{^/[^/]}.match(link)

          img_str = "<img src=\"#{link}\""
          img_str += " title=\"#{title}\"" unless title.to_s.empty?
          img_str += " alt=\"#{alt_text}\"" unless alt_text.to_s.empty?
          img_str += " width=\"#{width}\"" unless width.to_s.empty?
          img_str += " height=\"#{height}\"" unless height.to_s.empty?
          img_str += " class=\"#{classes.join(' ')}\"" unless classes.empty?
          img_str += ' />'
          img_str
        end

        private

        # This is used to process links that contain double backticks.
        # For example:
        # [click me](``Window``)
        # This allows for the text of a link to be different than the name
        # of the symbol you are linking to.
        def process_links_with_double_backticks(document)
          # Skip the warning, we don't want docs or links to them
          if !@site_config['skip_docs'].nil? && (@site_config['skip_docs'] == 'true')
            return
          end

          document.gsub!(/(\[([^\]]+)\])\(``([^`]+)``\)/) do |str|
            url = Regexp.last_match[3]
            text = Regexp.last_match[2]
            text_in_brackets = Regexp.last_match[1]

            language, symbol = parse_symbol(url)
            entry = docs_lookup(symbol, language)
            Jekyll.logger.warn('Backtick Warning:', "Could not find symbol '#{text}'") if entry.nil?

            entry ? (text_in_brackets + "#{backtick_link(entry)}") : text
          end
        end

        def process_double_backticks(document)
          # Skip the warning, we don't want docs or links to them
          if !@site_config['skip_docs'].nil? && (@site_config['skip_docs'] == 'true')
            return
          end

          document.gsub!(/([^`]+|\A)``([^`]+)``/) do |str|
            language, symbol = parse_symbol(Regexp.last_match[2])
            entry = docs_lookup(symbol, language)
            if entry.nil?
              Jekyll.logger.warn('Backtick Warning:', "Could not find symbol '#{Regexp.last_match[2]}'")
              language.nil? ? str : ('``' + Regexp.last_match[2][language.size+1..-1] + '``')
            else
              symbol_str = Regexp.last_match[2]
              symbol_str = symbol_str[language.size+1..-1] unless language.nil?
              "#{Regexp.last_match[1]}[`#{symbol_str}`]#{backtick_link(entry)}"
            end
          end
        end

        def backtick_link(symbol)
          "(#{symbol[:url]} \"DOCS:#{symbol[:name]}\")"
        end

        # Split the documentation string into language and symbol name.
        def parse_symbol(str)
          match = /^([a-z]*:)?([A-Za-z0-9_:\.\ ]*)/.match(str)
          language = match[1]
          language = language[0..-2].downcase unless language.nil?
          name = match[2]
          return language, name
        end

        def docs_lookup(name, language)
          return nil if name.nil?
          @site_config[:docs][:symbols].find do |symbol|
            symbol[:name].downcase == name.downcase &&
              (language.nil? ? true : symbol[:language] == language)
          end
        end

        def embed(url)
          if (match = regex_youtube_video.match(url))
            youtube(match[2])
          elsif (match = regex_youtube_playlist.match(url))
            youtube_playlist(match[3])
          elsif (match = regex_vimeo_video.match(url))
            vimeo(match[1])
          elsif (match = regex_slideshare.match(url))
            slideshare(match[1])
          elsif (match = regex_gist.match(url))
            gist(match[2])
          end
        end

        def set_classes(html, classes)
          doc = Nokogiri::HTML::DocumentFragment.parse(html)
          doc.child['class'] = classes.join(' ')
          doc.to_html
        end

        def youtube(id)
          '<div class="embed embed--youtube"><div class="video-wrapper">' \
          '<iframe width="640" height="360" frameborder="0" allowfullscreen' \
          " src=\"//www.youtube.com/embed/#{id}?rel=0\" ></iframe>" \
          '</div></div>'
        end

        def youtube_playlist(id)
          '<div class="embed embed--youtube"><div class="video-wrapper">' \
          '<iframe frameborder="0" allowfullscreen'\
          " src=\"//www.youtube.com/embed/videoseries?list=#{id}\" ></iframe>" \
          '</div></div>'
        end

        def vimeo(id)
          '<div class="embed embed--vimeo"><div class="video-wrapper">' \
          '<iframe width="500" height="281" frameborder="0"' \
          ' webkitallowfullscreen mozallowfullscreen allowfullscreen' \
          " src=\"//player.vimeo.com/video/#{id}\"></iframe>" \
          '</div></div>'
        end

        def slideshare(id)
          '<div style="width: 100%; height: 0px; position: relative; padding-bottom: 63%;">' \
          "<iframe src=\"https://www.slideshare.net/slideshow/embed_code/key/#{id}\"" \
          ' frameborder="0" allowfullscreen style="width: 100%; height: 100%; position: absolute;">' \
          '</iframe>'\
          '</div>'
        end

        def gist(id)
          '<div class="embed embed--gist">' \
          "<script src=\"//gist.github.com/#{id}.js\"></script>" \
          '</div>'
        end

        def baseurl
          @site_config['baseurl'] || ''
        end

        def asset_path
          @site_config['asset_path'] || ''
        end

        def link_sdk(url, title, content)

        end

        def regex_youtube_video
          %r{youtube\.com/(watch\?v=|v/|embed/)([a-z0-9A-Z\-_]*)}
        end

        def regex_youtube_playlist
          %r{^(https?://)?([w]{3}\.)?youtube\.com/playlist\?list=([a-z0-9A-Z\-]*)}
        end

        def regex_vimeo_video
          %r{vimeo.com/video/([0-9]+)}
        end

        def regex_slideshare
          %r{slideshare.net/slideshow/embed_code/key/([a-z0-9A-Z]*)}
        end

        def regex_gist
          %r{^(https?://)?gist.github\.com/(.*)}
        end

        def regex_button
          /^(.*)\ (&gt;|>)\{?([a-z,0-9\-]*)\}?$/
        end

        def regex_link_data
          /^(.*)\ (&gt;|>)\{([a-z\-_,:0-9A-Z]+)\}$/
        end

        def shortcode_to_platform(shortcode)
          platforms = {
            'CP' => 'cloudpebble',
            'LC' => 'local'
          }
          platforms[shortcode]
        end
      end
    end
  end
end

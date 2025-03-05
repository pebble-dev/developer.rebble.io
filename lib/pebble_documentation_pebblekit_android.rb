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

require 'zip'
require 'nokogiri'
require_relative 'pebble_documentation'

# TODO: Error handling.
# TODO: Introduce some DRY
# TODO: Fix the internal links!
# TODO: Bring back the summarys which I broke.
# TODO: Android Index Page

module Pebble
  class DocumentationPebbleKitAndroid < Documentation
    def initialize(site, source)
      super(site)
      @path = '/docs/pebblekit-android/'
      open(source) do | zf |
        Zip::File.open(zf.path) do | zipfile |
          entry = zipfile.glob('javadoc/index.html').first
          summary = Nokogiri::HTML(entry.get_input_stream.read)
          process_summary(zipfile, summary)

          @pages << PageDocPebbleKitAndroid.new(@site, @site.source, 'docs/pebblekit-android/com/constant-values/', 'Constant Values', process_html(Nokogiri::HTML(zipfile.glob('javadoc/constant-values.html').first.get_input_stream.read).at_css('.constantValuesContainer').to_html, '/docs/pebblekit-android/'), nil)
          @pages << PageDocPebbleKitAndroid.new(@site, @site.source, 'docs/pebblekit-android/com/serialized-form/', 'Serialized Form', process_html(Nokogiri::HTML(zipfile.glob('javadoc/serialized-form.html').first.get_input_stream.read).at_css('.serializedFormContainer').to_html, '/docs/pebblekit-android/'), nil)
        end
      end
    end

    private

    def language
      'pebblekit_android'
    end

    def process_summary(zipfile, summary)
      summary.css('tbody tr').each do | row |
        print(row)
        name = row.at_css('th.colFirst').content
        package = {
          name: name,
          url: "#{@path}#{name_to_url(name)}/",
          children: [],
          methods: [],
          enums: [],
          exceptions: [],
          path: [name]
        }
        add_symbol(name: name, url: "#{@path}#{name_to_url(name)}/")
        @tree << package
      end

      @tree.each do | package |
        entry = zipfile.glob("javadoc/#{name_to_url(package[:name])}/package-summary.html").first
        summary = Nokogiri::HTML(entry.get_input_stream.read)
        process_package(zipfile, package, summary)
      end
    end

    def process_package(zipfile, package, summary)
      url = "#{@path}#{name_to_url(package[:name])}"

      html = summary.at_css('.contentContainer').to_html
      html = process_html(html, url)

      @pages << PageDocPebbleKitAndroid.new(@site, @site.source, url, package[:name], html, package)

      class_table = summary.css('table[summary~="Class Summary"]')
      class_table.css('tbody tr').each do | row |
        name = row.at_css('td.colFirst').content
        package[:children] << {
          name: name,
          summary: row.at_css('.colLast').content,
          url: "#{url}/#{name}",
          path: package[:path].clone << name,
          type: 'class',
          children: [],
          methods: [],
          enums: [],
          exceptions: []
        }
        add_symbol(name: "#{package[:name]}.#{name}", url: "#{url}/#{name}")
      end

      enum_table = summary.css('table[summary~="Enum Summary"]')
      enum_table.css('tbody tr').each do | row |
        name = row.at_css('.colFirst').content
        package[:children] << {
          name: name,
          summary: row.at_css('.colLast').content,
          path: package[:path].clone << name,
          url: "#{url}/#{name}",
          type: 'enum',
          children: [],
          methods: [],
          enums: [],
          exceptions: []
        }
        add_symbol(name: "#{package[:name]}.#{name}", url: "#{url}/#{name}")
      end

      summary.css('table[summary~="Exception Summary"]').css('tbody tr').each do | row |
        name = row.at_css('td.colFirst').content
        package[:children] << {
          name: name,
          summary: row.at_css('.colLast').content,
          path: package[:path].clone << name,
          url: "#{url}/#{name}",
          type: 'exception',
          children: [],
          methods: [],
          enums: [],
          exceptions: []
        }
        add_symbol(name: "#{package[:name]}.#{name}", url: "#{url}/#{name}")
      end

      package[:children].each do | child |
        filename = "javadoc/#{name_to_url(package[:name])}/#{child[:name]}.html"
        child_url = '/docs/pebblekit-android/' + package[:name].split('.').join('/') + '/' + child[:name] + '/'

        entry = zipfile.glob(filename).first
        summary = Nokogiri::HTML(entry.get_input_stream.read)

        method_table = summary.css('table[summary~="Method Summary"]')
        method_table.css('tr').each do | row |
          next unless row.at_css('.memberNameLink')
          name = row.at_css('.memberNameLink').content
          child[:methods] << {
            name: name,
            summary: row.at_css('.block') ? row.at_css('.block').content : '',
            url: child_url + '#' + name,
            type: 'method'
          }
          add_symbol(name: [package[:name], child[:name], name].join('.'), url: child_url + '#' + name)
        end
        html = summary.at_css('.contentContainer').to_html
        html = process_html(html, child_url)
        @pages << PageDocPebbleKitAndroid.new(@site, @site.source, child_url, child[:name], html, child)
      end
    end

    def name_to_url(name)
      name.split('.').join('/')
    end

    def process_html(html, root)
      contents = Nokogiri::HTML(html)
      contents.css('a').each do | link |
        next if link['href'].nil?
        href =  File.expand_path(link['href'], root)
        href = href.sub('/com/com/', '/com/')
        href = href.sub('.html', '/')
        link['href'] = href
      end
      contents.css('.memberSummary caption').remove
      contents.to_html
    end
  end

  class PageDocPebbleKitAndroid < Jekyll::Page
    def initialize(site, base, dir, title, contents, group)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      @contents = contents
      @group = group

      process(@name)
      read_yaml(File.join(base, '_layouts', 'docs'), 'pebblekit-android.html')
      data['title'] = title.to_s
    end

    def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
      super(attrs + %w(
        contents
        group
      ))
    end

    attr_reader :contents

    def group
      if @group.nil?
        {}
      else
        JSON.parse(JSON.dump(@group))
      end
    end
  end
end

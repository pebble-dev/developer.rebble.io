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
      File.open(source) do |zf|
        Zip::File.open(zf.path) do |zipfile|
          entry = zipfile.glob('javadoc/index.html').first
          summary = Nokogiri::HTML(entry.get_input_stream.read)
          process_summary(zipfile, summary)

          @pages << PageDocPebbleKitAndroid.new(
            @site,
            'docs/pebblekit-android/com/constant-values/',
            'Constant Values',
            process_html(
              Nokogiri::HTML(zipfile.glob('javadoc/constant-values.html').first.get_input_stream.read)
                .at_css('.constants-summary')
                .to_html,
              '/docs/pebblekit-android/'
            ),
            nil
          )

          @pages << PageDocPebbleKitAndroid.new(
            @site,
            'docs/pebblekit-android/com/serialized-form/',
            'Serialized Form',
            process_html(
              Nokogiri::HTML(zipfile.glob('javadoc/serialized-form.html').first.get_input_stream.read)
                .at_css('.serialized-package-container')
                .to_html,
              '/docs/pebblekit-android/'
            ),
            nil
          )
        end
      end
    end

    private

    def language
      'pebblekit_android'
    end

    def process_summary(zipfile, summary)
      summary.css('.summary-table .col-first.all-packages-table').each do |row|
        name = row.content
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

      @tree.each do |package|
        entry = zipfile.glob("javadoc/#{name_to_url(package[:name])}/package-summary.html").first
        summary = Nokogiri::HTML(entry.get_input_stream.read)
        process_package(zipfile, package, summary)
      end
    end

    def find_table(html, name)
      button = html.at_xpath("//button[text()=\"#{name}\"]")
      return [] unless button

      selector = button['id']
      html.css(".col-first.#{selector}").zip(html.css(".col-last.#{selector}"))
    end

    def process_package(zipfile, package, summary)
      url = "#{@path}#{name_to_url(package[:name])}"

      html = summary.at_css('#class-summary').to_html
      html = process_html(html, url, is_package: true)

      @pages << PageDocPebbleKitAndroid.new(@site, url, package[:name], html, package)

      find_table(summary, 'Classes').each do |row|
        name = row[0].content
        package[:children] << {
          name: name,
          summary: row[1].content,
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

      find_table(summary, 'Enum Classes').each do |row|
        name = row[0].content
        package[:children] << {
          name: name,
          summary: row[1].content,
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

      find_table(summary, 'Exceptions').each do |row|
        name = row[0].content
        package[:children] << {
          name: name,
          summary: row[1].content,
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

      package[:children].each do |child|
        child_path = "#{name_to_url(package[:name])}/#{child[:name]}"
        filename = "javadoc/#{child_path}.html"
        child_url = "/docs/pebblekit-android/#{child_path}/"

        entry = zipfile.glob(filename).first
        summary = Nokogiri::HTML(entry.get_input_stream.read)

        method_rows = summary.css('#method-summary-table .summary-table')
        method_table =
          method_rows.css('.col-second:not(.table-header)').zip(method_rows.css('.col-last:not(.table-header)'))

        method_table.each do |row|
          link = row[0].at_css('.member-name-link')
          next unless link

          name = link.content
          description = row[1].at_css('.block')
          child[:methods] << {
            name: name,
            summary: description ? description.content : '',
            url: "#{child_url}##{name}",
            type: 'method'
          }
          add_symbol(name: "#{package[:name]}.#{child[:name]}.#{name}", url: "#{child_url}##{name}")
        end
        html = summary.at_css('main')
        html.children.each do |node|
          node.remove if node.classes.include?('header')
        end
        html = process_html(html.to_html, child_url)
        @pages << PageDocPebbleKitAndroid.new(@site, child_url, child[:name], html, child)
      end
    end

    def name_to_url(name)
      name.split('.').join('/')
    end

    def process_html(html, root, is_package: false)
      contents = Nokogiri::HTML(html)
      contents.css('a').each do |link|
        href = link['href']
        next if href.nil?

        unless href.start_with?('https://')
          href = "../#{href}" unless is_package or href.start_with?('#')
          href = File.expand_path(href, root)
                     .sub('/com/com/', '/com/')
                     .sub('.html', '/')
        end
        link['href'] = href
      end
      contents.css('.memberSummary caption').remove
      contents.to_html
    end
  end

  class PageDocPebbleKitAndroid < Jekyll::Page
    def initialize(site, dir, title, contents, group)
      @site = site
      @base = site.source
      @dir = dir
      @name = 'index.html'
      @contents = contents
      @group = group

      process(@name)
      read_yaml(File.join(@base, '_layouts', 'docs'), 'pebblekit-android.html')
      data['title'] = title.to_s
    end

    def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
      super(attrs + %w[
        contents
        group
      ])
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

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

module Pebble
  # Rock.js documentation processing class.
  class DocumentationJs < Documentation

    def initialize(site, source, root, language, preview = false)
      super(site)
      @url_root = root
      @language = language
      @preview = preview
      json = site.data[source]
      json.each { |js_module| process_module(js_module) }
    end

    private

    def process_module(js_module)
      js_module[:path] = js_module['name']
      js_module[:url] = module_url(js_module)
      js_module[:processed_functions] = []
      js_module[:processed_members] = []
      js_module[:processed_typedefs] = []
      js_module[:children] = []

      process_members(js_module)
      add_to_tree(js_module)

      # Create and add the page
      page =  PageDocJS.new(@site, module_url(js_module), js_module)
      page.set_data(@language, @preview)
      @pages << page
    end

    def process_members(js_module)
      js_module['members'].each do |type, members|
        members.each do |member|

          kind = member.key?('kind') ? member['kind'] : 'member'
          processed_type = 'processed_' + kind + 's'
          url = child_url(js_module, member)

          symbol = {
            :name => member['name'],
            :description => member['description'],
            :type => member['type'],
            :returns => member['returns'],
            :params => member['params'],
            :properties => member['properties'],
            :url => url,
            :kind => kind,
            :summary => member['memberof']
          }
          add_symbol(symbol)
          js_module[:children].push(symbol)
          js_module[processed_type.to_sym].push(symbol)
        end
      end
    end

    def add_to_tree(js_module)
      @tree << js_module
    end

    def module_url(js_module)
      "#{@url_root}#{js_module['name']}/"
    end

    def child_url(js_module, child)
      "#{module_url(js_module)}##{child['name']}"
    end

    def child_path(js_module, child)
      [js_module['name'], child['name']].join('.')
    end

    def language
      @language
    end
  end

  # Jekyll Page subclass for rendering the JS documentation pages.
  class PageDocJS < Jekyll::Page
    attr_reader :js_module

    def initialize(site, url, js_module)
      @site = site
      @base = site.source
      @dir = url
      @name = 'index.html'
      @js_module = JSON.parse(js_module.to_json)
      process(@name)
      read_yaml(File.join(@base, '_layouts', 'docs'), 'js.html')
      data['title'] = js_module['name']
    end

    def set_data(language, preview)
      data['docs_language'] = language
      data['preview'] = preview
    end

    def to_liquid(attrs = ATTRIBUTES_FOR_LIQUID)
      super(attrs + %w(js_module))
    end
  end
end

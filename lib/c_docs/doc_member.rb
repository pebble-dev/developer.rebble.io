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

require_relative 'doc_enum_value.rb'

module Pebble
  # A DocMember is a function, enum, typedef that will become a symbol
  # and be a part of a documentation page. Belongs to a DocGroup.
  class DocMember < DocElement
    attr_accessor :children, :kind, :name, :summary, :children, :position, :data, :id

    def initialize(root, node, group, platform)
      super(root, platform)
      @group     = group
      @children  = []
      @platforms = [platform]
      @nodes     = { platform => node }
      @name      = node.at_css('name').content.to_s
      @kind      = node['kind']
      @id        = node['id']
      @path      = "#{@group.path}##{@name}"
      @position  = node.at_css(' > location')['line'].to_i
      @doxygen_processor = DoxygenProcessor.new(platform)
      create_enum_values(node, platform) if @kind == 'enum'
    end

    def add_platform(platform, node)
      @platforms      << platform
      @nodes[platform] = node
      @data[platform]  = {}
      create_enum_values(node, platform) if @kind == 'enum'
    end

    def to_liquid
      {
        'name'      => @name,
        'url'       => url,
        'children'  => @children,
        'position'  => @position,
        'data'      => @data,
        'uniform'   => uniform?,
        'platforms' => @platforms
      }
    end

    def process(mapping, platform)
      return unless @platforms.include? platform
      @data[platform]['summary'] = @doxygen_processor.process_summary(
        @nodes[platform].at_css(' > briefdescription'), mapping
      )
      process_data(@nodes[platform], mapping, platform)
      @data[platform]['description'] = @doxygen_processor.process_description(
        @nodes[platform].at_css(' > detaileddescription'), mapping
      )
      @children.each { |child| child.process(mapping, platform) }
    end

    def uniform?
      identical = data['aplite'].to_json == data['basalt'].to_json
      identical &&= children.all?(&:uniform?) if @kind == 'enum'
      identical
    end

    private

    def create_enum_values(node, platform)
      node.css('enumvalue').each do |value|
        enum_value = DocEnumValue.new(@root, value, @group, platform)
        existing_value = @children.select { |ev| ev.name == enum_value.name }.first
        if existing_value.nil?
          @children << enum_value
        else
          existing_value.add_platform(value, platform)
        end
      end
    end

    def process_data(node, mapping, platform)
      process_typedef(node, mapping, platform) if @kind == 'typedef'
      process_function(node, mapping, platform) if @kind == 'function'
      process_define(node, mapping, platform) if @kind == 'define'
      process_simplesects(node, mapping, platform)
    end

    def process_typedef(node, mapping, platform)
      process_return_type(node, mapping, platform)
      argsstring = node.at_css('argsstring')
      if argsstring == nil then
        @data[platform]['argsstring'] = ""
      else
        @data[platform]['argsstring'] = argsstring.content.to_s
      end
      process_parameter_list(node, mapping, platform)
    end

    def process_function(node, mapping, platform)
      process_return_type(node, mapping, platform)
      process_params(node, mapping, platform) unless node.css('param').nil?
      process_parameter_list(node, mapping, platform)
    end

    def process_define(node, mapping, platform)
      unless node.at_css('initializer').nil?
        @data[platform]['initializer'] = process_to_html(
          node.at_css('initializer'), mapping
        )
      end
      process_return_type(node, mapping, platform)
      process_parameter_list(node, mapping, platform)
      process_params(node, mapping, platform) unless node.css('param').nil?
    end

    def process_return_type(node, mapping, platform)
      @data[platform]['type'] = process_to_html(node.at_css('> type'), mapping)
    end

    def process_params(node, mapping, platform)
      @data[platform]['params'] = node.css('param').map do |elem|
        params = {}
        unless elem.at_css('declname').nil?
          params['name'] = elem.at_css('declname').content.to_s
        end
        unless elem.at_css('type').nil?
          params['type'] = process_to_html(elem.at_css('type'), mapping)
        end
        unless elem.at_css('defname').nil?
          params['name'] = elem.at_css('defname').content.to_s
        end
        params
      end
    end

    def process_to_html(node, mapping)
      return '' if node.nil?
      node.css('ref').each do |ref|
        @doxygen_processor.process_node_ref(ref, mapping)
      end
      node.inner_html.to_s
    end

    def process_parameter_list(node, mapping, platform)
      return if node.at_css('parameterlist').nil?
      parameter_list = node.at_css('parameterlist').clone
      node.at_css('parameterlist').remove
      @data[platform]['parameters'] = parameter_list.css('parameteritem').map do |item|
        {
          'name' => get_parameter_name(item),
          'summary' => @doxygen_processor.process_summary(item.at_css('parameterdescription'), mapping)
        }
      end
    end

    def get_parameter_name(item)
      name = item.at_css('parameternamelist > parametername')
      direction = name.attr('direction').to_s
      direction.nil? || direction == '' ? name.content.to_s : "#{name.content.to_s} (#{direction})"
    end
  end
end

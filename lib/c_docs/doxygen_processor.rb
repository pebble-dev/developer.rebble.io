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

module Pebble
  # Class of methods for processing Doxygen XML into 'sane' HTML.
  # rubocop:disable Metrics/ClassLength
  class DoxygenProcessor
    def initialize(platform)
      @platform = platform
    end

    def process_summary(node, mapping)
      process_description(node, mapping)
    end

    def process_description(node, mapping)
      return '' if node.nil?
      node.children.map { |para| process_paragraph(para, mapping) }.join("\n").strip
    end

    # rubocop:disable Metrics/MethodLength, Methods/CyclomaticComplexity
    # rubocop:disable Methods/AbcSize
    def process_paragraph(node, mapping)
      return '' if node.nil?
      node.name = 'p'
      node.children.each do |child|
        case child.name
        when 'ref'
          process_node_ref(child, mapping)
        when 'programlisting'
          process_code(child)
        when 'simplesect'
          # puts node.content.to_s
          # process_blockquote(child)
        when 'heading'
          process_node_heading(child)
        when 'htmlonly'
          process_node_htmlonly(child)
        when 'itemizedlist'
          process_list(child, mapping)
        when 'image'
          process_image(child)
        when 'computeroutput'
          process_computer_output(child)
        when 'emphasis'
          child.name = 'em'
        when 'bold'
          child.name = 'strong'
        when 'linebreak'
          child.name = 'br'
        when 'preformatted'
          child.name = 'pre'
        when 'ndash'
          child.name = 'span'
          child.content = '-'
        when 'ulink'
          child.name = 'a'
          child['href'] = child['url'].sub(%r{^https?://developer.rebble.io/}, '/')
          child.remove_attribute('url')
        when 'text'
          # SKIP!
        else
          # puts child.name, node.content.to_s
        end
      end
      node.to_html.to_s.strip
    end
    # rubocop:enable Metrics/MethodLength, Methods/CyclomaticComplexity
    # rubocop:enable Methods/AbcSize

    def process_code(node)
      xml = node.to_xml.gsub('<sp/>', ' ')
      doc  = Nokogiri::XML(xml)
      highlight = Pygments.highlight(doc.content.to_s.strip, lexer: 'c')
      node.content = ''
      node << Nokogiri::XML(highlight).at_css('pre')
      node.name = 'div'
      node['class'] = 'highlight'
    end

    def process_node_ref(child, mapping)
      child.name = 'a'
      map = mapping.select { |m| m[:id] == child['refid'] }.first
      child['href'] = map[:url] unless map.nil?
    end

    def process_node_heading(node)
      node.name = 'h' + node['level']
    end

    def process_node_htmlonly(node)
      decoder = HTMLEntities.new
      xml = Nokogiri::XML('<root>' + decoder.decode(node.content) + '</root>')
      node_count = xml.root.children.size
      process_node_htmlonly_simple(node, xml) if node_count == 2
      process_node_htmlonly_complex(node, xml) if node_count > 2
    end

    def process_node_htmlonly_simple(node, xml)
      child = xml.at_css('root').children[0]
      node.name = child.name
      child.attributes.each { |key, value| node[key] = value }
      node.content = child.content
    end

    def process_node_htmlonly_complex(node, xml)
      node.name = 'div'
      node.content = ''
      node << xml.root.children
    end

    def process_blockquote(node)
      node.name = 'blockquote'
      node['class'] = 'blockquote--' + node['kind']
      process_paragraph(node.children[0]) if node.children[0].name == 'para'
      node.to_html.to_s
    end

    def process_list(node, mapping)
      node.name = 'ul'
      node.children.each do |child|
        process_list_item(child, mapping)
      end
    end

    def process_list_item(node, mapping)
      node.name = 'li'
      node.children.each do |child|
        process_paragraph(child, mapping) if child.name == 'para'
      end
    end

    def process_image(node)
      node.name = 'img'
      node['src'] = "/assets/images/docs/c/#{@platform}/#{node['name']}"
    end

    def process_computer_output(node)
      node.name = 'code'
    end
  end
  # rubocop:enable Metrics/ClassLength
end

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

require_relative '../lib/toc_generator'

module Jekyll

  class Document

    include Convertible

    alias_method :parent_to_liquid, :to_liquid

    def to_liquid
      parent_to_liquid
      # Utils.deep_merge_hashes parent_to_liquid, {
      #   'toc' => toc,
      #   'related_docs' => related_docs
      # }
    end

    private

    def toc
      unless @toc
        generate_toc if data['generate_toc']
      end
      (@toc.nil? || @toc.empty?) ? nil : @toc
    end

    def related_docs
      # Skip the warning, we don't want docs or links to them
      if !@site.config['skip_docs'].nil? && (@site.config['skip_docs'] == 'true')
        return
      end

      return nil if data['related_docs'].nil?

      docs = data['related_docs'].map do | doc |
        # Use existing doc data if it exists
        if !doc.nil? and doc.is_a?(Hash) and doc.has_key?("name") and doc.has_key?("url")
          doc
        else
          # use nil if data is formated in an unexpected way
          if doc.nil? or !doc.is_a? String
            next
          else
            # Otherwise search for the symbol
            symbol = @site.config[:docs][:symbols].find do |symbol|
              symbol[:name].downcase == doc.downcase
            end

            if symbol.nil?
              Jekyll.logger.warn "Related Warning:", "Could not find symbol '#{doc}' in '#{data['title']}'"
              next
            else
              {
                'name' => symbol[:name],
                'url' => symbol[:url],
              }
            end
          end
        end
      end

    end

    def generate_toc
      generator = Pebble::TocGenerator.new(data['toc_max_depth'] || -1)
      @toc = generator.generate(content)
    end

  end

end

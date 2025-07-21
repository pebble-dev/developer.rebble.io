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

require 'htmlentities'
require 'slugize'
require 'dotenv'

module Jekyll

  class GeneratorGuides < Generator

    priority :highest

    def initialize(config)
    end

    def generate(site)
      @site = site
      site.collections['guides'].docs.each do |guide|
        group = find_group(guide)
        subgroup = find_subgroup(guide, group)
        guide.data['group_data'] = group
        guide.data['subgroup_data'] = subgroup
        unless subgroup.nil?
          subgroup['guides'] << {
            'title' => guide.data['title'],
            'url' => guide.url,
            'menu' => guide.data['menu'],
            'order' => guide.data['order'],
            'summary' => guide.data['description']
          }
        else
          unless group.nil?
            group['guides'] << {
              'title' => guide.data['title'],
              'url' => guide.url,
              'menu' => guide.data['menu'],
              'order' => guide.data['order'],
              'summary' => guide.data['description']
            }
          end
        end
      end

      site.data['guides'] = [] if site.data['guides'].nil?

      site.data['guides'].each do |id, group|
        group['url'] = "/guides/#{id}/"
        if group['subgroups'].nil?
          group['subgroups'] = []
          next
        end
        group['subgroups'].each do |id, subgroup|
          subgroup['url'] = "#{group['url']}#{id}/"
        end
      end
    end

    def find_group(guide)
      @site.data['guides'].each do |id, group|
        if id == guide.data['guide_group']
          group['guides'] = [] if group['guides'].nil?
          return group
        end
      end
      nil
    end

    def find_subgroup(guide, group)
      return if group.nil? || group['subgroups'].nil?
      group['subgroups'].each do |id, subgroup|
        if id == guide.data['guide_subgroup']
          subgroup['guides'] = [] if subgroup['guides'].nil?
          return subgroup
        end
      end
      nil
    end

  end

end

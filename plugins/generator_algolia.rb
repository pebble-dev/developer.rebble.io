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
require 'algolia'
require 'slugize'
require 'dotenv'
require 'securerandom'

module Jekyll
  class GeneratorAlgolia < Generator
    # Do this last so everything else has been processed already.
    priority :lowest

    def initialize(_config)
      Dotenv.load
    end

    def generate(site)
      @site = site
      config = get_config
      return unless config

      @prefix = config['prefix']
      @random_code = random_code
      @client = Algolia::SearchClient.create(config['app_id'], config['api_key'])

      setup_indexes
      generate_all
    end

    private

    def env_var_defined?(var)
      @site.config[var].nil? || @site.config[var].empty?
    end

    def get_config
      if env_var_defined?('algolia_app_id')
        Jekyll.logger.warn(
          'Config Warning:',
          'You did not provide a ALGOLIA_APP_ID environment variable. Skipping search index generation.'
        )
        return nil
      end
      if env_var_defined?('algolia_api_key')
        Jekyll.logger.warn(
          'Config Warning:',
          'You did not provide a ALGOLIA_API_KEY environment variable. Skipping search index generation.'
        )
        return nil
      end
      if env_var_defined?('algolia_prefix')
        Jekyll.logger.warn(
          'Config Warning:',
          'You did not provide a ALGOLIA_PREFIX environment variable. Skipping search index generation.'
        )
        return nil
      end

      {
        'app_id' => @site.config['algolia_app_id'],
        'api_key' => @site.config['algolia_api_key'],
        'prefix' => @site.config['algolia_prefix']
      }
    end

    def generate_all
      requests = [].concat(generate_blog_posts,
                           generate_guides,
                           generate_documentation,
                           generate_none_guide_guides,
                           generate_other).compact

      @client.multiple_batch(
        Algolia::Search::BatchParams.new(requests: requests)
      )
    end

    def random_code
      SecureRandom.hex
    end

    def setup_indexes
      @site.data['search_indexes'].each do |name, properties|
        unless properties['settings'].nil?
          @client.set_settings("#{@prefix}#{name}", Algolia::Search::IndexSettings.new(properties['settings']))
        end
      end
    end

    def generate_documentation
      return [] if @site.data['docs'].nil?

      @site.data['docs'][:symbols].map do |item|
        next if item[:language] == 'c_preview'

        if item[:summary].nil? || item[:summary].strip.empty?
          Jekyll.logger.warn(
            'Search Warning:',
            "There was no summary for the symbol '#{item[:name]}' in #{item[:language]}."
          )
        end

        Algolia::Search::MultipleBatchRequest.new(
          action: 'addObject',
          index_name: "#{@prefix}documentation",
          body: {
            'objectID' => item[:url],
            'title' => item[:name],
            'splitTitle' => item[:name].split(/(?=[A-Z])/).join(' '),
            'url' => item[:url],
            'summary' => item[:summary],
            'kind' => item[:kind],
            'language' => item[:language],
            'type' => 'documentation',
            'ranking' => doc_language_rank[item[:language]] * 1000,
            'randomCode' => @random_code
          }
        )
      end.compact
    end

    def generate_blog_posts
      @site.posts.docs.flat_map do |post|
        # Calculate the age of the post so we can prioritise newer posts
        # over older ones.
        # NOTE: post.date is actually a Time object, despite its name
        age = (Time.now - post.date).round
        author = post.data['author']

        post.get_sections.map do |section|
          # Ignore sections without any contents.
          next if section[:contents].strip.empty?

          url = section[:title].nil? ? post.url : "#{post.url}##{section[:title].slugize}"

          Algolia::Search::MultipleBatchRequest.new(
            action: 'addObject',
            index_name: "#{@prefix}blog-posts",
            body: {
              'objectID' => url,
              'title' => post.data['title'],
              'sectionTitle' => section[:title],
              'url' => url,
              'urlDisplay' => post.url,
              'author' => author,
              'content' => HTMLEntities.new.decode(section[:contents]),
              'posted' => post.date,
              'age' => age,
              'type' => 'blog post',
              'randomCode' => @random_code
            }
          )
        end
      end
    end

    def generate_guides
      return [] if @site.collections['guides'].nil?

      @site.collections['guides'].docs.flat_map do |guide|
        group = @site.data['guides'][guide.data['guide_group']]
        unless group.nil? || group['subgroups'].nil? || guide.data['guide_subgroup'].nil?
          subgroup = group.nil? ? '' : group['subgroups'][guide.data['guide_subgroup']]
        end

        guide.get_sections.map do |section|
          url = section[:title].nil? ? guide.url : "#{guide.url}##{section[:title].slugize}"

          Algolia::Search::MultipleBatchRequest.new(
            action: 'addObject',
            index_name: "#{@prefix}guides",
            body: {
              'objectID' => url,
              'title' => guide.data['title'],
              'sectionTitle' => section[:title],
              'url' => url,
              'urlDisplay' => guide.url,
              'content' => HTMLEntities.new.decode(section[:contents]),
              'group' => group.nil? ? '' : group['title'],
              'subgroup' => subgroup.nil? ? '' : subgroup['title'],
              'type' => 'guide',
              'randomCode' => @random_code
            }
          )
        end
      end
    end

    def generate_none_guide_guides
      gs_pages = @site.pages.select { |page| page.data['search_index'] }

      gs_pages.flat_map do |page|
        page.get_sections.map do |section|
          url = section[:title].nil? ? page.url : "#{page.url}##{section[:title].slugize}"

          Algolia::Search::MultipleBatchRequest.new(
            action: 'addObject',
            index_name: "#{@prefix}guides",
            body: {
              'objectID' => url,
              'title' => page.data['title'],
              'sectionTitle' => section[:title],
              'url' => url,
              'urlDisplay' => page.url,
              'content' => HTMLEntities.new.decode(section[:contents]),
              'group' => page.data['search_group'],
              'subgroup' => page.data['sub_group'],
              'type' => 'not-guide',
              'randomCode' => @random_code
            }
          )
        end
      end
    end

    def generate_other
      @site.data['search-other'].map do |other|
        Algolia::Search::MultipleBatchRequest.new(
          action: 'addObject',
          index_name: "#{@prefix}other",
          body: {
            'objectID' => other['id'],
            'title' => other['title'],
            'url' => other['url'],
            'content' => other['description'],
            'randomCode' => @random_code
          }
        )
      end
    end

    def doc_language_rank
      {
        'c' => 10,
        'rockyjs' => 9,
        'pebblekit_js' => 8,
        'pebblekit_android' => 6,
        'pebblekit_ios' => 4
      }
    end
  end
end

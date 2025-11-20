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

module Jekyll
  class GeneratorRedirects < Generator
    priority :lowest

    def initialize(config) end

    def generate(site)
      @site = site
      site.data['redirects'].each do |redirect|
        if infinite_redirect?(redirect[0], redirect[1])
          Jekyll.logger.warn 'Redirect Warning:', "Skipping redirect of #{redirect[0]} to #{redirect[1]}"
          next
        end
        @site.pages <<
          RedirectPage.new(@site, @site.source, File.dirname(redirect[0]), File.basename(redirect[0]), redirect[1])
      end

      # Generate redirects for the old URLs under the /developer.pebble.com/ subpath to new, subpath-less location
      site.pages.dup.reject { |page| page.url.start_with?('/assets/') }.each(&method(:create_old_path_redirect))
      site.collections.flat_map { |collection| collection[1].docs }.each(&method(:create_old_path_redirect))
    end

    private

    # Returns true if the redirect pair (from, to) will cause an infinite
    # redirect.
    def infinite_redirect?(from, to)
      return true if from == to

      return true if File.basename(from) == 'index.html' && File.dirname(from) == File.dirname("#{to}index.html")

      false
    end

    def create_old_path_redirect(page)
      if page.url.end_with?('/')
        @site.pages <<
          RedirectPage.new(@site, @site.source, "/developer.pebble.com#{page.url}", 'index.html', page.url)
        @site.pages <<
          RedirectPage.new(@site, @site.source, "/developer.getpebble.com#{page.url}", 'index.html', page.url)
      else
        @site.pages <<
          RedirectPage.new(@site, @site.source, File.dirname("/developer.pebble.com#{page.url}"), File.basename(page.url), page.url)
        @site.pages <<
          RedirectPage.new(@site, @site.source, File.dirname("/developer.getpebble.com#{page.url}"), File.basename(page.url), page.url)
      end
    end
  end

  class RedirectPage < Page
    def initialize(site, base, dir, name, redirect_to)
      @site = site
      @base = base
      @dir = dir
      @name = name.empty? ? 'index.html' : name

      process(@name)
      read_yaml(File.join(base, '_layouts', 'utils'), 'redirect_permanent.html')
      data['redirect_to'] = redirect_to.delete_suffix('index.html')
      data['sitemap'] = false
    end
  end
end

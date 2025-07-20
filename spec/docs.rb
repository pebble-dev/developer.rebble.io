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

require 'open-uri'
require 'jekyll'

shared_context 'docs' do
  before {
    skip('Docs generation disabled') if ENV['SKIP_DOCS'] == 'true'
  }

  def load_config
    config = File.join(File.dirname(__FILE__), '../source/_data/docs.yaml')
    YAML.load(File.read(config))
  end

  def valid_branch(branch)
    expect(branch[:name]).to respond_to(:to_s)
    expect(branch[:url]).to respond_to(:to_s)
    expect(branch[:children]).to respond_to(:to_a)
    branch[:children].to_a.each { |child| valid_branch(child) }
  end

  def valid_branch2(branch)
    expect(branch[:name]).to respond_to(:to_s)
    expect(branch[:url]).to respond_to(:to_s)
    expect(branch[:children]).to respond_to(:to_a)
    branch[:children].to_a.each { |child| valid_branch2(child) }
  end

  # rubocop:disable Metrics/MethodLength
  def fake_site
    config = Jekyll::Configuration::DEFAULTS.dup
    config['source'] = './source/'
    Jekyll::Site.new(config)
  end
  # rubocop:enable Metrics/MethodLength

  # Iterate through all of the symbols and make sure that there is no other
  # symbol with the same name.
  def clashing_symbols(symbols)
    symbols.any? do |symbol|
      symbols.any? do |sym|
        return false if sym == symbol
        return true if sym[:name] == symbol[:name] || sym[:url] == symbol[:url]
        false
      end
    end
  end

  # Iterate through all of symbols and make sure that we have a matching
  # page that the symbol is linking to.
  def symbol_to_page_completeness(symbols, pages)
    symbols.each do |symbol|
      file = symbol[:url][/^([^#]*)/].gsub('%2B', '+')
      has_page = pages.any? do |page|
        page.url == file || page.url == File.join(file, 'index.html') || page.url == file + '/'
      end
      expect(has_page).to be true
    end
  end

  def find_symbol(symbols, name)
    symbols.index { |symbol| symbol[:name] == name }
  end
end

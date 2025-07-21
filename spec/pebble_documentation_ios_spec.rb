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

require_relative './spec_helper'
require 'jekyll'
require_relative '../lib/pebble_documentation'
require_relative '../lib/pebble_documentation_pebblekit_ios'

require_relative './docs'

describe Pebble::DocumentationPebbleKitIos do
  include_context 'docs'

  before do
    @docs_config = load_config
    @site = fake_site
    allow(File).to receive(:read).and_return('')
    source = ENV['DOCS_URL'] + @docs_config['pebblekit_ios']
    @doc = Pebble::DocumentationPebbleKitIos.new(@site, source, '/docs/pebblekit-ios/')
  end

  describe '#load_symbols' do
    before do
      @symbols = []
      @doc.load_symbols(@symbols)
    end

    xit 'should add symbols to the list' do
      expect(@symbols.size).to be > 0
    end

    xit 'should contain some known symbols' do
      symbols = [
        'pb_pebbleDictionaryData:',
        'isMobileAppInstalled',
        'PBWatch',
        'dataLoggingService:hasSInt8s:numberOfItems:forDataLoggingSession:'
      ]
      symbols.each { |name| expect(find_symbol(@symbols, name)).to_not be(nil) }
    end

    xit 'should tag all symbols with the correct language' do
      expect(@symbols.any? { |symbol| symbol[:language] != 'pebblekit_ios' }).to be(false)
    end

    xit 'should create symbols with correct URLS' do
      wrong_prefix = @symbols.any? do |symbol|
        !symbol[:url].start_with?('/docs/pebblekit-ios/')
      end
      expect(wrong_prefix).to be(false)
    end

    xit 'should not create two symbols that clash'

    xit 'should trim whitespace from summary' do
      not_trimmed = @symbols.any? do |symbol|
        !symbol[:summary].nil? && symbol[:summary].strip != symbol[:summary]
      end

      expect(not_trimmed).to be(false)
    end

    xit 'should URLencode the symbol URLS' do
      bad_urls = @symbols.any? do |symbol|
        symbol[:url].include?('+')
      end
      expect(bad_urls).to be(false)
    end
  end

  describe '#create_pages' do
    before do
      @pages = []
      @doc.create_pages(@pages)
    end

    xit 'should add some pages to the list' do
      expect(@pages.size).to be > 0
    end

    xit 'should create pages with contents and group exposed' do
      page = @pages[0]
      expect(page.contents).to_not be(nil)
      expect(page.group).to_not be(nil)
    end
  end

  describe '#build_tree' do
    before do
      @tree = []
      @doc.build_tree(@tree)
    end

    xit 'should populate the tree' do
      expect(@tree.size).to be > 0
    end

    xit 'should create tree objects formatted properly' do
      @tree.each { |branch| valid_branch(branch) }
    end
  end

  describe 'completeness' do
    before do
      @tree = []
      @symbols = []
      @pages = []
      @doc.build_tree(@tree)
      @doc.create_pages(@pages)
      @doc.load_symbols(@symbols)
    end

    xit 'should have a page for every symbol' do
      symbol_to_page_completeness(@symbols, @pages)
    end
  end
end

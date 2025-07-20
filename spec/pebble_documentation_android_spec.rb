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
require_relative '../lib/pebble_documentation_pebblekit_android'

require_relative './docs'

describe Pebble::DocumentationPebbleKitAndroid do
  include_context 'docs'

  before do
    @docs_config = load_config
    @site = fake_site
    allow(File).to receive(:read).and_return('')
    source = ENV['DOCS_URL'] + @docs_config['pebblekit_android']
    @doc = Pebble::DocumentationPebbleKitAndroid.new(@site, source)
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
      symbols = %w(
        com.getpebble.android.kit.Constants
        com.getpebble.android.kit.PebbleKit.registerReceivedDataHandler
        com.getpebble.android.kit.util.PebbleDictionary.remove
      )
      symbols.each { |name| expect(find_symbol(@symbols, name)).to_not be(nil) }
    end

    xit 'should tag all symbols with the correct language' do
      expect(@symbols.any? { |symbol| symbol[:language] != 'pebblekit_android' })
        .to be(false)
    end

    xit 'should create symbols with correct URLS' do
      wrong_prefix = @symbols.any? do |symbol|
        !symbol[:url].start_with?('/docs/pebblekit-android/')
      end
      expect(wrong_prefix).to be(false)
    end

    xit 'should not create two symbols that clash' do
      expect(clashing_symbols(@symbols)).to be false
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

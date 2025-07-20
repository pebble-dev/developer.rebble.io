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

require 'uglifier'
require 'digest'

module Jekyll
  # Jekyll Generator for concatenating and minifying JS for production site
  class GeneratorMinifyJS < Generator
    priority :highest

    def initialize(_)
    end

    def generate(site)
      return if Jekyll.env == 'development'

      @site = site
      @tmp_dir = File.join(site.source, '../tmp/')
      @js_dir = 'assets/js/'
      @tmp_js_dir = File.join(@tmp_dir, @js_dir)
      libs_js = uglify_libs
      libs_md5 = Digest::MD5.hexdigest(libs_js)
      @site.data['js']['lib_hash'] = libs_md5
      create_libs_js(libs_js, libs_md5)
    end

    private

    def uglify_libs
      ugly_libs = []
      @site.data['js']['libs'].each do |lib|
        lib_path = File.join(@site.source, 'assets', lib['path'])
        ugly_libs << Uglifier.compile(File.read(lib_path))
      end
      ugly_libs.join("\n\n")
    end

    def create_libs_js(js, md5)
      FileUtils.mkdir_p(@tmp_js_dir)
      File.open(File.join(@tmp_js_dir, "libs-#{md5}.js"), 'w') do |f|
        f.write(js)
      end
      @site.static_files << Jekyll::StaticFile.new(@site, @tmp_dir, @js_dir,
                                                   "libs-#{md5}.js")
    end
  end
end

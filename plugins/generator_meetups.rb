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

require 'googlestaticmap'

module Jekyll
  class GeneratorMeetups < Generator
    def initialize(config)
    end

    def generate(site)
      @site = site
      print("HIIIIIIIIIIIIIIIIII\n")
      map = GoogleStaticMap.new(:api_key => site.config['google_maps'], :width => 700, :height => 500)
      site.data['meetups'].each do |meetup|
        map.markers << MapMarker.new(:color => "0x9D49D5FF",
                                     :location => MapLocation.new(:latitude => meetup['pin']['latitude'],
                                                                  :longitude => meetup['pin']['longitude']
                                     )
        )
      end
      @site.data['meetups_map_url'] = map.url(:auto)
    end
  end
end

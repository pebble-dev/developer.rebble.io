---
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

title: Getting Started with Pebble Time Round
description: |
  Details on all the new features and APIs available for the Chalk platfom, or
  Pebble Time Round.
layout: sdk/markdown
permalink: /round/getting-started/
generate_toc: true
search_index: true
---

With the addition of Pebble Time Round to the Pebble hardware family, the Pebble
SDK now targets a third platform called Chalk. Feature-wise, this new hardware
is very similar to the Basalt platform with one major difference - a new display
with a round shape and increased resolution.

Pebble SDK 3.6 is available to help developers write apps
that are compatible with all hardware platforms. New graphics APIs and UI
component behaviors assist with creating layouts ideally suited for both the
rectangular and round display types.

[Get the SDK >{center,bg-lightblue,fg-white}](/sdk/download/?sdk={{ site.data.sdk.c.version }})

## New Resources

To get you started, we have updated the following sections of the Pebble
Developer site with new content and information on designing and developing
for the new Pebble hardware platform:

* An updated
  [*Hardware Comparison*](/guides/tools-and-resources/hardware-information)
  chart - See the hardware differences between all Pebble platforms.

* [*Design in the Round*](/guides/design-and-interaction/in-the-round/) - A new
  section of the Design and Interaction guides with design guidance on how to
  best take advantage of this new display shape.

* [*Creating Circular Apps*](/guides/user-interfaces/round-app-ui/) - A new
  guide describing how to use new graphics APIs and features.

* An updated
  [*Building for Every Pebble*](/guides/best-practices/building-for-every-pebble/)
  guide - New information added on how to keep apps compatible with all three
  Pebble hardware platforms.

* Revised
  [*Platform-specific Resources*](/guides/app-resources/platform-specific/)
  guide - App resources can now be tagged according to intended usage in more
  ways than before to allow tailored resources for different display shapes.


## New Examples

A number of new example apps have been created to help illustrate the round
concept. They are listed below.


### Watchfaces

**Time Dots**

[![time-dots >{pebble-screenshot,pebble-screenshot--time-round-silver-14}](/images/sdk/time-dots.png)]({{site.links.examples_org}}/time-dots/)

**Concentricity**
{% screenshot_viewer %}
{
  "image": "/images/sdk/concentricity.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "red"},
    {"hw": "basalt", "wrapper": "time-black"},
    {"hw": "chalk", "wrapper": "time-round-silver-14"}
  ]
}
{% endscreenshot_viewer %}

### Watchapps

**ContentIndicator Demo**

[![content-indicator-demo >{pebble-screenshot,pebble-screenshot--time-round-silver-14}](/images/sdk/content-indicator-demo.png)]({{site.links.examples_org}}/content-indicator-demo/)

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

title: Getting Started with SDK 4
description: |
  Details on all the new features and APIs available for use in SDK 4
layout: sdk/markdown
permalink: /sdk4/getting-started/
search_index: true
---

Pebble SDK 4 is now available for developers who are interested in using the
new APIs and features. We encourage developers to read
the [Release Notes](/sdk/changelogs/), the [SDK 4 Docs](/docs/c/), and the new
guides listed below to help familiarize themselves with the new functionality.

## Getting Started

#### Mac OS X (Homebrew)

```bash
$ brew update && brew upgrade pebble-sdk && pebble sdk install latest
````

#### Mac OS X (Manual)
1. Download the
   [SDK package]({{ site.links.pebble_tool_root }}pebble-sdk-{{ site.data.sdk.pebble_tool.version }}-mac.tar.bz2).

2. Follow the [Mac manual installation instructions](/sdk/install/mac/).

####Linux
Linux users should install the SDK manually using the instructions below:

1. Download the relevant package:
   [Linux (32-bit)]({{ site.links.pebble_tool_root }}pebble-sdk-{{ site.data.sdk.pebble_tool.version }}-linux32.tar.bz2) |
   [Linux (64-bit)]({{ site.links.pebble_tool_root }}pebble-sdk-{{ site.data.sdk.pebble_tool.version }}-linux64.tar.bz2).

2. Install the SDK by following the
   [manual installation instructions](/sdk/install/linux/).

## Blog Posts

We've published several useful blog posts regarding SDK 4:

* [Introducing Rocky.js Watchfaces!](/blog/2016/08/15/introducing-rockyjs-watchfaces/)
* [Prime Time is Approaching for OS 4.0](/blog/2016/08/19/prime-time-is-approaching-for-os-4.0/)
* [Announcing Pebble SDK 4.0](/blog/2016/08/30/announcing-pebble-sdk4/)

## New Resources

To get you started, we have updated the following sections of the Pebble
Developer site with new content and information on designing and developing
for the new Pebble hardware platform:

* A 2-part [*Rocky.js tutorial*](/tutorials/js-watchface-tutorial/part1/) - Learn
  how to create watchfaces in JavaScript using Rocky.js.

* An updated
  [*Hardware Comparison*](/guides/tools-and-resources/hardware-information)
  chart - See the hardware differences between all Pebble platforms.

* [*AppExitReason API Guide*](/guides/user-interfaces/app-exit-reason/) - A new
  guide with information on how to use the `AppExitReason` API.

* [*AppGlance C API Guide*](/guides/user-interfaces/appglance-c/) - A new
  guide describing how to use the AppGlance API to display information in the
  system's launcher.

* [*AppGlance PebbleKit JS API Guide*](/guides/user-interfaces/appglance-pebblekit-js/) -
  A new guide describing how to use the AppGlance API to display information
  in the system's launcher.

* [*One Click Action Guide*](/guides/design-and-interaction/one-click-actions/) -
  A new guide with information on how to use one-click actions in watchapps.

* [*UnobstuctedArea API Guide*](/guides/user-interfaces/unobstructed-area) - A
  new guide that will demonstrate the basics of the `UnobstructedArea` API, and
  how to use it to create watchfaces that respond to Timeline Quick View events.

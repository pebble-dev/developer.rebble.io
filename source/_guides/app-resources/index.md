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

title: App Resources
description: |
  Information on the many kinds of files that can be used inside Pebble apps.
guide_group: app-resources
menu: false
permalink: /guides/app-resources/
generate_toc: false
hide_comments: true
---

The Pebble SDK allows apps to include extra files as app resources. These files
can include images, animated images, vector images, custom fonts, and raw data
files. These resources are stored in flash memory and loaded when required by
the SDK. Apps that use a large number of resources should consider only keeping
in memory those that are immediately required.

{% alert notice %}
The maximum number of resources an app can include is **256**. In addition, the
maximum size of all resources bundled into a built app is **128 kB** on the
Aplite platform, and **256 kB** on the Basalt and Chalk platforms. These limits
include resources used by included Pebble Packages.
{% endalert %}

App resources are included in a project by being listed in the `media` property
of `package.json`, and are converted into suitable firmware-compatible formats
at build time. Examples of this are shown in each type of resource's respective
guide.


## Contents

{% include guides/contents-group.md group=page.group_data %}

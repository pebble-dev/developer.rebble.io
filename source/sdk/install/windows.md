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

layout: sdk/markdown
title: Installing the Pebble SDK on Windows
description: Detailed installation instructions for the Pebble SDK on Windows.
menu_subsection: install
menu_platform: windows
generate_toc: true
permalink: /sdk/install/windows/
---

Installing the Pebble SDK on Windows is not officially supported at this time.

However, you can choose from several alternative strategies to develop
watchfaces and watchapps on Windows.

## Use CloudPebble

[CloudPebble][cloudpebble] is the official online development environment for
writing Pebble apps.

It allows you to create, edit, build and distribute applications in your web
browser without installing anything on your computer.

**Pebble strongly recommends [CloudPebble][cloudpebble] for Windows users.**

## Use a Virtual Machine

You can also download and run the Pebble SDK in a virtual machine.

 1. Install a virtual machine manager such as
   [VirtualBox](http://www.virtualbox.org) (free) or
   [VMWare Workstation](http://www.vmware.com/products/workstation/).
 2. Install [Ubuntu Linux](http://www.ubuntu.com/) in a virtual machine.
 3. Follow the standard [Linux installation instructions](/sdk/install/linux/).


## Need installation help?

If you need help installing the SDK, feel free to post in the
[SDK Installation Help forum][sdk-install-help].

Please make sure you provide as many details as you can about the issue you have
encountered (copy/pasting your terminal output will help a lot).

[cloudpebble]: {{ site.links.cloudpebble }}
[sdk-install-help]: https://forums.rebble.io/categories/sdk-install/
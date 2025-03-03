{% comment %}
 Copyright 2025 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
{% endcomment %}

### Windows

Installing the Pebble SDK directly on Windows is not supported at this time. We
recommend you use [CloudPebble]({{ site.links.cloudpebble }}) instead.

Alternatively, you can run a Linux virtual machine:

1. Install a virtual machine manager such as
   [VirtualBox](http://www.virtualbox.org/) (free) or
   [VMWare Workstation](http://www.vmware.com/products/workstation/).
2. Install [Ubuntu Linux](http://www.ubuntu.com/) in a new virtual machine.
3. Follow the [manual installation instructions](/sdk/install/linux/), but skip
   "Download and install the Pebble ARM toolchain", as the toolchain is
   included.


### Mac OS X

If you previously used Homebrew to install the Pebble SDK, run:

```bash
$ brew update && brew upgrade --devel pebble-sdk
```

If you've never used Homebrew to install the Pebble SDK, run:

```bash
$ brew update && brew install --devel pebble/pebble-sdk/pebble-sdk
```

If you would prefer to not use Homebrew and would like to manually install the
Pebble SDK:

1. Download the
   [SDK package](https://s3.amazonaws.com/assets.rebble.io/pebble-tool/pebble-sdk-{{ site.data.sdk.pebble_tool.version }}-mac.tar.bz2).

2. Follow the [manual installation instructions](/sdk/install/), but skip
   "Download and install the Pebble ARM toolchain", as the toolchain is
   included.


### Linux

1. Download the relevant package:
   [Linux (32-bit)](https://s3.amazonaws.com/assets.rebble.io/pebble-tool/pebble-sdk-{{ site.data.sdk.pebble_tool.version }}-linux32.tar.bz2) |
   [Linux (64-bit)](https://s3.amazonaws.com/assets.rebble.io/pebble-tool/pebble-sdk-{{ site.data.sdk.pebble_tool.version }}-linux64.tar.bz2)

2. Install the SDK by following the
   [manual installation instructions](/sdk/install/linux/), but skip
   "Download and install the Pebble ARM toolchain", as the toolchain is
   included.

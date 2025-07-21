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

layout: docs/markdown
title: PebbleKit iOS Documentation
docs_language: pebblekit_ios
---

This is the contents page for the PebbleKit iOS SDK documentation, which
includes all information on the main reference sections below.

This part of the SDK can be used to build companion apps for iOS to enhance the
features of the watchapp or to integrate Pebble into an existing mobile app
experience.

Get started using PebbleKit iOS by working through the
[*iOS Tutorial*](/tutorials/ios-tutorial/part1). Check out
{% guide_link communication/using-pebblekit-ios %} to learn more about using
this SDK.

You can find the source code for PebbleKit iOS
[on GitHub](https://github.com/pebble/pebble-ios-sdk), and the documentation
is also available on
[CocoaDocs](http://cocoadocs.org/docsets/PebbleKit/{{ site.data.sdk.pebblekit-ios.version }}/).

{% for module in site.data.docs_tree.pebblekit_ios %}
<h3>{{ module.name }}</h3>
{% for child in module.children %}
<h5><a href="{{ child.url }}">{{ child.name }}</a></h5>
{% endfor %}
<p/>
{% endfor %}

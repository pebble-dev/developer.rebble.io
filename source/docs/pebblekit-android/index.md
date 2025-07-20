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
title: PebbleKit Android Documentation
docs_language: pebblekit_android
---

This is the contents page for the PebbleKit Android SDK documentation, which
includes all information on the two main packages below:

{% for module in site.data.docs_tree.pebblekit_android %}
<h3><a href="{{ module.url }}">{{ module.name }}</a></h3>
<p/>
{% endfor %}

This part of the SDK can be used to build companion apps for Android to enhance
the features of the watchapp or to integrate Pebble into an existing mobile app
experience.

Get started using PebbleKit Android by working through the
[*Android Tutorial*](/tutorials/android-tutorial/part1). Check out
{% guide_link communication/using-pebblekit-android %} to learn more about using
this SDK.

You can also find the source code for PebbleKit Android
[on GitHub](https://github.com/pebble/pebble-android-sdk).

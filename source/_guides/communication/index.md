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

title: Communication
description: |
  How to talk to the phone via PebbleKit with JavaScript and on Android or iOS.
guide_group: communication
menu: false
permalink: /guides/communication/
generate_toc: false
hide_comments: true
---

All Pebble watchapps and watchfaces have the ability to communicate with the
outside world through its connection to the user's phone. The PebbleKit
collection of libraries (see below) is available to facilitate this
communication between watchapps and phone apps. Examples of additional
functionality made possible through PebbleKit include, but are not limited to
apps that can:

* Display weather, news, stocks, etc.

* Communicate with other web services.

* Read and control platform APIs and features of the connected phone.


## Contents

{% include guides/contents-group.md group=page.group_data %}


## Communication Model

Pebble communicates with the connected phone via the Bluetooth connection, which
is the same connection that delivers notifications and other alerts in normal
use. Developers can leverage this connection to send and receive arbitrary data
using the ``AppMessage`` API.

Depending on the requirements of the app, there are three possible ways to
receive data sent from Pebble on the connected phone:

* {% guide_link communication/using-pebblekit-js %} - A JavaScript
  environment running within the official Pebble mobile app with web,
  geolocation, and extended storage access.

* {% guide_link communication/using-pebblekit-android %} -
  A library available to use in Android companion apps that allows them to
  interact with standard Android platform APIs.

* {% guide_link communication/using-pebblekit-ios %} -
  As above, but for iOS companion apps.

<div class="alert alert--fg-white alert--bg-dark-red">
{% markdown %}
**Important**

PebbleKit JS cannot be used in conjunction with PebbleKit Android or PebbleKit
iOS.
{% endmarkdown %}
</div>

All messages sent from a Pebble watchapp or watchface will be delivered to the
appropriate phone app depending on the layout of the developer's project:

* If at least an `index.js` file is present in `src/pkjs/`, the message will be
  handled by PebbleKit JS.

* If there is no valid JS file present (at least an `index.js`) in the project,
  the message will be delivered to the official Pebble mobile app. If there is a
  companion app installed that has registered a listener with the same UUID as
  the watchapp, the message will be forwarded to that app via PebbleKit
  Android/iOS.

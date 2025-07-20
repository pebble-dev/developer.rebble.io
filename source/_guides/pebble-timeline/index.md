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

title: Pebble Timeline
description: |
  How to use Pebble timeline to bring timely information to app users outside
  the app itself via web services.
guide_group: pebble-timeline
permalink: /guides/pebble-timeline/
generate_toc: false
menu: false
related_examples:
 - title: Timeline Push Pin
   url: https://github.com/pebble-examples/timeline-push-pin
 - title: Hello Timeline
   url: https://github.com/pebble-examples/hello-timeline
 - title: Timeline TV Tracker
   url: https://github.com/pebble-examples/timeline-tv-tracker
hide_comments: true
---

The Pebble timeline is a system-level display of chronological events that apps
can insert data into to deliver user-specific data, events, notifications and
reminders. These items are called pins and are accessible outside the running
app, but are deeply associated with an app the user has installed on their
watch.

Every user can view their personal list of pins from the main watchface by
pressing Up for the past and Down for the future. Examples of events the user
may see include weather information, calendar events, sports scores, news items,
and notifications from any web-based external service.


## Contents

{% include guides/contents-group.md group=page.group_data %}


## Enabling a New App

To push pins via the Pebble timeline API, a first version of a new app must be
uploaded to the [Developer Portal]({{ site.links.devportal }}). This is
required so that the appstore can identify the app's UUID, and so generate
sandbox and production API keys for the developer to push pins to. It is then
possible to use the timeline web API in sandbox mode for development or in
production mode for published apps.

1. In the Developer Portal, go to the watchapp's details page in the 'Dashboard'
   view and click the 'Enable timeline' button.

2. To obtain API keys, click the 'Manage Timeline Settings' button at the
   top-right of the page. New API keys can also be generated from this page. If
   required, users with sandbox mode access can also be whitelisted here.


## About Sandbox Mode

The sandbox mode is automatically used when the app is sideloaded using the SDK.
By default, sandbox pins will be delivered to all users who sideload a PBW.

The production mode is used when a user installs the app from the Pebble
appstore. Use the two respective API key types for these purposes. If
whitelisting is enabled in sandbox mode, the developer's account is
automatically included, and they can add more Pebble users by adding the users'
email addresses in the [Developer Portal]({{ site.links.devportal }}).

If preferred, it is possible to enable whitelisting to limit this access to only
users involved in development and testing of the app. Enter the email addresses
of users to be authorized to use the app's timeline in sandbox mode on the
'Manage Timeline Settings' page of an app listing.

> When whitelisting is enabled, the `Pebble.getTimelineToken()` will return an
> error for users who are not in the whitelist.

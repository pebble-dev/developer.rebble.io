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

title: Preparing a Submission
description: |
  How to prepare an app submission for the Pebble appstore.
guide_group: appstore-publishing
order: 0
---

Once a new Pebble watchface or watchapp has been created, the
[Pebble Developer Portal]({{ site.links.devportal }}) allows the
developer to publish their creation to the appstore either publicly, or
privately. The appstore is built into the official mobile apps and means that
every new app can be found and also featured for increased exposure and
publicity.

> Note: An app can only be published privately while it is not already published
> publicly. If an app is already public, it must be unpublished before it can be
> made private.

To build the appstore listing for a new app, the following resources are
required from the developer. Some may not be required, depending on the type of
app being listed. Read
{% guide_link appstore-publishing/publishing-an-app#listing-resources "Listing Resources" %}
for a comparison.


## Basic Info

| Resource | Details |
|----------|---------|
| App title | Title of the app. |
| Website URL | Link to the brand or other website related to the app. |
| Source code URL | Link to the source code of the app (such as GitHub or BitBucket). |
| Support email address | An email address for support issues. If left blank, the developer's account email address will be used. |
| Category | A watchapp may be categorized depending on the kind of functionality it offers. Users can browse the appstore by these categories. |
| Icons | A large and small icons representing the app. |


## Asset Collections

An asset collection must be created for each of the platforms that the app
supports. These are used to tailor the description and screenshots shown to
users browing with a specific platform connected.

| Resource | Details |
|----------|---------|
| Description | The details and features of the app. Maximum 1600 characters. |
| Screenshots | Screenshots showing off the design and features of the app. Maximum 5 per platform in PNG, GIF, or Animated GIF format. |
| Marketing banner | Large image used at the top of a listing in some places, as well as if an app is featured on one of the main pages. |


## Releases

In addition to the visual assets in an appstore listing, the developer must
upload at least one valid release build in the form of a `.pbw` file generated
by the Pebble SDK. This is the file that will be distributed to users if they
choose to install your app.

The appstore will automatically select the appropriate version to download based
on the SDK version. This is normally the latest release, with the one exception
of the latest release built for SDK 2.x (deprecated) distributed to users
running a watch firmware less than 3.0. A release is considered valid if the
UUID is not in use and the version is greater than all previously published
releases.


## Companion Apps

If your app requires an Android or iOS companion app to function, it can be
listed here by providing the name, icon, and URL that users can use to obtain
the companion app. When a user install the watchapp, they will be prompted to
also download the companion app automatically.


## Timeline

Developers that require the user of the timeline API will need to click 'Enable
timeline' to obtain API keys used for pushing pins. See the
{% guide_link pebble-timeline %} guides for more information.


## Promotion

Once published, the key to growth in an app is through promotion. Aside from
users recommending the app to each other, posting on websites such as the
[Discord server]({{ site.links.discord_invite }}),
[Reddit]({{ site.links.reddit }}), [Bluesky]({{ site.links.bluesky }}),
and [Mastodon]({{ site.links.mastodon }}) can help increase exposure.


## Developer Retreat Video

Watch the presentation given by Aaron Cannon at the 2016 Developer Retreat to
learn more about preparing asset collections for the appstore.

[EMBED](//www.youtube.com/watch?v=qXmz3eINObU&index=10&list=PLDPHNsf1sb48bgS5oNr8hgFz0pL92XqtO)

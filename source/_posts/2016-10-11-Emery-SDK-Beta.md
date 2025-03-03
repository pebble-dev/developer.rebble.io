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

title: 4.2-beta4 SDK - Emery Edition!
author: jonb
tags:
- Freshly Baked
---

We're incredibly excited to announce the first public beta of the Pebble SDK
4.2. This is the first time that developers can experience the new 'Emery'
platform which is specifically created for the upcoming
[Pebble Time 2](https://www.rebble.io/buy-pebble-time-2-smartwatch).


![Pebble Time 2](/images/blog/2016-10-11-intro.jpg)


## All About Those Pixels

The new display on the *Pebble Time 2* is almost 53% physically larger, and the
[Pixels per inch](https://en.wikipedia.org/wiki/Pixel_density) (PPI) has been
increased from 182 PPI to 202 PPI. This is a massive 200x228 pixels, compared to
144x168 on the *Pebble Time Steel*, that's an 88% increase in the total amount
of pixels!.

Take a look at our
{% guide_link tools-and-resources/hardware-information "Hardware guide" %} for
further information about the specifications of the Pebble Time 2.

Watchfaces and watchapps that have not been updated for the Emery platform will
run in *Bezel Mode*. This means they will appear centered on screen at their
original resolution (144x168), but due to the change in PPI, they appear
slightly smaller.

![Pebble Time 2 Bezel](/images/blog/2016-10-11-bezel.png)
<p class="blog__image-text">Left: Pebble Time Steel, Middle: Pebble Time 2 -
Bezel Mode, Right: Optimized for Pebble Time 2.<br />
<a href="https://github.com/pebble-examples/concentricity">Concentricity
Watchface</a></p>

The increased number of pixels would immediately make you think that you can
just add more elements to your watchface design, but due to the increase in PPI,
existing elements and fonts may feel slightly smaller than expected when viewed
on an actual device.

The image below simulates how the PPI difference makes a bezel mode application
feel smaller on the Pebble Time 2.

![Pebble Time 2 PPI](/images/blog/2016-10-11-dpi-comparison.png)
<p class="blog__image-text">Left: Pebble Time Steel, Right: Pebble Time 2 - Bezel Mode.</p>

We've now seen that the increased amount of pixels doesn't necessarily equate to
bigger text on our devices, due to the change in PPI, that's why we've created
the new [ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API.


## Introducing the ContentSize API

All existing Pebble smartwatches provide the ability for users to change the
size of text for notifications and some system UI components using *Settings >
Notifications > Text Size*.

The new
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API now exposes this setting to developers, in order for
them to adapt their application design and layout based on this user preference.

In the previous section, we saw how the PPI increase on Pebble Time 2 affected
the relative size of a watchface. In the image below you can see precisely how
text sizes are affected by the PPI change.

![Pebble Time 2 ContentSize](/images/blog/2016-10-11-contentsize.png)
<p class="blog__image-text">Yellow: Pebble Time Steel, Green: Pebble Time 2.</p>

To negate the effects of this reduced font size, the Emery platform uses larger
fonts by default. Developers can use the
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API to match this
behaviour within their own applications.

The following table explains how the text size setting affects the content size
on each platform:

Platform | Text Size: Small | Text Size: Medium | Text Size: Large
---------|------------------|-------------------|-----------------
Aplite, Basalt, Chalk, Diorite | ContentSize: Small | ContentSize: Medium | ContentSize: Large
Emery | ContentSize: Medium | ContentSize: Large | ContentSize: Extra Large

Developers should aim to implement designs which adapt to the capabilities of
the device, but also the accessibility requirements of the user. The
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API satisfies both of these goals.

For more information, read the
{% guide_link user-interfaces/content-size "ContentSize guide" %}.


## New for Rocky.js

With the release of SDK 4.2, we're extremely proud to announce that
[Rocky.js](/docs/rockyjs/) watchfaces can be published into the Pebble appstore!
As usual, don't publish apps with the beta SDK into the appstore, please wait
for the final release.

In addition to finalizing the memory contract for Rocky.js apps, we've also
added a few new APIs to work with:


### Memory Pressure

The `memorypressure` event has been added to allow developers to handle the
situations which occur when the amount of memory available to their application
has changed. Initially we've only implemented the `high` memory pressure level,
which occurs right before your application is about to be terminated, due to a
lack of memory. If you can free sufficient memory within the callback for this
event, your application will continue to run. Please refer to the Rocky.js
[documentation](/docs/rockyjs/rocky/#RockyMemoryPressureCallback) and the memory
pressure [example application](https://github.com/pebble-examples/rocky-memorypressure).


### UserPreferences

The first watchface setting exposed in the new `UserPreferences` object is
`contentSize`. This exposes the new
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API to Rocky.js watchface
developers. Find out more in the Rocky.js
[UserPreferences documentation](/docs/rockyjs/rocky/#userPreferences).


## What's Next

Check out the [release notes](/sdk/changelogs/4.2-beta4/) for a full list of
changes and fixes that were included in SDK 4.2-beta4.

Let us know on [Twitter]({{ site.links.twitter }}) if you built something
cool using the new APIs! We'd love to hear about your experiences with the SDK.

Happy Hacking!

Team Pebble

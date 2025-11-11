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

title: The Road to Pebble SDK 3.0 in Ten Questions
author: thomas
tags: 
- Freshly Baked
date: 2015-04-03
banner: /images/blog/road30-banner.png
---

We launched the first version of our new SDK with support for Pebble Time two
days into our Kickstarter campaign. Since then, we have updated it every week,
releasing six iterations of our developer preview. Some of these versions
included major new features like support for color in the emulator and support
for the timeline. Some other features were more subtle, like the new
antialiased drawing mode and the updates to the animation system. All these
changes together, and a bunch more that you have not seen yet, will form the
SDK that you will use to build watchfaces, watchapps and timeline apps for all
models of Pebble watches in the coming months.

These updates include lots of changes, and no matter how hard we try to
document everything there are a lot of unanswered questions. Some subjects have
just not been addressed by the developer previews yet, some need more
explaining and as always there are things we just missed in our communication
efforts.

In this update, I want to answer publicly the most frequent questions received
from the community in the last few weeks. I will cover components that have
been released but also those that are still to come so you have the information
needed to plan ahead and prepare your apps for the Pebble Time launch.



## What is the “timeline” shown in the Kickstarter video and how can I plug into it?

The timeline is a system-provided app that allows the user to navigate through
important events in their near future and their past.

![A glipse at the future (on the timeline) >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/road30-timeline.gif)

Apps have a very important role to play in the timeline. All Pebble apps (but
not companion apps that use our native PebbleSDK on Android and iOS) can push
“pins” to the timeline. From a developer perspective, pins are just a block of
JSON which describes the information to show to the user and what layout to use
to display the information (generic, calendar, sports or weather). Pins can
also include notifications that will be shown to the user when the pin is
created or updated on the watch, and reminders that can trigger at a specific
time. Finally pins can have actions attached to them. Actions can open a
Pebble app with a `uint32` parameter.

You can experiment with pins in CloudPebble’s new “Timeline” tab or with the
command line SDK and the `pebble insert-pin` command. For documentation, refer
to our [“Understanding Timeline Pins”](/guides/pebble-timeline/pin-structure/)
guide. Once you have nailed down what you want your pins to look and feel like
you can start pushing them via a public HTTP API. This API requires that your
app is submitted on the Pebble appstore; that is also how you get your API key
to use the timeline API. We have built a [Node.js
library](https://github.com/pebble/pebble-api-node) to make this easier and
David Moreau has already shared a 
[PHP library](https://github.com/dav-m85/pebble-api-php/).

We also have a number of examples to help you get started: 

 * A very simple [timeline hello
   world](https://github.com/pebble-examples/hello-timeline) that shows how
   to push a pin every time you press a button in your app 
 * A [TV show tracker](https://github.com/pebble-examples/timeline-tv-tracker/)
   that announces your favorite tv show and lets users click on the pins to
   increase the number of viewers in realtime.

Get started now with our [Getting started with Timeline
post](/blog/2015/03/20/Getting-Started-With-Timeline/) or join us at the next
[Pebble SF developer meetup](http://www.meetup.com/PebbleSF/) on April 24th
where we will do a walkthrough of how to build a timeline app. If you are unable
to make it, you can also find this session on our [YouTube
channel](https://www.youtube.com/channel/UCFnawAsyEiux7oPWvGPJCJQ).

As a side note, many people have asked us what will happen if their app does
not integrate with the timeline. The new Pebble system still includes a main
menu in which all the apps will appear and they can be still be launched from
there.

## How can I build apps with transitions and animations like the ones shown in the Kickstarter videos?

The user interface in the new OS is full of extremely rich animations, and of
course we are not limiting them to the system applications. We want all apps to
take advantage of them and to achieve that, we are investing a lot of effort.

An essential part of all the animations is the core graphics framework used to
draw shapes, text and images. We have improved it a lot in recent weeks with
[much better support for animations](/guides/graphics-and-animations/animations),
[anti-aliasing and stroke width](/guides/graphics-and-animations/drawing-primitives-images-and-text/), 
color bitmap handling and a lot of bugfixes and performance improvements.

Upcoming releases of the SDK will add the new UI components that you saw in the
Kickstarter video: 

 * A new MenuLayer with support for color, infinite scrolling (i.e. looping back
   to the top), and new animations ![The new MenuLayer
   >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/road30-menulayer.gif)
 * A new ActionBar (available this week in developer preview 6!) that is wider,
   takes the full height of the screen, and includes some new animations.  ![The
   updated ActionBar
   >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/road30-actionbar.png)
 * An ActionMenuWindow which is a full screen component to select an action in a
   list. This is the same UI used to select an action on a pin or a
   notification, and it is available to all apps.  ![The new ActionMenuWindow
   >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/road30-actionmenu.gif)
 * A StatusBarLayer that gives you much more control over the status bar,
   including the ability to animate it and add goodies like a progress indicator
   and a card counter for the card pattern.  ![The new StatusBar
   >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/road30-statusbar.png)
 * Cards are not really a UI Component but more of a standard pattern, seen in
   the Weather app in the Kickstarter video and we expect that a lot more apps
   will want to re-use it because it is an extremely efficient way to represent
   information and looks very good! We will have a full example available to you
   very soon showing how to build this type of app.  ![A preview of the Weather
   app and its animations
   >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/road30-card.gif)

For more information on the design of apps in SDK 3.0, we are putting the
finishing touches on a completely new design guide. Stay tuned!

## What is up with the icons on Pebble Time? Can I use these effects in my applications?

A lot of the new design aesthetic is provided by icons, and those icons are not
your usual bitmap file. They animate during transitions to give a level of life
and personality never seen in any User Interface framework before.

They are vector based animations and we came up with a complete new set of APIs
called Pebble Drawing Commands, as well as a new file format (.pdc) to
implement them. Compared to bitmap icons they can be automatically animated by
the system depending on the context: the same icon can explode on the screen,
regroup into a dot or fly through one of the screen edges; all of this in a
fraction of the space it would normally take to do such effects with animated
PNGs.

We will be providing a large set of icons that you can use in your timeline
pins and in your apps. You will also be able to make your own animated icons to
play in your app.


## What is really happening when I compile an app today to be compatible with all Pebbles?

With the current version of the Pebble SDK, we compile your apps once with SDK
2.9 for Aplite (Pebble and Pebble Steel) and once with SDK 3.0 for Basalt
(Pebble Time and Pebble Time Steel). This means that your apps can have a
different look on each platform. This is going to be even more true as we
introduce the new UI components in the next few releases.

![Aplite differences](/images/blog/road30-aplite-differences.png)

However, as soon as we provide official support for Aplite in SDK 3.0, we will
start compiling against the same set of APIs and the UI components will have
similar sizes, look and behavior.

All the new software features of Pebble Time will be available on the original
Pebble, including the timeline, as well as the new UI components, PNG, Pebble
Drawing Commands, unlimited apps, AppFaces, etc. Of course features that are
hardware-dependent (such as the microphone) will not be supported on Aplite.

We encourage everyone to maintain support for both Aplite and Basalt in their
source code. You can easily do it with `#ifdef` calls. If you just want to
freeze your Aplite app as it is today and focus on your Basalt app this will be
possible too with a new feature in the build process coming in the near future.

## What are AppFaces and when can we use them?

AppFaces are previews of your app that are displayed in the launcher before the
user starts your app. To use them, your app will need to support being launched
without a UI to update the AppFace.

![AppFaces](/images/blog/road30-appfaces.png)

AppFaces will not be part of Pebble SDK when we launch Pebble Time. Your apps
will just appear with their name until we add this API at a later stage. This
also means that your app icons defined in the appinfo.json are not used with
the new launcher (but they will still appear on Aplite until 3.0 ships for
Aplite).

## When can we start interacting with smartstraps?

We have released a lot of [mechanical and electrical information about
smartstraps](/smartstraps/) but no APIs yet. You will quickly find out that
without software support, the smartstrap does not get any power.

We are working hard with our first smartstrap partners to finalize the
specifications for this API. If you want to be a part of this discussion,
[please make yourself known!](/contact)

## How can I get my hands on Pebble Time? When will users get them?

If you did not order one on Kickstarter you can register on [our
website]({{ site.links.pebble }}/pebble_time/) to be notified as soon as they are
available for normal orders. We will ship every Kickstarter pledge before we
start selling them on the Pebble website.  If you ordered one through the
Kickstarter campaign, we are working hard to get it to you as soon as possible.

As you know if you are a Kickstarter backer, Pebble Time starts shipping in May.

As a developer, you already have access to the emulator. It includes everything
you need to work on your app. If you are missing anything, [contact us](/contact). 
With only about a month left, there is no time to lose!

## What about PebbleKit for iOS and Android? Any improvements?

We decided to focus all our efforts on the new UI framework and the timeline.
There are no functional changes to PebbleKit in SDK 3.0. However, all Android
apps must be recompiled with the new PebbleKit Android library to be compatible
with Pebble Time. If you do not recompile, your app will not work with Pebble
Time. 

We have lots of plans for PebbleKit in the future and hope to share them
with you soon. 

If you have suggestions for APIs you’d like to see, please
[contact us](/contact)

## Will developers have access to the microphone? What can we do with it?

Absolutely. We will give developers access to our speech-to-text APIs. You will
be able to show a UI to start a recording and your app will receive the text
spoken by the user. This API is coming soon™ - not in 3.0.

We are considering other APIs such as direct microphone access. Stay tuned for
more information on those.

## Can we submit apps for Pebble Time to the Pebble appstore now?

No, you should not. As long as you are using a developer preview SDK, the APIs
are non-final and apps built with the developer preview SDK may not work with
the final firmware and SDK shipped with Pebble Time.

Once the APIs are stable, we will announce a final SDK and encourage everyone
to push applications built with the final SDK to the Pebble appstore.

## Want more answers?

For more questions and answers, such as the future of the `InverterLayer`,
information on floating point support or whether Pebble is really powered by
unicorns and rainbows, please take a look at this [/r/pebbledevelopers
thread](http://www.reddit.com/r/pebbledevelopers/comments/314uvg/what_would_you_like_to_know_about_pebble_sdk_30/).

Much thanks to all the developers who contributed questions to prepare this
blog post!

If there is anything else you would like to know, [this
thread](http://www.reddit.com/r/pebbledevelopers/comments/314uvg/what_would_you_like_to_know_about_pebble_sdk_30/)
is just [one](https://forums.pebble.com/c/development) [of
the](https://twitter.com/pebbledev) [many
ways](/contact) [to get in touch](http://www.meetup.com/pro/pebble/)
with us and get answers!

---
title: Time to Expand Our Core Business!!
author: cat
tags:
- Freshly Baked
---

You might have noticed a bit of a buzz around Pebble today - we have officially
launched our **[third Kickstarter campaign](https://pebble.com/kickstarter)**,
and it is jam packed with exciting new products and features for developers to
explore and hack on. We have been hard at work not only creating the next
generation of health-focused smartwatches, but also refining what great wearable
user and developer experiences look like. We are introducing an entirely new
class of wearable device, and adding a modern JavaScript SDK that takes
advantage of the Web APIs JavaScript developers around the world know and love.

There is a lot to take in, so we’re here to help break down what’s new and
exciting for our favorite developer community!



## The Smartwatches

We are introducing two new smartwatches designed to track and improve your
health, and simplify your life.

![Pebble 2, and Time 2](/images/blog/2016-05-24-kickstarter-3/smartwatches.png)
<p class="blog__image-text">Pebble 2, and Time 2</p>

Pebble 2 is a take on our classic Pebble that launched the smartwatch market in
2012. It includes updated hardware with a high contrast black and white display,
microphone, up to seven days battery life, plus activity, sleep and heart rate
tracking.

Time 2 takes everything our users love about the Pebble Time Steel, and
builds upon it. It offers the same ten day battery life, activity and sleep
tracking you’re used to, and adds a larger color display, a smaller bezel, and
heart rate tracking!

If you are looking to dive a bit deeper, we encourage you to check out our
updated [Hardware Information Guide](/guides/tools-and-resources/hardware-information/)
below, and our [Pebble-3D GitHub repository](https://github.com/pebble/pebble-3d)
that includes 3D drawings of all our smartwatches!

{% include hardware-platforms.html %}

## Pebble Core

A lot of people like to call Pebble a ‘smartwatch’ company, but we’ve decided
it’s *Time* to prove them wrong, and expand our *Core* business with an entirely
new ultra-wearable!

![Pebble Core](/images/blog/2016-05-24-kickstarter-3/core.jpg)
<p class="blog__image-text">Pebble Core</p>

Pebble Core is an entirely new class of wearable device - it features 3G,
WiFi, Bluetooth, GPS, an accelerometer, two programmable buttons, a headphone
jack, and a hardware expansion port accessible to developers.

**Oh yeah, and it’s an open platform.**

Pebble Core is built on top of Android, but has the familiar Pebble
developer experience you’re used to. Pebble Core will be able to run the
PebbleKit JS component of watchapps, to ensure apps continue functioning when a
user leaves their mobile device at home. Additionally, developers will be able
to write standalone Pebble Core applications using an extended version of
PebbleKit JS, allowing you to customize the user experience depending on whether
or not the user has an attached Pebble smartwatch.

With Internet connectivity on the go, and programmatic access to GPS and
Bluetooth Low Energy, the possibilities are endless.

- *Create an app to open your Internet-connected garage door with the click of a button, or order pizza to your current location.*
- *Use geofencing to automatically notify your loved ones when you leave work or school.*
- *Hook it up to your drone and send real time sensor and location information to your phone.*

We have a million ideas for Pebble Core, and we can’t wait for you to get your
hands on it and start hacking! We will be providing more information and news
around Pebble Core soon, so stay tuned!

## SDK 4.0 (The C Part)

With the launch of Pebble 2 and Time 2 we will be releasing our next revision to
the operating system with Pebble OS 4.0. The new operating system includes an
updated user experience aimed at helping the user have access to the information
they need at a glance, and take quick, simple actions.

Let’s look at some of the new features in Pebble OS 4.0, and how you can take
advantage of them as a developer.

The most obvious change is that we have replaced timeline past with an updated
Launcher capable of displaying glanceable information through a new AppGlances
API. To help accommodate the removal of timeline past, we’ve updated the
behaviour of “Now” pins to allow them to persist into the future.

<img src="/assets/images/blog/2016-05-24-kickstarter-3/launcher.gif" alt="Updated Launcher" class="pebble-screenshot pebble-screenshot--time-black">
<p class="blog__image-text">Preview version of updated launcher with AppGlances</p>

Along with the updated launcher, we’re also helping users gain better insight
into what’s going on right now through a new feature called timeline quick view.
Timeline Quick View is a small notification displayed on the user’s watchface 
to let them know what’s happening right now, or coming up soon.

[![Timeline Quick View](/images/blog/2016-05-24-kickstarter-3/peek.png)](/assets/images/blog/2016-05-24-kickstarter-3/peek.png)
<p class="blog__image-text">Preview version of timeline quick view</p>

The default behaviour for timeline quick view is to simply draw over the bottom 
of the watchface, however, developers will have access to a new set of APIs to 
manage how their watchface responds to timeline quick view events. SDK 4.0 will 
include APIs to find the “unobstructed area” of the display, and to react to 
timeline quick view being displayed, and hidden. Using these APIs, developers 
can create watchfaces that respond to timeline quick view, and programmatically 
adjust!

And of course, you’ll have programmatic access to the heart rate monitor through
an updated HealthService, capable of providing both real time, and historical
heart rate information.

## SDK 4.0 (The Embedded JavaScript Part)

We’ve been hard at work enabling developers to write JavaScript applications
that run directly on our smartwatches. In a recent firmware release, we hit a
major milestone - we shipped a JavaScript version of the default watchface,
TicToc, and a Pebble-specific port of an
[embedded JavaScript runtime](https://github.com/pebble/jerryscript) to power
it.

We believe that providing an embedded JavaScript SDK will make our platform more
accessible, powerful, and collaborative. Our JavaScript SDK will be based on
existing Standard Web APIs wherever possible - your display will be a
[Canvas](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API), your
watch and mobile device will communicate through a message-passing API similar
to [Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers),
and you’ll access the compass and accelerometer through the
[Device Orientation](https://developer.mozilla.org/en-US/docs/Web/API/Detecting_device_orientation)
API.


## This is Real (Really!)

We’ll be shipping an early preview version of the 4.0 C SDK near the conclusion
of the Kickstarter campaign. The 4.0 C SDK will include preview APIs for
managing what information your watchapps display in the launcher, how your
watchfaces respond to timeline quick view events, and more.

Support for building and testing Pebble 2 and Time 2 watchapps and watchfaces
will be included in the first official SDK 4 release, tentatively scheduled for
July 2016.

Finally, the embedded JavaScript SDK is scheduled to ship later this summer. We
want to ensure that you have access to it before the first Pebble 2
smartwatches make it onto users’ wrists, so you have time to write the first
wave of Pebble 2 watchfaces in JavaScript!

## Let’s Meetup IRL

If you’re local to San Francisco, we welcome you to join us at SF Geekdom on
June 15 at 6:00pm (more details to follow) to checkout our new hardware, and
learn more about what’s new, and how to best use it. If you are like the
majority of the world and don’t live in San Francisco, you’ll be able to access
a recording of our Meetup after the event so you can join in the fun and learn
what’s new!

If you run a Pebble Meetup, or are interested in running an event to bring
together Pebble Developers, let us know - we’d love to call-in, talk about
what’s new in SDK 4.0, and answer questions from your local community!

## We Need You to Make This Happen

We have worked hard to pack this Kickstarter with as many developer friendly
features and products as possible, and we hope you are as excited as we are!
We’re counting on your support to make all of this happen - so go treat yourself
to some awesome new Pebble products, and help us show the world what wearables
should look like!

https://pebble.com/kickstarter

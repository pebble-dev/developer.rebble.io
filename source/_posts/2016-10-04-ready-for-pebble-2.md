---
title: Ready for Pebble 2
author: jonb
tags:
- Freshly Baked
---

The latest 4.1 releases of the firmware, mobile apps and SDK bring support for
the new Pebble 2 smartwatches, which have started appearing on the wrists of
developers and reviewers around the globe.


![Pebble 2 in the Wild](/images/blog/2016-09-27-silk-in-the-wild.jpg)

Pebble 2 smartwatches are on their way to Kickstarter backers, and firmware 4.1
will be ready and waiting for them.


## Heart Rate Monitor API

The HRM APIs allow allow developers to query the user's current and historical
heart rates. We've provided a simple to use API which caters for the most common
use-cases.

![HRM >{pebble-screenshot,pebble-screenshot--pebble2-black-lime}](/images/blog/2016-09-27-heart-beat.gif)

Find out more in the
{% guide_link events-and-services/hrm "Heart Rate Monitor API guide" %}.


## AppGlance REST API

The AppGlance REST API enables developers to programmatically set the icon and
subtitle that appears alongside their app in the launcher. Developers can push
slices to the their app's glance using their own backend servers by sending
HTTPS requests to the timeline endpoint.

![HRM >{pebble-screenshot,pebble-screenshot--pebble2-white-teal}](/images/blog/2016-05-24-kickstarter-3/launcher.gif)

Find out more about ``App Glance`` in the SDK documentation, or read the
{% guide_link user-interfaces/appglance-rest "AppGlance REST API guide" %}.


## What's Next

Check out the [release notes](/sdk/changelogs/4.1/) for a full list of changes
and fixes that were included in SDK 4.1.

Let us know on [Twitter]({{ site.links.twitter }}) if you built something
cool using the new APIs! We'd love to hear about your experiences with the SDK.

Happy Hacking!

Team Pebble

---
title: Time to Add Color to These Pebbles
author: pebble
tags:
- Freshly Baked
date: 2015-02-26
summary: |
  Announcing the first developer preview of Pebble SDK 3.0, available right now
  on CloudPebble and for download.
banner: /images/blog/Pebble_Watch_3Up_Small.png
---

You [might](https://www.kickstarter.com/blog/six-hours-in-pebble-time) [have](http://techcrunch.com/2015/02/24/pebble-smashes-through-6-5m-on-kickstarter-in-half-a-day/) [noticed](http://www.cnn.com/videos/tech/2015/02/25/ns-pebble-time-smartwatch-ceo.cnn) [on](http://www.cnbc.com/id/102455422) [the](http://www.theverge.com/2015/2/24/8091175/pebble-time-watch-wearable-platform-eric-migicovsky-interview) [Internet](http://www.reddit.com/r/IAmA/comments/2x5aj4/were_eric_migicovsky_the_creators_of_pebble_time/) that we announced the brand new Pebble Time on Tuesday. Almost 50,000 members of our community have already backed the [project on Kickstarter](https://www.kickstarter.com/projects/597507018/pebble-time-awesome-smartwatch-no-compromises) this week.

Most important for all of you is that today we are announcing the first developer preview of Pebble SDK 3.0. This new SDK is available right now to all Pebble developers, via [CloudPebble]({{ site.links.cloudpebble }}) or to [install on your computer](/sdk/download/). Both versions include an emulator with support for the new hardware, and of course the color screen!



<div class="image-list">
  <img src="{{ site.asset_path }}/images/blog/fill-up.gif">
  <img src="{{ site.asset_path }}/images/blog/test7.png">
  <img src="{{ site.asset_path }}/images/blog/isotime.gif">
  <img src="{{ site.asset_path }}/images/blog/block-world.gif">
</div>
<p></p>

Even better: all current Pebble apps will still work on the new Pebble Time!

Apps built with Pebble SDK 3.0 are compatible with today’s Pebble and will be compatible with Pebble Time. Switching to 3.0 only requires minor changes to your application. Once those changes are done, you can easily add color support for Pebble Time watches. By the way, the resolution has not changed (144x168) and we have increased the memory available to apps on Pebble Time to 64kB which should facilitate the transition.

> **For help porting your app to 3.0, take a look at our [Migration Guide](/sdk/migration-guide/).**

We are also sharing with you the documentation for the timeline. As explained in our [Kickstarter video](https://d2pq0u4uni88oo.cloudfront.net/assets/003/333/414/b0eadb909090b2df2b6a5b7a54a900d1_h264_high.mp4), the timeline is a key component of Pebble Time, and it will also be supported by Pebble and Pebble Steel later this year. The timeline is built around a few new PebbleKit JavaScript functions and web APIs that you will call from your own backend. Please note that the API endpoints are not available yet.

> **Read the new [Pebble timeline guide](/guides/pebble-timeline/).**

There are a lot of other new features in 3.0 such as:

+ Support for 64 colors which all [have a name](/tools/color-picker/)!
+ A brand new [animation framework](``Animation``)
+ PNG and Animated PNG support in the SDK
+ Detecting which platforms you are building for at compile time
+ Much more to come!

> **For more details of these and other features, take a look at [What’s New in SDK 3.0](/sdk/whats-new/).**

Much Love and Happy Pebbling!
 - Team Pebble

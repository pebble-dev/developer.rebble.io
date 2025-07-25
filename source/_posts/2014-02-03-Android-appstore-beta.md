---
author: thomas
title: Android appstore beta
date: 2014-02-03 16:20
tags:
- Freshly Baked
---

**Update:** [A new version is available](/blog/2014/03/03/android-beta11/).

This morning [we released the Pebble appstore for iOS](/blog/2014/02/03/pebble-appstore-is-live/). We love Android and feature parity is extremely important for us. We are releasing today a beta of the Pebble Android mobile app that includes the Pebble appstore to all developers.



You can help us finalize the Android app and ship it to everyone very quickly:

 * Report bugs

   Please install it on your device, use it to download apps from the Pebble appstore and share any bug you might encounter.
   **Update**: We have opened a dedicated forum thread to discuss the Android Beta. [Join the discussion!](https://forums.getpebble.com/discussion/10876/pebble-2-0-android-beta)

 * Refer your Android developer friends to Pebble!

   Do you know any great Android developers? Tell them about Pebble, tell them how much you would appreciate them joining us to make a real difference in your life! Seriously, we are hiring: [please apply!](http://pages.getpebble.com/pages/jobs).

This is a BETA release, and comes with some known issues that we are working on:

 * The pairing process has some issues. We recommend first pairing in the bluetooth settings of your phone and then starting the pebble app.
 * You will not be able to configure an app if it is running on your Pebble. Exit the app (or watchface) before clicking the settings button.
 * When installing an application with the pebble tool, you will need to press the "Load" button on your phone to proceed with the install. Make sure the app is launched and in the foreground before you run `pebble install`.
 * `getAccountToken()` currently returns an hardcoded token.
 * If your are an Android developer, you might have the Android dev options of "Limit Background Processes" and "Don't Keep Activities" checked. You need to uncheck/disable these to use the Pebble app.
 * The mobile app shows a "Settings" icon for all JavaScript apps, even if they are not configurable.

Please come back to this list regularly. We will update it with new known problems.


**Update:** [A new version is available](/blog/2014/03/03/android-beta11/).

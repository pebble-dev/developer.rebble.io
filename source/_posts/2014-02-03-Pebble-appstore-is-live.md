---
author: thomas
title: Pebble appstore is live!
tags:
- Freshly Baked
banner: /images/blog/available-on-ios.png
---

This is a big day for Pebble developers and the wearable ecosystem in general! Almost one year after the first version of Pebble SDK, this morning we have released a new version of the Pebble iOS app including the Pebble appstore. For the first time in the history of wearable computing, users can browse and download third party apps: **your apps**.

This is an important milestone. First and foremost we want to thank you for your journey with us. In just 3 months since the first beta of SDK 2 you have blown us away with your talent and creativity!



Here are some answers to the most pressing questions:


 *  When will Android users get the Pebble appstore?

    We are working extremely hard to get the Pebble appstore to all Android users. We will not stop until we are satisfied with the quality of the Android app and ready to release it.

    Yes, we will make a BETA version available to developers first in the next few days.

 * Can I see how many people have downloaded my application?

   Not yet, but we are collecting analytics and we'll make them available in the [developer portal](http://dev-portal.getpebble.com) very soon.

 * When is the next update of JavaScript apps coming?

   Tonight (that is Feb 3rd 2014 at 8pm PST) we will do another sweep of JavaScript apps and include them in version 2.0.1 of the iOS app. Please make sure you push to the appstore and publish your updated PBWs if you need to fix any bugs. You should not remove your previous releases.

   The next update will come 24 hours after the publication of the 2.0.1 iOS app.

 * What version of the iOS app should I use for development?

   You should now delete any BETA version of the Pebble iOS app and use the app available in the Apple App Store for development. It includes the developer connection to deploy your apps to your Pebble. Remember to enable it in the iOS Settings.

 * Known bug in DataLogging

   There is one known issue in the 2.0.0 Pebble iOS app with datalogging. To make sure this bug is not triggered, we have disabled the datalogging APIs in the 2.0.0 firmware. Launching apps using these APIs will exit the app and show a message "&lt;AppName&gt; is not supported".

   We will re-enable datalogging when the 2.0.1 iOS app is available on the App Store.

 * PebbleKit iOS applications

   We have released a [new version of PebbleKit iOS in SDK 2.0.0](/sdk/changelogs/2.0.0). You can use this version for development, it now supports armv7s, arm64 and x86_64 architectures.

   **Please do not use this version of PebbleKit to submit an application to Apple.** There is a known bug that can cause your application to crash when it's in the background. It will be fixed in an upcoming SDK release.


Join us on the [developer forums](https://forums.getpebble.com/categories/developer-discussion) to discuss any problems or share questions. If your question must remain private, you can [contact us](/contact). We are also listening on [@pebbledev](https://twitter.com/pebbledev).

Cheers!
Cherie & Thomas - On behalf of Team Pebble

---
author: thomas
tags:
- Freshly Baked
---

**Update:** [A new version is available](/blog/2014/03/03/android-beta11/).

We just released a new version of Pebble Android 2.0 Beta with the Pebble appstore.



This is what changed in this version:

 * Fix the "Settings" button. Will only appear for configurable apps and will always work.
 * Removed the phone popup when installing apps via the developer connection.
 * Added logs to better understand the battery drain problems.
 * (Updated) `getAccountToken()` now works on Android

Please install this version and report problems and bugs in [the forums](https://forums.getpebble.com/discussion/10876/pebble-2-0-android-beta-feedback#latest).

Here is a list of known issues in this version:

 * Appmessage blocks after a few minutes: We have a fix for this but we are still testing it. It will be included in the next version.
 * You may have trouble pairing if you have lots of bluetooth devices around.
 * After the few "onboarding screens", the app will exit and you will need to retart it.
 * After installing an app with the `pebble` tool, you will need to manually start the app

Please come back to this list regularly. We will update it with new known problems.

---
author: thomas
tags:
- Freshly Baked
---

**Update:** [A new version is available](/blog/2014/03/03/android-beta11/).

Dear Developers,

We just published Pebble Android 2.0 Beta 10. We are getting close to a final release and you can help by testing this build on your devices.



This is what changed in this version:

 * Improvements to speed in MyPebble
 * Improvements to connection stability (this fixes the appmessage getting stuck bug)
 * Improvements to power use
 * Installing apps via websockets will now auto launch them
 * Improvements to JavaScript launch in many conditions, such as when the watch just lost connection to the phone
 * Improvements to pairing during onboarding

Known problems:

 * Still some issues in onboarding.
 * Side-loading watchapps and watchfaces does not work.
 * HTML5 localStorage gets shared between apps.
 * The onboarding process will restart if you enable Accessibility. Workaround: Do not enable accessibility in the onboarding process.
 * If you are upgrading from a pre-2.0 firmware, you will need to first upgrade your watch to 1.14. Upgrading from earlier version is not fully supported at the moment. (To upgrade your Pebble firmware, please use the Pebble 1.9.6 app available in Google Play).

Please install this version and report problems and bugs in [the forums](https://forums.getpebble.com/discussion/10876/pebble-2-0-android-beta-feedback#latest).

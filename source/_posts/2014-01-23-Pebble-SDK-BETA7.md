---
author: thomas
title: Pebble SDK 2.0 BETA7
tags:
- Freshly Baked
---

Attention developers! Pebble SDK 2.0 BETA7 [just landed on the developer site](/sdk/download)! Go get it now and [do read the release notice](/sdk/changelogs/2.0-BETA7). iOS users will need to delete any existing Pebble app before they can upgrade.



Highlights of this new version:

 - More random crashes fixed in the firmware
 - Seriously improved datalogging on iOS (and some bugfixes on Android)
 - Fixed the URL scheme to install Pebble applications. It did not work in Beta6.
 - Added support for `getAccountToken()` in PebbleKit JS (iOS only at the moment)
 - iOS application and PebbleKit iOS are now 64-bit compatible
 - iOS application does not crash on iPhone 4 anymore
 - Some breaking changes in PebbleKit iOS: We cannot use NSNumber categories in 64 bit because their size is unknown. We added a new PBNumber class. This class is returned if you use the NSNumber Pebble category.

The activity on the forums is at its peak and we have been killing bugs like crazy! Please keep them coming! We have never been so close to a release!

We will have another Pebble [virtual lab](https://pebbledev-virtuallab-0120.eventbrite.com) tomorrow morning from 9 to 12 PST (17 to 20 UTC). Join us! IRC Channel: #pebble on freenode.net.

[Download Pebble SDK 2.0 BETA7](/sdk/download)

## Pebble appstore checklist

Have you already submitted your app? Or are you about to submit? Here is a quick checklist for you:

 * Is your application in the 'Published' state? Publishing a release is not enough. You need to click the 'Publish' button in the top right corner to make sure your app is visible. Please double-check this!

 * If you had a 1.x version of your app, and did you provide the name and UUID of your 1.x app in the developer portal? This will allow us to automatically migrate your users to the 2.0 version of your app.

 * Did you upload a header image for your app (not required for watchfaces)? If not, we provide the [Pebble appstore marketing materials](/guides/appstore-publishing/appstore-assets/) to help you.

 * Did you upload at least one screenshot of your app? You can easily create a screenshot of your app by running 'pebble screenshot --phone \<ipaddress>' or by selecting "Screenshot" from the compilation screen of [CloudPebble]({{ site.links.cloudpebble }})

	 ![](/images/blog/screenshot_cloudpebble.png)

	 NOTE: We will be contacting you by email if you uploaded an image that is not a screenshot.

## In other news

* We will have a [Pebble Virtual Lab](http://pebbledev-virtuallab-20140131.eventbrite.com) session next Friday from 2PM to 5PM PST. This is a great opportunity for you to ask all of your burning questions!

* The [developer forums](https://forums.getpebble.com/categories/developer-discussion) are the best place to get assistance. You can also [contact us](/contact) if you can't find an answer on the forums.

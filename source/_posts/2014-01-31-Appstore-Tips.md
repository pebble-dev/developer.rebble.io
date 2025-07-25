---
author: cherie
title: Tips for Appstore Success
tags:
- Beautiful Code
---

If you have already published an app, or are planning on publishing an app,
here are some tips for a successful appstore launch.


 * If your Pebble app requires an iOS or Android companion app, make sure that you have entered the Apple App Store/Google Play URL correctly for your app. Double-check that your links work by clicking on the companion app name in the developer portal or clicking the link in the mobile appstore.
	 ![](/images/blog/iOS_companion.png)
	 ![](/images/blog/android_companion.png)


	 
  * If your Pebble app makes use of the JS configuration tool, please double check that your HTML page loads correctly. You will be getting an influx of traffic on Monday, so make sure you have adequate server resources available to handle your page loads.
	
	
  * If your Pebble app existed on the 1.x SDK, we recommend that you verify that your app is upgraded properly during the 1.x -> 2.0 onboarding procedure. To test, install your 1.x mobile app and place your Pebble in recovery mode so that you are running a 1.x firmware. Once you've paired your Pebble with your phone (accepting the update to 1.14.1 firmware is ok), make sure your 1.x Pebble app is installed on your Pebble. Update your mobile app to BETA7 and pair it with your Pebble. You will be prompted to complete onboarding for 2.0, and then you can verify that your app was automatically upgraded to its 2.0 version.
	
	
  * Screenshots uploaded to the developer portal should be restricted to screenshots taken from your watchface/watchapp. Color photos and drawings are not permitted. We will attempt to contact you this weekend to fix your screenshot images if they have been flagged, but we reserve the right to unpublish your app if it is found to be in violation on Monday. Creating a screenshot is easy!

	* In CloudPebble, on the compilation screen, select "Run Build", enter your Phone IP into the text field and click "Screenshot". 
		![](/images/blog/cloudpebble_screentool.png)
	* With the SDK tools, simply type 'pebble screenshot --phone <phone_ip>' on the command line. The resulting screenshot captured will be a snapshot of whatever is running on your watch at that moment.	
	
  * If you have a marketing banner (optional) or are hoping to be featured in the appstore, please make sure your marketing banner contains these recommended elements: a screenshot overlaid on a [Pebble watch mockup](https://github.com/mcongrove/PebbleUI), the title of your app, and a one-line headline describing what your app does. We recommend that you choose a background that is relevant to your Pebble app.

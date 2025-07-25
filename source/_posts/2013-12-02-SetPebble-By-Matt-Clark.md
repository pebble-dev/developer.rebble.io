---
author: Matt Clark (SetPebble)
tags:
- At the Pub
---

The last Developer Blog post introduced the JS configuration utility, and included some screenshots from [SetPebble.com](http://setpebble.com).  Thomas and Cherie of Pebble asked me to guest blog about SetPebble and JS configuration, so here goes.



When I started creating Pebble apps, developers were publishing 2, 4, even 8 versions of their apps to cover different flavors such as screen inversion, text size, etc.  Soon after publishing my Fair Weather app, I received requests to switch the units to Celsius, wind speed to meters, etc.  Not wanting to create umpteen versions, I learned how to uniquely identify Pebbles when they accessed the Internet.  Therefore when my server transmits weather information to the Pebble watch, it also delivers customizable settings such as the temperature units.

The website I created ([SetPebble.com](http://setpebble.com)) is designed to store customizable settings for Pebble users.  Users can enter their serial number, and then they can choose their customized settings.

For Pebble SDK 2.0, Pebble apps can now store settings in persistent storage within the Pebble smart phone app.  On the Pebble smart phone app, configurable apps now display a gear (Android) or round button (iOS) in the app list.  Clicking on this button launches a web view which can be used to select custom settings.

So why is [SetPebble.com](http://setpebble.com) needed for SDK 2.0 if settings can be stored locally?  There are many reasons, and the first of all is that the settings are safe in the cloud and survive the installing and deinstalling and app crashes.  Users can control their settings from any web browser, and even password-protect their settings.  Developers get a fast and convenient method for adding custom settings to their Pebble apps and watchfaces, plus have summary reports regarding usage.

I can add custom settings to an app in a matter of minutes using the setup screens at [SetPebble.com](http://setpebble.com).  One cool feature is being able to communicate with your Pebble users:  a setting may be classified as “hidden” and I use this for setting a version number.  If one of my SetPebble-enabled apps receives a setting with a version number higher than the current version, then an “update available” message is displayed on the screen.

I have opened up [SetPebble.com](http://setpebble.com) to any developer wishing to easily add custom settings for their app or watch face.  For developers, the benefit is convenience and usage tracking, since SetPebble has a dashboard per app showing usage.  For users they receive a consistent and quality experience for configuring their Pebble, and they also have the option of configuring their options through any web browser if they choose to enter their serial number.

One caveat to developers is that the JS configuration utility is still in beta.  All my SDK 2.0 apps are working great in iOS, but the web views are not always launching in Android.  A future SDK 2.0 beta release should solve this issue.

Why did I create [SetPebble.com](http://setpebble.com) and open up this service to other developers?  The short answer is passion.  Developing for the Pebble is fun and challenging, and the positive user feedback is satisfying.  And Pebble development is turning into a family affair - my 11-year-old son thought of the idea for [Bot Buddy](http://setpebble.com/info?app=24) and helped with the design.

Please refer to these resources for examples of using the JS configuration with [SetPebble.com](http://setpebble.com):  
SetPebble Developer page:  http://setpebble.com/developers    
Sample SetPebble-enabled Simplicity Watchface:  http://github.com/SetPebble/Simplicity2    
Readme file with Screenshots:  https://github.com/SetPebble/Simplicity2/blob/master/README.md    

Happy Pebbling!  
Matt Clark

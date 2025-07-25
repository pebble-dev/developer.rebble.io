---
author: team pebble
tags:
- Freshly Baked
---

Hi Pebble Developers!

Today we are excited to announce Pebble SDK - Version 2.0. This new release adds tons of new features and makes it even easier for developers to build awesome apps and watchfaces for Pebble.

Since we launched the first version of our SDK in April, we’ve been getting feedback and suggestions from developers around the world, and we’ve been working hard to incorporate your suggestions in this new release.



###Some of the most notable changes in this release are:
####New Tools! 
`pebble build && pebble install --phone <ipaddress>` is all it takes now to build and install Pebble watch apps, and that's just the beginning! Developers now also have easy access to comprehensive logs with 'pebble logs' as well as useful feedback from the watch on app memory usage levels

####PebbleKit Javascript
Pebble SDK now provides a library that allows you to develop cross-platform, web-aware applications without a specific Android/iOS companion app. Developers with limited mobile experience can now build apps that work with both iOS and Android seamlessly, simply by bundling Javascript with watchapps.

####Persistent Storage
Apps can now store or cache data in between application sessions. Want to keep track of those high scores, or improve the loading time of your web-aware watch app? Done.

####Dynamic Memory  
Our good friends malloc() and free() are now enabled, allowing you to manage your own memory and create apps that are larger and more fully-featured. You can say good-bye to those statically allocated structures from 1.0, and say hello to beautiful dynamic arrays and linked lists!

####Data Logging 
The new data logging API in SDK 2.0 introduces a simplified messaging system that ensures reliable one-way message transmission from the watch to an iOS/Android device. Developers can now take a "fire and forget" approach to messaging and focus on app development, leaving connection monitoring and buffer management to Pebble. 

####Accelerometer Access 
Pebble SDK now supports access to raw 3-axis data from the built-in watch accelerometer. Use this data to track Pebblers' physical activity, to control software on your phone or computer, or to detect gestures.

Additional details can be found in [the release notes](/sdk/changelogs/2.0-BETA1)

We're proud to announce that more and more developers are creating apps and solutions for Pebble. We're excited to be working with GoPro, Yelp, Foursquare, and iControl to take advantage of the new APIs in Pebble SDK 2.0.

###Ready to dive in?

#####[Download the new SDK](/sdk/download/)  
#####[Get started with the guides](/guides/)  
#####[Browse the APIs](/docs/)  
#####[Find answers to your questions](https://forums.getpebble.com/categories/developer-discussion)  

Not a developer? Don’t worry, this is a beta release that anyone can opt to download and try. We’ll also be pushing out the release as an over-the-air update to all users later this year.

We hope you will enjoy these new tools that we have added to the SDK, as well as the improvements we've made to notifications by [incorporating ANCS and BTLE on iOS and Android devices](https://blog.getpebble.com/2013/11/06/introducing-ios-7-notifications-and-pebble-sdk-2-0/). As always, if you have any questions on how to use the SDK, please [contact us](/contact).

Missed the livestream? You can still view the [recording](https://www.getpebble.com/live) or peruse the [slides](http://www.slideshare.net/CherieWilliams1/pebble-sdk2betalaunch)

Stay up-to-date with the latest Pebble developer news with [RSS](/atom.xml)!

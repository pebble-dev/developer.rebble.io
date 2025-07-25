---
author: thomas
date: 2013-07-03
tags:
- Freshly Baked
- Beautiful Code
---

[Pebble firmware 1.12][pebble-1.12] was released earlier this week. The changelog announced "lots of goodies for watchapp developers" and many of you are curious to see what they are!



We are releasing today the new updated SDK for this firmware version. The first change you will notice is that the SDK version now follows the version numbering of the firmware. The other change is that we are clarifying the naming scheme for the different components:

 * Pebble SDK is the development kit to write watchapps and watchfaces; 
 * PebbleKit is the mobile-phone side of the SDK - It's available for iOS and Android and follows the same version number as the firmware.
 
PebbleKit is distributed inside the Pebble SDK. And as always, you can grab it from [your Pebble account][sdk-download].


This new release of the SDK introduces one major new feature and a lot of improvements:

 * [AppLogging](``Logging``): A framework to send log messages from the watch to your laptop over Bluetooth;
 * Several standard C functions are now available to developers: `snprintf`, `time`, `memcpy`, `memmove`, etc.
 * A new compositing mode for bitmaps
 * Examples for MenuLayer, SimpleMenuLayer and ScrollLayer
 * Several bugfixes (listed in the [changelog][sdk-changelog])

## Install or update the new SDK

[Instructions to install the SDK][sdk-install] have not changed. 

Once installed, you can upgrade existing projects with:

```sh
$ cd watchapp
$ ~/pebble-dev/PebbleSDK-v1.1.2/Pebble/tools/create_pebble_project.py --update-symlink ~/pebble-dev/PebbleSDK-v1.1.2/Pebble/sdk .
$ ./waf configure
$ ./waf build
```

## AppLogging

The first thing you will need to do to use AppLogging is to enable it in your watch. There is a new option for it in the 'About' menu:

![Enable AppLogging in the 'About' menu](/images/blog/applogging-enabled.jpg)

In your application, use `APP_LOG(level, fmt, args...)` to send new log messages through Bluetooth.

```
APP_LOG(APP_LOG_LEVEL_INFO, "Hello World!");
```

AppLogging provides five log levels (error, warning, info, debug and debug_verbose) which 'ought to be enough for everyone'.

On your computer, you will need the latest version of [libpebble from our repository][libpebble]. Pair your computer to your watch and run:

```
$ ~/pebble-dev/libpebble/p.py --lightblue --pebble_id 00:18:33:XX:XX:XX logcat
```

We have a complete example ready to go in `Pebble/demos/feature_app_logging/`.


## Standard C functions

By popular requests, we have added:

 * `srand()` and `rand()` to generate random numbers;
 * Some very useful string functions: `snprintf()`, `strcmp()`/`strncmp()`, `strcpy()`/`strncpy()`, `strcat()`/`strncat()`, `strlen()`
 * Standard UNIX time functions: `time()` (number of seconds since epoch) and `time_ms()` (number of millisecond since beginning of second)
 
You will find documentation for those functions in the [reference documentation][sdk-reference].

## A new compositing mode

We added a new compositing mode `GCompOpSet` for completeness sake (we had all the other options but this one) and we reworked [the documentation](``GCompOp``) to be accurate.

![Compositing modes](/images/blog/compops.png)  

There is also a new example (`feature_draw_bitmap_composite`) to demonstrate the different compositing modes.

## New examples

Finally we added examples for `MenuLayer`, `SimpleMenuLayer` and `ScrollLayer`. We hope you will find them useful!

## @pebbledev

We are also happy to announce that we will start tweeting developer news on <a href="https://twitter.com/pebbledev">@pebbledev</a> - Please follow us and don't hesitate to mention us when you have great watch apps to share!

Feel free to discuss this update here or in the forums!

[pebble-1.12]: https://forums.getpebble.com/discussion/6222/announcing-pebbleos-v1-12-firmware-release-notes/1
[sdk-download]: /sdk/download
[sdk-install]: /sdk/install
[libpebble]: {{ site.links.libpebble }}
[sdk-reference]: /docs/c
[sdk-changelog]: /sdk/changelogs/

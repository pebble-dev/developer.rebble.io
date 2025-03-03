---
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

author: team pebble
tags:
- Beautiful Code
---

PebbleKit JavaScript is one of the most popular additions in Pebble SDK 2.0. We are already seeing lots of amazing apps being built that take advantage of http requests, configuration UI, GPS and local storage on the phone.

Here are some Tips & Tricks to get the most out of JavaScript in your Pebble apps.



### Lint it!

Use [JSLint](http://jslint.com/) ([GitHub](https://github.com/douglascrockford/JSLint)) to check that your Javascript is valid. JSLint with default settings has been successful in catching most of the JS errors that have been reported to us.

If you lint it, there's a much better chance that your app will run smoothly on both the Android and iOS platforms.

### Make the best use of your data storage

There are two types of storage that are used with the Pebble, persistent storage and local storage. [Persistent storage](``Storage``) is available through a C API and saves data on Pebble. [Local storage](/guides/communication/using-pebblekit-js) is a JavaScript API and saves data on the phone. These two long-term storage systems are not automatically connected and you will need to use the [AppMessage](``AppMessage``) or [AppSync](``AppSync``) API's to transfer data from one to the other.

Persistent storage is a key-value storage where the values are limited to 256 bytes and the total space used cannot exceed 4 kb. Persistent storage is not erased when you upgrade the app - but it is erased if you uninstall the app. (Please not that this will be true in Pebble SDK 2.0-BETA4 but was not before).

Local storage exists on your mobile phone and will persist between app upgrades. It is important that you periodically review the data that your app is storing locally and remove any data that is unneeded or no longer relevant. This can be especially important when your internal app data structures change in an update to your app, as your new code will be expecting data formatted in a deprecated form.

We strongly recommend that you version your data (adding a key `version` for example) so that a new version of your app can upgrade the format of your data and erase obsolete data..

### Check for ACK/NACK responses

It is imperative that you check for ACK/NACK responses to your last message between your Pebble and phone before initiating another message. Only one message can be sent at any one time reliably and if you try to send additional messages before ACK/NACK responses are received, you will start seeing failed messages and will have to resend them.

[Pebble-faces](https://github.com/pebble-examples/pebble-faces/blob/master/src/js/pebble-js-app.js) is a good example that includes a `transferImageBytes()` function that sends an image to Pebble, waiting for an ACK after each packet.

### Familiarize yourself with the Geolocation API

The W3C has [extensive documentation](http://www.w3.org/TR/geolocation-API/) on how to use the API, as well as best practices.

Please be aware that support of this API is dependent on the underlying OS and results may vary wildly depending on the type of phone, OS version and environment of the user. There are situations where you may not get a response right away, you may get cached data, or you may never get a callback from your phone.

We recommend that you:

 * Always pass an error handler to `getCurrentPosition()` and `watchPosition()` - and test the error scenarios!
 * Set up a timeout (with `setTimeout()`) when you make a geolocation request. Set it to 5 or 10 seconds and let the user know that something is wrong if the timeout fires before any of the callbacks.
 * Take advantage of the different options you can pass to customize the precision and freshness of data.
 * Test what happens if you disable location services on Pebble (on iOS, remove or refuse the authorization to get location, or turn off the iPhone's radio and Wifi ; on Android disable all the location services).
 * On your watch app, communicate to the user when the system is looking for geolocation information, and gracefully handle the situation when Geolocation information is not available.

### Double check your strings for malformed data

Not all valid strings are valid in the context in which they're used. For instance, spaces in an URL are a bad idea and will throw exceptions. (It may also crash the iOS app in some earlier version of the SDK - Dont do it!) JSLint will not catch errors in quoted strings.

### Use the `ready` event

The `ready` event is fired when the JS VM is loaded and ready to run. Do not start network request, try to read localstorage, communication with Pebble or perform similar operations before the `ready` event is fired!

In practice this means that instead of writing:

    console.log("My app has started - Doing stuff...");
    Pebble.showSimpleNotificationOnPebble("BadApp", "I am running!");

You should do:

    Pebble.addEventListener("ready", function() {
      console.log("My app has started - Doing stuff...");
      Pebble.showSimpleNotificationOnPebble("BadApp", "I am running!");
    });

### Do not use recurring timers such as setInterval()

Your Pebble JavaScript can be killed at any time and you should not rely on it to provide long running services. In the future we may also limit the running time of your app and/or limit the use of intervals.

Follow these guidelines to get the most out of long running apps:

 - Design your app so that it can be killed at any time. Save any important configuration or state in local storage when you get it - and reload it in the `ready` event.
 - If you need some function to run at regular intervals, set a timer on Pebble and send a message to the JavaScript. If the JavaScript is dead, the mobile app will re-initialize it and run the message handler.
 - Do not use `setInterval()`. And of course, do not use `setTimeout()` to simulate intervals.

### Identify Users using the PebbleKit JS account token

PebbleKit JavaScript provides a unique account token that is associated with the Pebble account of the current user. The account token is a string that is guaranteed to be identical across devices that belong to the user, but is unique to your app and cannot be used to track users across applications.

If the user is not logged in, the function will return an empty string (""). The account token can be accessed via the `Pebble.getAccountToken()` function call.

Please note that PebbleKit JavaScript does not have access to the serial number of the Pebble connected.

### Determine a User's timezone using a simple JS script

Pebble does not support timezones yet so when Pebble syncs the current time with your phone, it retrieves your local time and stores the local time as a GMT time (ex. 9AM PST -> 9AM GMT), regardless of where you are located in the world.

If you need to get the current timezone in your app, you can use this simple JavaScript code snippet:

    function sendTimezoneToWatch() {
      // Get the number of seconds to add to convert localtime to utc
      var offsetMinutes = new Date().getTimezoneOffset() * 60;
      // Send it to the watch
      Pebble.sendAppMessage({ timezoneOffset: offsetMinutes })
    }

You will need to assign a value to the `timezoneOffset` appKey in your `appinfo.json`:

    {
      ...
      "appKeys": {
        "timezoneOffset": 42,
      },
      ...
    }

And this is how you would use it on Pebble:

    #define KEY_TIMEZONE_OFFSET 42

    static void appmsg_in_received(DictionaryIterator *received, void *context) {

      Tuple *timezone_offset_tuple = dict_find(received, KEY_TIMEZONE_OFFSET);

      if (timezone_offset_tuple) {
        int32_t timezone_offset = timezone_offset_tuple->value->int32;

        // Calculate UTC time
        time_t local, utc;
        time(&local);
        utc = local + timezone_offset;
      }
    }


### Use the source!

We have a growing number of JS examples in the SDK and in our [`pebble-hacks`](https://github.com/pebble-hacks) GitHub account. Check them out!

You can also [search for `Pebble.addEventListener` on GitHub](https://github.com/search?l=&q=Pebble.addEventListener+in%3Afile&ref=advsearch&type=Code) to find more open-source examples.


## Best Practices for the JS Configuration UI

The new configuration UI allows you to display a webview on the phone to configure your Pebble watchface or app. Here are some specific recommendations to development of that UI.

If you have not read it yet, you might want to take a look at our [Using PebbleKit JS for Configuration](/blog/2013/11/21/Using-PebbleKit-JS-Configuration/) blog post.

### Immediately start loading your Web UI

To avoid confusion, make sure UI elements are displayed immediately after the user clicks on settings. This means you should not do any http request or complex processing before calling `Pebble.openURL()` when you get the `showConfiguration` event:

    Pebble.addEventListener("showConfiguration", function() {
      Pebble.openURL('http://www.example.com/mypebbleurl');
    });

If the UI rendering is delayed, the user will get no feedbacks for their action (a press on the configure icon) and this would result in a poor user experience.

### Apply mobile & web best practices

There is a lot of information on the web on how to build webpages that display nicely on mobile devices. iOS and Android both use WebKit based browsers which makes things easier, but it is safe to assume that you will never get the exact same look - and you will always need to test on both platforms. Even if you do not own both devices, you can use the built-in browser in the iOS or Android emulators to test your configuration webpage.

Also consider using framework such as [JQuery Mobile](http://jquerymobile.com/) or [Sencha Touch](http://www.sencha.com/products/touch/) to make your life easier. They provide easy to use components and page templates. If you do not want to write any html, [setrebble.io](http://www.setrebble.io) is another great option that we have [discussed on the blog](/blog/2013/12/02/SetPebble-By-Matt-Clark/) previously.

### Be prepared for the network to be unreachable during a UI configuration attempt

UI configuration HTML is not stored locally on the phone and must be accessed from a hosted server. This introduces situations where a user's phone may not be connected to the network successfully, or your server may be unreachable, in which case the UI configuration screen will not load.

In this scenario, a user will likely cancel the configuration load, which means a blank string is returned to your application `webviewclosed` event. Your watchapp should be designed to handle this such that the watchapp does not erase all settings or crash.

### Display existing settings

When displaying your configuration UI, remember to pass existing settings to the webview and use them to pre-populate the UI!

### Name your configuration submission button "Save"

If you want to ensure that the settings a user has entered are saved correctly, make sure you call your button _Save_ so users understand that it is required to save data. If your configuration page is long, consider putting the _Save_ button at both the top and bottom of the page.

If the user clicks the Exit button (X), a blank string will be passed back to your application. You should be prepared to handle a blank string should a user decide to cancel the configuration process.

### Prompt users to complete app configuration in your Pebble app

Users may not be aware that they need to complete a configuration for your watchapp. It is best to advise users in the watchface or watchapp to go to their phone and configure your app before proceeding.

Use persistent storage or local storage to save a token indicating the user has completed configuration, and consider putting a version string in, to allow you to track which version of your configuration webpage the user has accessed (to assist future upgrades of your app).

## Questions? More tips?

Have more questions? Or want to share more tips? Please post them in the comments below!

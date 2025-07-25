---
author: thomas
tags:
- Beautiful Code
banner: /images/blog/pebble-on-plane.jpg
---

I love working on the plane. It is one of those rare place where I can spend 8 hours coding without being disturbed by emails, phone, etc. Here are a few tips to write Pebble apps in the air.



## 1. Download and Install the SDK

[CloudPebble]({{ site.links.cloudpebble }}) is awesome but unfortunately it will not work when you are not connected (and if you are using in-flight wifi, you will likely be disturbed by the usual suspects mentioned above).

Installing the Pebble SDK on a Mac or a Linux computer is very easy and should only take you a few minutes [following our instructions](/sdk/install). Make sure you do this before you get on the plane as some commands require Internet access.

## 2. Use the documentation packaged in the SDK

You may not know this but your local SDK install contains a full copy of the [API Reference](/docs/c). You can open it directly from the filesystem in your browser: `file:///Users/thomas/pebble-dev/{{ site.pb_sdk2_package }}/Documentation/pebble-api-reference/modules.html`.

Another great way to read the documentation is to use [Dash](http://kapeli.com/dash) and the [Pebble doc bundle](http://partlyhuman.github.io/PebbleSdkDocset/Pebble.xml) provided by [Roger Braunstein](https://github.com/partlyhuman/PebbleSdkDocset).

You also get a full copy of the examples in `{{ site.pb_sdk_path }}{{ site.pb_sdk2_package }}/Examples`.

## 3. Create your own local network

You really should use the `pebble` tool to push apps on your Pebble and debug them. To do that you need a wifi connection and the ability for different devices to communicate. I have tried a few options.

 * Using an hotspot on the plane

   If your plane is equipped with GoGo InFlight, just connect to the Wifi network. You do not need to pay. Your laptop and your mobile phone will get a local IP address and in my experience they can communicate perfectly with each other.

 * Create a hotspot from your phone

   On iOS this only works if you have the option enabled in your plan. Turn-on the "Personal Hotspot" and use Bluetooth, USB, or Wifi, to connect your laptop to your phone. Even in airplane mode, this works.

   On Android use the "Tethering & Portable HotSpot" menu in the Settings to create a new hotspot. This is very reliable and will also allow you to connect an iOS device. Some Android devices only allow this if the airplane mode is off which of course is not an option.

 * Create your own hotspot from your laptop

   If there is no hotspot on the plane, you can create your own. On a Mac, just click on the Wifi icon, then _Create Network..._ and choose a name and password. Connect your mobile to that network.

   Because you do not have a DHCP server, both the computer and the phone will wait for a bit before they automaticall assign IP address (in the form 169.254.xxx.xxx). To speed things up, you can use static addresses (192.168.0.1 and 192.168.0.2 for example).

   This seems to only work with iOS. Unfortunately Android devices cannot connect to an Ad-Hoc wifi network.

Once the Wifi is up, you should be able to turn on the developer connection and use the `pebble` tool with the `--phone 192.168.x.x` option to ping your Pebble:

    $ pebble ping --phone 192.168.43.1
&nbsp;

Enjoy!

---
author: thomas
tags:
- '#makeawesomehappen'
---

It seems the summer days are only increasing the energy of Pebble developers! There were lots of new watchfaces [announced on the forums](https://forums.getpebble.com/categories/watchapp-directory) this week. It's getting hard to try all of them!

Watchfaces are a very visible part of the work they are doing but they are also inventing new ways to use the Pebble SDK. Featured this week: how to take screenshots of your apps, getting facebook and twitter on your wrist (for iOS and Android), wearing barcodes and paying your respect to an old Chinese custom!



## Taking screenshots of Pebble apps

The current SDK offers no easy way to make screenshots of your applications and most developers have resolved to either take pictures of their watch or mockup their interface in [Photoshop][screenshots] or with [HTML Canvas][htmlcanvas].

This was not good enough for [Edward][] who decided to hack around the SDK a little bit (we will forgive you this time!) and wrote a [small library][pblcapture] that developers can embed in an existing app to export screen captures.

The captures are received on an iPhone by his companion app and for those of you using httpebble, he has [even made a fork][httpebble-fork] of httpebble that includes screen capturing and sharing.

Here is a little demo:

[EMBED](//www.youtube.com/v/DbfBWviuO0w)

Pretty awesome!

[screenshots]: https://forums.getpebble.com/discussion/4557/how-can-i-take-a-screenshot-of-a-pebble-watch-face
[htmlcanvas]: http://blog.gazler.com/blog/2013/01/30/writing-your-first-pebble-watchface/
[edward]: https://github.com/epatel/
[httpebble-fork]: https://github.com/epatel/httpebble-ios
[pblcapture]: https://github.com/epatel/pblindex/blob/capture/src/pblcapture.c

## Twitter, Facebook and more on the wrist

[Mybucketz][mybucketz] is a free service to aggregate all your social medias. [Al took the time][al] to write [a mybucketz watch application][mybucketzpbw] that works on Android and iOS (with httpebble) and allows you to get all your timelines on your wrist.

![Mybucketz screenshot](http://media.tumblr.com/6a78dd497fb864285b9456dcf2d65dae/tumblr_inline_mqd83aDvMs1qz4rgp.jpg)

[mybucketz]: http://www.mybucketz.com/
[al]: https://forums.getpebble.com/discussion/6694/watch-app-mybucketz-lets-you-see-your-facebook-and-twitter-feeds-on-your-wrist-httpebble#latest
[mybucketzpbw]: http://www.mypebblefaces.com/view?fID=5074&aName=mybucketz&pageTitle=Facebook%2FTwitter+Feed+%28mybucketz%29&auID=6107

## Wear your barcode

We already knew that you could load your [starbucks card][pebble-starbucks]  in a watchface and use it to pay for drinks at Starbucks. This has also been [reported to work][tesco] at Tesco in the UK. 

So far the [technique used][barcodetechnique] involved generating an image online and creating a new watchface with that image embedded (thanks to http://www.watchface-generator.de/ for example).

This is now getting even easier thanks to [frethop][frethop] _Wear Your Barcode_ watchface. It is available on [mypebblefaces.com][watchapp] and works with a companion [Android app][androidapp]: It supports carrying several barcodes in one watchface and you can save existing barcodes by scanning them with your phone.

So what barcode will you wear? Let us know in the comments!

[barcodetechnique]: http://www.reddit.com/r/pebble/comments/1dze2a/grocery_store_loyalty_card_on_pebble/
[pebble-starbucks]: https://twitter.com/nickdube/status/331835268728512512
[tesco]: http://www.modaco.com/topic/363454-turn-your-pebble-into-a-tesco-clubcard-with-a-custom-watchface/
[frethop]: https://forums.getpebble.com/profile/1181/frethop

[watchapp]: http://www.mypebblefaces.com/view?fID=5165&aName=frethop&pageTitle=WYB%3A+Wear+Your+Barcode&auID=1336
[androidapp]: https://play.google.com/store/apps/details?id=com.kabestin.android.wristbarcode.view&hl=en

## Tutorials

Still dreaming about developing for Pebble? This week brought more tutorials to help you get started!

[This three page tutorial on The Register][theregister-tutorial] is a great way to discover the SDK. It covers how to do some basic graphics on Pebble, using the buttons and pushing your app to the watch. By the end of this tutorial, you will have a nice bouncing ball type of app, like demonstrated in this video:

[EMBED](//www.youtube.com/v/UARniPjApZ0)

If you want to dive deeper in the SDK, [Chris][chris] has just published [part 7][part7] of his SDK Tutorial, covering `ScrollLayers`. If you missed them, the first part provided a good primer of basic C and the following posts cover different APIs of the SDK: installation, building a first watch face, animations, fonts and two-way communications.
 
 
[ninedof-tutorial]: http://ninedof.wordpress.com/pebble-sdk-tutorial/
[part7]: http://ninedof.wordpress.com/2013/07/21/pebble-watch-face-sdk-7-scrolllayers/
[chris]: http://twitter.com/Chris_DL
[theregister-tutorial]: http://www.theregister.co.uk/2013/07/18/how_to_write_apps_for_the_pebble_smartwatch/

## Dev Challenge

When you are done reading those tutorials, you might want to give this [developer challenge][devchallenge] a try!

The goal is to create a watchface that reproduces a classic Mao watch:

> If you have ever visited China, an almost essential souvenir is the infamous Chairman Mao watch. The watch features a picture of Chairman Mao and his hand waves as it runs. It defininitely falls into the so-tacky-it's-awesome camp, and is a "communist kitsch" must have! The other thing about the watches is that, being cheaply made in China, they are also almost guaranteed to break after a few days of use....

![Mao watch](/images/blog/maowatch.gif)

[devchallenge]: http://www.reddit.com/r/pebble/comments/1imaq5/dev_challenge_chairman_mao_watch_for_pebble

## Coming up next week

We cannot wait to see what new cool apps will come over the next week, make sure to let us know about your creations!

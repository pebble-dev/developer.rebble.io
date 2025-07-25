---
title: A once in a lifetime opportunity&#58; Pebble appstore launch
tags:
- Freshly Baked
---

Dear Developers,

Have you submitted your apps to the Pebble appstore?

[Eric announced this morning at CES](https://blog.getpebble.com/?p=187) that the appstore will be officially released in late January. The 2.0 BETA period is coming to an end; users will soon get their hands on the amazing apps you have created.

Eric also announced a brand new Pebble: [Pebble Steel]({{ site.links.pebble }}/steel). We have a few to give away to the developer community. Keep reading for more information!



![Pebble Steel](/images/blog/pebble-steel-1trio.png)

Appstore launches do not happen often and we all know this is a big opportunity; the first apps on the appstore will receive more downloads and attention than apps submitted at a later date. To prepare for this big day, we would like to share some tips and information:

## Submitting an application to the Pebble appstore

Submitting an application is a free and very easy process that only takes a few minutes. Just head to our [developer portal](https://dev-portal.getpebble.com) and upload your application and a few images.

We have prepared some resources to help you:

 - [Publishing to the Pebble appstore guide](/guides/appstore-publishing/)
 - [Photoshop template for Pebble appstore assets](/guides/appstore-publishing/appstore-assets/)
 - [Answer to some common questions](/blog/2013/12/18/All-Aboard-the-Pebble-app-store/)
 - [How to take screenshots with the `pebble` tool](/guides/tools-and-resources/pebble-tool/)

If you are new to Pebble SDK 2.0 or need to upgrade (the latest release is BETA4), you will need:

 - [Pebble 2.0 SDK bundle](/sdk/)
 - [Pebble 2.0 Firmware images](/sdk/)
 - [Pebble 2.0 iOS app](https://docs.google.com/a/pulse-dev.net/forms/d/14r3MHPsdH5ha-BCkfuquQuAKuQSEJLmxm--XXpBA8mg/viewform) (some info required, you will receive a download link shortly)
 - [Pebble 2.0 Android app](/sdk/)

## Automatic migrations

When users install the new Pebble mobile app, the list of apps installed on their Pebble will be downloaded and saved on the phone. The firmware will be automatically upgraded to 2.0 and the Pebble app will look for and install the 2.0 version of those apps from the Pebble appstore.

Matching of applications for the automatic upgrade is done on two criteria: Name and UUID. If you have written and published a Pebble 1.x application, make sure that you publish the 2.0 version of your app on the Pebble appstore and register the old name and old uuid of your 1.x app. If you are replacing several 1.x apps by one 2.0 app (this is often the case for watchfaces that had several variants and are now [configurable](/blog/2013/11/21/Using-PebbleKit-JS-Configuration/)) you can provide several pairs of UUIDs and names.

> Please note that the UUID you need to provide in the store is a standardized UUID in the form: `550e8400-e29b-41d4-a716-446655440000`. UUID of 1.x apps were defined as an array of bytes, for example: `0x42, 0x33, 0x22, ...`. In both cases they are a 16 byte identifier and conversion from one format to the other is trivial; simply remove the `0x` prefixes and commas, and add the dashes.
>
> For example the httpPebble UUID was:
> `{ 0x91, 0x41, 0xB6, 0x28, 0xBC, 0x89, 0x49, 0x8E, 0xB1, 0x47, 0x04, 0x9F, 0x49, 0xC0, 0x99, 0xAD }`
>
> In the appstore format, it should be written `9141B628-BC89-498E-B147-049F49C099AD`.

## Deadline for JavaScript applications

As previously mentioned in [the appstore announcement](/blog/2013/12/18/All-Aboard-the-Pebble-app-store/), the new iOS application will embed the source of all JavaScript apps available in the appstore. When iOS users browse the Pebble appstore, only the apps that have been bundled in the Pebble mobile app will appear (non-Javascript apps will appear normally).

**We will extract the JavaScript of all the appstore apps on January 9th at 23:59 PST.** If you are using PebbleKit JavaScript in your app, make sure your app is published on the store by this time.

## Beta versions and reporting bugs

We will continue releasing BETA versions of the 2.0 firmware and mobile apps as we have in the past. Your help finding and fixing bugs is extremely appreciated.

The forums are a great way to work together with other Pebble developers, so please consider posting there first. We review every post in the [Developer Discussions](https://forums.getpebble.com/categories/developer-discussion).

Two tips that go a long way towards helping us fix bugs faster:

1. If you encounter a bug or a crash, use the "Contact Support" button in the mobile apps to extract logs from your Pebble.

2. Make sure you provide very clear reproduction steps, along with the simplest code sample that can reproduce the issue.

## CloudPebble update

[@KatharineBerry](https://twitter.com/KatharineBerry) just pushed a [major update to CloudPebble](http://blog.cloudpebble.net/2013/12/sdk-2-0-developer-mode/) for SDK 2.0, so if you haven't used CloudPebble in awhile, definitely take some time to check out the new changes!

![CloudPebble installing app](http://blog.cloudpebble.net/wp-content/uploads/2013/12/Screen-Shot-2013-12-25-at-12.05.27.png)

CloudPebble now allows you to input your phone IP address and install an application over the air from your browser. You can also view a console with realtime logs from your app.

![CloudPebble logs](http://blog.cloudpebble.net/wp-content/uploads/2013/12/Screen-Shot-2013-12-25-at-12.09.05.png)

This is an excellent way to get started, and by far the best option for Windows developers. [Give it a try!](https://cloudpebble.net/)

## Check out Pebble Steel!

This update would not be complete without a word about [the new Pebble]({{ site.links.pebble }}/steel).

In terms of development, it is completely compatible with existing apps (same screen, same CPU, same memory, same bluetooth chip, etc). The only extra hardware is the RGB LED.

This new hardware is a beautiful piece of engineering and we want to share it with you our developers. We have reserved 4 Pebble Steels that we will send to the developer of:

 - One working JavaScript app selected at random from apps published on the appstore before January 9th
 - One working app selected randomly from published appstore apps that is a 1.x migration
 - One working app selected at random from all published apps on the appstore, including watchfaces
 - And the Pebble developer that sends the most useful bug report(s) prior to appstore launch (These bug reports must be posted to the forums under "Developer Discussion", with clear reproduction steps)

_This giveaway is limited to one Pebble per developer, and we reserve the right to disqualify apps that are fraudulent or that do not work._

Thanks for making Pebble so #awesome in 2013 - We are very excited to start 2014 with all of you and wish you a very Happy New Year!

Cherie and Thomas (for Team Pebble)

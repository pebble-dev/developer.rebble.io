---
author: thomas
title: Pebble SDK 2.0 BETA6 - Season Finale?
tags:
- Freshly Baked
---

Another week and another release of Pebble SDK 2.0. In this version you will find that the iOS application now includes the Pebble appstore and will give you a chance to see how your application looks and feels with the new store. If you had a 1.x application, you should also make sure that the automatic upgrade works properly for your app.



Beta6 also brings more bugfixes to the Pebble firmware and you will find that it is more stable than previous releases. [Read the full Changelog](/sdk/changelogs/2.0-BETA6/).

> **Attention iOS Users:**
>
> * Before you install this version, you need to remove the Pebble app from your phone. You will need to reinstall all your JavaScript apps afterwards.
> * iPhone5S, iPad Air and Retina iPad Mini users will need to manually pair in the Settings of the phone.

[Download Pebble SDK 2.0 BETA6](/sdk/download/)

## JavaScript application deadline updated

We have postponed the JavaScript application deadline to Sunday January 19th at 11:59 pm PST. You have a bit more time to get your app in the store!

We got a lot of questions on the JavaScript/iOS deadline. We are glad to see so much interest! Here are the most common questions and answers:


 * What do you mean by "the new iOS application will embed the source of all JavaScript apps available in the appstore"?

    Every time we make a release of the iOS application we will download all the published watchfaces and watchapps that use JavaScript and save the JavaScript files in a bundle packaged in the iOS application.

    All the releases that are saved are tagged with the version number of the iOS app in which we save them.

    When user browse the Pebble appstore with an iOS device, they will only see and be able to download the releases that are tagged with the version number of the iOS app they are using.

 * If I upload a new version of my application with a new binary and a new JavaScript file, will my users get the new binary right away?

    We track the entire application (C+JS), so users will have to wait until the JavaScript is included in the iOS app to get the update of your binary.

    There is an exception to that though - If the javascript source has not changed, we will detect this and automatically offer the updated version to the users.

 * If I miss the first deadline, how long will I have to wait for another update?

    We do not have an official schedule in place yet but you can expect the first update to come in the next two weeks after the first release.

 * Will the Pebble application allow users to download JavaScript apps from the web?

    No. When an iOS user downloads and installs a PBW with JavaScript from a website, the iOS app will not execute the JavaScript code.

 * As a developer, how will I be able to test and debug my application?

    We will provide a working environment for developers. Expect more information to come later.

## Pebble appstore checklist

Have you already submitted your app? Or are you about to submit? Here is a quick checklist for you:

 * Is your application in the 'Published' state? Publishing a release is not enough. You need to click the 'Publish' button in the top right corner to make sure your app is visible. Please double-check this!

 * If you had a 1.x version of your app, did you provide the name and UUID of your 1.x app in the developer portal? This will allow us to automatically migrate your users to the 2.0 version.

 * Did you upload a header image for your app (not required for watchfaces)? If not, we provide the [Pebble appstore marketing materials](/guides/appstore-publishing/appstore-assets/) to help you.

## Deep links to Pebble applications

You can link directly to a Pebble app or watchface in the Pebble appstore. Simply grab your Pebble application identifier in the URL of the developer portal and append it to: `pebble://appstore/`.

For example, if your application in the portal has the URL `https://dev-portal.getpebble.com/applications/52d396683e2e256b6c00001e`, then a deep-link for your app is `pebble://appstore/52d396683e2e256b6c00001e`.

This will work on iOS and Android, as long as the user has the 2.0 Pebble application installed. Installing applications through the Pebble appstore has many benefits:

 * A better user experience, and one that is consistent with searching and installing from the store.
 * Your application will be added to the Locker (The Pebble locker is a list of applications a user can easily swap in and out.)
 * You, as a developer, will get detailed stats on downloads and usage of your application.
 * We will automatically upgrade your app on Pebble when you publish an upgrade.

We strongly recommend you switch to this new model instead of directly installing PBWs.

## In other news

* We updated the [Design guide](/guides/appstore-publishing/appstore-assets/) with a section on designer resources that you can use to promote your Pebble applications.

* If you are not using JSHint now, you need to read our blog article on [Setting up JSHint for Pebble Development](/blog/2014/01/12/Using-JSHint-For-Pebble-Development/)

* We will have a [Pebble Virtual Lab](http://pebbledev-virtuallab-0120.eventbrite.com) session next friday from 9 am to 12 PST, that is 16 to 20 UTC. Hopefully this timeframe will be more practical for those of you in Europe.

* The [developer forums](https://forums.getpebble.com/categories/developer-discussion) are the best place to get assistance. You can also [contact us](/contact).

* We’re still hiring like crazy right now and we’d love to have you come join us! Pebble is a fantastic place to work and there are countless opportunities for you to grow within the organization. Check out our [jobs page](https://www.getpebble.com/pages/jobs) for more details.

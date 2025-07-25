---
title: Parlez-vous Pebble? Sprechen sie Pebble? ¿Hablas Pebble?
author: chrislewis
tags:
- Freshly Baked
date: 2014-12-15
banner: /images/blog/1212-world.png
---

The official Pebble Android and iOS apps have been updated to 2.2 and 2.6
respectively. These updates add support for the French, German and Spanish
languages. The Pebble firmware, the mobile apps and the appstore are all
translated.




## Localization 101

Now that Pebble speaks multiple languages, your app should recognize the user
language and automatically adapt to it.

To translate the names of days and months, you only need to tell the system that
you support localization. Call `setlocale(LC_ALL, "");` when your app starts and
`strftime()` will take care of the rest.

If you have more content to translate, `setlocale()` also conveniently returns a
string with the user locale!

For more information and tips on how to effectively translate your app
(including the list of supported languages), read 
[our new internationalization guide](/guides/tools-and-resources/internationalization/).

## Firmware and SDK 2.8.1 Released!

![sdk](/images/blog/1212-sdk.png)

After all the [new features](/blog/2014/11/28/Firmware-2-8-Android-2-1-Meetups/)
of 2.8 were released, there were unfortunately some bugs that needed squashing
as soon as possible. Hence we have released firmware 2.8.1, which will fix
these issues, as well as improved iOS BLE pairing and better translations.
Simply check your Pebble phone app to update your Pebble.

This release also comes with an [updated SDK](/sdk/), which now
allows non-ASCII characters in the app name, includes `locale.h`, as well as
several other app building related issues.

As always, check the [changelog](/sdk/changelogs/2.8.1/) for all the details.

## CloudPebble Now Available in Chinese!

![cp](/images/blog/1212-cp.png)

Previously supporting English, French, Spanish and German, developers can now
build Pebble apps using [CloudPebble]({{site.links.cloudpebble}}) in Chinese!

CloudPebble automatically switches to your browser language but you can also
manually switch to any of these languages from the dropdown list at the bottom
of the UI.

## Pebble Teaches with Codementor Office Hours

![codementor](/images/blog/1212-codementor.png)

Our lead evangelist Thomas Sarlandie led an online workshop entitled [*Building
Your First Pebble App in 1
Hour*](https://www.codementor.io/javascript/tutorial/intro-wearable-development-pebble-watch-apps),
which guided attendees in developing their first web-connected Pebble watchapp
that connected to a weather service.

If you, or anyone you know, wants a quick video introduction to development with
Pebble.js on CloudPebble, [this is the video for you!](https://www.codementor.io/javascript/tutorial/intro-wearable-development-pebble-watch-apps)

## PebbleKit iOS Deadline for Christmas

Like many companies, Apple is
[taking a break from approvals](https://developer.apple.com/news/?id=12082104a)
over the holiday break starting on December 18th. This means you should
[submit your app for whitelisting](/guides/appstore-publishing/whitelisting/)
before **December 16th 20:00 PST** to give us time to process and submit your
app before you can submit it on the 18th.

## Win a Pebble Steel for the best Community Contribution of The Month

We have opened [the community section](/community/) and are so happy to see so
many cool contributions pop-up that we have decided to give a Pebble Steel to
the best contribution submitted before the end of December.

Remember that [you can submit](/community/submission/) blog posts, tools,
example apps and libraries!

We have not figured out exactly how we will pick the winner yet. It will be a
mix of community feedback and awesomeness of the contribution! Let us know if
you would like to see more of this type of give-away.

## We're Hiring!

As a rapidly growing company, we're always on the lookout for new talent to grow
our various teams. If you or anyone you know has the technical skills, wearable
enthusiasm and a taste for the Valley lifestyle, have a look at our
[jobs page]({{ site.links.jobs }}) to see a list of open positions.

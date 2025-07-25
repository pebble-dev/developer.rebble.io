---
title: Pebble Timeline Challenge Week 1 Winner - Battery+
author: niharika
tags:
- Timeline
banner: /images/blog/batteryplusbanner.png
image: https://assets.getpebble.com/api/file/0Z1f9lINTNyGVTuDbT3x/convert?cache=true&fit=crop&w=80&h=80
---

On Monday, we announced the first winner of the Timeline Challenge: [Battery+][appstore-link].
Battery+ was created by [Eric Phillips](https://twitter.com/ericphillips0), a
Pebble developer who many may know for his watch timer, Timer+. Twitter has been
abuzz with compliments for Eric, and needless to say, we agree! Battery+ is a
useful, beautifully designed app that gathers data to generate intelligent
battery life predictions.





When you first open the app, you are met with a detailed tutorial that describes
how to use the app, as well as what it can do. Clicking through the lengthy
animation can give you details about what the buttons are used for,
what kind of data the app tracks, and the different ways you can view the data.
If you click through the app, you can get more detailed information, such as the
maximum life of your Pebble and how long it has lasted for.

![](/other/batteryplustutorial.gif)

Once the app begins to track your information, it will begin sending you
timeline pins about when the next charge needs to be.

![](/images/blog/batteryplustimeline.png)

Eric made use of a variety of features to create his app, including the
following:

1. The [Pebble C SDK](/sdk/)
2. The [Background Worker API](/guides/events-and-services/background-worker/)
   to collect battery data continuously
3. The [Persistent Storage API](/guides/events-and-services/persistent-storage)
   to store the collected data
4. [Timeline](/guides/pebble-timeline/) pins to send "Charge by" data to the
   user
5. [PebbleKit JS](/blog/2013/11/21/Using-PebbleKit-JS-Configuration/#what-now)
to store the data on the phone or share on social media
6. [Launch Reason](``Launch Reason``), [Wakeup](``Wakeup``),
   [Clicks](``Clicks``), [Vibes](``Vibes``), and many other APIs!

The attention to detail that Eric shows in this app is amazing. For example,
when you scroll to the end of the graph of your battery life, there is a small
animation and vibration that prevents you from going further. Features like
these impressed us, as it highlighted the thought Eric put in to ensure that
users had a seamless experience with his app.

We talked to Eric to learn more about his journey as a Pebble Developer. Below,
he details why he began Pebble development, the process of creating Battery+,
and hints at some future projects.

### Q&A with Eric

**Could you tell about your experience as a Pebble developer?**

I love to program, and have always wanted to publish my programs for other
people to use. However, most app stores required you to be over eighteen and pay
a registration fee. Pebble's openness was very attractive, and I began
programming for it soon after receiving my Pebble.

Since then, it has been awesome developing. It is really cool to work with such
a small screen, trying to find unique ways to display information, and since
Pebble's store is still relatively young, there is so much potential to be able
to write a popular app!

**What is the story behind Battery+?**

Battery+ actually came from another app I had previously made, "Battery Leak".
The idea behind Battery Leak was to create an app with true background battery
tracking, and it worked fine. However, as time progressed and I learned more, I
kept thinking of better ways to do things, and new features to add.

This is where Battery+ began. I wanted to remake Battery Leak, but in the
process I wanted to have a larger data range (Battery Leak held one week) and I
wanted to have intelligent battery life predictions. Rather than looking at your
watch and seeing that you have 20% of your battery left, and then trying to
figure out if that will make another day, I thought it would be so much better
if your watch could just tell you how many days of battery it has left. This
worked perfectly with the timeline concept, where I was able to insert a
"Charge by" event, complete with a one day remaining alert and some details
about the last charge.

**Could you give us a few more details about the creation of Battery+?**

I began Battery+ much like my other apps, just making something I would be happy
using. However, after I completed the first version, I posted some screen-shots
on social media to get other people's feedback. I was given many great ideas,
and the "Stats" screen and ability to view the data on the phone came out of
this. Later, I found a few beta testers (thanks!), and their feedback was a
tremendous help in making Battery+ more useable.

**What was your favorite part about making the app?**

It's hard to say what my favorite part was... I like optimizing code, and it was
a fun challenge to see how efficient I could make it, but I think my favorite
part was designing the UI. I love making a nice interface, and then seeing what
sorts of little things I can add to make it better. A couple examples of this
would be if you zoom too far in or out in the graph, it gives a little "popping"
animation and pulses the vibrator, kind of like gear teeth being stripped. Also,
in the configuration page, the color theme changes based off what the current
battery percentage is.

**Do you have any other app ideas that you're planning on exploring in the
future?**

I have a few ideas, and I am always looking for suggestions! Right now, I am
working on a sleep/activity tracking app. My goal is to create a simple but
beautiful app, more similarto my Timer+ app than to Battery+ (and yes, it will
have a "+" in its name).

**Anything else you'd like to tell us?**

I think the timeline challenge is a great idea, and I really look forward to
seeing what other people come up with!

![](/images/blog/eric-phillips.png)

### Future Steps

If you'd like to participate in the timeline challenge, you have 11 more weeks
to do so! Check out our [blog](/blog/2015/04/14/the-timeline-challenge-is-live/)
about the Pebble Timeline Challenge,
[FAQ](/blog/2015/05/07/timeline-challenge-faq/) about the Timeline Challenge, as
well as our [guides](/guides/) and [documentation](/docs) to get started with
programming for Pebble.

We're so excited for you to #makeawesomehappen!

[appstore-link]: https://apps.getpebble.com/applications/55197642d6fa6f2633000092

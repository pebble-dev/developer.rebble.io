---
title: Pebble Timeline Challenge Week 4 Winner - Pushbutton 
author: niharika
tags: 
- Timeline
banner: /images/blog/pushbuttonbanner.png
image: /images/blog/ifttt.png
---

The core goal of [IFTTT](https://ifttt.com/) (If This, Then That) is to use the 
Internet to simplify your life, and there is no better device to help with that 
goal than your Pebble! 
[Pushbutton](https://apps.getpebble.com/en_US/application/556111e92ff3b5887c000122), 
the 4th winner of the Pebble Timeline Challenge, works with any IFTTT Do Button 
action to help you create shortcuts for your daily life.



{% alert notice %}
_Update 9th June 2015_

The Pushbutton app is unfortunately no longer available in the Pebble appstore.
{% endalert %}

The options are truly endless: you can set up daily weather reports, create
a way to find your lost phone, put a notification on your timeline everytime 
a stock increases, etc. One of our 
[developers](https://twitter.com/YGalanter/status/603339339658035200) already 
created a hack to use his Pebble and the IFTTT Gmail channel to make a personal 
voice note taker. 

![](/images/blog/dobutton_options.png)

Pushbutton was the brainchild of Collin Fair, a Canadian developer and current 
University of Waterloo student. Here are some of the Pebble features and 
external resources he used while developing the app. 

- [PebbleKit JS](/docs/pebblekit-js) for IFTTT API magic, timeline setup, geolocation
- [Flask](http://flask.pocoo.org/) server for login page, timeline schedule 
management & pin pushing
- [Animations](/guides/graphics-and-animations/animations) 
- [Persistent storage](/guides/events-and-services/persistent-storage/)
for instant launches
- [Basalt Compatible PNG](/docs/c/Foundation/Resources/File_Formats/PNG8_File_Format/)
support for channel icons
- [Timeline app launch_args](``APP_LAUNCH_TIMELINE_ACTION``) for one-click action 
triggering

Read on for a look into Collin's history as a Pebble Developer!

### Q&A with Collin 

**Do you have a background as a Pebble developer?**

Strangely enough, my first experience developing for Pebble was during an 
internship on the firmware team - I was working behind the scenes on PebbleOS 
before I had written my first app! But, it wasn't long till I was drawn in. By 
far, my favourite part of developing for Pebble is pushing the limits of the 
platform, digging into the internals of the SDK and OS to create the perfect 
experience.

**What inspired you to develop Pushbutton?**

I'm a big fan of the idea of IFTTT - not to steal their marketing line, but it
unlocks the true power of the Internet, no programming required. Having that 
power on your wrist just makes sense. Many actions are things that people do 
every day, like emailing someone that they're on their way home: a perfect use 
for the new timeline. And, as people might know, IFTTT support was promised in 
the original Kickstarter back in 2012 - so I thought it was about time that 
promise was fulfilled. 

**Could you tell us a little bit about the creation of Pushbutton?**

The original design placed a much bigger emphasis on the icon of each action - 
after all, why waste that colour screen on boring text? But this ran into 
issues: downloading the large icons over AppMessage, even using the new Basalt 
PNG support, wasn't particularly fast. Furthermore, Pebble UX is all about 
"glanceability" (if that's a word), and if you had more than one SMS or GMail 
action you'd be stuck squinting at the tiny text below the uselessly large icon.
So, I took advantage of the new colour screen to make the action name front and 
centre, still backed by the familiar Twitter blue or Evernote green, solving 
both problems at once.

Of course, since its release I've had many great suggestions to improve the app 
further, so I'm sure I'll keep tweaking things. It's great to see the clever 
ideas people have come up with using the app in the first five days alone!

**Any favorite moments while making the app?**

It's a small thing, but the first time I hit the button on my Pebble and saw 
something actually happen via IFTTT. It wasn't until quite late in development 
that I hooked up the real button-pushing magic, so seeing the final piece fall 
into place was very satisfying. 

**Did you face any significant challenges during the development process?**

The Pebble C SDK does a good job of hiding the trickier parts of embedded 
development, but there are still rough edges to be found. For instance, 
complicated animations can slow down AppMessage transmission - so I had to be 
careful that I wasn't sacrificing an efficient user experience for superficial 
(if cool-looking) animations.

**Is there anything else you’d like to share?**

I'm looking forward to see how everyone else puts the timeline to work - it's 
completely changed how I think about my Pebble.

![](/images/blog/collinfair-pushbutton.png)

### Two Months to Go!

Developers, you have 8 weeks left to secure your spot at the Developer Retreat! 
Don't give up this chance to win awesome prizes and meet the Pebble team.

If you're still stuck about what to make, check our some of our 
[examples](/examples/) and explore our 
[timeline guides](/guides/pebble-timeline) to give you that first burst of
inspiration.

We're so excited for you to #makeawesomehappen!

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)

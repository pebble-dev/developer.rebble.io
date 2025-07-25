---
title: Pebble Timeline Challenge Week 3 Winner - Leaf 
author: niharika
tags: 
- Timeline
banner: /images/blog/leafbanner.png
image: https://assets.getpebble.com/api/file/egpXpvfS3KyYHmEDJxbr/convert?cache=true&fit=crop&w=80&h=80
---

With the rise of the Internet of Things (IoT), the number IoT products has 
increased almost exponentially. Slowly, connections between these devices are 
also being forged. 
[Leaf](https://apps.getpebble.com/en_US/application/52ccd42551a80d792600002c), 
the 3rd winner of the Pebble Timeline Challenge, falls into this latter 
category: the application allows your Pebble to act as a remote control for your 
[Nest](https://nest.com/thermostat/life-with-nest-thermostat/) thermostat from 
anywhere in the world!




Want to come back to a toasty house after a winter vacation? Just bump up
the temperature a few degrees while on your drive back from the airport. Are 
your kids a little too hot at home during the summer? Surreptitiously lower the 
temperature from your wrist while in a meeting. The Leaf application on your 
Pebble integrates with the Nest thermostat to allow you to adjust the 
temperature and manage away, fan, and operating modes. 

![ >{pebble-screenshot,pebble-screenshot--time-black}](/other/leafgif.gif)

Chris Nucci, a Florida based software engineer, was the mastermind behind this 
application, and his attention to detail made this app excel. Here are some of 
the features he used while developing the app. 

- The [Pebble C SDK](/sdk/)
- [PebbleKit JS](/docs/pebblekit-js)
- [Internationalization](``Internationalization``)
- [Logging](``Logging``), [Clicks](``Clicks``), [Vibes](``Vibes``),
  [Timer](``Timer``), [Animations](/guides/graphics-and-animations/animations),
  [Graphics](/guides/graphics-and-animations) and many other APIs!

Chris shared his story with us: read on to learn about his experiences with 
Pebble development. 

### Q&A with Chris 

**Could you tell us a bit with your experience as a Pebble developer?**

I’m a total believer in the open platform model.  I feel that it benefits both 
the platform and user base more than a closed platform ever could.  Pebble has 
it nailed in all aspects: the SDK, documentation, CloudPebble, forums, community
libraries and resources, beta programs, and last but not least, the close, 
personal support of their developers.

**What spurred you to create Leaf?**

I like to joke that I write software to enable me to be lazy. While that doesn’t
exactly hold up since I probably only save a few milliseconds of my life for 
every hour I spend developing, the Leaf app is the ultimate example of this.  In
a nutshell, not only did I not want to have to get up from the couch to adjust 
the thermostat, I didn’t even want to sit up to reach for my phone on the coffee
table.  So, it seemed like the Pebble was the perfect place for it.

I wasn’t the first to come up with this idea though.  There was an early version
written with version 1 of the SDK, but it required an iOS companion app.  When 
SDK 2 came out and included the JavaScript framework, I knew I could make a more
universal version.

This is actually my first Pebble app.  I skipped the obligatory “hello world” 
and went straight for it!
 
**Could you tell us a little bit about the development of Leaf?**

The initial versions of Leaf were available before the official Nest API was 
released, so it actually used an API that someone else reverse-engineered to 
access data and control the thermostats. It eventually worked alright, but it 
initially took a lot of trial and error to figure out the correct commands to 
send.

Things really went into high gear once the official API came out and Thomas 
Sarlandie contacted me to help foster a relationship directly with Nest.  I 
switched to using OAuth2 and a Firebase JS client to handle communication with 
Nest and redesigned the UI for the third time to be compliant with Nest’s design
guidelines.

**What was your favorite part about making the app?**

My favorite part was and still is finding new features to add. I love looking at
APIs, imagining the possibilities, and bringing them to life.  It’s all worth it
when I get the random email from a user stating how much he or she likes the 
app.

**Were there any significant challenges you faced?**

Generally, the most difficult thing is managing memory and being efficient with 
data, but I enjoy that challenge.  When the app closes and the log window says 
there are 12 bytes left allocated, you can be sure I’m diving back in to find 
them.

**Are you working on any other projects that you'd like to talk about?**

I’m currently working on adding Nest Protect support to Leaf and that should be
ready by the time everyone starts getting their Pebble Times.  Also, I’ve 
started working on another home automation app for the SmartThings platform.

Maybe I’ll save some more milliseconds!

**Anything else you’d like to tell us?**

Just thank you, Pebble!  And thanks to the other developers out there doing 
amazing things that we get to take advantage of!

![](/images/blog/chrisnucci-leaf.png)

### 9 More Weeks!

With over two months left in the challenge, there is still plenty of time to 
participate! If you already have an idea, open up
[CloudPebble]({{site.links.cloudpebble}}) and have some fun. If you don't 
know what to work on yet, don't worry! Browse our 
[timeline guide](/guides/pebble-timeline/), check out the
[examples](/examples/), and have fun exploring.

As always, if you have any questions, use our [contact form](/contact/) to get 
in touch with us. 

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)


---
title: Pebble Timeline Challenge Week 5 Winner - Flights 
author: niharika
tags: 
- Timeline
banner: /images/blog/flightsbanner.png
image: https://assets.getpebble.com/api/file/8c8LYNH7Qve4QdATgPgn/convert?cache=true&fit=crop&w=80&h=80
---

We've all been there at some point: you've just sprinted through the airport, 
rushed through security, and ended up breathless at your gate just to find out 
that your flight has been delayed for two hours. Well, with 
[Flights](https://apps.getpebble.com/en_US/application/555a8efcae067d58f800004d)
on your wrist, you'll never miss another flight notification again! 





Get real time notifications about your flight status right on your wrist: just 
last week, one of us from Team Pebble enjoyed live updates about a delayed 
flight. Flights informs you of delays, terminal and gate numbers, baggage claim 
location, local arrival time, and much more! After you connect the app with 
[TripIt](https://www.tripit.com/) or add your individual flights manually, sit 
back and let the app figure out the details for you. 

Ronny Carr devoted his last few weeks to this app, and was able to use a variety 
of Pebble features and external APIs in his application. 

- The [Pebble C SDK](/sdk/)
- [PebbleKit JS](/docs/pebblekit-js) for timeline integration
- [Animations](/guides/graphics-and-animations/animations/) 
- [Persistent storage](/guides/events-and-services/persistent-storage/)
for instant launches
- [Timeline app Launch Reason](``APP_LAUNCH_TIMELINE_ACTION``) 
- The [Kayak](http://www.kayak.com/) API

Below, Ronny tells us a little bit about himself, and why he decided to join 
the Pebble developer community. 

### Q&A with Ronny 

**Why did you decide to become a Pebble developer?**

I bought my first Pebble just this past November, opted for the Steel. 
Immediately fell in love with every aspect of the experience. It’s hard to 
ignore the lively developer community that surrounds the Pebble. As a developer 
myself, the interest was pretty high in creating my own watch face. Selenia was 
my first go at programming in C, and to my delight, a success! After that, I had
the confidence to start working on an app to keep tabs on the status of my 
SmartThings controlled apartment. Dwelling came to fruition within a couple of 
days and only fueled the development fire further. Flights was started the next 
day.

**Why Flights?**

I wanted to take full advantage of the timeline with my next app. Honestly, I 
had looked through the list of timeline icons about 100 times and the cute 
little airplane kept jumping out at me. I knew this was one of the most obvious 
uses of the timeline, and really wanted to bring it to life. I love traveling 
and I love data, win win.

**Could you tell us a little bit about the creation of Flights?**

Flights has been a focus for a couple of weeks now. A few all nighters, and 
maybe an hour or two at the office ;). At first the challenge was finding a data
source, basically two exist and they are not free. A major focus from the 
beginning was to limit the API hits as much as possible by storing the flight 
data and updating it on a schedule. I worked on one small aspect at a time, 
nothing was connected and certainly didn’t work. Slowly connecting the pieces 
together and building out the data was the most involved portion. With only a 
limited idea of what I wanted out of the app, most decisions were made while 
coding. Every corner rounded pretty much led to another "oh yeah, that" kind of 
moment. The most rewarding point during development was the first time I sent a 
pin to my timeline with real flight data. I couldn’t stop smiling.

**What were some of the challenges you faced during the development process?**

Developing Flights was, a challenge to say the least. One of the biggest 
differences in personal projects and work projects, there’s no team of 10+ 
people working on all the different aspects of development. As a developer it’s 
sometimes hard to stand back and see the larger picture of a project, which is 
why we are handed PSDs and specs.

**Is there anything else you’d like to share?**

I’ve continued making improvements to Flights with no plans to stop. I’ve got a
few great things in the works and am excited to get them out for everyone to 
enjoy. A full Flights app is also planned, and is in early development. With a 
great set of tools, an amazing community, and incredible support, I can only 
look forward to my next project for the Pebble.

### Seven Weeks Left!

With a little under 2 months left in the challenge, we encourage you to dive 
right in. Take a look at our previous winners below, fire up 
[CloudPebble]({{site.links.cloudpebble}}), and show us what you've got! We've got
a fabulous set of prizes waiting for you: don't miss out!

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)
- Week 4: [Pushbutton](/blog/2015/05/29/timeline-challenge-week-four/)

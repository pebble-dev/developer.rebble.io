---
title: Pebble Timeline Challenge Week 6 Winner - Meetup! 
author: niharika
tags: 
- Timeline
image: https://assets.getpebble.com/api/file/0hhl54GbT8OIbcVxf6m1/convert?cache=true&fit=crop&w=80&h=80
---

We've recently formed our 21st [Meetup group](http://pebble.meetup.com/), 
and are so excited that Pebblers around the world are meeting, sharing ideas,
and making awesome happen! Now, with the 6th winner of the Pebble Timeline
Challenge, you can keep track of the Pebble Meetup group as well as other local 
groups. View nearby Meetups and get event specific information such as 
the location and time: all in one informative timeline pin!




![ >{pebble-screenshot,pebble-screenshot--time-black}](/other/meetup.gif)

Meetup's creator, Matt Langlois, is one of our most active developers, 
and has definitely made his mark on the Pebble community! With his contributions
to Pebble.js, active participation in the Pebble Slack room, 
and organization of 
[Pebble hackathons](http://www.meetup.com/PebbleOTT/events/222726467/), he has 
proved that is he an extremely loyal developer. Here are some of the many 
features he used to create Meetup. 

- The [Pebble C SDK](/sdk/)
- [PebbleKit JS](/docs/pebblekit-js) to communicate with timeline
- [Timeline API](/guides/pebble-timeline/) to design the UI
- [PHPebbleTimeline](https://github.com/fletchto99/PHPebbleTimeline) to send 
events to the timeline from the server side 
- [Meetup API](http://www.meetup.com/meetup_api/) Node.js API to communicate 
with Meetup's open events stream
- A custom designed PHP backend to communicate with the watch

Read on to learn about Matt's story!

### Q&A with Matt 

**Tell us a bit about your experience as a Pebble developer.**

Developing for the Pebble has been nothing less than an awesome experience! I 
got my red Pebble original as a Christmas present last year and as soon as I got
it I wanted to start developing for the platform. Over the summer I started 
working on my first app, 
[uOttawa Card Manager](https://apps.getpebble.com/en_US/application/5468365c32e2d70d26000095),
which would allow me to view my meal plan balance at the uOttawa. Unfortunately, 
at the time I did not know how to code in C so I went for their Pebble.js option 
instead and in a few hours I had myself a working app. I was quite pleased with 
the system to publish my app: I submitted it to the app store and within a few 
minutes I was able to share it with my friend who also had a Pebble. For a few 
months I was a lurker on the Pebble IRC channel but then the 
Pebble Slack community was introduced, allowing me to 
easily communicate with other developers and Pebble engineers.

**What motivated Meetup?**

A few months after the creation of my first Pebble app, an Ottawa Pebble Meetup 
group appeared. This gave me the idea to make Meetup. It started out quite 
simple, only listing the upcoming events for the group in Ottawa. I showed off 
this concept at our first Meetup and I received plenty of feedback and 
suggestions to improve it. After many late nights (one of which I accidentally 
committed my Meetup API key to github during, whoops!) the Meetup 1.0 was born. This 
first version contained the few core features that were required to make my app 
universal.

**Tell us about the creation of Meetup.**

Making Meetup as versatile as it is today was no easy task, but I wasn't about 
to let any challenges get in my way. I started off creating the second 
iteration, the one which was submitted to the Pebble Timeline Challenge, by 
writing a complex server backend in PHP to manage all of the various tasks. This
API now runs all of the functionality the app offers today, from searching for a
pebble event to looking for the nearest Photography group. All requests run 
through the API and get sent back to the watch in a clean format which can then 
be easily displayed. 

Introducing timeline functionality had its own set of 
hurdles because I needed to implement a way to send the user timeline pins if 
they have subscribed to a group. I achieved this through the creation of a Node 
script which maintains constant communication with Meetup.com and my Pin API, so
when a new event is pushed I check which users are subscribed to the specific 
group or have already pinned it to their timeline, and then send it to their 
watches. 

During the creation of the timeline aspect I created PHPebbleTimeline 
which allows developers to easily access the timeline API through PHP. The final
step, and hurdle, to meetup was to introduce colors. Unfortunately at the time of 
creation, Pebble.js didn't support colors and I didn't want to bug Meiguro with 
another feature requst for Pebble.js. So instead I forked it on GitHub and 
learned a bit of C to implement the color support in menus, which now exists in 
Pebble.js. It was a great learning experience, even though it didn't require too 
many changes. 

**What were some of the challenges you faced while developing?**

The biggest hurdle in the creation of Meetup was finding time to improve upon 
the original app. I had so many ideas to add to the app, but it was the middle 
of exams so I had to put development on hold for a few weeks. As soon as exams 
finished I worked for about a week implementing timeline support so I could have
it tested on real Pebble time instead of the emulator. It wasn't perfect when I 
had Cherie testing it at our Meetup, but basic event pins were working! I was 
quite pleased with the progress I made in the few months I had to work on the 
app. Now Meetup supports a wide range of features, including searching for 
non-pebble groups and events.

**Do you have a favorite moment from when you were developing?**

The best part about developing this app is that I have been able to explore 
multiple programming languages while still making something useful. Most of my 
life, and all of my school career I have been programming in Java. Through the 
creation of Meetup I have been able to use NodeJS, MySQL, PHP, Javascript and 
have them all interact with each other to create a simple yet functional app. 
Ultimately I hope to further expand my knowledge and write Meetup in Pebble's 
native language, C.

**Are you working on any other projects that you'd like to talk about?**

Other than improving my most recent app, 
[Devboard](https://apps.getpebble.com/en_US/application/556bbaf730850a5fab000089),
I don't really have too many ideas for future apps. I'll be keeping an eye out 
on the Reddit page to see if anyone has any requests and probably just focus on 
improving the ones I've got out already. I'm also hoping to contribute more time
to improving Pebble.js.

**Any advice for other Pebble developers?**

I'd like to encourage other developers not to give up. I was planning on 
stopping creation of Meetup but in the long run it's paid off. I'm glad so many 
people seem to enjoy the app! If you're ever looking for some development help 
you can find me along with many other developers in the Slack group!

![](/images/blog/mattlanglois.png)

### Six Weeks to Go!

Itching to become a Pebble developer? It's easy! Fire up 
[CloudPebble](https://cloudpebble.net/), join our amazing 
[online community]({{ site.links.discord_invite }}), and #makeawesomehappen. Keep submitting
your work to the Pebble Timeline Challenge: we have 6 more weeks of awesome 
prizes, swag, and opportunities! 

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)
- Week 4: [Pushbutton](/blog/2015/05/29/timeline-challenge-week-four/)
- Week 5: [Flights](/blog/2015/06/05/timeline-challenge-week-five/)
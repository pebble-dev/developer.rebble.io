---
title: Guest Post - Beating Traffic with Clouds and Pebbles
author: katherine
tags:
- At the Pub
image: /images/blog/guestblogdries_icon.jpeg
---

*This is a guest post by Dries Oeyen, developer of the Pebble app [Commute](https://apps.getpebble.com/applications/564f706e86b141be60000081) and Rockstar of Belgium's Pebble Developer Meetup, [PebbleBelgium](http://www.meetup.com/PebbleBelgium/).*

Hello everyone. I'm [Dries Oeyen](http://nexworx.com) and I live in Belgium, a tiny country in Europe. In case you're wondering what Belgium is like: in the morning on weekdays, it looks roughly like this:



![Traffic jam in Brussels](/images/blog/guestblogdries_belgium.jpg)

Joking aside, traffic really is terrible here. Depending on a multitude of factors, my trip to work can take anywhere between 35 minutes and an hour. Firing up the Google Maps app every morning to check traffic conditions quickly became routine, but Maps is a big and kinda clunky app for this use-case. I only wanted to know when to hop in the car in order to arrive at work on time, and whether to take the highway or the backroad. More importantly: I wanted this information in a glanceable format, right at my fingertips. One day, as I was stuck in traffic once again, I looked at the Pebble on my wrist to check the time. And then it struck me.

## Build it...
That night when I came home, I opened my code editor and I got to work. At that point, I had some limited experience with the Pebble SDK: I had written a basic Pebble.js app in 2014, which I then ported to the C SDK after taking a conveniently timed C class at school. However, this time I wanted to spice things up with a completely custom interface. Thankfully, Pebble's documentation is truly fantastic and somehow makes writing C a breeze (really!). I quickly got the hang of how to use Pebble's UI APIs, and before too long I shipped the first version of my new app. [Commute](https://apps.getpebble.com/applications/564f706e86b141be60000081) was born.

<blockquote class="twitter-tweet" lang="nl"><p lang="en" dir="ltr">Strong start for Commute! Well over 100 users in just 12 hours. Happy with the adoption! :) <a href="https://t.co/dYOvptAYDa">https://t.co/dYOvptAYDa</a> <a href="https://t.co/jMkbLiz09r">pic.twitter.com/jMkbLiz09r</a></p>&mdash; Dries Oeyen (@DriesOeyen) <a href="https://twitter.com/DriesOeyen/status/669118468587933700">24 november 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## ... And they will come
At this point, the app achieved my initial goal of providing instant, glanceable insight into traffic conditions. I posted a thread on Pebble's subreddit, [/r/pebble](https://reddit.com/r/pebble), that helped Commute attract a healthy 100 users within the first 12 hours of going live.

I was obviously thrilled to see the app gain traction, but not just for the typical reasons one might expect. I had a second, more exciting goal for Commute: telling users when to leave for work in order to arrive right on time, by sending predictive timeline pins to their watches. Having a sizable group of early adopters from all over the world was a great opportunity for setting up a test group that would help me discover edge-cases as I developed the timeline algorithm. In fact, thanks to some planning ahead I already had the app collecting users' timeline tokens, so I could start deploying the feature to a test group transparently – no app update required.

## Integrating with Pebble Timeline
I knew integrating Commute with Pebble Timeline represented a major challenge. Both Google App Engine and the Google Maps API come with free quota, but in the end they're very much finite resources. Keeping in mind the growing number of users, it became clear that I'd need to think about scaling.

It was time to set up some constraints. My biggest priority was aggressively limiting the number of API calls to Google Maps, since you only get 2500 daily requests within the free tier. Doing the math, I quickly realized that the only way to pull this off was to use just a single Maps API request per user per trip. This represented a conundrum in terms of when exactly to perform said request: the later you fetch, the "fresher" the data, but you need to leave enough time to account for longer-than-usual traffic delays and the variable latency between a pin being sent and it appearing on the user's timeline. Using multiple requests, it would be possible to "hone in" on the ideal time to send a pin or to update it as fresher information becomes available, but using a single request per user per trip meant the algorithm had to be intelligent about when to perform said request.

The solution I came up with is keeping track of the average home-to-work and work-to-home travel times for each user. Every time a pin is sent to a user, these statistics are updated, thus improving the timing of the next pin. This ensures increasingly well-timed pins with sufficiently fresh data, all while putting minimal strain on my App Engine resources. I also limited the load on my datastore while periodically checking who needs to receive a pin: instead of cycling through every user every time the cron job runs, I wrote a heavily optimized 68-line filtering query that only selects likely candidates. Yeah, I know. Cloud development is weird sometimes. Luckily, seeing the result in action proved that it was worth it.

![Commute timeline pin and reminder](/images/blog/guestblogdries_pins.jpg)

## Testing and scaling timeline pins
With all of the hard work done (or so I thought), I turned to my test group to see if everything worked as expected. As it turns out, that was a good call. What followed was a streak of about 30 bug fixing commits. Timezones are hard! I'll let these commit messages speak for themselves:

* Fix scenario where pins could have the wrong date
* Fix exception if arrival/departure is next day
* Prevent division by zero while parsing directions
* And my personal favorite: Don't send timeline pins during weekends

Right before Christmas, Commute hit a big milestone: 1000 users. Meanwhile, I had been scaling up the test group as I squashed bugs. Since I was now sufficiently confident that the system worked as intended. I decided to celebrate by flipping the switch.

<blockquote class="twitter-tweet" lang="nl"><p lang="en" dir="ltr">Commute for <a href="https://twitter.com/Pebble">@Pebble</a> now has over 1000 users! To celebrate: timeline integration for all! 🎉 <a href="https://t.co/I7xhXq0bzv">https://t.co/I7xhXq0bzv</a> <a href="https://t.co/yUhJSBkRRz">pic.twitter.com/yUhJSBkRRz</a></p>&mdash; Dries Oeyen (@DriesOeyen) <a href="https://twitter.com/DriesOeyen/status/679229126352486400">22 december 2015</a></blockquote>

## What's next
Commute has been growing at a steady clip since the end of 2015: there are now over 1500 people using the app. Even though all my optimizations went a long way, the service is on track to outgrow its free quota on several points. Therefore, my goal for 2016 is to launch some great premium features so Commute can become self-supporting. Either way, I'm incredibly grateful to be in a situation where I have such a luxury problem in the first place! Commute is a place where I can experiment and have fun, all while (hopefully) helping people steer clear of heavy traffic.

Having had such a great experience developing for Pebble, I decided to get involved in something else as well. I had always been jealous of the various Meetup groups abroad, since it seemed like a ton of fun to meet up and share ideas and experiences with fellow Pebble developers. Interestingly, a fellow Belgian Pebble enthusiast apparently had the same idea, so we teamed up to become organizers of the Pebble Belgium Meetup group.

[![Pebble Belgium Meetup](/images/blog/guestblogdries_meetup.jpg)](http://www.meetup.com/PebbleBelgium/)

Are you interested in Pebble development and do you happen to live in Belgium? We'd love to meet you! Our first event is planned for February 17 in Brussels and will involve talks, drinks and bites, socializing and some neat Pebble swag, all in a relaxed atmosphere. Both experienced Pebble developers and interested newcomers are welcome, we'll have something to offer regardless of your existing Pebble development experience. RSVP here: [http://www.meetup.com/PebbleBelgium/events/228117357/](http://www.meetup.com/PebbleBelgium/events/228117357/).

Hope to see you there!
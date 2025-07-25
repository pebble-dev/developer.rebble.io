---
title: Timeline Spotlight - Hackawatch
author: niharika
tags:
   - Timeline
banner: /images/blog/hackawatch.png
---

Hackathons are packed with tutorials, tech talks, and demos, and it’s simple for
important activities to sometimes slip through the cracks. However, thanks to
[Hackawatch](http://challengepost.com/software/hackawatch), Pebblers will never
 miss an event at a hackathon again! Hackawatch is a Pebble application created
at LA Hacks that allows hackathon organizers to push pins to hackers’ timelines
to notify them about important events.





1. **Who**: 3 Arizona State University students: Jack Ketcham, Tim Kaing, and Tim Horng.
2. **What**: Hackawatch, a Pebble application that allows hackathon attendees to see
important events during the hackathon on their timeline.
3. **Where**: LA Hacks 
4. **When**: April 3rd- 5th
5. **Why**: The team is going to be organizing their own hackathon during the fall of
2015, Desert Hacks, and thought it would be a useful application to have in place
during their event.
6. **How**: Using the [guides](/guides/), [documentation](/docs/), and 
[blog posts](/blog/2015/03/20/Getting-Started-With-Timeline/) online!

##Q&A with the Hackawatch Team

We recently talked to these first time Pebble hackers, and got their story.

**How did you get started with your project?**

When we started setting up the project and needed to learn more about developing
on the Pebble, the first place we went to was Pebble's developer site, and we
looked through the relevant documentation for Pebble C and PebbleKit JS, as well
 as the guide for the timeline.  In addition, we found the Pebble examples on
 GitHub to be very helpful, both the regular Pebble C examples and the new timeline
examples.

**Why did you decide to use the timeline interface?**

We decided we wanted to use the timeline interface because we felt it was exactly
 what we needed to solve our hackathon event feed problem for attendees, and also
 because we found out about it through all of us pre-ordering the Pebble Time. We
 thought it would be great to build something we would be using ourselves in just
 a couple months. Not to mention, we also thought it would be the best thing to
hack on since it's one of the newest API features and something that all Pebble
watches would have eventually anyway.

**Which frameworks did you use for your project?**

I used the native SDK emulator on my MacBook Pro to test out the app as we were 
developing it, and we used PebbleKit JS running on the user's phone to retrieve 
the user's timeline token as well as our own NodeJS API. Further, we would send 
HTTP requests to our API, sending along the user's timeline token and their 
preferences for what they wanted to subscribe to so we could use the 
[pebble-api-node module](https://www.npmjs.com/package/pebble-api) on our end.

Also, when I was working on implementing the 
[pebble-api-node module](https://www.npmjs.com/package/pebble-api) in our backend, 
I also found some missing API functionality.  At the hackathon, I was able to add 
the functionality (deleting user pins) with appropriate tests and submitted a pull 
request, which got merged in shortly after the event!

**What was the hardest part about making the app?** 

I'd say the hardest part about developing the app was ramping up on the Pebble C 
library for creating the user interface on the Pebble, because it was a new API for 
us and none of us had any prior experience writing C.  Again, to combat that, we 
looked at the available documentation and examples, and also got help from the Pebble
 Engineers that were on site throughout the hackathon (they were awesome!).

**What was your favorite part about making the app?**

I’d say the best part about developing this app would be gaining experience developing 
on Pebble's newest API.  This is the next big move for the company and for the people 
that own these watches, and being able to be a part of that and show what we can make 
with the new functionality is really amazing.

##Future Steps

Hackathon organizers, take note! The story hasn’t ended here for Hackawatch. The team 
is going to continue adding functionality to their app: soon, they want to have an 
RSVP action for certain activities or tech talks. Their ultimate goal is to make it 
as easy as possible for any other hackathon organizers to fork the project into their 
own repo and adapt it for their event. 

##Inspired to Start Hacking on Pebble?

Follow the Hackawatch team’s lead and hack your heart out! We have tons of 
[guides](/guides/) and [documentation](/docs/) online that are perfect for first 
time hackers. If you want to share your project, enter it into the 
[Timeline Challenge](/blog/2015/04/14/the-timeline-challenge-is-live/)! 
For the next twelve weeks, we’re going to be giving out free Pebble Times, swag, and 
prizes, so fire up [CloudPebble]({{site.links.cloudpebble}}) and hack away! 

##Want to Hang Out with Pebble?

If you’re going to be in San Francisco next week, come to our
 [Meetup](http://www.meetup.com/PebbleSF/events/221717043/)! We’ll be talking 
specifically about timeline and all the cool features that come with it. Otherwise, 
keep an eye on our [Events](/community/events/) page to figure out where we’ll be 
soon. We have a busy few months coming up, and want to see as many Pebblers as 
possible. We can’t wait to meet you! 

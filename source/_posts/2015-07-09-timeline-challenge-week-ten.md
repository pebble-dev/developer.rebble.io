---
title: Pebble Timeline Challenge Week 10 Winner - 8-A-Day! 
author: niharika
tags: 
- Timeline
banner: /images/blog/8-a-day-collage.png
image: /images/blog/water-glass.png
---

Doctors have been telling us this for years: drink 8 glasses of water a day,
preferably more. Now, with the 10th winner of the Pebble Timeline Challenge, 
[8-A-Day](https://apps.getpebble.com/en_US/application/5544c004946ce2b650000037),
you can have your Pebble remind you instead! Get pinged hourly, and use your 
timeline to stay healthy and hydrated. 



At 9 AM in your local time zone, you'll receive a notification reminding you to 
drink your first glass of water. You can input whether or not you've finished a
glass, or choose to stop the notifications. If you continue receiving 
notifications, a pin will appear in an hour reminding you to continue drinking
water. This pattern will continue throughout the day, and at the end of the day 
you'll receive a summary of your daily water intake. 

An Australian developer, Stephen Rees-Carter, developed this app after 
conversations with his wife about the idea. A web developer by training, he was
excited to use his PHP skills to create an app for the timeline. Here are some
of the features he used in his application. 

- [Timeline](/guides/pebble-timeline/) for reminders, notifications, and updates
- [PebbleKit JS](/docs/pebblekit-js/) for external API calls
- [PHP API Wrapper](https://github.com/valorin/pinpusher) 
- An external PHP Application for logging and reminding the user 

Read on to hear more about Stephen and his app. 

### Q&A with Stephen 

**Tell us about your experience with Pebble development.**

It's been surprisingly easy to pick it up. A few months ago I hadn't even 
touched a Pebble, let alone done any Pebble development! I loved the idea of the 
timeline when the kickstarter campaign was launched, so I backed it, and when 
the timeline challenge was announced I thought to myself: I'm a web developer, 
why not give it a go, and so I did. The C proved to be the hard part, since as 
I'm a PHP developer, it proved to be frustratingly basic, but the Javascript was 
familiar territory. That said, getting my head around the split between C on the 
watch and JS on the phone took some effort, but once I got that sorted, it was 
good fun, and the SDK and CloudPebble made things easy.

After I completed 8-A-Day, I had an idea for a multi-player game built within 
the timeline,
[Timeline Tag](https://apps.getpebble.com/en_US/application/5551e85defff0cc943000026). 
As I'd already built my infrastructure for 8-A-Day, it took very little effort 
to build the game and get it live - which I was pretty happy about, and it shows 
how easy it is to get an app going.

**What is the backstory behind 8-A-Day?**

My wife and I were learning Android development when I decided to go for the 
challenge, and she had a great idea for an Android app that reminds you to drink 
water throughout the day... so I shamelessly stole it, as I thought it'd be an 
awesome idea for a Pebble Timeline app. It turns out that it works really well 
in the timeline, and a number of the issues that we were having with that 
Android app were non-issues in the timeline. For example, it's easy to go back, 
or forward, in time to find a notification when you have another drink - 
something you can't with a traditional Android notification.

**Tell a bit about the creation of 8-A-Day.**

I figured that since the timeline API is a web based system, it would make sense 
for me to build a simple PHP API server (using Laravel's Lumen, for those that 
are interested) to power the app. This turned out to be a good decision, as I 
only had to do minimal work on the C and JS parts of the Pebble app - most of 
the logic is actually in my PHP app, which was easier for me to work with, and 
it meant I was able to spend more time optimising the look and feel of the 
timeline pins.

Once I had a working app and server, the next step was testing... If you've ever 
worked with an app that has to fire notifications at specific times of the day, 
and handle repeating notifications within a specific time window, you'll know 
it's really, really hard to test! You have to spend days just watching and 
remembering what you've done with the app to make sure it's doing what it's 
supposed to be doing. It's worse when you're stuck using an emulator, and you 
need to leave your computer frequently during the 11 hour window that the app is 
running.

**What were some challenges you faced?**

I faced two challenges with 8-A-Day. The first one was dealing with timezones. 
The timeline API accepts pins with UTC timestamps, however 8-A-Day creates pins 
at 9am and 8pm in the local time of the Pebble. After a bit of searching I found 
a way to get the minute offset amount, and now every request to my server 
contains the offset so the server can figure out what timestamp to use. 

The second challenge was getting the watch to communicate with the phone (well, 
emulator, at the time) as it only seemed to work occasionally. After some 
searching, I found a suggestion to send a ping from the phone to the watch to 
let it know when it's ready. Once I implemented this, everything else fell into 
place.

**What was your favorite part about making the app?**

Since 8-A-Day relies on my server, I was able to tail the logs and watch what 
was happening. I was ridiculously excited when after publishing the app in the 
store, people actually started installing and using it! I went to bed the first 
night after publishing it, and woke to find a number of new users had installed 
it. I have since heard from a number of people who love 8-A-Day and find it 
useful. That's by far my favourite part of making the app.


**Any other applications or projects that you'd like to talk about?**

I'm planning on an advanced version of 8-A-Day that allows you to create multiple 
reminders for different things, and configure specific daily targets and 
start/end times. For example, if you have to take a specific medication 4 times 
a day, you could configure it to remind you to take your tablets AND drink water 
throughout the day. :-)

I'd also love to explore ideas around multi-player games/social apps within the 
timeline, expanding on the concept I've played with in my Timeline Tag game. So 
rather than simply interacting with a random number generator, your actions 
influence what other players receive on their Pebble.

**Anything else you’d like to tell us?**

I just wanted to finish up by saying that I love the concept of the timeline. 
It's the perfect companion to the watch form factor, and I'm always interested 
to hear about apps that are using it - especially some of the more creative and 
out-of-the-box ideas like the 
[Pokedex Challenge](https://apps.getpebble.com/en_US/application/5570838dddc5cc8060000012). 
It's really easy to build timeline apps, so if you have any creative, or crazy 
ideas, go for it! :-)

![](/images/blog/stephen-rees-carter.png)

### 2 Weeks! 

The Pebble Timeline Challenge is almost over! With only two weeks left, you 
don't want to delay your participation any more. 
[Publish](https://dev-portal.getpebble.com/) your apps, 
[submit](https://docs.google.com/forms/d/1chfXdxYy1vsu9s_qLzpvqveJ6UiVuiALLScCumIWHL0/viewform?c=0&w=1)
your entries, and **#makeawesomehappen**.  

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)
- Week 4: [Pushbutton](/blog/2015/05/29/timeline-challenge-week-four/)
- Week 5: [Flights](/blog/2015/06/05/timeline-challenge-week-five/)
- Week 6: [Meetup](/blog/2015/06/12/timeline-challenge-week-six/)
- Week 7: [Greeney's Run](/blog/2015/06/18/timeline-challenge-week-seven/)
- Week 8: [Pokedex Challenge](/blog/2015/06/25/timeline-challenge-week-eight/)
- Week 9: [Tideline](/blog/2015/07/02/timeline-challenge-week-nine/)

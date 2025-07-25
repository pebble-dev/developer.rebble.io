---
title: Pebble Timeline Challenge Week 2 Winner - FitCat 
author: niharika
tags:
    - Timeline
banner: /images/blog/fitcatbanner.png
image: https://assets.getpebble.com/api/file/3X6ZSHBASbn6QBn4U0Ys/convert?cache=true&fit=crop&w=80&h=80
---

Has anyone been missing their Tamagotchi pet lately? If so, your prayers have 
been answered! Meet 
[FitCat](https://apps.getpebble.com/applications/552f63b406bedce1700000bb): the 
“funniest way to live an active life.”




FitCat is a watchapp that combines fitness tracking and a virtual pet to spur 
you to lead an active lifestyle. Gnocchi, your pet cat, lives his life the 
way you do: when you're walking, he's walking, and when you're relaxing, he's 
relaxing. Being active is rewarded in Gnocchi's world: physical activity earns 
you money that can then be used to buy gifts and toys for Gnocchi. The healthier
your lifestyle is, the happier your pet is! 

This watchapp's range of features impressed us immensely, and 
set this app apart from the rest. For example, there are day and night 
environments for Gnocchi, a mini game inside the app itself, and different 
animations for Gnocchi's behavior. If you want to gamify your fitness tracking, 
you can! You can set a daily step goal, set timeline pins to notify you about 
your progress, and see your fitness acheivements.

![](/images/blog/fitcatpicture.png)

FitCat was created by [Paul Bouillon](https://twitter.com/paulkubgames), a 
French software engineer. Paul utlized a number of Pebble features:

- The [Pebble C SDK](/sdk/)
- [PebbleKit JS](/docs/pebblekit-js)
- [Timeline](/guides/pebble-timeline/) pins to inform user about daily step 
acheivements.
- [Background Worker API](/guides/events-and-services/background-worker)
for background step counting and opening FitCat when a step goal has been 
reached.
- The [Persistent Storage API](/guides/events-and-services/persistent-storage)
  to store the fitness data.
- [Launch Reason](``Launch Reason``), [Clicks](``Clicks``), [Vibes](``Vibes``),
  and many other APIs!

To learn about the creation of FitCat, we interviewed Paul. Read on to learn 
more!

### Q&A with Paul 

**Was this your first experience as a Pebble Developer?**

FitCat is the second app I created as a Pebble Developer. I developed a first 
app called 
[Match’em](https://apps.getpebble.com/applications/5433de4b79b9e561ea00002b) 
when I received my Pebble Steel last year. It is a simple game that I made while
learning how to use the Pebble SDK. Then, when the Pebble Time was announced, I 
got motivated to develop something more ambitious: FitCat.

**Could you tell us a little bit about the story behind FitCat?**

It started after two of my relatives got activity trackers. As I was looking at 
them I thought it was a really good idea to have a device that tracks your daily
activity. I then remembered those small devices with virtual pets I used to love
as a kid, and it made me want to create something that could combine both: an 
activity tracker that would be fun to use. Since everyone loves cats, this is 
how FitCat came up.

**Could you tell us a bit about the creation of FitCat?**

I wanted to do something that people would enjoy using as much as I would. So at
first, there had to be a background activity tracker, and cool environments and 
things to do for Gnocchi, the cat. But the more I worked on it, the more I 
wanted to improve it, by adding features such as timeline notifications or day 
and night variations when the cat is outside… I still have  a lot of ideas in 
mind, be prepared to see cool new features in the next updates!

**What was your favorite part of making the app?**

I really enjoyed developing FitCat. My favorite part about making the app would 
be when I was working on how to draw the environment and the different 
animations of the cat. I was really excited when I first saw the cat walking in 
front of the environment, even if it was on the emulator. When I am developing 
an app, I find it really cool to see how the thing I originally had in mind 
turns into on the screen.

**Do you have any other ideas that you're planning on exploring in the future?**

Yes, I do. The only thing I can say right now is that it will be a game that 
will take full advantage of the Pebble Time’s color screen. I have not begun its
development but it should come soon. I also plan to update my first game, 
Match’em, with new features.

### 10 Weeks to Go

If you're feeling inspired, make your own Pebble project! Get started with our 
[guides](/guides/) and [documentation](/docs/) online, and make sure to submit 
your application to the 
[Pebble Timeline Challenge](/blog/2015/04/14/the-timeline-challenge-is-live/).

We can't wait to see what you create!

### Past Winners 

Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)

---
title: Pebble Timeline Challenge Week 8 Winner - Pokedex Challenge! 
author: niharika
tags: 
- Timeline
banner: /images/blog/pokedex_collage.png
image: https://assets.getpebble.com/api/file/cLf8UecrTUWnBLYQ1jDs/convert?cache=true&fit=crop&w=80&h=80
---

Pokemon fans are going to love the 8th winner of the Pebble Timeline Challenge, 
[Pokedex Challenge](https://apps.getpebble.com/en_US/application/5570838dddc5cc8060000012)!
Have a blast catching the wild Pokemon as they appear in your timeline, and 
become a champion by completing the Pokedex. 






Mathew Reiss, an active Pebble developer and fan, created this 
detailed application. Users have multiple options, such as seeing each Pokemon's 
height and weight, navigating to their Trainer Card, and seeing their Pokedex 
progress. Here are some of the features Mathew used to make his app a reality.

- [Timeline](/guides/pebble-timeline/) to send pins to the user 
- [Persistent Storage](``Storage``) to store game information and status
- [Paint.NET plugin](https://www.dropbox.com/s/qk9n3hrbiybh8k3/ConvertTo6Bit.dll?dl=0)
to re-color Pokemon sprites.

Below, Mathew tells us a bit about his background.

### Q&A with Mathew 

**What is your previous experience with Pebble development?**

I actually started tinkering with the Pebble SDK about a year and a half ago - 
right after I ordered my Pebble Steel, I fired up CloudPebble and started 
working my way through tutorials. I finished my first watchface before my Steel 
even arrived. It didn't work at first, of course, but I was able to fix things 
quickly once I had hardware to test on.

It's been a lot of fun developing for this platform. Every time a new feature 
comes out (which is often!), I try to build a simple watchface or app that 
utilizes it. That way, I have my own sample code to refer back to when I work on
something bigger. It makes impulsive projects much easier, perhaps too easy! I
also really like the simplicity of the screen resolution and color palette, 
since it makes development more accessible to those without years of 
experience in design or coding.

**What is the backstory behind the Pokedex Challenge?**

I've been a huge Pokemon fan since I played the original Blue version on a 
translucent purple Gameboy Color back in the day :P I actually worked on a game 
with my college roommate that turned our campus into its own Pokemon world, 
complete with Professors/Gym Leaders and pixelated school buildings. 
Pokemon-style games are such a simple but popular concept; it makes developing 
your own little indie game easier if you can re-use content and gameplay 
mechanics that have been proven time and again to work well.

I've wanted to make a Pokemon related game for Pebble for a while now, but had a
hard time restricting what I wanted to do into a game appropriate for the 
platform. Even this timeline-based concept started out too over the top as 
something I could never realistically do (kudos to Yuriy Galanter for 
entertaining the idea of collaborating with me on it, as ludicrously difficult 
as it would have been). Eventually, I was able to whittle the idea down into 
what I felt was the core experience, and built that. Not only did that mean I 
actually finished the game, but I think it came out much better too.

I think things really clicked into place when I saw a notification based game 
for another platform called Lifeline. It was simple, it was passive, and it was 
really well done. It validated the idea of a passive but addicting gameplay 
experience. The idea of turning a standard Pokedex app into a passive game 
(waiting and responding to random events throughout the day rather than actively
playing) appealed to me immediately.

**Could you talk about the creation of Pokedex Challenge?**

I was fortunate in that there were already several great Pokedex apps for SDK 
2.0, so I didn't have to build everything from scratch. Once I forked the 
popular "Pokedex Kanto" app, the game development was really broken down into 
three phases. The first was building the basic JavaScript functionality to prove
the game as a concept. This is where I had a lot of fun playing around with 
different ways of interacting with timeline pins (and which pin icons to use! I 
eventually settled on the Snapchat ghost as the closest one to a "monster" icon 
from the original games).

Next was content creation. I went through and downloaded each sprite from 
Bulbapedia, then converted them all to 64 color palettes using a nifty plugin I 
wrote for Paint.NET. I also pulled data on type and species info, which form the 
coloring and text of each pin, respectively. The last phase of development was 
adding some simple but cool UI features like animated transitions and the trainer 
card, and testing/debugging. LOTS of testing/debugging :) Passive gameplay is 
great, but it was a new concept to me and one that required more patience than 
usual to properly test. "Cheating" in the sense that I increased pin frequency 
to a Pokemon every few seconds rather than every few hours helped, but required 
more constant attention than testing a minor feature in active gameplay would have.

**Did you face any significant challenges? If so, would you like to expand upon 
them?**

The game concept wasn't that technically difficult, but the timeline API is 
still very new and so there aren't a ton of great example apps - it was a lot of 
"learn as you go" development for me. I'm actually hoping to make the 
timeline-related code open-source at some point, so others don't have to go 
through the same learning curve.

I also had some crucial help from the Pebble dev community - Gregoire Sage 
helped me with a persistent storage issue I couldn't have solved on my own 
(bitwise anything is above my pay grade), valorin caught a critical bug that was 
preventing some Android users from seeing pins (his experience from making 
timeline Tag was really valuable as a resource), and of course there's the many 
people who helped beta test and made it possible for me to catch simple mistakes 
in my code much faster.

**What was your favorite part about making the app?**

I really enjoyed pretty much all of the development process, barring a few 
frustrating moments here and there. If I had to pick a favorite moment, I'd say 
it was after my first successful run through of the full game. I caught the 
final Pokemon, received all the right end-of-game notifications, then kind of 
just sat back and was like, "woah, it's a real game now".

**Any other projects that you'd like to talk about?**

At this point, I'm actually taking a long overdue break from coding (even 
hobbies can be stressful if you overdo them!). I'll respond to bugs and make 
necessary updates still, and am definitely keeping an eye out to see who makes 
it onto the Pokedex Challenge Leaderboards, but for now I'm content to sit back 
and see what amazing games and apps other devs come up with.

**Anything else you’d like to tell us?**

Just how grateful I am to be part of this developer community! Pebble and the 
community do a great job making the platform feel accessible to those with 
little or no programming or design experience, and as a result you see a lot of 
great ideas come from people who might otherwise be too intimidated to dive in. 
It's been a blast.

![](/images/blog/mathewreiss.png)

### 1 More Month!

Time is running out! Make sure you don't miss out on 
[awesome prizes and swag](/blog/2015/04/14/the-timeline-challenge-is-live/#whats-in-it-for-you). 
Check out our past winners below to get inspired, and then get ready to 
**#makeawesomehappen**!

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)
- Week 4: [Pushbutton](/blog/2015/05/29/timeline-challenge-week-four/)
- Week 5: [Flights](/blog/2015/06/05/timeline-challenge-week-five/)
- Week 6: [Meetup](/blog/2015/06/12/timeline-challenge-week-six/)
- Week 7: [Greeney's Run](/blog/2015/06/18/timeline-challenge-week-seven/)
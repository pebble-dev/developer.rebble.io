---
title: Pebble Timeline Challenge Week 7 Winner - Greeney's Run! 
author: niharika
tags: 
- Timeline
banner: /images/blog/greeneys_collage.png
image: https://assets.getpebble.com/api/file/sEYe7jsPRTqycshR84XZ/convert?cache=true&fit=crop&w=80&h=80
---

As the summer begins, we're all feeling the urge to relax a bit. With the 7th 
winner of the Pebble Timeline Challenge, 
[Greeney's Run](https://apps.getpebble.com/en_US/application/554f9adb4e604b9ed3000071), 
you can take a break by playing this colorful, exciting game! Rack up points
while traveling through meadows, beaches, and more.





Greeney's Run was created by Thomas Neff, an Austrian developer. Thomas' 
attention to detail is plainly visible in the game's features: there are over 17 
different segments used to generate new levels, 3 backgrounds (daytime, evening, 
and night), and the ability to resume the game after reopening the app. Here are
some resources he used to make those features a reality. 

- [Graphics API](``Graphics``) to draw bitmaps
- [Timer API](``Timer``) to configure the main game loop to run at 30 FPS 
- [Persistant Storage API](``Storage``) to store the game state upon exiting as 
well as the all time high score
- [Resource API](``Resources``) to store the game segments 

Below, Thomas tells us a bit about his background.

### Q&A with Thomas 

**Tell us about your experience with Pebble development.**

My first experience with Pebble Development was actually Greeney’s Run!  Being 
my first Pebble app, I first spent a lot of time doing small little demos and 
experimenting with the Pebble APIs. It was a huge help that every API was well 
documented and I managed to get prototypes running pretty quickly. I was also 
really surprised by how easy it is to actually publish an app to the Pebble 
store! Integration of both Pebble Time and the original Pebble was also very 
easy. A huge part of my Pebble Development experience was 
[CloudPebble]({{ site.links.cloudpebble }}). While I had a development environment 
running using Ubuntu/Linux on my Laptop, it was really nice to use CloudPebble 
as a platform independent development tool for both my Desktop PC and my Laptop.

**Why Greeney's Run?**

I’ve been developing platforms as a hobby for about 9 years now. The first 
game I ever made was a pretty bad and inefficiently programmed platformer using 
ActionScript and Flash. Since then, there have been multiple iterations of 
platform games I made, and every time it was a new experience for me, because I 
either tried to improve physics code, or just tried to tackle a new development 
platform. My character of choice, the main character of Greeney’s Run, has 
always been a simple green square. It started as a green square because I didn’t
really know how to do animation or proper art for my earlier games, but it grew 
on me and became somewhat like a signature character for me. Regarding the 
gameplay of Greeney’s Run, I’ve never done procedural or random generation of 
any kind in any of my games before, and it was something I really wanted to try 
out. Since the new Pebble Time has a color display, I decided to give it a shot,
and that’s how I started developing Greeney’s Run!

**Could you talk about the development of Greeney's Run a bit?**

As everyone who is new to a development platform would probably do, I started by
checking out the tutorials on the Pebble website. Coming from a background in 
mainly C and C++, I didn’t have a lot of trouble following the tutorials, and I 
managed to create a simple game rendering loop pretty quickly. From there, I 
implemented the background scrolling and physics engine, which I basically just 
ported over from one of my previous projects. My first few days of coding 
Greeney’s Run went on without many issues, but after I added more graphics and 
level segments, errors started to occur.

I realized that I completely forgot I’m developing on a Pebble. I was using so 
much memory, as I was not used to developing on anything other than a PC for a 
long time. Always keeping this in mind has definitely helped the later process 
of development.

Developing Greeney’s Run also involved lots of testing. I really wanted the 
gameplay to feel good and responsive, while providing a fun experience for 
everyone. I was also investing a lot of time thinking about the random level 
generation. Since Greeney’s Run is an endless runner type of game, I wanted each
run to feel unique and special. For that purpose, I used level segments. These 
are handcrafted “challenges” which are then presented to the player in a random 
order. This hit a good compromise for me, I was able to randomly generate the 
order of level segments, while still providing fun and self-designed level 
segments.

**What challenges did you face while developing?**

The biggest challenge was definitely to fit everything I needed into memory. The
scrolling backgrounds especially need a lot of memory, as they are quite big. 
Also keeping Greeney, the platform Tiles he can jump off of, as well as level 
segments in memory all at the same time proved to be quite difficult.  I was 
always at the edge of memory usage for the Pebble Time, and I remember just 
tinkering with my background images in an image manipulation program for a few 
hours to save a few hundred bytes of memory. Even some things as the removal of 
a color or usage of a different dithering algorithm helped a lot. I really 
wanted to fit everything I designed into the game, and I barely managed to in 
the end. 

**Do you have a favorite moment from the development process?**

My favorite part was developing the feature which allows the game to read the 
level segments from the flash storage. Since my available memory was pretty much
reserved for graphics, I wanted to be able to just keep two level segments in 
memory at a time. This required me to dynamically load new segments every time 
needed. Before that, I was simple using static arrays to represent the level 
segments in code. While still a bit cumbersome, they allowed for human-readable 
editing of levels. After I switched the system to use level segments from the 
flash storage, and therefore binary data, I also wrote a little level segment 
editor in C# in order to have a visual tool to create my level segments with. It
was really fun to see the level editor working in conjunction with Greeney’s Run
after it was finished!

I was also pretty exciting for me to work on some artwork again, as I have not 
done that for quite a while!

**Any other projects that you'd like to talk about?**

I don’t have any ideas at the moment and University is also keeping me pretty 
occupied currently.  The Pebble development experience definitely had a positive
influence on me though, and if I ever happen to stumble upon a cool idea, there 
is always the possibility for it to reach the Pebble!

**Any words of wisdom for the Pebble Dev Community?**

I’d like to encourage more hobby game developers to try out Pebble Development! 
I’d love to see awesome new games come out, especially for the Pebble Time. 

![](/images/blog/thomas_neff.png)

### Five Weeks to Go!

Now that the Pebble Timeline Challenge is more than half over, there's no time
like the present to begin developing! Check out our [guides](/guides/), 
[documentation](/docs/), and [examples](/examples/) to **#makeawesomehappen**! 

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)
- Week 4: [Pushbutton](/blog/2015/05/29/timeline-challenge-week-four/)
- Week 5: [Flights](/blog/2015/06/05/timeline-challenge-week-five/)
- Week 6: [Meetup](/blog/2015/06/12/timeline-challenge-week-six/)
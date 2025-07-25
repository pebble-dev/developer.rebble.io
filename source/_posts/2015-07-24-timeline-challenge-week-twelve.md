---
title: Pebble Timeline Challenge Week 12 Winner - TV Shows! 
author: niharika
tags: 
- Timeline
banner: https://assets.getpebble.com/api/file/oTPKvUUzSLCvKS0M7722/convert?cache=true&fit=crop&w=720&h=320
image: https://assets.getpebble.com/api/file/BxDVwzJ9RXiRZTL3gMnA/convert?cache=true&fit=crop&w=80&h=80
---

Since we announced the Pebble timeline, getting timeline pins about your favorite 
TV shows has been a much requested use case. Now, with the 12th and final winner 
of the timeline challenge, you can! With 
[TV Shows](https://apps.getpebble.com/en_US/application/55a461f5c12bc1287100007c), 
get timeline pins and notifications from up to 25 shows.






[Edwin Finch](http://www.edwinfinch.com), one of our most devoted and active developers, 
created this app with the design help of [Philipp Weder](http://www.iphibse.ch), his 
partner in all things Pebble development. Together, they created the 
[Lignite collection](http://lignite.io/), a series of watchfaces designed and 
optimized for the Pebble Time. They have also collaborated on a number of other 
watchfaces and watchapps, which you can read more about 
[here](https://www.edwinfinch.com/pebble/). 

To make this app, Edwin and Philipp used a number of Pebble features as well as
created some of their own. 

- [PebbleKit JS](/guides/communication/using-pebblekit-js/) 
- Many APIs from the [Pebble C SDK](/sdk/)
- A self designed server that includes JavaScript, PHP, Node.js, MongoDB, and 
HTML/CSS for the webpage. 

Below, Edwin and Philipp tell us about their experiences with Pebble and Pebble
development!

### Q&A with Edwin and Philipp

**Tell us about your experiences as Pebble Developers.**

*Edwin*

I got a Pebble when the original Kickstarter classics started shipping, but 
never got around to SDK 1.x. A few months after SDK 2.0 came out(which was a 
game changer), in January 2014, I just started messing around with it. I found 
it really easy to get started: CloudPebble helped me through getting set up 
because it’s so easy to use, and I messed around with other peoples’ open source 
projects. In one weekend I’d created my first two watchfaces: 
[Clean & Simple](https://www.edwinfinch.com/pebble/watchfaces/cleanandsimple/) 
and [PebbleBoy](https://www.edwinfinch.com/pebble/watchfaces/pebbleboy/). 

I eventually asked the community for ideas to create watchfaces and apps, and 
I’d do it for free, just because it was fun to do. This is when I met Philipp, 
who’d mocked up some concepts which I was really looking forward to writing and 
did end up writing. We ended up working together for weeks, which turned into 
months, and are now close friends.

We created Lignite - a successful Kickstarter campaign for a collection of 
watchfaces and apps for Pebble Time. Philipp created another amazing 20 designs 
for it, and I wrote the code. Lignite has companion apps for iOS and Android 
(because PebbleKit is multi platform, which is awesome) which are fully featured 
with settings and more. We’re still working on Lignite, and plan to add a lot 
more to it!

*Philipp*

I actually only bought my Pebble for this very reason: creating my own 
watchfaces! Since I did not want to charge my smartwatch each and every day, a 
Pebble was the only logical smartwatch to buy.

I was known for creating homescreens for the then-popular Windows Mobile 
smartphones many years ago. I ended up releasing over a hundred homescreens, 
which landed me some awesome freelance jobs for Microsoft, HTC, and the likes.

Initially wanting to code my own watchfaces, I soon found out what I already 
expected to happen: I am not a real coder but rather a designer. This is where 
Edwin came in. 

I sent him my mockups, and that’s pretty much where it all took off.

We released about 6 different watchfaces before the Kickstarter campaign for the 
Pebble Time started and gave us many more possibilities for designing watchfaces! 
Before the campaign even ended, we decided to launch our own campaign with 
Lignite. We were blown away by the feedback, the total amount pledged, and number 
of backers!

We would have never expected such a need for custom watchfaces!

**What is the backstory behind TV Guide?**

*Edwin*

Philipp actually came up with the idea after brainstorming long and hard. We 
first discussed an app for managing your water consumption and reminding you to 
drink water throughout the day (another idea of Philipp’s). Luckily enough we 
had a more suitable idea for us and soon thereafter found out that 
[8-A-Day](https://apps.getpebble.com/en_US/application/5544c004946ce2b650000037) 
won with exactly the same idea (by the way - congrats to them on their win!).

**Could you give us a few details about the creation of TV Guide? 
(any hurdles you ran into, etc)**

*Edwin*

TV APIs are few and far between, especially APIs which you can use easily. After 
some research, we had found a scraper named Zap2XML which pulls data off of 
Zap2it and puts it into XML format. It was great because it provided key 
information like start and end times, 119 channels, etc. I took this and 
converted it into JSON format (which is easily readable for PebbleKit JS), and 
made a few optimization tweaks.

I then built the internal API for it, which I use to pull the data and put it on 
the Pebble (and the website). I slowly built up the platform, first adding a 
list of channels, then show list based on channel, show detail view, and finally 
subscriptions. My original server backend was very messy and actually had an 
accounts system, which wasn’t user friendly and was very buggy. I ended up 
taking accounts out to improve the user experience. 

Philipp’s mockups featured many awesome features which we could not implement 
yet (since time was running out) but will later, such as images of the show 
right there on your wrist. We’re planning on expanding our feature set to match 
with his mockups eventually.

**What was your favorite part about making the app?**

*Edwin*

My favourite part about making TV Guide had to be just seeing all of that data 
pushed to my wrist. When I first saw all of the channels load into view, I had 
this rush of excitement and felt like I was in the future. Only a few years ago, 
smartwatches weren’t even a category (or to be more accurate, weren’t anything 
significant). Now, I am writing apps to display TV schedules on my watch, which 
is something else. With any project, I love seeing it grow, in files and 
features.

**Were there any significant challenges you faced? If so, would you like to 
expand upon them?**

*Edwin*

Yes, I faced a couple of significant challenges. Mainly having to do with 
creating the mobile web version of the platform, since I’m no web developer and 
a lot of the concepts I worked with were fairly new to me. I also hit a few 
scaling problems. Dealing with between 7000-9000 TV shows can prove slow and 
cumbersome. For example, it takes about 80-85 minutes total to run through each 
show and push the pin for that respective show (and that’s in best case scenario 
with a lower amount of shows). A small annoying problem: at early stages of 
development, I had to wait for all 119 channels to load each time I wanted to 
test the app once. While all of these challenges were frustrating, they sure 
were a blast to deal with. And seeing all of that data at my wrist made me feel 
awesome!

**Do you have any other app ideas that you’re planning on exploring in the future?**

There was another idea which we had to put on hold because it would have 
required more time than we had. But we have put it on our todo list and are sure 
that we will release it one day. Maybe on the next timeline contest? :-)

And of course loads more watchfaces and apps for the Lignite Collection. Philipp 
has designed many more faces/apps in the meantime and we are not running out of 
things to do in the future with Pebble!

**Anything else you’d like to tell us?** 

*Edwin*

Thanks for making an awesome platform. I don’t know where I’d be if it weren’t 
for Pebble. I wouldn’t have met Philipp, went to Austin to teach people how to 
write Pebble apps (for Austin Spark League), or have written this. Writing apps 
for Pebble has completely changed my life and I’m thankful every day for it. 
Keep making awesome happen!

![](/images/blog/edwin-and-philipp.png)

### A Great 12 Weeks

That's a wrap! We've had a great 12 weeks, and were amazed by the apps that 
our developers submitted. Keep an eye out over the next few weeks for some 
honorable mentions as well as special features! 

To everyone that participated in the timeline challenge, thanks for showing us 
how you **#makeawesomehappen**.  

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
- Week 10: [8-A-Day](/blog/2015/07/09/timeline-challenge-week-ten/)
- Week 11: [WatchPop](/blog/2015/07/17/timeline-challenge-week-eleven/)
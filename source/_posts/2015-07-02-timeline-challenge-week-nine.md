---
title: Pebble Timeline Challenge Week 9 Winner - Tideline! 
author: niharika
tags: 
- Timeline
banner: https://assets.getpebble.com/api/file/ElNX37g9RZCzo8hHrBoh/convert?cache=true&fit=crop&w=720&h=320
image: https://assets.getpebble.com/api/file/F4DF5LhgSr6JkhEjPslZ/convert?cache=true&fit=crop&w=80&h=80
---

With summer in full swing, we're all itching to get to the beach. Use the 9th 
winner of the Pebble Timeline Challenge to find the best waves to sail, surf, or 
ride! Keep track of the local tides with 
[Tideline](http://apps.getpebble.com/en_US/application/552e04460835235bf50000b7) 
and make sure your sandcastles are never swept away again.





Willem Olding, a Tasmanian developer and water sport lover, has avidly used his 
Pebble for years: check out this [video](https://player.vimeo.com/video/97312471) 
of him windsurfing with his Pebble. He created this app to help him plan when to
windsurf, kitesurf, and fish. Below are some of the features he used to create 
his app. 

- [Timeline](/guides/pebble-timeline/) to push new pins to the user daily 
- [PebbleKit JS](/docs/pebblekit-js/)
- [AppMessage](``AppMessage``)
- [Persistent Storage](``Storage``) to store the user's inputted information  
- [Geolocation API](/guides/communication/using-pebblekit-js)
to access the geolocation provided by the phone
- [Animation](/guides/graphics-and-animations/animations/) to create the 
rising and falling tide animations

Below, Willem tells us a bit about his background.

### Q&A with Willem 

**Tell us about your experience with Pebble development.**

My interest in Pebble was all about developing right from the start. I have 
created quite a few watch faces and apps over the years but Tideline is the 
first one I have released in the app store. I find developing for wearables to 
be a fun and unique experience. In only a couple of hours you can create a piece 
of software that you can carry around with you everywhere and use at any time. I 
am really excited to see what directions wearable technology takes in the future.

**Why Tideline?**

I have been playing around with creating a Pebble app for tide predictions for a 
while now. I’m really in to windsurfing, kitesurfing and fishing. Knowing what 
the tide is going to do is really important for planning these activities. There 
are quite a few good tide apps for Pebble already out there but none of them 
worked exactly how I wanted so I made my own. When I learned about the timeline 
API I knew it was a perfect fit. With pins for tide heights on the timeline you 
can plan your water sport activities around the rest of your schedule.

**Could you give us a few details about the creation of Tideline?**

The first step in creating Tideline was finding a high quality source of tide 
data. TideSpy was able to provide this data and the guys there kindly let me use 
the service for free. Without their support I would not have been able to 
support so many locations straight out of the box. Something that was important 
to me when developing Tideline was maintaining backward compatibility with the 
original Pebble and Pebble Steel. Although they don’t have timeline support yet 
they can still view the tide data within the app. I’m really glad I decided to 
support the earlier watches as at the time of writing the majority of users of 
Tideline are on the Aplite platform.

**Did you face any significant challenges?**

For me the most challenging part was developing the web backend that keeps track 
of the users and pushes out the new pins. I had never developed a web 
application before so it was a very steep learning curve. Fortunately Python has 
tools like Flask and SQLAlchemy which ultimately made the whole thing pretty 
straight forward. Another part of the project that I found challenging was doing 
the graphic design stuff. I want to thank my mate Lachy for giving me his time 
for free and designing a killer logo and banner.

**What was your favorite part about making the app?**

I really enjoyed developing on the Basalt emulator. It was great creating the 
animations and almost instantly being able to see what they look like on the 
watch. I actually created the whole app without ever laying hands on a Pebble 
Time so the emulator was a crucial part of the development process.

**Do you have any other app ideas that you’re planning on exploring in the 
future?**

I really love cooking so I think my next project will explore how wearables can 
improve the experience in the kitchen. I have a few ideas but I don’t want to 
say too much in case it doesn’t work out. There is also still plenty of things I 
want to add to Tideline such as support for more locations and an improved user 
interface.

**Anything else you’d like to tell us?**

I just wanted to say to any other developers out there who have created apps but 
are not sure if they should release them to the public. Its a great feeling 
knowing that other people out there are using and enjoying something you created.

![](/images/blog/willem_olding.png)

### 3 Chances Left!

We're nearing the finish line! It's been a great nine weeks, and we're so 
excited to see what these last three weeks bring. Make sure you 
[submit your apps](/blog/2015/04/14/the-timeline-challenge-is-live/) and put 
yourself in the running for some cool prizes and awesome swag! 

### Past Winners 

- Week 1: [Battery+](/blog/2015/05/08/timeline-challenge-week-1/)
- Week 2: [FitCat](/blog/2015/05/17/timeline-challenge-week-two/)
- Week 3: [Leaf](/blog/2015/05/22/timeline-challenge-week-three/)
- Week 4: [Pushbutton](/blog/2015/05/29/timeline-challenge-week-four/)
- Week 5: [Flights](/blog/2015/06/05/timeline-challenge-week-five/)
- Week 6: [Meetup](/blog/2015/06/12/timeline-challenge-week-six/)
- Week 7: [Greeney's Run](/blog/2015/06/18/timeline-challenge-week-seven/)
- Week 8: [Pokedex Challenge](/blog/2015/06/25/timeline-challenge-week-eight/)
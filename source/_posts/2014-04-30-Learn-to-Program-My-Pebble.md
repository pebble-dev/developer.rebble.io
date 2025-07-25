---
title: Learning to Program Your Pebble
author: tom
tags:
- At the Pub
---

Where can you find a good tutorial on how to program your Pebble? That question 
pops up frequently among readers on Pebble Developer Forums. Fortunately, a 
Pebble developer has provided the answer. In the Pebble community, Chris Lewis, 
a UK-based developer, has produced, beginning with Pebble SDK 1.x and recently 
with SDK 2.0, that essential tutorial for newbies coming to the platform on his 
blog: 
[ —try { work(); } finally { code(); }](http://ninedof.wordpress.com/pebble-sdk-tutorial/)
. You may want to check it out!



## The Essential Pebble Tutorial

To begin with, Chris divides the Pebble tutorial into two parts, the first of
which is aimed at beginners who are new to the C programming language. In the
second part, you learn progressively about the various components of the Pebble
SDK, from building your first watchapp, telling time, handling fonts and images,
dealing with animations, timers, buttons, vibrations and menu layers, on a
learning path all the way up to how to integrate Android apps. By that time,
you'll have a good handle on the basics of programming your Pebble.

The source code for each type of app is freely available, as is the source for
most of Chris's Pebble watchfaces and apps on
[GitHub](https://github.com/C-D-Lewis), which is a valuable resource for
building your own library of Pebble apps.

## About Chris and His Pebble Apps

Chris Lewis is a UK-based app developer, who started learning to code in C at
University while studying Electronic Engineering. Since then he has programmed
in Java for Android in his free time, before coming back to C for Pebble SDK.
"The combination of the two has resulted in Pebble apps that leverage Android
features to help streamline everyday life," he says.

![Chris Lewis](/images/blog/chris-qna.png)

Chris has developed and published several cool Pebble apps, notably

- [Watch Trigger+](https://play.google.com/store/apps/details?id=com.wordpress.ninedof.watchtrigger)
  , which lets you handle remote triggering of video capture, as well as photo 
  capture, on your Pebble.

![Watch Trigger+](/images/blog/watchtrigger.png)

- [Wristponder](https://play.google.com/store/apps/details?id=com.wordpress.ninedof.wristponder) 
  enables you to send customized pre-set SMS messages from your Pebble when you
  need to reply, but when you find that it isn't socially acceptable to use your
  mobile device.

![Wristponder](/images/blog/wristponder.png)

- [Watch App Selector](https://play.google.com/store/apps/details?id=com.wordpress.ninedof.watchappselector) 
lets you pull together all of Chris’s watchapps and watchfaces with one Android 
app for easy updating.

![Watch App Selector](/images/blog/app-selector.png)

## Q and A With Chris

We caught up with Chris recently and engaged in an online discussion about how
best to learn Pebble programming.

Q: Do you recommend that non-programmers engage in learning how to program a
Pebble app, perhaps just using CloudPebble?

 - A: I do recommend non-programmers engage, as it allows a Pebble user to
   unleash their own ideas and experiment with the platform. This is especially
   true if they like the idea of beginning to program, as once you have a basic
   working knowledge of the structure of C, the Pebble SDK is 'plain English'
   enough to be accessible as a first platform.

 - An example of this is 'text_layer_set_text()’, which 'does what it says on
   the tin' and sets the text a TextLayer will show. Once you are familiar with
   Pebble SDK, you can aim higher to other platforms such as Android, so it's a
   good starting point.

Q: Should they follow your tutorial on creating Pebble apps, or are they going
to bite off more than they can chew, as it were?

 - A: When I wrote the SDK 2.0 Tutorial I decided to try and give it a more
   progressive element, by starting small and working up to more advanced
   topics. Once a reader has variables, functions, control flow (if, else etc.)
   under their belt they should be able to progress along with it. Of course, I
   wrote it as an experienced user, so I hope I struck the right balance.

Q: How do you see working with CloudPebble? Is it a kind of IDE that non-
programmers or even seasoned programmers should use? What are some of the
limitations? Advantages?

 - A: As a Windows user, an alternative to setting up a Virtual Machine, tool
   chain and file share has got to be a bonus for non-programmers and seasoned
   programmers alike. Even more compelling an alternative to a VM now that
   'pebble logs' has been added.

 - When I'm out and don't have access to my laptop but access to another
   computer I can log in to CloudPebble to try out new ideas. A great example is
   when I was alerted by users to a big bug in Watch Trigger that had to be
   fixed fast, and thanks to CloudPebble I could do that as soon as possible
   without having to go home, preventing user frustration.

Q: What parts of the C programming language are essential to know and understand
when writing a Pebble app? I’m thinking if you’re coming to Pebble from
Objective-C or Java.

 - A: I’ve seen users who want to make a start in Pebble SDK recommended
   standard texts on C, which would make them an expert in the language, but
   they'd also know about ten times the amount they would actually need to make
   good use of the SDK, which is overkill.

 - I did quite a bit of Java for Android before re-visiting my limited C for
   Pebble SDK, and I found that the crucial things you need to know are how to
   store and use data (variables, structures, pointers and scope) and how to
   interact with the SDK.

 - This means an understanding of what a function definition is and the process
   of calling a function (arguments and return values, etc.). Once you know how
   to make and call functions, you can use ANY of the SDK functions, which
   immediately broadens your capabilities.

Q: How would you identify the most difficult part of learning to program on
Pebble? I’m thinking of the steepest learning curve example?

 - A: After gaining an initial understanding of C syntax, I think the steepest
   learning curve for a beginner would be trying to create a 'Grand Design' from
   scratch with too little experience. When I was learning Java, I found that
   starting small and then incorporating those small achievements into larger
   projects helped me improve my understanding of what was possible.

 - For example, I recently helped a fairly novice user create a MenuLayer based
   app that used AppMessage to update an Android phone app, and the main
   difficulty we had was the user's lack of experience of starting small and
   experimenting with those modules individually beforehand. Think of it as
   'building on your own shoulders'. Best to start small with TextLayers and
   Clicks, for example.

Q: Are the 
[nine tutorials](http://ninedof.wordpress.com/pebble-sdk-tutorial/) in the order 
that I, as a newbie to the Pebble platform, should follow, as a learning 
progression? Can I skip any in particular? What’s most critical for me to 
understand?

 - A: As I've previously mentioned, the basic syntax of storing and using/moving
   around data in C is a must. This enables you to use the Pebble SDK without
   much extra knowledge.

 - I hope that my SDK 2.0 Tutorial series are written as a natural progression
   from starting small to more advanced topics, but to get things off to a
   quicker start and get creating early this basic knowledge is covered in less
   detail than the first part of the 1.X Tutorial series.

 - That said, the Part #1 of the 1.X series is still a good introduction to the
   basic syntax of C, so perhaps I should revisit it as a 2.0 series prequel.

Q: Do you have any specific advice for JavaScript developers coming to the
Pebble platform?

 - A: The only practical experience I have with JavaScript was that gained from
   experimenting with PebbleKit JS, I had none before that. However, it is
   similar in most respects to Java in syntax but without explicit types.

 - Wanting to achieve set goals (such as Pebble Tube Status web data fetching)
   is a sure-fire way of motivating yourself to learn how to do new things with
   a language, instead of simply reading a book which provides no drive to
   accomplish things.

 - So with that in mind, my advice to JS developers would be to familiarize
   yourself with the differences in doing the same thing in each language. For
   example, string representations in C are very different than in JS. Being
   able to manipulate strings in both languages makes passing data between the
   watch and the phone a lot easier!

### Got a Pebble Programming Story to Tell?

Special thanks to Chris for sharing his ideas on learning techniques for Pebble
programming. If you have a story to tell about your experiences learning to
program your Pebble, please [contact us](/contact) and we'll add you to
our Learning to Program Your Pebble feature list.

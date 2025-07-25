---
title: Guest Post - My Experience with Paid Apps
author: cat
tags:
- At the Pub
image: /images/blog/authors/mathewreiss.png
---

*This is a guest post by Mathew Reiss, developer of countless Pebble apps
including
[Snowy](https://apps.getpebble.com/en_US/application/561960c8a1dd2652af00000d)
and [Yahoo! Fantasy Football](https://apps.getpebble.com/applications/55e74527646181ef07000047).*

My goal with writing apps for Pebble has never been to make tons of money.
Despite [Snowy's
success](https://twitter.com/KiezelPay/status/680484731079659520), I'm not
going to go quitting my job and moving to an exotic island any time soon.
However, it has been absolutely awesome making some money off my hobby. Most
importantly, having paid users validates my efforts as a developer and proves
that what I'm building is not just something that users want, but something
that they're willing to pay for.



![Steps to Profit](/images/blog/mathewreiss_paidapps/profit.png)
<p class="blog__image-text">It's that easy!</p>

Snowy started out as a basic voice calculator, with all parsing and processing
taking place in C. However, once I moved the parsing code into JavaScript, I
realized that there were nearly endless possibilities. So Snowy, the personal
assistant for Pebble Time, was born. I distinctly remember telling my wife that
night that I felt I'd finally made something people might be willing to pay
for...

## Getting Paid, Part 1 - Setting Up Payments

It turns out, I was correct. But at the time, I faced a serious question. *How*
do I get people to pay for my app? There were two problems: one technical, and
one systemic.

The technical problem was how to accept payments, the established way of doing
this for Pebble apps is typically to write a companion app for iOS and/or
Android. But there was a tiny issue: I don't know how to write iOS and/or
Android apps, and even if I did, Apple and Google take a big cut of your
potential revenue stream.

This is where [KiezelPay](https://kiezelpay.com/) comes into the picture. For
those of you unfamiliar with the platform, KiezelPay is a third-party library
that you integrate into your code. It checks whether the user has purchased a
license, and if they haven’t, a notification pops up on the watch with a 5
digit code and prompts the user to visit the KiezelPay website. There, the user
enters the code, which launches a payment flow through PayPal.

It’s easy to implement, and they take less of a cut than Google or Apple.

![Batman and Robin](/images/blog/mathewreiss_paidapps/batman.png)
<p class="blog__image-text">Holy Profitable Pebble Programming, Batman!</p>

The library consists of two C files and some JavaScript code. Initiating the
license check and payment prompt is as easy as adding a single line of code to
your `init()` function:

```c
kiezelpay_init();
```

You can easily customize the user experience if you want, to show custom
payment prompts (which Snowy does), or to allow a trial period (which Snowy
does not - more on that shortly).

## Getting Paid, Part 2 - Getting Users to Pay

Now that the technical side was taken care of, I still needed to address the
systemic issue: almost all apps in the Pebble appstore are free. This creates a
very unusual set of expectations for an app “marketplace” - namely, that any
new app is *expected to be* free since almost all other apps *are* free.

KiezelPay does offer the option for a free trial period; however, I felt
confident that Snowy wouldn’t need one. The success of the app would speak for
itself. Additionally, post-launch, I released a short
[demo video](https://youtu.be/-XVLs-WZ_yo). This satisfied many users who had
complained about not having a trial. They (understandably) wanted to see the
app in action before buying a license. The time I saved not integrating the
trial was spent creating marketing material that would support the app.

This material consisted of a simple [website](http://www.mydogsnowy.com) where
users could look up information on how to use Snowy and see answers to
frequently asked questions. Not only did this spare my inbox of most (but not
all) basic functionality questions, but I believe it added a legitimacy to the
product that wouldn’t have been there if I just had published a PBW and hoped
for the best.

![MyDogSnowy.com Homepage Banner](/images/blog/mathewreiss_paidapps/snowy_banner.png)
<p class="blog__image-text">MyDogSnowy.com Homepage Banner</p>

The next step was to promote Snowy in channels where I expected solid
conversion. This included the
[Pebble Forums](https://forums.getpebble.com/discussion/30378/app-personal-assistant-meet-snowy-the-worlds-first-personal-assistant-for-pebble-time/p1),
[Twitter](https://twitter.com/Idiot_Economist/status/679314463103836160), and
[Reddit](https://www.reddit.com/r/pebble/comments/3xu8zj/meet_snowy_the_worlds_first_personal_assistant/)
(r/pebble). The response on Reddit was the most significant, early adopters
began sharing their positive reviews, and soon more casual Pebblers were
downloading Snowy.

And there were definitely some people opposed, not to Snowy in particular, but
to paid apps in general. Some demanded a free trial. But the opinions of those
in the increasingly small minority who insisted on a trial or refused to pay
for a Pebble app mattered less and less as more and more users purchased
licenses.

## Key Takeaways

So what are my biggest takeaways from this experience? First and foremost, be
thorough in your documentation. Whether that’s a highly-detailed appstore
description or a simple WordPress site, you want users to be comfortable giving
you their money in exchange for your work. It should also reduce support
emails, which leads me to my second point.

Check your support emails frequently after each release. I try to respond in a
timely fashion to emails for all of my apps, but there’s an increased sense of
urgency if someone paid for one. Aim for a high level of professionalism, even
when responding to angry users or those who want a refund. It'll be better for
your long term credibility and success.

Also important, be highly visible in your pricing. This may seem counter-
intuitive, but if users think you're trying to hide the price, there will be
strong backlash. Be up front and honest about the price, and most will accept
that.

![Snowy appstore Banner](/images/blog/mathewreiss_paidapps/snowy_appstore.png)
<p class="blog__image-text">Banner design (courtesy of Juan Sanchez) makes the
price look like an integrated part of the Pebble appstore user interface.</p>

However, some users very explicitly won’t accept paid apps, and you need to
accept that. To paraphrase Abraham Lincoln, you can’t please all your users all
the time. There will be users that actively hate some detail or feature and
they won’t hesitate to let you know about it via that convenient “Email
Developer for Support” email link in the appstore. Sometimes, you’ll get
valuable feedback that way. More often than not, you’ll just need to remind
yourself that for every angry email, there are dozens, if not hundreds of
perfectly happy people using and loving your watchface or app every day.

Finally, my mantra for paid apps is this: “Charge money only for apps worth
paying for.” Asking a user to pay real money for an app is asking them to have
faith in the quality of your work. Users will lose faith in paid apps as a
whole if the Pebble appstore is suddenly flooded with low-quality paid apps.
The flip side of this is; if you *do* have an app that you believe is “worth
paying for”, you’re going to stand out in the crowd. Putting a pricetag on your
app will indicate to users that you believe it's worth something, and they
should too.

As for me, I’m content to continue working on supporting and
[updating Snowy](https://www.reddit.com/r/pebble/comments/43owzc/snowy_11_now_available_in_pebble_appstore/)
at this point. However, I’m excited to see more widespread adoption
of KiezelPay, and a new generation of paid apps in the Pebble appstore.

*Note: KiezelPay is still in beta, but is accepting applications for 
early access now. To apply, sign up at
[https://www.kiezelpay.com](https://www.kiezelpay.com).*

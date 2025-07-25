---
title: Building Apps for the Business Traveler
author: katherine
tags:
- At the Pub
---

_This is a guest post by Chris Ismael, Senior Developer Evangelist at [Concur](http://bit.ly/DisruptSF). Developers use Concur's APIs to reinvent their travel apps into time and money-saving tools for the business traveler.  Concur and Pebble are sponsoring the **[TechCrunch Disrupt Hackathon 2014](http://disruptsfhackathon.challengepost.com/)** in San Francisco. You can also get a shot at $100K prize for the best travel app at [**The Perfect Trip Fund Awards**](https://developer.concur.com/devcon/PerfectTripFundAwards). (Special thanks to **[Ethan Fan](https://twitter.com/ethanyfan) and [Gabi Zuniga](http://about.me/gabiz)** for the source code)._

The Pebble SDK makes it easy to build **Pebble apps that call cloud APIs**.  It also facilitates **communication between your Pebble smartwatch app and your smartphone**. Add to this the fact that your **development environment is run from the browser** (no installation horror!) - you know you've got a winner.


In this post, we'll touch on the those three aspects of the Pebble SDK by examining the code written by Ethan and Gabi from a previous hackathon.  Take a minute to watch their demo below so you can get a context on what the app is about - a Pebble smartwatch that computes and submits car mileage expense.

<iframe width="560" height="315" src="//www.youtube.com/embed/dhD4gqND81M" frameborder="0" allowfullscreen></iframe>

Their app is a re-imagination of the car mileage expense submission by using a combination of the Pebble SDK, Mojio API, and the Concur API.  We'll use the diagram below to explain the code in sequence:

![](/images/blog/PebbleBalsamiq.png)

The source code are accessible as gists at:

**Pebble C SDK (C)** | [ExpensePro.c](https://gist.github.com/ismaelc/4c2bcccbe1b8f9fa279b)
---------------------|---------------------------
**PebbleKit JS (Javascript)** | [pebble-js-app.js](https://gist.github.com/ismaelc/44d084346018a367a3bd)

Let's get started!
--

1.  **To establish the connection** betweeen your Pebble smartwatch and the Pebble app in your smartphone, we need to set up the **AppMessage API**.  This is explained in detail in the **Preparing AppMessage** section of the [Adding Content from the Web](/getting-started/watchface-tutorial/part3/) of the Pebble Getting Started tutorial.

    In our source code, we set up AppMessage and opened it in [line 233 of ExpensePro.c](https://gist.github.com/ismaelc/4c2bcccbe1b8f9fa279b#file-expensepro-c-L233).  This "opens" up the smartwatch app to receive incoming messages from the smartphone.

    <script src="https://gist.github.com/ismaelc/48c61ae79c1cafa9304f.js"></script>

    In the code above we also registered a callback [`fetch_msg`](https://gist.github.com/ismaelc/4c2bcccbe1b8f9fa279b#file-expensepro-c-L69) that will receive the message sent by the smartphone to the smartwatch.  We need this to display status info sent by the phone to the watch, among other things.

2.  **On the "phone" side**, we also have event handlers set up in [line 170 of pebble-js-app.js](https://gist.github.com/ismaelc/44d084346018a367a3bd#file-pebble-js-app-js-L170), to fire when the smartwatch app is 'ready', and when an `appmessage` is being sent from the watch to the phone.

    <script src="https://gist.github.com/ismaelc/ccce1d60414ae19df99a.js"></script>

    Note that the `ready` event above calls the functions `sendEntry` and `fetchLastMojoTrip` - they send values to the watch (to display status), and calls the Mojio API respectively (to determine the car's location and distance traveled).

    `fetchLastMojoTrip` is also called when the [middle button of the smartwatch is pressed](https://gist.github.com/ismaelc/44d084346018a367a3bd#file-pebble-js-app-js-L184), as shown in the diagram at the beginning of this post.  It is also called when the [timer ticks in ExpensePro.c](https://gist.github.com/ismaelc/4c2bcccbe1b8f9fa279b#file-expensepro-c-L121)

3.  When the business traveler arrives at their destination, they can choose to **submit the trip captured by Pebble and the Mojio API - as a car mileage expense to Concur**.

    This process is initiated when the [smartwatch button is pressed](https://gist.github.com/ismaelc/4c2bcccbe1b8f9fa279b#file-expensepro-c-L171). That action is [received by the Javascript code in the phone ](https://gist.github.com/ismaelc/44d084346018a367a3bd#file-pebble-js-app-js-L179)

    <script src="https://gist.github.com/ismaelc/004ec9dada0fece4538b.js"></script>

4.  The button press in Step 3 eventually calls [`postToConcur`](https://gist.github.com/ismaelc/44d084346018a367a3bd#file-pebble-js-app-js-L116) to submit the information to the Concur Expense API

    <script src="https://gist.github.com/ismaelc/df55b96f65dba94d43ec.js"></script>

    The code above uses `XMLHttpRequest` to make a POST call to the [Concur Expense API](http://bit.ly/DisruptSF).  It sends the values captured from the Mojio API as a car mileage expense entry to Concur.

And that's all there is to it!  Now that you have an overview of how the code works, you can now **put this together as Project in the CloudPebble IDE** like this:

![](/images/blog/cloudpebbleIDE.png)

I strongly suggest that you check out [Pebble's Getting Started tutorial](/getting-started/watchface-tutorial/part1/) where all we've discussed so far, including CloudPebble, are covered in detail.

To sum up, the Pebble SDK:

*   Makes it easy to call cloud APIs
*   Facilitates communication between your Pebble smartwatch and your smartphone app
*   Provides a browser-based IDE called CloudPebble that makes coding easier/faster

If you have questions, please feel free to email me at chris.ismael@concur.com

---
author: cherie
tags:
- '#makeawesomehappen'
- Beautiful Code
---

One of the most useful additions to the Pebble SDK in the [2.0 beta release](/sdk/) is the introduction of PebbleKit JS and the ability to use a webview on your phone to configure your watch app. Since we've been seeing a good number of questions on this new feature, we figured we'd talk about it a little more.



###What is PebbleKit JS?
PebbleKit JS is a new library in the Pebble SDK that allows your watch to communicate with the rest of the world/internet from within the Pebble mobile app itself. This means you don't have to have Android or iOS-specific knowledge in order to interact with web services or to create configuration interfaces on your mobile phone.

###What is the JS configuration utility?
The JS configuration utility allows you to create a configuration interface for your users to access on their mobile phones. You can use this to collect user information and credentials, or to create a place where users can adjust settings in your app. For example, in 1.x, a lot of duplicate apps were created to handle variations in languages, different watchface appearances, and time formatting. With the new JS config utility, you can setup a webview for your users to configure their preferred language, their preferred date format, and any variations you want to allow in the actual appearance of your watchface.

###How do I use it?
Using the JS config utility is very easy! To get started, read {% guide_link user-interfaces/app-configuration %}.

![](/images/blog/jsconfigure.png)

Thomas also created a cool demo of the configuration utility on [GitHub](https://github.com/pebble-hacks/js-configure-demo).
  
###What now?
Not sure how to implement a JS configuration view? You can also try out the nifty [SetPebble](http://setpebble.com) site, which auto-generates your JS webview for you based off of values you enter on the SetPebble site.
	
The instructions on how to do this can be found [here](http://setpebble.com/developers)
	
Questions? Have an app that uses the JS configuration utility? [Contact us!](/contact)

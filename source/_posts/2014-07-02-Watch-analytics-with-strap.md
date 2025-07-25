---
title: Watch Analytics with Strap
author: alex
tags:
- At the Pub
---

> We'd like to share a blog post from our friends at
> [Strap](https://www.straphq.com/) on how to add analytics to your Pebble app.
> Strap is an analytics platform targeted at wearables and helps to gather
> valuable metrics to help developers with their projects. We hope you find this
> valuable and follow the links below to try it out:

There are an increasing number of users downloading your Pebble watchfaces and
watchapps, but there is really no good way for you to figure out where those
users are coming from, how long they stay, and what they do with your app. You
can now gain these insights and more with Strap Metrics, the world's first
analytics platform built for wearable developers. Strap Metrics has spent the
past couple of months in private beta, and we are excited to go public today
with support for both PebbleKit JS apps and Pebble companion apps on iOS and
Android.



Just like traditional web and mobile analytics platforms, there is an
integration step which requires you to include our API in your project. By
default, you can include the API and call a couple of init functions to track
things like sessions (with duration), unique users, geographic location, device
battery performance, user agents, and activity. You can take this a step further
by logging events at the C level to paint a complete picture of what users are
doing inside of your application.

To demonstrate a simple use case, I'll walk you through integration with a
Pebble JS watch app that I wrote a while back. Watch3words is the official
Pebble app for [What3Words](http://www.what3words.com), an awesome platform that
lets you share your precise location in just three words. This is a fairly
typical Pebble JS app - it communicates via AppMessage and AppSync to interact
with the REST service provided by What3Words.

Note: If you have a companion app for iOS or Android, we've got you covered! We
have 
[quick start guides](https://github.com/strap/strap_sdk_pebble/tree/master/companion) 
for those platforms on our developer portal.

Before you get started, signup for an account at
https://www.straphq.com/register - it's free without limits during our public
beta!

#####1) Create an app on the Strap dashboard.

![1](/images/blog/strap1.png)

#####2) Make note of your app ID.

![2](/images/blog/strap2.png)

#####3) [Download the Strap Metrics Pebble SDK from Github.](https://github.com/strap/strap_sdk_pebble)

#####4) Add the C source to your project.

*The easy way:*

Run this from the "src" directory:

    curl http://pebble-install.straphq.com | sh


*Or manually:*

Copy /src/c to a "strap" directory in your project. 

#####5) Add the JS API to your JavaScript code

In the SDK you'll find a sample pebble-js-app.js which contains the API. Copy
the API portion of the code to the top of your js file.

![3](/images/blog/strap3.png)

#####6) Add the AppMessage event handler to your JavaScript code

Also in the sample pebble-js-app.js is an AppMessage event handler block. If you
already have an AppMessage event handler, just copy the relevant Strap portion
into it. Make sure you change the app_id to the one you created in Step 1.
Pebble.addEventListener("appmessage"),

    Pebble.addEventListener("appmessage",
      function(e) {
        //console.log("appmessage: " + JSON.stringify(e.payload));
        // Strap API: Developer updates these parameters to fit
        var strap_params = {
          app_id: "xyzabc123abcxyz",
          resolution: "144x168",
          useragent: "PEBBLE/2.0"
        };

        // -------------------------
        //  Strap API inclusion in appmessage
        //  This allows Strap to process Strap-related messages
        //  DO NOT EDIT
        // -------------------------
        if(strap_api_can_handle_msg(e.payload)) {
          clearTimeout(strap_api_timer_send);
          var params = strap_api_clone(strap_params);
          strap_api_log(e.payload, 200, params);
          strap_api_timer_send = setTimeout(function() {
            strap_api_log({}, 0, params);
          }, 10 * 1000);
        }
        // -------------------------
          
      }
    );



#####7) Add the C API to your C code

Include strap.h in any of your source that contains actions you want to track in
Strap. At a minimum, you must include the Strap header and call the init
functions in the next step for Strap to track anything. Make sure you correct
the path relative to your source if needed.

    #include "strap/strap.h"
    


#####8) Initialize Strap in your C code

In a typical Pebble pattern, your main() calls an init() and deinit() function.
Here, you'll need to include the strap_init() and strap_deinit() functions,
respectively. **Important: Your code must call app_message_open for Strap to
communicate!**

Here is a sample init function with the Strap init calls.


    static void init(void) {
      window = window_create();
      window_set_click_config_provider(window, click_config_provider);
      window_set_window_handlers(window, (WindowHandlers) {
        .load = window_load,
        .unload = window_unload,
      });

      const bool animated = true;
      window_stack_push(window, animated);
      app_message_register_inbox_received(in_received_handler);
      int in_size = app_message_inbox_size_maximum();
      int out_size = app_message_outbox_size_maximum();
      // required for Strap to communicate! 
      app_message_open(in_size, out_size);

      // initialize strap!
      strap_init();
    }

    static void deinit(void) {
      // unload strap on deinit!
      strap_deinit();
      window_destroy(window);
    }

    int main(void) {
      init();
      app_event_loop();
      deinit();
    }

#####9) Add Strap API calls to track events (optional, but recommended)

We recommend sending events in a simple URI format.

```
static void select_button_click_handler(ClickRecognizerRef recognizer, void *context) { 

  // do something on your Pebble 

  strap_log_event("/select-button-event"); 

}
```
If you made it this far, congrats! You've successfully integrated Strap into
your Pebble application. We'll start crunching the numbers as data starts to
flow into Strap, and you'll be seeing reports on the dashboard in about an hour.
We have tested Strap in a variety of app configurations, but your feedback is
extremely important to us in this beta period! If you have any questions,
concerns, or problems with Strap Metrics, please let us know. You can [open an
issue on GitHub](https://github.com/strap/strap_sdk_pebble/issues), visit our
community support portal at http://strap.uservoice.com, email us at
<support@straphq.com>, or tweet us
[@getstrap](https://www.google.com/url?q=http://www.twitter.com/getstrap).


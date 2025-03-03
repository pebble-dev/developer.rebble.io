---
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

title: Timeline - The Future of the Past!
author: jonb
tags:
- Freshly Baked
---

If you’ve been living under a rock, or have just been sunning yourself on the
beach for the past week, you might have missed the
[launch of Pebble OS 4.0](/blog/2016/08/30/announcing-pebble-sdk4/). This new
version introduced some fantastic new features, such as the
[updated health app](https://blog.rebble.io/2016/08/30/fw4-0/),
{% guide_link user-interfaces/unobstructed-area "timeline quick view" %},
{% guide_link user-interfaces/appglance-c "app glances" %},
[Rocky.js](/blog/2016/08/15/introducing-rockyjs-watchfaces/) and a new
[system launcher](/blog/2016/08/19/prime-time-is-approaching-for-os-4.0/#menu-icon-in-the-launcher).


### The Past and the Furious

However, there was one change which was met with mixed feedback from both users
and developers alike, the removal of timeline past. Previously accessible via
the UP button, timeline past was removed as part of the new 4.0 user
experience (UX). In 4.0 we introduced new APIs to give developers more options
to improve their application’s UX and potentially shift away from using the past
for interactions

Unfortunately, this change prevented users from accessing any timeline pin which
wasn’t in the present or future, negatively affecting a number of apps and their
use cases for the timeline.

We carefully listened to feedback and suggestions from our developer community
via the [forums](https://forums.rebble.io),
[Reddit](https://www.reddit.com/r/pebble),
[Twitter](https://twitter.com/pebbledev) and
[Discord]({{ site.links.discord_invite }}), and we are happy to announce that timeline past
has returned in the v4.0.1 update. Users who need to access the timeline past
can now assign it to one of their quick launch buttons.

![Quick Launch >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/2016-09-06-quick-launch.gif)

And so, with the reintroduction of timeline past, balanced was restored, and
that was the end of the story. Or was it?

### Back to the Future!

If you’re the developer of an application which relies upon timeline past, you
will probably want to inform your users about how they can access timeline past,
as it will not be enabled by default. Fortunately, there are multiple ways in
which you can do this easily.

#### 1. App Store Description

Use the app store description of your app to explain that your application
utilizes timeline past and that users will need to assign it to quick launch.
For example:

> This application utilizes pins in the timeline past. On your Pebble, go to
> ‘Settings’, ‘Quick Launch’, ‘Up Button’, then select ‘Timeline Past’. You can
> then access timeline past by long pressing UP.

#### 2. Display a Splash Screen

Add a splash screen to your application which only runs once, and display a
message informing users how to enable timeline past. You could use the
‘[about-window](https://www.npmjs.com/package/@smallstoneapps/about-window)’
Pebble package for a really quick and easy solution.

![About Window >{pebble-screenshot,pebble-screenshot--time-white}](/images/blog/2016-09-06-about-window.png)

#### 3. Display a One-Time Notification

Display a
[system notification](https://developer.rebble.io/guides/communication/using-pebblekit-js/#showing-a-notification)
which only fires once, and display a message informing users how to enable
timeline past.

![System Notification >{pebble-screenshot,pebble-screenshot--time-black}](/images/blog/2016-09-06-system-notification.png)

#### 4. Display a Timeline Notification

Display a
[timeline notification](https://developer.rebble.io/guides/pebble-timeline/),
and display a message informing users how to enable timeline past.

![Timeline Notification >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/2016-09-06-timeline-notification.png)

### The Future of the Past

For now, developers can continue to utilize timeline past, but over time we
would like to provide a more diverse set of functionality that allows developers
to surface information to their users. For example, some use cases of timeline
past may be more appropriate as using an app glance, or timeline quick view
instead.

### We’re Listening!

Your feedback is incredibly important to us, it’s how we keep making awesome
things. We love to receive your product and feature
[suggestions](http://pbl.io/ideas) too.

We’re particularly interested to hear about your use cases and ideas for
timeline as we travel further into the future! Let us know via
[the forums](https://forums.rebble.io),
[Twitter](https://twitter.com/pebbledev) and [Discord]({{ site.links.discord_invite }})!

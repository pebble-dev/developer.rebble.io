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

title: Take the Pebble Health API in your Stride
author: jonb
tags:
- Freshly Baked
---

I've been desperate to write a blog post about the Pebble [HealthService API]
(https://developer.rebble.io/docs/c/Foundation/Event_Service/HealthService/)
since it's initial release last month, and now I can finally share its
awesomeness with you. I'm also going to show you how you can use this exciting
new API to build an ultra-cool clone of the [Stride watchface]
(https://apps.rebble.io/en_US/application/56b15c5c9c4b20ed5300006c) by
Pebble.


## Background

Back in December 2015, Pebble Health was launched and had a massive uptake from
the existing Pebble userbase. For some reason, I foolishly thought health was
purely aimed at fitness fanatics and I completely underestimated its potential
uses and benefits to non-athletes like me. To give you a bit of my background,
I'm an overweight father of two, I don't get much sleep and probably spend an
unhealthy amount time in front of a computer screen. I enabled Pebble Health,
and as time progressed, I began to see how little exercise and how little sleep
I actually get.

Once you have started visualising health information, you can begin to see
patterns and get an understanding of what 'good' days and 'bad' days look like.
You can then make incremental changes and see how that affects your mood and
quality of life, though to be completely honest, I haven't changed my bad habits
just yet. I haven't suddenly started running every day, nor have I magically
started getting &gt;5 hours sleep each night, but I now have a wealth of data
available to help shape my future lifestyle decisions.

## What health data is available?

The HealthService API exposes various [`HealthMetric`]
(https://developer.rebble.io/docs/c/Foundation/Event_Service/HealthService/#HealthMetric)
values which relate to the user being physically active, or sleeping.

- `HealthMetricStepCount` - The number of steps counted.
- `HealthMetricActiveSeconds` - The number of seconds spent
active (i.e. not resting).
- `HealthMetricWalkedDistanceMeters` - The distance
walked, in meters.
- `HealthMetricSleepSeconds` - The number of seconds spent
sleeping.
- `HealthMetricSleepRestfulSeconds` - The number of sleep
seconds in the 'restful' or deep sleep state.
- `HealthMetricActiveKCalories` - The number of kcal 
(Calories) burned while active.
- `HealthMetricRestingKCalories` - The number of kcal 
(Calories) burned while resting due to resting metabolism.

## Querying the health data

There are a few important things you need to do before you actually attempt to
access the data from the HealthService.

1. Indicate that your watchapp will be accessing Health data by adding `health`
to the `capabilities` section of the `appinfo.json`, or checking the ‘Uses Health’
option in your project settings in CloudPebble. This is used by the Pebble Time
mobile app to inform users who are installing your watchapp that you're going to
be accessing their health data. If you don’t do this and attempt to access a
health api, your app will be terminated.
2. Check if the user has enabled Pebble Health in the Pebble Health app settings
and that there is any health data available. This is done by checking the
[`HealthServiceAccessibilityMask`]
(https://developer.rebble.io/docs/c/Foundation/Event_Service/HealthService/#HealthServiceAccessibilityMask) 
using [`health_service_metric_accessible()`]
(https://developer.rebble.io/docs/c/Foundation/Event_Service/HealthService/#health_service_metric_accessible).

Here is a basic example of the steps you should take before attempting to access
health data:

```c
// Between midnight (the start time) and now (the end time)
time_t start = time_start_of_today();
time_t end = time(NULL);

// Check step count data is actually available
bool any_data_available = HealthServiceAccessibilityMaskAvailable & 
   health_service_metric_accessible(HealthMetricStepCount, start, end);
```

## Building a Stride clone

![stride](/images/blog/2016-03-07-image03.png)
<p style="text-align: center; font-size: 0.9em;">Stride by Pebble</p>

The Stride watchface displays the current time and your current step count for
today. Around the edge of the screen it displays a bar which is your progress
towards your average daily step count. The yellow line shows your daily average
step count for the current time of day. So as the day progresses, the yellow
line moves towards the end of your total step goal. If you manage to get ahead
of the yellow line, you’re on track to beat your daily step count and to
highlight this, all of the blue elements turn green.

We're going to break down this project into several steps, so you can easily
see what's going on. I'm going to cheat slightly to keep the examples short.
Specifically we'll use emojis instead of the shoe icon, we won't be displaying
the am/pm indicator and we’ll only be drawing circular progress bars on all
platforms.

## Step 1 - Building the basic watchface

![strider-step1](/images/blog/2016-03-07-image00.png)

We'll start by creating a fairly typical structure of a watchface. We
initialise a new `Window`, add a `TextLayer` to display the time, then set up a
tick handler to update the time every minute.

[View the source code]
(https://github.com/pebble-examples/strider-watchface/tree/step1/src/Strider.c)

## Step 2 - Add the step count & icon

![strider-step2](/images/blog/2016-03-07-image07.png)

Now we need to add a new `TextLayer` to display our step count and emoji. We're
going to need to query the HealthService API to retrieve:

- The current step count for today.
- The target step goal amount.
- The average step count for the current time of day.

The step goal only needs to be updated once per day and we're going to use the
[`HealthEventMovementUpdate`]
(https://developer.rebble.io/guides/pebble-apps/sensors/health/#subscribing-to-healthservice-events)
event to trigger an update for the other data. This event will probably trigger
multiple times per minute, so if you’re looking to conserve energy, you could
manually update the data. Stride also changes the color of the text and icon if
the user has exceeded their average step count, so we'll do that too.

[View the source code]
(https://github.com/pebble-examples/strider-watchface/tree/step2/src/Strider.c)

## Step 3 - Add the progress indicators and progress bar

![strider-step3](/images/blog/2016-03-07-image04.png)

We’re going to create 2 new layers, one for the grey progress indicator dots
and the other for the progress bar. To simplify the example, we’re just dealing
with a circular indicator. If you want to see how Stride actually draws
rectangularly, checkout the [health-watchface on Github]
(https://github.com/pebble-examples/health-watchface).

The dots layer update procedure calculates the coordinates for each point using
[`gpoint_from_polar()`]
(https://developer.rebble.io/docs/c/Graphics/Drawing_Primitives/#gpoint_from_polar)
and then draws a circle at that point, for each dot. The progress layer update
procedure uses [`graphics_fill_radial()`]
(https://developer.rebble.io/docs/c/Graphics/Drawing_Primitives/#graphics_fill_radial)
which can fill a circle from a start and end angle, we’re using a narrow inset
thickness so that the circle is just drawn as a ring.

We also need to redraw the progress layer when the step count changes, but all
we need to do is mark the layer dirty.

[View the source code]
(https://github.com/pebble-examples/strider-watchface/tree/step3/src/Strider.c)

## Step 4 - Add the average step indicator

![strider-step4](/images/blog/2016-03-07-image01.png)

The final thing we’re going to add is an indicator to show your average daily
steps for this time of day. We’ve already calculated the average, and we’re
going to use [`graphics_fill_radial()`]
(https://developer.rebble.io/docs/c/Graphics/Drawing_Primitives/#graphics_fill_radial)
again but this time it’s just to draw a yellow line. We’ll need to add another
new layer and update procedure to handle the drawing of the line.

We also need to redraw the new layer when the step average value changes, but
again, all we need to do is mark the layer dirty.

[View the complete source code]
(https://github.com/pebble-examples/strider-watchface)

## The finished product

![strider-step2b](/images/blog/2016-03-07-image05.jpg)
<p style="text-align: center; font-size: 0.9em;">Strider watchface</p>

## Final thoughts

I’ve really only scratched the surface of the HealthService API, but hopefully
you’re now sufficiently excited to build something awesome! We’d really love to
see how you use it, and If you create a health enabled watchapp or watchface,
don’t forget to let us know on [Twitter](http://twitter.com/pebbledev) or on
[Discord]({{ site.links.discord_invite }})!

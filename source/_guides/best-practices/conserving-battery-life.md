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

title: Conserving Battery Life
description: How to write an app to consume power as efficiently as possible.
guide_group: best-practices
order: 1
related_docs:
  - Animation
  - Timer
  - AccelerometerService
  - BatteryStateService
  - TickTimerService
  - CompassService
  - Vibes
  - Light
related_examples:
  - title: Pebble Glancing Demo
    url: https://github.com/pebble-hacks/pebble_glancing_demo
---

One of Pebble's strengths is its long battery life. This is due in part to using
a low-power display technology, conservative use of the backlight, and allowing
the processor to sleep whenever possible. It therefore follows that apps which
misuse high-power APIs or prevent power-saving mechanisms from working will
detract from the user's battery life. Several common causes of battery drain in
apps are discussed in this guide, alongside suggestions to help avoid them.


## Battery Ratings

Any app published in the [Developer Portal]({{ site.links.devportal }})
will have a battery grade associated with it, once a minimum threshold of data
has been collected. This can be used to get a rough idea of how much battery
power the app consumes. For watchfaces and apps that will be launched for long
periods of time, making sure this grade is in the A - C range should be a
priority. Read {% guide_link appstore-publishing/appstore-analytics %} to learn
more about this rating system.


## Time Awake

Because the watch tries to sleep as much as possible to conserve power, any app
that keeps the watch awake will incur significant a battery penalty. Examples of
such apps include those that frequently use animations, sensors, Bluetooth
communications, and vibrations.


### Animations and Display Updates

A common cause of such a drain are long-running animations that cause frequent
display updates. For example, a watchface that plays a half-second ``Animation``
for every second that ticks by will drain the battery faster than one that does
so only once per minute. The latter approach will allow a lot more time for the
watch to sleep.

```c
static void tick_handler(struct tm *tick_time, TimeUnits changed) {
  // Update time
  set_time_digits(tick_time);

  // Only update once a minute
  if(tick_time->tm_sec == 0) {
    play_animation();
  }
}
```

This also applies to apps that make use of short-interval ``Timer``s, which is
another method of creating animations. Consider giving users the option to
reduce or disable animations to further conserve power, as well as removing or
shortening animations that are not essential to the app's function or aesthetic.

However, not all animations are bad. Efficient use of the battery can be
maintained if the animations are played at more intelligent times. For example,
when the user is holding their arm to view the screen (see
[`pebble_glancing_demo`](https://github.com/pebble-hacks/pebble_glancing_demo))
or only when a tap or wrist shake is detected:

```c
static void accel_tap_handler(AccelAxisType axis, int32_t direction) {
  // Animate when the user flicks their wrist
  play_animation();
}
```

```c
accel_tap_service_subscribe(tap_handler);
```


### Tick Updates

Many watchfaces unecessarily tick once a second by using the ``SECOND_UNIT``
constant value with the ``TickTimerService``, when they only update the display
once a minute. By using the ``MINUTE_UNIT`` instead, the amount of times the
watch is woken up per minute is reduced.

```c
// Only tick once a minute, much more time asleep
tick_timer_service_subscribe(MINUTE_UNIT, tick_handler);
```

If possible, give users the choice to disable the second hand tick and/or
animation to further save power. Extremely minimal watchfaces may also use the
``HOUR_UNIT`` value to only be updated once per hour.

This factor is especially important for Pebble Time Round users. On this
platform the reduced battery capacity means that a watchface with animations
that play every second could reduce this to one day or less. Consider offering
configuration options to reducing tick updates on this platform to save power
where it at a premium.


### Sensor Usage

Apps that make frequent usage of Pebble's onboard accelerometer and compass
sensors will also prevent the watch from going to sleep and consume more battery
power. The ``AccelerometerService`` API features the ability to configure the
sampling rate and number of samples received per update, allowing batching of
data into less frequent updates. By receiving updates less frequently, the
battery will last longer.

```c
// Batch samples into sets of 10 per callback
const uint32_t num_samples = 10;

// Sample at 10 Hz
accel_service_set_sampling_rate(ACCEL_SAMPLING_10HZ);

// With this combination, only wake up the app once per second!
accel_data_service_subscribe(num_samples, accel_data_handler);
```

Similarly, the ``CompassService`` API allows a filter to be set on the heading
updates, allowing an app to only be notified per every 45 degree angle change,
for example.

```c
// Only update if the heading changes significantly
compass_service_set_heading_filter(TRIG_MAX_ANGLE / 36);
```

In addition, making frequent use of the ``Dictation`` API will also keep the
watch awake, and also incur a penalty for keeping the Bluetooth connection
alive. Consider using the ``Storage`` API to remember previous user input and
instead present a list of previous inputs if appropriate to reduce usage of this
API.

```c
static void dictation_session_callback(DictationSession *session, DictationSessionStatus status,
                                       char *transcription, void *context) {
  if(status == DictationSessionStatusSuccess) {
    // Display the dictated text
    snprintf(s_last_text, sizeof(s_last_text), "Transcription:\n\n%s",
                                                                transcription);
    text_layer_set_text(s_output_layer, s_last_text);

    // Save for later!
    const int last_text_key = 0;
    persist_write_string(last_text_key, s_last_text);
  }
}
```


### Bluetooth Usage

Hinted at above, frequent use of the ``AppMessage`` API to send and recieve data
will cause the Bluetooth connection to enter a more responsive state, which
consumes much more power. A small time after a message is sent, the connection
will return back to a low-power state.

The 'sniff interval' determines how often the API checks for new messages from
the phone, and should be let in the default ``SNIFF_INTERVAL_NORMAL`` state as
much as possible. Consider how infrequent communication activities can be to
save power and maintain functionality, and how data obtained over the Bluetooth
connection can be cached using the ``Storage`` API to reduce the frequency of
updates (for example, weather information in watchface).

If the reduced sniff state must be used to transfer large amounts of data
quickly, be sure to return to the low-power state as soon as the transfer is
complete:

```c
// Return to low power Bluetooth state
app_comm_set_sniff_interval(SNIFF_INTERVAL_NORMAL);
```


## Backlight Usage

The backlight LED is another large consumer of battery power. System-level
backlight settings may see the backlight turn on for a few seconds every time a
button is pressed. While this setting is out of the hands of developers, apps
can work to reduce the backlight on-time by minimizing the number of button
presses required to operate them. For example, use an ``ActionBarLayer`` to
execute common actions with one button press instead of a long scrolling
``MenuLayer``.

While the ``Light`` API is available to manually turn the backlight on, it
should not be used for more than very short periods, if at all. Apps that keep
the backlight on all the time will not last more than a few hours. If the
backlight must be kept on for an extended period, make sure to return to the
automatic mode as soon as possible:

```c
// Return to automatic backlight control
light_enable(false);
```


## Vibration Motor Usage

As a physical converter of electrical to mechanical energy, the vibration motor
also consumes a lot of power. Users can elect to use Quiet Time or turn off
vibration for notifications to save power, but apps can also contribute to this
effort. Try and keep the use of the ``Vibes`` API to a minimum and giving user
the option to disable any vibrations the app emits. Another method to reduce
vibrator power consumtion is to shorten the length of any custom sequences used.


## Learn More

To learn more about power consumtion on Pebble and how battery life can be
extended through app design choices, watch the presentation below given at the
2014 Developer Retreat.

[EMBED](//www.youtube.com/watch?v=TS0FPfgxAso)

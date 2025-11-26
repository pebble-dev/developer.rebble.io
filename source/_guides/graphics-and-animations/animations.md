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

title: Animations
description: |
  How to use Animations and Timers to add life to your app.
guide_group: graphics-and-animations
order: 0
related_docs:
  - Animation
  - Timer
  - AnimationImplementation
related_examples:
  - title: Composite Animations Example
    url: https://github.com/pebble-examples/composite-animations-example
  - title: Feature Property Animation
    url: https://github.com/pebble-examples/feature-property-animation
---

The ``Animation`` API allows a variety of different types of value to be
smoothly animated from an initial value to a new value over time. Animations can
also use built-in easing curves to affect how the transition behaves.


## Using PropertyAnimations

The most common use of animations is to move a ``Layer`` (or similar) around the
display. For example, to show or hide some information or animate the time
changing in a watchface.

The simplest method of animating a ``Layer`` (such as a ``TextLayer``) is to use
a ``PropertyAnimation``, which animates a property of the target object. In this
example, the target is the frame property, which is a ``GRect`` To animate the
this property, ``property_animation_create_layer_frame()`` is used, which is a
convenience ``PropertyAnimation`` implementation provided by the SDK.

```c
static Layer *s_layer;
```

Create the Layer during ``Window`` initialization:

```c
// Create the Layer
s_layer = layer_create(some_bounds);
```

Determine the start and end values of the ``Layer``'s frame. These are the
'from' and 'to' locations and sizes of the ``Layer`` before and after the
animation takes place:

```c
// The start and end frames - move the Layer 40 pixels to the right
GRect start = GRect(10, 10, 20, 20);
GRect finish = GRect(50, 10, 20, 20);
```

At the appropriate time, create a ``PropertyAnimation`` to animate the
``Layer``, specifying the `start` and `finish` values as parameters:

```c
// Animate the Layer
PropertyAnimation *prop_anim = property_animation_create_layer_frame(s_layer, 
                                                               &start, &finish);
```

Configure the attributes of the ``Animation``, such as the delay before
starting, and total duration (in milliseconds):

```c
// Get the Animation
Animation *anim = property_animation_get_animation(prop_anim);

// Choose parameters
const int delay_ms = 1000;
const int duration_ms = 500;

// Configure the Animation's curve, delay, and duration
animation_set_curve(anim, AnimationCurveEaseOut);
animation_set_delay(anim, delay_ms);
animation_set_duration(anim, duration_ms);
```

Finally, schedule the ``Animation`` to play at the next possible opportunity
(usually immediately):

```c
// Play the animation
animation_schedule(anim);
```

If the app requires knowledge of the start and end times of an ``Animation``, it
is possible to register ``AnimationHandlers`` to be notified of these events.
The handlers should be created with the signature of these examples shown below:

```c
static void anim_started_handler(Animation *animation, void *context) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Animation started!");
}

static void anim_stopped_handler(Animation *animation, bool finished, void *context) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Animation stopped!");
}
```

Register the handlers with an optional third context parameter **before**
scheduling the ``Animation``:

```c
// Set some handlers
animation_set_handlers(anim, (AnimationHandlers) {
  .started = anim_started_handler,
  .stopped = anim_stopped_handler
}, NULL);
```

With the handlers registered, the start and end times of the ``Animation`` can
be detected by the app and used as appropriate.


### Other Types of PropertyAnimation

In addition to ``property_animation_create_layer_frame()``, it is also possible
to animate the origin of a ``Layer``'s bounds using
``property_animation_create_bounds_origin()``. Animation of more types of data
can be achieved using custom implementations and one the following provided
update implementations and the associated 
[getters and setters](``property_animation_update_int16``):

* ``property_animation_update_int16`` - Animate an `int16`.
* ``property_animation_update_uint32`` - Animate a `uint32`.
* ``property_animation_update_gpoint`` - Animate a ``GPoint``.
* ``property_animation_update_grect`` - Animate a ``GRect``
* ``property_animation_update_gcolor8`` - Animate a ``GColor8``.


## Custom Animation Implementations

Beyond the convenience functions provided by the SDK, apps can implement their
own ``Animation`` by using custom callbacks for each stage of the animation
playback process. A ``PropertyAnimation`` is an example of such an
implementation.

The callbacks to implement are the `.setup`, `.update`, and `.teardown` members
of an ``AnimationImplementation`` object. Some example implementations are shown
below. It is in the `.update` callback where the value of `progress` can be used
to modify the custom target of the animation. For example, some percentage of
completion:

```c
static void implementation_setup(Animation *animation) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Animation started!");
}

static void implementation_update(Animation *animation, 
                                  const AnimationProgress progress) {
  // Animate some completion variable
  s_animation_percent = ((int)progress * 100) / ANIMATION_NORMALIZED_MAX;
  
  APP_LOG(APP_LOG_LEVEL_INFO, "Animation progress: %d%%", s_animation_percent);
}

static void implementation_teardown(Animation *animation) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Animation finished!");
}

// This needs to exist while the event loop runs
static const AnimationImplementation s_implementation = {
  .setup = implementation_setup,
  .update = implementation_update,
  .teardown = implementation_teardown
};
```

Once these are in place, create a new ``Animation`` , specifying the new custom
implementation as a `const` object pointer at the appropriate time:

```c
// Create a new Animation
Animation *animation = animation_create();
animation_set_delay(animation, 1000);
animation_set_duration(animation, 1000);

// Create the AnimationImplementation
animation_set_implementation(animation, &s_implementation);

// Play the Animation
animation_schedule(animation);
```

The output of the example above will look like the snippet shown below (edited
for brevity). Note the effect of the easing ``AnimationCurve`` on the progress
value:

```nc|text
[13:42:33] main.c:11> Animation started!
[13:42:34] main.c:19> Animation progress: 0%
[13:42:34] main.c:19> Animation progress: 0%
[13:42:34] main.c:19> Animation progress: 0%
[13:42:34] main.c:19> Animation progress: 2%
[13:42:34] main.c:19> Animation progress: 3%
[13:42:34] main.c:19> Animation progress: 5%
[13:42:34] main.c:19> Animation progress: 7%
[13:42:34] main.c:19> Animation progress: 10%
[13:42:34] main.c:19> Animation progress: 14%
[13:42:35] main.c:19> Animation progress: 17%
[13:42:35] main.c:19> Animation progress: 21%
[13:42:35] main.c:19> Animation progress: 26%

...

[13:42:35] main.c:19> Animation progress: 85%
[13:42:35] main.c:19> Animation progress: 88%
[13:42:35] main.c:19> Animation progress: 91%
[13:42:35] main.c:19> Animation progress: 93%
[13:42:35] main.c:19> Animation progress: 95%
[13:42:35] main.c:19> Animation progress: 97%
[13:42:35] main.c:19> Animation progress: 98%
[13:42:35] main.c:19> Animation progress: 99%
[13:42:35] main.c:19> Animation progress: 99%
[13:42:35] main.c:19> Animation progress: 100%
[13:42:35] main.c:23> Animation finished!
```


## Timers

[`AppTimer`](``Timer``) objects can be used to schedule updates to variables and
objects at a later time. They can be used to implement frame-by-frame animations
as an alternative to using the ``Animation`` API. They can also be used in a
more general way to schedule events to occur at some point in the future (such
as UI updates) while the app is open.

A thread-blocking alternative for small pauses is ``psleep()``, but this is
**not** recommended for use in loops updating UI (such as a counter), or for
scheduling ``AppMessage`` messages, which rely on the event loop to do their
work.

> Note: To create timed events in the future that persist after an app is
> closed, check out the ``Wakeup`` API.

When a timer elapses, it will call a developer-defined ``AppTimerCallback``.
This is where the code to be executed after the timed interval should be placed.
The callback will only be called once, so use this opportunity to re-register
the timer if it should repeat.

```c
static void timer_callback(void *context) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Timer elapsed!");
}
```

Schedule the timer with a specific `delay` interval, the name of the callback to
fire, and an optional context pointer:

```c
const int delay_ms = 5000;

// Schedule the timer
app_timer_register(delay_ms, timer_callback, NULL);
```

If the timer may need to be cancelled or rescheduled at a later time, ensure a
reference to it is kept for later use:

```c
static AppTimer *s_timer;
```

```c
// Register the timer, and keep a handle to it
s_timer = app_timer_register(delay_ms, timer_callback, NULL);
```

If the timer needs to be cancelled, use the previous reference. If it has
already elapsed, nothing will occur:

```c
// Cancel the timer
app_timer_cancel(s_timer);
```


## Sequence and Spawn Animations

The Pebble SDK also includes the capability to build up composite animations
built from other ``Animation`` objects. There are two types: a
sequence animation and a spawn animation.

* A sequence animation is a set of two or more other animations that are played
  out in **series** (one after another). For example, a pair of timed animations
  to show and hide a ``Layer``.

* A spawn animation is a set of two or more other animations that are played out
  in **parallel**. A spawn animation acts the same as creating and starting two
  or more animations at the same time, but has the advantage that it can be
  included as part of a sequence animation.

> Note: Composite animations can be composed of other composite animations.


### Important Considerations

When incorporating an ``Animation`` into a sequence or spawn animation, there
are a couple of points to note:

* Any single animation cannot appear more than once in the list of animations
  used to create a more complex animation.

* A composite animation assumes ownership of its component animations once it
  has been created.

* Once an animation has been added to a composite animation, it becomes
  immutable. This means it can only be read, and not written to. Attempts to
  modify such an animation after it has been added to a composite animation will
  fail.

* Once an animation has been added to a composite animation, it cannot then be
  used to build a different composite animation.


### Creating a Sequence Animation

To create a sequence animation, first create the component ``Animation`` objects
that will be used to build it.

```c
// Create the first Animation
PropertyAnimation *prop_anim = property_animation_create_layer_frame(s_layer, 
                                                               &start, &finish);
Animation *animation_a = property_animation_get_animation(prop_anim);

// Set some properties
animation_set_delay(animation_a, 1000);
animation_set_duration(animation_a, 500);

// Clone the first, modify the duration and reverse it.
Animation *animation_b = animation_clone(animation_a);
animation_set_reverse(animation_b, true);
animation_set_duration(animation_b, 1000);
```

Use these component animations to create the sequence animation. You can either
specify the components as a list or pass an array. Both approaches are shown
below.


#### Using a List

You can specify up to 20 ``Animation`` objects as parameters to
`animation_sequence_create()`. The list must always be terminated with `NULL` to
mark the end.

```c
// Create the sequence
Animation *sequence = animation_sequence_create(animation_a, animation_b, NULL);

// Play the sequence
animation_schedule(sequence);
```


#### Using an Array

You can also specify the component animations using a dynamically allocated
array. Give this to `animation_sequence_create_from_array()` along with the size
of the array.

```c
const uint32_t array_length = 2;

// Create the array
Animation **arr = (Animation**)malloc(array_length * sizeof(Animation*));
arr[0] = animation_a;
arr[1] = animation_b;

// Create the sequence, set to loop forever
Animation *sequence = animation_sequence_create_from_array(arr, array_length);
animation_set_play_count(sequence, ANIMATION_DURATION_INFINITE);

// Play the sequence
animation_schedule(sequence);

// Destroy the array
free(arr);
```


### Creating a Spawn Animation

Creating a spawn animation is done in a very similiar way to a sequence
animation. The animation is built up from component animations which are then
all started at the same time. This simplifies the task of precisely timing
animations that are designed to coincide.

The first step is the same as for sequence animations, which is to create a
number of component animations to be spawned together.

```c
// Create the first animation
Animation *animation_a = animation_create();
animation_set_duration(animation_a, 1000);

// Clone the first, modify the duration and reverse it.
Animation *animation_b = animation_clone(animation_a);
animation_set_reverse(animation_b, true);
animation_set_duration(animation_b, 300);
```

Next, the spawn animation is created in a similar manner to the sequence
animation with a `NULL` terminated list of parameters:

```c
// Create the spawn animation
Animation *spawn = animation_spawn_create(animation_a, animation_b, NULL);

// Play the animation
animation_schedule(spawn);
```

Alternatively the spawn animation can be created with an array of ``Animation``
objects.

```c
const uint32_t array_length = 2;

// Create the array
Animation **arr = (Animation**)malloc(array_length * sizeof(Animation*));
arr[0] = animation_a;
arr[1] = animation_b;

// Create the sequence and set the play count to 3
Animation *spawn = animation_spawn_create_from_array(arr, array_length);
animation_set_play_count(spawn, 3);

// Play the spawn animation
animation_schedule(spawn);

// Destroy the array
free(arr);
```

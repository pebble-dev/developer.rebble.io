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

layout: tutorials/tutorial
tutorial: watchface
tutorial_part: 1

title: Build Your Own Watchface in C
description: A guide to making a new Pebble watchface with the Pebble C API
permalink: /tutorials/watchface-tutorial/part1/
menu_section: tutorials
generate_toc: true
---

In this tutorial we'll cover the basics of writing a simple watchface with
Pebble's C API. Customizability is at the heart of the Pebble philosophy, so
we'll be sure to add some exciting features for the user!

When we are done this section of the tutorial, you should end up with a brand
new basic watchface looking something like this:

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/1-time.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}


## First Steps

So, let's get started!

Before you can start the tutorial you will need to have the Pebble SDK
installed. If you haven't done this yet, go to our [download page](/sdk) to grab
the SDK and follow the instructions to install it on your machine. Once you've
done that you can come back here and carry on where you left off.

Once you have installed the SDK, navigate to a directory of your choosing
and run `pebble new-project watchface` (where 'watchface' is the name of your
new project) to start a new project and set up all the relevant files.

In an SDK project, all the information about how an app is configured (its
name, author, capabilities and resource listings etc) is stored in a file in the
project root directory called `package.json`. Since this project will be a
watchface, you will need to modify the `watchapp` object in this file to reflect
this:

```json
"watchapp": {
  "watchface": true
}
```

The main difference between the two kinds are that watchfaces serve as the
default display on the watch, with the Up and Down buttons allowing use of the
Pebble timeline. This means that these buttons are not available for custom
behavior (Back and Select are also not available to watchfaces). In contrast,
watchapps are launched from the Pebble system menu. These have more capabilities
such as button clicks and menu elements, but we will come to those later.

Finally, set a value for `companyName` and we can start to write some code!


## Watchface Basics

Our first source file is already created for you by the `pebble` command
line tool and lives in the project's `src` directory. By default, this file
contains sample code which you can safely remove, since we will be starting from
scratch. Alternatively, you can avoid this by using the `--simple` flag when
creating the project.

Let's add the basic code segments which are required by every watchapp. The
first of these is the main directive to use the Pebble SDK at the top of the
file like so:

```c
#include <pebble.h>
```

After this first line, we must begin with the recommended app structure,
specifically a standard C `main()` function and two other functions to help us
organize the creation and destruction of all the Pebble SDK elements. This helps
make the task of managing memory allocation and deallocation as simple as
possible. Additionally, `main()` also calls ``app_event_loop()``, which lets the
watchapp wait for system events until it exits.

The recommended structure is shown below, and you can use it as the basis
for your main C file:

```c
#include <pebble.h>

static void init() {

}

static void deinit() {

}

int main(void) {
  init();
  app_event_loop();
  deinit();
}
```

To add the first ``Window``, we first declare a static pointer to a ``Window``
variable, so that we can access it wherever we need to, chiefly in the `init()`
and `deinit()` functions. Add this declaration below `#include`, prefixed with
`s_` to denote its `static` nature (`static` here means it is accessible only
within this file):

```c
static Window *s_main_window;
```

The next step is to create an instance of ``Window`` to assign to this pointer,
which we will do in `init()` using the appropriate Pebble SDK functions. In this
process we also assign two handler functions that provide an additional layer of
abstraction to manage the subsequent creation of the ``Window``'s sub-elements,
in a similar way to how `init()` and `deinit()` perform this task for the
watchapp as a whole. These two functions should be created above `init()` and
must match the following signatures (the names may differ, however):

```c
static void main_window_load(Window *window) {

}

static void main_window_unload(Window *window) {

}
```

With this done, we can complete the creation of the ``Window`` element, making
reference to these two new handler functions that are called by the system
whenever the ``Window`` is being constructed. This process is shown below, and
takes place in `init()`:

```c
static void init() {
  // Create main Window element and assign to pointer
  s_main_window = window_create();

  // Set handlers to manage the elements inside the Window
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload
  });

  // Show the Window on the watch, with animated=true
  window_stack_push(s_main_window, true);
}
```

A good best-practice to learn at this early stage is to match every Pebble SDK
`_create()` function call with the equivalent `_destroy()` function to make sure
all memory used is given back to the system when the app exits. Let's do this
now in `deinit()` for our main ``Window`` element:

```c
static void deinit() {
  // Destroy Window
  window_destroy(s_main_window);
}
```

We can now compile and run this watchface, but it will not show anything
interesting yet. It is also a good practice to check that our code is still
valid after each iterative change, so let's do this now.


## First Compilation and Installation

To compile the watchface, make sure you have saved your project files and
then run `pebble build` from the project's root directory. The installable
`.pbw` file will be deposited in the `build` directory. After a successful
compile you will see a message reading `'build' finished successfully`. If there
are any problems with your code, the compiler will tell you which lines are in
error so you can fix them.

In order to install your watchface on your Pebble, first
[setup the Pebble Developer Connection](/guides/tools-and-resources/developer-connection/).
Make sure you are using the latest version of the Pebble app.

Install the watchapp by running `pebble install`, supplying your phone's IP
address with the `--phone` flag. For example: `pebble install
--phone 192.168.1.78`.

> Instead of using the --phone flag every time you install, set the PEBBLE_PHONE environment variable:
> `export PEBBLE_PHONE=192.168.1.78` and simply use `pebble install`.

Congratulations! You should see that you have a new item in the watchface menu,
but it is entirely blank!

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/1-blank.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

Let's change that with the next stage towards a basic watchface - the
``TextLayer`` element.


## Showing Some Text

Re-open your main C file to continue adding code.

The best way to show some text on a watchface or watchapp
is to use a ``TextLayer`` element. The first step in doing this is to follow a
similar procedure to that used for setting up the ``Window`` with a pointer,
ideally added below `s_main_window`:

```c
static TextLayer *s_time_layer;
```

This will be the first element added to our ``Window``, so we will make the
Pebble SDK function calls to create it in `main_window_load()`. After calling
``text_layer_create()``, we call other functions with plain English names that
describe exactly what they do, which is to help setup layout properties for the
text shown in the ``TextLayer`` including colors, alignment and font size. We
also include a call to ``text_layer_set_text()`` with "00:00" so that we can
verify that the ``TextLayer`` is set up correctly.

The layout parameters will vary depending on the shape of the display. To easily
specify which value of the vertical position is used on each of the round and
rectangular display shapes we use ``PBL_IF_ROUND_ELSE()``. Thus
`main_window_load()` becomes:

```c
static void main_window_load(Window *window) {
  // Get information about the Window
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  // Create the TextLayer with specific bounds
  s_time_layer = text_layer_create(
      GRect(0, PBL_IF_ROUND_ELSE(58, 52), bounds.size.w, 50));

  // Improve the layout to be more like a watchface
  text_layer_set_background_color(s_time_layer, GColorClear);
  text_layer_set_text_color(s_time_layer, GColorBlack);
  text_layer_set_text(s_time_layer, "00:00");
  text_layer_set_font(s_time_layer, fonts_get_system_font(FONT_KEY_BITHAM_42_BOLD));
  text_layer_set_text_alignment(s_time_layer, GTextAlignmentCenter);

  // Add it as a child layer to the Window's root layer
  layer_add_child(window_layer, text_layer_get_layer(s_time_layer));
}
```

Note the use of SDK values such as ``GColorBlack`` and `FONT_KEY_BITHAM_42_BOLD`
which allow use of built-in features and behavior. These examples here are the
color black and a built in system font. Later we will discuss loading a custom
font file, which can be used to replace this value.

Just like with ``Window``, we must be sure to destroy each element we create. We
will do this in `main_window_unload()`, to keep the management of the
``TextLayer`` completely within the loading and unloading of the ``Window`` it
is associated with. This function should now look like this:

```c
static void main_window_unload(Window *window) {
  // Destroy TextLayer
  text_layer_destroy(s_time_layer);
}
```

This completes the setup of the basic watchface layout. If you run `pebble
build && pebble install` (with your phone's IP address) for the new build, you
should now see the following:

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/1-textlayer-test.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

The final step is to get the current time and display it using the
``TextLayer``. This is done with the ``TickTimerService``.


## Telling the Time

The ``TickTimerService`` is an Event Service that allows access to the current
time by subscribing a function to be run whenever the time changes. Normally
this may be every minute, but can also be every hour, or every second. However,
the latter will incur extra battery costs, so use it sparingly. We can do this
by calling ``tick_timer_service_subscribe()``, but first we must create a
function to give the service to call whenever the time changes, and must match
this signature:

```c
static void tick_handler(struct tm *tick_time, TimeUnits units_changed) {

}
```

This means that whenever the time changes, we are provided with a data structure
of type `struct tm` containing the current time
[in various forms](http://www.cplusplus.com/reference/ctime/tm/), as well as a
constant ``TimeUnits`` value that tells us which unit changed, to allow
filtering of behaviour. With our ``TickHandler`` created, we can register it
with the Event Service in `init()` like so:

```c
// Register with TickTimerService
tick_timer_service_subscribe(MINUTE_UNIT, tick_handler);
```

The logic to update the time ``TextLayer`` will be created in a function called
`update_time()`, enabling us to call it both from the ``TickHandler`` as well as
`main_window_load()` to ensure it is showing a time from the very beginning.

This function will use `strftime()`
([See here for formatting](http://www.cplusplus.com/reference/ctime/strftime/))
to extract the hours and minutes from the `struct tm` data structure and write
it into a character buffer. This buffer is required by ``TextLayer`` to be
long-lived as long as the text is to be displayed, as it is not copied into the
``TextLayer``, but merely referenced. We achieve this by making the buffer
`static`, so it persists across multiple calls to `update_time()`. Therefore
this function should be created before `main_window_load()` and look like this:

```c
static void update_time() {
  // Get a tm structure
  time_t temp = time(NULL);
  struct tm *tick_time = localtime(&temp);

  // Write the current hours and minutes into a buffer
  static char s_buffer[8];
  strftime(s_buffer, sizeof(s_buffer), clock_is_24h_style() ?
                                          "%H:%M" : "%I:%M", tick_time);

  // Display this time on the TextLayer
  text_layer_set_text(s_time_layer, s_buffer);
}
```

Our ``TickHandler`` follows the correct function signature and contains only a
single call to `update_time()` to do just that:

```c
static void tick_handler(struct tm *tick_time, TimeUnits units_changed) {
  update_time();
}
```

Lastly, `init()` should be modified include a call to
`update_time()` after ``window_stack_push()`` to ensure the time is displayed
correctly when the watchface loads:

```c
// Make sure the time is displayed from the start
update_time();
```

Since we can now display the time we can remove the call to
``text_layer_set_text()`` in `main_window_load()`, as it is no longer needed to
test the layout.

Re-compile and re-install the watchface on your Pebble, and it should look like
this:

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/1-time.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}


## Conclusion

So there we have it, the basic process required to create a brand new Pebble
watchface! To do this we:

1. Created a new Pebble project.
2. Setup basic app structure.
3. Setup a main ``Window``.
4. Setup a ``TextLayer`` to display the time.
5. Subscribed to ``TickTimerService`` to get updates on the time, and wrote
   these to a buffer for display in the ``TextLayer``.

If you have problems with your code, check it against the sample source code
provided using the button below.

[View Source Code >{center,bg-lightblue,fg-white}](https://gist.github.com/9b9d50b990d742a3ae34)

## What's Next?

The next section of the tutorial will introduce adding custom fonts and bitmap
images to your watchface.

[Go to Part 2 &rarr; >{wide,bg-dark-red,fg-white}](/tutorials/watchface-tutorial/part2/)

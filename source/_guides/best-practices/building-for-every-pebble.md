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

title: Building for Every Pebble
description: How to write one app compatible with all Pebble smartwatches.
guide_group: best-practices
order: 0
---

The difference in capabilities between the various Pebble hardware platforms are
listed in
{% guide_link tools-and-resources/hardware-information %}. For example, the
Basalt, Chalk and Emery platforms support 64 colors, whereas the Aplite, Diorite
and Flint platforms only support two colors. This can make developing apps with
rich color layouts difficult when considering compatibility with other non-color
hardware. Another example is using platform specific APIs such as Health or
Dictation.

To make life simple for users, developers should strive to write one app that
can be used on all platforms. To help make this task simpler for developers, the
Pebble SDK provides numerous methods to accommodate different hardware
capabilities in code.


## Preprocessor Directives

It is possible to specify certain blocks of code to be compiled for specific
purposes by using the `#ifdef` preprocessor statement. For example, the
``Dictation`` API should be excluded on platforms with no microphone:

```c
#if defined(PBL_MICROPHONE)
  // Start dictation UI
  dictation_session_start(s_dictation_session);
#else
  // Microphone is not available
  text_layer_set_text(s_some_layer, "Dictation not available!");
#endif
```

When designing UI layouts, any use of colors on compatible platforms can be
adapted to either black or white on non-color platforms. The `PBL_COLOR` and
`PBL_BW` symbols will be defined at compile time when appropriate capabilities
are available:

```c
#if defined(PBL_COLOR)
  text_layer_set_text_color(s_text_layer, GColorRed);
  text_layer_set_background_color(s_text_layer, GColorChromeYellow);
#else
  text_layer_set_text_color(s_text_layer, GColorWhite);
  text_layer_set_background_color(s_text_layer, GColorBlack);
#endif
```

This is useful for blocks of multiple statements that change depending on the
availability of color support. For single statements, this can also be achieved
by using the ``PBL_IF_COLOR_ELSE()`` macro.

```c
window_set_background_color(s_main_window, PBL_IF_COLOR_ELSE(GColorJaegerGreen, GColorBlack));
```

See below for a complete list of defines and macros available.


## Available Defines and Macros

The tables below show a complete summary of all the defines and associated
macros available to conditionally compile or omit feature-dependant code. The
macros are well-suited for individual value selection, whereas the defines are
better used to select an entire block of code.

| Define | MACRO |Available |
|--------|-------|----------|
| `PBL_BW` | `PBL_IF_BW_ELSE()` | Running on hardware that supports only black and white. |
| `PBL_COLOR` | `PBL_IF_COLOR_ELSE()` | Running on hardware that supports 64 colors. |
| `PBL_MICROPHONE` | `PBL_IF_MICROPHONE_ELSE()` | Running on hardware that includes a microphone. |
| `PBL_COMPASS` | None | Running on hardware that includes a compass. |
| `PBL_SMARTSTRAP` | `PBL_IF_SMARTSTRAP_ELSE()` | Running on hardware that includes a smartstrap connector, but does not indicate that the connector is capable of supplying power. |
| `PBL_SMARTSTRAP_POWER` | None | Running on hardware that includes a smartstrap connector capable of supplying power. |
| `PBL_HEALTH` | `PBL_IF_HEALTH_ELSE()` | Running on hardware that supports Pebble Health and the `HealthService` API. |
| `PBL_RECT` | `PBL_IF_RECT_ELSE()` | Running on hardware with a rectangular display. |
| `PBL_ROUND` | `PBL_IF_ROUND_ELSE()` | Running on hardware with a round display. |
| `PBL_DISPLAY_WIDTH` | None | Determine the screen width in pixels. |
| `PBL_DISPLAY_HEIGHT` | None | Determine the screen height in pixels. |
| `PBL_PLATFORM_APLITE` | None | Built for Pebble/Pebble Steel. |
| `PBL_PLATFORM_BASALT` | None | Built for Pebble Time/Pebble Time Steel. |
| `PBL_PLATFORM_CHALK` | None | Built for Pebble Time Round. |
| `PBL_PLATFORM_DIORITE` | None | Built for Pebble 2. |
| `PBL_PLATFORM_EMERY` | None | Built for Pebble Time 2. |
| `PBL_PLATFORM_FLINT` | None | Built for Pebble 2 Duo. |
| `PBL_SDK_2` | None | Compiling with SDK 2.x (deprecated). |
| `PBL_SDK_3` | None | Compiling with SDK 3.x. or 4.x. |

> Note: It is strongly recommended to conditionally compile code using
> applicable feature defines instead of `PBL_PLATFORM` defines to be as specific
> as possible.

## API Detection

In addition to platform and capabilities detection, we now provide API
detection to detect if a specific API method is available. This approach could
be considered future-proof, since platforms and capabilities may come and go.
Let's take a look at a simple example:

```c
#if PBL_API_EXISTS(health_service_peek_current_value)
 // Do something if specific Health API exists
#endif
```

## Avoid Hardcoded Layout Values

With the multiple display shapes and resolutions available, developers should
try and avoid hardcoding layout values. Consider the example
below:

```c
static void window_load(Window *window) {
  // Create a full-screen Layer - BAD
  s_some_layer = layer_create(GRect(0, 0, 144, 168));
}
```

The hardcoded width and height of this layer will cover the entire screen on
Aplite, Basalt, Diorite and Flint, but not on Chalk or Emery. This kind of screen
size-dependant calculation should use the ``UnobstructedArea`` bounds of the
``Window`` itself:

```c
static void window_load(Window *window) {
  // Get the unobstructed bounds of the Window
  Layer window_layer = window_get_root_layer(window);
  GRect window_bounds = layer_get_unobstructed_bounds(window_layer);

  // Properly create a full-screen Layer - GOOD
  s_some_layer = layer_create(window_bounds);
}
```

Another common use of this sort of construction is to make a ``Layer`` that is
half the unobstructed screen height. This can also be correctly achieved using
the ``Window`` unobstructed bounds:

```c
GRect layer_bounds = window_bounds;
layer_bounds.size.h /= 2;

// Create a Layer that is half the screen height
s_some_layer = layer_create(layer_bounds);
```

This approach is also advantageous in simplifying updating an app for a future
new screen size, as proportional layout values will adapt as appropriate when
the ``Window`` unobstructed bounds change.


## Screen Sizes

To ease the introduction of the Emery platform, the Pebble SDK introduced new
compiler directives to allow developers to determine the screen width and
height. This is preferable to using platform detection, since multiple platforms
share the same screen width and height.

```c
#if PBL_DISPLAY_HEIGHT == 228
  uint8_t offset_y = 100;
#elif PBL_DISPLAY_HEIGHT == 180
  uint8_t offset_y = 80;
#else
  uint8_t offset_y = 60;
#endif
```

> Note: Although this method is preferable to platform detection, it is better
to dynamically calculate the display width and height based on the unobstructed
bounds of the root layer.

## Pebble C WatchInfo

The ``WatchInfo`` API can be used to determine exactly which Pebble model and
color an app is running on. Apps can use this information to dynamically
modify their layout or behavior depending on which Pebble the user is wearing.

For example, the display on Pebble Steel is located at a different vertical
position relative to the buttons than on Pebble Time. Any on-screen button hints
can be adjusted to compensate for this using ``WatchInfoModel``.

```c
static void window_load(Window *window) {
  Layer window_layer = window_get_root_layer(window);
  GRect window_bounds = layer_get_bounds(window_layer);

  int button_height, y_offset;

  // Conditionally set layout parameters
  switch(watch_info_get_model()) {
    case WATCH_INFO_MODEL_PEBBLE_STEEL:
      y_offset = 64;
      button_height = 44;
      break;
    case WATCH_INFO_MODEL_PEBBLE_TIME:
      y_offset = 58;
      button_height = 56;
      break;

    /* Other cases */

    default:
      y_offset = 0;
      button_height = 0;
      break;

  }

  // Set the Layer frame
  GRect layer_frame = GRect(0, y_offset, window_bounds.size.w, button_height);

  // Create the Layer
  s_label_layer = text_layer_create(layer_frame);
  layer_add_child(window_layer, text_layer_get_layer(s_label_layer));

  /* Other UI code */

}
```

Developers can also use ``WatchInfoColor`` values to theme an app for each
available color of Pebble.

```c
static void window_load(Window *window) {
  GColor text_color, background_color;

  // Choose different theme colors per watch color
  switch(watch_info_get_color()) {
    case WATCH_INFO_COLOR_RED:
      // Red theme
      text_color = GColorWhite;
      background_color = GColorRed;
      break;
    case WATCH_INFO_COLOR_BLUE:
      // Blue theme
      text_color = GColorBlack;
      background_color = GColorVeryLightBlue;
      break;

    /* Other cases */

    default:
      text_color = GColorBlack;
      background_color = GColorWhite;
      break;

  }

  // Use the conditionally set value
  text_layer_set_text_color(s_label_layer, text_color);
  text_layer_set_background_color(s_label_layer, background_color);

  /* Other UI code */

}
```


## PebbleKit JS Watch Info

Similar to [*Pebble C WatchInfo*](#pebble-c-watchinfo) above, the PebbleKit JS
``Pebble.getActiveWatchInfo()`` method allows developers to determine
which model and color of Pebble the user is wearing, as well as the firmware
version running on it. For example, to obtain the model of the watch:

> Note: See the section below to avoid problem using this function on older app
> version.

```js
// Get the watch info
var info = Pebble.getActiveWatchInfo();

console.log('Pebble model: ' + info.model);
```


## Detecting Platform-specific JS Features

A number of features in PebbleKit JS (such as ``Pebble.timelineSubscribe()`` and
``Pebble.getActiveWatchInfo()``) exist on SDK 3.x. If an app tries to use any of
these on an older Pebble mobile app version where they are not available, the JS
app will crash.

To prevent this, be sure to check for the availability of the function before
calling it. For example, in the case of ``Pebble.getActiveWatchInfo()``:

```js
if (Pebble.getActiveWatchInfo) {
  // Available.
  var info = Pebble.getActiveWatchInfo();

  console.log('Pebble model: ' + info.model);
} else {
  // Gracefully handle no info available

}
```


## Platform-specific Resources

With the availability of color support on Basalt, Chalk and Emery, developers
may wish to include color versions of resources that had previously been
pre-processed for Pebble's black and white display. Including both versions of
the resource is expensive from a resource storage perspective, and lays the
burden of packing redundant color resources in an Aplite, Diorite or Flint app when
built for multiple platforms.

To solve this problem, the Pebble SDK allows developers to specify which version
of an image resource is to be used for each display type, using `~bw` or
`~color` appended to a file name. Resources can also be bundled only with
specific platforms using the `targetPlatforms` property for each resource.

For more details about packaging resources specific to each platform, as well as
more tags available similar to `~color`, read
{% guide_link app-resources/platform-specific %}.


## Multiple Display Shapes

With the introduction of the Chalk platform, a new round display type is
available with increased pixel resolution. To distinguish between the two
possible shapes of display, developers can use defines to conditionally
include code segments:

```c
#if defined(PBL_RECT)
  printf("This is a rectangular display!");
#elif defined(PBL_ROUND)
  printf("This is a round display!");
#endif
```

Another approach to this conditional compilation is to use the
``PBL_IF_RECT_ELSE()`` and ``PBL_IF_ROUND_ELSE()`` macros, allowing values to be
inserted into expressions that might otherwise require a set of `#define`
statements similar to the previous example. This would result in needless
verbosity of four extra lines of code when only one is actually needed. These
are used in the following manner:

```c
// Conditionally print out the shape of the display
printf("This is a %s display!", PBL_IF_RECT_ELSE("rectangular", "round"));
```

This mechanism is best used with window bounds-derived layout size and position
value. See the [*Avoid Hardcoded Layout Values*](#avoid-hardcoded-layout-values)
section above for more information. Making good use of the builtin ``Layer``
types will also help safeguard apps against display shape and size changes.

Another thing to consider is rendering text on a round display. Due to the
rounded corners, each horizontal line of text will have a different available
width, depending on its vertical position.

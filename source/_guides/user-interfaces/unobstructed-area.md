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

title: Unobstructed Area
description: |
  Details on how to use the UnobstructedArea API to adapt your watchface layout
  when the screen is partially obstructed by a system overlay.
guide_group: user-interfaces
order: 5
related_docs:
  - Graphics
  - LayerUpdateProc
  - UnobstructedArea
related_examples:
  - title: Simple Example
    url: https://github.com/pebble-examples/unobstructed-area-example
  - title: Watchface Tutorial
    url: https://github.com/pebble-examples/watchface-tutorial-unobstructed
---

The ``UnobstructedArea`` API, added in SDK 4.0, allows developers to dynamically
adapt their watchface design when an area of the screen is partially obstructed
by a system overlay. Currently, the Timeline Quick View feature is the only
system overlay.

Developers are not required to adjust their designs to cater for such system
overlays, but by using the ``UnobstructedArea`` API they can detect changes to
the available screen real-estate and then move, scale, or hide their layers to
achieve an optimal layout while the screen is partially obscured.

![Unobstructed-watchfaces](/images/guides/user-interfaces/unobstructed-area/01-unobstructed-watchfaces.jpg)
<p class="blog__image-text">Sample watchfaces with Timeline Quick View overlay
</p>

![Obstructed-watchfaces](/images/guides/user-interfaces/unobstructed-area/02-obstructed-watchfaces.jpg)
<p class="blog__image-text">Potential versions of sample watchfaces using the
UnobstructedArea API</p>

### Determining the Unobstructed Bounds

Prior to SDK 4.0, when displaying layers on screen you would calculate the
size of the display using ``layer_get_bounds()`` and then scale and position
your layers accordingly. Developers can now calculate the size of a layer,
excluding system obstructions, using the new
``layer_get_unobstructed_bounds()``.

```c
static Layer *s_window_layer;
static TextLayer *s_text_layer;

static void main_window_load(Window *window) {
  s_window_layer = window_get_root_layer(window);
  GRect unobstructed_bounds = layer_get_unobstructed_bounds(s_window_layer);
  s_text_layer = text_layer_create(GRect(0, unobstructed_bounds.size.h / 4, unobstructed_bounds.size.w, 50));
}
```

If you still want a fullscreen entities such as a background image, regardless
of any obstructions, just combine both techniques as follows:

```c
static Layer *s_window_layer;
static BitmapLayer *s_image_layer;
static TextLayer *s_text_layer;

static void main_window_load(Window *window) {
  s_window_layer = window_get_root_layer(window);
  GRect full_bounds = layer_get_bounds(s_window_layer);
  GRect unobstructed_bounds = layer_get_unobstructed_bounds(s_window_layer);
  s_image_layer = bitmap_layer_create(full_bounds);
  s_text_layer = text_layer_create(GRect(0, unobstructed_bounds.size.h / 4, unobstructed_bounds.size.w, 50));
}
```

The approach outlined above is perfectly fine to use when your watchface is
initially launched, but you’re also responsible for handling the obstruction
appearing and disappearing while your watchface is running.

### Rendering with LayerUpdateProc

If your application controls its own rendering process using a
``LayerUpdateProc`` you can just dynamically adjust your rendering
each time your layer updates.

In this example, we use ``layer_get_unobstructed_bounds()`` instead of
``layer_get_bounds()``. The graphics are then positioned or scaled based upon
the available screen real-estate, instead of the screen dimensions.

> You must ensure you fill the entire window, not just the unobstructed
> area, when drawing the screen - failing to do so may cause unexpected
> graphics to be drawn behind the quick view, during animations.

```c
static void hands_update_proc(Layer *layer, GContext *ctx) {
  GRect bounds = layer_get_unobstructed_bounds(layer);
  GPoint center = grect_center_point(&bounds);
  const int16_t second_hand_length = (bounds.size.w / 2);
  time_t now = time(NULL);
  struct tm *t = localtime(&now);
  int32_t second_angle = TRIG_MAX_ANGLE * t->tm_sec / 60;
  GPoint second_hand = {
    .x = (int16_t)(sin_lookup(second_angle) * (int32_t)second_hand_length / TRIG_MAX_RATIO) + center.x,
    .y = (int16_t)(-cos_lookup(second_angle) * (int32_t)second_hand_length / TRIG_MAX_RATIO) + center.y,
  };

  // second hand
  graphics_context_set_stroke_color(ctx, GColorWhite);
  graphics_draw_line(ctx, second_hand, center);

  // minute/hour hand
  graphics_context_set_fill_color(ctx, GColorWhite);
  graphics_context_set_stroke_color(ctx, GColorBlack);
  gpath_rotate_to(s_minute_arrow, TRIG_MAX_ANGLE * t->tm_min / 60);
  gpath_draw_filled(ctx, s_minute_arrow);
  gpath_draw_outline(ctx, s_minute_arrow);

  gpath_rotate_to(s_hour_arrow, (TRIG_MAX_ANGLE * (((t->tm_hour % 12) * 6) +
                  (t->tm_min / 10))) / (12 * 6));
  gpath_draw_filled(ctx, s_hour_arrow);
  gpath_draw_outline(ctx, s_hour_arrow);

  // dot in the middle
  graphics_context_set_fill_color(ctx, GColorBlack);
  graphics_fill_rect(ctx, GRect(bounds.size.w / 2 - 1, bounds.size.h / 2 - 1, 3,
  3), 0, GCornerNone);
}
```

### Using Unobstructed Area Handlers

If you are not overriding the default rendering of a ``Layer``, you will need to
subscribe to one or more of the ``UnobstructedAreaHandlers`` to adjust the sizes
and positions of layers.

There are 3 events available using ``UnobstructedAreaHandlers``.
These events will notify you when the unobstructed area is: *about to change*,
*is currently changing*, or *has finished changing*. You can use these handlers
to perform any necessary alterations to your layout.

`.will_change` - an event to inform you that the unobstructed area size is about
to change. This provides a ``GRect`` which lets you know the size of the screen
after the change has finished.

`.change` - an event to inform you that the unobstructed area size is currently
changing. This event is called several times during the animation of an
obstruction appearing or disappearing. ``AnimationProgress`` is provided to let
you know the percentage of progress towards completion.

`.did_change` - an event to inform you that the unobstructed area size has
finished changing. This is useful for deinitializing or destroying anything
created or allocated in the will_change handler.

These handlers are optional, but at least one must be specified for a valid
subscription. In the following example, we subscribe to two of the three
available handlers.

> **NOTE**: You must construct the
> ``UnobstructedAreaHandlers`` object *before* passing it to the
> ``unobstructed_area_service_subscribe()`` method.

```c
UnobstructedAreaHandlers handlers = {
  .will_change = prv_unobstructed_will_change,
  .did_change = prv_unobstructed_did_change
};
unobstructed_area_service_subscribe(handlers, NULL);
```

#### Hiding Layers

In this example, we’re going to hide a ``TextLayer`` containing the current
date, while the screen is obstructed.

Just before the Timeline Quick View appears, we’re going to hide the
``TextLayer`` and we’ll show it again after the Timeline Quick View disappears.

```c
static Window *s_main_window;
static Layer *s_window_layer;
static TextLayer *s_date_layer;
```

Subscribe to the `.did_change` and `.will_change` events:

```c
static void main_window_load(Window *window) {
  // Keep a handle on the root layer
  s_window_layer = window_get_root_layer(window);
  // Subscribe to the will_change and did_change events
  UnobstructedAreaHandlers handlers = {
    .will_change = prv_unobstructed_will_change,
    .did_change = prv_unobstructed_did_change
  };
  unobstructed_area_service_subscribe(handlers, NULL);
}
```

The `will_change` event fires before the size of the unobstructed area changes,
so we need to establish whether the screen is already obstructed, or about to
become obstructed. If there isn’t a current obstruction, that means the
obstruction must be about to appear, so we’ll need to hide our data layer.

```c
static void prv_unobstructed_will_change(GRect final_unobstructed_screen_area,
void *context) {
  // Get the full size of the screen
  GRect full_bounds = layer_get_bounds(s_window_layer);
  if (!grect_equal(&full_bounds, &final_unobstructed_screen_area)) {
    // Screen is about to become obstructed, hide the date
    layer_set_hidden(text_layer_get_layer(s_date_layer), true);
  }
}
```

The `did_change` event fires after the unobstructed size changes, so we can
perform the same check to see whether the screen is already obstructed, or
about to become obstructed. If the screen isn’t obstructed when this event
fires, then the obstruction must have just cleared and we’ll need to display
our date layer again.

```c
static void prv_unobstructed_did_change(void *context) {
  // Get the full size of the screen
  GRect full_bounds = layer_get_bounds(s_window_layer);
  // Get the total available screen real-estate
  GRect bounds = layer_get_unobstructed_bounds(s_window_layer);
  if (grect_equal(&full_bounds, &bounds)) {
    // Screen is no longer obstructed, show the date
    layer_set_hidden(text_layer_get_layer(s_date_layer), false);
  }
}
```

#### Animating Layer Positions

The `.change` event will fire several times while the unobstructed area is
changing size. This allows us to use this event to make our layers appear to
slide-in or slide-out of their initial positions.

In this example, we’re going to use percentages to position two text layers
vertically. One layer at the top of the screen and one layer at the bottom. When
the screen is obstructed, these two layers will shift to be closer together.
Because we’re using percentages, it doesn’t matter if the unobstructed area is
increasing or decreasing, our text layers will always be relatively positioned
in the available space.

```c
static const uint8_t s_offset_top_percent = 33;
static const uint8_t s_offset_bottom_percent = 10;
```

A simple helper function to simulate percentage based coordinates:

```c
uint8_t relative_pixel(int16_t percent, int16_t max) {
  return (max * percent) / 100;
}
```

Subscribe to the change event:

```c
static void main_window_load(Window *window) {
  UnobstructedAreaHandlers handler = {
    .change = prv_unobstructed_change
  };
  unobstructed_area_service_subscribe(handler, NULL);
}
```

Move the text layer each time the unobstructed area size changes:

```c
static void prv_unobstructed_change(AnimationProgress progress, void *context) {
  // Get the total available screen real-estate
  GRect bounds = layer_get_unobstructed_bounds(s_window_layer);
  // Get the current position of our top text layer
  GRect frame = layer_get_frame(text_layer_get_layer(s_top_text_layer));
  // Shift the Y coordinate
  frame.origin.y = relative_pixel(s_offset_top_percent, bounds.size.h);
  // Apply the new location
  layer_set_frame(text_layer_get_layer(s_top_text_layer), frame);
  // Get the current position of our bottom text layer
  GRect frame2 = layer_get_frame(text_layer_get_layer(s_top_text_layer));
  // Shift the Y coordinate
  frame2.origin.y = relative_pixel(s_offset_bottom_percent, bounds.size.h);
  // Apply the new position
  layer_set_frame(text_layer_get_layer(s_bottom_text_layer), frame2);
}
```

### Toggling Timeline Quick View

The `pebble` tool which shipped as part of [SDK 4.0](/sdk4),
allows developers to enable and disable Timeline Quick View, which is
incredibly useful for debugging purposes.

![Unobstructed animation >{pebble-screenshot,pebble-screenshot--time-black}](/images/guides/user-interfaces/unobstructed-area/unobstructed-animation.gif)

To enable Timeline Quick View, you can use:

```nc|text
$ pebble emu-set-timeline-quick-view on
```

To disable Timeline Quick View, you can use:

```nc|text
$ pebble emu-set-timeline-quick-view off
```


### Additional Considerations

If you're scaling or moving layers based on the unobstructed area, you must
ensure you fill the entire window, not just the unobstructed area. Failing to do
so may cause unexpected graphics to be drawn behind the quick view, during
animations.

At present, Timeline Quick View is not currently planned for the Chalk platform.

For design reference, the height of the Timeline Quick View overlay will be
*51px* in total, which includes a 2px border, but this may vary on newer
platforms and and the height should always be calculated at runtime.

```c
// Calculate the actual height of the Timeline Quick View
s_window_layer = window_get_root_layer(window);
GRect fullscreen = layer_get_bounds(s_window_layer);
GRect unobstructed_bounds = layer_get_unobstructed_bounds(s_window_layer);

int16_t obstruction_height = fullscreen.size.h - unobstructed_bounds.size.h;
```

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
tutorial: advanced
tutorial_part: 1

title: Vector Animations
description: |
  How to use vector images in icons and animations.
permalink: /tutorials/advanced/vector-animations/
generate_toc: true
platforms:
  - basalt
  - chalk
  - diorite
  - emery
---

Some of the best Pebble apps make good use of the ``Animation`` and the
[`Graphics Context`](``Graphics``) to create beautiful and eye-catching user
interfaces that look better than those created with just the standard ``Layer``
types.

Taking a good design a step further may involve using the ``Draw Commands`` API
to load vector icons and images, and to animate them on a point-by-point basis
at runtime. An additional capability of the ``Draw Commands`` API is the draw
command sequence, allowing multiple frames to be incorporated into a single
resource and played out frame by frame.

This tutorial will guide you through the process of using these types of image
files in your own projects.


## What Are Vector Images?

As opposed to bitmaps which contain data for every pixel to be drawn, a vector
file contains only instructions about points contained in the image and how to
draw lines connecting them up. Instructions such as fill color, stroke color,
and stroke width are also included.

Vector images on Pebble are implemented using the ``Draw Commands`` APIs, which
load and display PDC (Pebble Draw Command) images and sequences that contain
sets of these instructions. An example is the weather icon used in weather
timeline pins. The benefit of using vector graphics for this icon is that is
allows the image to stretch in the familiar manner as it moves between the
timeline view and the pin detail view:

![weather >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/advanced/weather.png)

By including two or more vector images in a single file, an animation can be
created to enable fast and detailed animated sequences to be played. Examples
can be seen in the Pebble system UI, such as when an action is completed:

![action-completed >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/advanced/action-completed.gif)

The main benefits of vectors over bitmaps for simple images and icons are:

* Smaller resource size - instructions for joining points are less memory
  expensive than per-pixel bitmap data.

* Flexible rendering - vector images can be rendered as intended, or manipulated
  at runtime to move the individual points around. This allows icons to appear
  more organic and life-like than static PNG images. Scaling and distortion is
  also made possible.

* Longer animations - a side benefit of taking up less space is the ability to
  make animations longer.

However, there are also some drawbacks to choosing vector images in certain
cases:

* Vector files require more specialized tools to create than bitmaps, and so are
  harder to produce.

* Complicated vector files may take more time to render than if they were simply
  drawn per-pixel as a bitmap, depending on the drawing implementation.


## Creating Compatible Files

The file format of vector image files on Pebble is the PDC (Pebble Draw Command)
format, which includes all the instructions necessary to allow drawing of
vectors. These files are created from compatible SVG (Scalar Vector Graphics)
files using the
[`svg2pdc`]({{site.links.examples_org}}/cards-example/blob/master/tools/svg2pdc.py)
tool.

<div class="alert alert--fg-white alert--bg-dark-red">
Pebble Draw Command files can only be used from app resources, and cannot be
created at runtime.
</div>

To convert an SVG file to a PDC image of the same name:

```bash
$ python svg2pdc.py image.svg
```

To create a PDCS (Pebble Draw Command Sequence) from individual SVG frames,
specify the directory containing the frames with the `--sequence` flag when
running `svg2pdc`:

```bash
$ ls frames/
1.svg          2.svg          3.svg
4.svg          5.svg

$ python svg2pdc.py --sequence frames/
```

In the example above, this will create an output file in the `frames` directory
called `frames.pdc` that contains draw command data for the complete animation.

<div class="alert alert--fg-white alert--bg-dark-red">
{% markdown %}
**Limitations**

The `svg2pdc` tool currently supports SVG files that use **only** the following
elements: `g`, `layer`, `path`, `rect`, `polyline`, `polygon`, `line`, `circle`.

We recommend using Adobe Illustrator to create compatible SVG icons and images.
{% endmarkdown %}
</div>

For simplicity, compatible image and sequence files will be provided for you to
use in your own project.


### PDC icons

Example PDC image files are available for the icons listed in
[*App Assets*](/guides/app-resources/app-assets/).
These are ideal for use in many common types of apps, such as notification or
weather apps.

[Download PDC icon files >{center,bg-lightblue,fg-white}]({{ site.links.s3_assets }}/assets/other/pebble-timeline-icons-pdc.zip)


## Getting Started

Begin a new project using `pebble new-project` and create a simple app that
pushes a blank ``Window``, such as the example below:

```c
#include <pebble.h>

static Window *s_main_window;

static void main_window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

}

static void main_window_unload(Window *window) {

}

static void init() {
  s_main_window = window_create();
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload,
  });
  window_stack_push(s_main_window, true);
}

static void deinit() {
  window_destroy(s_main_window);
}

int main() {
  init();
  app_event_loop();
  deinit();
}
```


## Drawing a PDC Image

For this tutorial, use the example
[`weather_image.pdc`](/assets/other/weather_image.pdc) file provided.

Add the PDC file to your project resources in `package.json` as shown
below. Set the 'name' field to `WEATHER_IMAGE`, and the 'type' field to `raw`.
The file is assumed to be called `weather_image.pdc`:

```json
"media": [
  {
    "type": "raw",
    "name": "WEATHER_IMAGE",
    "file": "weather_image.pdc"
  }
]

Drawing a Pebble Draw Command image is just as simple as drawing a normal PNG
image to a graphics context, requiring only one draw call. First, load the
`.pdc` file from resources, for example with the `name` defined as
`WEATHER_IMAGE`, as shown below.

Declare a pointer of type ``GDrawCommandImage`` at the top of the file:

```c
static GDrawCommandImage *s_command_image;
```

Create and assign the ``GDrawCommandImage`` in `init()`, before calling
`window_stack_push()`:

```nc|c
static void init() {
  /* ... */

  // Create the object from resource file
  s_command_image = gdraw_command_image_create_with_resource(RESOURCE_ID_WEATHER_IMAGE);

  /* ... */
}
```

Next, define the ``LayerUpdateProc`` that will be used to draw the PDC image:

```c
static void update_proc(Layer *layer, GContext *ctx) {
  // Set the origin offset from the context for drawing the image
  GPoint origin = GPoint(10, 20);

  // Draw the GDrawCommandImage to the GContext
  gdraw_command_image_draw(ctx, s_command_image, origin);
}
```

Next, create a ``Layer`` to display the image:

```c
static Layer *s_canvas_layer;
```

Next, set the ``LayerUpdateProc`` that will do the rendering and add it to the
desired ``Window``:

```c
static void main_window_load(Window *window) {

  /* ... */

  // Create the canvas Layer
  s_canvas_layer = layer_create(GRect(30, 30, bounds.size.w, bounds.size.h));

  // Set the LayerUpdateProc
  layer_set_update_proc(s_canvas_layer, update_proc);

  // Add to parent Window
  layer_add_child(window_layer, s_canvas_layer);
}
```

Finally, don't forget to free the memory used by the ``Window``'s sub-components
in `main_window_unload()`:

```c
static void main_window_unload(Window *window) {
  layer_destroy(s_canvas_layer);
  gdraw_command_image_destroy(s_command_image);
}
```

When run, the PDC image will be loaded, and rendered in the ``LayerUpdateProc``.
To put the image into contrast, we will finally change the ``Window`` background
color after `window_create()`:

```c
window_set_background_color(s_main_window, GColorBlueMoon);
```

The result will look similar to the example shown below.

![weather-image >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/advanced/weather-image.png)


## Playing a PDC Sequence

The ``GDrawCommandSequence`` API allows developers to use vector graphics as
individual frames in a larger animation. Just like ``GDrawCommandImage``s, each
``GDrawCommandFrame`` is drawn to a graphics context in a ``LayerUpdateProc``.

For this tutorial, use the example
[`clock_sequence.pdc`](/assets/other/clock_sequence.pdc) file provided.

Begin a new app, with a C file containing the [template](#getting-started) provided above.

Next, add the file as a `raw` resource in the same way as for a PDC image,
for example with the `name` field specified in `package.json` as
`CLOCK_SEQUENCE`.

```json
"media": [
  {
    "type": "raw",
    "name": "CLOCK_SEQUENCE",
    "file": "clock_sequence.pdc"
  }
]
```

Load the PDCS in your app by first declaring a ``GDrawCommandSequence`` pointer:

```c
static GDrawCommandSequence *s_command_seq;
```

Next, initialize the object in `init()` before calling `window_stack_push()`:

```nc|c
static void init() {
  /* ... */

  // Load the sequence
  s_command_seq = gdraw_command_sequence_create_with_resource(RESOURCE_ID_CLOCK_SEQUENCE);

  /* ... */
}
```

Get the next frame and draw it in the ``LayerUpdateProc``. Then register a timer
to draw the next frame:

```c
// Milliseconds between frames
#define DELTA 13

static int s_index = 0;

/* ... */

static void next_frame_handler(void *context) {
  // Draw the next frame
  layer_mark_dirty(s_canvas_layer);

  // Continue the sequence
  app_timer_register(DELTA, next_frame_handler, NULL);
}

static void update_proc(Layer *layer, GContext *ctx) {
  // Get the next frame
  GDrawCommandFrame *frame = gdraw_command_sequence_get_frame_by_index(s_command_seq, s_index);

  // If another frame was found, draw it
  if (frame) {
    gdraw_command_frame_draw(ctx, s_command_seq, frame, GPoint(0, 30));
  }

  // Advance to the next frame, wrapping if neccessary
  int num_frames = gdraw_command_sequence_get_num_frames(s_command_seq);
  s_index++;
  if (s_index == num_frames) {
    s_index = 0;
  }
}
```

Next, create a new ``Layer`` to utilize the ``LayerUpdateProc`` and add it to the
desired ``Window``.

Create the `Window` pointer:

```c
static Layer *s_canvas_layer;
```

Next, create the ``Layer`` and assign it to the new pointer. Set its update
procedure and add it to the ``Window``:

```c
static void main_window_load(Window *window) {
  // Get Window information
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  // Create the canvas Layer
  s_canvas_layer = layer_create(GRect(30, 30, bounds.size.w, bounds.size.h));

  // Set the LayerUpdateProc
  layer_set_update_proc(s_canvas_layer, update_proc);

  // Add to parent Window
  layer_add_child(window_layer, s_canvas_layer);
}
```

Start the animation loop using a timer at the end of initialization:

```c
// Start the animation
app_timer_register(DELTA, next_frame_handler, NULL);
```

Finally, remember to destroy the ``GDrawCommandSequence`` and ``Layer`` in
`main_window_unload()`:

```c
static void main_window_unload(Window *window) {
  layer_destroy(s_canvas_layer);
  gdraw_command_sequence_destroy(s_command_seq);
}
```

When run, the animation will be played by the timer at a framerate dictated by
`DELTA`, looking similar to the example shown below:

![pdcs-example >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/advanced/pdcs-example.gif)


## What's Next?

You have now learned how to add vector images and animations to your apps.
Complete examples for these APIs are available under the `pebble-examples`
GitHub organization:

* [`pdc-image`]({{site.links.examples_org}}/pdc-image) - Example
  implementation of a Pebble Draw Command Image.

* [`pdc-sequence`]({{site.links.examples_org}}/pdc-sequence) - Example
  implementation of a Pebble Draw Command Sequence animated icon.


More advanced tutorials will be added here in the future, so keep checking back!

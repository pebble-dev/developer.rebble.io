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

title: Vector Graphics
description: |
  How to draw simple images using vector images, instead of bitmaps.
guide_group: graphics-and-animations
order: 3
related_docs:
  - Draw Commands
related_examples:
  - title: PDC Image
    url: https://github.com/pebble-examples/pdc-image
  - title: PDC Sequence
    url: https://github.com/pebble-examples/pdc-sequence
---

This is an overview of drawing vector images using Pebble Draw Command files.
See the [*Vector Animations*](/tutorials/advanced/vector-animations) tutorial
for more information.


## Vector Graphics on Pebble

As opposed to bitmaps which contain data for every pixel to be drawn, a vector
file contains only instructions about points contained in the image and how to
draw lines connecting them up. Instructions such as fill color, stroke color,
and stroke width are also included.

Vector images on Pebble are implemented using the ``Draw Commands`` API, which
allows apps to load and display PDC (Pebble Draw Command) images and sequences
that contain sets of these instructions. An example is the weather icon used in
weather timeline pins. The benefit of using vector graphics for this icon is
that is allows the image to stretch in the familiar manner as it moves between
the timeline view and the pin detail view:

![weather >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/advanced/weather.png)

The main benefits of vectors over bitmaps for simple images and icons are:

* Smaller resource size - instructions for joining points are less memory
  expensive than per-pixel bitmap data.

* Flexible rendering - vector images can be rendered as intended, or manipulated
  at runtime to move the individual points around. This allows icons to appear
  more organic and life-like than static PNG images. Scaling and distortion is
  also made possible.

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
files. Read {% guide_link app-resources/converting-svg-to-pdc %} for more
information.

<div class="alert alert--fg-white alert--bg-dark-red">
Pebble Draw Command files can only be used from app resources, and cannot be
created at runtime.
</div>


## Drawing Vector Graphics

Add the PDC file to the project resources in `package.json` with the
'type' field to `raw`:

```json
"media": [
  {
    "type": "raw",
    "name": "EXAMPLE_IMAGE",
    "file": "example_image.pdc"
  }
]

Drawing a Pebble Draw Command image is just as simple as drawing a normal
PNG image to a graphics context, requiring only one draw call. First, load the
`.pdc` file from resources as shown below.

First, declare a pointer of type ``GDrawCommandImage`` at the top of the file:

```c
static GDrawCommandImage *s_command_image;
```

Create and assign the ``GDrawCommandImage`` in `init()`, before calling
`window_stack_push()`:

```nc|c
// Create the object from resource file
s_command_image = gdraw_command_image_create_with_resource(RESOURCE_ID_EXAMPLE_IMAGE);
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

Assign the ``LayerUpdateProc`` that will do the rendering to the canvas
``Layer`` and add it to the desired ``Window`` during `window_load()`:

```c
// Create the canvas Layer
s_canvas_layer = layer_create(GRect(30, 30, bounds.size.w, bounds.size.h));

// Set the LayerUpdateProc
layer_set_update_proc(s_canvas_layer, update_proc);

// Add to parent Window
layer_add_child(window_layer, s_canvas_layer);
```

Finally, don't forget to free the memory used by the sub-components of the
``Window`` in `main_window_unload()`:

```c
// Destroy the canvas Layer
layer_destroy(s_canvas_layer);

// Destroy the PDC image
gdraw_command_image_destroy(s_command_image);
```

When run, the PDC image will be loaded, and rendered in the ``LayerUpdateProc``.
To put the image into contrast, optionally change the ``Window`` background
color after `window_create()`:

```c
window_set_background_color(s_main_window, GColorBlueMoon);
```

The result will look similar to the example shown below.

![weather-image >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/advanced/weather-image.png)

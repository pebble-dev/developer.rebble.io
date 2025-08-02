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

title: Animated Images
description: |
  How to add animated image resources to a project in the APNG format, and
  display them in your app.
guide_group: app-resources
order: 0
---

The Pebble SDK allows animated images to be played inside an app using the
``GBitmapSequence`` API, which takes [APNG](https://en.wikipedia.org/wiki/APNG)
images as input files. APNG files are similar to well-known `.gif` files, which
are not supported directly but can be converted to APNG.

A similar effect can be achieved with multiple image resources, a
``BitmapLayer`` and an ``AppTimer``, but would require a lot more code. The
``GBitmapSequence`` API handles the reading, decompression, and frame
duration/count automatically.


## Converting GIF to APNG

A `.gif` file can be converted to the APNG `.png` format with
[gif2apng](http://gif2apng.sourceforge.net/) and the `-z0` flag:

```text
./gif2apng -z0 animation.gif
```

> Note: The file extension must be `.png`, **not** `.apng`.


## Adding an APNG

Include the APNG file in the `resources` array in `package.json` as a `raw`
resource:

```js
"resources": {
  "media": [
    {
      "type":"raw",
      "name":"ANIMATION",
      "file":"images/animation.png"
    }
  ]
}
```

## Displaying APNG Frames

The ``GBitmapSequence`` will use a ``GBitmap`` as a container and update its
contents each time a new frame is read from the APNG file. This means that the
first step is to create a blank ``GBitmap`` to be this container.

Declare file-scope variables to hold the data:

```c
static GBitmapSequence *s_sequence;
static GBitmap *s_bitmap;
```

Load the APNG from resources into the ``GBitmapSequence`` variable, and use the
frame size to create the blank ``GBitmap`` frame container:


```c
// Create sequence
s_sequence = gbitmap_sequence_create_with_resource(RESOURCE_ID_ANIMATION);

// Create blank GBitmap using APNG frame size
GSize frame_size = gbitmap_sequence_get_bitmap_size(s_sequence);
s_bitmap = gbitmap_create_blank(frame_size, GBitmapFormat8Bit);
```

Once the app is ready to begin playing the animated image, advance each frame
using an ``AppTimer`` until the end of the sequence is reached. Loading the next
APNG frame is handled for you and written to the container ``GBitmap``.

Declare a ``BitmapLayer`` variable to display the current frame, and set it up
as described under
{% guide_link app-resources/images#displaying-an-image "Displaying An Image" %}.

```c
static BitmapLayer *s_bitmap_layer;
```

Create the callback to be used when the ``AppTimer`` has elapsed, and the next
frame should be displayed. This will occur in a loop until there are no more
frames, and ``gbitmap_sequence_update_bitmap_next_frame()`` returns `false`:

```c
static void timer_handler(void *context) {
  uint32_t next_delay;

  // Advance to the next APNG frame, and get the delay for this frame
  if(gbitmap_sequence_update_bitmap_next_frame(s_sequence, s_bitmap, &next_delay)) {
    // Set the new frame into the BitmapLayer
    bitmap_layer_set_bitmap(s_bitmap_layer, s_bitmap);
    layer_mark_dirty(bitmap_layer_get_layer(s_bitmap_layer));

    // Timer for that frame's delay
    app_timer_register(next_delay, timer_handler, NULL);
  }
}
```

When appropriate, schedule the first frame advance with an ``AppTimer``:

```c
uint32_t first_delay_ms = 10;

// Schedule a timer to advance the first frame
app_timer_register(first_delay_ms, timer_handler, NULL);
```

When the app exits or the resource is no longer required, destroy the
``GBitmapSequence`` and the container ``GBitmap``:

```c
gbitmap_sequence_destroy(s_sequence);
gbitmap_destroy(s_bitmap);
```

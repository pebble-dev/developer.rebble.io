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

title: Images
description: |
  How to add image resources to a project and display them in your app.
guide_group: app-resources
order: 4
---

Images can be displayed in a Pebble app by adding them as a project resource.
They are stored in memory as a ``GBitmap`` while the app is running, and can be
displayed either in a ``BitmapLayer`` or by using
``graphics_draw_bitmap_in_rect()``.


## Creating an Image

In order to be compatible with Pebble, the image should be saved as a PNG file,
ideally in a palettized format (see below for palette files) with the
appropriate number of colors. The number of colors available on each platform is
shown below:

| Platform | Number of Colors |
|----------|------------------|
| Aplite | 2 (black and white) |
| Basalt | 64 colors |
| Chalk | 64 colors |


## Color Palettes

Palette files for popular graphics packages that contain the 64 supported colors
are available below. Use these when creating color image resources:

* [Photoshop `.act`](/assets/other/pebble_colors_64.act)

* [Illustrator `.ai`](/assets/other/pebble_colors_64.ai)

* [GIMP `.pal`](/assets/other/pebble_colors_64.pal)

* [ImageMagick `.gif`](/assets/other/pebble_colors_64.gif)


## Import the Image

After placing the image in the project's `resources` directory, add an entry to
the `resources` item in `package.json`. Specify the `type` as `bitmap`, choose a
`name` (to be used in code) and supply the path relative to the project's
`resources` directory. Below is an example:

```js
"resources": {
  "media": [
    {
      "type": "bitmap",
      "name": "EXAMPLE_IMAGE",
      "file": "background.png"
    }
  ]
},
```


## Specifying an Image Resource

Image resources are used in a Pebble project when they are listed using the
`bitmap` resource type.

Resources of this type can be optimized using additional attributes:

| Attribute | Description | Values |
|-----------|-------------|--------|
| `memoryFormat` | Optional. Determines the bitmap type. Reflects values in the `GBitmapFormat` `enum`. | `Smallest`, `SmallestPalette`, `1Bit`, `8Bit`, `1BitPalette`, `2BitPalette`, or `4BitPalette`. |
| `storageFormat` | Optional. Determines the file format used for storage. Using `spaceOptimization` instead is preferred. | `pbi` or `png`. |
| `spaceOptimization` | Optional. Determines whether the output resource is optimized for low runtime memory or low resource space usage. | `storage` or `memory`. |

An example usage of these attributes in `package.json` is shown below:

```js
{
  "type": "bitmap",
  "name": "IMAGE_EXAMPLE",
  "file": "images/example_image.png"
  "memoryFormat": "Smallest",
  "spaceOptimization": "memory"
}
```

On all platforms `memoryFormat` will default to `Smallest`. On Aplite
`spaceOptimization` will default to `memory`, and `storage` on all other
platforms.

> If you specify a combination of attributes that is not supported, such as a
> `1Bit` unpalettized PNG, the build will fail. Palettized 1-bit PNGs are
> supported.

When compared to using image resources in previous SDK versions:

* `png` is equivalent to `bitmap` with no additional specifiers.

* `pbi` is equivalent to `bitmap` with `"memoryFormat": "1Bit"`.

* `pbi8` is equivalent to `bitmap` with `"memoryFormat": "8Bit"` and
  `"storageFormat": "pbi"`.

Continuing to use the `png` resource type will result in a `bitmap` resource
with `"storageFormat": "png"`, which is not optimized for memory usage on the
Aplite platform due to less memory available in total, and is not encouraged.


## Specifying Resources Per Platform

To save resource space, it is possible to include only certain image resources
when building an app for specific platforms. For example, this is useful for the
Aplite platform, which requires only black and white versions of images, which
can be significantly smaller in size. Resources can also be selected according
to platform and display shape.

Read {% guide_link app-resources/platform-specific %} to learn more about how to
do this.


## Displaying an Image

Declare a ``GBitmap`` pointer. This will be the object type the image data is
stored in while the app is running:

```c
static GBitmap *s_bitmap;
```

Create the ``GBitmap``, specifying the `name` chosen earlier, prefixed with
`RESOURCE_ID_`. This will manage the image data:

```c
s_bitmap = gbitmap_create_with_resource(RESOURCE_ID_EXAMPLE_IMAGE);
```

Declare a ``BitmapLayer`` pointer:

```c
static BitmapLayer *s_bitmap_layer;
```

Create the ``BitmapLayer`` and set it to show the ``GBitmap``. Make sure to
supply the correct width and height of your image in the ``GRect``, as well as
using ``GCompOpSet`` to ensure color transparency is correctly applied:

```c
s_bitmap_layer = bitmap_layer_create(GRect(5, 5, 48, 48));
bitmap_layer_set_compositing_mode(s_bitmap_layer, GCompOpSet);
bitmap_layer_set_bitmap(s_bitmap_layer, s_bitmap);
```

Add the ``BitmapLayer`` as a child layer to the ``Window``:

```c
layer_add_child(window_get_root_layer(window), 
                                      bitmap_layer_get_layer(s_bitmap_layer));
```

Destroy both the ``GBitmap`` and ``BitmapLayer`` when the app exits:

```c
gbitmap_destroy(s_bitmap);
bitmap_layer_destroy(s_bitmap_layer);
```

## Menu Icon in the Launcher

The new launcher in firmware 4.0+ allows developers to provide a custom icon for
their watchapps and watchfaces.

<div class="pebble-dual-image">
  <div class="panel">
  {% markdown %}
  ![Launcher Icon](/images/blog/2016-08-19-pikachu-icon.png)
  {% endmarkdown %}
  </div>
  <div class="panel">
  {% markdown %}
  ![Launcher >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/2016-08-19-pikachu-launcher.png)
  {% endmarkdown %}
  </div>
</div>

You can add a 25x25 `png` to the `resources.media` section of the`package.json`
file, and set `"menuIcon": true`. Please note that icons that are larger will be
rejected by the SDK.

```js
"resources": {
  "media": [
    {
      "type": "bitmap",
      "name": "MENU_ICON",
      "file": "images/icon.png",
      "menuIcon": true
    }
  ]
}
```

> If your `png` file is color, we will use the luminance of the image to add
> some subtle gray when rendering it in the launcher, rather than just black
> and white. Transparency will be preserved.

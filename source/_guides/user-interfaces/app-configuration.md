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

title: App Configuration
description: |
  How to allow users to customize an app with a configuration page.
guide_group: user-interfaces
order: 0
related_examples:
  - title: Clay Example
    url: https://github.com/pebble-examples/clay-example
---

Many watchfaces and watchapps in the Pebble appstore include the ability to
customize their behavior or appearance through the use of a configuration page.

[Clay for Pebble](https://github.com/pebble/clay) is the recommended approach
for creating configuration pages, and is what will be covered in this guide.
If you need to host your own configuration pages, please follow our
{% guide_link user-interfaces/app-configuration-static "Manual Setup" %} guide.

![Clay Sample](/images/guides/user-interfaces/app-configuration/clay-sample.png =200)

Clay for Pebble dramatically simplifies the process of creating a configuration
page, by allowing developers to define their application settings using a
simple [JSON](https://en.wikipedia.org/wiki/JSON) file. Clay processes the
JSON file and then dynamically generates a configuration page which matches the
existing style of the Pebble mobile application, and it even works without an
Internet connection.


## Enabling Configuration

For an app to be configurable, it must include the 'configurable' item in
`package.json`.

```json
"capabilities": [ "configurable" ]
```

The presence of this value tells the mobile app to display the gear icon that
is associated with the ability to launch the config page next to the app itself.

## Installing Clay

Clay is available as a {% guide_link pebble-packages "Pebble Package" %}, so it
takes minimal effort to install.

Within your project folder, just type:

```nc|text
$ pebble package install pebble-clay
```


## Choosing messageKeys

When passing data between the configuration page and the watch application, we
define `messageKeys` to help us easily identify the different values.

In this example, we're going to allow users to control the background color,
foreground color, whether the watchface ticks on seconds and whether any
animations are displayed.

We define `messageKeys` in the `package.json` file for each configuration
setting in our application:

```json
"messageKeys": [
  "BackgroundColor",
  "ForegroundColor",
  "SecondTick",
  "Animations"
]
```


## Creating the Clay Configuration

The Clay configuration file (`config.js`) should be created in your
`src/pkjs/` folder. It allows the easy definition of each type of HTML form
entity that is required. These types include:

* [Section](https://github.com/pebble/clay#section)
* [Heading](https://github.com/pebble/clay#heading)
* [Text](https://github.com/pebble/clay#text)
* [Input](https://github.com/pebble/clay#input)
* [Toggle](https://github.com/pebble/clay#toggle)
* [Select](https://github.com/pebble/clay#select)
* [Color Picker](https://github.com/pebble/clay#color-picker)
* [Radio Group](https://github.com/pebble/clay#radio-group)
* [Checkbox Group](https://github.com/pebble/clay#checkbox-group)
* [Generic Button](https://github.com/pebble/clay#generic-button)
* [Range Slider](https://github.com/pebble/clay#range-slider)
* [Submit Button](https://github.com/pebble/clay#submit)

In our example configuration page, we will add some introductory text, and group
our fields into two sections. All configuration pages must have a submit button
at the end, which is used to send the JSON data back to the watch.

![Clay](/images/guides/user-interfaces/app-configuration/clay-actual.png =200)

Now start populating the configuration file with the sections you require, then
add the required elements to each section. Be sure to assign the correct
`messageKey` to each field.

```js
module.exports = [
  {
    "type": "heading",
    "defaultValue": "App Configuration"
  },
  {
    "type": "text",
    "defaultValue": "Here is some introductory text."
  },
  {
    "type": "section",
    "items": [
      {
        "type": "heading",
        "defaultValue": "Colors"
      },
      {
        "type": "color",
        "messageKey": "BackgroundColor",
        "defaultValue": "0x000000",
        "label": "Background Color"
      },
      {
        "type": "color",
        "messageKey": "ForegroundColor",
        "defaultValue": "0xFFFFFF",
        "label": "Foreground Color"
      }
    ]
  },
  {
    "type": "section",
    "items": [
      {
        "type": "heading",
        "defaultValue": "More Settings"
      },
      {
        "type": "toggle",
        "messageKey": "SecondTick",
        "label": "Enable Seconds",
        "defaultValue": false
      },
      {
        "type": "toggle",
        "messageKey": "Animations",
        "label": "Enable Animations",
        "defaultValue": false
      }
    ]
  },
  {
    "type": "submit",
    "defaultValue": "Save Settings"
  }
];
```

## Initializing Clay

To initialize Clay, all you need to do is add the following JavaScript into
your `index.js` file.

```js
// Import the Clay package
var Clay = require('pebble-clay');
// Load our Clay configuration file
var clayConfig = require('./config');
// Initialize Clay
var clay = new Clay(clayConfig);
```

> When using the local SDK, it is possible to use a pure JSON
> configuration file (`config.json`). If this is the case, you must not include
> the `module.exports = []` in your configuration file, and you need to
> `var clayConfig = require('./config.json');`

## Receiving Config Data

Within our watchapp we need to open a connection with ``AppMessage`` to begin
listening for data from Clay, and also provide a handler to process the data
once it has been received.

```c
void prv_init(void) {
  // ...

  // Open AppMessage connection
  app_message_register_inbox_received(prv_inbox_received_handler);
  app_message_open(128, 128);

  // ...
}
```

Once triggered, our handler will receive a ``DictionaryIterator`` containing
``Tuple`` objects for each `messageKey`. Note that the key names need to be
prefixed with `MESSAGE_KEY_`.

```c
static void prv_inbox_received_handler(DictionaryIterator *iter, void *context) {
  // Read color preferences
  Tuple *bg_color_t = dict_find(iter, MESSAGE_KEY_BackgroundColor);
  if(bg_color_t) {
    GColor bg_color = GColorFromHEX(bg_color_t->value->int32);
  }

  Tuple *fg_color_t = dict_find(iter, MESSAGE_KEY_ForegroundColor);
  if(fg_color_t) {
    GColor fg_color = GColorFromHEX(fg_color_t->value->int32);
  }

  // Read boolean preferences
  Tuple *second_tick_t = dict_find(iter, MESSAGE_KEY_SecondTick);
  if(second_tick_t) {
    bool second_ticks = second_tick_t->value->int32 == 1;
  }

  Tuple *animations_t = dict_find(iter, MESSAGE_KEY_Animations);
  if(animations_t) {
    bool animations = animations_t->value->int32 == 1;
  }

}
```

## Persisting Settings

By default, Clay will persist your settings in localStorage within the
mobile application. It is common practice to also save settings within the
persistent storage on the watch. This creates a seemless experience for users
launching your application, as their settings can be applied on startup. This
means there isn't an initial delay while the settings are loaded from the phone.

You could save each individual value within the persistent storage, or you could
create a struct to hold all of your settings, and save that entire object. This
has the benefit of simplicity, and because writing to persistent storage is
slow, it also provides improved performance.

```c
// Persistent storage key
#define SETTINGS_KEY 1

// Define our settings struct
typedef struct ClaySettings {
  GColor BackgroundColor;
  GColor ForegroundColor;
  bool SecondTick;
  bool Animations;
} ClaySettings;

// An instance of the struct
static ClaySettings settings;

// AppMessage receive handler
static void prv_inbox_received_handler(DictionaryIterator *iter, void *context) {
  // Assign the values to our struct
  Tuple *bg_color_t = dict_find(iter, MESSAGE_KEY_BackgroundColor);
  if (bg_color_t) {
    settings.BackgroundColor = GColorFromHEX(bg_color_t->value->int32);
  }
  // ...
  prv_save_settings();
}

// Save the settings to persistent storage
static void prv_save_settings() {
  persist_write_data(SETTINGS_KEY, &settings, sizeof(settings));
}
```

You can see a complete implementation of persisting a settings struct in the
[Pebble Clay Example]({{ site.links.examples_org }}/clay-example).

## What's Next

If you're thinking that Clay won't be as flexible as hand crafting your own
configuration pages, you're mistaken.

Developers can extend the functionality of Clay in a number of ways:

* Define a
[custom function](https://github.com/pebble/clay#custom-function) to enhance the
interactivity of the page.
* [Override events](https://github.com/pebble/clay#handling-the-showconfiguration-and-webviewclosed-events-manually)
and transform the format of the data before it's transferred to the watch.
* Create and share your own
[custom components](https://github.com/pebble/clay#custom-components).

Why not find out more about [Clay for Pebble](https://github.com/pebble/clay)
and perhaps even
[contribute](https://github.com/pebble/clay/blob/master/CONTRIBUTING.md) to the
project, it's open source!

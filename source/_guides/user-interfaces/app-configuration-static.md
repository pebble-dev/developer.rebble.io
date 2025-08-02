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

title: App Configuration (manual setup)
description: |
  How to allow users to customize an app with a static configuration page.
guide_group:
order: 0
---

> This guide provides the steps to manually create an app configuration page.
> The preferred approach is to use
> {% guide_link user-interfaces/app-configuration "Clay for Pebble" %} instead.

Many watchfaces and apps in the Pebble appstore include the ability to customize
their behavior or appearance through the use of a configuration page. This
mechanism consists of an HTML form that passes the user's chosen configuration
data to PebbleKit JS, which in turn relays it to the watchface or watchapp.

The HTML page created needs to be hosted online, so that it is accessible to
users via the Pebble application. If you do not want to host your own HTML
page, you should follow the
{% guide_link user-interfaces/app-configuration "Clay guide" %} to create a
local config page.

App configuration pages are powered by PebbleKit JS. To find out more about
PebbleKit JS,
{% guide_link communication/using-pebblekit-js "read the guide" %}.



## Adding Configuration

For an app to be configurable, it must marked as 'configurable' in the
app's {% guide_link tools-and-resources/app-metadata "`package.json`" %}
`capabilities` array. The presence of this value tells the mobile app to
display a gear icon next to the app, allowing users to access the configuration
page.

```json
"capabilities": [ "configurable" ]
```


## Choosing Key Values

Since the config page must transmit the user's preferred options to the
watchapp, the first step is to decide upon the ``AppMessage`` keys defined in
`package.json` that will be used to represent the chosen value for each option
on the config page:

```json
"messageKeys": [
  "BackgroundColor",
  "ForegroundColor",
  "SecondTick",
  "Animations"
]
```

These keys will automatically be available both in C on the watch and in
PebbleKit JS on the phone.

Each of these keys will apply to the appropriate input element on the config
page, with the user's chosen value transmitted to the watchapp's
``AppMessageInboxReceived`` handler once the page is submitted.



## Showing the Config Page

Once an app is marked as `configurable`, the PebbleKit JS component must
implement `Pebble.openURL()` in the `showConfiguration` event handler in
`index.js` to present the developer's HTML page when the user wants to configure
the app:

```js
Pebble.addEventListener('showConfiguration', function() {
  var url = 'http://example.com/config.html';

  Pebble.openURL(url);
});
```


## Creating the Config Page

The basic structure of an HTML config page begins with a template HTML file:

> Note: This page will be plain and unstyled. CSS styling must be performed
> separately, and is not covered here.

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Example Configuration</title>
  </head>
  <body>
    <p>This is an example HTML forms configuration page.</p>
  </body>
</html>
```

The various UI elements the user will interact with to choose their preferences
must be placed within the `body` tag, and will most likely take the form of
HTML `input` elements. For example, a text input field for each of the example
color options will look like the following:

```html
<input id='background_color_input' type='text' value='#000000'>
  Background Color
</input>
<input id='foreground_color_input' type='text' value='#000000'>
  Foreground Color
</input>
```

Other components include checkboxes, such as the two shown below for each of
the example boolean options:

```html
<input id='second_tick_checkbox' type='checkbox'>
  Enable Second Ticks
</input>
<input id='animations_checkbox' type='checkbox'>
  Show Animations
</input>
```

The final element should be the 'Save' button, used to trigger the sending of
the user's preferences back to PebbleKit JS.

```html
<input id='submit_button' type='button' value='Save'>
```


## Submitting Config Data

Once the 'Save' button is pressed, the values of all the input elements should
be encoded and included in the return URL as shown below:

```html
<script>
  // Get a handle to the button's HTML element
  var submitButton = document.getElementById('submit_button');

  // Add a 'click' listener
  submitButton.addEventListener('click', function() {
    // Get the config data from the UI elements
    var backgroundColor = document.getElementById('background_color_input');
    var foregroundColor = document.getElementById('foreground_color_input');
    var secondTickCheckbox = document.getElementById('second_tick_checkbox');
    var animationsCheckbox = document.getElementById('animations_checkbox');

    // Make a data object to be sent, coercing value types to integers
    var options = {
      'background_color': parseInt(backgroundColor.value, 16),
      'foreground_color': parseInt(foregroundColor.value, 16),
      'second_ticks': secondTickCheckbox.checked == 'true' ? 1 : 0,
      'animations': animationsCheckbox.checked == 'true' ? 1 : 0
    };

    // Determine the correct return URL (emulator vs real watch)
    function getQueryParam(variable, defaultValue) {
      var query = location.search.substring(1);
      var vars = query.split('&');
      for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split('=');
        if (pair[0] === variable) {
          return decodeURIComponent(pair[1]);
        }
      }
      return defaultValue || false;
    }
    var return_to = getQueryParam('return_to', 'pebblejs://close#');

    // Encode and send the data when the page closes
    document.location = return_to + encodeURIComponent(JSON.stringify(options));
  });
</script>
```

> Note: Remember to use `encodeURIComponent()` and `decodeURIComponent()` to
> ensure the JSON data object is transmitted without error.


## Hosting the Config Page

In order for users to access your configuration page, it needs to be hosted
online somewhere. One potential free service to host your configuration page
is Github Pages:

[Github Pages](https://pages.github.com/) allow you to host your HTML, CSS and
JavaScript files and directly access them from a special branch within your
Github repo. This also has the added advantage of encouraging the use of
version control.


## Relaying Data through PebbleKit JS

When the user submits the HTML form, the page will close and the result is
passed to the `webviewclosed` event handler in the PebbleKit JS `index.js` file:

```js
Pebble.addEventListener('webviewclosed', function(e) {
  // Decode the user's preferences
  var configData = JSON.parse(decodeURIComponent(e.response));
}
```

The data from the config page should be converted to the appropriate keys and
value types expected by the watchapp, and sent via ``AppMessage``:

```js
// Send to the watchapp via AppMessage
var dict = {
  'BackgroundColor': configData.background_color,
  'ForegroundColor': configData.foreground_color,
  'SecondTick': configData.second_ticks,
  'Animations': configData.animations
};

// Send to the watchapp
Pebble.sendAppMessage(dict, function() {
  console.log('Config data sent successfully!');
}, function(e) {
  console.log('Error sending config data!');
});
```


## Receiving Config Data

Once the watchapp has called ``app_message_open()`` and registered an
``AppMessageInboxReceived`` handler, that handler will be called once the data
has arrived on the watch. This occurs once the user has pressed the submit
button.

To obtain the example keys and values shown in this guide, simply look for and
read the keys as ``Tuple`` objects using the ``DictionaryIterator`` provided:

```c
static void inbox_received_handler(DictionaryIterator *iter, void *context) {
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

  // App should now update to take the user's preferences into account
  reload_config();
}
```


Read the {% guide_link communication %} guides for more information about using
the ``AppMessage`` API.

If you're looking for a simpler option, we recommend using
{% guide_link user-interfaces/app-configuration "Clay for Pebble" %} instead.

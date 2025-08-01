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
tutorial_part: 3

title: Adding Web Content
description: A guide to adding web-based content your Pebble watchface
permalink: /tutorials/watchface-tutorial/part3/
generate_toc: true
---

In the previous tutorial parts, we created a simple watchface to tell the time
and then improved it with a custom font and background bitmap. There's a lot you
can do with those elements, such as add more bitmaps, an extra ``TextLayer``
showing the date, but let's aim even higher. This part is longer than the last,
so make sure you have a nice cup of your favourite hot beverage on hand before
embarking!

In this tutorial we will add some extra content to the watchface that is fetched
from the web using [PebbleKit JS](/guides/communication/using-pebblekit-js/).
This part of the SDK allows you to use JavaScript to access the web as well as
the phone's location services and storage. It even allows you to display a
configuration screen to give users options over how they want your watchface or
app to look and run.

By the end of this tutorial we will arrive at a watchface like the one below, in
all its customized glory:

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/3-final.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

To continue from the last part, you can either modify your existing Pebble
project or create a new one, using the code from that project's main `.c` file
as a starting template. For reference, that should look 
[something like this](https://gist.github.com/pebble-gists/d216d9e0b840ed296539). 


## Preparing the Watchface Layout

The content we will be fetching will be the current weather conditions and
temperature from [OpenWeatherMap](http://openweathermap.org). We will need a new
``TextLayer`` to show this extra content. Let's do that now at the top of the C
file, as we did before:

```c
static TextLayer *s_weather_layer;
```

As usual, we then create it properly in `main_window_load()` after the existing
elements. Here is the ``TextLayer`` setup; this should all be familiar to you
from the previous two tutorial parts:

```c
// Create temperature Layer
s_weather_layer = text_layer_create(
    GRect(0, PBL_IF_ROUND_ELSE(125, 120), bounds.size.w, 25));

// Style the text
text_layer_set_background_color(s_weather_layer, GColorClear);
text_layer_set_text_color(s_weather_layer, GColorWhite);
text_layer_set_text_alignment(s_weather_layer, GTextAlignmentCenter);
text_layer_set_text(s_weather_layer, "Loading...");
```

We will be using the same font as the time display, but at a reduced font size.

You can add another font in `package.json` by duplicating the first font's
entry in the `media` array and changing the font size indicated in the `name`
field to `_20` or similar. Below is an example showing both fonts:

```json
"media": [
  {
    "type":"font",
    "name":"FONT_PERFECT_DOS_48",
    "file":"perfect-dos-vga.ttf",
    "compatibility": "2.7"
  },
  {
    "type":"font",
    "name":"FONT_PERFECT_DOS_20",
    "file":"perfect-dos-vga.ttf",
    "compatibility": "2.7"
  },
]
```

Now we will load and apply that font as we did last time, beginning with a new
``GFont`` declared at the top of the file:

```c
static GFont s_weather_font;
```

Next, we load the resource and apply it to the new ``TextLayer`` and then add
that as a child layer to the main ``Window``:

```c
// Create second custom font, apply it and add to Window
s_weather_font = fonts_load_custom_font(resource_get_handle(RESOURCE_ID_FONT_PERFECT_DOS_20));
text_layer_set_font(s_weather_layer, s_weather_font);
layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_weather_layer));
```

Finally, as usual, we add the same destruction calls in `main_window_unload()`
as for everything else:

```c
// Destroy weather elements
text_layer_destroy(s_weather_layer);
fonts_unload_custom_font(s_weather_font);
```

After compiling and installing, your watchface should look something like this:

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/3-loading.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}


## Preparing AppMessage

The primary method of communication for all Pebble watchapps and watchfaces is
the ``AppMessage`` API. This allows the construction of key-value dictionaries
for transmission between the watch and connected phone. The standard procedure
we will be following for enabling this communication is as follows:

1. Create ``AppMessage`` callback functions to process incoming messages and
   errors.
2. Register this callback with the system. 
3. Open ``AppMessage`` to allow app communication.

After this process is performed any incoming messages will cause a call to the
``AppMessageInboxReceived`` callback and allow us to react to its contents.
Let's get started!

The callbacks should be placed before they are referred to in the code file, so
a good place is above `init()` where we will be registering them. The function
signature for ``AppMessageInboxReceived`` is shown below:

```c
static void inbox_received_callback(DictionaryIterator *iterator, void *context) {
    
}
```

We will also create and register three other callbacks so we can see all
outcomes and any errors that may occur, such as dropped messages. These are
reported with calls to ``APP_LOG`` for now, but more detail 
[can be gotten from them](http://stackoverflow.com/questions/21150193/logging-enums-on-the-pebble-watch):

```c
static void inbox_dropped_callback(AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Message dropped!");
}

static void outbox_failed_callback(DictionaryIterator *iterator, AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Outbox send failed!");
}

static void outbox_sent_callback(DictionaryIterator *iterator, void *context) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Outbox send success!");
}
```

With this in place, we will now register the callbacks with the system in
`init()`:

```c
// Register callbacks
app_message_register_inbox_received(inbox_received_callback);
app_message_register_inbox_dropped(inbox_dropped_callback);
app_message_register_outbox_failed(outbox_failed_callback);
app_message_register_outbox_sent(outbox_sent_callback);
```

And finally the third step, opening ``AppMessage`` to allow the watchface to
receive incoming messages, directly below
``app_message_register_inbox_received()``. It is considered best practice to
register callbacks before opening ``AppMessage`` to ensure that no messages are
missed. The code snippet below shows this process using two variables to specify
the inbox and outbox size (in bytes):

```c
// Open AppMessage
const int inbox_size = 128;
const int outbox_size = 128;
app_message_open(inbox_size, outbox_size);
```

> Read 
> [*Buffer Sizes*](/guides/pebble-apps/communications/appmessage/#buffer-sizes) 
> to learn about using correct buffer sizes for your app.

## Preparing PebbleKit JS

The weather data itself will be downloaded by the JavaScript component of the
watchface, and runs on the connected phone whenever the watchface is opened. 

To begin using PebbleKit JS, add a new file to your project at 
`src/pkjs/index.js` to contain your JavaScript code.

To get off to a quick start, we will provide a basic template for using the
PebbleKit JS SDK. This template features two basic event listeners. One is for
the 'ready' event, which fires when the JS environment on the phone is first
available after launch. The second is for the 'appmessage' event, which fires
when an AppMessage is sent from the watch to the phone.

This template is shown below for you to start your JS file:

```js
// Listen for when the watchface is opened
Pebble.addEventListener('ready', 
  function(e) {
    console.log('PebbleKit JS ready!');
  }
);

// Listen for when an AppMessage is received
Pebble.addEventListener('appmessage',
  function(e) {
    console.log('AppMessage received!');
  }                     
);
```

After compiling and installing the watchface, open the app logs.

You can listen for app logs by running `pebble logs`, supplying your
phone's IP address with the `--phone` switch. For example: 

```
pebble logs --phone 192.168.1.78
```

You can also combine these two commands into one: 

```
pebble install --logs --phone 192.168.1.78
```

You should see a message matching that set to appear using `console.log()` in
the JS console in the snippet above! This is where any information sent using
``APP_LOG`` in the C file or `console.log()` in the JS file will be shown, and
is very useful for debugging!


## Getting Weather Information

To download weather information from 
[OpenWeatherMap.org](http://openweathermap.org), we will perform three steps in 
our JS file:

1. Request the user's location from the phone.
2. Perform a call to the OpenWeatherMap API using an `XMLHttpRequest` object,
   supplying the location given to us from step 1.
3. Send the information we want from the XHR request response to the watch for
   display on our watchface.

You will need to add `location` to the `capabilities` array in the
`package.json` file. This will allow the watchapp to access the phone's location
services. This is shown in the code segment below:

```json
"capabilities": ["location"]
```

The next step is simple to perform, and is shown in full below. The method we
are using requires two other functions to use as callbacks for the success and
failure conditions after requesting the user's location. It also requires two
other pieces of information: `timeout` of the request and the `maximumAge` of
the data:

```js
function locationSuccess(pos) {
  // We will request the weather here
}

function locationError(err) {
  console.log('Error requesting location!');
}

function getWeather() {
  navigator.geolocation.getCurrentPosition(
    locationSuccess,
    locationError,
    {timeout: 15000, maximumAge: 60000}
  );
}

// Listen for when the watchface is opened
Pebble.addEventListener('ready', 
  function(e) {
    console.log('PebbleKit JS ready!');
    
    // Get the initial weather
    getWeather();
  }
);
```

Notice that when the `ready` event occurs, `getWeather()` is called, which in
turn calls `getCurrentPosition()`. When this is successful, `locationSuccess()`
is called and provides us with a single argument: `pos`, which contains the
location information we require to make the weather info request. Let's do that
now.

The next step is to assemble and send an `XMLHttpRequest` object to make the
request to OpenWeatherMap.org. To make this easier, we will provide a function
that simplifies its usage. Place this before `locationSuccess()`:

```js
var xhrRequest = function (url, type, callback) {
  var xhr = new XMLHttpRequest();
  xhr.onload = function () {
    callback(this.responseText);
  };
  xhr.open(type, url);
  xhr.send();
};
```

The three arguments we have to provide when calling `xhrRequest()` are the URL,
the type of request (`GET` or `POST`, for example) and a callback for when the
response is received. The URL is specified on the OpenWeatherMap API page, and
contains the coordinates supplied by `getCurrentPosition()`, the latitude and
longitude encoded at the end:

{% include guides/owm-api-key-notice.html %}

```js
var url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
  pos.coords.latitude + '&lon=' + pos.coords.longitude + '&appid=' + myAPIKey;
```

The type of the XHR will be a 'GET' request, to *get* information from the
service. We will incorporate the callback into the function call for
readability, and the full code snippet is shown below:

```js
function locationSuccess(pos) {
  // Construct URL
  var url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
      pos.coords.latitude + '&lon=' + pos.coords.longitude + '&appid=' + myAPIKey;
  
  // Send request to OpenWeatherMap
  xhrRequest(url, 'GET', 
    function(responseText) {
      // responseText contains a JSON object with weather info
      var json = JSON.parse(responseText);
      
      // Temperature in Kelvin requires adjustment
      var temperature = Math.round(json.main.temp - 273.15);
      console.log('Temperature is ' + temperature);
      
      // Conditions
      var conditions = json.weather[0].main;      
      console.log('Conditions are ' + conditions);
    }      
  );
}
```

Thus when the location is successfully obtained, `xhrRequest()` is called. When
the response arrives, the JSON object is parsed and the temperature and weather
conditions obtained. To discover the structure of the JSON object we can use
`console.log(responseText)` to see its contents.

To see how we arrived at some of the statements above, such as
`json.weather[0].main`, here is an 
[example response](https://gist.github.com/pebble-gists/216e6d5a0f0bd2328509#file-example-response-json) 
for London, UK. We can see that by following the JSON structure from our
variable called `json` (which represents the root of the structure) we can
access any of the data items. So to get the wind speed we would access
`json.wind.speed`, and so on.

## Showing Weather on Pebble

The final JS step is to send the weather data back to the watch. To do this we must
pick some appmessage keys to send back. Since we want to display the temperature
and current conditions, we'll create one key for each of those.

You can add your ``AppMessage`` keys in the `messageKeys` object in
`package.json` as shown below for the example keys:

```json
"messageKeys": [
  "TEMPERATURE",
  "CONDITIONS",
]
```

To send the data, we call `Pebble.sendAppMessage()` after assembling the weather
info variables `temperature` and `conditions` into a dictionary. We can
optionally also supply two functions as success and failure callbacks:

```js
// Assemble dictionary using our keys
var dictionary = {
  'TEMPERATURE': temperature,
  'CONDITIONS': conditions
};

// Send to Pebble
Pebble.sendAppMessage(dictionary,
  function(e) {
    console.log('Weather info sent to Pebble successfully!');
  },
  function(e) {
    console.log('Error sending weather info to Pebble!');
  }
);
```

While we are here, let's add another call to `getWeather()` in the `appmessage`
event listener for when we want updates later, and will send an ``AppMessage``
from the watch to achieve this:

```js
// Listen for when an AppMessage is received
Pebble.addEventListener('appmessage',
  function(e) {
    console.log('AppMessage received!');
    getWeather();
  }                     
);
```

The final step on the Pebble side is to act on the information received from
PebbleKit JS and show the weather data in the ``TextLayer`` we created for this
very purpose. To do this, go back to your C code file and find your
``AppMessageInboxReceived`` implementation (such as our
`inbox_received_callback()` earlier). This will now be modified to process the
received data. When the watch receives an ``AppMessage`` message from the JS
part of the watchface, this callback will be called and we will be provided a
dictionary of data in the form of a `DictionaryIterator` object, as seen in the
callback signature. `MESSAGE_KEY_TEMPERATURE` and `MESSAGE_KEY_CONDITIONS`
will be automatically provided as we specified them in `package.json`.

Before examining the dictionary we add three character
buffers; one each for the temperature and conditions and the other for us to
assemble the entire string. Remember to be generous with the buffer sizes to
prevent overruns:

```c
// Store incoming information
static char temperature_buffer[8];
static char conditions_buffer[32];
static char weather_layer_buffer[32];
```

We then store the incoming information by reading the appropriate `Tuple`s to
the two buffers using `snprintf()`:

```c
// Read tuples for data
Tuple *temp_tuple = dict_find(iterator, MESSAGE_KEY_TEMPERATURE);
Tuple *conditions_tuple = dict_find(iterator, MESSAGE_KEY_CONDITIONS);

// If all data is available, use it
if(temp_tuple && conditions_tuple) {
  snprintf(temperature_buffer, sizeof(temperature_buffer), "%dC", (int)temp_tuple->value->int32);
  snprintf(conditions_buffer, sizeof(conditions_buffer), "%s", conditions_tuple->value->cstring);
}
```

Lastly within this `if` statement, we assemble the complete string and instruct
the ``TextLayer`` to display it:

```c
// Assemble full string and display
snprintf(weather_layer_buffer, sizeof(weather_layer_buffer), "%s, %s", temperature_buffer, conditions_buffer);
text_layer_set_text(s_weather_layer, weather_layer_buffer);
```

After re-compiling and re-installing you should be presented with a watchface
that looks similar to the one shown below:

{% screenshot_viewer %}
{
  "image": "/images/getting-started/watchface-tutorial/3-final.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

Remember, if the text is too large for the screen, you can reduce the font
size in `package.json` for that resource's entry in the `media` array. Don't
forget to change the constants in the `.c` file to match the new resource's
`name`.

An extra step we will perform is to modify the C code to obtain regular weather
updates, in addition to whenever the watchface is loaded. To do this we will
take advantage of a timer source we already have - the ``TickHandler``
implementation, which we have called `tick_handler()`. Let's modify this to get
weather updates every 30 minutes by adding the following code to the end of
`tick_handler()` in our main `.c` file:

```c
// Get weather update every 30 minutes
if(tick_time->tm_min % 30 == 0) {
  // Begin dictionary
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);

  // Add a key-value pair
  dict_write_uint8(iter, 0, 0);

  // Send the message!
  app_message_outbox_send();
}
```

Thanks to us adding a call to `getWeather()` in the `appmessage` JS event
handler earlier, this message send in the ``TickHandler`` will result in new
weather data being downloaded and sent to the watch. Job done!

## Conclusion

Whew! That was quite a long tutorial, but here's all you've learned:

1. Managing multiple font sizes.
2. Preparing and opening ``AppMessage``.
3. Setting up PebbleKit JS for interaction with the web.
4. Getting the user's current location with `navigator.getCurrentPosition()`.
5. Extracting information from a JSON response.
6. Sending ``AppMessage`` to and from the watch.

Using all this it is possible to `GET` and `POST` to a huge number of web
services to display data and control these services.

As usual, you can compare your code to the example code provided using the button
below.

[View Source Code >{center,bg-lightblue,fg-white}](https://gist.github.com/216e6d5a0f0bd2328509)


## What's Next?

The next section of the tutorial will introduce the Battery Service, and
demonstrate how to add a battery bar to your watchface.

[Go to Part 4 &rarr; >{wide,bg-dark-red,fg-white}](/tutorials/watchface-tutorial/part4/)

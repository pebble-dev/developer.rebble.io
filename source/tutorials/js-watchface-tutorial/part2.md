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
tutorial: js-watchface
tutorial_part: 2

title: Adding Web Content to a Rocky.js JavaScript Watchface
description: A guide to adding web content to a JavaScript watchface
permalink: /tutorials/js-watchface-tutorial/part2/
menu_section: tutorials
generate_toc: true
platform_choice: true
---

{% include tutorials/rocky-js-warning.html %}

In the [previous tutorial](/tutorials/js-watchface-tutorial/part1), we looked
at the process of creating a basic watchface using Pebble's new JavaScript API.

In this tutorial, we'll extend the example to add weather conditions from the
Internet to our watchface.

![rocky >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/js-watchface-tutorial/tictoc-weather.png)

We'll be using the JavaScript component `pkjs`, which runs on the user's mobile
device using [PebbleKit JS](/docs/pebblekit-js). This `pkjs` component can be
used to access information from the Internet and process it on the phone. This
`pkjs` environment does not have the same the hardware and memory constraints of
the Pebble.

## First Steps

^CP^ The first thing we'll need to do is add a new JavaScript file to the
project we created in [Part 1](/tutorials/js-watchface-tutorial/part1). Click
'Add New' in the left menu, set the filename to `index.js` and the 'TARGET' to
'PebbleKit JS'.

^LC^ The first thing we'll need to do is edit a file from the project we
created in [Part 1](/tutorials/js-watchface-tutorial/part1). The file is
called `/src/pkjs/index.js` and it is the entry point for the `pkjs` portion
of the application.

This `pkjs` component of our application is capable of sending and receiving
messages with the smartwatch, accessing the user's location, making web
requests, and an assortment of other tasks that are all documented in the
[PebbleKit JS](/docs/pebblekit-js) documentation.

> Although Rocky.js (watch) and `pkjs` (phone) both use JavaScript, they
> have separate APIs and purposes. It is important to understand the differences
> and not attempt to run your code within the wrong component.

## Sending and Receiving Messages

Before we get onto the example, it's important to understand how to send and
receive messages between the Rocky.js component on the smartwatch, and the
`pkjs` component on the mobile device.

### Sending Messages

To send a message from the smartwatch to the mobile device, use the
``rocky.postMessage`` method, which allows you to send an arbitrary JSON
object:

```js
// rocky index.js
var rocky = require('rocky');

// Send a message from the smartwatch
rocky.postMessage({'test': 'hello from smartwatch'});
```

To send a message from the mobile device to the smartwatch, use the
``Pebble.postMessage`` method:

```js
// pkjs index.js

// Send a message from the mobile device
Pebble.postMessage({'test': 'hello from mobile device'});
```

### Message Listeners

We can create a message listener in our smartwatch code using the ``rocky.on``
method:

```js
// rocky index.js

// On the smartwatch, begin listening for a message from the mobile device
rocky.on('message', function(event) {
  // Get the message that was passed
  console.log(JSON.stringify(event.data));
});
```

We can also create a message listener in our `pkjs` code using the ``Pebble.on``
method:

```js
// pkjs index.js

// On the phone, begin listening for a message from the smartwatch
Pebble.on('message', function(event) {
  // Get the message that was passed
  console.log(JSON.stringify(event.data));
});
```

## Requesting Location

Our `pkjs` component can access to the location of the user's smartphone. The
Rocky.js component cannot access location information directly, it must request
it from `pkjs`.

^CP^ In order to use this functionality, you must change your project settings
in CloudPebble. Click 'SETTINGS' in the left menu, then tick 'USES LOCATION'.

<div class="platform-specific" data-sdk-platform="local">
{% markdown {} %}
In order to use this functionality, your application must include the
`location` flag in the
[`pebble.capabilities`](/guides/tools-and-resources/app-metadata/)
array of your `package.json` file.


```js
// file: package.json
// ...
  "pebble": {
    "capabilities": ["location"]
  }
// ...
```
{% endmarkdown %}
</div>

Once we've added the `location` flag, we can access GPS coordinates using the
[Geolocation API](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation).
In this example, we're going to request the user's location when we receive the
"fetch" message from the smartwatch.

```js
// pkjs index.js

Pebble.on('message', function(event) {
  // Get the message that was passed
  var message = event.data;

  if (message.fetch) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      // TODO: fetch weather
    }, function(err) {
      console.error('Error getting location');
    },
    { timeout: 15000, maximumAge: 60000 });
  }
});
```

## Web Service Calls

The `pkjs` side of our application can also access the
[XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)
object. Using this object, developers are able to interact with external web
services.

In this tutorial, we will interface with
[Open Weather Map](http://openweathermap.org/) – a common weather API used by
the [Pebble Developer Community](https://forums.rebble.io/c/development).

The `XMLHttpRequest` object is quite powerful, but can be intimidating to get
started with. To make things a bit simpler, we'll wrap the object with a helper
function which makes the request, then raises a callback:

```js
// pkjs index.js

function request(url, type, callback) {
  var xhr = new XMLHttpRequest();
  xhr.onload = function () {
    callback(this.responseText);
  };
  xhr.open(type, url);
  xhr.send();
}
```

The three arguments we have to provide when calling our `request()` method are
the URL, the type of request (`GET` or `POST`) and a callback for when the
response is received.

### Fetching Weather Data

The URL is specified on the
[OpenWeatherMap API page](http://openweathermap.org/current), and contains the
coordinates supplied by `getCurrentPosition()` (latitude and longitude),
followed by the API key:

{% include guides/owm-api-key-notice.html %}

```js
var myAPIKey = '1234567';
var url = 'http://api.openweathermap.org/data/2.5/weather' +
          '?lat=' + pos.coords.latitude +
          '&lon=' + pos.coords.longitude +
          '&appid=' + myAPIKey;
```

All together, our message handler should now look like the following:

```js
// pkjs index.js

var myAPIKey = '1234567';

Pebble.on('message', function(event) {
  // Get the message that was passed
  var message = event.data;

  if (message.fetch) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      var url = 'http://api.openweathermap.org/data/2.5/weather' +
              '?lat=' + pos.coords.latitude +
              '&lon=' + pos.coords.longitude +
              '&appid=' + myAPIKey;

      request(url, 'GET', function(respText) {
        var weatherData = JSON.parse(respText);
        //TODO: Send weather to smartwatch
      });
    }, function(err) {
      console.error('Error getting location');
    },
    { timeout: 15000, maximumAge: 60000 });
  }
});
```

## Finishing Up

Once we receive the weather data from OpenWeatherMap, we need to send it to the
smartwatch using ``Pebble.postMessage``:

```js
// pkjs index.js

// ...
request(url, 'GET', function(respText) {
  var weatherData = JSON.parse(respText);

  Pebble.postMessage({
    'weather': {
      // Convert from Kelvin
      'celcius': Math.round(weatherData.main.temp - 273.15),
      'fahrenheit': Math.round((weatherData.main.temp - 273.15) * 9 / 5 + 32),
      'desc': weatherData.weather[0].main
    }
  });
});
```

On the smartwatch, we'll need to create a message handler to listen for a
`weather` message, and store the information so it can be drawn on screen.

```js
// rocky index.js
var rocky = require('rocky');

// Global object to store weather data
var weather;

rocky.on('message', function(event) {
  // Receive a message from the mobile device (pkjs)
  var message = event.data;

  if (message.weather) {
    // Save the weather data
    weather = message.weather;

    // Request a redraw so we see the information
    rocky.requestDraw();
  }
});
```

We also need to send the 'fetch' command from the smartwatch to ask for weather
data when the application starts, then every hour:

```js
// rocky index.js

// ...

rocky.on('hourchange', function(event) {
  // Send a message to fetch the weather information (on startup and every hour)
  rocky.postMessage({'fetch': true});
});
```

Finally, we'll need some new code in our Rocky `draw` handler to display the
temperature and conditions:

```js
// rocky index.js
var rocky = require('rocky');

// ...

function drawWeather(ctx, weather) {
  // Create a string describing the weather
  //var weatherString = weather.celcius + 'ºC, ' + weather.desc;
  var weatherString = weather.fahrenheit + 'ºF, ' + weather.desc;

  // Draw the text, top center
  ctx.fillStyle = 'lightgray';
  ctx.textAlign = 'center';
  ctx.font = '14px Gothic';
  ctx.fillText(weatherString, ctx.canvas.unobstructedWidth / 2, 2);
}

rocky.on('draw', function(event) {
  var ctx = event.context;
  var d = new Date();

  // Clear the screen
  ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);

  // Draw the conditions (before clock hands, so it's drawn underneath them)
  if (weather) {
    drawWeather(ctx, weather);
  }

  // ...
});
```

## Conclusion

So there we have it, we successfully added web content to our JavaScript
watchface! To do this we:

1. Enabled `location` in our `package.json`.
2. Added a `Pebble.on('message', function() {...});` listener in `pkjs`.
3. Retrieved the users current GPS coordinates in `pkjs`.
4. Used `XMLHttpRequest` to query OpenWeatherMap API.
5. Sent the current weather conditions from the mobile device, to the
smartwatch, using `Pebble.postMessage()`.
6. On the smartwatch, we created a `rocky.on('message', function() {...});`
listener to receive the weather data from `pkjs`.
7. We subscribed to the `hourchange` event, to send a message to `pkjs` to
request the weather data when the application starts and every hour.
8. Then finally we drew the weather conditions on the screen as text.

If you have problems with your code, check it against the sample source code
provided using the button below.

[View Source Code >{center,bg-lightblue,fg-white}](https://github.com/pebble-examples/rocky-watchface-tutorial-part2)

## What's Next

We hope you enjoyed this tutorial and that it inspires you to make something
awesome!

Why not let us know what you've created by tweeting
[@pebbledev](https://twitter.com/pebbledev), or join our epic developer
community on [Discord]({{ site.links.discord_invite }}).

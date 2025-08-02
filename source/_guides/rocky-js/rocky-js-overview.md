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

title: Rocky.js Overview
description: |
  Details of Rocky.js projects, available APIs, limitations, and how to get
  started.
guide_group: rocky-js
order: 1
related_examples:
 - title: Tutorial Part 1
   url: https://github.com/pebble-examples/rocky-watchface-tutorial-part1
 - title: Tutorial Part 2
   url: https://github.com/pebble-examples/rocky-watchface-tutorial-part2
 - title: Memory Pressure
   url: https://github.com/pebble-examples/rocky-memorypressure
---

Rocky.js can be used to create Pebble 4.0 watchfaces using ECMAScript 5.1
JavaScript, which runs natively on the watch. Rocky.js is possible due to
[our collaboration](https://github.com/Samsung/jerryscript/wiki/JerryScriptWorkshopApril2016)
with [JerryScript](https://github.com/pebble/jerryscript).

> At this time, Rocky.js cannot be used to create watchapps, but we're currently
working towards this goal.


## It's JavaScript on the freakin' watch!

```javascript
var rocky = require('rocky');

rocky.on('minutechange', function(event) {
  rocky.requestDraw();
});

rocky.on('draw', function(event) {
  var ctx = event.context;
  ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);
  ctx.fillStyle = 'white';
  ctx.textAlign = 'center';

  var w = ctx.canvas.unobstructedWidth;
  var h = ctx.canvas.unobstructedHeight;
  ctx.fillText('JavaScript\non the watch!', w / 2, h / 2);
});
```

![Rocky >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/2016-08-16-jotw.png)


## Rocky.js Projects

Rocky.js projects have a different structure from projects created using our C
SDK. There is a Rocky.js (rocky) component which runs on the watch, and a
{% guide_link communication/using-pebblekit-js "PebbleKit JS" %} (pkjs) component
which runs on the phone. The pkjs component allows developers to access web
services, use geolocation, and offload data processing tasks to the phone.


### Creating a Project

Once you've installed the Pebble SDK, you can create a new Rocky.js project
using the following command:

```nc|text
$ pebble new-project --rocky <strong><em>projectname</em></strong>
```


### Rocky JS

In the local SDK, our main entry point into the application on the watch is
`/src/rocky/index.js`.

This is file is where our Rocky.js JavaScript code resides. All code within this
file will be executed on the smartwatch. In addition to standard JavaScript,
developers have access to the [rocky](/docs/rockyjs/rocky/) object. Additional
scripts may also be added, see [below](#additional-scripts).


### PebbleKit JS

In the local SDK, our primary [PebbleKit JS](/docs/pebblekit-js/) script is
`/src/pkjs/index.js`.

All PebbleKit JS code will execute on the mobile device connected to the
smartwatch. In addition to standard JavaScript, developers have access to
[WebSockets](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API),
[XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest),
[Geolocation](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation),
[LocalStorage](https://developer.mozilla.org/en-US/docs/Web/API/LocalStorage)
and the [Pebble](/docs/pebblekit-js/) object. Additional scripts may also be
added, see [below](#additional-scripts).


### Shared JS

If you need to share code between Rocky.js and PebbleKit JS, you can place
JavaScript files in a shared area.

In the local SDK, place your shared files in `/src/common/`.

Shared JavaScript files can be referenced using the
[CommonJS Module](http://www.commonjs.org/specs/modules/1.0/) format.

```javascript
// Shared JS (index.js)
function test() {
  console.log('Hello from shared code');
}

module.exports.test = test;
```

```javascript
// Rocky JS
var shared = require('../common/index');
shared.test();
```

```javascript
// PebbleKit JS
var shared = require('../common/index');
shared.test();
```


### Additional Scripts

Both the `Rocky JS` and ` PebbleKit JS` support the use of multiple .js files.
This helps to keep your code clean and modular. Use the
[CommonJS Module](http://www.commonjs.org/specs/modules/1.0/) format for
your additional scripts, then `require()` them within your script.

```javascript
// additional.js
function test() {
  console.log('Additional File');
}

module.exports.test = test;
```

```javascript
var additional = require('./additional');
additional.test();
```


## Available APIs

In this initial release of Rocky.js, we have focused on the ability to create
watchfaces only. We will be adding more and more APIs as time progresses, and
we're determined for JavaScript to have feature parity with the rest of the
Pebble developer ecosystem.

We've developed our API in-line with standard
[Web APIs](https://developer.mozilla.org/en-US/docs/Web/API), which may appear
strange to existing Pebble developers, but we're confident that this will
facilitate code re-use and provide a better experience overall.


### System Events

We've provided a series of events which every watchface will likely require, and
each of these events allow you to provide a callback function that is called
when the event occurs.

Existing Pebble developers will be familiar with the tick style events,
including:

* [`secondchange`](/docs/rockyjs/rocky/#on)
* [`minutechange`](/docs/rockyjs/rocky/#on)
* [`hourchange`](/docs/rockyjs/rocky/#on)
* [`daychange`](/docs/rockyjs/rocky/#on)

By using these events, instead of
[`setInterval`](/docs/rockyjs), we're automatically kept in sync with the wall
clock time.

We also have a
[`message`](/docs/rockyjs/rocky/#on) event for
receiving JavaScript JSON objects from the `pkjs` component, a
[`memorypressure`](/docs/rockyjs/rocky/#on) event when there is a notable change
in available system memory, and a [`draw`](/docs/rockyjs/rocky/#on) event which
you'll use to control the screen updates.

```javascript
var rocky = require('rocky');

rocky.on('minutechange', function(event) {
  // Request the screen to be redrawn on next pass
  rocky.requestDraw();
});
```


### Drawing Canvas

The canvas is a 2D rendering context and represents the display of the Pebble
smartwatch. We use the canvas context for drawing text and shapes. We're aiming
to support standard Web API methods and properties where possible, so the canvas
has been made available as a
[CanvasRenderingContext2D](/docs/rockyjs/CanvasRenderingContext2D/).

> Please note that the canvas isn't fully implemented yet, so certain methods
and properties are not available at this time. We're still working on this, so
expect more features in future updates!

```javascript
rocky.on('draw', function(event) {
  var ctx = event.context;

  ctx.fillStyle = 'red';
  ctx.textAlign = 'center';
  ctx.font = '14px Gothic';

  var w = ctx.canvas.unobstructedWidth;
  var h = ctx.canvas.unobstructedHeight;
  ctx.fillText('Rocky.js Rocks!', w / 2, h / 2);
});
```


### Messaging

For Rocky.js projects only, we've added a new simplified communication channel
[`postMessage()`](/docs/rockyjs/rocky/#postMessage) and
[`on('message', ...)`](/docs/rockyjs/rocky/#on) which allows you to send and
receive JavaScript JSON objects between the phone and smartwatch.

```javascript
// Rocky.js (rocky)

// Receive data from the phone (pkjs)
rocky.on('message', function(event) {
  console.log(JSON.stringify(event.data));
});

// Send data to the phone (pkjs)
rocky.postMessage({command: 'fetch'});
```

```javascript
// PebbleKit JS (pkjs)

// Receive data from the watch (rocky)
Pebble.on('message', function(event) {
  if(event.data.command === 'fetch') {
    // doSomething();
  }
});

// Send data to the watch (rocky)
Pebble.postMessage({
  'temperature': 90,
  'condition': 'Hot'
});
```

You can see an example of post message in action in
[part 2](https://github.com/pebble-examples/rocky-watchface-tutorial-part2) of
the Rocky.js tutorial.


### Memory Pressure

The [`memorypressure`](/docs/rockyjs/rocky/#on) event is emitted every time
there is a notable change in available system memory. This provides developers
with an opportunity to free some memory, in order to prevent their application
from being terminated when memory pressure is high.

```javascript
rocky.on('memorypressure', function(event) {
  console.log(event.level);
});
```

A detailed example of the [`memorypressure`](/docs/rockyjs/rocky/#on) event
is provided [here](https://github.com/pebble-examples/rocky-memorypressure).


### Content Size

The [`contentSize`](/docs/rockyjs/rocky/#UserPreferences) property allows
developers to dynamically adapt their watchface design based upon the system
`Text Size` preference (*Settings > Notifications > Text Size*).

`contentSize` is exposed in Rocky.js via the
[`UserPreferences`](/docs/rockyjs/rocky/#UserPreferences) object.

```javascript
rocky.on('draw', function(event) {
  var ctx = event.context;
  // ...
  if (rocky.userPreferences.contentSize === 'x-large') {
    ctx.font = '42px bold numbers Leco-numbers';
  } else {
    ctx.font = '32px bold numbers Leco-numbers';
  }
  // ...
});
```

## App Configuration

[Clay](https://github.com/pebble/clay#) is a JavaScript library that makes it
easy to add offline configuration pages to your Pebble apps. Out of the box,
Clay is not currently compatible with Rocky.js, but it can be made to work by
manually including the clay.js file and overriding the default events.

You can find a community Rocky.js project which uses Clay
[here](https://github.com/orviwan/rocky-leco-clay).


## Limitations

Although Rocky.js is finally out of beta, there are still some limitations and
restrictions that you need to be aware of:

* No support for custom fonts, images and other resources, yet.
* No C code allowed.
* No messageKeys.
* Pebble Packages are not supported.
* There are file size and memory constraints for Rocky.js projects.
If you include a large JS library, it probably won't work.


## How to Get Started

We created a [2-part tutorial](/tutorials/js-watchface-tutorial/part1/) for
getting started with Rocky.js watchfaces. It explains everything you need to
know about creating digital and analog watchfaces, plus how to retrieve
weather conditions from the internet.

If you're looking for more detailed information, check out the
[API Documentation](/docs/rockyjs).

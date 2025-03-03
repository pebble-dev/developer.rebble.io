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

title: Introducing Rocky.js Watchfaces!
author: jonb
tags:
- Freshly Baked
---

We're incredibly excited and proud to announce the first public beta version of
Rocky.js watchfaces for Pebble. Rocky.js is ECMAScript 5.1 JavaScript running
natively on Pebble smartwatches, thanks to
[our collaboration](https://github.com/Samsung/jerryscript/wiki/JerryScriptWorkshopApril2016)
with [JerryScript](https://github.com/pebble/jerryscript). This is an incredible
feat of engineering!


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

Right now we're giving you early access to this game-changing environment to
create watchfaces entirely in JavaScript. Feel free to share your code, to
install it on the emulator and on your watch (with the upcoming firmware 4.0),
but please don't upload apps to the appstore as they will stop working in a
future release.

<div class="alert alert--fg-white alert--bg-purple">
  {% markdown %}
  **Appstore Publishing**

  Rocky.js JavaScript watchfaces must not be published into the appstore at
  this time.
  {% endmarkdown %}
</div>

We can't wait to hear your feedback and see what amazing watchfaces you create!

Enough hype, let's dive into the eye of the tiger!


## Rocky.js Projects

Things are a little different in the JavaScript world, so let's take a closer
look at the structure of a Rocky.js project:

```nc|text
package.json
src/rocky/index.js
src/pkjs/index.js
common/*.js
```

#### package.json

The format of the `package.json` file remains roughly the same as existing
Pebble projects, with some minor differences:

* `"projectType": "rocky"`.
* Aplite `targetPlatform` is not supported.
* `resources` are not currently supported, but will consume space in your PBW if
specified.
* `messageKeys` are not permitted.

#### src/rocky/index.js

This is now the main entry point into our application on the watch. This is
where our Rocky.js JavaScript code resides. All code within this file will be
executed on the smartwatch. Additional scripts may be placed in this folder, see
[below](#additional-scripts).

#### src/pkjs/index.js

This file contains our [PebbleKit JS](/docs/pebblekit-js/) (pkjs) JavaScript
code. This code will execute on the mobile device connected to the smartwatch.
Additional scripts may be placed in this folder, see
[below](#additional-scripts).

For Rocky.js projects only, we've added a new simplified communication channel
[`postMessage()`](/docs/rockyjs/rocky/#postMessage) and
[`on('message', ...)`](/docs/rockyjs/rocky/#on) which allows you to send and
receive JavaScript JSON objects between the phone and smartwatch.

#### Additional Scripts

Both the `rocky` and `pkjs` folders support the use of multiple .js files, which
helps to keep your code clean and modular. Use the
[CommonJS Module](http://www.commonjs.org/specs/modules/1.0/) format for
your additional scripts, then `require()` them in your `index.js`.

```javascript
// file: src/rocky/additional.js
function test() {
  console.log('Additional File');
}

module.exports.test = test;
```

```javascript
// file: src/rocky/index.js
var additional = require('./additional');
additional.test();
```

#### common/*.js

If you need to share code between `rocky` and `pkjs`, you can create a `common`
folder, then add your JavaScript files.

```javascript
// file: src/common/shared.js
function test() {
  console.log('Hello from shared code');
}

module.exports.test = test;
```

```javascript
// file: src/rocky/index.js
var shared = require('../common/shared');
shared.test();
```

```javascript
// file: src/pkjs/index.js
var shared = require('../common/shared');
shared.test();
```

## Available APIs

In this initial release of Rocky.js, we have focused on the ability to create
watchfaces only. We will be adding more and more APIs as time progresses, and
we're determined for JavaScript to have feature parity with the rest of the
Pebble developer ecosystem.

We've developed our API in-line with standard Web APIs, which may appear strange
to existing Pebble developers, but we're confident that this will facilitate
code re-use and provide a better experience overall.

### System Events

We've provided a series of events which every watchface will likely require, and
each of these events allow you to provide a callback method which is emitted
when the event occurs.

Existing Pebble developers will be familiar with the tick style events,
including:
[`secondchange`](/docs/rockyjs/rocky/#on),
[`minutechange`](/docs/rockyjs/rocky/#on),
[`hourchange`](/docs/rockyjs/rocky/#on) and
[`daychange`](/docs/rockyjs/rocky/#on). By using these events, instead of
[`setInterval`](/docs/rockyjs), we're automatically kept in sync with the wall
clock time.

We also have a
[`message`](/docs/rockyjs/rocky/#on) event for
receiving JavaScript JSON objects from the `pkjs` component, and a
[`draw`](/docs/rockyjs/rocky/#on) event which you'll use to control the screen
updates.

```javascript
rocky.on('minutechange', function(event) {
  // Request the screen to be redrawn on next pass
  rocky.requestDraw();
});
```

###  Drawing Canvas

The canvas is a 2D rendering context and represents the display of the Pebble
smartwatch. We use the canvas context for drawing text and shapes. We're aiming
to support standard Web API methods and properties where possible, so the canvas
has been made available as a
[CanvasRenderingContext2D](/docs/rockyjs/CanvasRenderingContext2D/).

> Please note that the canvas isn't fully implemented yet, so certain methods
> and properties are not available yet. We're still working on this, so expect
> more in future updates!

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

## Limitations

We are still in the early beta phase and there are some limitations and
restrictions that you need to be aware of:

* Don't publish Rocky.js watchfaces to the Pebble appstore yet, they will stop
working.
* Rocky.js watchfaces only run on the 4.0 emulators/firmware. The 4.0 firmware
will be available soon for Basalt, Chalk and Diorite.
* No support for custom fonts, images and other resources, yet.
* No C code allowed.
* No messageKeys.
* There are file size and memory considerations with your Rocky.js projects.
If you include a large JS library, it probably won't work.

## SDK 4.0

We have published an updated version of
[CloudPebble]({{site.links.cloudpebble}}) which now supports creating
Rocky.js watchfaces in JavaScript.

If you prefer our local tools, we've also published everything you need to begin
creating Rocky.js watchfaces. Run the following command to install the Pebble
Tool and 4.0 SDK:

```nc|text
$ brew upgrade pebble-sdk
$ pebble sdk install latest
```

## How to Get Started

We created a [2-part tutorial](/tutorials/js-watchface-tutorial/part1/) for
getting started with Rocky.js watchfaces. It explains everything you need to
know about creating digital and analog watchfaces, plus how to retrieve
weather conditions from the internet.

If you're looking for more detailed information, check out the
[API Documentation](/docs/rockyjs).

## Sample Watchfaces

We've already created a few sample watchfaces:

* [Tictoc](https://github.com/pebble-examples/rocky-watchface-tutorial-part1) -
Simple analog watchface.
* [Tictoc Weather](https://github.com/pebble-examples/rocky-watchface-tutorial-part2) -
Simple analog watchface with weather data from a REST API.
* [Leco with Weather](https://github.com/orviwan/rocky-leco-weather) - Simple
digital watchface with weather data from a REST API.
* [Leco with Clay](https://github.com/orviwan/rocky-leco-clay) - Simple analog
watchface which uses Clay for configurable settings.
* [Simplicity](https://github.com/orviwan/simplicity-rockyjs) - Rocky.js version
of the classic Simplicity watchface.

## Feedback and Help

We hope you're as exicited about Rocky.js as we are. If you need assistance,
have feedback or just want to send us some love, we're in #rockyjs on
[Discord]({{ site.links.discord_invite }}) or the
[Pebble developer forums](https://forums.rebble.io/c/development).

We're already working on the next update of Rocky.js and your feedback will help
shape the future!

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
tutorial_part: 1

title: Build a Watchface in JavaScript using Rocky.js
description: A guide to making a new Pebble watchface with Rocky.js
permalink: /tutorials/js-watchface-tutorial/part1/
menu_section: tutorials
generate_toc: true
---

{% include tutorials/rocky-js-warning.html %}

In this tutorial we'll cover the basics of writing a simple watchface with
Rocky.js, Pebble's JavaScript API. Rocky.js enables developers to create
beautiful and feature-rich watchfaces with a modern programming language.

Rocky.js should not be confused with Pebble.js which also allowed developers to
write applications in JavaScript. Unlike Pebble.js, Rocky.js runs natively on
the watch and is now the only offically supported method for developing
JavaScript applications for Pebble smartwatches.

We're going to start with some basics, then create a simple digital watchface
and finally create an analog clock which looks just like this:

![rocky >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/js-watchface-tutorial/tictoc.png)

## First Steps

If you haven't already, head over the [SDK Page](/sdk/install/) to learn how to
download and install the latest version of the Pebble Tool, and the latest SDK.

Once you've installed the Pebble Tool and SDK 4.0, you can create a new Rocky.js
project with the following command:

```nc|text
$ pebble new-project --rocky helloworld
```

This will create a new folder called `helloworld` and populate it with the basic
structure required for a basic Rocky.js application.


## Watchface Basics

Watchface are essentially long running applications that update the display at
a regular interval (typically once a minute, or when specific events occur). By
minimizing the frequency that the screen is updated, we help to conserve
battery life on the watch.

The main entry point for the watchface is `/src/rocky/index.js`, so we'll
start by editing this file.

The very first thing we must do is include the Rocky.js library, which gives us
access to the APIs we need to create a Pebble watchface.

```js
var rocky = require('rocky');
```

Next, the invocation of `rocky.on('minutechange', ...)` registers a callback
method to the `minutechange` event - which is emitted every time the internal
clock's minute changes (and also when the handler is registered). Watchfaces
should invoke the ``requestDraw`` method as part of the `minutechange` event to
redraw the screen.

```js
rocky.on('minutechange', function(event) {
  rocky.requestDraw();
});
```

> **NOTE**: Watchfaces that need to update more or less frequently can also
> register the `secondchange`, `hourchange` or `daychange` events.

Next we register a callback method to the `draw` event - which is emitted after
each call to `rocky.requestDraw()`. The `event` parameter passed into the
callback function includes a ``CanvasRenderingContext2D`` object, which is used
to determine the display characteristics and draw text or shapes on the display.

```js
rocky.on('draw', function(event) {
  // Get the CanvasRenderingContext2D object
  var ctx = event.context;
});
```

The ``RockyDrawCallback`` is where we render the smartwatch display, using the
methods provided to us through the ``CanvasRenderingContext2D`` object.

> **NOTE**: The `draw` event may also be emitted at other times, such
as when the handler is first registered.

## Creating a Digital Watchface

In order to create a simple digital watchface, we will need to do the following
things:

- Subscribe to the `minutechange` event.
- Subscribe to the `draw` event, so we can update the display.
- Clear the display each time we draw on the screen.
- Determine the width and height of the available content area of the screen.
- Obtain the current date and time.
- Set the text color to white.
- Center align the text.
- Display the current time, using the width and height to determine the center
point of the screen.

To create our minimal watchface which displays the current time, let's
replace the contents of `/src/rocky/index.js` with the following code:

```js
var rocky = require('rocky');

rocky.on('draw', function(event) {
  // Get the CanvasRenderingContext2D object
  var ctx = event.context;

  // Clear the screen
  ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);

  // Determine the width and height of the display
  var w = ctx.canvas.unobstructedWidth;
  var h = ctx.canvas.unobstructedHeight;

  // Current date/time
  var d = new Date();

  // Set the text color
  ctx.fillStyle = 'white';

  // Center align the text
  ctx.textAlign = 'center';

  // Display the time, in the middle of the screen
  ctx.fillText(d.toLocaleTimeString(), w / 2, h / 2, w);
});

rocky.on('minutechange', function(event) {
  // Display a message in the system logs
  console.log("Another minute with your Pebble!");

  // Request the screen to be redrawn on next pass
  rocky.requestDraw();
});
```

## First Compilation and Installation

To compile the watchface, make sure you have saved your project files, then
run the following command from the project's root directory:

```nc|text
$ pebble build
```

After a successful compilation you will see a message reading `'build' finished
successfully`.

If there are any problems with your code, the compiler will tell you which lines
contain an error, so you can fix them. See
[Troubleshooting and Debugging](#troubleshooting-and-debugging) for further
information.

Now install the watchapp and view the logs on the emulator by running:

```nc|text
$ pebble install --logs --emulator basalt
```

## Congratulations!

You should see a loading bar as the watchface is loaded, shortly followed by
your watchface running in the emulator.

![rocky >{pebble-screenshot,pebble-screenshot--time-red}](/images/tutorials/js-watchface-tutorial/rocky-time.png)

Your logs should also be displaying the message we told it to log with
`console.log()`.

```nc|text
Another minute with your Pebble!
```

> Note: You should prevent execution of the log statements by commenting the
code, if you aren't using them. e.g. `//console.log();`

## Creating an Analog Watchface

In order to draw an analog watchface, we will need to do the following things:

- Subscribe to the `minutechange` event.
- Subscribe to the `draw` event, so we can update the display.
- Obtain the current date and time.
- Clear the display each time we draw on the screen.
- Determine the width and height of the available content area of the screen.
- Use the width and height to determine the center point of the screen.
- Calculate the max length of the watch hands based on the available space.
- Determine the correct angle for minutes and hours.
- Draw the minute and hour hands, outwards from the center point.

### Drawing the Hands

We're going to need to draw two lines, one representing the hour hand, and one
representing the minute hand.

We need to implement a function to draw the hands, to prevent duplicating the
same drawing code for hours and minutes.  We're going to use a series of
``CanvasRenderingContext2D`` methods to accomplish the desired effect.

First we need to find the center point in our display:

```js
// Determine the available width and height of the display
var w = ctx.canvas.unobstructedWidth;
var h = ctx.canvas.unobstructedHeight;

// Determine the center point of the display
var cx = w / 2;
var cy = h / 2;
```

Now we know the starting point for the hands (`cx`, `cy`), but we still need to
determine the end point. We can do this with a tiny bit of math:

```js
var x2 = cx + Math.sin(angle) * length;
var y2 = cy - Math.cos(angle) * length;
```

Then we'll use the `ctx` parameter and configure the line width and color of
the hand.

```js
// Configure how we want to draw the hand
ctx.lineWidth = 8;
ctx.strokeStyle = color;
```

Finally we draw the hand, starting from the center of the screen, drawing a
straight line outwards.

```js
// Begin drawing
ctx.beginPath();

// Move to the center point, then draw the line
ctx.moveTo(cx, cy);
ctx.lineTo(x2, y2);

// Stroke the line (output to display)
ctx.stroke();
```

### Putting It All Together

```js
var rocky = require('rocky');

function fractionToRadian(fraction) {
  return fraction * 2 * Math.PI;
}

function drawHand(ctx, cx, cy, angle, length, color) {
  // Find the end points
  var x2 = cx + Math.sin(angle) * length;
  var y2 = cy - Math.cos(angle) * length;

  // Configure how we want to draw the hand
  ctx.lineWidth = 8;
  ctx.strokeStyle = color;

  // Begin drawing
  ctx.beginPath();

  // Move to the center point, then draw the line
  ctx.moveTo(cx, cy);
  ctx.lineTo(x2, y2);

  // Stroke the line (output to display)
  ctx.stroke();
}

rocky.on('draw', function(event) {
  var ctx = event.context;
  var d = new Date();

  // Clear the screen
  ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);

  // Determine the width and height of the display
  var w = ctx.canvas.unobstructedWidth;
  var h = ctx.canvas.unobstructedHeight;

  // Determine the center point of the display
  // and the max size of watch hands
  var cx = w / 2;
  var cy = h / 2;

  // -20 so we're inset 10px on each side
  var maxLength = (Math.min(w, h) - 20) / 2;

  // Calculate the minute hand angle
  var minuteFraction = (d.getMinutes()) / 60;
  var minuteAngle = fractionToRadian(minuteFraction);

  // Draw the minute hand
  drawHand(ctx, cx, cy, minuteAngle, maxLength, "white");

  // Calculate the hour hand angle
  var hourFraction = (d.getHours() % 12 + minuteFraction) / 12;
  var hourAngle = fractionToRadian(hourFraction);

  // Draw the hour hand
  drawHand(ctx, cx, cy, hourAngle, maxLength * 0.6, "lightblue");
});

rocky.on('minutechange', function(event) {
  // Request the screen to be redrawn on next pass
  rocky.requestDraw();
});
```

Now compile and run your project in the emulator to see the results!


## Troubleshooting and Debugging

If your build didn't work, you'll see the error message: `Build Failed`. Let's
take a look at some of the common types of errors:


### Rocky.js Linter

As part of the build process, your Rocky `index.js` file is automatically
checked for errors using a process called
['linting'](https://en.wikipedia.org/wiki/Lint_%28software%29).

The first thing to check is the 'Lint Results' section of the build output.

```nc|text
========== Lint Results: index.js ==========

src/rocky/index.js(7,39): error TS1005: ',' expected.
src/rocky/index.js(9,8): error TS1005: ':' expected.
src/rocky/index.js(9,37): error TS1005: ',' expected.
src/rocky/index.js(7,1): warning TS2346: Supplied parameters do not match any signature of call target.
src/rocky/index.js(7,24): warning TS2304: Cannot find name 'funtion'.

Errors: 3, Warnings: 2
Please fix the issues marked with 'error' above.
```

In the error messages above, we see the filename which contains the error,
followed by the line number and column number where the error occurs. For
example:

```nc|text
Filename: src/rocky/index.js
Line number: 7
Character: 24
Description: Cannot find name 'funtion'.
```

```javascript
rocky.on('minutechange', funtion(event) {
  // ...
});
```

As we can see, this error relates to a typo, 'funtion' should be 'function'.
Once this error has been fixed and you run `pebble build` again, you should
see:

```nc|text
========== Lint Results: index.js ==========

Everything looks AWESOME!
```

### Locating Errors Using Logging

So what do we do when the build is successful, but our code isn't functioning as
expected? Logging!

Scatter a breadcrumb trail through your application code, that you can follow as
your application is running. This will help to narrow down the location of
the problem.

```javascript
rocky.on('minutechange', function(event) {
  console.log('minutechange fired!');
  // ...
});
```
Once you've added your logging statements, rebuild the application and view the
logs:

```nc|text
$ pebble build && pebble install --emulator basalt --logs
```

If you find that one of your logging statements hasn't appeared in the log
output, it probably means there is an issue in the preceding code.

### I'm still having problems!

If you've tried the steps above and you're still having problems, there are
plenty of places to get help. You can post your question and code on the
[Pebble Forums](https://forums.pebble.com/c/development) or join our
[Discord Server]({{ site.links.discord_invite }}) and ask for assistance.


## Conclusion

So there we have it, the basic process required to create a brand new Pebble
watchface using JavaScript! To do this we:

1. Created a new Rocky.js project.
2. Included the `'rocky'` library.
3. Subscribed to the `minutechange` event.
4. Subscribed to the `draw` event.
5. Used drawing commands to draw text and lines on the display.

If you have problems with your code, check it against the sample source code
provided using the button below.

[View Source Code >{center,bg-lightblue,fg-white}](https://github.com/pebble-examples/rocky-watchface-tutorial-part1)

## What's Next

If you successfully built and run your application, you should have seen a very
basic watchface that closely mimics the built-in TicToc. In the next tutorial,
we'll use `postMessage` to pass information to the mobile device, and
request weather data from the web.

[Go to Part 2 &rarr; >{wide,bg-dark-red,fg-white}](/tutorials/js-watchface-tutorial/part2/)

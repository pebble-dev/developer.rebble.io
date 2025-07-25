---
title: Pebble Smartwatch Emulator in CloudPebble!
author: katharine
tags:
- CloudPebble
- Freshly Baked
date: 2015-01-22
---

We're thrilled to announce the latest addition to CloudPebble: a Pebble smartwatch
emulator!




![Love Weather running in CloudPebble](/images/blog/cloudpebble-emulator-hero.png)

To use the emulator, just head over to [CloudPebble]({{site.links.cloudpebble}})
and run your project. The emulator is now used by default; to install to your
phone, change tabs from the Compilation pane:

![Phone / Emulator pane](/images/blog/cloudpebble-emulator-device-switch.png)

The emulator supports running both strictly native apps and those 
with a PebbleKit JS component, including Pebble.js apps.

To interact with the emulator, click on the buttons on the sides, or click in
the screen and then use the arrow keys for the buttons. In keyboard mode you can
also press X, Y, or Z for a tap in the positive direction, or shift-X, shift-Y,
or shift-Z for a tap in the negative direction.

You can also adjust the battery state using the settings popover:

![Settings popover](/images/blog/cloudpebble-emulator-config-popover.png)

This pane also lets you shut down the emulated Pebble smartwatch and open your app's
configuration page if it has one. However, you will have to make a minor
adjustment to your configuration page: you will be passed a query parameter
called `return_to`; if you're passed that, you should use it in place of
`pebblejs://close#`.

For instance, something like this:

```js
// Something like this to get query variables.
function getQueryParam(variable, default_) {
	var query = location.search.substring(1);
	var vars = query.split('&');
	for (var i = 0; i < vars.length; i++) {
		var pair = vars[i].split('=');
		if (pair[0] == variable)
			return decodeURIComponent(pair[1]);
	}
	return default_ || false;
}

var return_to = getQueryParam('return_to', 'pebblejs://close#');
document.location = return_to + encodeURIComponent(JSON.stringify(some_settings));
```

We hope this makes developing for the Pebble smartwatch easier than ever! Please
[let us know](mailto:cloudpebble@getpebble.com) if it doesn't work with your
app.

Finally, for those who are interested, we'll have some technical posts soon
about how we made this work!

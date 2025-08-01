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

title: PebbleKit JS
description: |
  How to use PebbleKit JS to communicate with the connected phone's JS
  environment.
guide_group: communication
order: 4
---

PebbleKit JS allows a JavaScript component (run in a sandbox inside the official
Pebble mobile app) to be added to any watchapp or watchface in order to extend
the functionality of the app beyond what can be accomplished on the watch
itself.

Extra features available to an app using PebbleKit JS include:

* Access to extended storage with [`localStorage`](#using-localstorage).

* Internet access using [`XMLHttpRequest`](#using-xmlhttprequest).

* Location data using [`geolocation`](#using-geolocation).

* The ability to show a configuration page to allow users to customize how the
  app behaves. This is discussed in detail in
  {% guide_link user-interfaces/app-configuration %}.


## Setting Up

PebbleKit JS can be set up by creating the `index.js` file in the project's
`src/pkjs/` directory. Code in this file will be executed when the associated
watchapp is launched, and will stop once that app exits.

The basic JS code required to begin using PebbleKit JS is shown below. An event
listener is created to listen for the `ready` event - fired when the watchapp
has been launched and the JS environment is ready to receive messages. This
callback must return within a short space of time (a few seconds) or else it
will timeout and be killed by the phone.

```js
Pebble.addEventListener('ready', function() {
  // PebbleKit JS is ready!
  console.log('PebbleKit JS ready!');
});
```

<div class="alert alert--fg-white alert--bg-dark-red">
{% markdown %}
**Important**

A watchapp or watchface **must** wait for the `ready` event before attempting to
send messages to the connected phone. See 
[*Advanced Communication*](/guides/communication/advanced-communication#waiting-for-pebblekit-js) 
to learn how to do this.
{% endmarkdown %}
</div>


## Defining Keys

Before any messages can be sent or received, the keys to be used to store the
data items in the dictionary must be declared. The watchapp side uses
exclusively integer keys, whereas the JavaScript side may use the same integers
or named string keys declared in `package.json`. Any string key not declared
beforehand will not be transmitted to/from Pebble.

> Note: This requirement is true of PebbleKit JS **only**, and not PebbleKit
> Android or iOS.

Keys are declared in the project's `package.json` file in the `messageKeys`
object, which is inside the `pebble` object. Example keys are shown as equivalents
to the ones used in the hypothetical weather app example in
{% guide_link communication/sending-and-receiving-data#choosing-key-values %}.

```json
"messageKeys": [
  "Temperature",
  "WindSpeed",
  "WindDirection",
  "RequestData",
  "LocationName"
]
```

The names chosen here will be injected into your C code prefixed with `MESSAGE_KEY_`,
like `MESSAGE_KEY_Temperature`. As such, they must be legal C identifiers.

If you want to emulate an array by attaching multiple "keys" to a name, you can
specify the size of the array by adding it in square brackets: for instance,
`"LapTimes[10]`" would create a key called `LapTimes` and leave nine empty keys
after it which can be accessed by arithmetic, e.g. `MESSAGE_KEY_LapTimes + 3`.


## Sending Messages from JS

Messages are sent to the C watchapp or watchface using
`Pebble.sendAppMessage()`, which accepts a standard JavaScript object containing
the keys and values to be transmitted. The keys used **must** be identical to
the ones declared earlier.

An example is shown below:

```js
// Assemble data object
var dict = {
  'Temperature': 29,
  'LocationName': 'London, UK'
};

// Send the object
Pebble.sendAppMessage(dict, function() {
  console.log('Message sent successfully: ' + JSON.stringify(dict));
}, function(e) {
  console.log('Message failed: ' + JSON.stringify(e));
});
```

It is also possible to read the numeric values of the keys by `require`ing
`message_keys`, which is necessary to use the array feature. For instance:

```js
// Require the keys' numeric values.
var keys = require('message_keys');

// Build a dictionary.
var dict = {}
dict[keys.LapTimes] = 42
dict[keys.LapTimes+1] = 51

// Send the object
Pebble.sendAppMessage(dict, function() {
  console.log('Message sent successfully: ' + JSON.stringify(dict));
}, function(e) {
  console.log('Message failed: ' + JSON.stringify(e));
});
```


### Type Conversion

Depending on the type of the item in the object to be sent, the C app will be
able to read the value (from the
[`Tuple.value` union](/guides/communication/sending-and-receiving-data#data-types))
according to the table below:

| JS Type | Union member |
|---------|--------------|
| String | cstring |
| Number | int32 |
| Array | data |
| Boolean | int16 |


## Receiving Messages in JS

When a message is received from the C watchapp or watchface, the `appmessage`
event is fired in the PebbleKit JS app. To receive these messages, register the
appropriate event listener:

```js
// Get AppMessage events
Pebble.addEventListener('appmessage', function(e) {
  // Get the dictionary from the message
  var dict = e.payload;

  console.log('Got message: ' + JSON.stringify(dict));
});
```

Data can be read from the dictionary by reading the value if it is present. A
suggested best practice involves first checking for the presence of each key
within the callback using an `if()` statement.

```js
if(dict['RequestData']) {
  // The RequestData key is present, read the value
  var value = dict['RequestData'];
}
```


## Using LocalStorage

In addition to the storage available on the watch itself through the ``Storage``
API, apps can take advantage of the larger storage on the connected phone
through the use of the HTML 5 [`localStorage`](http://www.w3.org/TR/webstorage/)
API. Data stored here will persist across app launches, and so can be used to
persist latest data, app settings, and other data.

PebbleKit JS `localStorage` is:

* Associated with the application UUID and cannot be shared between apps.

* Persisted when the user uninstalls and then reinstalls an app.

* Persisted when the user upgrades an app.

To store a value:

```js
var color = '#FF0066';

// Store some data
localStorage.setItem('backgroundColor', color);
```

To read the data back:

```js
var color = localStorage.getItem('backgroundColor');
```

> Note: Keys used with `localStorage` should be Strings.


## Using XMLHttpRequest

A PebbleKit JS-equipped app can access the internet and communicate with web
services or download data using the standard
[`XMLHttpRequest`](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)
object.

To communicate with the web, create an `XMLHttpRequest` object and send it,
specifying the HTTP method and URL to be used, as well as a callback for when it
is successfully completed:

```js
var method = 'GET';
var url = 'http://example.com';

// Create the request
var request = new XMLHttpRequest();

// Specify the callback for when the request is completed
request.onload = function() {
  // The request was successfully completed!
  console.log('Got response: ' + this.responseText);
};

// Send the request
request.open(method, url);
request.send();
```

If the response is expected to be in the JSON format, data items can be easily
read after the `responseText` is converted into a JSON object:

```js
request.onload = function() {
  try {
    // Transform in to JSON
    var json = JSON.parse(this.responseText);

    // Read data
    var temperature = json.main.temp;
  } catch(err) {
    console.log('Error parsing JSON response!');
  }
};
```


## Using Geolocation

PebbleKit JS provides access to the location services provided by the phone
through the
[`navigator.geolocation`](http://dev.w3.org/geo/api/spec-source.html) object.

Declare that the app will be using the `geolocation` API by adding the
string `location` in the `capabilities` array in `package.json`:

```json
"capabilities": [ "location" ]
```

Below is an example showing how to get a single position value from the
`geolocation` API using the 
[`getCurrentPosition()`](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/getCurrentPosition) 
method:

```js
function success(pos) {
  console.log('lat= ' + pos.coords.latitude + ' lon= ' + pos.coords.longitude);
}

function error(err) {
  console.log('location error (' + err.code + '): ' + err.message);
}

/* ... */

// Choose options about the data returned
var options = {
  enableHighAccuracy: true,
  maximumAge: 10000,
  timeout: 10000
};

// Request current position
navigator.geolocation.getCurrentPosition(success, error, options);
```

Location permission is given by the user to the Pebble application for all
Pebble apps. The app should gracefully handle the `PERMISSION DENIED` error and
fallback to a default value or manual configuration when the user has denied
location access to Pebble apps.

```js
function error(err) {
  if(err.code == err.PERMISSION_DENIED) {
    console.log('Location access was denied by the user.');  
  } else {
    console.log('location error (' + err.code + '): ' + err.message);
  }
}

```

The `geolocation` API also provides a mechanism to receive callbacks when the
user's position changes to avoid the need to manually poll at regular intervals.
This is achieved by using 
[`watchPosition()`](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/watchPosition) 
in a manner similar to the example below:

```js
// An ID to store to later clear the watch
var watchId;

function success(pos) {
  console.log('Location changed!');
  console.log('lat= ' + pos.coords.latitude + ' lon= ' + pos.coords.longitude);
}

function error(err) {
  console.log('location error (' + err.code + '): ' + err.message);
}

/* ... */

var options = {
  enableHighAccuracy: true,
  maximumAge: 0,
  timeout: 5000
};

// Get location updates
watchId = navigator.geolocation.watchPosition(success, error, options);
```

To cancel the update callbacks, use the `watchId` variable received when the
watch was registered with the 
[`clearWatch()`](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/clearWatch) 
method:

```js
// Clear the watch and stop receiving updates
navigator.geolocation.clearWatch(watchId);
```


## Account Token

PebbleKit JS provides a unique account token that is associated with the Pebble
account of the current user, accessible using `Pebble.getAccountToken()`:

```js
// Get the account token
console.log('Pebble Account Token: ' + Pebble.getAccountToken());
```

The token is a string with the following properties:

* From the developer's perspective, the account token of a user is identical
  across platforms and across all the developer's watchapps.

* If the user is not logged in, the token will be an empty string ('').


## Watch Token

PebbleKit JS also provides a unique token that can be used to identify a Pebble
device. It works in a similar way to `Pebble.getAccountToken()`:

```js
// Get the watch token
console.log('Pebble Watch Token: ' + Pebble.getWatchToken());
```

The token is a string that is unique to the app and cannot be used to track
Pebble devices across applications.

<div class="alert alert--fg-white alert--bg-dark-red">
{% markdown %}
**Important**

The watch token is dependent on the watch's serial number, and therefore
**should not** be used to store sensitive user information in case the watch
changes ownership. If the app wishes to track a specific user _and_ watch, use a
combination of the watch and account token.
{% endmarkdown %}
</div>


## Showing a Notification

A PebbleKit JS app can send a notification to the watch. This uses the standard
system notification layout with customizable `title` and `body` fields:

```js
var title = 'Update Available';
var body = 'Version 1.5 of this app is now available from the appstore!';

// Show the notification
Pebble.showSimpleNotificationOnPebble(title, body);
```

> Note: PebbleKit Android/iOS applications cannot directly invoke a
> notification, and should instead leverage the respective platform notification
> APIs. These will be passed on to Pebble unless the user has turned them off in
> the mobile app.


## Getting Watch Information

Use `Pebble.getActiveWatchInfo()` to return an object of data about the
connected Pebble.

<div class="alert alert--fg-white alert--bg-purple">
{% markdown %}
This API is currently only available for SDK 3.0 and above. Do not assume that
this function exists, so test that it is available before attempting to use it
using the code shown below.
{% endmarkdown %}
</div>

```js
var watch = Pebble.getActiveWatchInfo ? Pebble.getActiveWatchInfo() : null;

if(watch) {
  // Information is available!

} else {
  // Not available, handle gracefully
  
}
```

> Note: If there is no active watch available, `null` will be returned.

The table below details the fields of the returned object and the information
available.

| Field | Type | Description | Values |
|-------|------|-------------|--------|
| `platform` | String | Hardware platform name. | `aplite`, `basalt`, `chalk`. |
| `model` | String | Watch model name including color. | `pebble_black`, `pebble_grey`, `pebble_white`, `pebble_red`, `pebble_orange`, `pebble_blue`, `pebble_green`, `pebble_pink`, `pebble_steel_silver`, `pebble_steel_black`, `pebble_time_red`, `pebble_time_white`, `pebble_time_black`, `pebble_time_steel_black`, `pebble_time_steel_silver`, `pebble_time_steel_gold`, `pebble_time_round_silver_14mm`, `pebble_time_round_black_14mm`, `pebble_time_round_rose_gold_14mm`, `pebble_time_round_silver_20mm`, `pebble_time_round_black_20mm`, `qemu_platform_aplite`, `qemu_platform_basalt`, `qemu_platform_chalk`. |
| `language` | String | Language currently selected on the watch. | E.g.: `en_GB`. See the {% guide_link tools-and-resources/internationalization#locales-supported-by-pebble %} for more information. |
| `firmware` | Object | The firmware version running on the watch. | See below for sub-fields. |
| `firmware.major` | Number | Major firmware version. | E.g.: `2` |
| `firmware.minor` | Number | Minor firmware version. | E.g.: `8` |
| `firmware.patch` | Number | Patch firmware version. | E.g.: `1` |
| `firmware.suffix` | String | Any additional firmware versioning. | E.g.: `beta3` |

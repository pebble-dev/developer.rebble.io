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

title: Advanced Communication
description: |
  Details of communication tips and best practices for more advanced scenarios.
guide_group: communication
order: 0
related_docs:
  - AppMessage
related_examples:
  - title: JS Ready Example
    url: https://github.com/pebble-examples/js-ready-example
  - title: List Items Example
    url: https://github.com/pebble-examples/list-items-example
  - title: Accel Data Stream
    url: https://github.com/pebble-examples/accel-data-stream
  - title: PNG Download Example
    url: https://github.com/pebble-examples/png-download-example
  - title: Pebble Faces
    url: https://github.com/pebble-examples/pebble-faces
---

Many types of connected Pebble watchapps and watchfaces perform common tasks
such as the ones discussed here. Following these best practices can increase the
quality of the implementation of each one, and avoid common bugs.


## Waiting for PebbleKit JS

Any app that wishes to send data from the watch to the phone via
{% guide_link communication/using-pebblekit-js "PebbleKit JS" %} **must**
wait until the JavaScript `ready` event has occured, indicating that the phone
has loaded the JavaScript component of the launching app. If this JavaScript
code implements the `appmessage` event listsner, it is ready to receive data.

> An watchapp that only *receives* data from PebbleKit JS does not have to wait
> for the `ready` event. In addition, Android companion apps do not have to wait
> for such an event thanks to the `Intent` system. iOS companion apps must wait
> for `-watchDidConnect:`.

A simple method is to define a key in `package.json` that will be interpreted by
the watchapp to mean that the JS environment is ready for exchange data:

```js
"messageKeys": [
  "JSReady"
]
```

The watchapp should implement a variable that describes if the `ready` event has
occured. An example is shown below:

```c
static bool s_js_ready;
```

This can be exported in a header file for other parts of the app to check. Any
parts of the app that are waiting should call this as part of a
[retry](#timeouts-and-retries) mechanism.

```c
bool comm_is_js_ready() {
  return s_js_ready;
}
```

The state of this variable will be `false` until set to `true` when the `ready`
event causes the key to be transmitted:

```js
Pebble.addEventListener('ready', function() {
  console.log('PebbleKit JS ready.');

  // Update s_js_ready on watch
  Pebble.sendAppMessage({'JSReady': 1});
});
```

This key should be interpreted in the app's ``AppMessageInboxReceived``
implementation:

```c
static void inbox_received_handler(DictionaryIterator *iter, void *context) {
  Tuple *ready_tuple = dict_find(iter, MESSAGE_KEY_JSReady);
  if(ready_tuple) {
    // PebbleKit JS is ready! Safe to send messages
    s_js_ready = true;
  }
}
```


## Timeouts and Retries

Due to the wireless and stateful nature of the Bluetooth connection, some
messages sent between the watch and phone may fail. A tried-and-tested method
for dealing with these failures is to implement a 'timeout and retry' mechanism.
Under such a scheme:

* A message is sent and a timer started.

* If the message is sent successfully (and optionally a reply received), the
  timer is cancelled.

* If the timer elapses before the message can be sent successfully, the message
  is reattempted. Depending on the nature of the failure, a suitable retry
  interval (such as a few seconds) is used to avoid saturating the connection.

The interval chosen before a timeout occurs and the message is resent may vary
depending on the circumstances. The first failure should be reattempted fairly
quickly (one second), with the interval increasing as successive failures
occurs. If the connection is not available the timer interval should be
[even longer](https://en.wikipedia.org/wiki/Exponential_backoff), or wait until
the connection is restored.


### Using a Timeout Timer

The example below shows the sending of a message and scheduling a timeout timer.
The first step is to declare a handle for the timeout timer:

```c
static AppTimer *s_timeout_timer;
```

When the message is sent, the timer should be scheduled:

```c
static void send_with_timeout(int key, int value) {
  // Construct and send the message
  DitionaryIterator *iter;
  if(app_message_outbox_begin(&iter) == APP_MSG_OK) {
    dict_write_int(iter, key, &value, sizeof(int), true);
    app_message_outbox_send();
  }

  // Schedule the timeout timer
  const int interval_ms = 1000;
  s_timout_timer = app_timer_register(interval_ms, timout_timer_handler, NULL);
}
```

If the ``AppMessageOutboxSent`` is called, the message was a success, and the
timer should be cancelled:

```c
static void outbox_sent_handler(DictionaryIterator *iter, void *context) {
  // Successful message, the timeout is not needed anymore for this message
  app_timer_cancel(s_timout_timer);
}
```

### Retry a Failed Message

However, if the timeout timer elapses before the message's success can be
determined or an expected reply is not received, the callback to
`timout_timer_handler()` should be used to inform the user of the failure, and
schedule another attempt and retry the message:

```c
static void timout_timer_handler(void *context) {
  // The timer elapsed because no success was reported
  text_layer_set_text(s_status_layer, "Failed. Retrying...");

  // Retry the message
  send_with_timeout(some_key, some_value);
}
```

Alternatively, if the ``AppMessageOutboxFailed`` is called the message failed to
send, sometimes immediately. The timeout timer should be cancelled and the
message reattempted after an additional delay (the 'retry interval') to avoid
saturating the channel:

```c
static void outbox_failed_handler(DictionaryIterator *iter,
                                      AppMessageResult reason, void *context) {
  // Message failed before timer elapsed, reschedule for later
  if(s_timout_timer) {
    app_timer_cancel(s_timout_timer);
  }

  // Inform the user of the failure
  text_layer_set_text(s_status_layer, "Failed. Retrying...");

  // Use the timeout handler to perform the same action - resend the message
  const int retry_interval_ms = 500;
  app_timer_register(retry_interval_ms, timout_timer_handler, NULL);
}
```

> Note: All eventualities where a message fails must invoke a resend of the
> message, or the purpose of an automated 'timeout and retry' mechanism is
> defeated. However, the number of attempts made and the interval between them
> is for the developer to decide.


## Sending Lists

Until SDK 3.8, the size of ``AppMessage`` buffers did not facilitate sending
large amounts of data in one message. With the current buffer sizes of up to 8k
for each an outbox the need for efficient transmission of multiple sequential
items of data is lessened, but the technique is still important. For instance,
to transmit sensor data as fast as possible requires careful scheduling of
successive messages.

Because there is no guarantee of how long a message will take to transmit,
simply using timers to schedule multiple messages after one another is not
reliable. A much better method is to make good use of the callbacks provided by
the ``AppMessage`` API.


### Sending a List to the Phone

For instance, the ``AppMessageOutboxSent`` callback can be used to safely
schedule the next message to the phone, since the previous one has been
acknowledged by the other side at that time. Here is an example array of items:

```c
static int s_data[] = { 2, 4, 8, 16, 32, 64 };

#define NUM_ITEMS sizeof(s_data);
```

A variable can be used to keep track of the current list item index that should
be transmitted next:

```c
static int s_index = 0;
```

When a message has been sent, this index is used to construct the next message:

> Note: A useful key scheme is to use the item's array index as the key. For
> PebbleKit JS that number of keys will have to be declared in `package.json`,
> like so: `someArray[6]`

```c
static void outbox_sent_handler(DictionaryIterator *iter, void *context) {
  // Increment the index
  s_index++;

  if(s_index < NUM_ITEMS) {
    // Send the next item
    DictionaryIterator *iter;
    if(app_message_outbox_begin(&iter) == APP_MSG_OK) {
      dict_write_int(iter, MESSAGE_KEY_someArray + s_index, &s_data[s_index], sizeof(int), true);
      app_message_outbox_send();
    }
  } else {
    // We have reached the end of the sequence
    APP_LOG(APP_LOG_LEVEL_INFO, "All transmission complete!");
  }
}
```

This results in a callback loop that repeats until the last data item has been
transmitted, and the index becomes equal to the total number of items. This
technique can be combined with a timeout and retry mechanism to reattempt a
particular item if transmission fails. This is a good way to avoid gaps in the
received data items.

On the phone side, the data items are received in the same order. An analogous
`index` variable is used to keep track of which item has been received. This
process will look similar to the example shown below:

```js
var NUM_ITEMS = 6;
var keys = require('message_keys');

var data = [];
var index = 0;

Pebble.addEventListener('appmessage', function(e) {
  // Store this data item
  data[index] = e.payload[keys.someArray + index];

  // Increment index for next message
  index++;

  if(index == NUM_ITEMS) {
    console.log('Received all data items!');
  }
});
```


### Sending a List to Pebble

Conversely, the `success` callback of `Pebble.sendAppMessage()` in PebbleKit JS
is the equivalent safe time to send the next message to the watch.

An example implementation that achieves this is shown below. After the message
is sent with `Pebble.sendAppMessage()`, the `success` callback calls the
`sendNextItem()` function repeatedly until the index is larger than that of the
last list item to be sent, and transmission will be complete. Again, an index
variable is maintained to keep track of which item is being transmitted:

```js
var keys = require('message_keys');
function sendNextItem(items, index) {
  // Build message
  var key = keys.someArray + index;
  var dict = {};
  dict[key] = items[index];

  // Send the message
  Pebble.sendAppMessage(dict, function() {
    // Use success callback to increment index
    index++;

    if(index < items.length) {
      // Send next item
      sendNextItem(items, index);
    } else {
      console.log('Last item sent!');
    }
  }, function() {
    console.log('Item transmission failed at index: ' + index);
  });
}

function sendList(items) {
  var index = 0;
  sendNextItem(items, index);
}

function onDownloadComplete(responseText) {
  // Some web response containing a JSON object array
  var json = JSON.parse(responseText);

  // Begin transmission loop
  sendList(json.items);
}
```

On the watchapp side, the items are received in the same order in the
``AppMessageInboxReceived`` handler:

```c
#define NUM_ITEMS 6

static int s_index;
static int s_data[NUM_ITEMS];
```

```c
static void inbox_received_handler(DictionaryIterator *iter, void *context) {
  Tuple *data_t = dict_find(iter, MESSAGE_KEY_someArray + s_index);
  if(data_t) {
    // Store this item
    s_data[index] = (int)data_t->value->int32;

    // Increment index for next item
    s_index++;
  }

  if(s_index == NUM_ITEMS) {
    // We have reached the end of the sequence
    APP_LOG(APP_LOG_LEVEL_INFO, "All transmission complete!");
  }
}
```

This sequence of events is demonstrated for PebbleKit JS, but the same technique
can be applied exactly to either and Android or iOS companion app wishing to
transmit many data items to Pebble.


Get the complete source code for this example from the
[`list-items-example`](https://github.com/pebble-examples/list-items-example)
repository on GitHub.


## Sending Image Data

A common task developers want to accomplish is display a dynamically loaded
image resource (for example, showing an MMS photo or a news item thumbnail
pulled from a webservice). Because some images could be larger than the largest
buffer size available to the app, the techniques shown above for sending lists
also prove useful here, as the image is essentially a list of color byte values.


### Image Data Format

There are two methods available for displaying image data downloaded from the
web:

1. Download a `png` image, transmit the compressed data, and decompress using
   ``gbitmap_create_from_png_data()``. This involves sending less data, but can
   be prone to failure depending on the exact format of the image. The image
   must be in a compatible palette (1, 2, 4, or 8-bit) and small enough such
   that there is enough memory for a compessed copy, an uncompressed copy, and
   ~2k overhead when it is being processed.

2. Download a `png` image, decompress in the cloud or in PebbleKit JS into an
   array of image pixel bytes, transmit the pixel data into a blank
   ``GBitmap``'s `data` member. Each byte must be in the compatible Pebble color
   format (2 bits per ARGB). This process can be simplified by pre-formatting
   the image to be dowloaded, as resizing or palette-reduction is difficult to
   do locally.


### Sending Compressed PNG Data

As the fastest and least complex of the two methods described above, an example
of how to display a compressed PNG image will be discussed here. The image that
will be displayed is
[the HTML 5 logo](https://www.w3.org/html/logo/):

![The HTML5 logo.](/images/guides/pebble-apps/communications/html5-logo-small.png)

> Note: The above image has been resized and palettized for compatibility.

To download this image in PebbleKit JS, use an `XmlHttpRequest` object. It is
important to specify the `responseType` as 'arraybuffer' to obtain the image
data in the correct format:

```js
function downloadImage() {
  var url = 'https://developer.rebble.io/assets/images/guides/pebble-apps/communications/html5-logo-small.png';

  var request = new XMLHttpRequest();
  request.onload = function() {
    processImage(this.response);
  };
  request.responseType = "arraybuffer";
  request.open("GET", url);
  request.send();
}
```

When the response has been received, `processImage()` will be called. The
received data must be converted into an array of unsigned bytes, which is
achieved through the use of a `Uint8Array`. This process is shown below (see
the
[`png-download-example`](https://github.com/pebble-examples/png-download-example)
repository for the full example):

```js
function processImage(responseData) {
  // Convert to a array
  var byteArray = new Uint8Array(responseData);
  var array = [];
  for(var i = 0; i < byteArray.byteLength; i++) {
    array.push(byteArray[i]);
  }

  // Send chunks to Pebble
  transmitImage(array);
}
```

Now that the image data has been converted, the transmission to Pebble can
begin. At a high level, the JS side transmits the image data in chunks, using an
incremental array index to coordinate saving of data on the C side in a mirror
array. In downloading the image data, the following keys are used for the
specified purposes:

| Key | Purpose |
|-----|---------|
| `Index` | The array index that the current chunk should be stored at. This gets larger as each chunk is transmitted. |
| `DataLength` | This length of the entire data array to be downloaded. As the image is compressed, this is _not_ the product of the width and height of the image. |
| `DataChunk` | The chunk's image data. |
| `ChunkSize` | The size of this chunk. |
| `Complete` | Used to signify that the image transfer is complete. |

The first message in the sequence should tell the C side how much memory to
allocate to store the compressed image data:

```js
function transmitImage(array) {
  var index = 0;
  var arrayLength = array.length;

  // Transmit the length for array allocation
  Pebble.sendAppMessage({'DataLength': arrayLength}, function(e) {
    // Success, begin sending chunks
    sendChunk(array, index, arrayLength);
  }, function(e) {
    console.log('Failed to initiate image transfer!');
  })
}
```

If this message is successful, the transmission of actual image data commences
with the first call to `sendChunk()`. This function calculates the size of the
next chunk (the smallest of either the size of the `AppMessage` inbox buffer, or
the remainder of the data) and assembles the dictionary containing the index in
the array it is sliced from, the length of the chunk, and the actual data
itself:

```js
function sendChunk(array, index, arrayLength) {
  // Determine the next chunk size
  var chunkSize = BUFFER_SIZE;
  if(arrayLength - index < BUFFER_SIZE) {
    // Resize to fit just the remaining data items
    chunkSize = arrayLength - index;
  }

  // Prepare the dictionary
  var dict = {
    'DataChunk': array.slice(index, index + chunkSize),
    'ChunkSize': chunkSize,
    'Index': index
  };

  // Send the chunk
  Pebble.sendAppMessage(dict, function() {
    // Success
    index += chunkSize;

    if(index < arrayLength) {
      // Send the next chunk
      sendChunk(array, index, arrayLength);
    } else {
      // Complete!
      Pebble.sendAppMessage({'Complete': 0});
    }
  }, function(e) {
    console.log('Failed to send chunk with index ' + index);
  });
}
```

After each chunk is sent, the index is incremented with the size of the chunk
that was just sent, and compared to the total length of the array. If the index
exceeds the size of the array, the loop has sent all the data (this could be
just a single chunk if the array is smaller than the maximum message size). The
`AppKeyComplete` key is sent to inform the C side that the image is complete and
ready for display.


### Receiving Compressed PNG Data

In the previous section, the process for using PebbleKit JS to download and
transmit an image to the C side was discussed. The process for storing and
displaying this data is discussed here. Only when both parts work in harmony can
an image be successfully shown from the web.

The majority of the process takes place within the watchapp's
``AppMessageInboxReceived`` handler, with the presence of each key being
detected and the appropriate actions taken to reconstruct the image.

The first item expected is the total size of the data to be transferred. This is
recorded (for later use with ``gbitmap_create_from_png_data()``) and the buffer
used to store the chunks is allocated to this exact size:

```c
static uint8_t *s_img_data;
static int s_img_size;
```

```c
// Get the received image chunk
Tuple *img_size_t = dict_find(iter, MESSAGE_KEY_DataLength);
if(img_size_t) {
  s_img_size = img_size_t->value->int32;

  // Allocate buffer for image data
  img_data = (uint8_t*)malloc(s_img_size * sizeof(uint8_t));
}
```

When the message containing the data size is acknowledged, the JS side begins
sending chunks with `sendChunk()`. When one of these subsequent messages is
received, the three keys (`DataChunk`, `ChunkSize`, and
`Index`) are used to store that chunk of data at the correct offset in the
array:

```c
// An image chunk
Tuple *chunk_t = dict_find(iter, MESSAGE_KEY_DataChunk);
if(chunk_t) {
  uint8_t *chunk_data = chunk_t->value->data;

  Tuple *chunk_size_t = dict_find(iter, MESSAGE_KEY_ChunkSize);
  int chunk_size = chunk_size_t->value->int32;

  Tuple *index_t = dict_find(iter, MESSAGE_KEY_Index);
  int index = index_t->value->int32;

  // Save the chunk
  memcpy(&s_img_data[index], chunk_data, chunk_size);
}
```

Finally, once the array index exceeds the size of the data array on the JS side,
the `AppKeyComplete` key is transmitted, triggering the data to be transformed
into a ``GBitmap``:

```c
static BitmapLayer *s_bitmap_layer;
static GBitmap *s_bitmap;
```

```c
// Complete?
Tuple *complete_t = dict_find(iter, MESSAGE_KEY_Complete);
if(complete_t) {
  // Create new GBitmap from downloaded PNG data
  s_bitmap = gbitmap_create_from_png_data(s_img_data, s_img_size);

  // Show the image
  if(s_bitmap) {
    bitmap_layer_set_bitmap(s_bitmap_layer, s_bitmap);
  } else {
    APP_LOG(APP_LOG_LEVEL_ERROR, "Error creating GBitmap from PNG data!");
  }
}
```

The final result is a compressed PNG image downloaded from the web displayed in
a Pebble watchapp.

![watch >{pebble-screenshot,pebble-screenshot--time-black}](/images/guides/pebble-apps/communications/html-5-watch.png)

Get the complete source code for this example from the
[`png-download-example`](https://github.com/pebble-examples/png-download-example)
repository on GitHub.

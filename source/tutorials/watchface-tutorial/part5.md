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
tutorial_part: 5

title: Vibrate on Disconnect
description: |
  How to add bluetooth connection alerts to your watchface.
permalink: /tutorials/watchface-tutorial/part5/
generate_toc: true
---

The final popular watchface addition explored in this tutorial series
is the concept of using the Bluetooth connection service to alert the user
when their watch connects or disconnects. This can be useful to know when the
watch is out of range and notifications will not be received, or to let the user
know that they might have walked off somewhere without their phone.

To continue from the last part, you can either modify your existing Pebble
project or create a new one, using the code from the end of the last tutorial
as a starting point. Don't forget also to include changes to `package.json`.

In a similar manner to both the ``TickTimerService`` and
``BatteryStateService``, the events associated with the Bluetooth connection are
given to developers via subscriptions, which requires an additional callback -
the ``ConnectionHandler``. Create one of these in the format given below:

```c
static void bluetooth_callback(bool connected) {

}
```

The subscription to Bluetooth-related events is added in `init()`:

```c
// Register for Bluetooth connection updates
connection_service_subscribe((ConnectionHandlers) {
  .pebble_app_connection_handler = bluetooth_callback
});
```

The indicator itself will take the form of the following 'Bluetooth
disconnected' icon that will be displayed when the watch is disconnected, and
hidden when reconnected. Save the image below for use in this project:

<img style="background-color: #CCCCCC;" src="/assets/images/tutorials/intermediate/bt-icon.png"</img>

Add this icon to your project by copying the above icon image to the
`/resources/images` project directory, and adding a new JSON object to the
`media` array in `package.json` such as the following:

```js
{
  "type": "bitmap",
  "name": "IMAGE_BT_ICON",
  "file": "images/bt-icon.png"
}
```

This icon will be loaded into the app as a ``GBitmap`` for display in a
``BitmapLayer`` above the time display. Declare both of these as pointers at the
top of the file, in addition to the existing variables of these types:

```c
static BitmapLayer *s_background_layer, *s_bt_icon_layer;
static GBitmap *s_background_bitmap, *s_bt_icon_bitmap;
```

Allocate both of the new objects in `main_window_load()`, then set the
``BitmapLayer``'s bitmap as the new icon ``GBitmap``:

```c
// Create the Bluetooth icon GBitmap
s_bt_icon_bitmap = gbitmap_create_with_resource(RESOURCE_ID_IMAGE_BT_ICON);

// Create the BitmapLayer to display the GBitmap
s_bt_icon_layer = bitmap_layer_create(GRect(59, 12, 30, 30));
bitmap_layer_set_bitmap(s_bt_icon_layer, s_bt_icon_bitmap);
layer_add_child(window_get_root_layer(window), bitmap_layer_get_layer(s_bt_icon_layer));
```

As usual, ensure that the memory allocated to create these objects is also freed
in `main_window_unload()`:

```c
gbitmap_destroy(s_bt_icon_bitmap);
bitmap_layer_destroy(s_bt_icon_layer);
```

With the UI in place, the implementation of the ``BluetoothConnectionHandler``
can be finished. Depending on the state of the connection when an event takes
place, the indicator icon is hidden or unhidden as required. A distinct
vibration is also triggered if the watch becomes disconnected, to differentiate
the feedback from that of a notification or phone call:

```c
static void bluetooth_callback(bool connected) {
  // Show icon if disconnected
  layer_set_hidden(bitmap_layer_get_layer(s_bt_icon_layer), connected);

  if(!connected) {
    // Issue a vibrating alert
    vibes_double_pulse();
  }
}
```

Upon initialization, the app will display the icon unless a re-connection event
occurs, and the current state is evaluated. Manually call the handler in
`init()` to display the correct initial state:

```c
// Show the correct state of the BT connection from the start
bluetooth_callback(connection_service_peek_pebble_app_connection());
```

With this last feature in place, running the app and disconnecting the Bluetooth
connection will cause the new indicator to appear, and the watch to vibrate
twice. It may take a few seconds for the watch to register the disconnection.

![bt >{pebble-screenshot,pebble-screenshot--steel-black}](/images/tutorials/intermediate/bt.png)


## Conclusion

Now our watchface shows the watch's remaining battery level! It's discreet,
but very useful.

As usual, you can compare your code to the example code provided below.

> The JS code file remains unchanged from the last part of the tutorial.

<details>
<summary>View C code</summary>
{% markdown %}
```c
#include <pebble.h>

static Window *s_main_window;
static TextLayer *s_time_layer;
static BitmapLayer *s_background_layer, *s_bt_icon_layer;
static TextLayer *s_weather_layer;
static Layer *s_battery_layer;

static GFont s_time_font;
static GFont s_weather_font;
static GBitmap *s_background_bitmap, *s_bt_icon_bitmap;

static int s_battery_level;

static void update_time() {
  // Get a tm structure
  time_t temp = time(NULL);
  struct tm *tick_time = localtime(&temp);

  // Write the current hours and minutes into a buffer
  static char s_buffer[8];
  strftime(s_buffer, sizeof(s_buffer), clock_is_24h_style() ?
                                          "%H:%M" : "%I:%M", tick_time);

  // Display this time on the TextLayer
  text_layer_set_text(s_time_layer, s_buffer);
}

static void battery_update_proc(Layer *layer, GContext *ctx) {
  GRect bounds = layer_get_bounds(layer);

  // Find the width of the bar (total width = 114px)
  int width = (s_battery_level * 114) / 100;

  // Draw the background
  graphics_context_set_fill_color(ctx, GColorBlack);
  graphics_fill_rect(ctx, bounds, 0, GCornerNone);

  // Draw the bar
  graphics_context_set_fill_color(ctx, GColorWhite);
  graphics_fill_rect(ctx, GRect(0, 0, width, bounds.size.h), 0, GCornerNone);
}

static void main_window_load(Window *window) {
  // Get information about the Window
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  // Create GBitmap
  s_background_bitmap = gbitmap_create_with_resource(RESOURCE_ID_IMAGE_BACKGROUND);

  // Create BitmapLayer to display the GBitmap
  s_background_layer = bitmap_layer_create(bounds);
  bitmap_layer_set_bitmap(s_background_layer, s_background_bitmap);
  layer_add_child(window_layer, bitmap_layer_get_layer(s_background_layer));

  // Create GFont
  s_time_font = fonts_load_custom_font(resource_get_handle(RESOURCE_ID_FONT_PERFECT_DOS_48));

  // Create the TextLayer with specific bounds
  s_time_layer = text_layer_create(
      GRect(0, PBL_IF_ROUND_ELSE(58, 52), bounds.size.w, 50));
  text_layer_set_background_color(s_time_layer, GColorClear);
  text_layer_set_text_color(s_time_layer, GColorBlack);
  text_layer_set_text(s_time_layer, "00:00");
  text_layer_set_font(s_time_layer, fonts_get_system_font(FONT_KEY_BITHAM_42_BOLD));
  text_layer_set_text_alignment(s_time_layer, GTextAlignmentCenter);
  text_layer_set_font(s_time_layer, s_time_font);
  layer_add_child(window_layer, text_layer_get_layer(s_time_layer));

  // Create weather Layer
  s_weather_layer = text_layer_create(
      GRect(0, PBL_IF_ROUND_ELSE(125, 120), bounds.size.w, 25));
  text_layer_set_background_color(s_weather_layer, GColorClear);
  text_layer_set_text_color(s_weather_layer, GColorWhite);
  text_layer_set_text_alignment(s_weather_layer, GTextAlignmentCenter);
  text_layer_set_text(s_weather_layer, "Loading...");

  // Create second custom font, apply it and add to Window
  s_weather_font = fonts_load_custom_font(resource_get_handle(RESOURCE_ID_FONT_PERFECT_DOS_20));
  text_layer_set_font(s_weather_layer, s_weather_font);
  layer_add_child(window_get_root_layer(window), text_layer_get_layer(s_weather_layer));

  // Create battery meter Layer
  s_battery_layer = layer_create(GRect(14, 53, 115, 2));
  layer_set_update_proc(s_battery_layer, battery_update_proc);
  layer_add_child(window_get_root_layer(window), s_battery_layer);

  // Create the Bluetooth icon GBitmap
  s_bt_icon_bitmap = gbitmap_create_with_resource(RESOURCE_ID_IMAGE_BT_ICON);

  // Create the BitmapLayer to display the GBitmap
  s_bt_icon_layer = bitmap_layer_create(GRect(59, 12, 30, 30));
  bitmap_layer_set_bitmap(s_bt_icon_layer, s_bt_icon_bitmap);
  layer_add_child(window_get_root_layer(window), bitmap_layer_get_layer(s_bt_icon_layer));
}

static void main_window_unload(Window *window) {
  text_layer_destroy(s_time_layer);
  bitmap_layer_destroy(s_background_layer);
  bitmap_layer_destroy(s_bt_icon_layer);
  text_layer_destroy(s_weather_layer);
  layer_destroy(s_battery_layer);

  fonts_unload_custom_font(s_weather_font);
  fonts_unload_custom_font(s_time_font);

  gbitmap_destroy(s_background_bitmap);
  gbitmap_destroy(s_bt_icon_bitmap);
}

static void tick_handler(struct tm *tick_time, TimeUnits units_changed) {
  update_time();

  // Get weather update every 30 minutes
  if (tick_time->tm_min % 30 == 0) {
    // Begin dictionary
    DictionaryIterator *iter;
    app_message_outbox_begin(&iter);

    // Add a key-value pair
    dict_write_uint8(iter, 0, 0);

    // Send the message!
    app_message_outbox_send();
  }
}

static void battery_callback(BatteryChargeState state) {
  // Record the new battery level
  s_battery_level = state.charge_percent;

  // Update meter
  layer_mark_dirty(s_battery_layer);
}

static void bluetooth_callback(bool connected) {
  // Show icon if disconnected
  layer_set_hidden(bitmap_layer_get_layer(s_bt_icon_layer), connected);

  if(!connected) {
    // Issue a vibrating alert
    vibes_double_pulse();
  }
}

static void inbox_received_callback(DictionaryIterator *iterator, void *context) {
  // Store incoming information
  static char temperature_buffer[8];
  static char conditions_buffer[32];
  static char weather_layer_buffer[32];

  // Read tuples for data
  Tuple *temp_tuple = dict_find(iterator, MESSAGE_KEY_TEMPERATURE);
  Tuple *conditions_tuple = dict_find(iterator, MESSAGE_KEY_CONDITIONS);

  // If all data is available, use it
  if (temp_tuple && conditions_tuple) {
    snprintf(temperature_buffer, sizeof(temperature_buffer), "%dC", (int)temp_tuple->value->int32);
    snprintf(conditions_buffer, sizeof(conditions_buffer), "%s", conditions_tuple->value->cstring);
  }

  // Assemble full string and display
  snprintf(weather_layer_buffer, sizeof(weather_layer_buffer), "%s, %s", temperature_buffer, conditions_buffer);
  text_layer_set_text(s_weather_layer, weather_layer_buffer);
}

static void inbox_dropped_callback(AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Message dropped!");
}

static void outbox_failed_callback(DictionaryIterator *iterator, AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Outbox send failed!");
}

static void outbox_sent_callback(DictionaryIterator *iterator, void *context) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Outbox send success!");
}

static void init() {
  s_main_window = window_create();
  window_set_background_color(s_main_window, GColorBlack);
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload
  });
  window_stack_push(s_main_window, true);

  tick_timer_service_subscribe(MINUTE_UNIT, tick_handler);
  update_time();

  // Register callbacks
  app_message_register_inbox_received(inbox_received_callback);
  app_message_register_inbox_dropped(inbox_dropped_callback);
  app_message_register_outbox_failed(outbox_failed_callback);
  app_message_register_outbox_sent(outbox_sent_callback);

  // Open AppMessage
  const int inbox_size = 256;
  const int outbox_size = 128;
  app_message_open(inbox_size, outbox_size);

  // Register for battery level updates
  battery_state_service_subscribe(battery_callback);
  battery_callback(battery_state_service_peek());

  // Register for Bluetooth connection updates
  connection_service_subscribe((ConnectionHandlers) {
    .pebble_app_connection_handler = bluetooth_callback
  });

  // Show the correct state of the BT connection from the start
  bluetooth_callback(connection_service_peek_pebble_app_connection());
}

static void deinit() {
  window_destroy(s_main_window);
}

int main(void) {
  init();
  app_event_loop();
  deinit();
}
```
{% endmarkdown %}
</details>

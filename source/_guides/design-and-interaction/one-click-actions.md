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

title: One Click Actions
description: |
  Details about how to create One Click Action watchapps
guide_group: design-and-interaction
menu: true
order: 2
related_docs:
  - AppExitReason
  - AppGlanceSlice
  - AppMessage
related_examples:
  - title: One Click Action Example
    url: https://github.com/pebble-examples/one-click-action-example
---

One click actions are set to revolutionize the way users interact with their
Pebble by providing instant access to their favorite one click watchapps,
directly from the new system launcher. Want to unlock your front door?
Call an Uber? Or perhaps take an instant voice note? With one click actions,
the user is able to instantly perform a single action by launching an app, and
taking no further action.

![Lockitron >{pebble-screenshot,pebble-screenshot--time-black}](/images/guides/design-and-interaction/lockitron.png)

### The One Click Flow

It’s important to develop your one click application with a simple and elegant
flow. You need to simplify the process of your application by essentially
creating an application which serves a single purpose.

The typical flow for a one click application would be as follows:

1. Application is launched
2. Application performs action
3. Application displays status to user
4. Application automatically exits to watchface if the action was successful,
or displays status message and does not exit if the action failed

If we were creating an instant voice note watchapp, the flow could be as
follows:

1. Application launched
2. Application performs action (take a voice note)
  1. Start listening for dictation
  2. Accept dictation response
3. Application displays a success message
4. Exit to watchface

In the case of a one click application for something like Uber, we would need to
track the state of any existing booking to prevent ordering a second car. We
would also want to update the ``App Glance``
as the status of the booking changes.

1. Application launched
2. If a booking exists:
  1. Refresh booking status
  2. Update ``App Glance`` with new status
  3. Exit to watchface
3. Application performs action (create a booking)
  1. Update AppGlance: “Your Uber is on it’s way”
  2. Application displays a success message
  3. Exit to watchface

### Building a One Click Application

For this example, we’re going to build a one click watchapp which will lock or
unlock the front door of our virtual house. We’re going to use a virtual
[Lockitron](https://lockitron.com/), or a real one if you’re lucky enough to
have one.

Our flow will be incredibly simple:

1. Launch the application
2. Take an action (toggle the state of the lock)
3. Update the ``App Glance`` to indicate the new lock state
4. Display a success message
5. Exit to watchface

For the sake of simplicity in our example, we will not know if someone else has
locked or unlocked the door using a different application. You can investigate
the [Lockitron API](http://api.lockitron.com) if you want to develop this idea
further.

In order to control our Lockitron, we need the UUID of the lock and an access
key. You can generate your own virtual lockitron UUID and access code on the
[Lockitron website](https://api.lockitron.com/v1/getting_started/virtual_locks).

```c
#define LOCKITRON_LOCK_UUID "95c22a11-4c9e-4420-adf0-11f1b36575f2"
#define LOCKITRON_ACCESS_TOKEN "99e75a775fe737bb716caf88f161460bb623d283c3561c833480f0834335668b"
```

> Never publish your actual Lockitron access token in the appstore, unless you
want strangers unlocking your door! Ideally you would make these fields
configurable using [Clay for Pebble](https://github.com/pebble-dev/clay).

We’re going to need a simple enum for the state of our lock, where 0 is
unlocked, 1 is locked and anything else is unknown.

```c
typedef enum {
  LOCKITRON_UNLOCKED,
  LOCKITRON_LOCKED,
  LOCKITRON_UNKNOWN
} LockitronLockState;
```

We’re also going to use a static variable to keep track of the state of our
lock.

```c
static LockitronLockState s_lockitron_state;
```

When our application launches, we’re going to initialize ``AppMessage`` and
then wait for PebbleKit JS to tell us it’s ready.

```c
static void prv_init(void) {
  app_message_register_inbox_received(prv_inbox_received_handler);
  app_message_open(256, 256);
  s_window = window_create();
  window_stack_push(s_window, false);
}

static void prv_inbox_received_handler(DictionaryIterator *iter, void *context) {
  Tuple *ready_tuple = dict_find(iter, MESSAGE_KEY_APP_READY);
  if (ready_tuple) {
    // PebbleKit JS is ready, toggle the Lockitron!
    prv_lockitron_toggle_state();
    return;
  }
  // ...
}
```

In order to toggle the state of the Lockitron, we’re going to send an
``AppMessage`` to PebbleKit JS, containing our UUID and our access key.

```c
static void prv_lockitron_toggle_state() {
  DictionaryIterator *out;
  AppMessageResult result = app_message_outbox_begin(&out);
  dict_write_cstring(out, MESSAGE_KEY_LOCK_UUID, LOCKITRON_LOCK_UUID);
  dict_write_cstring(out, MESSAGE_KEY_ACCESS_TOKEN, LOCKITRON_ACCESS_TOKEN);
  result = app_message_outbox_send();
}
```

PebbleKit JS will handle this request and make the relevant ajax request to the
Lockitron API. It will then return the current state of the lock and tell our
application to exit back to the default watchface using
``AppExitReason``. See the
[full example](https://github.com/pebble-examples/one-click-action-example) for
the actual Javascript implementation.

```c
static void prv_inbox_received_handler(DictionaryIterator *iter, void *context) {
  // ...
  Tuple *lock_state_tuple = dict_find(iter, MESSAGE_KEY_LOCK_STATE);
  if (lock_state_tuple) {
    // Lockitron state has changed
    s_lockitron_state = (LockitronLockState)lock_state_tuple->value->int32;
    // App will exit to default watchface
    app_exit_reason_set(APP_EXIT_ACTION_PERFORMED_SUCCESSFULLY);
    // Exit the application by unloading the only window
    window_stack_remove(s_window, false);
  }
}
```

Before our application terminates, we need to update the
``App Glance`` with the current state
of our lock. We do this by passing our current lock state into the
``app_glance_reload`` method.

```c
static void prv_deinit(void) {
  window_destroy(s_window);
  // Before the application terminates, setup the AppGlance
  app_glance_reload(prv_update_app_glance, &s_lockitron_state);
}
```

We only need a single ``AppGlanceSlice`` for our ``App Glance``, but it’s worth
noting you can have multiple slices with varying expiration times.

```c
static void prv_update_app_glance(AppGlanceReloadSession *session, size_t limit, void *context) {
  // Check we haven't exceeded system limit of AppGlances
  if (limit < 1) return;

  // Retrieve the current Lockitron state from context
  LockitronLockState *lockitron_state = context;

  // Generate a friendly message for the current Lockitron state
  char *str = prv_lockitron_status_message(lockitron_state);
  APP_LOG(APP_LOG_LEVEL_INFO, "STATE: %s", str);

  // Create the AppGlanceSlice (no icon, no expiry)
  const AppGlanceSlice entry = (AppGlanceSlice) {
    .layout = {
      .template_string = str
    },
    .expiration_time = time(NULL)+3600
  };

  // Add the slice, and check the result
  const AppGlanceResult result = app_glance_add_slice(session, entry);
  if (result != APP_GLANCE_RESULT_SUCCESS) {
    APP_LOG(APP_LOG_LEVEL_ERROR, "AppGlance Error: %d", result);
  }
}
```

### Handling Launch Reasons

In the example above, we successfully created an application that will
automatically execute our One Click Action when the application is launched.
But we also need to be aware of some additional launch reasons where it would
not be appropriate to perform the action.

By using the ``launch_reason()`` method, we can detect why our application was
started and prevent the One Click Action from firing unnecessarily.

A common example, would be to detect if the application was actually started by
the user, from either the launcher, or quick launch.

```c
  if(launch_reason() == APP_LAUNCH_USER || launch_reason() == APP_LAUNCH_QUICK_LAUNCH) {
    // Perform One Click
  } else {
    // Display a message
  }
```

### Conclusion

As you can see, it’s a relatively small amount of code to create one click
watchapps and we hope this inspires you to build your own!

We recommend that you check out the complete
[Lockitron sample](https://github.com/pebble-examples/one-click-action-example)
application and also the ``App Glance`` and ``AppExitReason`` guides for further
information.

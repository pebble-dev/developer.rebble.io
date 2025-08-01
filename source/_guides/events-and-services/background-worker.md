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

title: Background Worker
description: |
  Using the Background Worker to do work in the background, such as activity
  tracking.
guide_group: events-and-services
order: 1
related_docs:
  - Worker
related_examples:
  - title: Background Counter
    url: https://github.com/pebble-examples/feature-background-counter
  - title: Background Worker Communication
    url: https://github.com/pebble-examples/feature-worker-message
---

In addition to the main foreground task that every Pebble app implements, a
second background worker task can also be created. This worker is capable of
running even when the foreground task is closed, and is useful for tasks that
must continue for long periods of time. For example, apps that log sensor data.

There are several important points to note about the capabilities of this
worker when compared to those of the foreground task:

* The worker is constrained to 10.5 kB of memory.

* Some APIs are not available to the worker. See the 
  [*Available APIs*](#available-apis) section below for more information.

* There can only be one background worker active at a time. In the event that a
  second one attempts to launch from another watchapp, the user will be asked to
  choose whether the new worker can replace the existing one.

* The user can determine which app's worker is running by checking the
  'Background App' section of the Settings menu. Workers can also be launched
  from there.

* The worker can launch the foreground app using ``worker_launch_app()``. This
  means that the foreground app should be prepared to be launched at any time
  that the worker is running.

> Note: This API should not be used to build background timers; use the
> ``Wakeup`` API instead.


## Adding a Worker

The background worker's behavior is determined by code written in a
separate C file to the foreground app, created in the `/worker_src` project 
directory.

This project structure can also be generated using the 
[`pebble` tool](/guides/tools-and-resources/pebble-tool/) with the `--worker`
flag as shown below:

```bash
$ pebble new-project --worker project_name
```

The worker C file itself has a basic structure similar to a regular Pebble app,
but with a couple of minor changes, as shown below:

```c
#include <pebble_worker.h>

static void prv_init() {
  // Initialize the worker here
}

static void prv_deinit() {
  // Deinitialize the worker here
}

int main(void) {
  prv_init();
  worker_event_loop();
  prv_deinit();
}
```


## Launching the Worker

To launch the worker from the foreground app, use ``app_worker_launch()``:

```c
// Launch the background worker
AppWorkerResult result = app_worker_launch();
```

The ``AppWorkerResult`` returned will indicate any errors encountered as a
result of attempting to launch the worker. Possible result values include:

| Result | Value | Description |
|--------|-------|:------------|
| ``APP_WORKER_RESULT_SUCCESS`` | `0` | The worker launch was successful, but may not start running immediately. Use ``app_worker_is_running()`` to determine when the worker has started running. |
| ``APP_WORKER_RESULT_NO_WORKER`` | `1` | No worker found for the current app. |
| ``APP_WORKER_RESULT_ALREADY_RUNNING`` | `4` | The worker is already running. |
| ``APP_WORKER_RESULT_ASKING_CONFIRMATION`` | `5` | The user will be asked for confirmation. To determine whether the worker was given permission to launch, use ``app_worker_is_running()`` for a short period after receiving this result. |


## Communicating Between Tasks

There are three methods of passing data between the foreground and background 
worker tasks:

* Save the data using the ``Storage`` API, then read it in the other task.

* Send the data to a companion phone app using the ``DataLogging`` API. Details
  on how to do this are available in {% guide_link communication/datalogging %}.

* Pass the data directly while the other task is running, using an
  ``AppWorkerMessage``. These messages can be sent bi-directionally by creating 
  an `AppWorkerMessageHandler` in each task. The handler will fire in both the 
  foreground and the background tasks, so you must identify the source 
  of the message using the `type` parameter. 

    ```c
    // Used to identify the source of a message
    #define SOURCE_FOREGROUND 0
    #define SOURCE_BACKGROUND 1
    ```

    **Foreground App**

    ```c
    static int s_some_value = 1;
    static int s_another_value = 2;

    static void worker_message_handler(uint16_t type, 
                                        AppWorkerMessage *message) {
      if(type == SOURCE_BACKGROUND) {
        // Get the data, only if it was sent from the background
        s_some_value = message->data0;
        s_another_value = message->data1;
      }
    }

    // Subscribe to get AppWorkerMessages
    app_worker_message_subscribe(worker_message_handler);


    // Construct a message to send
    AppWorkerMessage message = {
      .data0 = s_some_value,
      .data1 = s_another_value
    };

    // Send the data to the background app
    app_worker_send_message(SOURCE_FOREGROUND, &message);

    ```

    **Worker**

    ```c
    static int s_some_value = 3;
    static int s_another_value = 4;

    // Construct a message to send
    AppWorkerMessage message = {
      .data0 = s_some_value,
      .data1 = s_another_value
    };

    static void worker_message_handler(uint16_t type, 
                                        AppWorkerMessage *message) {
      if(type == SOURCE_FOREGROUND) {
        // Get the data, if it was sent from the foreground
        s_some_value = message->data0;
        s_another_value = message->data1;
      }
    }

    // Subscribe to get AppWorkerMessages
    app_worker_message_subscribe(worker_message_handler);

    // Send the data to the foreground app
    app_worker_send_message(SOURCE_BACKGROUND, &message);
    ```


## Managing the Worker

The current running state of the background worker can be determined using the
``app_worker_is_running()`` function:

```c
// Check to see if the worker is currently active
bool running = app_worker_is_running();
```

The user can tell whether the worker is running by checking the system
'Background App' settings. Any installed workers with be listed there.

The worker can be stopped using ``app_worker_kill()``:

```c
// Stop the background worker
AppWorkerResult result = app_worker_kill();
```

Possible `result` values when attempting to kill the worker are as follows:

| Result | Value | Description |
|--------|-------|:------------|
| ``APP_WORKER_RESULT_SUCCESS`` | `0` | The worker launch was killed successfully. |
| ``APP_WORKER_RESULT_DIFFERENT_APP`` | `2` | A worker from a different app is running, and cannot be killed by this app. |
| ``APP_WORKER_RESULT_NOT_RUNNING`` | `3` | The worker is not currently running. |


## Available APIs

Background workers do not have access to the UI APIs. They also cannot use the
``AppMessage`` API or load resources. Most other APIs are available including
(but not limited to) ``AccelerometerService``, ``CompassService``,
``DataLogging``, ``HealthService``, ``ConnectionService``,
``BatteryStateService``, ``TickTimerService`` and ``Storage``.

The compiler will throw an error if the developer attempts to use an API
unsupported by the worker. For a definitive list of available APIs, check
`pebble_worker.h` in the SDK bundle for the presence of the desired API.

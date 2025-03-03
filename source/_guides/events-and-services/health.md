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

title: Pebble Health
description: |
  Information on using the HealthService API to incorporate multiple types of
  health data into your apps.
guide_group: events-and-services
order: 6
platforms:
  - basalt
  - chalk
  - diorite
  - emery
related_docs:
  - HealthService
related_examples:
  - title: Simple Health Example
    url: https://github.com/pebble-examples/simple-health-example
---

[Pebble Health](https://blog.rebble.io/2015/12/15/health/) provides builtin
health data tracking to allow users to improve their activity and sleep habits.
With SDK 3.9, the ``HealthService`` API opens this data up to developers to
include and use within their apps. For example, a watchface could display a
brief summary of the user's activity for the day.


## API Availability

In order to use the ``HealthService`` (and indeed Pebble Health), the user must
enable the 'Pebble Health' app in the 'Apps/Timeline' view of the official
Pebble mobile app. If this is not enabled health data will not be available to
apps, and API calls will return values to reflect this.

In addition, any app using the ``HealthService`` API must declare the 'health'
capability in order to be accepted by the 
[developer portal](https://dev-portal.rebble.io/). This can be done in
CloudPebble 'Settings', or in `package.json` in the local SDK:

```js
"capabilities": [ "health" ]
```

Since Pebble Health is not available on the Aplite platform, developers should
check the API return values and hence the lack of ``HealthService`` on that
platform gracefully. In addition, the `PBL_HEALTH` define and
`PBL_IF_HEALTH_ELSE()` macro can be used to selectively omit affected code.


## Available Metrics

The ``HealthMetric`` `enum` lists the types of data (or 'metrics') that can be
read using the API. These are described below:

| Metric | Description |
|--------|-------------|
| `HealthMetricStepCount` | The user's step count. |
| `HealthMetricActiveSeconds` | Duration of time the user was considered 'active'. |
| `HealthMetricWalkedDistanceMeters` | Estimation of the distance travelled in meters. |
| `HealthMetricSleepSeconds` | Duration of time the user was considered asleep. |
| `HealthMetricSleepRestfulSeconds` | Duration of time the user was considered in deep restful sleep. |
| `HealthMetricRestingKCalories` | The number of kcal (thousand calories) burned due to resting metabolism. |
| `HealthMetricActiveKCalories` | The number of kcal (thousand calories) burned due to activity. |
| `HealthMetricHeartRateBPM` | The heart rate, in beats per minute. |


## Subscribing to HealthService Events

Like other Event Services, an app can subscribe a handler function to receive a
callback when new health data is available. This is useful for showing 
near-realtime activity updates. The handler must be a suitable implementation of
``HealthEventHandler``. The `event` parameter describes the type of each update,
and is one of the following from the ``HealthEventType`` `enum`:

| Event Type | Value | Description |
|------------|-------|-------------|
| `HealthEventSignificantUpdate` | `0` | All data is considered as outdated, apps should re-read all health data. This can happen on a change of the day or in other cases that significantly change the underlying data. |
| `HealthEventMovementUpdate` | `1` | Recent values around `HealthMetricStepCount`, `HealthMetricActiveSeconds`, `HealthMetricWalkedDistanceMeters`, and `HealthActivityMask` changed. |
| `HealthEventSleepUpdate` | `2` | Recent values around `HealthMetricSleepSeconds`, `HealthMetricSleepRestfulSeconds`, `HealthActivitySleep`, and `HealthActivityRestfulSleep` changed. |
| `HealthEventHeartRateUpdate` | `4` | The value of `HealthMetricHeartRateBPM` has changed. |

A simple example handler is shown below, which outputs to app logs the type of
event that fired the callback:

```c
static void health_handler(HealthEventType event, void *context) {
  // Which type of event occurred?
  switch(event) {
    case HealthEventSignificantUpdate:
      APP_LOG(APP_LOG_LEVEL_INFO, 
              "New HealthService HealthEventSignificantUpdate event");
      break;
    case HealthEventMovementUpdate:
      APP_LOG(APP_LOG_LEVEL_INFO, 
              "New HealthService HealthEventMovementUpdate event");
      break;
    case HealthEventSleepUpdate:
      APP_LOG(APP_LOG_LEVEL_INFO, 
              "New HealthService HealthEventSleepUpdate event");
      break;
    case HealthEventHeartRateUpdate:
      APP_LOG(APP_LOG_LEVEL_INFO,
              "New HealthService HealthEventHeartRateUpdate event");
      break;
  }
}
```

The subscription is then registered in the usual way, optionally providing a
`context` parameter that is relayed to each event callback. The return value
should be used to determine whether the subscription was successful:

```c
#if defined(PBL_HEALTH)
// Attempt to subscribe 
if(!health_service_events_subscribe(health_handler, NULL)) {
  APP_LOG(APP_LOG_LEVEL_ERROR, "Health not available!");
}
#else
APP_LOG(APP_LOG_LEVEL_ERROR, "Health not available!");
#endif
```


## Reading Health Data

Health data is collected in the background as part of Pebble Health regardless
of the state of the app using the ``HealthService`` API, and is available to
apps through various ``HealthService`` API functions.

Before reading any health data, it is recommended to check that data is
available for the desired time range, if applicable. In addition to the
``HealthServiceAccessibilityMask`` value, health-related code can be
conditionally compiled using `PBL_HEALTH`. For example, to check whether 
any data is available for a given time range:

```c
#if defined(PBL_HEALTH)
// Use the step count metric
HealthMetric metric = HealthMetricStepCount;

// Create timestamps for midnight (the start time) and now (the end time)
time_t start = time_start_of_today();
time_t end = time(NULL);

// Check step data is available
HealthServiceAccessibilityMask mask = health_service_metric_accessible(metric, 
                                                                    start, end);
bool any_data_available = mask & HealthServiceAccessibilityMaskAvailable;
#else
// Health data is not available here
bool any_data_available = false;
#endif
```

Most applications will want to read the sum of a metric for the current day's
activity. This is the simplest method for accessing summaries of users' health
data, and is shown in the example below:

```c
HealthMetric metric = HealthMetricStepCount;
time_t start = time_start_of_today();
time_t end = time(NULL);

// Check the metric has data available for today
HealthServiceAccessibilityMask mask = health_service_metric_accessible(metric, 
  start, end);

if(mask & HealthServiceAccessibilityMaskAvailable) {
  // Data is available!
  APP_LOG(APP_LOG_LEVEL_INFO, "Steps today: %d", 
          (int)health_service_sum_today(metric));
} else {
  // No data recorded yet today
  APP_LOG(APP_LOG_LEVEL_ERROR, "Data unavailable!");
}
```

For more specific data queries, the API also allows developers to request data
records and sums of metrics from a specific time range. If data is available, it
can be read as a sum of all values recorded between that time range. You can use
the convenience constants from ``Time``, such as ``SECONDS_PER_HOUR`` to adjust
a timestamp relative to the current moment returned by ``time()``.

> Note: The value returned will be an average since midnight, weighted for the
> length of the specified time range. This may change in the future.

An example of this process is shown below:

```c
// Make a timestamp for now
time_t end = time(NULL);

// Make a timestamp for the last hour's worth of data
time_t start = end - SECONDS_PER_HOUR;

// Check data is available
HealthServiceAccessibilityMask result = 
    health_service_metric_accessible(HealthMetricStepCount, start, end);
if(result & HealthServiceAccessibilityMaskAvailable) {
  // Data is available! Read it
  HealthValue steps = health_service_sum(HealthMetricStepCount, start, end);

  APP_LOG(APP_LOG_LEVEL_INFO, "Steps in the last hour: %d", (int)steps);
} else {
  APP_LOG(APP_LOG_LEVEL_ERROR, "No data available!");
}
```


## Representing Health Data

Depending on the locale of the user, the conventional measurement system used to
represent distances may vary between metric and imperial. For this reason it is
recommended to query the user's preferred ``MeasurementSystem`` before
formatting distance data from the ``HealthService``:

> Note: This API is currently only meaningful when querying the
> ``HealthMetricWalkedDistanceMeters`` metric. ``MeasurementSystemUnknown`` will
> be returned for all other queries.

```c
const HealthMetric metric = HealthMetricWalkedDistanceMeters;
const HealthValue distance = health_service_sum_today(metric);

// Get the preferred measurement system
MeasurementSystem system = health_service_get_measurement_system_for_display(
                                                                        metric);

// Format accordingly
static char s_buffer[32];
switch(system) {
  case MeasurementSystemMetric:
    snprintf(s_buffer, sizeof(s_buffer), "Walked %d meters", (int)distance);    
    break;
  case MeasurementSystemImperial: {
    // Convert to imperial first
    int feet = (int)((float)distance * 3.28F);
    snprintf(s_buffer, sizeof(s_buffer), "Walked %d feet", (int)feet);
  } break;
  case MeasurementSystemUnknown:
  default:
    APP_LOG(APP_LOG_LEVEL_INFO, "MeasurementSystem unknown or does not apply");
}

// Display to user in correct units
text_layer_set_text(s_some_layer, s_buffer);
```


## Obtaining Averaged Data

The ``HealthService`` also allows developers to read average values of a
particular ``HealthMetric`` with varying degrees of scope. This is useful for
apps that wish to display an average value (e.g.: as a goal for the user)
alongside a summed value. 

In this context, the `start` and `end` parameters specify the time period to be
used for the daily average calculation. For example, a start time of midnight
and an end time ten hours later will return the average value for the specified
metric measured until 10 AM on average across the days specified by the scope.

The ``HealthServiceTimeScope`` specified when querying for averaged data over a
given time range determines how the average is calculated, as detailed in the
table below:

| Scope Type | Description |
|------------|-------------|
| `HealthServiceTimeScopeOnce` | No average computed. The result is the same as calling ``health_service_sum()``. |
| `HealthServiceTimeScopeWeekly` | Compute average using the same day from each week (up to four weeks). For example, every Monday if the provided time range falls on a Monday. |
| `HealthServiceTimeScopeDailyWeekdayOrWeekend` | Compute average using either weekdays (Monday to Friday) or weekends (Saturday and Sunday), depending on which day the provided time range falls. |
| `HealthServiceTimeScopeDaily` | Compute average across all days of the week. |

> Note: If the difference between the start and end times is greater than one
> day, an average will be returned that takes both days into account. Similarly,
> if the time range crosses between scopes (such as including weekend days and
> weekdays with ``HealthServiceTimeScopeDailyWeekdayOrWeekend``), the start time
> will be used to determine which days are used.

Reading averaged data values works in a similar way to reading sums. The example
below shows how to read an average step count across all days of the week for a
given time range:

```c
// Define query parameters
const HealthMetric metric = HealthMetricStepCount;
const HealthServiceTimeScope scope = HealthServiceTimeScopeDaily;

// Use the average daily value from midnight to the current time
const time_t start = time_start_of_today();
const time_t end = time(NULL);

// Check that an averaged value is accessible
HealthServiceAccessibilityMask mask = 
          health_service_metric_averaged_accessible(metric, start, end, scope);
if(mask & HealthServiceAccessibilityMaskAvailable) {
  // Average is available, read it
  HealthValue average = health_service_sum_averaged(metric, start, end, scope);

  APP_LOG(APP_LOG_LEVEL_INFO, "Average step count: %d steps", (int)average);
}
```


## Detecting Activities

It is possible to detect when the user is sleeping using a
``HealthActivityMask`` value. A useful application of this information could be
to disable a watchface's animations or tick at a reduced rate once the user is
asleep. This is done by checking certain bits of the returned value:

```c
// Get an activities mask
HealthActivityMask activities = health_service_peek_current_activities();

// Determine which bits are set, and hence which activity is active
if(activities & HealthActivitySleep) {
  APP_LOG(APP_LOG_LEVEL_INFO, "The user is sleeping.");
} else if(activities & HealthActivityRestfulSleep) {
  APP_LOG(APP_LOG_LEVEL_INFO, "The user is sleeping peacefully.");
} else {
  APP_LOG(APP_LOG_LEVEL_INFO, "The user is not currently sleeping.");
}
```


## Read Per-Minute History

The ``HealthMinuteData`` structure contains multiple types of activity-related
data that are recorded in a minute-by-minute fashion. This style of data access
is best suited to those applications requiring more granular detail (such as
creating a new fitness algorithm). Up to seven days worth of data is available
with this API. 

> See [*Notes on Minute-level Data*](#notes-on-minute-level-data) below for more
> information on minute-level data.

The data items contained in the ``HealthMinuteData`` structure are summarized
below:

| Item | Type | Description |
|------|------|-------------|
| `steps` | `uint8_t`  | Number of steps taken in this minute. |
| `orientation` | `uint8_t` | Quantized average orientation, encoding the x-y plane (the "yaw") in the lower 4 bits (360 degrees linearly mapped to 1 of 16 values) and the z axis (the "pitch") in the upper 4 bits. |
| `vmc` | `uint16_t` | Vector Magnitude Counts (VMC). This is a measure of the total amount of movement seen by the watch. More vigorous movement yields higher VMC values. |
| `is_invalid` | `bool` | `true` if the item doesn't represent actual data, and should be ignored. |
| `heart_rate_bpm` | `uint8_t` | Heart rate in beats per minute (if available). |

These data items can be obtained in the following manner, similar to obtaining a
sum. 

```c
// Create an array to store data
const uint32_t max_records = 60;
HealthMinuteData *minute_data = (HealthMinuteData*)
                              malloc(max_records * sizeof(HealthMinuteData));

// Make a timestamp for 15 minutes ago and an hour before that 
time_t end = time(NULL) - (15 * SECONDS_PER_MINUTE);
time_t start = end - SECONDS_PER_HOUR;

// Obtain the minute-by-minute records
uint32_t num_records = health_service_get_minute_history(minute_data, 
                                                  max_records, &start, &end);
APP_LOG(APP_LOG_LEVEL_INFO, "num_records: %d", (int)num_records);

// Print the number of steps for each minute
for(uint32_t i = 0; i < num_records; i++) {
  APP_LOG(APP_LOG_LEVEL_INFO, "Item %d steps: %d", (int)i, 
          (int)minute_data[i].steps);
}
```

Don't forget to free the array once the data is finished with:

```c
// Free the array
free(minute_data);
```

### Notes on Minute-level Data

Missing minute-level records can occur if the watch is reset, goes into low 
power (watch-only) mode due to critically low battery, or Pebble Health is 
disabled during the time period requested.

``health_service_get_minute_history()`` will return as many **consecutive**
minute-level records that are available after the provided `start` timestamp, 
skipping any missing records until one is found. This API behavior enables one 
to easily continue reading data after a previous query encountered a missing 
minute. If there are some minutes with missing data, the API will return all 
available records up to the last available minute, and no further. Conversely, 
records returned will begin with the first available record after the provided 
`start` timestamp, skipping any missing records until one is found. This can 
be used to continue reading data after a previous query encountered a missing 
minute.

The code snippet below shows an example function that packs a provided
``HealthMinuteData`` array with all available values in a time range, up to an
arbitrary maximum number. Any missing minutes are collapsed, so that as much
data can be returned as is possible for the allocated array size and time range
requested.

> This example shows querying up to 60 records. More can be obtained, but this
> increases the heap allocation required as well as the time taken to process
> the query.

```c
static uint32_t get_available_records(HealthMinuteData *array, time_t query_start, 
                                      time_t query_end, uint32_t max_records) {
  time_t next_start = query_start;
  time_t next_end = query_end;
  uint32_t num_records_found = 0;

  // Find more records until no more are returned
  while (num_records_found < max_records) {
    int ask_num_records = max_records - num_records_found;
    uint32_t ret_val = health_service_get_minute_history(&array[num_records_found], 
                                        ask_num_records, &next_start, &next_end);
    if (ret_val == 0) {
      // a 0 return value means no more data is available
      return num_records_found;
    }
    num_records_found += ret_val;
    next_start = next_end;
    next_end = query_end;
  } 

  return num_records_found;
}

static void print_last_hours_steps() {
  // Query for the last hour, max 60 minute-level records 
  // (except the last 15 minutes)
  const time_t query_end = time(NULL) - (15 * SECONDS_PER_MINUTE);
  const time_t query_start = query_end - SECONDS_PER_HOUR;
  const uint32_t max_records = (query_end - query_start) / SECONDS_PER_MINUTE;
  HealthMinuteData *data = 
              (HealthMinuteData*)malloc(max_records * sizeof(HealthMinuteData));

  // Populate the array
  max_records = get_available_records(data, query_start, query_end, max_records);

  // Print the results
  for(uint32_t i = 0; i < max_records; i++) {
    if(!data[i].is_invalid) {
      APP_LOG(APP_LOG_LEVEL_INFO, "Record %d contains %d steps.", (int)i, 
                                                            (int)data[i].steps);
    } else {
      APP_LOG(APP_LOG_LEVEL_INFO, "Record %d was not valid.", (int)i);
    }
  }

  free(data);
}
```

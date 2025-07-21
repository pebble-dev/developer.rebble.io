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

title: Heart Rate Monitor
description: |
  Information on using the HealthService API to obtain information from the
  Heart Rate Monitor.
guide_group: events-and-services
order: 6
related_docs:
  - HealthService
related_examples:
  - title: HRM Watchface
    url: https://github.com/pebble-examples/watchface-tutorial-hrm
  - title: HRM Activity
    url: https://github.com/pebble-examples/hrm-activity-example
platform_choice: true
---

The Pebble Time 2 and Pebble 2 (excluding SE model)
{% guide_link tools-and-resources/hardware-information "devices" %} include a
heart rate monitor. This guide will demonstrate how to use the ``HealthService``
API to retrieve information about the user's current, and historical heart
rates.

If you aren't already familiar with the ``HealthService``, we recommended that
you read the {% guide_link events-and-services/health "Health guide" %}
before proceeding.

## Enable Health Data

<div class="platform-specific" data-sdk-platform="local">
{% markdown {} %}
Before your application is able to access the heart rate information, you will
need to add `heath` to the `capabilities` array in your applications
`package.json` file.

```js
{
  ...
  "pebble": {
    ...
    "capabilities": [ "health" ],
    ...
  }
}
```
{% endmarkdown %}
</div>

^CP^ Before your application is able to access heart rate information, you will
need to enable the `USES HEALTH` option in your project settings on
[CloudPebble]({{ site.links.cloudpebble }}).


## Data Quality

Heart rate sensors aren't perfect, and their readings can be affected by
improper positioning, environmental factors and excessive movement. The raw data
from the HRM sensor contains a metric to indicate the quality of the readings it
receives.

The HRM API provides a raw BPM reading (``HealthMetricHeartRateRawBPM``) and a
filtered reading (``HealthMetricHeartRateBPM``). This filtered value minimizes
the effect of hand movement and improper sensor placement, by removing the bad
quality readings. This filtered data makes it easy for developers to integrate
in their applications, without needing to filter the data themselves.


## Obtaining the Current Heart Rate

To obtain the current heart rate, you should first check whether the
``HealthMetricHeartRateBPM`` is available by using the
``health_service_metric_accessible`` method.

Then you can obtain the current heart rate using the
``health_service_peek_current_value`` method:

```c
HealthServiceAccessibilityMask hr = health_service_metric_accessible(HealthMetricHeartRateBPM, time(NULL), time(NULL));
if (hr & HealthServiceAccessibilityMaskAvailable) {
  HealthValue val = health_service_peek_current_value(HealthMetricHeartRateBPM);
  if(val > 0) {
    // Display HRM value
    static char s_hrm_buffer[8];
    snprintf(s_hrm_buffer, sizeof(s_hrm_buffer), "%lu BPM", (uint32_t)val);
    text_layer_set_text(s_hrm_layer, s_hrm_buffer);
  }
}
```
> **Note** this value is averaged from readings taken over the past minute, but
due to the [sampling rate](#heart-rate-sample-periods) and our data filters,
this value could be several minutes old. Use `HealthMetricHeartRateRawBPM` for
the raw, unfiltered value.


## Subscribing to Heart Rate Updates

The user's heart rate can also be monitored via an event subscription, in a
similar way to the other health metrics. If you wanted your watchface to update
the displayed heart rate every time the HRM takes a new reading, you could use
the ``health_service_events_subscribe`` method.

```c

static void prv_on_health_data(HealthEventType type, void *context) {
  // If the update was from the Heart Rate Monitor, query it
  if (type == HealthEventHeartRateUpdate) {
    HealthValue value = health_service_peek_current_value(HealthMetricHeartRateBPM);
    // Display the heart rate
  }
}

static void prv_init(void) {
  // Subscribe to health event handler
  health_service_events_subscribe(prv_on_health_data, NULL);
  // ...
}
```

> **Note** The frequency of these updates does not directly correlate to the
> sensor sampling rate.


## Heart Rate Sample Periods

The default sample period is 10 minutes, but the system automatically controls
the HRM sample rate based on the level of user activity. It increases the
sampling rate during intense activity and reduces it again during inactivity.
This aims to provide the optimal battery usage.

### Battery Considerations

Like all active sensors, accelerometer, backlight etc, the HRM sensor will have
a negative affect on battery life. It's important to consider this when using
the APIs within your application.

By default the system will automatically control the heart rate sampling period
for the optimal balance between update frequency and battery usage. In addition,
the APIs have been designed to allow developers to retrieve values for the most
common use cases with minimal impact on battery life.

### Altering the Sampling Period

Developers can request a specific sampling rate using the
``health_service_set_heart_rate_sample_period`` method. The system will use this
value as a suggestion, but does not guarantee that value will be used. The
actual sampling period may be greater or less due to other apps that require
input from the sensor, or data quality issues.

The shortest period you can currently specify is `1` second, and the longest
period you can specify is `600` seconds (10 minutes).

In this example, we will sample the heart rate monitor every second:

```c
// Set the heart rate monitor to sample every second
bool success = health_service_set_heart_rate_sample_period(1);
```
> **Note** This does not mean that you can peek the current value every second,
> only that the sensor will capture more samples.


### Resetting the Sampling Period

Developers **must** reset the heart rate sampling period when their application
exits. Failing to do so may result in the heart rate monitor continuing at the
increased rate for a period of time, even after your application closes. This
is fundamentally different to other Pebble sensors and was designed so that
applications which a reliant upon high sampling rates can be temporarily
interupted for notifications, or music, without affecting the sensor data.

```c
// Reset the heart rate sampling period to automatic
health_service_set_heart_rate_sample_period(0);
```


## Obtaining Historical Data

If your application is using heart rate information, it may also want to obtain
historical data to compare it against. In this section we'll look at how you can
use the `health_service_aggregate` functions to obtain relevant historic data.

Before requesting historic/aggregate data for a specific time period, you
should ensure that it is available using the
``health_service_metric_accessible`` method.

Then we'll use the ``health_service_aggregate_averaged`` method to
obtain the average daily heart rate over the last 7 days.

```c
// Obtain history for last 7 days
time_t end_time = time(NULL);
time_t start_time = end_time - (7 * SECONDS_PER_DAY);

HealthServiceAccessibilityMask hr = health_service_metric_accessible(HealthMetricHeartRateBPM, start_time, end_time);
if (hr & HealthServiceAccessibilityMaskAvailable) {
  uint32_t weekly_avg_hr = health_service_aggregate_averaged(HealthMetricHeartRateBPM,
                              start_time, end_time,
                              HealthAggregationAvg, HealthServiceTimeScopeDaily);
}
```

You can also query the average `min` and `max` heart rates, but only within the
past two hours (maximum). This limitation is due to very limited storage
capacity on the device, but the implementation may change in the future.

```c
// Obtain history for last 1 hour
time_t end_time = time(NULL);
time_t start_time = end_time - SECONDS_PER_HOUR;

HealthServiceAccessibilityMask hr = health_service_metric_accessible(HealthMetricHeartRateBPM, start_time, end_time);
if (hr & HealthServiceAccessibilityMaskAvailable) {
  uint32_t min_hr = health_service_aggregate_averaged(HealthMetricHeartRateBPM,
                                start_time, end_time,
                                HealthAggregationMin, HealthServiceTimeScopeOnce);
  uint32_t max_hr = health_service_aggregate_averaged(HealthMetricHeartRateBPM,
                                start_time, end_time,
                                HealthAggregationMax, HealthServiceTimeScopeOnce);
}
```

## Read Per-Minute History

The ``HealthMinuteData`` structure contains multiple types of activity-related
data that are recorded in a minute-by-minute fashion. Although this structure
now contains HRM readings, it does not contain information about the quality of
those readings.

> **Note** Please refer to the
> {% guide_link events-and-services/health#read-per-minute-history "Health Guide" %}
> for futher information.


## Next Steps

This guide covered the basics of how to interact with realtime and historic
heart information. We encourage you to further explore the ``HealthService``
documentation, and integrate it into your next project.

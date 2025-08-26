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

title: Creating Pins
description: |
  How to create timeline pins with reminders, actions, and layouts.
guide_group: pebble-timeline
order: 0
---

A timeline pin contains all the information required to be displayed on the
watch, and is written in the JSON object format. It can contain basic
information such as title and times, or more advanced data such as
notifications, reminders, or actions that can be used out from the pin view.


## Pin Overview

The table below details the pin object fields and their function within the
object. Those marked in **bold** are required.

| Field | Type | Function |
|-------|------|----------|
| **`id`** | String (max. 64 chars) | Developer-implemented identifier for this pin event, which cannot be re-used. This means that any pin that was previously deleted cannot then be re-created with the same `id`. |
| **`time`** | String ([ISO date-time](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString)) | The start time of the event the pin represents, such as the beginning of a meeting. See {% guide_link pebble-timeline/timeline-public#pin-time-limitations "Pin Time Limitations" %} for information on the acceptable time range. |
| `duration` | Integer number | The duration of the event the pin represents, in minutes. |
| `createNotification` | [Notification object](#notification-object) | The notification shown when the event is first created. |
| `updateNotification` | [Notification object](#notification-object) | The notification shown when the event is updated but already exists. |
| **`layout`** | [Layout object](#layout-object) | Description of the values to populate the layout when the user views the pin. |
| `reminders` | [Reminder object](#reminder-object) array (Max. 3) | Collection of event reminders to display before an event starts. |
| `actions` | [Action object](#action-object) array | Collection of event actions that can be executed by the user. |


### Notification Object

The notification objects used for `createNotification` and `updateNotification`
contain only one common field: a Layout object describing the visual properties
of the notification.

The other field (`time`) is used only in an `updateNotification` object. The
`createNotification` type does **not** require a `time` attribute.

| Field | Type | Function |
|-------|------|----------|
| `layout` | [Layout object](#layout-object) | The layout that will be used to display this notification. |
| `time` | String (ISO date-time) | The new time of the pin update. |

The `createNotification` is shown when the pin is first delivered to the watch.

The `updateNotification` is shown when the pin already existed and is being
updated on the watch. It will only be shown if the `updateNotification.time` is
newer than the last `updateNotification.time` received by the watch.

Using these fields, developers can build a great experience for their users when
live updating pins. For example, when sending updates about a sports game the
app could use the `createNotification` to tell the user that "The game has just
been added to your timeline" and the `updateNotification` to tell them that "The
game starting time has just been updated in your timeline.".


### Layout Object

The Layout object is used to describe any message shown in a customizable
layout. This includes a pin in the timeline, a notification, and also reminders.
Developers can choose between different layout types and customize them with
attributes.

Required fields are shown in **bold**. Some layout types have additional
required fields not shown below, but listed in their dedicated sections. Values
for icon URIs can be found below under [Pin Icons](#pin-icons), although not all
icons are available at all sizes.

| Field | Type | Function |
|-------|------|----------|
| **`type`** | String | The type of layout the pin will use. See [*Pin Layouts*](#pin-layouts) for a list of available types. |
| `title` | String | The title of the pin when viewed. |
| `subtitle` | String | Shorter subtitle for details. |
| `body` | String | The body text of the pin. Maximum of 512 characters. |
| `tinyIcon` | String | URI of the pin's tiny icon. |
| `smallIcon` | String | URI of the pin's small icon. |
| `largeIcon` | String | URI of the pin's large icon. |

The following attributes are also available for all pin layout types
**(excluding notifications and reminders)**.

| Field | Type | Function |
|-------|------|----------|
| `primaryColor` | String | Six-digit color hexadecimal string or case-insensitive SDK constant (e.g.: "665566" or "mintgreen"), describing the primary text color. |
| `secondaryColor` | String | Similar to `primaryColor`, except applies to the layout's secondary-colored elements. |
| `backgroundColor` | String | Similar to `primaryColor`, except applies to the layout's background color. |
| `headings` | Array of Strings | List of section headings in this layout. The list must be less than 128 characters in length, including the underlying delimiters (one byte) between each item. Longer items will be truncated with an ellipsis ('...'). |
| `paragraphs` | Array of Strings | List of paragraphs in this layout. **Must equal the number of `headings`**. The list must be less than 1024 characters in length, including the underlying delimiters (one byte) between each item. Longer items will be truncated with an ellipsis ('...'). |
| `lastUpdated` | ISO date-time | Timestamp of when the pin’s data (e.g: weather forecast or sports score) was last updated. |


### Reminder Object

Reminders are synchronized to the watch and will be shown at the precise time
set in the reminder. They work even when Pebble is disconnected from the
user's mobile phone.

| Field | Type | Function |
|-------|------|----------|
| `time` | String (ISO date-time) | The time the reminder is scheduled to be shown. |
| `layout` | [Layout object](#layout-object) | The layout of the reminder. |


### Action Object

| Field | Type | Function |
|-------|------|----------|
| `title` | String | The name of the action that appears on the watch. |
| `type` | String | The type of action this will execute. See [*Pin Actions*](#pin-actions) for a list of available actions. |


## Minimal Pin Example

The example pin object shown below includes only the required fields for a
generic pin.

```json
{
  "id": "example-pin-generic-1",
  "time": "2015-03-19T18:00:00Z",
  "layout": {
    "type": "genericPin",
    "title": "News at 6 o'clock",
    "tinyIcon": "system://images/NOTIFICATION_FLAG"
  }
}
```


## Complete Pin Example

Below is a more advanced example pin object:

```json
{
  "id": "meeting-453923",
  "time": "2015-03-19T15:00:00Z",
  "duration": 60,
  "createNotification": {
    "layout": {
      "type": "genericNotification",
      "title": "New Item",
      "tinyIcon": "system://images/NOTIFICATION_FLAG",
      "body": "A new appointment has been added to your calendar at 4pm."
    }
  },
  "updateNotification": {
    "time": "2015-03-19T16:00:00Z",
    "layout": {
      "type": "genericNotification",
      "tinyIcon": "system://images/NOTIFICATION_FLAG",
      "title": "Reminder",
      "body": "The meeting has been rescheduled to 4pm."
    }
  },
  "layout": {
    "title": "Client Meeting",
    "type": "genericPin",
    "tinyIcon": "system://images/TIMELINE_CALENDAR",
    "body": "Meeting in Kepler at 4:00pm. Topic: discuss pizza toppings for party."
  },
  "reminders": [
    {
      "time": "2015-03-19T14:45:00Z",
      "layout": {
        "type": "genericReminder",
        "tinyIcon": "system://images/TIMELINE_CALENDAR",
        "title": "Meeting in 15 minutes"
      }
    },
    {
      "time": "2015-03-19T14:55:00Z",
      "layout": {
        "type": "genericReminder",
        "tinyIcon": "system://images/TIMELINE_CALENDAR",
        "title": "Meeting in 5 minutes"
      }
    }
  ],
  "actions": [
    {
      "title": "View Schedule",
      "type": "openWatchApp",
      "launchCode": 15
    },
    {
      "title": "Show Directions",
      "type": "openWatchApp",
      "launchCode": 22
    }
  ]
}
```


## View Modes

When viewing pins in the timeline, they can be displayed in two different ways.

| State | Preview | Details |
|-------|---------|---------|
| Selected | ![](/images/guides/timeline/timeline-selected.png) | Three lines of text shown from the title, location and sender. |
| Not selected | ![](/images/guides/timeline/timeline-one-line.png) | Time, short title, and icon are shown. |


## Pin Icons

The tables below detail the available icons provided by the system. Each icon
can be used when pushing a pin in the following manner:

```
"layout": {
  "type": "genericNotification",
  "title": "Example Pin",
  "tinyIcon": "system://images/NOTIFICATION_FLAG"
}
```

> For general use in watchapps, PDC files are available for these icons in 
> {% guide_link app-resources/app-assets#pebble-timeline-pin-icons %}.


### Notifications

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/NOTIFICATION_GENERIC.svg =25) | `NOTIFICATION_GENERIC` | Generic notification |
| ![](/images/guides/timeline/NOTIFICATION_REMINDER.svg =25) | `NOTIFICATION_REMINDER` | Reminder notification |
| ![](/images/guides/timeline/NOTIFICATION_FLAG.svg =25) | `NOTIFICATION_FLAG` | Generic notification flag |
| ![](/images/guides/timeline/NOTIFICATION_LIGHTHOUSE.svg =25) | `NOTIFICATION_LIGHTHOUSE` | Generic lighthouse |


### Generic

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/GENERIC_EMAIL.svg =25) | `GENERIC_EMAIL` | Generic email |
| ![](/images/guides/timeline/GENERIC_SMS.svg =25) | `GENERIC_SMS` | Generic SMS icon |
| ![](/images/guides/timeline/GENERIC_WARNING.svg =25) | `GENERIC_WARNING` | Generic warning icon |
| ![](/images/guides/timeline/GENERIC_CONFIRMATION.svg =25) | `GENERIC_CONFIRMATION` | Generic confirmation icon |
| ![](/images/guides/timeline/GENERIC_QUESTION.svg =25) | `GENERIC_QUESTION` | Generic question icon |


### Weather

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/PARTLY_CLOUDY.svg =25) | `PARTLY_CLOUDY` | Partly cloudy weather |
| ![](/images/guides/timeline/CLOUDY_DAY.svg =25) | `CLOUDY_DAY` | Cloudy weather |
| ![](/images/guides/timeline/LIGHT_SNOW.svg =25) | `LIGHT_SNOW` | Light snow weather |
| ![](/images/guides/timeline/LIGHT_RAIN.svg =25) | `LIGHT_RAIN` | Light rain weather |
| ![](/images/guides/timeline/HEAVY_RAIN.svg =25) | `HEAVY_RAIN` | Heavy rain weather icon |
| ![](/images/guides/timeline/HEAVY_SNOW.svg =25) | `HEAVY_SNOW` | Heavy snow weather icon |
| ![](/images/guides/timeline/TIMELINE_WEATHER.svg =25) | `TIMELINE_WEATHER` | Generic weather icon |
| ![](/images/guides/timeline/TIMELINE_SUN.svg =25) | `TIMELINE_SUN` | Sunny weather icon |
| ![](/images/guides/timeline/RAINING_AND_SNOWING.svg =25) | `RAINING_AND_SNOWING` | Raining and snowing weather icon |
| ![](/images/guides/timeline/SUNRISE.svg =25) | `SUNRISE` | Sunrise weather icon |
| ![](/images/guides/timeline/SUNSET.svg =25) | `SUNSET` | Sunset weather icon |


### Timeline

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/TIMELINE_MISSED_CALL.svg =25) | `TIMELINE_MISSED_CALL` | Generic missed call icon |
| ![](/images/guides/timeline/TIMELINE_CALENDAR.svg =25) | `TIMELINE_CALENDAR` | Generic calendar event icon |
| ![](/images/guides/timeline/TIMELINE_SPORTS.svg =25) | `TIMELINE_SPORTS` | Generic sports icon |


### Sports

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/TIMELINE_BASEBALL.svg =25) | `TIMELINE_BASEBALL` | Baseball sports icon |
| ![](/images/guides/timeline/AMERICAN_FOOTBALL.svg =25) | `AMERICAN_FOOTBALL` | American football sports icon |
| ![](/images/guides/timeline/BASKETBALL.svg =25) | `BASKETBALL` | Basketball sports icon |
| ![](/images/guides/timeline/CRICKET_GAME.svg =25) | `CRICKET_GAME` | Cricket sports icon |
| ![](/images/guides/timeline/SOCCER_GAME.svg =25) | `SOCCER_GAME` | Soccer sports icon |
| ![](/images/guides/timeline/HOCKEY_GAME.svg =25) | `HOCKEY_GAME` | Hockey sports icon |


### Action Results

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/RESULT_DISMISSED.svg =25) | `RESULT_DISMISSED` | Dismissed event |
| ![](/images/guides/timeline/RESULT_DELETED.svg =25) | `RESULT_DELETED` | Deleted event |
| ![](/images/guides/timeline/RESULT_MUTE.svg =25) | `RESULT_MUTE` | Mute event |
| ![](/images/guides/timeline/RESULT_SENT.svg =25) | `RESULT_SENT` | Generic message sent event |
| ![](/images/guides/timeline/RESULT_FAILED.svg =25) | `RESULT_FAILED` | Generic failure event |


### Events

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/STOCKS_EVENT.svg =25) | `STOCKS_EVENT` | Stocks icon |
| ![](/images/guides/timeline/MUSIC_EVENT.svg =25) | `MUSIC_EVENT` | Music event |
| ![](/images/guides/timeline/BIRTHDAY_EVENT.svg =25) | `BIRTHDAY_EVENT` | Birthday event |
| ![](/images/guides/timeline/NEWS_EVENT.svg =25) | `NEWS_EVENT` | Generic news story event |
| ![](/images/guides/timeline/SCHEDULED_EVENT.svg =25) | `SCHEDULED_EVENT` | Generic scheduled event |
| ![](/images/guides/timeline/MOVIE_EVENT.svg =25) | `MOVIE_EVENT` | Generic movie icon |
| ![](/images/guides/timeline/NO_EVENTS.svg =25) | `NO_EVENTS` | No events icon |


### Miscellaneous

| Preview | Name | Description |
|---------|------|-------------|
| ![](/images/guides/timeline/PAY_BILL.svg =25) | `PAY_BILL` | Pay bill event |
| ![](/images/guides/timeline/HOTEL_RESERVATION.svg =25) | `HOTEL_RESERVATION` | Hotel event |
| ![](/images/guides/timeline/TIDE_IS_HIGH.svg =25) | `TIDE_IS_HIGH` | High tide event |
| ![](/images/guides/timeline/INCOMING_PHONE_CALL.svg =25) | `INCOMING_PHONE_CALL` | Incoming phone call event |
| ![](/images/guides/timeline/DURING_PHONE_CALL.svg =25) | `DURING_PHONE_CALL` | Phone call event |
| ![](/images/guides/timeline/DURING_PHONE_CALL_CENTERED.svg =25) | `DURING_PHONE_CALL_CENTERED` | Phone call event centered |
| ![](/images/guides/timeline/DISMISSED_PHONE_CALL.svg =25) | `DISMISSED_PHONE_CALL` | Phone call dismissed event |
| ![](/images/guides/timeline/CHECK_INTERNET_CONNECTION.svg =25) | `CHECK_INTERNET_CONNECTION` | Check Internet connection event |
| ![](/images/guides/timeline/GLUCOSE_MONITOR.svg =25) | `GLUCOSE_MONITOR` | Sensor monitor event |
| ![](/images/guides/timeline/ALARM_CLOCK.svg =25) | `ALARM_CLOCK` | Alarm clock event |
| ![](/images/guides/timeline/CAR_RENTAL.svg =25) | `CAR_RENTAL` | Generic car rental event |
| ![](/images/guides/timeline/DINNER_RESERVATION.svg =25) | `DINNER_RESERVATION` | Dinner reservation event |
| ![](/images/guides/timeline/RADIO_SHOW.svg =25) | `RADIO_SHOW` | Radio show event |
| ![](/images/guides/timeline/AUDIO_CASSETTE.svg =25) | `AUDIO_CASSETTE` | Audio cassette icon |
| ![](/images/guides/timeline/SCHEDULED_FLIGHT.svg =25) | `SCHEDULED_FLIGHT` | Scheduled flight event |
| ![](/images/guides/timeline/REACHED_FITNESS_GOAL.svg =25) | `REACHED_FITNESS_GOAL` | Reached fitness goal event |
| ![](/images/guides/timeline/DAY_SEPARATOR.svg =25) | `DAY_SEPARATOR` | Day separator icon |
| ![](/images/guides/timeline/WATCH_DISCONNECTED.svg =25) | `WATCH_DISCONNECTED` | Watch disconnected event |
| ![](/images/guides/timeline/TV_SHOW.svg =25) | `TV_SHOW` | Generic TV show icon |
| ![](/images/guides/timeline/LOCATION.svg =25) | `LOCATION` | Generic location icon |
| ![](/images/guides/timeline/SETTINGS.svg =25) | `SETTINGS` | Generic settings icon |


### Custom Icons

Custom icons were introduced in SDK 4.0. They allow you to use custom images for
timeline pins, by utilizing the
{% guide_link tools-and-resources/app-metadata#published-media "Published Media" %}
`name`. E.g. `app://images/*name*`


## Pin Layouts

Developers can customize how pins, reminders and notifications are shown to the
user using different layouts. The Pebble SDK includes layouts appropriate for a
broad set of apps. Each layout has different customization options, called the
layout attributes. Most layouts also offer the option of showing an icon, which
must be one of the standard system provided icons, listed under
[*Pin Icons*](#pin-icons) above.

The sub-sections below detail the available layouts and the fields they will
display. Required attributes are shown in **bold**.


### Generic Layout

Generic layout for generic pins of no particular type.

**Timeline view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/generic-pin.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Detail view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/generic-layout.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Standard Attributes**

**`title`**, **`tinyIcon`**, `subtitle`, `body`.

**Color Elements**

| Layout Property | Applies To |
|-----------------|------------|
| `primaryColor` | Time, body |
| `secondaryColor` | Title |
| `backgroundColor` | Background |

**Example JSON**

```json
{
  "id": "pin-generic-1",
  "time": "2015-09-22T16:30:00Z",
  "layout": {
    "type": "genericPin",
    "title": "This is a genericPin!",
    "tinyIcon": "system://images/NOTIFICATION_FLAG",
    "primaryColor": "#FFFFFF",
    "secondaryColor": "#666666",
    "backgroundColor": "#5556FF"
  }
}
```


### Calendar Layout

Standard layout for pins displaying calendar events.

**Timeline view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/calendar-pin.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Detail view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/calendar-layout.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Standard Attributes**

**`title`**, `body`.

**Special Attributes**

| Field | Type | Function |
|-------|------|----------|
| `locationName` | String | Name of the location of this pin event. Used if `shortSubtitle` is not present on the list view, and always in the detail view. |

**Color Elements**

| Layout Property | Applies To |
|-----------------|------------|
| `primaryColor` | Times, body |
| `secondaryColor` | Title |
| `backgroundColor` | Background |

**Example JSON**

```json
{
  "id": "pin-calendar-1",
  "time": "2015-03-18T15:45:00Z",
  "duration": 60,
  "layout": {
    "type": "calendarPin",
    "title": "Pin Layout Meeting",
    "locationName": "Conf Room 1",
    "body": "Discuss layout types with Design Team."
  }
}
```


### Sports Layout

Generic layout for displaying sports game pins including team ranks, scores
and records.

**Timeline view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/sport-pin.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Detail view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/sport-layout.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Standard Attributes**

**`title`** (name of the game), `subtitle` (friendly name of the period), `body`
(game description), **`tinyIcon`**, `largeIcon`, `lastUpdated`.

**Special Attributes**

> Note: The `rankAway` and `rankHome` fields will be shown before the event
> begins, otherwise `scoreAway` and `scoreHome` will be shown.

| Field | Type | Function |
|-------|------|----------|
| `rankAway` | String (~2 characters) | The rank of the away team. |
| `rankHome` | String (~2 characters) | The rank of the home team. |
| `nameAway` | String (Max 4 characters) | Short name of the away team. |
| `nameHome` | String (Max 4 characters) | Short name of the home team. |
| `recordAway` | String (~5 characters) | Record of the away team (wins-losses). |
| `recordHome` | String (~5 characters) | Record of the home team (wins-losses). |
| `scoreAway` | String (~2  characters) | Score of the away team. |
| `scoreHome` | String (~2 characters) | Score of the home team. |
| `sportsGameState` | String | `in-game` for in game or post game, `pre-game` for pre game. |

**Color Elements**

| Layout Property | Applies To |
|-----------------|------------|
| `primaryColor` | Text body |
| `secondaryColor` | Team names and scores |
| `backgroundColor` | Background |

**Example JSON**

```json
{
  "id": "pin-sports-1",
  "time": "2015-03-18T19:00:00Z",
  "layout": {
    "type": "sportsPin",
    "title": "Bulls at Bears",
    "subtitle": "Halftime",
    "body": "Game of the Century",
    "tinyIcon": "system://images/AMERICAN_FOOTBALL",
    "largeIcon": "system://images/AMERICAN_FOOTBALL",
    "lastUpdated": "2015-03-18T18:45:00Z",
    "rankAway": "03",
    "rankHome": "08",
    "nameAway": "POR",
    "nameHome": "LAC",
    "recordAway": "39-19",
    "recordHome": "39-21",
    "scoreAway": "54",
    "scoreHome": "49",
    "sportsGameState": "in-game"
  }
}
```


### Weather Layout

Standard layout for pins displaying the weather.

**Timeline view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/weather-pin.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Detail view**

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/weather-layout.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Standard Attributes**

**`title`** (part of the day), **`tinyIcon`**, `largeIcon`, `body`
(shortcast), `lastUpdated`.

**Special Attributes**

| Field | Type | Function |
|-------|------|----------|
| `shortTitle` | String | Used instead of `title` in the main timeline view unless it is not specified. |
| `subtitle` | String | Show high/low temperatures. Note: currently only numbers and the degree symbol (°) are supported. |
| `shortSubtitle` | String | Used instead of `subtitle` in the main timeline view unless it is not specified. |
| **`locationName`** | String | Name of the location of this pin event. |
| `displayTime` | String | Use a value of 'pin' to display the pin's time in title of the detail view and description, or 'none' to not show the time. Defaults to 'pin' if not specified. |

**Color Elements**

| Layout Property | Applies To |
|-----------------|------------|
| `primaryColor` | All text |
| `backgroundColor` | Background |

**Example JSON**

```json
{
  "id": "pin-weather-1",
  "time": "2015-03-18T19:00:00Z",
  "layout": {
    "type": "weatherPin",
    "title": "Nice day",
    "subtitle": "40/65",
    "tinyIcon": "system://images/TIMELINE_SUN",
    "largeIcon": "system://images/TIMELINE_SUN",
    "locationName": "Palo Alto",
    "body": "Sunny with a chance of rain.",
    "lastUpdated": "2015-03-18T18:00:00Z"
  }
}
```


### Generic Reminder

Generic layout for pin reminders, which can be set at various times before an
event is due to occur to remind the user ahead of time.

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/generic-reminder.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Standard Attributes**

**`title`**, **`tinyIcon`**.

**Special Attributes**

| Field | Type | Function |
|-------|------|----------|
| `locationName` | String | Name of the location of this pin event. |

**Example JSON**

```json
{
  "id": "pin-generic-reminder-1",
  "time": "2015-03-18T23:00:00Z",
  "layout": {
    "type": "genericPin",
    "title": "This is a genericPin!",
    "subtitle": "With a reminder!.",
    "tinyIcon": "system://images/NOTIFICATION_FLAG"
  },
  "reminders": [
    {
      "time": "2015-03-18T22:55:00Z",
      "layout": {
        "type": "genericReminder",
        "title": "Reminder!",
        "locationName": "Conf Rm 1",
        "tinyIcon": "system://images/ALARM_CLOCK"
      }
    }
  ]
}
```


### Generic Notification

Generic notification layout which can be used with `createNotification` and
`updateNotification` to alert the user to a new pin being created on their
timeline.

{% screenshot_viewer %}
{
  "image": "/images/guides/timeline/generic-notification-layout.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

**Standard Attributes**

**`title`**, **`tinyIcon`**, `body`.

**Color Elements**

| Layout Property | Applies To |
|-----------------|------------|
| `primaryColor` | Title |
| `backgroundColor` | Banner background |

**Example JSON**

```json
{
  "id": "pin-generic-createmessage-1",
  "time": "2015-04-30T23:45:00Z",
  "layout": {
    "type": "genericPin",
    "title": "This is a genericPin!",
    "subtitle": "With a notification",
    "tinyIcon": "system://images/NOTIFICATION_FLAG"
  },
  "createNotification": {
    "layout": {
      "type": "genericNotification",
      "title": "Notification!",
      "tinyIcon": "system://images/NOTIFICATION_FLAG",
      "body": "A new genericPin has appeared!"
    }
  }
}

```


## Pin Actions

Pins can be further customized by adding actions to them. This allows bi-
directional interactivity for pin-based apps. These apps can have multiple
actions associated with them, allowing different launch behavior depending on
how the user interacts with the pin.

The table below shows the available actions that can be added to a pin. Required
attributes are shown in **bold**.

| Action `type` | Description | Attributes |
|---------------|-------------|------------|
| `openWatchApp` | Launch the watchapp associated with this pin. The `launchCode` field of this action object will be passed to the watchapp and can be obtained with ``launch_get_args()``. | **`title`**, **`launchCode`**. |
| `http` | Execute an HTTP request that invokes this action on the remote service. | See [*HTTP Actions*](#http-actions) for full attribute details. |


### Using a Launch Code

Launch codes can be used to pass a single integer value from a specific timeline
pin to the app associated with it when it is lauched from that pin. This
mechanism allows the context to be given to the app to allow it to change
behavior based on the action chosen.

For example, a pin could have two actions associated with an app for making
restaurant table reservations that allowed the user to cancel the reservation or
review the restaurant. To set up these actions, add them to the pin when it is
pushed to the timeline API.

```
"actions": [
  {
    "title": "Cancel Table",
    "type": "openWatchApp",
    "launchCode": 15
  },
  {
    "title": "Leave Rating",
    "type": "openWatchApp",
    "launchCode": 22
  }
]
```


### Reading the Launch Code

When the user sees the pin and opens the action menu, they can select one of
these actions which will launch the watchapp (as dictated by the `openWatchApp`
pin action `type`). When the app launches, use ``launch_get_args()`` to read the
value of the `launchCode` associated with the chosen action, and react
accordingly. An example is shown below;

```c
if(launch_reason() == APP_LAUNCH_TIMELINE_ACTION) {
  uint32_t arg = launch_get_args();

  switch(arg) {
  case LAUNCH_ARG_CANCEL:
    // Cancel table UI...

    break;
  case LAUNCH_ARG_REVIEW:
    // Leave a review UI...

    break;
  }
}
```


### HTTP Actions

With the `http` pin action `type`, pins can include actions that carry out an
arbitrary HTTP request. This makes it possible for a web service to be used
purely by pushed pins with actions that respond to those events.

The table below details the attributes of this type of pin action object. Items
shown in **bold** are required.

| Attribute | Type | Default | Description |
|-----------|------|---------|-------------|
| **`title`** | String | *mandatory* | The title of the action. |
| **`url`** | String | *mandatory* | The URL of the remote service to send the request to. |
| `method` | String | `POST` | The request method, such as `GET`, `POST`, `PUT` or `DELETE`. |
| `headers` | Object | `{}` | Dictionary of key-value pairs of headers (`Content-Type` is implied by using `bodyJSON`) as required by the remote service. |
| `bodyText` | String | `''` | The data body of the request in String format. |
| `bodyJSON` | Object | *unspecified* | The data body of the request in JSON object format. |
| `successText` | String | "Done!" | The string to display if the action is successful. |
| `successIcon` | Pin Icon URL | `system://images/GENERIC_CONFIRMATION` | The icon to display if the action is successful. |
| `failureText` | String | "Failed!" | The string to display if the action is unsuccessful. |
| `failureIcon` | Pin Icon URL | `system://images/RESULT_FAILED` | The icon to display if the action is unsuccessful. |

> Note: `bodyText` and `bodyJSON` are mutually exclusive fields (they cannot be
> used together in the same request). You should choose that which is most
> convenient for your implementation.

> Note: Do not include a body with HTTP methods that do not support one. This
> means that `bodyText` and `bodyJSON` cannot be used with `GET` or `DELETE`
> requests.

The following is an example action, using the `http` action `type` to confirm
attendance at a meeting managed by a fictitious meeting scheduling service.

```js
"actions": [
  {
    "type": "http",
    "title": "Confirm Meeting",
    "url": "http://some-meeting-service.com/api/v1/meetings/46146717",
    "method": "PUT",
    "headers": {
      "X-Request-Source": "pebble-timeline",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    "bodyText": "type=confirm&value=1",
    "successIcon": "system://images/GENERIC_CONFIRMATION",
    "successText": "Confirmed!"
  }
]
```

Alternatively, pins can use the `bodyJSON` field to encode a JSON object.
Include this data using the `bodyJSON` field.

```js
"actions": [
  {
    "type": "http",
    "title": "Confirm Meeting",
    "url": "http://some-meeting-service.com/api/v1/meetings/46146717",
    "method": "PUT",
    "headers": {
      "X-Request-Source": "pebble-timeline"
    },
    "bodyJSON": {
      "type": "confirm",
      "value": true
    },
    "successIcon": "system://images/GENERIC_CONFIRMATION",
    "successText": "Confirmed!"
  }
]
```


### Included Headers

When using the `http` action, the request will also include the following
additional headers. Developers can use these to personalize the timeline
experience to each individual user.

| Header Key | Value |
|------------|-------|
| `X-Pebble-Account-Token` | Same as [`Pebble.getAccountToken()`](/guides/communication/using-pebblekit-js) |
| `X-Pebble-Watch-Token` | Same as [`Pebble.getWatchToken()`](/guides/communication/using-pebblekit-js) |


## Testing Pins

It is also possible to push new timeline pins using the `pebble`
{% guide_link tools-and-resources/pebble-tool %}. Prepare your pin in a JSON
file, such as `example-pin.json` shown below:

```json
{
  "id": "pin-generic-1",
  "time": "2015-03-18T15:45:00Z",
  "layout": {
    "type": "genericPin",
    "title": "This is a genericPin!",
    "tinyIcon": "system://images/NOTIFICATION_FLAG"
  }
}
```

Push this pin to your emulator to preview how it will appear for users.

```nc|bash
$ pebble insert-pin example-pin.json
```

The pin will appear as shown below:

![pin-preview >{pebble-screenshot,pebble-screenshot--time-red}](/images/guides/timeline/generic-pin~basalt.png)

It is possible to delete the pin in a similar manner, making sure the `id` is
the same as the pin to be removed:

```nc|bash
$ pebble delete-pin --id pin-generic-1
```

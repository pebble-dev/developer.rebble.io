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

title: AppGlance REST API
description: |
  How to update an app's app glance using the REST API.
guide_group: user-interfaces
order: 2
related_docs:
  - AppGlanceSlice
related_examples:
  - title: Node.js Example
    url: https://github.com/pebble-examples/app-glance-rest-example
---

<div class="alert alert--fg-white alert--bg-purple">
  {% markdown %}
  **Important Note**

  This API requires the forthcoming v4.1 of the Pebble mobile application in
  order to display App Glances on the connected watch.
  {% endmarkdown %}
</div>

## Overview

This guide explains how to use the AppGlance REST API. The ``App Glance`` API
was added in SDK 4.0 and enables developers to programmatically set the icon and
subtitle that appears alongside their app in the launcher.

If you want to learn more about ``App Glance``, please read the
{% guide_link user-interfaces/appglance-c %} guide.


## The REST API

The AppGlance REST API shares many similarities with the existing
{% guide_link pebble-timeline/timeline-public "timeline API" %}.
Developers can push slices to the their app's glance using their own backend
servers. Slices are created using HTTPS requests to the Pebble AppGlance REST
API.


#### Creating Slices

To create a slice, send a `PUT` request to the following URL scheme:

```text
PUT https://timeline-api.rebble.io/v1/user/glance
```

Use the following headers, where `X-User-Token` is the user's
timeline token (read
{% guide_link pebble-timeline/timeline-js#get-a-timeline-token "Get a Timeline Token" %}
to learn how to get a token):

```text
Content-Type: application/json
X-User-Token: a70b23d3820e9ee640aeb590fdf03a56
```

Include the JSON object as the request body from a file such as `glance.json`. A
sample of an object is shown below:

```json
{
  "slices": [
    {
      "layout": {
        "icon": "system://images/GENERIC_CONFIRMATION",
        "subtitleTemplateString": "Success!"
      }
    }
  ]
}
```

#### Curl Example

```bash
$ curl -X PUT https://timeline-api.rebble.io/v1/user/glance \
    --header "Content-Type: application/json" \
    --header "X-User-Token: a70b23d3820e9ee640aeb590fdf03a56" \
    -d @glance.json
OK
```

#### Slice Icons

There are two types of resources which can be used for AppGlance icons.

* You can use system images. E.g. `system://images/HOTEL_RESERVATION`
* You can use custom images by utilizing the
{% guide_link tools-and-resources/app-metadata#published-media "Published Media" %}
`name`. E.g. `app://images/*name*`


#### Subtitle Template Strings

The `subtitle_template_string` field provides developers with a string
formatting language for app glance subtitles. Read more in the
{% guide_link user-interfaces/appglance-c#subtitle-template-strings "AppGlance C guide" %}.


#### Expiring Slices

When you want your slice to expire automatically, just provide an
`expirationTime` in
[ISO date-time](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString)
format and the system will automatically remove it upon expiry.

```json
{
  "slices": [
    {
      "layout": {
        "icon": "system://images/GENERIC_CONFIRMATION",
        "subtitleTemplateString": "Success!"
      },
      "expirationTime": "2016-12-31T23:59:59.000Z"
    }
  ]
}
```


#### Creating Multiple Slices

Because `slices` is an array, you can send multiple slices within a single
request. The system is responsible for displaying the correct entries based on
the `expirationTime` provided in each slice.

```json
{
  "slices": [
    {
      "layout": {
        "icon": "system://images/DINNER_RESERVATION",
        "subtitleTemplateString": "Lunchtime!"
      },
      "expirationTime": "2017-01-01T12:00:00.000Z"
    },
    {
      "layout": {
        "icon": "system://images/RESULT_MUTE",
        "subtitleTemplateString": "Nap Time!"
      },
      "expirationTime": "2017-01-01T14:00:00.000Z"
    }
  ]
}
```


#### Updating Slices

There isn't a concept of updating an AppGlance slice, just send a request to
the REST API with new slices and any existing slices will be replaced.


#### Deleting Slices

All you need to do is send an empty slices array to the REST API and any
existing slices will be removed.

```json
{
  "slices": []
}
```

### Additional Notes

We will not display App Glance slices for SDK 3.0 applications under any
circumstances. Your watchapp needs to be compiled with SDK 4.0 in order to
support App Glances.


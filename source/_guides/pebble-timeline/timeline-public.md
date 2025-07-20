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

title: Public Web API
description: |
  How to push Pebble timeline data to an app's users using the public web API.
guide_group: pebble-timeline
order: 3
related_examples:
 - title: Hello Timeline
   url: https://github.com/pebble-examples/hello-timeline
 - title: Timeline TV Tracker
   url: https://github.com/pebble-examples/timeline-tv-tracker
 - title: Timeline Push Pin
   url: https://github.com/pebble-examples/timeline-push-pin
---

While users can register subscriptions and receive data from the timeline using
the PebbleKit JS subscriptions API 
(detailed in {% guide_link pebble-timeline/timeline-js %}), app developers can
use the public timeline web API to provide that data by pushing pins. Developers
will need to create a simple web server to enable them to process and send the
data they want to display in the timeline. Each pin represents a specific event
in the past or the future, and will be shown on the watch once pushed to the
public timeline web API and automatically synchronized with the watch via the
Pebble mobile applications.

The Pebble SDK emulator supports the timeline and automatically synchronizes
every 30 seconds.


## Pushing Pins

Developers can push data to the timeline using their own backend servers. Pins
are created and updated using HTTPS requests to the Pebble timeline web API.

> Pins pushed to the Pebble timeline web API may take **up to** 15 minutes to
> appear on a user's watch. Although most pins can arrive faster than this, we
> recommend developers do not design apps that rely on near-realtime updating of
> pins.


### Create a Pin

To create a pin, send a `PUT` request to the following URL scheme, where `ID` is
the `id` of the pin object. For example 'reservation-1395203':

```text
PUT https://timeline-api.getpebble.com/v1/user/pins/ID
```

Use the following headers, where `X-User-Token` is the user's
timeline token (read 
{% guide_link pebble-timeline/timeline-js#get-a-timeline-token "Get a Timeline Token" %} 
to learn how to get a token):

```text
Content-Type: application/json
X-User-Token: a70b23d3820e9ee640aeb590fdf03a56
```

Include the JSON object as the request body from a file such as `pin.json`. A
sample of an object is shown below:

```json
{
  "id": "reservation-1395203",
  "time": "2014-03-07T08:01:10.229Z",
  "layout": {
    "shortTitle": "Dinner at La Fondue",
    ...
  },
  ...
}
```


#### Curl Example

```bash
$ curl -X PUT https://timeline-api.getpebble.com/v1/user/pins/reservation-1395203 \
    --header "Content-Type: application/json" \
    --header "X-User-Token: a70b23d3820e9ee640aeb590fdf03a56" \
    -d @pin.json
OK
```


### Update a Pin

To update a pin, send a `PUT` request with a new JSON object with the **same
`id`**.

```text
PUT https://timeline-api.getpebble.com/v1/user/pins/reservation-1395203

```

Remember to include the user token in the headers.

```text
X-User-Token: a70b23d3820e9ee640aeb590fdf03a56
```

When an update to an existing pin is issued, it replaces the original
pin entirely, so all fields (including those that have not changed) should be
included. The example below shows an event updated with a new `time`:

```json
{
    "id": "reservation-1395203",
    "time": "2014-03-07T09:01:10.229Z",
    "layout": {
      "shortTitle": "Dinner at La Fondue",
      ...
    },
    ...
}
```


#### Curl Example

```bash
$ curl -X PUT https://timeline-api.getpebble.com/v1/user/pins/reservation-1395203 \
    --header "Content-Type: application/json" \
    --header "X-User-Token: a70b23d3820e9ee640aeb590fdf03a56" \
    -d @pin.json
OK
```


### Delete a Pin

Delete a pin by issuing a HTTP `DELETE` request.

```text
DELETE https://timeline-api.getpebble.com/v1/user/pins/reservation-1395203
```

Remember to include the user token in the headers.

```text
X-User-Token: a70b23d3820e9ee640aeb590fdf03a56
```

This pin will then be removed from that timeline on the user's watch.
In some cases it may be preferred to simply update a pin with a cancelled
event's details so that it can remain visible and useful to the user.


#### Curl Example

```bash
$ curl -X DELETE https://timeline-api.getpebble.com/v1/user/pins/reservation-1395203 \
    --header "Content-Type: application/json" \
    --header "X-User-Token: a70b23d3820e9ee640aeb590fdf03a56"
OK
```


## Shared Pins

### Create a Shared Pin

It is possible to send a pin (and updates) to multiple users at once by
modifying the `PUT` header to include `X-Pin-Topics` (the topics a user must be
subscribed to in order to receive this pin) and `X-API-Key` (issued by the
[Developer Portal]({{ site.links.devportal }})). In this case, the URL is
also modified:

```text
PUT /v1/shared/pins/giants-game-1
```

The new headers:

```text
Content-Type: application/json
X-API-Key: fbbd2e4c5a8e1dbef2b00b97bf83bdc9
X-Pin-Topics: giants,redsox,baseball
```

The pin body remains the same:

```json
{
    "id": "giants-game-1",
    "time": "2014-03-07T10:01:10.229Z",
    "layout": {
      "title": "Giants vs Red Sox: 5-3",
      ...
    },
    ...
}
```


#### Curl Example

```bash
$ curl -X PUT https://timeline-api.getpebble.com/v1/shared/pins/giants-game-1 \
    --header "Content-Type: application/json" \
    --header "X-API-Key: fbbd2e4c5a8e1dbef2b00b97bf83bdc9" \
    --header "X-Pin-Topics: giants,redsox,baseball" \
    -d @pin.json
OK
```


### Delete a Shared Pin

Similar to deleting a user pin, shared pins can be deleted by issuing a `DELETE`
request:

```text
DELETE /v1/shared/pins/giants-game-1
```

As with creating a shared pin, the API key must also be provided in the request
headers:

```text
X-API-Key: fbbd2e4c5a8e1dbef2b00b97bf83bdc9
```


#### Curl Example

```bash
$ curl -X DELETE https://timeline-api.getpebble.com/v1/shared/pins/giants-game-1 \
    --header "Content-Type: application/json" \
    --header "X-API-Key: fbbd2e4c5a8e1dbef2b00b97bf83bdc9" \
OK
```


## Listing Topic Subscriptions

Developers can also query the public web API for a given user's currently
subscribed pin topics with a `GET` request:

```text
GET /v1/user/subscriptions
```

This requires the user's timeline token:

```text
X-User-Token: a70b23d3820e9ee640aeb590fdf03a56
```


#### Curl Example

```bash
$ curl -X GET https://timeline-api.getpebble.com/v1/user/subscriptions \
    --header "X-User-Token: a70b23d3820e9ee640aeb590fdf03a56" \
```

The response will be a JSON object containing an array of topics the user is
currently subscribed to for that app:

```json
{
  "topics": [
    "topic1",
    "topic2"
  ]
}
```


## Pin Time Limitations

The `time` property on a pin pushed to the public API must not be more than two
days in the past, or a year in the future. The same condition applies to the
`time` associated with a pin's reminders and notifications.

Any pins that fall outside these conditions may be rejected by the web API. In
addition, the actual range of events shown on the watch may be different under
some conditions.

For shared pins, the date and time of an event will vary depending on the user's
timezone.


## Error Handling

In the event of an error pushing a pin, the public timeline API will return one
of the following responses.

| HTTP Status | Response Body | Description |
|-------------|---------------|-------------|
| 200 | None | Success. |
| 400 | `{ "errorCode": "INVALID_JSON" }` | The pin object submitted was invalid. |
| 403 | `{ "errorCode": "INVALID_API_KEY" }` | The API key submitted was invalid. |
| 410 | `{ "errorCode": "INVALID_USER_TOKEN" }` | The user token has been invalidated, or does not exist. All further updates with this user token will fail. You should not send further updates for this user token. A user token can become invalidated when a user uninstalls an app for example. |
| 429 | `{ "errorCode": "RATE_LIMIT_EXCEEDED" }` | Server is sending updates too quickly, and has been rate limited (see [*Rate Limiting*](#rate-limiting) below). |
| 503 | `{ "errorCode": "SERVICE_UNAVAILABLE" }` | Could not save pin due to a temporary server error. |


## Rate Limiting

For requests using API Keys, developers can make up to 5000 requests per minute.
For requests using User Tokens, up to 300 requests every 15 minutes can be made.
Check the returned HTTP headers of any API request to see the current rate limit
status:

```text
$ curl -i https://timeline-api.getpebble.com/v1/user/pins/reservation-1395203

HTTP/1.1 429 OK
date: Wed, 13 May 2015 21:36:58 GMT
x-ratelimit-percent: 100
retry-after: 43
```

The headers contain information about the current rate limit status:

| Header Name | Description |
|-------------|-------------|
| `x-ratelimit-percent` | The percentage of the rate limit currently utilized. |
| `retry-after` | When `x-ratelimit-percent` has reached `100`, this header will be set to the number of seconds after which the rate limit will reset. |

When the rate limit is exceeded, the response body also reports the error:

```text
{ "errorCode":"RATE_LIMIT_EXCEEDED" }
```

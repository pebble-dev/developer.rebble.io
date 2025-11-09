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

title: Managing Subscriptions
description: |
  How to integrate the timeline into apps with the PebbleKit JS subscriptions
  API according to user preferences.
guide_group: pebble-timeline
order: 2
related_examples:
 - title: Timeline Push Pin
   url: https://github.com/pebble-examples/timeline-push-pin
 - title: Hello Timeline
   url: https://github.com/pebble-examples/hello-timeline
 - title: Timeline TV Tracker
   url: https://github.com/pebble-examples/timeline-tv-tracker
---

The following PebbleKit JS APIs allow developers to intereact with the timeline
API, such as adding and removing the user's subscribed topics. By combining
these with user preferences from a configuration page (detailed in 
{% guide_link user-interfaces/app-configuration %}) it is possible to allow
users to choose which pin sources they receive updates and events from.

> The timeline APIs to subscribe users to topics and retrieve user tokens are
> only available in PebbleKit JS.
>
> If you wish to use the timeline APIs with a Pebble app that uses PebbleKit iOS
> or Android please [contact us](/contact) to discuss your specific use-case.


## Requirements

These APIs require some knowledge of your app before they can work. For example,
in order to return the user's timeline token, the web API must know your app's
UUID. This also ensures that only users who have your app installed will receive
the correct pins.

If you have not performed this process for your app and attempt to use these
APIs, you will receive an error similar to the following message:

```text
[INFO    ] No token available for this app and user.
```

### Shared Pins

For best compatibility with applications, when using shared pins, it is
recommended to define the following in your PebbleKit JS code:

```js
var getTimelineSubscribeToTopicURL = function(topic) {
    var encodedTopic = encodeURIComponent(topic);
    return "https://timeline-api.rebble.io/v1/user/subscriptions/" + encodedTopic;
};

var getTimelineSubscriptionsListURL = function() {
    return "https://timeline-api.rebble.io/v1/user/subscriptions";
};
```


## Get a Timeline Token

The timeline token is unique for each user/app combination. This can be used by
an app's third party backend server to selectively send pins only to those users
who require them, or even to target users individually for complete
personalization.

```js
Pebble.getTimelineToken(function(token) {
  console.log('My timeline token is ' + token);
}, function(error) {
  console.log('Error getting timeline token: ' + error);
});
```

## Subscribe to a Topic

A user can also subscribe to a specific topic in each app. Every user that
subscribes to this topic will receive the pins pushed to it. This can be used to
let the user choose which features of your app they wish to subscribe to. For
example, they may want 'world news' stories but not 'technology' stories. In
this case they would be subscribed only to the topic that includes pins with
'world news' information.

```js
Pebble.timelineSubscribe('world-news', function() {
  console.log('Subscribed to world-news');
}, function(err) {
  console.log('Error subscribing to topic: ' + err);
});
```

## Unsubscribe from a Topic

The user may unsubscribe from a topic they previously subscribed to. They will
no longer receive pins from this topic.

```js
Pebble.timelineUnsubscribe('world-news', function() {
  console.log('Unsubscribed from world-news');
}, function(err) {
  console.log('Error unsubscribing from topic: ' + err);
});
```

## List Current Subscriptions

You can use the function below to list all the topics a user has subscribed to.

```js
Pebble.timelineSubscriptions(function(topics) {
  // List all the subscribed topics
  console.log('Subscribed to ' + topics.join(', '));
}, function(errorString) {
  console.log('Error getting subscriptions: ' + errorString);
});
```

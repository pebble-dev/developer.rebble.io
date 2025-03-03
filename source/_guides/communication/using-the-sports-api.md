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

title: Sports API
description: |
  How to use the PebbleKit Sports API to integrate your mobile sports
  app with Pebble.
guide_group: communication
order: 6
related_examples:
  - title: PebbleKit Sports API Demos
  - url: https://github.com/pebble-examples/pebblekit-sports-api-demo
---

Every Pebble watch has two built-in system watchapps called the Sports app, and
the Golf app. These apps are hidden from the launcher until launched via
PebbleKit Android or PebbleKit iOS.

Both are designed to be generic apps that display sports-related data in common
formats. The goal is to allow fitness and golf mobile apps to integrate with
Pebble to show the wearer data about their activity without needing to create
and maintain an additional app for Pebble. An example of a popular app that uses
this approach is the 
[Runkeeper](http://apps.rebble.io/en_US/application/52e05bd5d8561de307000039) 
app.

The Sports and Golf apps are launched, closed, and controlled by PebbleKit in an
Android or iOS app, shown by example in each section below. In both cases, the
data fields that are available to be populated are different, but data is pushed
in the same way.


## Available Data Fields

### Sports

{% screenshot_viewer %}
{
  "image": "/images/guides/design-and-interaction/sports.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

The sports app displays activity duration and distance which can apply to a wide
range of sports, such as cycling or running. A configurable third field is also
available that displays pace or speed, depending on the app's preference. The
Sports API also allows the app to be configured to display the labels of each
field in metric (the default) or imperial units.

The action bar is used to prompt the user to use the Select button to pause and
resume their activity session. The companion app is responsible for listening
for these events and implementing the pause/resume operation as appropriate.


### Golf

{% screenshot_viewer %}
{
  "image": "/images/guides/design-and-interaction/golf.png",
  "platforms": [
    {"hw": "aplite", "wrapper": "steel-black"},
    {"hw": "basalt", "wrapper": "time-red"},
    {"hw": "chalk", "wrapper": "time-round-rosegold-14"}
  ]
}
{% endscreenshot_viewer %}

The Golf app is specialized to displaying data relevant to golf games, including
par and hole numbers, as well as front, mid, and rear yardage.

Similar to the Sports app, the action bar is used to allow appropriate feedback
to the companion app. In this case the actions are an 'up', 'ball' and 'down'
events which the companion should handle as appropriate.


## With PebbleKit Android

Once an Android app has set up 
{% guide_link communication/using-pebblekit-android %}, the Sports and Golf apps
can be launched and customized as appropriate.


### Launching Sports and Golf

To launch one of the Sports API apps, simply call `startAppOnPebble()` and
supply the UUID from the `Constants` class:

```java
// Launch the Sports app
PebbleKit.startAppOnPebble(getApplicationContext(), Constants.SPORTS_UUID);
```


### Customizing Sports

To choose which unit type is used, construct and send a `PebbleDictionary`
containing the desired value from the `Constants` class. Either
`SPORTS_UNITS_IMPERIAL` or `SPORTS_UNITS_METRIC` can be used:

```java
PebbleDictionary dict = new PebbleDictionary();

// Display imperial units
dict.addUint8(Constants.SPORTS_UNITS_KEY, Constants.SPORTS_UNITS_IMPERIAL);

PebbleKit.sendDataToPebble(getApplicationContext(), Constants.SPORTS_UUID, dict);
```

To select between 'pace' or 'speed' as the label for the third field, construct
and send a `PebbleDictionary` similar to the example above. This can be done in
the same message as unit selection:

```java
PebbleDictionary dict = new PebbleDictionary();

// Display speed instead of pace
dict.addUint8(Constants.SPORTS_LABEL_KEY, Constants.SPORTS_DATA_SPEED);

PebbleKit.sendDataToPebble(getApplicationContext(), Constants.SPORTS_UUID, dict);
```

> Note: The Golf app does not feature any customizable fields.


### Displaying Data

Data about the current activity can be sent to either of the Sports API apps
using a `PebbleDictionary`. For example, to show a value for duration and
distance in the Sports app:

```java
PebbleDictionary dict = new PebbleDictionary();

// Show a value for duration and distance
dict.addString(Constants.SPORTS_TIME_KEY, "12:52");
dict.addString(Constants.SPORTS_DISTANCE_KEY, "23.8");

PebbleKit.sendDataToPebble(getApplicationContext(), Constants.SPORTS_UUID, dict);
```

Read the [`Constants`](/docs/pebblekit-android/com/getpebble/android/kit/Constants)
documentation to learn about all the available parameters that can be used for
customization.


### Handling Button Events

When a button event is generated from one of the Sports API apps, a message is
sent to the Android companion app, which can be processed using a
`PebbleDataReceiver`. For example, to listen for a change in the state of the
Sports app, search for `Constants.SPORTS_STATE_KEY` in the received
`PebbleDictionary`. The user is notified in the example below through the use of
an Android
[`Toast`](http://developer.android.com/guide/topics/ui/notifiers/toasts.html):

```java
// Create a receiver for when the Sports app state changes
PebbleDataReceiver reciever = new PebbleKit.PebbleDataReceiver(
                                                        Constants.SPORTS_UUID) {

  @Override
  public void receiveData(Context context, int id, PebbleDictionary data) {
    // Always ACKnowledge the last message to prevent timeouts
    PebbleKit.sendAckToPebble(getApplicationContext(), id);

    // Get action and display as Toast
    Long value = data.getUnsignedIntegerAsLong(Constants.SPORTS_STATE_KEY);
    if(value != null) {
      int state = value.intValue();
      String text = (state == Constants.SPORTS_STATE_PAUSED)
                                                      ? "Resumed!" : "Paused!";
      Toast.makeText(getApplicationContext(), text, Toast.LENGTH_SHORT).show();
    }
  }

};

// Register the receiver
PebbleKit.registerReceivedDataHandler(getApplicationContext(), receiver);
```


## With PebbleKit iOS

Once an iOS app has set up {% guide_link communication/using-pebblekit-ios %},
the Sports and Golf apps can be launched and customized as appropriate. The
companion app should set itself as a delegate of `PBPebbleCentralDelegate`, and
assign a `PBWatch` property once `watchDidConnect:` has fired. This `PBWatch`
object will then be used to manipulate the Sports API apps. 

Read *Becoming a Delegate* in the 
{% guide_link communication/using-pebblekit-ios %} guide to see how this is
done.


### Launching Sports and Golf

To launch one of the Sports API apps, simply call `sportsAppLaunch:` or
`golfAppLaunch:` as appropriate:

```objective-c
[self.watch sportsAppLaunch:^(PBWatch * _Nonnull watch,
                                                  NSError * _Nullable error) {
  NSLog(@"Sports app was launched");
}];
```


### Customizing Sports

To choose which unit type is used, call `sportsAppSetMetric:` with the desired
`isMetric` `BOOL`:

```objective-c
BOOL isMetric = YES;

[self.watch sportsAppSetMetric:isMetric onSent:^(PBWatch * _Nonnull watch,
                                                 NSError * _Nonnull error) {
  if (!error) {
    NSLog(@"Successfully sent message.");
  } else {
    NSLog(@"Error sending message: %@", error);
  }
}];
```

To select between 'pace' or 'speed' as the label for the third field, call
`sportsAppSetLabel:` with the desired `isPace` `BOOL`:

```objective-c
BOOL isPace = YES;

[self.watch sportsAppSetLabel:isPace onSent:^(PBWatch * _Nonnull watch,
                                              NSError * _Nullable error) {
  if (!error) {
    NSLog(@"Successfully sent message.");
  } else {
    NSLog(@"Error sending message: %@", error);
  }
}];
```

> Note: The Golf app does not feature any customizable fields.


### Displaying Data

Data about the current activity can be sent to either the Sports or Golf app
using `sportsAppUpdate:` or `golfAppUpdate:`. For example, to show a value for
duration and distance in the Sports app:

```objective-c
// Construct a dictionary of data
NSDictionary *update = @{ PBSportsTimeKey: @"12:34",
                          PBSportsDistanceKey: @"6.23" };

// Send the data to the Sports app
[self.watch sportsAppUpdate:update onSent:^(PBWatch * _Nonnull watch,
                                                  NSError * _Nullable error) {
  if (!error) {
    NSLog(@"Successfully sent message.");
  } else {
    NSLog(@"Error sending message: %@", error);
  }
}];
```

Read the [`PBWatch`](/docs/pebblekit-ios/Classes/PBWatch/) documentation to learn about all
the available methods and values for customization.


### Handling Button Events

When a button event is generated from one of the Sports API apps, a message is
sent to the Android companion app, which can be processed using
`sportsAppAddReceiveUpdateHandler` and supplying a block to be run when a
message is received. For example, to listen for change in state of the Sports
app, check the value of the provided `SportsAppActivityState`:

```objective-c
// Register to get state updates from the Sports app
[self.watch sportsAppAddReceiveUpdateHandler:^BOOL(PBWatch *watch,
                                                SportsAppActivityState state) {
  // Display the new state of the watchapp
  switch (state) {
    case SportsAppActivityStateRunning:
      NSLog(@"Watchapp now running.");
      break;
    case SportsAppActivityStatePaused:
      NSLog(@"Watchapp now paused.");
      break;
    default: break;
  }

  // Finally
  return YES;
}];
```
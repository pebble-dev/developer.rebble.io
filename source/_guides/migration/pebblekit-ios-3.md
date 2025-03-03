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

title: PebbleKit iOS 3.0 Migration Guide
description: How to migrate apps that use PebbleKit iOS to the 3.0 version.
permalink: /guides/migration/pebblekit-ios-3/
generate_toc: true
guide_group: migration
order: 1
---

With previous Pebble firmware versions, iOS users had to manage two different
Bluetooth pairings to Pebble. A future goal is removing the Bluetooth *Classic*
pairing and keeping only the *LE* (Low Energy) one. This has a couple of
advantages. By using only one Bluetooth connection Pebble saves energy,
improving the battery life of both Pebble and the phone. It also has the
potential to simplify the onboarding experience. In general, fewer moving parts
means less opportunity for failures and bugs.

The plan is to remove the Bluetooth *Classic* connection and switch to *LE* in
gradual steps. The first step is to make the Pebble app communicate over *LE* if
it is available. The Bluetooth *Classic* pairing and connection will be kept
since as of today most iOS companion apps rely on the *Classic* connection in
order to work properly.

Building a companion app against PebbleKit iOS 3.0 will make it compatible with
the new *LE* connection, while still remaining compatible with older Pebble
watches which don't support the *LE* connection. Once it is decided to cut the
Bluetooth *Classic* cord developers won't have to do anything, existing apps
will continue to work.

> Note: Pebble Time Round (the chalk platform) uses only Bluetooth LE, and so
> companion apps **must** use PebbleKit iOS 3.0 to connect with it.


## What's New

### Sharing No More: Dedicated Channels per App

A big problem with the Bluetooth *Classic* connection is that all iOS companion
apps have to share a single communication channel which gets assigned on a "last
one wins" basis. Another problem is that a "session" on this channel has to be
opened and closed by the companion app.

PebbleKit iOS 3.0 solved both these problems with *LE* based connections. When
connected over *LE* each companion app has a dedicated and persistent
communication channel to Pebble.

This means that an app can stay connected as long as there is a physical
Bluetooth LE connection, and it does not have to be closed before that other
apps can use it!


### Starting an App from Pebble

Since each companion app using the *LE* connection will have a dedicated and
persistent channel, the user can now start using an app from the watch without
having to pull out the phone to open the companion app. The companion app will
already be connected and listening. However there are a few caveats to this:

* The user must have launched the companion app at least once after rebooting
  the iOS device.

* If the user force-quits the companion app (by swiping it out of the app
  manager) the channel to the companion app will be disconnected.

Otherwise the channel is pretty robust. iOS will revive the companion app in the
background when the watchapp sends a message if the companion app is suspended,
has crashed, or was stopped/killed by iOS because it used too much memory.


## How to Upgrade

1. Download the new `PebbleKit.framework` from the
   [`pebble-ios-sdk`](https://github.com/pebble/pebble-ios-sdk/) repository.

2. Replace the existing `PebbleKit.framework` directory in the iOS project.

3. The `PebbleVendor.framework` isn't needed anymore. If it is not used, remove
   it from the project to reduce its size.

3. See the [Breaking API Changes](#breaking-api-changes) section below.

4. When submitting the iOS companion to the
  [Pebble appstore](https://dev-portal.rebble.io/), make sure to check the
  checkbox shown below.

![](/images/guides/migration/companion-checkbox.png)

> **Important**: Make sure to invoke `[[PBPebbleCentral defaultCentral] run]`
> after the iOS app is launched, or watches won't connect!


## Breaking API Changes

### App UUIDs Are Now NSUUIDs

Older example code showed how to use the `appUUID` property of the
`PBPebbleCentral` object, which was passed as an `NSData` object. Now it is
possible to directly use an `NSUUID` object. This also applies to the `PBWatch`
APIs requiring `appUUID:` parameters. An example of each case is shown below.

**Previous Versions of PebbleKit iOS**

```obj-c
uuid_t myAppUUIDbytes;
NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"226834ae-786e-4302-a52f-6e7efc9f990b"];
[myAppUUID getUUIDBytes:myAppUUIDbytes];
[PBPebbleCentral defaultCentral].appUUID = [NSData dataWithBytes:myAppUUIDbytes length:16];
```

**With PebbleKit iOS 3.0**

```obj-c
NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"226834ae-786e-4302-a52f-6e7efc9f990b"];
[PBPebbleCentral defaultCentral].appUUID = myAppUUID;
```


### Cold PBPebbleCentral

As soon as PebbleKit uses a `CoreBluetooth` API a pop-up asking for Bluetooth
permissions will appear. Since it is undesirable for this pop-up to jump right
into users' faces when they launch the iOS app, `PBPebbleCentral` will start in
a "cold" state.

This gives developers the option to explain to app users that this pop-up will
appear, in order to provide a smoother onboarding experience. As soon as a 
pop-up would be appropriate to show (e.g.: during the app's onboarding flow),
 call `[central run]`, and the pop-up will be shown to the user.

To help personalize the experience, add some custom text to the pop-up by adding
a `NSBluetoothPeripheralUsageDescription` ("Privacy - Bluetooth Peripheral Usage
Description") value to the project's `Info.plist` file.

```obj-c
// MyAppDelegate.m - Set up PBPebbleCentral and run if the user has already
// performed onboarding
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [PBPebbleCentral defaultCentral].delegate = self;
  [PBPebbleCentral defaultCentral].appUUID = myAppUUID;
  if ([MySettings sharedSettings].userDidPerformOnboarding) {
    [[PBPebbleCentral defaultCentral] run];
  }
}
```

```obj-c
// MyOnboarding.m - Once the pop-up has been accepted, begin PBPebbleCentral
- (IBAction)didTapGrantBluetoothPermissionButton:(id)sender {
  [MySettings sharedSettings].userDidPerformOnboarding = YES;
  [[PBPebbleCentral defaultCentral] run]; // will trigger pop-up
}
```

It is very unlikely that the Pebble watch represented by the `PBWatch` object
returned by `lastConnectedWatch` is connected instantly after invoking `[central
run]`. Instead, it is guaranteed that the delegate will receive
`pebbleCentral:watchDidConnect:` as soon as the watch connects (which might take
a few seconds). Once this has occurred, the app may then perform operations on
the `PBWatch` object.


## New Features

### 8K AppMessage Buffers

In previous versions of PebbleKit iOS, if an app wanted to transmit large
amounts of data it had to split it up into packets of 126 bytes. As of firmware
version 3.5, this is no longer the case - the maximum message size is now such
that a dictionary with one byte array (`NSData`) of 8192 bytes fits in a single
app message. The maximum available buffer sizes are increased for messages in
both directions (i.e.: inbox and outbox buffer sizes). Note that the watchapp
should be compiled with SDK 3.5 or later in order to use this capability.

To check whether the connected watch supports the increased buffer sizes, use
`getVersionInfo:` as shown below.

```obj-c
[watch getVersionInfo:^(PBWatch *watch, PBVersionInfo *versionInfo) {
  // If 8k buffers are supported...
  if ((versionInfo.remoteProtocolCapabilitiesFlags & PBRemoteProtocolCapabilitiesFlagsAppMessage8kSupported) != 0) {
    // Send a larger message!
    NSDictionary *update = @{ @(0): someHugePayload };
    [watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
      // ...
    }];
  } else {
    // Fall back to sending smaller 126 byte messages...
  }
}];
```


###  Swift Support

The library now exports a module which makes using PebbleKit iOS in
[Swift](https://developer.apple.com/swift/) projects much easier. PebbleKit iOS
3.0 also adds nullability and generic annotations so that developers get the
best Swift experience possible.

```obj-c
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  let pebbleCentral = PBPebbleCentral.defaultCentral()
  pebbleCentral.appUUID = PBGolfUUID
  pebbleCentral.delegate = self
  pebbleCentral.run()

  return true
}
```


## Minor Changes and Deprecations

* Removed the PebbleVendor framework.

  * Also removed CocoaLumberjack from the framework. This should
    reduce conflicts if the app is using CocoaLumberjack itself.

  * If the project need these classes, it can keep the PebbleVendor dependency,
    therwise just remove it.

* Added `[watch releaseSharedSession]` which will close *Classic* sessions that
  are shared between iOS apps (but not *LE* sessions as they are not shared).

  * If the app doesn't need to talk to Pebble in the background, it doesn't have
    to use it.

  * If the app does talk to Pebble while in the background, call this method as
    soon as it is done talking.

* Deprecated `[watch closeSession:]` - please use `[watch releaseSharedSession]`
  if required (see note above). The app can't close *LE* sessions actively.

* Deprecated `[defaultCentral hasValidAppUUID]` - please use `[defaultCentral
  appUUID]` and check that it is not `nil`.

* Added `[defaultCentral addAppUUID:]` if the app talks to multiple app UUIDs from
  the iOS application, allowing `PebbleCentral` to eagerly create *LE*
  sessions.

* Added logging - PebbleKit iOS 3.0 now logs internal warnings and errors via
  `NSLog`. To change the verbosity, use `[PBPebbleCentral setLogLevel:]` or even
  override the `PBLog` function (to forward it to CocoaLumberjack for example).

* Changed `[watch appMessagesAddReceiveUpdateHandler:]` - the handler must not
  be `nil`.


## Other Recommendations

### Faster Connection

Set `central.appUUID` before calling `[central run]`. If using multiple app
UUIDs please use the new `addAppUUID:` API before calling `[central run]` for
every app UUID that the app will talk to.


### Background Apps

If the app wants to run in the background (please remember that Apple might
reject it unless it provides reasonable cause) add the following entries to the
`UIBackgroundModes` item in the project's `Info.plist` file:

* `bluetooth-peripheral` ("App shares data using CoreBluetooth") which is used
  for communication.

* `bluetooth-central` ("App communicates using CoreBluetooth") which is used for
  discovering and reconnecting Pebbles.


### Compatibility with Older Pebbles

Most of the Pebble users today will be using a firmware that is not capable of
connecting to an iOS application using *LE*. *LE* support will gradually roll
out to all Pebble watches. However, this will not happen overnight. Therefore,
both *LE* and *Classic* PebbleKit connections have to be supported for some
period of time. This has several implications for apps:

* Apps still need to be whitelisted. Read 
  {% guide_link appstore-publishing/whitelisting %} for more information and to
  whitelist a new app.

* Because the *Classic* communication channel is shared on older Pebble firmware
  versions, iOS apps still need to provide a UI to let the user connect to/disconnect
  from the Pebble app. For example, a "Disconnect" button would cause `[watch
  releaseSharedSession]` to be called.

* In the project's `Info.plist` file:

  * The `UISupportedExternalAccessoryProtocols` key still needs to be added with
    the value `com.getpebble.public`.

  * The `external-accessory` value needs to be added to the `UIBackgroundModes`
    array, if you want to support using the app while backgrounded.

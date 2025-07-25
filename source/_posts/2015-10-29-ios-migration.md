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

title: Migrating to Pebblekit iOS 3.0
author: alex
tags:
- Freshly Baked
banner: /images/blog/ios-migration-banner.png
---

Starting with Pebble Time Round, we are moving towards communicating with Bluetooth
Low-Energy only. This means there are some updates to PebbleKit iOS to support this. Here are
the major changes and steps to take to support the new BLE connection.

**What's New**

* Companion apps have dedicated, persistent communication channels
* Start mobile apps from Pebble
* 8K AppMessage buffers
* Swift support


## What do you need to do?
Import the new [PebbleKit iOS 3.0](/guides/migration/pebblekit-ios-3/#how-to-upgrade) library into your project.

### API Changes

#### NSUUIDs

You can now use `NSUUID` objects directly rather than passing ``appUUID`` as a `NSData` object.

**PebbleKit 2.x**

```c
uuid_t myAppUUIDbytes;
NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"226834ae-786e-4302-a52f-6e7efc9f990b"];
[myAppUUID getUUIDBytes:myAppUUIDbytes];
[PBPebbleCentral defaultCentral].appUUID = [NSData dataWithBytes:myAppUUIDbytes length:16];
```

**PebbleKit 3.0**

```c
NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"226834ae-786e-4302-a52f-6e7efc9f990b"];
[PBPebbleCentral defaultCentral].appUUID = myAppUUID;
```

#### Cold start PBPebbleCentral

You'll want to start ``PBPebbleCentral`` in a cold state now so users don't get
a pop-up asking for Bluetooth permissions as soon as the app initializes. Call
`[central run]` when it makes sense for the pop-up to show up. Add some custom
text to the dialog with `NSBluetoothPeripheralUsageDescription` to your
`Info.plist` file.

**PebbleKit 2.x**

 ```c
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

**PebbleKit 3.0**

```c
// MyOnboarding.m - Once the pop-up has been accepted, begin PBPebbleCentral
- (IBAction)didTapGrantBluetoothPermissionButton:(id)sender {
  [MySettings sharedSettings].userDidPerformOnboarding = YES;
  [[PBPebbleCentral defaultCentral] run]; // will trigger pop-up
}
```

### Specify that your app is built with PebbleKit 3.0 in the Developer Portal
Go to edit the companion app listing in your [developer portal]({{ site.links.devportal }}) page and check the box for "Was this iOS app compiled with PebbleKit iOS 3.0 or newer?" This way, users on Pebble Time Round will be able to see your app in the appstore.

![](/images/blog/checkbox.png)

### Final thoughts

With a few quick steps, you can bring compatability for the BLE connection to your app. In the coming months, we'll be rolling out updates for users of Pebble and Pebble Time to take advantage of BLE-only connection as well. In the short term, if you intend to support Pebble Time Round, these steps are mandatory. For the complete details on migrating to PebbleKit 3.0, take a look at our [migration guide](/guides/migration/pebblekit-ios-3/). If you have any issues in migrating or have any questions concerning PebbleKit 3.0, feel free to [contact](/contact/) us anytime!

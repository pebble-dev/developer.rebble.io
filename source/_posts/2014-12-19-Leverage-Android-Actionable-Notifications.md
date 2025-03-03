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

title: Send a Smile with Android Actionable Notifications
author: thomas
date: 2014-12-19
tags:
- Beautiful Code
banner: /images/blog/1219-header.jpg
---

Just a few days ago, we released [beta version 2.3 of our Android
Application][android-beta] with support for actionable notifications. If you
have not tested it already, [enroll in our beta channel][beta-channel] and try
it out for yourself!

Notifications have always been a key use case for Pebble, and we are excited by
this new feature which is going to change the way you look at
notifications. With actionable notifications Pebble not only informs you 
about relevant events, users can now interact with them and choose from actions
you as an Android developer attach to them.

When connected to an Android device, Pebble will show all wearable actions, just
like any Android Wear device. While supporting wearable notifications is easy 
we have found that there are still a number of mobile apps who miss the opportunity 
to extend their reach to the wrist. Don't let your app be one of those!

In this post, we will describe what you can do with actions on wearable devices
and how to add them to your Android notifications.



## Actionable Notifications

Android actionable notifications on the phone were introduced with Android 4.1. 
Developers specify different actions per notification and users can react to them
by pushing a button on the phone's screen.
By default those actions are shown in the notification area.

You can make those actions visible to wearable devices and you even have the
option to collect data from the user before triggering the action. For example,
a "Reply" action can offer a list of pre-defined messages that the user can
choose from. On Pebble, this includes a long list of nice emojis!

To take advantage of actionable notifications on Pebble and Android Wear
devices, you need to do two things:

 - Add support for notification actions in your application
 - Declare which ones you want to make available on wearable device

Let's take a look at how to do this.

## Pushing a Notification to the Watch

All notifications start with the Android Notification Builder. A best practice
is to use the `NotificationCompat` class from the [Android Support
libraries][android-support-lib] which will automatically handle backwards
compatibility issues. For example, action buttons are only available in Android
4.1 and up; the library will automatically make sure your code stays compatible
with older Android phones and hide the buttons if necessary.

If you have not installed the Android Support Library, you can [follow these
instructions][android-support-lib-setup] or simply remove the `Compat`
suffix to the classes we use in this post.

To prepare a notification, you create an instance of a builder and define some
properties on it. At the very least, you need an icon, a title and some text:

    NotificationCompat.Builder builder = new NotificationCompat.Builder(context);
    builder.setSmallIcon(R.drawable.ic_launcher);
    builder.setContentTitle("Wearable Pomodoro");
    builder.setContentText("Starting the timer ...");

To push the notification, get a hold of the system notification manager:

    NotificationManager notifManager =
      (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

And finally send the notification:

    notifManager.notify(42, builder.build());

> The first parameter is a notification id that you can use to edit or cancel the
notification later.

Once you give your app the permission to send notifications to your Pebble
via the notifications menu in the Pebble Android app,
this notification appears with the default _Dismiss_ action.

![A simple notification on an Android device and a Pebble](/images/blog/1219-an-notif.png)

If you press _Dismiss_ on Pebble, the notification will be dismissed on the
watch **and** on the phone. This is a nice start, but there's so much more
control you can give to your users with custom actions.

> While custom actions work for Android 4.1 and above,
> dismiss actions on Pebble are only visible from Android 4.3 onwards.

## Adding Actions to Notifications

Let's add a custom action to our notification.
The first step is to define what it will do when it is triggered.
Actions can execute any of the standard Android intents (Activity, Service or
Broadcast). You prepare the intent, wrap it in a `PendingIntent` instance and it
will be triggered if the user selects this action.

This is what this looks like with a broadcast intent:

    // Create a new broadcast intent
    Intent pauseIntent = new Intent();
    pauseIntent.setAction(ACTION_PAUSE);

    // Wrap the intent into a PendingIntent
    PendingIntent pausePendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0, pauseIntent, 0);

> Note here that `ACTION_PAUSE` is simply a string that we defined as a constant
> in the class:
>
>     static final String ACTION_PAUSE = "com.getpebble.hacks.wearablepomodoro.PAUSE";

Now that we have the pending intent, we can create the actual
`Notification.Action` instance using an action builder:

    NotificationCompat.Action pauseAction =
      new NotificationCompat.Action.Builder(R.drawable.ic_launcher, "Pause", pausePendingIntent).build();

To make this action available on the Android notification view, you can add it
directly to the notification:

    builder.addAction(pauseAction);

Finally, **and this is the only _wearable_ specific step**, to make the action
available on Pebble and Android Wear, you **must** declare it as available to
wearable devices:

    builder.extend(new NotificationCompat.WearableExtender().addAction(pauseAction));

We now have an action available on Android and on Pebble:

![An action shown on the phone and the watch](/images/blog/1219-an-pause.png)

You can add multiple actions as you want. If you have more than one, Pebble will
show a "More..." menu and display all the actions in a list.

> The option to "Open on Phone" is not available in this example because we did
> not define a default action for the notification. It will appear automatically
> if you do.

## User Input on Action

In some cases a simple choice of actions is not enough. You may want to collect
some information from the user, for example a reply to a text message.

On Pebble, the user will be presented with a list of possible replies that you
can customize. Such actions always present a list of emojis, too. 
In Android lingo, this is an
action with support for remote input and it is trivial to set up and configure:

    String[] excuses = { "Coworker", "Facebook", "Exercise", "Nap", "Phone", "N/A" };
    RemoteInput remoteInput = new RemoteInput.Builder(KEY_INTERRUPT_REASON)
            .setLabel("Reason?")
            .setChoices(excuses)
            .build();
    NotificationCompat.Action interruptAction =
      new NotificationCompat.Action.Builder(R.drawable.ic_launcher, "Interrupt", replyPendingIntent)
            .addRemoteInput(remoteInput)
            .build();

> Pebble will hide input actions if you set `.setAllowFreeFormInput(false)`.

Don't forget to add this action to the WearableExtender to **make it visible on
wearable devices**:

    builder.extend(new Notification.WearableExtender().addAction(pauseAction).addAction(replyAction));

And this is what it looks like on Pebble:

![Action with remote input on Pebble](/images/blog/1219-an-pebble-interrupt.png)

## Caveat

One useful caveat to know about when you are sending notifications to Pebble is
that the watch will automatically de-duplicate identical notifications. So if
the title and content of your notification is identical to another notification
recently displayed, Pebble will not show it.

This is very useful in the field to avoid spamming the user when notifications
are updated but as a developer you may run into this when you test your app.
If you do, just make sure something in your message changes between each notification.

## That's All Folks!

As you can see there is nothing magical about actionable notifications – and they are
very easy to add to your app. We look forward to more Android apps supporting
useful wearable actions and taking advantage of remote input.

> **Further Reading on Android Notifications**
>
> For more information, we suggest you take a look at the [Android Notifications
Design Guide][android-patterns-notifications] and the associated [developer
guide][android-development-notifications]. Both are great resources to make the
most of notifications!


[android-beta]: https://blog.rebble.io/2014/12/16/ad-23/
[beta-channel]: /blog/2014/06/12/Android-Beta-Channel/
[android-patterns-notifications]: http://developer.android.com/design/patterns/notifications.html
[android-development-notifications]: http://developer.android.com/guide/topics/ui/notifiers/notifications.html
[android-support-lib]: http://developer.android.com/tools/support-library/
[android-support-lib-setup]: http://developer.android.com/tools/support-library/setup.html

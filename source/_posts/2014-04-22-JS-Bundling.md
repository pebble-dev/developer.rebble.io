---
title: Bundling Javascript for Pebble Apps
author: alex
tags:
- Beautiful Code
---

> *Updated Apr 23rd*: "COMING SOON" bug is fixed.

> *Updated May 14th*: We will now make most updates available right away. Your
> update will be available to both iOS and Android users at the same time if
> your JS app was previously approved. Newly submitted apps still have to wait
> for the next version of the iOS app to be made available and will be marked
> "coming soon".

We get a lot of questions about apps that use JavaScript and their availability
in the store. We are improving the Pebble appstore documentation and the
Developer Portal to address these questions, but until those changes are live,
we thought we would summarize the key points in a blog post.



First, a little reminder: Pebble applications that use PebbleKit JavaScript need
to have their JavaScript file bundled in the Pebble iOS application before iOS
Pebblers can install those apps. Android users are not affected: all Pebble apps
are always available right away to Android users.

When you submit a new app that uses JavaScript to the Pebble appstore, this app
will not be available immediately to iOS users. Instead of the "ADD" button,
they will see a "COMING SOON" button. Approximately once every 10 days, we grab
the latest release of all published JavaScript apps and include them in a new
release of our iOS app. This new release is then sent to Apple. When this new
release is approved by Apple, iOS users will automatically upgrade to this
version and will then have access to your app.

The same process is true for updates but if you have an older version of the app
that is published and included in a previous iOS release, we will show this
version to iOS users. Users will not see the "COMING SOON" button, but the
newest version of your app will not be available until the new iOS app is
published and users have updated their iOS apps. **If you need expedite process
for a JavaScript update,** you can 
[contact us](/contact).

*Please note:* We are aware of a bug that caused some apps to appear as "COMING
SOON" although an older version was available. We have now fixed this bug.


In summary:

![](/images/blog/FlowchartJS.png)

##### Here’s how the bundling process works:

1. Once we submit our Pebble iOS app to Apple, it takes about a week for Apple
   to approve it.
2. When we get the signal that the app is approved, we inform developers that we 
will soon be preparing a new release. Look for this 
[announcement on the developer forums](https://forums.getpebble.com/discussion/12451/pebble-js-bundling-updates#latest) 
and our [@pebbledev](https://twitter.com/pebbledev) Twitter account.
3. Updated JavaScript apps are collected and bundled in the iOS app and then 
submitted in a new version to Apple. The cycle restarts.
 
##### These are the best practices you should follow:

* Submit and publish new versions of your apps as soon as they are ready. They
  will be available to Android users right away and will be automatically
  included in the next version of the iOS app.
* Do not delete previous releases of your app. If you do so, users will see the
  "COMING SOON" message instead of having access to the version included in
  their iOS app.
* Do not change your JavaScript file if you do not need to. If the MD5 signature
  of your JavaScript file does not change, we will detect this and the new
  version of your app will be available right away to all users.
* Expect 7 to 20 days between when you submit a new version of your app and when
  this version will be available to all users.

##### Future improvements

Finally, this is what we are currently working on to improve the experience of
developers publishing JavaScript applications:

* We've set up a 
[forum thread](https://forums.getpebble.com/discussion/12451/pebble-js-bundling-updates#latest) 
to announce when we are going to grab JavaScript from the appstore to submit a 
new build to Apple, and then when this version is available to iOS users;
* We are updating the appstore documentation to explain how the process works;
* We will be showing you in the developer portal what the current status of your
  app is and in what version of the iOS application it is or will be in.

We are continuously looking to improve the tools and services we provide to the
developer community and will keep you updated as we do. As always feel free to
[contact us](/contact) with comments, questions and suggestions!

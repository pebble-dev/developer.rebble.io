---
title: Installing the Pebble SDK just got simpler
author: alexey
tags:
- Freshly Baked
---

Until today, installing the Pebble SDK meant downloading and unzipping the SDK and arm tools, installing some python requirements and updating your bash_profile.



### New and Improved
We've been working to make it easier to get started with the Pebble SDK. Starting today for OS X users, installing the SDK is as simple as running

> Since the release of SDK 3.0 we have removed the SDK installation script. Sorry for the inconvenience.

in your terminal. Of course, the [manual install guide](/sdk/install/mac/) for OS X is still available if you run into any issues or are more comfortable installing the requirements manually.

### Caveats
The Pebble SDK requires Python 2.7, as well as OS X 10.6 or later (10.8 or later is recommended). Support for automatic installation on linux distributions is on our roadmap as well.

Try out the one-line SDK install and let us know if you run into any issues by posting on the [SDK Installation Forum](https://forums.getpebble.com/categories/sdk-install) or [contacting us](/contact).

#### Note
> As part of the change, we now install our python dependencies through virtualenv rather than globally on your system, which should reduce the number of issues during installation.

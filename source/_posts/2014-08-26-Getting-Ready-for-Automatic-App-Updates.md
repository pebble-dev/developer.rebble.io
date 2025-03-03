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

title: Getting Ready for Automatic App Updates
author: katharine
tags:
- Freshly Baked
---

We are pleased to announce that we will soon be automatically updating apps installed from the Pebble
appstore. We believe this will be a significant improvement to your ability to get your work into
the hands of your users, as well as to the user experience.

However, as developers, you need to make sure that your app is ready for these updates. In
particular, you will need to make sure that your app conforms to our new version numbering, and
that it can tolerate persistent storage left over from old app versions.




Version Numbers
---------------

To prepare for automatic app updates, we have imposed new requirements on the format of app
version numbers. The new format is:

<center>
<p><strong>major.minor</strong></p>
</center>

Where minor is optional, and each component is considered independently (so 2.10 is newer than 2.5).
For instance, all of the following are valid version codes:

* 1.0
* 2.3
* 0.1
* 2

However, neither of the following are:

* ~~1.0.0~~
* ~~2.5-beta6~~

We will automatically upgrade the app if the version number from the watch is less than the latest
released version on the appstore. If old versions of your app contained a "bugfix" number, we will
use a number truncated to the major.minor format — so "1.0.7" will be taken as "1.0".

Persistent Storage
------------------

Automatic updates will retain persistent storage between app versions. This ensures that your users
will not be frustrated by updates silently deleting their data and settings. However, this puts the
onus on you as developers to ensure your app behaves well when presented with an old version of
its persistent storage. If your app does not already use persistent storage, you can ignore this
section.

We recommend that you do this by versioning your persistent storage, and incrementing the version
every time its structure changes.

The easiest way to do this versioning will be to create a new key in your persistent storage
containing the app version. If you have not already versioned your storage, you should simply check
for the version key and assume its absence to mean "version zero".

Once you know the "storage version" of your app, you can perform some migration to make it match
your current format. If the version is too old, or you have multiple "version zero" formats that you
cannot otherwise distinguish, you may instead just delete the old keys - but keep in mind that this
is a poor user experience, and we recommend avoiding it wherever possible.

Ultimately, you might have code that looks something like this:

```c
#define STORAGE_VERSION_KEY 124 // any previously unused value
#define CURRENT_STORAGE_VERSION 3
// ...
static void clear_persist(void) {
	// persist_delete all your keys.
}

static void read_v2_persist(void) {
	// Read the old v2 format into some appropriate structure
}

static void read_v1_persist(void) {
	// Read the old v1 format into some appropriate structure.
}

static void migrate_persist(void) {
	uint32_t version = persist_read_int(STORAGE_VERSION_KEY); // defaults to 0 if key is missing.

	if(version > CURRENT_STORAGE_VERSION) {
		// This is more recent than what we expect; we can't know what happened, so delete it
		clear_persist();
	} else if(version == 2) {
		read_v2_persist();
		store_persist();
	} else if(version == 1) {
		read_v1_persist();
		store_persist();
	} else if(version == 0) {
		// Again, just delete this - perhaps we have multiple unversioned types, or 0 is just too
		// long ago to be worth handling.
		clear_persist();
	}
}
```

Obviously, that is just an example; you will have to deal with your own situation as appropriate.

If you have further questions about getting ready for automatic app updates, let us know! [Contact us](/contact) or 
[post on our forums](https://forums.rebble.io/categories/developer-discussion).

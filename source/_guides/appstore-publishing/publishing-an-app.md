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

title: Publishing an App
description: |
  How to upload and publish an app in the Pebble appstore.
guide_group: appstore-publishing
order: 1
---

When an app is ready for publishing, the `.pbw` file needs to be uploaded to the
Pebble [Developer Portal](https://dev-portal.rebble.io/), where a listing is
created. Depending on the type of app, different sets of additional resources
are required. These resources are then used to generate the listing pages
visible to potential users in the Pebble appstore, which is embedded within the Pebble mobile app. 

You can also view the [watchfaces](http://apps.rebble.io/en_US/watchfaces) 
and [watchapps](http://apps.rebble.io/en_US/watchapps) from a desktop 
computer, as well as perform searches and get shareable links.


## Listing Resources

The table below gives a summary of which types of resources required by
different types of app. Use this to quickly assess how complete assets and
resources are before creating the listing.

| Resource | Watchface | Watchapp | Companion |
|----------|-----------|----------|-----------|
| Title | Yes | Yes | Yes |
| `.pbw` release build | Yes | Yes | - |
| Asset collections | Yes | Yes | Yes |
| Category | - | Yes | Yes |
| Large and small icons | - | Yes | Yes |
| Compatible platforms | - | - | Yes |
| Android or iOS companion appstore listing | - | - | Yes |


## Publishing a Watchface

1. After logging in, click 'Add a Watchface'.

2. Enter the basic details of the watchface, such as the title, source code URL,
   and support email (if different from the one associated with this developer
   account):

    ![face-title](/images/guides/appstore-publishing/face-title.png)

3. Click 'Create' to be taken to the listing page. This page details the status
   of the listing, including links to subpages, a preview of the public page,
   and any missing information preventing release.

    ![face-listing](/images/guides/appstore-publishing/face-listing.png)

4. The status now says 'Missing: At least one published release'. Click 'Add a
   release' to upload the `.pbw`, optionally adding release notes:

    ![face-release](/images/guides/appstore-publishing/face-release.png)

5. Click 'Save'. After reloading the page, make the release public by clicking
   'Publish' next to the release:

    ![face-release-publish](/images/guides/appstore-publishing/face-release-publish.png)

6. The status now says 'Missing: A complete X asset collection' for
   each X supported platform. Click 'Manage Asset Collections', then click
   'Create' for a supported platform.

7. Add a description, up to 5 screenshots, and optionally a marketing banner
   before clicking 'Create Asset Collection'.

    ![face-assets](/images/guides/appstore-publishing/face-assets.png)

8. Once all asset collections required have been created, click 'Publish' or
   'Publish Privately' to make the app available only to those viewing it
   through the direct link. Note that once made public, an app cannot then be
   made private.

9. After publishing, reload the page to get the public appstore link for social
   sharing, as well as a deep link that can be used to directly open the
   appstore in the mobile app.


## Publishing a Watchapp

1. After logging in, click 'Add a Watchapp'.

2. Enter the basic details of the watchapp, such as the title, source code URL,
   and support email (if different from the one associated with this developer
   account):

    ![app-title](/images/guides/appstore-publishing/app-title.png)

3. Select the most appropriate category for the app, depending on the features
   it provides:

    ![app-category](/images/guides/appstore-publishing/app-category.png)

4. Upload the large and small icons representing the app:

    ![app-icons](/images/guides/appstore-publishing/app-icons.png)

5. Click 'Create' to be taken to the listing page. This page details the status
   of the listing, including links to subpages, a preview of the public page,
   and any missing information preventing release.

    ![app-listing](/images/guides/appstore-publishing/app-listing.png)

6. The status now says 'Missing: At least one published release'. Click 'Add a
   release' to upload the `.pbw`, optionally adding release notes:

    ![app-release](/images/guides/appstore-publishing/app-release.png)

7. Click 'Save'. After reloading the page, make the release public by clicking
   'Publish' next to the release:

    ![face-release-publish](/images/guides/appstore-publishing/face-release-publish.png)

8. The status now says 'Missing: A complete X asset collection' for
   each X supported platform. Click 'Manage Asset Collections', then click
   'Create' for a supported platform.

9. Add a description, up to 5 screenshots, optionally up to three header images,
   and a marketing banner before clicking 'Create Asset Collection'.

    ![app-assets](/images/guides/appstore-publishing/app-assets.png)

10. Once all asset collections required have been created, click 'Publish' or
    'Publish Privately' to make the app available only to those viewing it
    through the direct link.

11. After publishing, reload the page to get the public appstore link for social
    sharing, as well as a deep link that can be used to directly open the
    appstore in the mobile app.


## Publishing a Companion App

> A companion app is one that is written for Pebble, but exists on the Google
> Play store, or the Appstore. Adding it to the Pebble appstore allows users to
> discover it from the mobile app.

1. After logging in, click 'Add a Companion App'.

2. Enter the basic details of the companion app, such as the title, source code
   URL, and support email (if different from the one associated with this
   developer account):

    ![companion-title](/images/guides/appstore-publishing/companion-title.png)

3. Select the most appropriate category for the app, depending on the features
   it provides:

    ![companion-category](/images/guides/appstore-publishing/companion-category.png)

4. Check a box beside each hardware platform that the companion app supports.
   For example, it may be a photo viewer app that does not support Aplite.

5. Upload the large and small icons representing the app:

    ![companion-icons](/images/guides/appstore-publishing/companion-icons.png)

6. Click 'Create' to be taken to the listing page. The status will now read
   'Missing: At least one iOS or Android application'. Add the companion app
   with eithr the 'Add Android Companion' or 'Add iOS Companion' buttons (or
   both!).

7. Add the companion app's small icon, the name of the other appstore app's
   name, as well as the direct link to it's location in the appropriate
   appstore. If it has been compiled with a PebbleKit 3.0, check that box:

    ![companion-link](/images/guides/appstore-publishing/companion-link.png)

8. Once the companion appstore link has been added, click 'Publish' or 'Publish
   Privately' to make the app available only to those viewing it through the
   direct link.

9. After publishing, reload the page to get the public appstore link for social
   sharing, as well as a deep link that can be used to directly open the
   appstore in the mobile app.

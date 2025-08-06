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
Rebble [Developer Portal]({{ site.links.devportal }}), where a listing is
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

1. After logging in to the Developer Portal, click '+ New App'. Press 'Next'.

2. Enter the basic details of the Watchface, such as the title, type,
   and a description:

    ![face-title](/images/guides/appstore-publishing/face-title.png)

3. Click 'Next' to be taken to the images page. Here you should upload screenshots for each platform your Watchface supports.
    ![add-images](/images/guides/appstore-publishing/new-add-image.png)

   Further down the page is the option to upload a banner. During inital submission, you can provide one banner. After
   your app is submitted, you will be able to provide up to 3 banners per platform if desired. Press 'Next'.

4. The next step is to optionally provide a website link and a source code link. Both fields can be left blank if desired.

    ![add-source](/images/guides/appstore-publishing/new-add-source.png)

5. Click 'Next'. The final page requires you to provide release notes for your first release, as well as the .pbw file.

    ![face-release-publish](/images/guides/appstore-publishing/new-add-release.png)

   Once you have submitted this information, and you are happy with the submission, press 'Publish App to Store' to submit your app!


## Publishing a Watchapp

1. After logging in to the Developer Portal, click '+ New App'. Press 'Next'.

2. Enter the basic details of the App, such as the title, type, category and a description:

    ![face-title](/images/guides/appstore-publishing/new-add-watchapp.png)

3. Click 'Next' to be taken to the images page. Here you should upload screenshots for each platform your App supports.
    ![add-images](/images/guides/appstore-publishing/new-add-image.png)

   Further down the page is the section to upload a banner. During inital submission, you can provide one banner. After
   your app is submitted, you will be able to provide up to 3 banners per platform if desired.

   You must also provide a large icon and small icon for your Watch App.

   ![add-banners](/images/guides/appstore-publishing/new-add-banner.png)

4. The next step is to optionally provide a website link and a source code link. Both fields can be left blank if desired.

    ![face-release](/images/guides/appstore-publishing/new-add-source.png)

5. Click 'Next'. The final page requires you to provide release notes for your first release, as well as the .pbw file.

    ![face-release-publish](/images/guides/appstore-publishing/new-add-release.png)

   Once you have submitted this information, and you are happy with the submission, press 'Publish App to Store' to submit your app!


## Publishing a Companion App

<div class="alert alert--fg-white alert--bg-orange">
{% markdown %}
**Legacy Section**

The Rebble Developer Portal does not yet support companion apps. The legacy Pebble documentation is currently preserved here for reference.
If you wish to publish or update a companion app, please get in touch via [Discord]({{ site.links.discord_invite }}).
{% endmarkdown %}
</div>

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

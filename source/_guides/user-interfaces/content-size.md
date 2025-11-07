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

title: Content Size
description: |
  Details on how to use the ContentSize API to adapt your watchface layout
  based on user text size preferences.
guide_group: user-interfaces
order: 6
related_docs:
  - ContentSize
  - UnobstructedArea
related_examples:
  - title: Simple Example
    url: https://github.com/pebble-examples/feature-content-size
---

{% alert notice %}
The ContentSize API is currently only available in SDK 4.2-BETA.
{% endalert %}

The [ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API, added in SDK 4.2, allows developers to dynamically
adapt their watchface and watchapp design based upon the system `Text Size`
preference (*Settings > Notifications > Text Size*).

While this allows developers to create highly accessible designs, it also serves
to provide a mechanism for creating designs which are less focused upon screen
size, and more focused upon content size.

![ContentSize >{pebble-screenshot,pebble-screenshot--time-red}](/images/guides/content-size/anim.gif)

The `Text Size` setting displays the following options on all platforms:

* Small
* Medium
* Large

Whereas, the
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
API will return different content sizes based on
the `Text Size` setting, varying by platform. The list of content sizes is:

* Small
* Medium
* Large
* Extra Large

An example of the varying content sizes:

* `Text Size`: `small` on `Basalt` is `ContentSize`: `small`
* `Text Size`: `small` on `Emery` is `ContentSize`: `medium`

The following table describes the relationship between `Text Size`, `Platform`
and `ContentSize`:

Platform | Text Size: Small | Text Size: Medium | Text Size: Large
---------|------------------|-------------------|-----------------
Aplite, Basalt, Chalk, Diorite, Flint | ContentSize: Small | ContentSize: Medium | ContentSize: Large
Emery | ContentSize: Medium | ContentSize: Large | ContentSize: Extra Large

> *At present the Text Size setting only affects notifications and some system
UI components, but other system UI components will be updated to support
ContentSize in future versions.*

We highly recommend that developers begin to build and update their applications
with consideration for
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
 to provide the best experience to users.

## Detecting ContentSize

In order to detect the current
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
 developers can use the
``preferred_content_size()`` function.

The [ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
will never change during runtime, so it's perfectly
acceptable to check this once during `init()`.

```c
static PreferredContentSize s_content_size;

void init() {
  s_content_size = preferred_content_size();
  // ...
}
```

## Adapting Layouts

There are a number of different approaches to adapting the screen layout based
upon content size. You could change font sizes, show or hide design elements, or
even present an entirely different UI.

In the following example, we will change font sizes based on the
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)


```c
static TextLayer *s_text_layer;
static PreferredContentSize s_content_size;

void init() {
  s_content_size = preferred_content_size();

  // ...
  switch (s_content_size) {
    case PreferredContentSizeMedium:
      // Use a medium font
      text_layer_set_font(s_text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_18_BOLD));
      break;
    case PreferredContentSizeLarge:
    case PreferredContentSizeExtraLarge:
      // Use a large font
      text_layer_set_font(s_text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_28_BOLD));
      break;
    default:
      // Use a small font
      text_layer_set_font(s_text_layer, fonts_get_system_font(FONT_KEY_GOTHIC_14_BOLD));
      break;
  }
  // ...
}
```

## Additional Considerations

When developing an application which dynamically adjusts based on the
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)
setting, try to avoid using fixed widths and heights. Calculate
coordinates and dimensions based upon the size of the root layer,
``UnobstructedArea`` and
[ContentSize](/docs/c/preview/User_Interface/Preferences/#preferred_content_size)


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

title: CloudPebble
description: |
  How to use CloudPebble to create apps with no installation required.
guide_group: tools-and-resources
order: 1
---

[CloudPebble]({{ site.links.cloudpebble }}) is an online-only IDE
(Integrated Development Environment) for easy creation of Pebble apps.
It can be used as an alternative to the local SDK on Mac OSX and Linux, and is
the recommended app development option for Windows users. Features include:

* All-in-one project management, code editing, compilation, and installation.

* Intelligent real-time code completion including project symbols.

* Browser-based emulators for testing apps and generating screenshots without
  physical hardware.

* Integration with GitHub.

To get started, log in with a Pebble Account. This is the same account as is
used for the Pebble Forums and the local SDK. Once logged in, a list of projects
will be displayed.


## Creating a Project

To create a new project, click the 'Create' button.

![create-project](/images/guides/tools-and-resources/create-project.png =480x)

Fill out the form including the name of the project, which type of project it
is, as well as the SDK version. Optionally begin with a project template. When
done, click 'Create'.


## Code Editor

The next screen will contain the empty project, unless a template was chosen.
This is the code editor screen, with the main area on the right being used to
write source files.

![empty-project](/images/guides/tools-and-resources/empty-project.png)

The left-hand menu contains links to other useful screens:

* Settings - Manage the metadata and behavior of the project as an analogue to
  the local SDK's `package.json` file.

* Timeline - Test inserting and deleting
  {% guide_link pebble-timeline "Pebble timeline" %} pins.

* Compilation - Compile and install the project, view app logs and screenshots.
  This screen also contains the emulator.

* GitHub - Configure GitHub integration for this project.

In addition, the 'Source Files' and 'Resources' sections will list the
respective files as they are added to the project. As code is written, automatic
code completion will suggest completed symbols as appropriate.


## Writing Some Code

To begin an app from a blank project, click 'Add New' next to 'Source Files'.
Choose an appropriate name for the first file (such as `main.c`), leave the
target as 'App/Watchface', and click 'Create'.

The main area of the code editor will now display the code in the new file,
which begins with the standard include statement for the Pebble SDK:

```c
#include <pebble.h>
```

To begin a runnable Pebble app, simply add the bare bones functions for
initialization, the event loop, and deinitialization. From here everything else
can be constructed:

```c
void init() {

}

void deinit() {

}

int main() {
  init();
  app_event_loop();
  deinit();
}
```

The right-hand side of the code editor screen contains convenient buttons for
use during development.

| Button | Description |
|:------:|:------------|
| ![](/images/guides/tools-and-resources/icon-play.png) | Build and run the app as configured on the 'Compilation' screen. By default this will be the Basalt emulator. |
| ![](/images/guides/tools-and-resources/icon-save.png) | Save the currently open file. |
| ![](/images/guides/tools-and-resources/icon-reload.png) | Reload the currently open file. |
| ![](/images/guides/tools-and-resources/icon-rename.png) | Rename the currently open file. |
| ![](/images/guides/tools-and-resources/icon-delete.png) | Delete the currently open file. |


## Adding Project Resources

Adding a resource (such as a bitmap or font) can be done in a similar manner as
a new code file, by clicking 'Add New' next to 'Resources' in the left-hand
pane. Choose the appropriate 'Resource Type' and choose an 'Identifier', which
will be available in code, prefixed with `RESOURCE_ID_`.

Depending on the chosen 'Resource Type', the remaining fields will vary:

* If a bitmap, the options pertaining to storage and optimization will be
  displayed. It is recommended to use the 'Best' settings, but more information
  on specific optimization options can be found in the
  [*Bitmap Resources*](/blog/2015/12/02/Bitmap-Resources/#quot-bitmap-quot-to-the-rescue)
  blog post.

* If a font, the specific characters to include (in regex form) and tracking
  adjust options are available to adjust the font, as well as a compatibility
  option that is best left to 'Latest'.

* If a raw resource, no extra options are available, save the 'Target Platforms'
  option.

Once the new resource has been configured, browse the the file itself and upload
it by clicking 'Save'.


## Installing and Running Apps

The app under development can be compiled and run using the 'play' button on the
right-hand side of the code editor screen. If the compilation was successful,
the app will be run as configured. If not, the 'Compilation' screen will be
opened and the reason for failure can be seen by clicking 'Build Log' next to
the appropriate item in the build log. The 'Compilation' screen can be thought
of a comprehensive view of what the 'play' buttons does, with more control. Once
all code errors have been fixed, clicking 'Run Build' will do just that.

When the build is complete, options to install and run the app are presented.
Clicking one of the hardware platform buttons will run the app on an emulator of
that platform, while choosing 'Phone' and 'Install and Run' will install and run
the app on a physical watch connected to any phone logged in with the same
Pebble account.

In addition to running apps, the 'Compilation' screen also offers the ability to
view app log output and capture screenshots with the appropriate buttons.
Lastly, the `.pbw` bundle can also be obtained for testing and distribution in
the [Developer Portal]({{ site.links.devportal }}).


### Interacting with the Emulator

Once an app is installed and running in the emulator, button input can be
simulated using the highlighted regions of the emulator view decoration. There
are also additional options available under the 'gear' button.

![](/images/guides/tools-and-resources/gear-options.png)

From this panel, muliple forms of input can be simulated:

* Adjust the charge level of the emulated battery with the 'Battery' slider.

* Set whether the emulated battery is in the charging state with the 'Charging'
  checkbox.

* Set whether the Bluetooth connection is connected with the 'Bluetooth'
  checkbox.

* Set whether the emulated watch is set to use 24- or 12-hour time format with
  the '24-hour' checkbox.

* Open the app's configuration page (if applicable) with the 'App Config'
  button. This will use the URL passed to `Pebble.openURL()`. See
  {% guide_link user-interfaces/app-configuration %} for more information.

* Emulate live input of the accelerometer and compass using a mobile device by
  clicking the 'Sensors' button and following the instructions.

* Shut down the emulated watch with the 'Shut Down' button.


## UI Editor

In addition to adding new code files and resources, it is also possible to
create ``Window`` layouts using a GUI interface with the UI editor. To use this
feature, create a new code file by clicking 'Add New' next to 'Source Files' and
set the 'File Type' to 'Window Layout'. Choose a name for the window and click
'Create'.

The main UI Editor screen will be displayed. This includes a preview of the
window's layout, as well as details about the current element and a toolkit of
new elements. This is shown in the image below:

![ui-editor](/images/guides/publishing-tools/ui-editor.png)

Since the only UI element that exists at the moment is the window itself, the
editor shows the options available for customizing this element's properties,
e.g. its background color and whether or not it is fullscreen.


### Adding More UI

Add a new UI element to the window by clicking on 'Toolkit', which contains a
set of standard UI elements. Choose a ``TextLayer`` element, and all the
available properties of the ``Layer`` to change its appearence and position will
be displayed:

![ui-editor-textlayer](/images/guides/publishing-tools/ui-editor-textlayer.png)

In addition to manually typing in the ``Layer``'s dimensions, use the anchor
points on the preview of the ``Layer`` on the left of the editor to click and
drag the size and position of the ``TextLayer``.

![ui-editor-drag](/images/guides/publishing-tools/ui-editor-drag.gif =148x)

When satisfied with the new ``TextLayer``'s configuration, use the 'UI Editor'
button on the right-hand side of the screen to switch back to the normal code
editor screen, where the C code that represents the ``Layer`` just set up
visually can be seen. An example of this generated code is shown below, along
with the preview of that layout.

```c
// BEGIN AUTO-GENERATED UI CODE; DO NOT MODIFY
static Window *s_window;
static GFont s_res_gothic_24_bold;
static TextLayer *s_textlayer_1;

static void initialise_ui(void) {
  s_window = window_create();
  window_set_fullscreen(s_window, false);

  s_res_gothic_24_bold = fonts_get_system_font(FONT_KEY_GOTHIC_24_BOLD);
  // s_textlayer_1
  s_textlayer_1 = text_layer_create(GRect(0, 0, 144, 40));
  text_layer_set_text(s_textlayer_1, "Hello, CloudPebble!");
  text_layer_set_text_alignment(s_textlayer_1, GTextAlignmentCenter);
  text_layer_set_font(s_textlayer_1, s_res_gothic_24_bold);
  layer_add_child(window_get_root_layer(s_window), (Layer *)s_textlayer_1);
}

static void destroy_ui(void) {
  window_destroy(s_window);
  text_layer_destroy(s_textlayer_1);
}
// END AUTO-GENERATED UI CODE
```

![ui-editor-preview](/images/guides/publishing-tools/ui-editor-preview.png =148x)

> Note: As marked above, the automatically generated code should **not** be
> modified, otherwise it will not be possible to continue editing it with the
> CloudPebble UI Editor.


### Using the New Window

After using the UI Editor to create the ``Window``'s layout, use the two
functions provided in the generated `.h` file to include it in the app:

`main_window.h`

```c
void show_main_window(void);
void hide_main_window(void);
```

For example, call the `show_` function as part of the app's initialization
procedure and the `hide_` function as part of its deinitialization. Be sure to
include the new header file after `pebble.h`:

```c
#include <pebble.h>
#include "main_window.h"

void init() {
  show_main_window();
}

void deinit() {
  hide_main_window();
}

int main(void) {
  init();
  app_event_loop();
  deinit();
}
```

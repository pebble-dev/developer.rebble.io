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

title: Pebble.js - Pebble Package Edition!
author: jonb
tags:
- Freshly Baked
---

We're pleased to announce that [Pebble.js](https://pebble.github.io/pebblejs/)
has now been [published](https://www.npmjs.com/package/pebblejs) as a
{% guide_link pebble-packages "Pebble Package" %}. Pebble.js lets developers
easily create Pebble applications using JavaScript by executing the JavaScript
code within the mobile application on a user's phone, rather than on the watch.


![Pebble.js as a Pebble Package](/images/blog/2016-12-22-pebble-js.jpg)

Making Pebble.js a Pebble Package means Pebble.js projects can be converted to
standard Pebble C projects. This gives benefits like the ability to
easily utilize other Pebble Packages, such as
[Clay for Pebble](https://www.npmjs.com/package/pebble-clay), or easily
importing and exporting the project with
[CloudPebble]({{ site.links.cloudpebble }}).

The Pebble.js package is using the
[`develop`](https://github.com/pebble/pebblejs/tree/develop) branch from the
[Pebble.js repository](https://github.com/pebble/pebblejs) on Github, and
can be updated independently from CloudPebble deployments.

**It also supports the Diorite platform!**.


## Creating a New Project

The initial steps vary if you're using CloudPebble or the Local SDK. Follow the
appropriate steps below to create a new project.

#### CloudPebble

If you're using CloudPebble, follow these initial steps:

1. Create a new project:
   * Project Type = Pebble C SDK
   * Template = Empty Project

2. Add the following dependency:
   * Package Name = pebblejs
   * Version = 1.0.0

3. Add a new `main.c` file and an `index.js` file.

Now continue to add the [default project files](#default-project-files).

#### Local SDK

If you're using the Local SDK, just create a new C project with Javascript
support:

```nc|text
$ pebble new-project PROJECTNAME --javascript
```

Now continue to add the [default project files](#default-project-files).

#### Default Project Files

Copy and paste these default project files into your project, replacing any
existing file contents:

**your-main.c**

```c
#include <pebble.h>
#include "pebblejs/simply.h"

int main(void) {
  Simply *simply = simply_create();
  app_event_loop();
  simply_destroy(simply);
}
```

**index.js**

```javascript
require('pebblejs');
var UI = require('pebblejs/ui');

var card = new UI.Card({
  title: 'Hello World',
  body: 'This is your first Pebble app!',
  scrollable: true
});

card.show();
```

At this point you should be able to compile and run your new project.


## Migrating an Existing Project

Unfortunately there isn't an automated way to migrate your existing Pebble.js
project, but the steps are fairly straightforward.

1. Create a new project, following the [steps above](#creating-a-new-project).

2. Change the project settings to match your old project settings, including the
UUID.

3. Copy your project resources (images, fonts etc.), and source files into the
new project.

4. Compile and enjoy your new C project with Pebble.js support.

> Note: `index.js` is a direct replacement for `app.js`, which may be your old
Javascript file.


## Next Steps?

Want to add Clay support to your project? It's now easy by following the
standard Clay [Getting Started](https://github.com/pebble/clay#clay)
instructions!

If you have any questions or problems, post the details on the
[developer forum](https://forums.rebble.io/t/pebble-js-pebble-package-edition/27315)
or [Discord](http://discord.gg/aRUAYFN).

Happy Holidays!

Jon Barlow + Team #PEBBLExFITBIT

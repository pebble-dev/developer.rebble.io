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

title: Creating Pebble Packages
description: How to create Pebble Packages
permalink: /guides/pebble-packages/creating-packages/
generate_toc: true
guide_group: pebble-packages
---

## Getting Started

To get started creating a package, run `pebble new-package some-name`.
Make `some-name` something meaningful and unique; it is what you'll be
publishing it under. You can check if it's taken on [npm](https://npmjs.org).
If you'll be including a JavaScript component, you can add `--javascript` for
a sample javascript file.

## Components of a Package

### C code

{% alert notice %}
**Tip**: If you want to use an
``Event Service``,
you should use the
[pebble-events](https://www.npmjs.com/package/pebble-events) package to
handle subscriptions from multiple packages.
{% endalert %}

Packages can export C functions to their consumers, and the default package
exports `somelib_find_truth` as an example. To export a function, it
simply has to be declared in a C file in `src/c/`, and declared in a header
file in `include/`. For instance:

`src/c/somelib.c`:

```c
#include <pebble.h>
#include "somelib.h"

bool somelib_find_truth(void) {
    return true;
}
```

`include/somelib.h`:

```c
#pragma once

bool somelib_find_truth(void);
```

Notice that `include/` is already in the include path when building packages,
so include files there can be included easily. By convention, packages should
prefix their non-static functions with their name (in this case `somelib`) in
order to avoid naming conflicts. If you don't want to export a function, don't
include it in a file in `includes/`; you can instead use `src/c/`. You should
still prefix any non-static symbols with your library name to avoid conflicts.

Once the package is imported by a consumer — either an app or package — its
include files will be in a directory named for the package, and so can be
included with `#include <somelib/somelib.h>`. There is no limit on the number
or structure of files in the `include` directory.

### JavaScript code

Packages can export JavaScript code for use in PebbleKit JS. The default
JavaScript entry point for packages is always in `src/js/index.js`. However,
files can also be required directly, according to
[standard node `require` rules](https://nodejs.org/api/modules.html). In either
case they are looked up relative to their root in `src/js/`.

JavaScript code can export functions by attaching them to the global `exports`
object:

`src/js/index.js`:

```
exports.addNumbers = function(a, b) {
    return a + b;
};
```

Because JavaScript code is scoped and namespaced already, there is no need to
use any naming convention.

### Resources

Packages can include resources in the same way as apps, and those resources can
then be used by both the package and the app. They are included in
`package.json` in
[the same manner as they are for apps](/guides/app-resources/).
To avoid naming conflicts, packages should prefix their resource names with the
package name, e.g. `SOMELIB_IMAGE_LYRA`.

It's best practice to define an image resource using the package name as a
prefix on the resource `name`:

```javascript
"resources": {
  "media": [
    {
      "name": "MEDIA_PACKAGE_IMAGE_01_TINY",
      "type": "bitmap",
      "file": "images/01-tiny.png"
    },
    //...
  ]
}
```

Create a `publishedMedia` entry if you want to make the images available for
{% guide_link user-interfaces/appglance-c "AppGlance slices" %} or
{% guide_link pebble-timeline/pin-structure "Timeline pins" %}.


```javascript
"resources": {
  //...
  "publishedMedia": [
    {
      "name": "MEDIA_PACKAGE_IMAGE_01",
      "glance": "MEDIA_PACKAGE_IMAGE_01_TINY",
      "timeline": {
        "tiny": "MEDIA_PACKAGE_IMAGE_01_TINY",
        "small": "MEDIA_PACKAGE_IMAGE_01_SMALL",
        "large": "MEDIA_PACKAGE_IMAGE_01_LARGE"
      }
    }
  ]
}
```

> Note: Do NOT assign an `id` when defining `publishedMedia` within packages,
see {% guide_link pebble-packages/using-packages "Using Packages" %}.

Resource IDs are not assigned until the package has been linked with an app and
compiled, so `RESOURCE_ID_*` constants cannot be used as constant initializers
in packages. To work around this, either assign them at runtime or reference
them directly. It is also no longer valid to try iterating over the resource id
numbers directly; you must use the name defined for you by the SDK.


### AppMessage Keys

Libraries can use AppMessage keys to reduce friction when creating a package
that needs to communicate with the phone or internet, such as a weather package.
A list of key names can be included in `package.json`, under
`pebble.messageKeys`. These keys will be allocated numbers at app build time.
We will inject them into your C code with the prefix `MESSAGE_KEY_`, e.g.
`MESSAGE_KEY_CURRENT_TEMP`.

If you want to use multiple keys as an 'array', you can specify a name like
`ELEMENTS[6]`. This will create a single key, `ELEMENTS`, but leave five empty
spaces after it, for a total of six available keys. You can then use arithmetic
to access the additional keys, such as `MESSAGE_KEY_ELEMENTS + 5`.

To use arrays in JavaScript you will need to know the actual numeric values of
your keys. They will exist as keys on an object you can access via
`require('message_keys')`. For instance:

```js
var keys = require('message_keys');
var elements = ['honesty', 'generosity', 'loyalty', 'kindness', 'laughter', 'magic'];
var dict = {}
for (var i = 0; i < 6; ++i) {
	dict[keys.ELEMENTS + i] = elements[i];
}
Pebble.sendAppMessage(dict, successCallback, failureCallback);
```

## Building and testing

Run `pebble build` to build your package. You can install it in a test project
using `pebble package install ../path/to/package`. Note that you will have to
repeat both steps when you change the package. If you try symlinking the package,
you are likely to run into problems building your app.

## Publishing

Publishing a Pebble Package requires you to have an npm account. For your
convenience, you can create or log in to one using `pebble package login`
(as distinct from `pebble login`). Having done this once, you can use
`pebble package publish` to publish a package.

Remember to document your package! It isn't any use to anyone if they can't
figure out how to use it. README.md is a good place to include some
documentation.

Adding extra metadata to package.json is also worthwhile. In particular,
it is worth specifying:

* `repository`: if your package is open source, the repo you can find it in.
  If it's hosted on github, `"username/repo-name"` works; otherwise a git
  URL.
* `license`: the license the package is licensed under. If you're not sure,
  try [choosealicense.com](http://choosealicense.com). You will also want to
  include a copy of the full license text in a file called LICENSE.
* `description`: a one-sentence description of the package.

For more details on package.json, check out
[npm's package.json documentation](https://docs.npmjs.com/getting-started/using-a-package.json).



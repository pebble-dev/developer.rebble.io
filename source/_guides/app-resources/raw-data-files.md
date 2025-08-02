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

title: Raw Data Files
description: |
  How to add raw data resources to a project and read them in your app.
guide_group: app-resources
order: 7
---

Some kinds of apps will require extra data that is not a font or an image. In
these cases, the file can be included in a Pebble project as a raw resource.
When a file is included as a raw resource, it is not modified in any way from
the original when the app is built.

Applications of this resource type can be found in the Pebble SDK for APIs
such as ``GDrawCommand`` and ``GBitmapSequence``, which both use raw resources
as input files. Other possible applications include localized string
dictionaries, CSV data files, etc.


## Adding Raw Data Files

To add a file as a raw resource, specify its `type` as `raw` in `package.json`.
An example is shown below:

```js
"resources": {
  "media": [
    {
      "type": "raw",
      "name": "EXAMPLE_DATA_FILE",
      "file": "data.bin"
    }
  ]
}
```


## Reading Bytes and Byte Ranges

Once a raw resource has been added to a project, it can be loaded at runtime in
a manner similar to other resources types:

```c
// Get resource handle
ResHandle handle = resource_get_handle(RESOURCE_ID_DATA);
```

With a handle to the resource now available in the app, the size of the resource
can be determined:

```c
// Get size of the resource in bytes
size_t res_size = resource_size(handle);
```

To read bytes from the resource, create an appropriate byte buffer and copy data
into it:

```c
// Create a buffer the exact size of the raw resource
uint8_t *s_buffer = (uint8_t*)malloc(res_size);
```

The example below copies the entire resource into a `uint8_t` buffer:

```c
// Copy all bytes to a buffer
resource_load(handle, s_buffer, res_size);
```

It is also possible to read a specific range of bytes from a given offset into
the buffer:

```c
// Read the second set of 8 bytes
resource_load_byte_range(handle, 8, s_buffer, 8);
```

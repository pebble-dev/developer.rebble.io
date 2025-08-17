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

title: App Exit Reason
description: |
  Details on how to use the AppExitReason API
guide_group: user-interfaces
order: 1
related_docs:
  - AppExitReason
---

Introduced in SDK v4.0, the ``AppExitReason`` API allows developers to provide a
reason when terminating their application. The system uses these reasons to
determine where the user should be sent when the current application terminates.

At present, there are only two ``AppExitReason`` states when exiting an application, but this may change in future updates.

### APP_EXIT_NOT_SPECIFIED

This is the default state and when the current watchapp terminates. The user is
returned to their previous location. If you do not specify an ``AppExitReason``,
this state will be used automatically.

```c
static void prv_deinit() {
    // Optional, default behavior
    // App will exit to the previous location in the system
    exit_reason_set(APP_EXIT_NOT_SPECIFIED);
}
```

### APP_EXIT_ACTION_PERFORMED_SUCCESSFULLY

This state is primarily provided for developers who are creating one click
action applications. When the current watchapp terminates, the user is returned
to the default watchface.

```c
static void prv_deinit() {
    // App will exit to default watchface
    exit_reason_set(APP_EXIT_ACTION_PERFORMED_SUCCESSFULLY);
}
```

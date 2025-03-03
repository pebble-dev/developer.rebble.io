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

title: FreeRTOS™ Code Revisions from Pebble
author: brad
tags:
- Down the Rabbit Hole
---

Today Pebble is releasing its recent modifications to the FreeRTOS project.
Pebble has made a few minor changes to FreeRTOS to enable its new sandboxed
application environment for PebbleOS 2.0 as well as to make Pebble easier to
monitor and debug.

The changes are available 
[as a tarball](http://assets.rebble.io.s3-website-us-east-1.amazonaws.com/dev-portal/FreeRTOS-8.0.0-Pebble.tar.gz)
.

Read on to learn more about the changes and why they were made.


The new PebbleOS 2.0 application sandbox environment allows running third party
native code (Pebble Apps) in a safe and secure manner. In the sandbox, any
application errors should not negatively impact the host operating system.

Because of the hardware restrictions of a Pebble watch, the  implementation is
achieved in a basic manner. Pebble Apps are run in their own FreeRTOS task that
is unprivileged. This means that the instructions the app is authorized to run
are restricted. For example, it’s not allowed to change the `CONTROL` register
(which changes whether the app is privileged or not) or change interrupt
settings. Furthermore, Pebble restricts the memory the app can access to a small
fixed region. This is done using the MPU (Memory Protection Unit) hardware
available in the Pebble microcontroller. Accesses outside of this region will
cause the application to be stopped. This way Pebble can make sure the
application is only interacting with the kernel in ways that will not interfere
with other features and functions.

The FreeRTOS implementation includes a port that uses the MPU (ARM_CM3_MPU)
which is incompatible with the project goals. This port appears meant for safety
critical environments where tasks shouldn’t be allowed to accidentally interact
with each other. However, there doesn’t seem to be any protection from a
malicious task. For example, raising a task's privilege level is as easy as
triggering a software interrupt, which unprivileged tasks are free to use. “MPU
wrapper” functions are provided to allow any task to call a FreeRTOS API
function from any privilege level and operate as a privileged function, ignoring
any MPU settings. The sandbox is intended to restrict how the application
FreeRTOS task is allowed to interact with the kernel, so modifications were
necessary.

To solve this, Pebble has created its own port named ARM_CM3_PEBBLE. This port
is based on the ARM_CM3_MPU port, but is modified to use the MPU in a different
way. No wrappers are provided (you need to be privileged to directly call
FreeRTOS functions) and the `portSVC_RAISE_PRIVILEGE` software interrupt is
removed.

To permit the app to interact with the system in a safe manner, Pebble added a
new software interrupt, called `portSVC_SYSCALL`. Unprivileged code can use it
to jump into the operating system in a privileged state but only using a system-
provided jump-table. The jump-table contains the address to landing functions
(we refer to them as syscalls) that are individually responsible for checking
that the operation is permitted and the parameters are safe and valid.

Pebble has also made some minor changes to how tasks are created and destroyed.
In order for the application to keep working inside its sandbox, it needs access
to certain resources like its own stack memory. FreeRTOS allows a programmer to
specify a buffer to be used as the stack, so a buffer that's allocated inside
the app sandbox memory region is used. However, FreeRTOS has a bug where it
tries to deallocate the stack memory when a task is destroyed, regardless of
where that memory came from. Pebble changed this code to only free the stack
when it was not provided by the system.

Pebble also added the ability for the system to designate its own buffer for the
`_reent` struct. This struct is a feature of the c library we use - newlib -
that contains buffers that are used by various libc functions. For example,
`localtime` returns a pointer to a `struct tm` structure. This struct is
actually stored in the `_reent` struct. FreeRTOS has `_reent` support so which
`_reent` struct is currently being used is swapped around per task, so each task
has their own `_reent` struct to play with and you don’t have issues if two
threads call `localtime` at the same time. To ensure the `_reent` struct for the
application task is available within the sandboxed memory region, Pebble pre-
allocated it and passed it through to `xTaskCreate`.

Finally, Pebble has added some functionality to inspect the saved registers of
tasks that aren’t currently running. This allows Pebble to collect additional
diagnostics if the watch exhibits any errors and to provide basic crash
reporting for apps. For example, App developers will get a dump of the app’s PC
(Program Counter) and LR (Link Register) registers at the time of the crash.

Pebble is incredibly thankful for all the work that the FreeRTOS community has
put into the code. It has been a huge asset when building PebbleOS. We'll be
releasing additional updates as we continue to modify FreeRTOS in the future. If
you have any questions, don’t hesitate to [contact us](/contact).

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

title: FreeRTOS™ Code Revisions - Background Worker Edition
author: brad
tags:
- Down the Rabbit Hole
---

As part of our commitment to the open source community, Pebble is releasing its
recent modifications to the FreeRTOS project. Pebble has made a few minor
changes to FreeRTOS to enable Background Workers for PebbleOS 2.6 as well as to
make Pebble easier to monitor and debug.

The changes are available [as a tarball](http://assets.rebble.io.s3-website-us-east-1.amazonaws.com/dev-portal/FreeRTOS-8.0.0-Pebble.2.tar.gz).

Below is a changelog of the modifications since the last time we released our
fork of the FreeRTOS code back in May.


* Added `UBaseType_t uxQueueGetRecursiveCallCount( QueueHandle_t xMutex )
  PRIVILEGED_FUNCTION;` to queue.h
    * Retrieves the number of times a mutex has been recursively taken
    * FreeRTOS always tracked this internally but never made it available
      externally
    * Used to debug locking relating issues in PebbleOS

* Added `configASSERT_SAFE_TO_CALL_FREERTOS_API();`
    * This macro can be used to assert that it is safe to call a FreeRTOS API.
      It checks that the caller is not processing an interrupt or in a critical
      section.
    * See http://www.freertos.org/RTOS-Cortex-M3-M4.html for more details on
      how interrupts interact with the FreeRTOS API
* Added `configASSERT_SAFE_TO_CALL_FREERTOS_FROMISR_API();`
    * This macro can be used to assert that it is safe to call a FreeRTOS
      "FromISR" API. It checks that the caller is at an appropriate interrupt
      level.
    * See http://www.freertos.org/RTOS-Cortex-M3-M4.html for more details on
      how interrupts interact with the FreeRTOS API
* Added `uintptr_t ulTaskGetStackStart( xTaskHandle xTask );` to task.h
    * Retrieves the address of the start of the stack space
    * Useful for implementing routines which check for available stack space
* Added `bool vPortInCritical( void );` to port.c
    * Indicates if we're currently in a FreeRTOS critical section
    * Used to implement `configASSERT_SAFE_TO_CALL_FREERTOS_API();`
* Fixed an issue with vPortStoreTaskMPUSettings that occurred when more than
  one task wanted to configure MPU regions
    * This bug was encountered when adding support for Background Workers in
      FW 2.6

Pebble would like to again extend its thanks to FreeRTOS and its community.
We'll be releasing additional updates as we continue to modify FreeRTOS in the
future. If you have any questions, don’t hesitate to [contact us](/contact).

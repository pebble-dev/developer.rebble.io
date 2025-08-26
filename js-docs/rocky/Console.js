/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @namespace console
 * @desc This provides an interface to the app's debugging console. 
 * 
 *   Use the `$ pebble logs` command or: 
 *
 *   `$ pebble install --emulator basalt --logs`
 *
 *   You can find out more about logging in our 
 *   {@link /guides/debugging/debugging-with-app-logs/ Debugging with App Logs} guide.
 */
var console = new Object();

/**
 * @desc Outputs a message to the app's debugging console.
 * 
 *   `console.log(rocky.watchInfo.platform);`
 *
 * @param {...Object} obj - One or more JavaScript objects to output. The string
 *   representations of each of these objects are appended together in the order
 *   listed and output.
 */
console.log = function (obj) { };

/**
 * @desc Outputs a warning message to the app's debugging console.
 *
 *   `console.warn('Something seems wrong');`
 *
 * @param {...Object} obj - One or more JavaScript objects to output. The string
 *   representations of each of these objects are appended together in the order
 *   listed and output.
 */
console.warn = function (obj) { };

/**
 * @desc Outputs an error message to the app's debugging console.
 *
 *   `console.error(JSON.stringify(obj));`
 *
 * @param {...Object} obj - One or more JavaScript objects to output. The string
 *   representations of each of these objects are appended together in the order
 *   listed and output.
 */
console.error = function (obj) { };

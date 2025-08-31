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

title: Command Line Tool
description: |
  How to use the Pebble command line tool to build, debug, and emulate apps.
guide_group: tools-and-resources
order: 2
toc_max_depth: 2
---

{% alert notice %}
This page applies only to developers using the SDK on their local machine;
CloudPebble allows you to use many of these features in 'Compilation'.
{% endalert %}

The Pebble SDK includes a command line tool called `pebble`. This tool allows
developers to create new projects, build projects, install apps on a watch and debug
them. This tool is part of the SDK, but many of these functions are made
available on [CloudPebble]({{ site.links.cloudpebble }}).


## Enabling the Developer Connection

Most `pebble` commands allow interaction with a Pebble watch. This relies on a
communication channel opened between the `pebble` tool on a computer and the
Pebble mobile application on the phone.

The `pebble` tool requires two configuration steps:

1. Enable the {% guide_link tools-and-resources/developer-connection %} in the
   Pebble mobile application.
2. Give the phone IP address to the `pebble` tool as shown below to communicate
   with a watch. This is not required when using the emulator or connecting via
   CloudPebble.


## Connecting to a Pebble

There are four connection types possible with the command line tool. These can
be used with any command that involves a watch, for example `install`.

Connect to a physical watch connected to a phone on the same Wi-Fi network with
`IP` [IP address](#enabling-the-developer-connection):

```nc|text
$ pebble install --phone IP
```

Connect to an already running QEMU instance available on the `HOST` and `PORT`
provided:

```nc|text
$ pebble install --qemu HOST:PORT
```

Connect directly to a watch using a local Bluetooth connection, where `SERIAL`
is the path to the device file. On OS X, this is similar to
`/dev/cu.PebbleTimeXXXX-SerialPo` or `/dev/cu.PebbleXXXX-SerialPortSe`:

> Note: Replace 'XXXX' with the actual value for the watch in question.

```nc|text
$ pebble install --serial SERIAL
```

Alternatively, connect to a watch connected to the phone via the CloudPebble
proxy, instead of local Wi-Fi. This removes the need for local inter-device
communication, but still requires an internet connection on both devices:

```nc|text
$ pebble install --cloudpebble
```


## Configure the Pebble Tool

Save the IP address of the phone in an environment variable:

```text
$ export PEBBLE_PHONE=192.168.1.42
```

Save the default choice of emulator platform:

```text
$ export PEBBLE_EMULATOR=aplite
```

Save the default instance of QEMU:

```text
$ export PEBBLE_QEMU=localhost:12344
```

{% comment %}
Always use the CloudPebble proxy:

```text
$ export PEBBLE_CLOUDPEBBLE
```
{% endcomment %}


## Debugging Output

Get up to four levels of `pebble` tool log verbosity. This is available for all
commands:

```nc|text
# Minimum level of verbosity
$ pebble install -v

# Maximum logging verbosity
$ pebble install -vvvv
```


## Installing Watchapps

In addition to interacting with a physical Pebble watch, the Pebble emulator
included in the local SDK (as well as on CloudPebble) can be used to run and
debug apps without any physical hardware.

Build an app, then use `pebble install` with the `--emulator` flag to choose
between an emulator platform with `aplite`, `basalt`, or `chalk`. This allows
developers to test out apps on all platforms before publishing to the Pebble
appstore. For example, to emulate Pebble Time or Pebble Time Steel:

```nc|text
$ pebble install --emulator basalt
```

> Note: If no `--emulator` parameter is specified, the running emulator will
> be used.

With a suitable color app installed, the emulator will load and display it:

![](/images/guides/publishing-tools/emulator.png)

The Pebble physical buttons are emulated with the following mapping:

| Button | Key |
|--------|-----|
| Back | `Q`, left arrow |
| Up | `W`, up arrow |
| Select | `S`, right arrow |
| Down | `X`, down arrow |


## Pebble Timeline in the Emulator

With the emulator, it is also possible to view any past and future pins on the
Pebble timeline by pressing Up or Down from the main watchface screen:

<table>
  <tr>
    <td><img src="/assets/images/guides/publishing-tools/timeline-past.png"/></td>
    <td><img src="/assets/images/guides/publishing-tools/timeline-future.png"/></td>
  </tr>
  <tr style="text-align: center;">
    <td>Timeline, past view</td><td>Timeline, future view</td>
  </tr>
</table>


## Commands

This section summarizes the available commands that can be used in conjunction
with the `pebble` tool, on the applicable SDK versions. Most are designed to
interact with a watch with `--phone` or the emulator with `--emulator`.


### Project Management

#### new-project

```nc|text
$ pebble new-project [--simple] [--javascript] [--worker] [--rocky] NAME
```

Create a new project called `NAME`. This will create a directory in the
location the command is used, containing all essential project files.

There are also a number of optional parameters that allow developers to choose
features of the generated project to be created automatically:

* `--simple` - Initializes the main `.c` file with a minimal app template.

* `--javascript` - Creates a new application including a `./src/pkjs/index.js` file
  to quickly start an app with a PebbleKit JS component. Read 
  {% guide_link communication/using-pebblekit-js %} for more information.

* `--worker` - Creates a new application including a `
  ./worker_src/NAME_worker.c` file to quickly start an app with a background
  worker. Read {% guide_link events-and-services/background-worker %} for more
  information.

* `--rocky` - Creates a new Rocky.js application. Do not use any other optional
  parameters with this command.  Read
  [Rocky.js documentation](/docs/rockyjs/) for more information.


#### build

```nc|text
$ pebble build
```

Compile and build the project into a `.pbw` file that can be installed on a
watch or the emulator.


#### install

```nc|text
$ pebble install [FILE]
```

Install the current project to the watch connected to the phone with the given
`IP` address, or to the emulator on the `PLATFORM`. See 
{% guide_link tools-and-resources/hardware-information %} for a list of
available platforms. 

For example, the Aplite platform is specified as follows:

```nc|text
$ pebble install --emulator aplite
```

It is also possible to use this command to install a pre-compiled `.pbw` `FILE`.
In this case, the specified file will be installed instead of the current
project.

> Note: A `FILE` parameter is not required if running `pebble install` from
> inside a buildable project directory. In this case, the `.pbw` package is
> found automatically in `./build`.


#### clean

```nc|text
$ pebble clean
```

Delete all build files in `./build` to prepare for a clean build, which can
resolve some state inconsistencies that may prevent the project from building.


#### convert-project

```nc|text
$ pebble convert-project
```

Convert an existing Pebble project to the current SDK. 

> Note: This will only convert the project, the source code will still have to
> updated to match any new APIs.


### Pebble Interaction

#### logs

```nc|text
$ pebble logs
```

Continuously display app logs from the watch connected to the phone with the
given `IP` address, or from a running emulator.

App log output is colorized according to log level. This behavior can be forced
on or off by specifying `--color` or `--no-color` respectively.


#### screenshot

```nc|text
$ pebble screenshot [FILENAME]
```

Take a screenshot of the watch connected to the phone with the given `IP`
address, or from any running emulator. If provided, the output is saved to
`FILENAME`.

Color correction may be disabled by specifying `--no-correction`. The
auto-opening of screenshots may also be disabled by specifying `--no-open`.


#### ping

```nc|text
$ pebble ping
```

Send a `ping` to the watch connected to the phone with the given `IP` address,
or to any running emulator.


#### repl

```nc|text
$ pebble repl
```

Launch an interactive python shell with a `pebble` object to execute methods on,
using the watch connected to the phone with the given `IP` address, or to any
running emulator.


#### data-logging

##### list

```nc|text
$ pebble data-logging list
```

List the current data logging sessions on the watch.

##### download

```nc|text
$ pebble data-logging download --session-id SESSION-ID FILENAME
```

Downloads the contents of the data logging session with the given ID
(as given by `pebble data-logging list`) to the given filename.

##### disable-sends

```nc|text
pebble data-logging disable-sends
```

Disables automatically sending data logging to the phone. This enables
downloading data logging information without the phone's interference.
It will also suspend any other app depending on data logging, which
includes some firmware functionality. You should remember to enable
it once you are done testing.

##### enable-sends


```nc|text
pebble data-logging enable-sends
```

Re-enables automatically sending data logging information to the phone.

##### get-sends-enabled

```nc|text
pebble data-logging get-sends-enabled
```

Indicates whether data logging is automatically sent to the phone. Change
state with `enable-sends` and `disable-sends`.



### Emulator Interaction


#### gdb

```nc|text
$ pebble gdb
```

Use [GDB](https://www.gnu.org/software/gdb/) to step through and debug an app
running in an emulator. Some useful commands are displayed in a cheat sheet
when run with `--help` and summarized in the table below:

> Note: Emulator commands that rely on interaction with the emulator (e.g. 
> `emu-app-config`) will not work while execution is paused with GDB.

| Command | Description |
|---------|-------------|
| ctrl-C | Pause app execution. |
| `continue` or `c` | Continue app execution. The app is paused while a `(gdb)` prompt is available. |
| ctrl-D or `quit` | Quit gdb. |
| `break` or `b` | Set a breakpoint. This can be either a symbol or a position: <br/>- `b function_name` to break when entering a function.<br/>- `b file_name.c:45` to break on line 45 of `file_name.c`. |
| `step` or `s` | Step forward one line. |
| `next` or `n` | Step *over* the current line, avoiding stopping for any functions it calls into. |
| `finish` | Run forward until exiting the current stack frame. |
| `backtrace` or `bt` | Print out the current call stack. |
| `p [expression]` | Print the result of evaluating the given `expression`. |
| `info args` | Show the values of arguments to the current function. |
| `info locals` | Show local variables in the current frame. |
| `bt full` | Show all local variables in all stack frames. |
| `info break` | List break points (#1 is `<app_crashed>`, and is inserted by the `pebble` tool). |
| `delete [n]` | Delete breakpoint #n. |

Read {% guide_link debugging/debugging-with-gdb %} for help on using GDB to
debug app.


#### emu-control

```nc|text
$ pebble emu-control [--port PORT]
```

Send near real-time accelerometer and compass readings from a phone, tablet, or
computer to the emulator. When run, a QR code will be displayed in the terminal
containing the IP address the device should connect to. Scanning the code will
open this address in the device's browser. The IP address itself is also printed
in the terminal for manual entry. `PORT` may be specified in order to make
bookmarking the page easier.

![qr-code](/images/guides/publishing-tools/qr-code.png =450x)

After connecting, the device's browser will display a UI with two modes of
operation.

![accel-ui](/images/guides/publishing-tools/accel-ui.png =300x)

The default mode will transmit sensor readings to the emulator as they are
recorded. By unchecking the 'Use built-in sensors?' checkbox, manual values for
the compass bearing and each of the accelerometer axes can be transmitted to the
emulator by manipulating the compass rose or axis sliders. Using these UI
elements will automatically uncheck the aforementioned checkbox.

The values shown in bold are the Pebble SDK values, scaled relative to
``TRIG_MAX_ANGLE`` in the case of the compass bearing value, and in the range of
+/-4000 (+/- 4g) for the accelerometer values. The physical measurements with
associated units are shown beside in parentheses.


#### emu-app-config

```nc|text
$ pebble emu-app-config [--file FILE]
```

Open the app configuration page associated with the running app, if any. Uses
the HTML configuration `FILE` if provided.

See {% guide_link user-interfaces/app-configuration %} to learn about emulator-
specific configuration behavior.


#### emu-tap

```nc|text
$ pebble emu-tap [--direction DIRECTION]
```

Send an accelerometer tap event to any running emulator. `DIRECTION` can be one
of `x+`, `x-`, `y+`, `y-`, `z+`, or `z-`.


#### emu-bt-connection

```nc|text
$ pebble emu-bt-connection --connected STATE
```

Send a Bluetooth connection event to any running emulator. `STATE` can be either
`yes` or `no` for connected and disconnected events respectively.

> Note: The disconnected event may take a few seconds to occur.


#### emu-compass

```nc|text
$ pebble emu-compass --heading BEARING [--uncalibrated | --calibrating | --calibrated]
```

Send a compass update event to any running emulator. `BEARING` must be a number
between `0` and `360` to be the desired compass bearing. Use any of
`--uncalibrated`, `--calibrating`, or `--calibrated` to set the calibration
state.


#### emu-battery

```nc|text
$ pebble emu-battery [--percent LEVEL] [--charging]
```

Send a battery update event to any running emulator. `LEVEL` must be a number
between `0` and `100` to represent the new battery level. The presence of
`--charging` will determine whether the charging cable is plugged in.


#### emu-accel

```nc|text
$ pebble emu-accel DIRECTION [--file FILE]
```

Send accelerometer data events to any running emulator. `DIRECTION` can be any
of `tilt_left`, `tilt_right`, `tilt_forward`, `tilt_back`, `gravity+x`,
`gravity-x`, `gravity+y`, `gravity-y`, `gravity+z`, `gravity-z` , and `custom`.
If `custom` is selected, specify a `FILE` of comma-separated x, y, and z
readings.


#### transcribe

```nc|text
$ pebble transcribe [message] [--error {connectivity,disabled,no-speech-detected}]
```

Run a server that will act as a transcription service. Run it before
invoking the ``Dictation`` service in an app. If `message` is provided,
the dictation will be successful and that message will be provided.
If `--error` is provided, the dictation will fail with the given error.
`--error` and `message` are mutually exclusive.

```nc|text
$ pebble transcribe "Hello, Pebble!"
```


#### kill

```nc|text
$ pebble kill
```

Kill both the Pebble emulator and phone simulator.


#### emu-time-format

```nc|text
pebble emu-time-format --format FORMAT
```

Set the time format of the emulator to either 12-hour or 24-hour format, with a
`FORMAT` value of `12h` or `24h` respectively.


#### emu-set-timeline-quick-view

```nc|text
$ pebble emu-set-timeline-quick-view STATE
```

Show or hide the Timeline Quick View system overlay. STATE can be `on` or `off`.


#### wipe

```nc|text
$ pebble wipe
```

Wipe data stored for the Pebble emulator, but not the logged in Pebble account.
To wipe **all** data, specify `--everything` when running this command.


### Pebble Account Management

#### login

```nc|text
$ pebble login
```

Launces a browser to log into a Pebble account, enabling use of `pebble` tool
features such as pushing timeline pins.


#### logout

```nc|text
$ pebble logout
```

Logs out the currently logged in Pebble account from this instance of the
command line tool.


### Pebble Timeline Interaction

#### insert-pin

```nc|text
$ pebble insert-pin FILE [--id ID]
```

Push a JSON pin `FILE` to the Pebble timeline. Specify the pin `id` in the
`FILE` as `ID`.


#### delete-pin

```nc|text
$ pebble delete-pin FILE [--id ID]
```

Delete a pin previously pushed with `insert-pin`, specifying the same pin `ID`.


## Data Collection for Analytics

When first run, the `pebble` tool will ask for permission to collect usage
information such as which tools are used and the most common errors. Nothing
personally identifiable is collected.

This information will help us improve the SDK and is extremely useful for us,
allowing us to focus our time on the most important parts of the SDK as
discovered through these analytics.

To disable analytics collection, run the following command to stop sending
information:

```text
# Mac OSX
$ touch ~/Library/Application\ Support/Pebble\ SDK/NO_TRACKING

# Other platforms
$ touch ~/.pebble-sdk/NO_TRACKING
```

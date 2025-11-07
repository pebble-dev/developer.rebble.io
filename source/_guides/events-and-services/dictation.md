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

title: Dictation
description: |
  How to use the Dictation API to get voice-to-text input in watchapps.
guide_group: events-and-services
order: 4
platforms:
  - basalt
  - chalk
  - diorite
  - emery
  - flint
related_docs:
  - Dictation
related_examples:
  - title: Simple Voice Demo
    url: https://github.com/pebble-examples/simple-voice-demo
  - title: Voice Quiz
    url: https://github.com/pebble-examples/voice-quiz
---

On hardware [platforms](/faqs/#pebble-sdk) supporting a microphone, the 
``Dictation`` API can be used to gather arbitrary text input from a user. 
This approach is much faster than any previous button-based text input system 
(such as [tertiary text](https://github.com/vgmoose/tertiary_text)), and 
includes the ability to allow users to re-attempt dictation if there are any 
errors in the returned transcription.

> Note: Apps running on multiple hardware platforms that may or may not include
> a microphone should use the `PBL_MICROPHONE` compile-time define (as well as
> checking API return values) to gracefully handle when it is not available.


## How the Dictation API Works

The ``Dictation`` API invokes the same UI that is shown to the user when
responding to notifications via the system menu, with events occuring in the
following order:

* The user initiates transcription and the dictation UI is displayed.

* The user dictates the phrase they would like converted into text.

* The audio is transmitted via the Pebble phone application to a 3rd party
  service and translated into text.

* When the text is returned, the user is given the opportunity to review the
  result of the transcription. At this time they may elect to re-attempt the
  dictation by pressing the Back button and speaking clearer.

* When the user is happy with the transcription, the text is provided to the
  app by pressing the Select button.

* If an error occurs in the transcription attempt, the user is automatically
  allowed to re-attempt the dictation.

* The user can retry their dictation by rejecting a successful transcription,
  but only if confirmation dialogs are enabled.


## Beginning a Dictation Session

To get voice input from a user, an app must first create a ``DictationSession``
that contains data relating to the status of the dictation service, as well as
an allocated buffer to store the result of any transcriptions. This should be
declared in the file-global scope (as `static`), so it can be used at any time
(in button click handlers, for example).

```c
static DictationSession *s_dictation_session;
```

A callback of type ``DictationSessionStatusCallback`` is also required to notify
the developer to the status of any dictation requests and transcription results.
This is called at any time the dictation UI exits, which can be for any of the
following reasons:

* The user accepts a transcription result.

* A transcription is successful but the confirmation dialog is disabled.

* The user exits the dictation UI with the Back button.

* When any error occurs and the error dialogs are disabled.

* Too many transcription errors occur.

```c
static void dictation_session_callback(DictationSession *session, DictationSessionStatus status,
                                       char *transcription, void *context) {
  // Print the results of a transcription attempt
  APP_LOG(APP_LOG_LEVEL_INFO, "Dictation status: %d", (int)status);
}
```

At the end of this callback the `transcription` pointer becomes invalid - if the
text is required later it should be copied into a separate buffer provided by
the app. The size of this dictation buffer is chosen by the developer, and
should be large enough to accept all expected input. Any transcribed text longer
than the length of the buffer will be truncated.

```c
// Declare a buffer for the DictationSession
static char s_last_text[512];
```

Finally, create the ``DictationSession`` and supply the size of the buffer and
the ``DictationSessionStatusCallback``. This session may be used as many times
as requires for multiple transcriptions. A context pointer may also optionally
be provided.

```c
// Create new dictation session
s_dictation_session = dictation_session_create(sizeof(s_last_text),
                                               dictation_session_callback, NULL);
```


## Obtaining Dictated Text

After creating a ``DictationSession``, the developer can begin a dictation
attempt at any time, providing that one is not already in progress.

```c
// Start dictation UI
dictation_session_start(s_dictation_session);
```

The dictation UI will be displayed and the user will speak their desired input.

![listening >{pebble-screenshot,pebble-screenshot--time-red}](/images/guides/pebble-apps/sensors/listening.png)

It is recommended to provide visual guidance on the format of the expected input
before the ``dictation_session_start()`` is called. For example, if the user is
expected to speak a location that should be a city name, they should be briefed
as such before being asked to provide input.

When the user exits the dictation UI, the developer's
``DictationSessionStatusCallback`` will be called. The `status` parameter
provided will inform the developer as to whether or not the transcription was
successful using a ``DictationSessionStatus`` value. It is useful to check this
value, as there are multiple reasons why a dictation request may not yield a
successful result. These values are described below under
[*DictationSessionStatus Values*](#dictationsessionstatus-values).

If the value of `status` is equal to ``DictationSessionStatusSuccess``, the
transcription was successful. The user's input can be read from the
`transcription` parameter for evaluation and storage for later use if required.
Note that once the callback returns, `transcription` will no longer be valid.

For example, a ``TextLayer`` in the app's UI with variable name `s_output_layer`
may be used to show the status of an attempted transcription:

```c
if(status == DictationSessionStatusSuccess) {
  // Display the dictated text
  snprintf(s_last_text, sizeof(s_last_text), "Transcription:\n\n%s", transcription);
  text_layer_set_text(s_output_layer, s_last_text);
} else {
  // Display the reason for any error
  static char s_failed_buff[128];
  snprintf(s_failed_buff, sizeof(s_failed_buff), "Transcription failed.\n\nReason:\n%d",
           (int)status);
  text_layer_set_text(s_output_layer, s_failed_buff);
}
```

The confirmation mechanism allowing review of the transcription result can be
disabled if it is not needed. An example of such a scenario may be to speed up a
'yes' or 'no' decision where the two expected inputs are distinct and different.

```c
// Disable the confirmation screen
dictation_session_enable_confirmation(s_dictation_session, false);
```

It is also possible to disable the error dialogs, if so desired. This will
disable the dialogs that appear when a transcription attempt fails, as well as
disabling the ability to retry the dictation if a failure occurs.

```
// Disable error dialogs
dictation_session_enable_error_dialogs(s_dictation_session, false);
```


### DictationSessionStatus Values

These are the possible values provided by a ``DictationSessionStatusCallback``,
and should be used to handle transcription success or failure for any of the
following reasons.

| Status | Value | Description |
|--------|-------|-------------|
| ``DictationSessionStatusSuccess`` | `0` | Transcription successful, with a valid result. |
| ``DictationSessionStatusFailureTranscriptionRejected`` | `1` | User rejected transcription and dismissed the dictation UI. |
| ``DictationSessionStatusFailureTranscriptionRejectedWithError`` | `2` | User exited the dictation UI after a transcription error. |
| ``DictationSessionStatusFailureSystemAborted`` | `3` | Too many errors occurred during transcription and the dictation UI exited. |
| ``DictationSessionStatusFailureNoSpeechDetected`` | `4` | No speech was detected and the dictation UI exited. |
| ``DictationSessionStatusFailureConnectivityError`` | `5` | No Bluetooth or Internet connection available. |
| ``DictationSessionStatusFailureDisabled`` | `6` | Voice transcription disabled for this user. This can occur if the user has disabled sending 'Usage logs' in the Pebble mobile app. |
| ``DictationSessionStatusFailureInternalError`` | `7` | Voice transcription failed due to an internal error. |
| ``DictationSessionStatusFailureRecognizerError`` | `8` | Cloud recognizer failed to transcribe speech (only possible if error dialogs are disabled). |

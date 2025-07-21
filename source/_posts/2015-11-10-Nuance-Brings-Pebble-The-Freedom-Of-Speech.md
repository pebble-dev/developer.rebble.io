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

title: Nuance Brings Pebble The Freedom Of Speech
author: jonb
tags:
- Freshly Baked
---

In October, we gave developers access to the microphone in the Pebble Time via
our new
[Dictation API](``Dictation``),
and almost instantly we began seeing awesome projects utilising speech input.
Voice recognition is an exciting new method of interaction for Pebble and it has
created an opportunity for developers to enhance their existing applications, or
create highly engaging new applications designed around the spoken word.

Speech-to-text has been integrated with Pebble by using the
[Recognizer](http://www.nuance.com/for-business/automatic-speech-recognition/automated-ivr/index.htm)
cloud service from Nuance, a leading provider of voice and language solutions.


## The Pebble Dictation Process

The Dictation API has been made incredibly easy for developers to integrate into
their watchapps. It’s also intuitive and simple for users to interact with.
Here’s an overview of the the dictation process:

1. The user begins by pressing a designated button or by triggering an event
   within the watchapp to indicate they want to start dictating. The watchapp’s
   UI should make this obvious.

2. The watchapp
   [initiates a dictation session](/docs/c/Foundation/Dictation/#dictation_session_start),
   assigning a
   [callback function](/docs/c/Foundation/Dictation/#DictationSessionStatusCallback)
   to handle the response from the system. This response will be either
   successful and return the dictated string, or fail with an error code.

3. The system Dictation UI appears and guides the user through recording their
   voice. The stages in the image below illustrate:

    a. The system prepares its buffers and checks connectivity with the cloud
       service.

    b. The system begins listening for speech and automatically stops listening
       when the user finishes talking.

    c. The audio is compressed and sent to the cloud service via the mobile
       application.

    d. The audio is transcribed by the cloud service and the transcribed text is
       returned and displayed for the user to accept or reject (this behaviour
       can be
       [programmatically overridden](/docs/c/Foundation/Dictation/#dictation_session_enable_confirmation)).

4. Once the process has completed, the registered callback method is fired and
   the watchapp can deal with the response.

![dictation-flow](/images/blog/dictation-flow.png)


## But How Does It Actually Work?

Let’s take a closer look at what’s happening behind the scenes to see what’s
really going on.

![dictation-recognizer](/images/blog/dictation-recognizer.png)

1. To capture audio, Pebble Time (including Time Steel and Time Round) has a
   single [MEMS](https://en.wikipedia.org/wiki/Microelectromechanical_systems)
   microphone. This device produces output at 1 MHz in a
   [PDM](https://en.wikipedia.org/wiki/Pulse-density_modulation) format.

2. This 1 bit PDM signal needs to be converted into 16-bit
   [PCM](https://en.wikipedia.org/wiki/Pulse-code_modulation) data at 16 kHz
   before it can be compressed.

3. Compression is performed using the [Speex](http://www.speex.org/) encoder,
   which was specifically designed for speech compression. Compression needs to
   occur in order to reduce the overall size of the data before it’s transferred
   via bluetooth to the mobile application. Speex also has some additional
   advantages like tuneable quality/compression and recovery from dropped
   frames.

4. The mobile application sends the compressed data to Nuance Recognizer, along
   with some additional information like the user’s selected language.

5. Nuance performs its magic and returns the textual representation of the
   spoken phrase to the mobile application, which is then automatically passed
   back to the watchapp.

6. The Dictation UI presents the transcribed text back to the user where they
   can choose to accept or reject it.


## About the Dictation API

Behind the scenes there’s a lot going on, but let’s take a look at how minimal
the code needs to be in order to use the API.

1. Create a static variable as a reference to the dictation session:

    ```c
    static DictationSession *s_dictation_session;
    ```

2. Create a callback function to receive the dictation response:

    ```c
    static void dictation_session_callback(DictationSession *session, DictationSessionStatus status, char *transcription, void *context) {
      if(status == DictationSessionStatusSuccess) {
        APP_LOG(APP_LOG_LEVEL_DEBUG, "Transcription:\n\n%s", transcription);
      } else {
        APP_LOG(APP_LOG_LEVEL_DEBUG, "Transcription failed.\n\nError ID:\n%d", (int)status);
      }
    }
    ```

3. Within a button click or other event, create a ``DictationSession`` to begin
   the process:

    ```c
    s_dictation_session = dictation_session_create(512, dictation_session_callback, NULL);
    ```

4. Before your app exits, don’t forget to destroy the session:

    ```c
    dictation_session_destroy(s_dictation_session);
    ```


## Voice-enabled Watchapps

Here’s a small sample of some of the watchapps which are already available in
the Pebble appstore which utilise the Dictation API.

* [Voice2Timeline](http://apps.rebble.io/en_US/application/561f9188bcb7ac903a00005b)
  is a handy tool for quickly creating pins on your timeline by using your
  voice. It already works in 6 different languages. You can leave notes in the
  past, or even create reminders for the future (e.g. “Don’t forget the milk in
  1 hour”).

* [Translate (Vox Populi)](http://apps.rebble.io/en_US/application/561ff3cbbcb7aca6250000a3)
  allows a user to translate short phrases and words into a different language.
  It uses the [Yandex](https://translate.yandex.com/) machine translator API
  which supports more than 60 different languages.

* [Checklist](http://apps.rebble.io/en_US/application/5620e876768e7ada4e00007a)
  is a really simple tool which generates a list of items using your voice. It
  even allows you to enter multiple items at once, by specifying a comma or
  period. You can easily mark them as completed by pressing the ‘select’ button
  on each item.

* [Smartwatch Pro](https://itunes.apple.com/gb/app/smartwatch-pro-for-pebble/id673907094?mt=8)
  (iOS) has been updated to give users voice controlled music playback, create
  reminders and even create tweets by using their voice.


## Final Thoughts

Why not also checkout this video of Andrew Stapleton (Embedded Developer) as he 
deep dives into the internals of the Pebble Dictation API during his presentation 
at the [Pebble Developer Retreat 2015](/community/events/developer-retreat-2015/).

[EMBED](www.youtube.com/embed/D-8Ng24RXwo)

We hope you’ve seen how flexible and easy it is to use the new Dictation API,
and perhaps it will inspire you to integrate voice into your own application or
watchface - if you create a voice enabled watchapp, let us know by tweeting
[@pebbledev](https://twitter.com/pebbledev).

If you’re looking to find out more about voice integration, checkout our
[developer guide](/guides/events-and-services/dictation/),
[API documentation](``Dictation``)
and our
[simple example app](https://github.com/pebble-examples/simple-voice-demo). We
also have a very friendly and helpful Pebble community on Discord; why not
[join us]({{ site.links.discord_invite }})?

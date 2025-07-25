---
title: Guest Blog Post - Pebble Powered Instruments at GrizzHacks
author: pebble
tags:
- At the Pub
---

*This is a guest blog post from [Jeremy Karbowski][1], who created a theremin-like gesture based instrument for the Pebble smartwatch at [GrizzHacks 2016][2].*

Hackathons are wonderful. The three I've attended thus far have been amazing opportunities to learn new technologies and work with other hackers to bring an idea to life. Hackathons embody some of the pure magical joy of computing that make your eyes light up with new ideas, and they provide an opportunity for participants to work with hardware and resources that they may not have had access to otherwise.



[![Prototyping](/images/blog/2016-04-26-pebble-theremin/working.png)][i1]
<p class="blog__image-text">Working on the prototype during GrizzHacks</p>

When I showed up to GrizzHacks I had no idea what I wanted to make, but I knew I wanted to explore some of the new hardware that was provided by the organizers, and the Pebble smartwatch and [Myo armband][3] immediately stuck out as bursting with potential. I remembered a project from a past hackathon that used the Myo wristband to control a string of colored lights based on the user’s movement, and was impressed by the expressive potential that gesture-based input suggested. I wanted to explore that.

Our minds simultaneously inhabit physical and virtual spaces, switching between the two constantly throughout the day. Using movement and gesture-based technology for control draws these spaces closer together, providing a stronger connection between the two worlds and enabling expressive and emotional interactions with virtual spaces through technology.

One of the best ways to translate and express emotion is through music, and I realized that with the gesture recognition of the Myo and the accelerometer packed inside of the Pebble I could create an instrument that allowed for musical expression through the motion of the device in a way similar to the [theremin][4].

Now that I had my idea, I just needed to build it. I created a system to stream hardware sensor data to a Node.js server and a web front-end that listeners can connect to from anywhere in the world. Here, streaming sensor data is converted to synthesizer modulations done in-browser by a web audio synth. Movements on different axes were meant to control different parameters of the synthesizer, such as frequency and amplitude. Pebble made this task a dream - the hardware worked beautifully, and I was able to transfer accelerometer data over a websocket connection with ease.

```js
// Simplified Pebble JS code
var UI = require('ui');
var Accel = require('ui/accel');
var ws = new WebSocket('ws://boiling-fjord-40795.herokuapp.com/');

Accel.on('data', function(e) {
  ws.send(JSON.stringify(e.accel));
});

ws.onclose = function() {
  Accel.on('data', function(e) { /* do nothing */ });
};
```

After ~20 hours of fiddling with server configurations and synth modules I had a working prototype. A few tweaks to the sensitivity/responsiveness (that feel much better in newer builds) and it was ready to present. Things weren’t perfect, but such is the nature of a hackathon. Larger and excited motions would cause synthesizer values to fluctuate wildly, creating an audio stream that sounded something like a dial-up connection. As a result, I believe I may have the honor of saying that I'm the first person to perform dial-up on stage. The positive response was amazing, the crowd loved it. So much so that I hurried off-stage in a rush of excitement and thanks, forgetting to speak to the very real future of the project.

[![Live Demo](/images/blog/2016-04-26-pebble-theremin/demoing.png)][i2]
<p class="blog__image-text">Demoing the instrument to a live audience</p>

Work has begun on expanding the project. The web app design makes it trivial to connect multiple users all playing separate instruments, enabling multi-user performances with each participant playing remotely from anywhere in the world. The viewer end of the interface is modeled as a visualization of a garden, with viewers represented as flowers in the garden and performers as bouncing balls of light. Viewers can chat through a common interface, help shape the current performance through their interaction, as well as record, play back, and share performances.

[![Test Interface](/images/blog/2016-04-26-pebble-theremin/testing.png)][i3]
<p class="blog__image-text">Garden's demo interface</p>

Development has begun on a new instrument interface powered by an Android application. The app works similarly to the interface created for the Pebble - streaming sensor data from the phone to the web app, with additional concerns and design changes due to the weight of the phone and the addition of a touch screen. The differences in the two will make for two distinctly different instruments with similarly intuitive styles of control, enabling users to join together for collaborative, physically-based musical performances.

Huge thanks to the people at Pebble for their great piece of wearable tech and for being all-around awesome. This couldn’t have happened without their awesome documentation and support. I'm incredibly excited for the future of this project. It’s been a blast to work on so far, and I hope you'll join me later this summer when the new version of the site goes live for testing! If you’re interested, you can find more information about the project (including it’s source) on [hackaday.io][6]  and follow me on Twitter [@JeremyKarbowski][5] where I occasionally post about the projects I’m working on.

[1]: https://github.com/jkarbows
[2]: http://grizzhacks.com
[3]: https://www.myo.com/
[4]: https://en.wikipedia.org/wiki/Theremin
[5]: https://twitter.com/JeremyKarbowski
[6]: https://hackaday.io/project/10876-garden

[i1]: /assets/images/blog/2016-04-26-pebble-theremin/working_full.png
[i2]: /assets/images/blog/2016-04-26-pebble-theremin/demoing_full.png
[i3]:/assets/images/blog/2016-04-26-pebble-theremin/testing_full.png


---
title: Hands-on with the RePhone smartstrap kit for Pebble Time
author: jonb
tags:
- Freshly Baked
---

For those that don’t already know, the RePhone smartstrap kit was part of a
highly successful [Kickstarter campaign]
(https://www.kickstarter.com/projects/seeed/rephone-kit-worlds-first-open-source-and-modular-p)
by [Seeed Studio](http://www.seeed.cc/) to create the world’s first open source
and modular smartphone. Part of their campaign was to create a smartstrap kit
for Pebble Time that integrates with RePhone modules such as GPS, NFC, and
external batteries. This is the first commercial smartstrap project I’ve managed
to lay my hands on, and it’s awesome!


The box contains everything you need to get started:

- Xadow GPS v2 module 
- Xadow NFC v2 module 
- Xadow Battery 100mAh module 
- A Pebble Time adaptor 
- A 22mm watch strap with mounting holes 
- Ribbon cables, Mounting rivets and silicone casings 
- Instruction booklet 

![rephone-smartstrap-kit-diagram](/images/blog/rephone-smartstrap-kit-diagram.png)
<p style="text-align: center; font-size: 0.9em;">RePhone Strap Kit diagram courtesy of Seeed Studio</p>

Assembling the components was a reasonably straightforward process, although my
chunky fingers and poor eyesight didn’t always make it quite as easy as it
should have been. First you need to fix the adaptor to the back of your Pebble,
then attach the watchstrap, making sure to feed the ribbon cables that extend
from the adaptor through on top of the watch strap. Each module needs to be
interconnected as per the instructions above.

Seeed Studio provide an open source [Pebble
watchapp](https://github.com/Seeed-Studio/Xadow_Strap/raw/master/build/pebbleapp_jack.pbw) 
which displays GPS coordinates, velocity, altitude, satellites and NFC (when in range). 
[This project](https://github.com/Seeed-Studio/Xadow_Strap/) can be compiled with the local [Pebble SDK](/sdk/) 
or [CloudPebble]({{site.links.cloudpebble}}). 

After getting everything hooked up and the watchapp installed, I was
disappointed when the GPS didn’t initially appear to be working. I headed
outside with my watch and stood in the street for a while, and pretty soon the
number of visible satellites started to increase and then the GPS position was
established. 

![rephone-smartstrap-kit](/images/blog/rephone-smartstrap-kit.jpg)

It honestly felt like wearing some kind of futuristic time travel device with
all of the wires and circuits exposed. I wouldn’t recommend walking into an
airport like this, but I actually quite enjoyed the aesthetics.

The next thing to test was the NFC module, and thankfully this was really
simple. I held my NFC enabled phone against the NFC antenna and sure enough, the
tag ID appeared. I also used it to successfully scan another NFC chip, but this
one was embedded directly inside someone's hand. Apparently there’s some
seriously dedicated next-level biohackers at Pebble!

The battery module supplied with the kit is used to power the GPS and NFC
modules, but you can also use it to charge the Pebble itself. I didn’t have time
to perform any testing other than confirm that the Pebble was infact charging
from the strap’s battery. The battery module is 100mAh, compared to the 150mAh
battery in the Pebble Time, pretty impressive for something so small!

There are other modules available for the RePhone kit, like GSM+BLE, audio,
touch screen and LEDs, but it doesn’t look like the smartstrap kit is able to
take advantage of those. However, I did stumble across a page on the [Seeed
Studio wiki](http://www.seeedstudio.com/wiki/Xadow_Pebble_Time_Adapter), which
explains how to build your own firmware for the smartstrap adaptor itself. So if
you’re interested in taking things further, it’s great to know there are more
options are available for the hardcore hardware hacker.

The Pebble developer community have been eagerly hacking away with their kits,
[ishotjr](https://twitter.com/ishjr) has published some unboxing photos on his 
[blog](http://ishotjr.com/seeed-rephone-smartstrap-for-pebble-time-unboxing/)
and created a [useful wiki](https://github.com/ishotjr/rephone-smartstrap/wiki).
If you want to get involved, you can find them in #smartstraps over on the 
[Pebble Developer Discord]({{ site.links.discord_invite }}).

We've only just scratched the surface of what's possible with this smartstrap kit
and we can't wait to see what the community produce. If you build a custom app 
using the RePhone Smartstrap Kit, we'd love to [hear about it]
(https://twitter.com/pebbledev).

---
title: Get Ready For Smartstraps - Warm Up Your 3D Printer!
author: pebble
tags:
- Freshly Baked
date: 2015-03-03 
---

Many of you have read about smartstraps on 
[our Kickstarter page](http://kickstarter.com/projects/597507018/pebble-time-awesome-smartwatch-no-compromises) 
and contacted us for more details. Today we are releasing mechanical and
electrical designs so you can start working on the next generation of straps:
Straps that expand the functionality of Pebble Time and Pebble Time Steel.

The smartstrap connector is situated on the back of your new favorite watch.
Smartstraps can extend below the watch to reach that connector while Pebble Time
is worn. In the 3D files we are releasing today, you will find a generic
connector that can work with most straps. Of course, you can also design
completely new straps if your project calls for one!




![strap-components](/images/more/strap-components.png =400x)

The smartstrap connector has four contacts: two for ground, one for power in/out
and a one-wire serial bus. The power contact is bi-directional and can be used
to power your accessory, or for the strap to provide power to the watch. The
amount of power you can draw to power your accessory must not exceed 20 mA, and
of course it will impact the battery life of the Pebble.

For more information on how to electrically connect the smartstrap connector to
an external accessory, please refer to our 
[dedicated smartstrap page](/smartstraps/).

The APIs to interact with smartstraps are not part of the developer preview.
They will be available publicly several months after we start shipping Pebble
Time, as it is lower priority than shipping the main OS. You can however expect
that there to be APIs that read and write on the port, as well as some standard
control protocol to detect when a smartstrap is attached and even automatically
launch an app.

We will have an early access program to the smartstraps APIs for developers
interested in them. Just 
[drop your email into this form](http://eepurl.com/bfK91H) and we will contact 
you when we are ready to share them. Until then you can also exchange ideas and
[discuss smartstraps in the forums](https://forums.getpebble.com/categories/smartstraps).

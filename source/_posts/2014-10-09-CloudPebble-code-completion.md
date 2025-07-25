---
title: New CloudPebble Code Completion
author: katharine
tags:
- Freshly Baked
- CloudPebble
---

CloudPebble today gains significantly enhanced support for code completion, as
well as inline syntax checking and the ability to "go to definition".

Check it out!




<!-- Work around silly gfycat padding. -->
<div style="height: 210px; overflow: hidden; margin-bottom: 20px;">
<iframe src="https://gfycat.com/ifr/DenseEmotionalDipper" frameborder="0"
	scrolling="no" width="480" height="360" 
	style="-webkit-backface-visibility: hidden; -webkit-transform: scale(1) translate(0, -70px); transform: translate(0, -70px);">
</iframe>
</div>

In particular, the new code completion now features:

- Fuzzy matching! You can now enter abbrevations (e.g. `tlst` for
  `text_layer_set_text`) and CloudPebble will know what you mean
- Complete your own symbols! The code completion is now aware of your own
  symbols and will include them in its suggestions
- Struct members and unions are now suggested as appropriate, instead of
  suggesting members that do not exist.

Real-time sanity checking of your code means we will highlight errors and
warnings in red and yellow, respectively; you can hover over the icon on the
left to see the complaint.

![](/images/blog/cloudpebble-inline-warning.png)
![](/images/blog/cloudpebble-inline-error.png)

Note: if you are suddenly seeing red all over a header file it's probably
missing a `#include` or some type definitions.

Finally, you can now ⌘-click (Mac) or ctrl-click (Windows, Linux) on symbol
names to jump to their definitions in your code - for instance, on a `#define` to
see its value, or on a struct to see its definition.

We appreciate your feedback! Please let us know by commenting here or emailing
us at <cloudpebble@getpebble.com>.

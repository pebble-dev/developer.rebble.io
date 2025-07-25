---
title: API documentation now inside CloudPebble
author: katharine
tags:
- Freshly Baked
- CloudPebble
---

To help make your Pebble development experience even better, CloudPebble can now display the API
documentation for any function directly in the editor view.



First up, a brief summary of each function now appears at the bottom of the autocomplete popup,
explaining the purpose of that function. This could help you remember, for instance, whether you
wanted to set a layer's *bounds* or *frame*.

![autocomplete summary view](/images/blog/cloudpebble-autocomplete-fn-summary.png)

For more detail on any API function, you can hold down the 'alt' key (or 'option' on Macs) and
click the function's name, which will show a popover including a description of the function,
explanations of its parameters and return values, and any important considerations when using it:

![property_animation_create_layer_frame popover](/images/blog/cloudpebble-api-popover.png)

This popover can be dismissed by clicking elsewhere or hitting the Escape key.

In addition to alt-clicking, you can also produce this popover using a keyboard shortcut. If you
are using a mac, that shortcut is cmd-ctrl-shift-/ (which is the same as cmd-ctrl-? on US/UK keyboards).
Otherwise, use ctrl-alt-shift-/ (or ctrl-alt-?). A popover explaining the function your caret is
inside will appear:

![window_long_click_subscribe popover](/images/blog/cloudpebble-api-popover-keyboard.png)

Again, this can be dismissed using the Escape key or by clicking elsewhere.

We hope this makes creating apps for Pebble easier and more enjoyable. And if you have suggestions on how
we can make your development experience better, let us know
[on GitHub](https://github.com/CloudPebble/CloudPebble/issues?state=open)!

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

title: App Assets
description: |
  A collection of assets for use as resources in Pebble apps.
guide_group: app-resources
order: 1
---

This guide contains some resources available for developers to use in their apps
to improve consistency, as well as for convenience. For example, most
``ActionBarLayer`` implementations will require at least one of the common icons
given below.


## Pebble Timeline Pin Icons

Many timeline pin icons 
[are available]({{ site.links.s3_assets }}/assets/other/pebble-timeline-icons-pdc.zip) 
in Pebble Draw Command or PDC format (as described in 
{% guide_link graphics-and-animations/vector-graphics %}) for use in watchfaces
and watchapps. These are useful in many kinds of generic apps.


## Example PDC icon SVG Files

Many of the system PDC animations are available for use in watchfaces and
watchapps as part of the 
[`pdc-sequence`](https://github.com/pebble-examples/pdc-sequence/tree/master/resources) 
example project.


## Example Action Bar Icons

There is a 
[set of example icons](https://s3.amazonaws.com/developer.getpebble.com/assets/other/actionbar-icons.zip) 
for developers to use for common actions. Each icon is shown below as a preview,
along with a short description about its suggested usage.

| Preview | Description |
|---------|-------------|
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_check.png) | Check mark for confirmation actions. |
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_dismiss.png) | Cross mark for dismiss, cancel, or decline actions. |
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_up.png) | Up arrow for navigating or scrolling upwards. |
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_down.png) | Down arrow for navigating or scrolling downwards. |
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_edit.png) | Pencil icon for edit actions. |
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_delete.png) | Trash can icon for delete actions. |
| ![](/images/guides/design-and-interaction/icons/action_bar_icon_snooze.png) | Stylized 'zzz' for snooze actions. |
| ![](/images/guides/design-and-interaction/icons/music_icon_ellipsis.png) | Ellipsis to suggest further information or actions are available. |
| ![](/images/guides/design-and-interaction/icons/music_icon_play.png) | Common icon for play actions. |
| ![](/images/guides/design-and-interaction/icons/music_icon_pause.png) | Common icon for pause actions. |
| ![](/images/guides/design-and-interaction/icons/music_icon_skip_forward.png) | Common icon for skip forward actions. |
| ![](/images/guides/design-and-interaction/icons/music_icon_skip_backward.png) | Common icon for skip backward actions. |
| ![](/images/guides/design-and-interaction/icons/music_icon_volume_up.png) | Common icon for raising volume. |
| ![](/images/guides/design-and-interaction/icons/music_icon_volume_down.png) | Common icon for lowering volume. |

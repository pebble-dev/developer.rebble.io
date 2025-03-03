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

title: Introducing Clay - App configuration made easy
author: keegan
tags:
- Freshly Baked
---

It is with great pleasure that I present to you, Clay, a Pebble package that makes it easy to add offline configuration pages to your Pebble apps. All you need to get started is a couple lines of JavaScript and a JSON file; no servers, HTML or CSS required.



![Clay Example](/images/blog/2016-06-24-introducing-clay/clay-example.png =421)

## How to get started

This post aims to provide high level explanation of how the framework works and how it came to be. Below is a quick overview of how easy it is to make your app configurable with Clay. If you would like to learn how to integrate Clay into your project, read our guide on [app configuration](/guides/user-interfaces/app-configuration/) or read the full documentation on the project [GitHub repository.](https://github.com/pebble/clay#clay)

**1) Install the module via [Pebble Packages](/guides/pebble-packages/using-packages/)**
 - SDK: `$ pebble package install pebble-clay`
 - CloudPebble: Add `pebble-clay`, version `^1.0.0` to your project dependencies.

**2) Create a configuration file that looks something like:**

```js
module.exports = [
  {
    "type": "heading",
    "defaultValue": "Example App"
  },
  {
    "type": "section",
    "items": [
      {
        "type": "color",
        "messageKey": "BackgroundColor",
        "defaultValue": "0x000000",
        "label": "Background Color"
      },
      {
        "type": "toggle",
        "messageKey": "Animations",
        "label": "Enable Animations",
        "defaultValue": false
      }
    ]
  },
  {
    "type": "submit",
    "defaultValue": "Save Settings"
  }
];
```

**3) Update your project settings with the matching `messageKeys` from the config above.**

**4) Add a few lines to your `index.js`**

```js
var Clay = require('pebble-clay');
var clayConfig = require('./config');
var clay = new Clay(clayConfig);
```

**5) Retrieve the values on the C side using standard [app messages](/guides/communication/sending-and-receiving-data/) or alternatively let [enamel](https://github.com/gregoiresage/enamel) do the work for you.**


## Why I created Clay

Clay began as a side project of mine. Whilst developing my [Segment watchface](https://apps.rebble.io/applications/560ae4754d43a36393000001), I wanted to add a configuration page to allow users to customize the colors of the watchface. However, I soon discovered this process to be rather fiddly. The old way of doing things required you to create and host HTML pages even for simple things like changing a background color or toggling an option. You would also need to write a bunch of boilerplate JavaScript to serialize and send the settings to the watch. Best case, for developers, this is super tedious. Worst case, it is terrifying. By day, I work as a web developer (mainly front-end) so if I was finding the process tiresome, I could only imagine how challenging it would be for someone who wasn't familiar with web technologies. And so I decided to create a framework that would alleviate this barrier for developers. I had a number of requirements that needed to be met in order for the framework to achieve my goals:

 - It should not require developers to write any HTML or CSS.
 - It should use JSON to define the generated config page.
 - It should all work offline
 - Developers should be able to add interactivity to the config page without manually manipulating DOM.
 - Developers should be able to create and share their own custom components.
 - The config page should be able to be versioned with the rest of the code in the project.
 - It should have extensive unit tests with 100% test coverage.


## How Clay Actually Works

Clay has two main components. The first is a very long string that is compiled from all the HTML, CSS and JavaScript that forms the skeleton of the generated config page. The second is the module that gets included in your `index.js`. This module is in charge of bundling all the dynamic elements set by the developer into a format that can be opened using `Pebble.openURL()`. It is also in charge of listening for the `webviewclosed` event and persisting the user's settings to local storage. I use Gulp and a series of Browserify transforms to compile all these components into a single module. The advantage of using a system such as Browserify, is that later, Clay can be made into a stand alone module to be used by developers who have very advanced use cases that require Clay to be run in a hosted HTML page.

The most challenging item on the requirements list was making the whole thing work offline. Neither of the Pebble mobile apps allow file system access from the config page's webview, so I had to get a little creative. It turns out that [Data URIs](https://en.wikipedia.org/wiki/Data_URI_scheme) work with more than images. You can in fact encode an entire HTML page into the URI. This was the solution to making the config pages offline. It sounds crazy but this method actually provides other advantages for developers beyond offline access. By bundling all the HTML, CSS and JavaScript into the Clay package, the version of Clay being used by the developer will not change without the developer rebuilding their app. This means developers do not need to worry about the behavior of their app's configuration page potentially breaking as new versions of Clay get released.


## Advanced Use

If developers want to add additional functionality to their config page, they can. Clay allows developers to inject, what I call a [`custom function`](https://github.com/pebble/clay#custom-function) into the generated config page. This allows developers control of their config page without needing to manipulate the DOM. Clay achieves this by exposing an API that provides a consistent way of interacting with the config page as well as making AJAX requests. Instead of manually updating the values of HTML elements, developers can use the much simpler Clay API.


## Where to find more information

 - [App configuration guide.](/guides/user-interfaces/app-configuration/)
 - [Clay GitHub repository including full documentation.](https://github.com/pebble/clay)
 - Chat to us in the `#clay` channel on [Discord]({{ site.links.discord_invite }}).
 - Visit the [Pebble Forums](https://forums.rebble.io/)
 - Tweet at [@pebbledev](https://twitter.com/pebbledev)


## How to get involved

Clay is open source and welcomes pull requests from anybody. Have a look at the [contributing guide](https://github.com/pebble/clay/blob/master/CONTRIBUTING.md) for instructions on how you can help make Clay even better. Regardless of your skill level, if you have any ideas on how Clay could be improved or if you find any bugs, we would love you to [submit an issue on GitHub](https://github.com/pebble/clay/issues/new).

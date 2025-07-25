---
title: Pebble and the Wolfram Cloud
author: Arnoud Buzing, Wolfram Research
tags:
- At the Pub
date: 2015-01-16
banner: /images/blog/pebble-and-wolfram/wolfram-photo.jpg
---

> This is a guest blog post by Arnoud Buzing at Wolfram Research about how to use
the power of the Wolfram Cloud in a Pebble watchapp. You can find out more
information about the Wolfram Cloud in the links posted throughout the post.
Enjoy!

Greetings!

In this post I will describe how to create an app for the [Pebble watch][1] that
uses the [Wolfram Cloud][2].

The Wolfram Cloud offers an integrated solution for data storage and 
knowledge-based computing using the Wolfram Language, a high level programming 
language. Specifically in this post, I will use so-called 'instant APIs' which
allows you to associate an arbitrary Wolfram Language computation with a
uniquely generated URL (we call them 'Cloud Objects'). This means that you can
use any function from the Wolfram Language
[(over 5,000 high level functions)](http://reference.wolfram.com/language/) and 
any Wolfram|Alpha functionality (including all data from its underlying Wolfram
Knowledgebase) and expose this in your Pebble app.

So let's get started by making a sample app!




First let's look at the user interface of this app and how to navigate to the
various elements. The app opens with a splash screen listing its app title and
which action to take to continue ('Press SELECT'):

![splash >{pebble-screenshot,pebble-screenshot--steel-stainless}](/images/blog/pebble-and-wolfram/pebble001.png)

Upon pressing SELECT (the middle button on the right-hand side of the Pebble
watch), you are offered a menu list with seven choices. You can scroll to each
choice by using the UP and DOWN buttons (also on the right-hand side of the
Pebble watch). Here is a table of images of each menu item and the result window
that is shown when a particular menu item is selected (with the SELECT button).

| Menu Selection | Result of Computation |
|----------------|-----------------------|
| ![date](/images/blog/pebble-and-wolfram/pebble002.png)| ![date2](/images/blog/pebble-and-wolfram/pebble009.png) |
| ![ip](/images/blog/pebble-and-wolfram/pebble003.png) | ![ip2](/images/blog/pebble-and-wolfram/pebble010.png) |
| ![location](/images/blog/pebble-and-wolfram/pebble004.png) | ![location2](/images/blog/pebble-and-wolfram/pebble011.png) |
| ![temperature](/images/blog/pebble-and-wolfram/pebble005.png) | ![temperature2](/images/blog/pebble-and-wolfram/pebble012.png) |
| ![version](/images/blog/pebble-and-wolfram/pebble006.png) | ![version2](/images/blog/pebble-and-wolfram/pebble013.png) |
| ![sunset](/images/blog/pebble-and-wolfram/pebble007.png) | ![sunset2](/images/blog/pebble-and-wolfram/pebble014.png) |
| ![stock](/images/blog/pebble-and-wolfram/pebble008.png) | ![stock2](/images/blog/pebble-and-wolfram/pebble015.png) |

So now we need to create Wolfram Cloud 'instant API' calls for each of the
individual menu items. I will show one example here, the remaining six are
similar and the full source code can be obtained from this URL (cloud object):
[https://www.wolframcloud.com/objects/c68a118b-ad29-4ebf-b330-d1f4549d8ecb][20].

This utility function creates a named cloud object (using `name`) and an
expression you want it to execute, like `DateString[]`:

```text
Attributes[CreateCloudObject]={HoldAllComplete};
CreateCloudObject[name_String,expr_]:=Module[{cloudObject,apiFunction},
  cloudObject=CloudObject["pebble/"<>name];
  apiFunction=APIFunction[{},ExportForm[{"result" ->ToString[expr]}, "JSON"] &];
  CloudDeploy[apiFunction, cloudObject, Permissions -> "Public"]
]
```

Then for each menu item you create one cloud 'instant API' function:

```text
CreateCloudObject["date",DateString[]]
```

That's all the code that it required on the Wolfram Cloud side.

Next, we need to write the app for the Pebble. Pebble provides an online cloud
IDE for this called [CloudPebble]({{ site.links.cloudpebble }}). One of the
options is the use [Pebble.js](https://pebble.github.io/pebblejs/), a javascript
environment which Pebble uses to control a binary application that is executed
on the watch.

The full javascript source code is included at the bottom of this post.
Here are a few key highlights of this implementation.

First import the required libraries and set the base URL for all the cloud
calls:

```js
var ui = require('ui');
var ajax = require('ajax');
var base = 'https://www.wolframcloud.com/objects/user-7053ce31-817f-4643-aec1-eda27051bba6/pebble/';
```

Define the splash card (window) and show it on the watch:

```js
var main = new ui.Card({
  title: ' Wolfram',
  icon: 'images/wolfram.png',
  subtitle: 'Cloud App',
  body: 'Press SELECT' 
});

main.show();
```

This code is part of the SELECT click handler and defines the menu that is shown
to the user:

```js
var menu = new ui.Menu({
  sections: [{
    items: [
      { title: 'DateString[]', subtitle: 'get the date' }, 
      { title: '$RequesterAddress', subtitle: 'get the ip' }, 
      { title: '$GeoLocation', subtitle: 'get the location' }, 
      { title: 'WeatherData[]', subtitle: 'get the temperature' }, 
      { title: '$Version', subtitle: 'get the version' },
      { title: 'Sunset[]', subtitle: 'get the sunset' }, 
      { title: 'FinancialData', subtitle: 'get a stock' }]
  }]
});

menu.show();
```

This code is executed when the user selects a given menu item:

```js
switch(e.itemIndex) {
  case 0: displayResults( base + 'date', 'DateString[]' ); break;
  case 1: displayResults( base + 'address', '$RequesterAddress' ); break;
  case 2: displayResults( base + 'location', '$GeoLocation' ); break;
  case 3: displayResults( base + 'weather', 'WeatherData[Here,"Temperature"]' ); break;
  case 4: displayResults( base + 'version', '$Version'); break;
  case 5: displayResults( base + 'sunset', 'Sunset[]'); break;
  case 6: displayResults( base + 'stock', 'FinancialData["GE"]'); break;
  default: console.log('e.itemIndex is out of bounds: ' + e.itemIndex);
} 
```

The `displayResults` function is a function which shows a temporary 'Loading'
card and then retrieves the cloud 'instant API' result from the cloud and
displays it:

```js
function displayResults(url, title) {
  var wait = new ui.Card({title: 'Loading...', subtitle: 'Please wait'});
  wait.show();
  ajax( { url: url, type:'json' }, 
    // success
    function(json) {
      var result = new ui.Card({ title: title, body: json.result });
      result.show();
      wait.hide();
    }, 
    // error
    function(error) {
      console.log('Error during displayResults');
      console.log(url);
      console.log(title);
    });
}
```

And that's it! You can now upload the app to your watch from the Pebble cloud
IDE and make calls to the Wolfram Cloud! And it's easy to completely customize
it with any Wolfram Language function you find useful.

And finally, here is the complete Pebble.js 
[source code](/assets/other/wolfram-source.js) for this sample project:

```js
var ui = require('ui');
var ajax = require('ajax');

var base = 'https://www.wolframcloud.com/objects/user-7053ce31-817f-4643-aec1-eda27051bba6/pebble/';

var main = new ui.Card({
  title: ' Wolfram',
  icon: 'images/wolfram.png',
  subtitle: 'Cloud App',
  body: 'Press SELECT'
});

main.show();

main.on('click', 'select', function(e) {
  var menu = new ui.Menu({
    sections: [{
      items: [
        { title: 'DateString[]', subtitle: 'get the date' }, 
        { title: '$RequesterAddress', subtitle: 'get the ip' }, 
        { title: '$GeoLocation', subtitle: 'get the location' }, 
        { title: 'WeatherData[]', subtitle: 'get the temperature' }, 
        { title: '$Version', subtitle: 'get the version' },
        { title: 'Sunset[]', subtitle: 'get the sunset' }, 
        { title: 'FinancialData', subtitle: 'get a stock' }]
    }]
  });

  menu.show();
  
  menu.on('select', function(e) {
    switch(e.itemIndex) {
      case 0: displayResults( base + 'date', 'DateString[]' ); break;
      case 1: displayResults( base + 'address', '$RequesterAddress' ); break;
      case 2: displayResults( base + 'location', '$GeoLocation' ); break;
      case 3: displayResults( base + 'weather', 'WeatherData[Here,"Temperature"]' ); break;
      case 4: displayResults( base + 'version', '$Version'); break;
      case 5: displayResults( base + 'sunset', 'Sunset[]'); break;
      case 6: displayResults( base + 'stock', 'FinancialData["GE"]'); break;
      default: 
        console.log('e.itemIndex is out of bounds: ' + e.itemIndex);
    } 
  });
});

function displayResults(url, title) {
  var wait = new ui.Card({title: 'Loading...', subtitle: 'Please wait'});
  wait.show();
  ajax( { url: url, type:'json' }, 
    // success
    function(json) {
      var result = new ui.Card({ title: title, body: json.result });
      result.show();
      wait.hide();
    }, 
    // error
    function(error) {
      console.log('Error during displayResults');
      console.log(url);
      console.log(title);
    });
}
```

[1]: {{ site.links.pebble }}/
[2]: http://www.wolfram.com/cloud/
[20]: https://www.wolframcloud.com/objects/c68a118b-ad29-4ebf-b330-d1f4549d8ecb

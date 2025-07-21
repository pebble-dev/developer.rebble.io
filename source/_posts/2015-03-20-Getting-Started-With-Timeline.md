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

title: Getting Started With Timeline
author: kirby
tags:
- Timeline
date: 2015-03-20
banner: /images/blog/getting-started-timeline.png
---

The new timeline interface is a completely new way to have users interact with
your app. The Pebble SDK along with timeline web APIs allows you to push pins to 
your users' Pebbles. Adding pins to timeline is a straightforward process. This 
guide will walk you through the steps from start to finish.



## The Project

We're going to build an app that lets users track their packages. We'll place pins
on the timeline for each package. For simplicity, we'll use the [Slice API](https://developer.slice.com/)
to get information about our packages. We'll go over the specifics of how to:

- Use the [PebbleKit JS timeline APIs](/guides/pebble-timeline/timeline-js/)
- Setup a server that utilizes the [pebble-api](https://www.npmjs.com/package/pebble-api)
npm module
- Enable timeline for the app through the [Developer Portal]({{ site.links.devportal }})

## Setup

Before we dive into the timeline specifics of this app we'll first need to build
a typical Pebble app. I won't spend much time on how to build a basic Pebble app;
there are plenty of [guides](/guides/) for that.

In order to get setup with Slice follow their [Hello World example](https://developer.slice.com/docs/hello).
After you have your OAuth token it is easy to make a request to their 
[shipments endpoint](https://developer.slice.com/docs/resources#res_shipments)
and get a JSON array of all your shipments. For example:

```bash
$ curl -X GET --header 'Authorization: XXXXXXXXXXXXXXXXXXXXXXXXXX' \
    https://api.slice.com/api/v1/shipments

# response
{
  "result": [
    {
      "status": {
        "code": 3,
        "description": "DELIVERED"
      },
      "updateTime": 1426785379000,
      "shipper": {...},
      "description": "Dockers Pants, Tapered Fit Alpha Khaki Flat Front Dark Pebble 34x32",
      "receivedDate": "2015-03-20",
      "receivedShare": null,
      "trackingUrl": "https://tools.usps.com/go/TrackConfirmAction.action?tLabels=9261299998829554536102",
      "shares": [...],
      "merchantTrackingUrl": null,
      "emails": [...],
      "href": "https://api.slice.com/api/v1/shipments/2689846985907082329",
      "shippingDate": "2015-03-17",
      "items": [...],
      "shippingEstimate": {...},
      "trackingNumber": "9261299998829554536102",
      "deliveryEstimate": {
        "maxDate": "2015-03-20",
        "minDate": "2015-03-20"
      },
      "destinationAddress": {...},
      "history": [...]
    }, ...
  ]
}
```

Our app will be pretty simple. We'll use ``AppSync`` to load a ``MenuLayer`` with
a list of packages that we get from Slice.

![package tracker app >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/package-tracker.png)

Here is the source code to [timeline-package-tracker]({{site.links.examples_org}}/timeline-package-tracker/tree/7edde5caa0f6439d2a0ae9d30be183ace630a147)
without any timeline support.

> Note that this is just an example. In a real app, you'd never hard code an 
OAuth token into javascript, and you probably wouldn't arbitrarily limit your
app to have a 3 package limit.

## PebbleKit JS Timeline APIs

For our app we simply want to push each package as a pin to the timeline. Before
we can do this we need to get our user's timeline token. After we get the token
we'll need to send it to our own server. We'll also send our user's Slice oauth
token so that the server can keep up to date on all of their packages. From
there we can format a timeline pin with our package information and send it to
the user via their timeline token.

```js
var API_ROOT = 'YOUR_TIMELINE_SERVER';
var oauth    = 'XXXXXXXXXXXXXXXXXXXX'; // in a real app we'd use a configuration window

Pebble.addEventListener('ready', function() {
  doTimeline();
});

var doTimeline = function(packages) {
  Pebble.getTimelineToken(function (token) {
    sendToken(token, oauth);
  }, function (error) {
    console.log('Error getting timeline token: ' + error);
  });
};

var sendToken = function(token, oauth) {
  var request = new XMLHttpRequest();
  request.open('GET', API_ROOT + '/senduserpin/' + token + '/' + oauth, true); // send the user's timeline token and Slice oauth token to our server
  request.onload = function() {
    console.log('senduserpin server response: ' + request.responseText);
  };
  request.send();
}
```

> Note that we're currently talking to a server that doesn't exist yet! We'll
cover how to set that up next.

## Pebble Timeline Web APIs

We'll need a server of our own to talk to the Pebble timeline web APIs.
[Express](https://github.com/strongloop/express/) is a convenient and easy way
to get a server up and running quickly. It also allows us to utilize the 
[pebble-api](https://www.npmjs.com/package/pebble-api) npm module.

A basic Express server look like this:

```js
var express = require('express');
var request = require('request');

var Timeline = require('pebble-api');

var app = express();
app.set('port', (process.env.PORT || 5000));

var timeline = new Timeline();

app.get('/', function(req, res) {
  res.send('Hello, world!');
});

// start the webserver
var server = app.listen(app.get('port'), function () {
  console.log('Package Tracker server listening on port %s', app.get('port'));
});
```

We'll go ahead and include `request`, so that we can easily make requests to
Slice to get each user's package information. We'll also include the `pebble-api`
module too.

Now that we have a basic server up all we need to do is handle each request to
our server, fetch packages, and send pins. The `pebble-api` module will 
make it super easy to create our pins according to 
[spec](/guides/pebble-timeline/pin-structure/). 

```js
var users = {}; // This is a cheap "in-memory" database ;) Use mongo db in real life!

app.get('/senduserpin/:userToken/:oauth', function(req, res) {
  var userToken = req.params.userToken;
  var oauth     = req.params.oauth;

  users[userToken] = {};
  users[userToken]['oauth'] = oauth; // store user
  users[userToken]['packages'] = [];

  res.send('Success');
});

// every 5 minutes check for new packages for all users
setInterval(function() {
  Object.keys(users).forEach(function(user) {
    var userToken = user;
    var oauth     = users[user]['oauth'];
    getPackages(oauth, userToken);
  });
}, 300000);

var getPackages = function(oauth, userToken) {
  var options = {
      url: 'https://api.slice.com/api/v1/shipments',
      headers: { 'Authorization': oauth }
  };
  
  request(options, function(error, response, body) {
    var response = JSON.parse(body);
    var pkgs = getCurrentPackages(response.result);
    pkgs.forEach(function(pkg) {
      var found = false;
      users[userToken]['packages'].forEach(function(oldPkg) { // check if pkg is new or not
        if(oldPkg.id === pkg.id) {
          found = true;
        }
      });
      if(!found) {
        users[userToken]['packages'].push(pkg) // we have a new package, save it
        sendPin(pkg, userToken); // and send it as a pin
      }
    });
  });
};

// slice returns every package we've ever ordered. Let's just get the ones from the past week.
var getCurrentPackages = function(pkgs) {
  current = [];
  var oneWeekAgo = (new Date).getTime() - 604800000;
  pkgs.forEach(function(pkg) {
    if(pkg.updateTime > oneWeekAgo) {
      current.push({'name': pkg.description, 'date': pkg.shippingEstimate.minDate, 'id': pkg.trackingNumber});
    }
  });
  return current.slice(0, 3);
};

var sendPin = function(pkg, userToken) {
  var pin = new Timeline.Pin({
    id: pkg.id,
    time: new Date(Date.parse(pkg.date) + 43200000), // will always be noon the day of delivery
    layout: new Timeline.Pin.Layout({
      type: Timeline.Pin.LayoutType.GENERIC_PIN,
      tinyIcon: Timeline.Pin.Icon.MAIL,
      title: pkg.name
    })
  });

  timeline.sendUserPin(userToken, pin, function (err, body, resp) {
    if(err) {
      return console.error(err);
    }
  });
};
```

This will accept GET requests from our Pebble app, and will then store each user
in memory. From there it checks every 5 minutes for new packages, and if they exist
creates a pin for them. Since the carrier only tells us the date the package will
be delivered, we arbitrarily set the time of the pin to noon.

> Note in this current implementation users are stored in memory. A better
implementation would store packages in a database.

## Enable Timeline in the Developer Portal

We have almost everything setup, but our app won't work correctly with the
timeline web APIs until we upload the app's pbw to the Pebble Developer Portal
and enable timeline.

In order to enable timeline, perform the following steps:

0. Make sure you have a new and unique uuid. If you used the example from GitHub you will have to change it in your `appinfo.json`. To generate a new UUID, [you can use this tool](https://www.uuidgenerator.net/version4)
1. Login to the [Developer Portal]({{ site.links.devportal }})
2. Click the Add Watchapp button on the portal (you don't need to upload any image assets)
3. Upload your pbw by adding a release (located in the build folder of your project)
4. Click the Enable Timeline button

And then you're done!

![package tracker pin >{pebble-screenshot,pebble-screenshot--time-red}](/images/blog/package-tracker-pin.png)

Checkout the full source code on [Github]({{site.links.examples_org}}/timeline-package-tracker/).

> **Further Reading on Pebble Timeline**
>
> For more information, we suggest you take a look at the [timeline guides](/guides/pebble-timeline/)
as well as the [hello-timeline]({{site.links.examples_org}}/hello-timeline)
and the [timeline-tv-tracker]({{site.links.examples_org}}/timeline-tv-tracker)
examples. They are all great resources to make the most of timeline!

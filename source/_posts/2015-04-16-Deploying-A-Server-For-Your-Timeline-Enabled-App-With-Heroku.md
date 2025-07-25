---
title: Deploying A Server For Your Timeline Enabled App With Heroku
author: kirby
tags:
- Timeline
date: 2015-04-16
banner: /images/blog/deploying-server-header.png
---

Pins are a new and intuitive way for your users to interact with your app via
the Pebble timeline. In a previous [blog post](/blog/2015/03/20/Getting-Started-With-Timeline/)
I went through a complete walkthrough on how to get started with timeline. This
post will focus on one single part of that process; how to deploy a server with
[Heroku](https://www.heroku.com/), run jobs with [Scheduler](https://addons.heroku.com/scheduler),
and how to build APIs that push pins with the [Express](https://www.npmjs.com/package/express)
and [pebble-api](https://www.npmjs.com/package/pebble-api) node modules.



## Prerequisites

There are few things we’ll need to set up before we can deploy our server

- An account with [Heroku](https://signup.heroku.com/)
- The [Heroku Toolbelt](https://toolbelt.heroku.com/)
- [Node and npm](https://nodejs.org/download/) installed


## The Project

This time around we'll discuss how to deploy a server to push pins as part of
your app experience. We'll utilize [Heroku](https://www.heroku.com/) for this
tutorial, because they make it super simple to deploy a server up to the cloud.
Our server will run Node.js with the `Express` npm module to serve our HTTP
endpoints. This allows us to utilize the [pebble-api](https://www.npmjs.com/package/pebble-api)
npm module which makes it super easy to create pins and push them to our users.

## Why Do I Need My Own Server?

With the addition of timeline to the Pebble SDK developers are now encouraged to
enhance their applications by running their own servers that bridge
communication between their users' Pebble and the timeline web API.

![timeline architecture](/images/guides/3.0/timeline-architecture.png)

This type of architecture allows you to do more for your users. Some of the
things you can now do include:

- Push pins to users without your app running
- Push pins to all users
- Store user data (like preferences) in the cloud

> Of course you aren't required to use a server to talk to the timeline web API,
you can make requests directly via PebbleKit JS. A great example of this is the
[timeline-push-pin]({{site.links.examples_org}}/timeline-push-pin) app. This
approach allows an app to push pins to just the specific user. You can also use
it to push shared pins to topics, but this will require storing the app's
production API key in the JS, which we advise against.

## Setup A Simple Webserver

The following commands will create a folder, create a file called `server.js`,
create a file called `package.json`, install the Express and pebble-api modules
and add them to list of dependencies in `package.json`.

```bash
$ mkdir node
$ cd node
$ touch server.js
$ npm init  # all of the default options are fine
$ npm install express pebble-api --save
```

In order to talk to the timeline web API, you need to obtain an API key from the
[Developer Portal](https://dev-portal.getpebble.com/). Once you've obtained the
API key you need to set it as an environment variable, so the `pebble-api` npm
module can use it.

```bash
$ export PEBBLE_TIMELINE_API_KEY=XXXXXXXXXXXXXXX # make sure to use your actual API key
```

Open `server.js` in your favorite editor and paste the following:

```js
var express = require('express');  // import the express module

var Timeline = require('pebble-api');

// create a new Timeline object with our API key passed as an environment variable
var timeline = new Timeline();

var app = express(); // create an express instance
app.set('port', (process.env.PORT || 5000)); // set the port on the instance

// push a pin to :userToken from our webservice
app.get('/senduserpin/:userToken', function(req, res) {
  var userToken = req.params.userToken;

  var pin = new Timeline.Pin({
    id: parseInt(Math.random() * (999999 - 100000) + 100000).toString(), // random pin id
    time: new Date(new Date().getTime() + 60*60*1000), // current date and time plus 1 hour
    layout: new Timeline.Pin.Layout({
      type: Timeline.Pin.LayoutType.GENERIC_PIN,
      tinyIcon: Timeline.Pin.Icon.PIN,
      title: 'Pin from Heroku!'
    })
  });

  timeline.sendUserPin(userToken, pin, function (err, body, resp) {
    if(err) {
      res.status(400);
      res.send(err);
    } else {
      res.send('Pin successfully pushed!');
    }
  });
});

// start the webserver
var server = app.listen(app.get('port'), function () {
  console.log('Package Tracker server listening on port %s', app.get('port'));
});
```

When you run `node server.js` this creates a super simple webserver. When a request
is made to `https://localhost:5000/senduserpin/<pebble_user_token>` that will
send a pin to that user's Pebble saying "Pin from Heroku!" You can test this
locally by visiting [http://localhost:5000/senduserpin/yourtoken](http://localhost:5000/senduserpin/yourtoken)
in your browser.

> Make sure to replace "yourtoken" with your actual token in the above link!

## Commit, Push, Deploy

From here we can initialize a `git` repository, and commit our code so that we
push our code to Heroku.

```bash
$ git init
$ git add .
$ git commit -m 'First commit'
```

> I would suggest adding a `.gitignore` file that ignores the `node_modules`
folder. [Here](https://www.gitignore.io/api/node) is a good one.

Let's create a Heroku app and connect it to our repo.

```bash
$ heroku create
```

> Since we initalize our repo before we created our Heroku app, the Heroku
Toolbelt will automatically add a git remote to Heroku's servers.

Now we just need to push our app to Heroku!

```bash
$ git push heroku master
```

This will push our repo to Heroku, where they'll take care of configuring the
server, running our Node.js application, etc.

Before our server will work we need to set the timeline web API key environment
variable on Heroku.

```bash
$ heroku config:set PEBBLE_TIMELINE_API_KEY=XXXXXXXXXXXXXXX # make sure to use your actual API key
```

You can check out your server by running:

```bash
$ heroku open
```

This will take you somewhere like `https://<your_app>.herokuapp.com`. Like in
the local example, you can append `/senduserpin/yourtoken` to push a pin your
Pebble.

## Pushing Nested Folders to Heroku

Often you'll want to keep both your server and your Pebble app in the same
folder. The best way to do this is to have two separate folders, one for the
server and one for the Pebble app, with in another folder. A great example is
the [Timeline TV Tracker]({{site.links.examples_org}}/timeline-tv-tracker).

This poses a problem, because Heroku expects our application to be in the root
of our git repo. To resolve this problem instead of running `git push heroku master`
run

```bash
$ git subtree push --prefix <server folder> heroku master
```

> You can read more about git-subtree by reading the official
[documentation](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt).

## Heroku Scheduler

Sometimes your server will need to run some periodic task. For example the
[Timeline Package Tracker]({{site.links.examples_org}}/timeline-package-tracker)
checks to see if users have any new packages every 5 minutes. The Timeline
Package Tracker accomplishes this by using [`setInterval`]({{site.links.examples_org}}/timeline-package-tracker/blob/master/server/server.js#L24).
Unfortunately this will not work on Heroku, because Heroku goes to sleep after
60 minutes of inactivity.

We can fix this by utilizing [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler)
which lets us run abritrary jobs on a scheduled basis. We can create a small
JavaScript file that we can run periodically. We'll need to put this in a local
`bin` directory so that Heroku knows where to find it.

```bash
$ mkdir bin
$ touch bin/pushTopicPins
```

In your favorite text editor put the following in `pushTopicPins`.

```js
#!/usr/bin/env node

var Timeline = require('pebble-api');

function pushTopicPins() {
  // create a new Timeline object with our API key passed as an environment variable
  var timeline = new Timeline();

  var pin = new Timeline.Pin({
    id: parseInt(Math.random() * (999999 - 100000) + 100000).toString(), // random pin id
    time: new Date(), // current date and time
    layout: new Timeline.Pin.Layout({
      type: Timeline.Pin.LayoutType.GENERIC_PIN,
      tinyIcon: Timeline.Pin.Icon.PIN,
      title: 'Another pin about a topic from Heroku!'
    })
  });

  timeline.sendSharedPin(['some_topic'], pin, function (err, body, resp) {
    if(err) {
      console.error(err);
    }
  });
}
pushTopicPins();
```

> In order to leverage the `pebble-api` npm module you need to set `PEBBLE_TIMELINE_API_KEY`
with your timeline API key.

Everytime this script is run it will push a pin to every user

Add it to your git remote, push, and test it:

```bash
$ git add bin
$ git commit -m 'Add pushTopicPins job'
$ git push heroku master
$ heroku run pushTopicPins
```

To schedule the job we first need to add the Scheduler addon:

```bash
$ heroku addons:add scheduler:standard
```

Then we can schedule the job to run through the dashboard:

```bash
$ heroku addons:open scheduler
```

Heroku makes it easy to see all of the logs for your app in one place. This
includes information about each time a job is run.

```bash
$ heroku logs
```

> Note, Heroku is free until you exceed 750 dyno-hours per month. If you're
running jobs that take a very long time you could potentially exceed that limit.
For more information check out their [Usage & Billing](https://devcenter.heroku.com/articles/usage-and-billing)
article.

## Conclusion

This tutorial should help you hit the ground running when deploying your first
server for timeline. I highly encourage you to try and deploy the [Timeline TV Tracker]({{site.links.examples_org}}/timeline-tv-tracker)
and see how it all works together.

Have questions or want to share something awesome you've made for Pebble?
Contact at us on twitter [@pebbledev](https://twitter.com/pebbledev/) or 
[share your project](/contact).

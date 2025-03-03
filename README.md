# [developer.rebble.io][site]

[![Build Status](https://magnum.travis-ci.com/pebble/developer.rebble.io.svg?token=HUQ9CCUxB447Nq1exrnd)][travis]

This is the repository for the [Pebble Developer website][site].

The website is built using [Jekyll](http://jekyllrb.com) with some plugins that
provide custom functionality.

For anyone who wants to contribute to the content of the site, you should find
the information in one of the sections below.

* [Blog Posts](#blog-posts)
* [Markdown](#markdown)
* [Landing Page Features](#landing-page-features)
* [Colors](#colors)

## Getting Started

Once you have cloned the project you will need to run `bundle install` to
install the Ruby dependencies. If you do not have [bundler](http://bundler.io/)
installed you will need to run `[sudo] gem install bundler` first.

You should also do `cp .env.sample .env` and edit the newly created `.env` file
with the appropriate values. Take a look at the
[Environment Variables documentation](/docs/environment.md) for more details.

To start the Jekyll web server, run `bundle exec jekyll serve`.

## JS Documentation

The PebbleKit JS and Rocky documentation is generated with the
[documentation.js](documentation.js.org) framework. The documentation tool can
create a JSON file from the JSDocs contained in the [js-docs](/js-docs)
folder.

To install documentation.js, run `npm install -g documentation`

To regenerate the `/source/_data/rocky-js.json` file, run `./scripts/generate-rocky-docs.sh`

> **NOTE**: This is intended to be a temporary hack. Ideally the rocky-js.json
> file is generated as part of the release generator (and built using the actual
> Rocky.js source, or stubs in the Tintin repository.

## Blog Posts

### Setting up a new author
Add your name to the `source/_data/authors.yml` so the blog knows who you are!

```
blogUsername:
  name: First Last
  photo: https://example.com/you.png
```

### Creating a new blog post
Add a Markdown file in `source/_posts/` with a filename in following the
format: `YYYY-MM-DD-Title-of-the-blog-most.md`.

Start the file with a block of YAML metadata:

```
---
title: Parlez-vous Pebble? Sprechen sie Pebble? ¿Hablas Pebble?
author: blogUsername
tags:
- Freshly Baked
---
```

You should pick one tag from this list:

* Freshly Baked - Posts announcing or talking about new features
* Beautiful Code - Posts about writing better code
* "#makeawesomehappen" - Hackathons/events/etc
* At the Pub - Guest Blog Posts (presumably written at a pub)
* Down the Rabbit Hole - How Pebble works 'on the inside'
* CloudPebble - Posts about CloudPebble
* Timeline - Posts about Timeline

### Setting the post's preview text

The blog's homepage will automatically generate a 'preview' of your blog post. It does this by finding the first set of 3 consecutive blank lines, and using everything before those lines as the preview.

You should aim to have your preview be 1-2 paragraphs, and end with a hook that causes the reader to want to click the 'Read More' link.

## Markdown

There is a [Markdown styleguide and additional syntax cheatsheat][markdown]
you should use if you are writing any Markdown for the site. That includes all
blog posts and guides.

## Landing Page Features

The landing page of the website contains a slideshow (powered by [slick][slick]).
The contents of the slideshow, or 'features' as we call them, are generated
from the features data file found at `source/_data/features.yaml`.

There are two main types of features, images and videos.

### Image Feature

```yaml
- title: Want to make your apps more internationally friendly?
  url: /guides/publishing-tools/i18n-guide/
  background_image: /images/landing-page/i18n-guide.png
  button_text: Read our brand new guide to find out how
  button_fg: black
  button_bg: yellow
  duration: 5000
```

It should be relatively clear what each of the fields is for. For the
`button_fg` and `button_bg` options, check out the [colors](#colors) section
for the available choices.

The `background_image` can either be a local asset file or an image on an
external web server.

**Please Remember:** The landing page will see a lot of traffic so you
should strive to keep image sizes small, while still maintaing relatively large
dimensions. Run the images through minifying tools, such as
[TinyPNG][tinypng] or [TinyJPG][tinyjpg], before commiting them to the site.

### Video Feature

```yaml
- title: Send a Smile with Android Actionable Notifications
  url: /blog/2014/12/19/Leverage-Android-Actionable-Notifications/
  background_image: /images/landing-page/actionable-notifications.png
  video:
    url: https://s3.amazonaws.com/developer.rebble.io/videos/actionable-notifications.mp4
  button_text: Learn how to supercharge Your Android Apps
  button_fg: white
  button_bg: green
  duration: 5000
```

To prevent massively bloating the size of this repository, we are hosting all
videos externally on S3. If you do not have permission to upload videos to our
S3 bucket, you will need to ask someone who does!

In order to enable to videos to play across all of the browsers + platforms,
you will need to provided the video in MP4, OGV and WEBM formats.
There is a script provided in the scripts folder to do the automatic conversion
from MP4, and to export the first frame of the video as a PNG used as a
placeholder while the video loads.

```sh
./scripts/video-encode.sh PATH_TO_MP4
```

If you run the script as above, it will create an OGV, WEBM and PNG file in the same folder as the MP4. The PNG file should go in the `/assets/images/landing-page/` folder, and the three video files should be uploaded to S3.

## Colors

Buttons and Alerts come are available in several different color options, with
both foreground and background modifier classes to give you maximum control.

The available colors:

* white
* green
* blue
* red
* purple
* yellow
* orange
* lightblue
* dark-red

To set the background, use `--bg-<COLOR>` modifier. To set the foreground (i.e)
the text color, use `--fg-<COLOR>`.

## Troubleshooting

Trouble building the developer site? Read the [Troubleshooting](/docs/troubleshooting.md) page for some possible solutions.

[site]: https://developer.rebble.io
[markdown]: ./docs/markdown.md
[slick]: http://kenwheeler.github.io/slick/
[tinypng]: https://tinypng.com/
[tinyjpg]: https://tinyjpg.com/
[travis]: https://magnum.travis-ci.com/pebble/developer.rebble.io

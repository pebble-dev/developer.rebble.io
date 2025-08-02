# Writing Markdown

If you are writing anything in Markdown for the Pebble Developer site, you
should read this guide to learn about some of the rules and enhancements that
the site has, beyond those of "standard Markdown".

## Styleguide

### 80 character lines

To keep your Markdown files readable and easy to review, please break all lines
at 80 characters.

*NOTE:* The line breaking does not affect the HTML output, this is purely to
keep the source files readable and reviewable.

### Headers

Use the `#`, `##` etc syntax for headers, and include a space after the hashes
and before the header text.

```
## Write Headers Like This

##Don't Write Them Like This

And Definitely Don't Do This
=======
```

You should also generally avoid using the top level header (`#`) because the
page that is displaying the content will be using the document title in a \<h1\>
tag automatically.

#### Table of Contents

If enabled, the table of contents for the document will include all headers on
the page.

You can enable/disable table of contents generation for a specific page in the
YAML metadata:

```
generate_toc: true
```

#### Anchors

All headers automatically have anchors attached to them, so you can easily link
to sections of the page. The ID for the header will be the slugized header text.

For example, `## Install Your App` will become `#install-your-app`.

### Blockcode

Use triple backticks for block code, and
[specify the language](http://pygments.org/languages/) to ensure the syntax is
highlighted correctly.

    ```js
    var foo = 'bar';
    ```


#### Click to Copy

By default, all code blocks will include the Click to Copy button in the
top right corner. If you want to disable it, prepend the language with `nc^`.

    ```nc^text
    This is not for copying!
    ```

### Images

In blog posts and guides, images will be block elements that are centered on
the page. *Plan accordingly.*

#### Size

You can control the width (and optionally height) of images using the following
syntax:

```
![Image with width](/images/huge_image.png =300)
![Image with width and height](/images/huge_image.png =300x400)
```

### HTML

Do not use HTML unless you **absolutely** have to. It is almost always better to
use Markdown so that we can more easily maintain a consistent style across the
site.

## Additional Syntax

### Buttons

To convert any link into a button simply append a `>` onto the end of the text.

```
[Button Text >](http://google.com/)
```

You can optionally pass extra button classes after the `>` to modify the style
of the button.

```
[Wide Orange Button >{wide,fg-orange}](http://google.com)
```

The available classes are:

* wide
* small
* center
* fg-COLOR
* bg-COLOR

*Where COLOR is any one of the [available colors](README.md#colors).*

### Link Data

To add additional data attributes to links (useful for outbound tracking),
append a `>` to the end of the link title, and format the content as below.

```
[Link Text](http://google.com "Link Title >{track-event:click,track-name:google}")
```

This will create a link with the attributes `data-track-event="click"` and
`data-track-name="google"`.

### SDK Documentation Links

If you wish to link to a section of the SDK documentation, you can do so using
double backticks. This can either be done to enhance existing inline code
or in the text of a link.

```
This will link to the ``window_create`` documentation.

You should check out the page on [Events](``event services``)
```

### Pebble Screenshots

If you want to provide a watch screenshot and have it displayed in a Pebble
wrapper, you should upload the 144x168 image and use the following syntax.

```
![ >{pebble-screenshot,pebble-screenshot--time-red}](/images/screenshot.png)
```

You can pick from any of the following screenshot wrappers:

* pebble-screenshot--black
* pebble-screenshot--white
* pebble-screenshot--red
* pebble-screenshot--gray
* pebble-screenshot--orange
* pebble-screenshot--steel-black
* pebble-screenshot--steel-stainless
* pebble-screenshot--snowy-black
* pebble-screenshot--snowy-red
* pebble-screenshot--snowy-white
* pebble-screenshot--time-round-black-20
* pebble-screenshot--time-round-red-14

The following screenshot classes exist, but the accompanying images are not
currently available. They will be aliased to black-20 or red-14 as size
dictates:

* pebble-screenshot--time-round-rosegold-14
* pebble-screenshot--time-round-silver-14
* pebble-screenshot--time-round-silver-20

> Please match the wrapper to the screenshot where possible. For example, do not
use an original Pebble wrapper with a color screenshot.

#### Screenshot Viewer

If you want to show matching screenshots across multiple platforms, you should use the new
`screenshot_viewer` tag.

Here is an example of it in use:

```
{% screenshot_viewer %}
{
  "image": "/images/guides/pebble-apps/display-animations/submenu.png",
  "platforms": [
    { "hw": "basalt", "wrapper": "time-red" },
    { "hw": "chalk", "wrapper": "time-round-red-14" }
  ]
}
{% endscreenshot_viewer %}
```

The URL to the image gets the hardware platform insert into it, so in order to make
the above example work, you should have two files with the following names:

```
/source/assets/images/guides/pebble-apps/display-animations/submenu~basalt.png
/source/assets/images/guides/pebble-apps/display-animations/submenu~chalk.png
```

### Alerts

Some information requires more prominent formatting than standard block notes.
Use the `alert` Liquid tag for this purpose. Both 'notice' (purple) and
'important' (dark red) are supported for appropriate levels of highlighting.
Some examples are below:

```
{% alert important %}
PebbleKit JS and PebbleKit Android/iOS may **not** be used in conjunction.
{% endalert %}
```

```
{% alert notice %}
This API is currently in the beta stage, and may be changed before final
release.
{% endalert %}
```

### Formatting

The following additional text formatting syntax is supported.

#### Strikethrough

```
This is some ~~terribly bad~~ amazingly good code.
```

#### Highlight

```
CloudPebble is ==extremely== good.
```

#### Tables

Tables are supported with the
[PHP Markdown syntax](https://michelf.ca/projects/php-markdown/extra/#table).

```
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
```

### Emoji

You can use emoji in your text by using the colon syntax.

```
If you're a beginner Pebble developer, you should use :cloud:Pebble
```

### Embedded Content

#### YouTube

To embed a YouTube video or playlist, use the standard link syntax with EMBED
as the link title.

```
You should check out this video on developing Pebble apps:
[EMBED](https://www.youtube.com/watch?v=LU_hPBhgjGQ)
```

#### Gist

To embed a GitHub Gist, use the standard link syntax with EMBED as the link
title.

```
Here is the Gist code.
[EMBED](https://gist.github.com/JaviSoto/5405969)
```

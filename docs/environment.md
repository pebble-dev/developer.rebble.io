# Environment Variables

The following environment variables are used in the generation of the site.

## URL

This overrides the `url` configuration parameter of Jeyll. Set this to the root
of where the site will be hosted.

```
URL=http://developer.rebble.io
```

## HTTPS_URL

This overrides the `https_url` configuration parameter of Jeyll. Set this to
the secure root of where the site will be hosted.

```
HTTPS_URL=https://developer.rebble.io
```

## PORT

The port on which the Jekyll server will listen. If you don't set this it will
default to port `4000`.

```
PORT=8000
```

## ASSET_PATH

This sets the `asset_path` configuration variable, which tells the site where
the assets are to be found.

During development and testing, this can be set to the relative URL of the
assets folder inside the main site.

For production, this should be set to the CDN where the assets will be uploaded.

*Note:* As of 8th January 2014, the production version of the site still used
local assets and not a CDN.

```
ASSET_PATH=assets/
```

## EXTERNAL_SERVER

This sets the `external_server` configuration variable, which tells the site the
location of the external server used for events, community blog and contact.

```
EXTERNAL_SERVER=https://developer-api.rebble.io
```

## DOCS_URL

The URL of the server on which the documentation sources are being built.

The production and staging values are private, so if you do not work for Pebble
you will have to omit it from the environment (or `.env` file). Sorry

## ALGOLIA_*

The site search is powered by [Algolia](https://algolia.com). There are four
environment variables that are required to turn on indexing at build time and
also correctly setup the client JS for searching. The production and staging
values can be found on our Algolia account.

If you do not work for Pebble, or don't care about testing the indexing, then
omit these values from the environment (or `.env` file) to disable Algolia.

The `ALGOLIA_PREFIX` value is extremely important. Make sure you set it if you
are enabling Algolia support on the site, and check that it matches the scoped
search key.

```
ALGOLIA_APP_ID=
ALGOLIA_API_KEY=
ALGOLIA_SEARCH_KEY=
ALGOLIA_PREFIX=
```

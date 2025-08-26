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

title: Internationalization
description: |
  How to localize an app to multiple languages.
guide_group: tools-and-resources
order: 5
---

When distributing an app in the Pebble appstore, it can be downloaded by Pebble
users all over the world. Depending on the app, this means that developers may
want to internationalize their apps for a varierty of different locales. The
locale is the region in the world in which the user may be using an app. The
strings used in the app to convey information should be available as
translations in locales where the app is used by speakers of a different
language. This is the process of localization. For example, users in France may
prefer to see an app in French, if the translation is available.


## Internationalization on Pebble

The Pebble SDK allows an app to be localized with the ``Internationalization``
API. Developers can use this to adjust how their app displays and behaves to
cater for users in non-English speaking countries. By default all apps are
assumed to be in English. Choose the user selected locale using
``i18n_get_system_locale()`` or to force one using ``setlocale()``.

> Note: The app's locale also affects ``strftime()``, which will output
> different strings for different languages. Bear in mind that these strings may
> be different lengths and use different character sets, so the app's layout
> should scale accordingly.


## Locales Supported By Pebble

This is the set of locales that are currently supported:

| Language | Region | Value returned by ``i18n_get_system_locale()`` |
|----------|--------|------------------------------------------------|
| English | United States | `"en_US"` |
| French | France | `"fr_FR"` |
| German | Germany | `"de_DE"` |
| Spanish | Spain | `"es_ES"` |
| Italian | Italy | `"it_IT"` |
| Portuguese | Portugal | `"pt_PT"` |
| Chinese | China | `"en_CN"` |
| Chinese | Taiwan | `"en_TW"` |


When the user's preferred language is set using the Pebble Time mobile app, the
required characters will be loaded onto Pebble and will be used by the
compatible system fonts. **This means that any custom fonts used should include
the necessary locale-specific characters in order to display correctly.**


## Translating an App

By calling `setlocale(LC_ALL, "")`, the app can tell the system that it supports
internationalization. Use the value returned by ``setlocale()`` to translate any
app strings. The implementation follows the
[libc convention](https://www.gnu.org/software/libc/manual/html_node/Setting-the-Locale.html#Setting-the-Locale).
Users may expect text strings, images, time display formats, and numbers to
change if they use an app in a certain language.

Below is a simple approach to providing a translation:

```c
// Use selocale() to obtain the system locale for translation
char *sys_locale = setlocale(LC_ALL, "");

// Set the TextLayer's contents depending on locale
if (strcmp("fr_FR", sys_locale) == 0) {
  text_layer_set_text(s_output_layer, "Bonjour tout le monde!");
} else if ( /* Next locale string comparison */ ) {
  /* other language cases... */
} else {
  // Fall back to English
  text_layer_set_text(s_output_layer, "Hello, world!");
}
```

The above method is most suitable for a few strings in a small number of
languages, but may become unwieldly if an app uses many strings. A more
streamlined approach for these situations is given below in 
[*Using Locale Dictionaries*](#using-locale-dictionaries).


## Using the Locale in JavaScript

Determine the language used by the user's phone in PebbleKit JS using the
standard
[`navigator`](http://www.w3schools.com/jsref/prop_nav_language.asp) property:

```js
console.log('Phone language is ' + navigator.language);
```

```
[INFO    ] js-i18n-example__1.0/index.js:19 Phone language is en-US
```

This will reflect the user's choice of 'Language & Input' -> 'Language' on
Android and 'General' -> 'Language & Region' -> 'i[Pod or Phone] Language' on
iOS.

> Note: Changing the language on these platforms will require a force close of
> the Pebble app or device restart before changes take effect.


## Choosing the App's Locale

It is also possible to explicitly set an app's locale using ``setlocale()``.
This is useful for providing a language selection option for users who wish to
do so. This function takes two arguments; the `category` and the `locale`
string. To set localization **only** for the current time, use `LC_TIME` as the
`category`, else use `LC_ALL`. The `locale` argument accepts the ISO locale
code, such as `"fr_FR"`. Alternatively, set `locale` to `NULL` to query the
current locale or `""` (an empty string) to set the app's locale to the system
default.

```c
// Force the app's locale to French
setlocale(LC_ALL, "fr_FR");
```

To adapt the way an application displays time, call `setlocale(LC_TIME, "")`.
This will change the locale used to display time and dates in ``strftime()``
without translating any strings.


## Effect of Setting a Locale

Besides returning the value of the current system locale, calling
``setlocale()`` will have a few other effects:

* Translate month and day names returned by ``strftime()`` `%a`, `%A`, `%b`, and
  `%B`.

* Translate the date and time representation returned by ``strftime()`` `%c`.

* Translate the date representation returned by ``strftime()`` `%x`.

Note that currently the SDK will not change the decimal separator added by the
`printf()` family of functions when the locale changes; it will always be a `.`
regardless of the currently selected locale.


## Using Locale Dictionaries

A more advanced method to include multiple translations of strings in an app
(without needing a large number of `if`, `else` statements) is to use the
[Locale Framework](https://github.com/pebble-hacks/locale_framework). This
framework works by wrapping every string in the project's `src` directory in
the `_()` and replacing it with with a hashed value, which is then used with
the current locale to look up the translated string from a binary resource file
for that language.

Instructions for using this framework are as follows:

* Add `hash.h`, `localize.h` and `localize.c` to the project. This will be the
  `src` directory in the native SDK.

* Include `localize.h` in any file to be localized:

```c
#include "localize.h"
```

* Initalize the framework at the start of the app's execution:

```c
int main(void) {
  // Init locale framework
  locale_init();

  /** Other app setup code **/
}
```

* For every string in each source file to be translated, wrap it in `_()`:

```c
text_layer_set_text(some_layer, _("Meal application"));
```

* Save all source files, then run `get_dict.py` from the project root directory
  to get a JSON file containing the hashed strings to be translated. This file
  will look like the one below:

```
{
  "1204784839": "Breakfast Time",
  "1383429240": "Meal application",
  "1426781285": "A fine meal with family",
  "1674248270": "Lunch Time",
  "1753964326": "Healthy in a hurry",
  "1879903262": "Start your day right",
  "2100983732": "Dinner Time"
}
```

* Create a copy of the JSON file and perform translation of each string, keeping
  the equivalent hash values the same. Name the file according to the language,
  such as `locale_french.json`.

* Convert both JSON files into app binary resource files:

```
$ python dict2bin.py locale_english.json
$ python dict2bin.py locale_french.json
```

* Add the output binary files as project resources as described in
  {% guide_link app-resources/raw-data-files %}.

When the app is compiled and run, the `_()` macro will be replaced with calls
to `locale_str()`, which will use the app's locale to load the translated string
out of the binary resource files.

> Note: If the translation lookup fails, the framework will fall back to the
> English binary resource file.

## Publishing Localized Apps

The appstore does not yet support localizing an app's resources (such as name,
description, images etc), so use this guide to prepare the app itself. To cater
for users viewing appstore listings in a different locale, include a list of
supported languages in the listing description, which itself can be written in
multiple languages.

The format for a multi-lingual appstore description should display the supported
languages at the top and a include a copy in each language, as shown in the
example below:

> Now supports - French, German and Spanish.
>
> This compass app allows you to navigate in any directions from your wrist!
> Simply open the app and tilt to show the layout you prefer.
>
> Français
>
> Cette application de la boussole vous permet de naviguer dans toutes les
> directions à partir de votre poignet! Il suffit d'ouvrir l'application et de
> l'inclinaison pour montrer la disposition que vous préférez.
>
> Deutsch
>
> Dieser Kompass App ermöglicht es Ihnen, in jeder Richtung vom Handgelenk zu
> navigieren! Öffnen Sie einfach die App und kippen, um das Layout Sie
> bevorzugen zu zeigen.
>
> Español
>
> Esta aplicación brújula le permite navegar en cualquier dirección de la muñeca
> ! Basta con abrir la aplicación y la inclinación para mostrar el diseño que
> prefiera.

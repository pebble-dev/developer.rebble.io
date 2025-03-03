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

title: Using JSHint for Pebble Development
author: thomas
tags:
- Beautiful Code
---

In our post on [JavaScript Tips and Tricks](/blog/2013/12/20/Pebble-Javascript-Tips-and-Tricks/) we strongly recommended the use of JSLint or [JSHint](http://www.jshint.com/) to help you detect JavaScript problems at compile time.

We believe JSHint can really increase the quality of your code and we will probably enforce JSHint correct-ness for all the apps on the appstore very soon. In this post we show you how to setup jshint and integrate it in your Pebble development process.



## Installing JSHint

JSHint is a modern alternative to JSLint. It is more customizable and you can install it and run it on your machine. This allows you to run JSHint every time you build your Pebble application and fix errors right away. This will save you a lot of install/crash/fix cycles!

JSHint is a [npm package](https://npmjs.org/package/jshint). NPM is included in all recent NodeJS installations. On Mac and Windows you can [download an installer package](http://nodejs.org/download/). On most Linux distribution, you will install nodejs with the standard package manage (`apt-get install nodejs`).

To install the JSHint package, run this command:

    sudo npm install -g jshint

The `-g` flag tells npm to install this package globally, so that the `jshint` command line tool is always available.

## Configuring jshint

JSHint offers a large selection of options to customize its output and disable some rules if you absolutely have to. We have prepared a default configuration file that we recommend for Pebble development. The first half should not be changed as they are the rules that we may enforce on the appstore in the future. The second half is our recommended best practices but you can change them to suit your coding habits.

Save this configuration in a `pebble-jshintrc` file in your Pebble project.

    /*
     * Example jshint configuration file for Pebble development.
     *
     * Check out the full documentation at http://www.jshint.com/docs/options/
     */
    {
      // Declares the existence of a global 'Pebble' object
      "globals": { "Pebble" : true },

      // And standard objects (XMLHttpRequest and console)
      "browser": true,
      "devel": true,

      // Do not mess with standard JavaScript objects (Array, Date, etc)
      "freeze": true,

      // Do not use eval! Keep this warning turned on (ie: false)
      "evil": false,

      /*
       * The options below are more style/developer dependent.
       * Customize to your liking.
       */

      // All variables should be in camelcase
      "camelcase": true,

      // Do not allow blocks without { }
      "curly": true,

      // Prohibits the use of immediate function invocations without wrapping them in parentheses
      "immed": true,

      // Enforce indentation
      "indent": true,

      // Do not use a variable before it's defined
      "latedef": "nofunc",

      // Spot undefined variables
      "undef": "true",

      // Spot unused variables
      "unused": "true"
    }

## Automatically running jshint

To automatically run jshint every time you compile your application, you will need to edit your `wscript` build file. This is the modified `wscript` file:


    # Use the python sh module to run the jshint command
    from sh import jshint

    top = '.'
    out = 'build'

    def options(ctx):
        ctx.load('pebble_sdk')

    def configure(ctx):
        ctx.load('pebble_sdk')
        # Always pass the '--config pebble-jshintrc' option to jshint
        jshint.bake(['--config', 'pebble-jshintrc'])

    def build(ctx):
        ctx.load('pebble_sdk')

        # Run jshint before compiling the app.
        jshint("src/js/pebble-js-app.js")

        ctx.pbl_program(source=ctx.path.ant_glob('src/**/*.c'),
                        target='pebble-app.elf')

        ctx.pbl_bundle(elf='pebble-app.elf',
                       js=ctx.path.ant_glob('src/js/**/*.js'))

Now simply run `pebble build` and if there is anything wrong in your JS file, the build will stop and the errors will be displayed on the console. You won't believe how much time you will save!

## CloudPebble users

CloudPebble users are encouraged to download and install JSHint on their machine. You can use the [web interface](http://www.jshint.com/) and set most of the recommended options but you will never get 100% correctness because there is no way to declare an extra global variable (the `Pebble` object).

Good news is [CloudPebble is opensource](https://github.com/CloudPebble/CloudPebble/)! We would be happy to offer a brand new [Pebble Steel](http://www.rebble.io/steel) to the developer who will submit and get through Katherine's approval a pull request to add jshint support in CloudPebble ;)

---
title: Guest Blog Post - Introducing KiezelPay!
author: cat
tags:
- At the Pub
image: /images/blog/authors/kiezelpay.png
---

*This is a guest blog post from [Kiezel's](https://www.kiezelwatchfaces.com/) Kristof (in Belgium) and Jaron (in the US), who recently opened their KiezelPay payments platform to all Pebble developers! We're super excited to see how it will be used and adopted! You can find a list of KiezelPay Powered [watchapps](https://apps.getpebble.com/en_US/collection/kiezelpay/watchapps) and [watchfaces](https://apps.getpebble.com/en_US/collection/kiezelpay/watchfaces) in Pebble's appstore.*

[KiezelPay](https://kiezelpay.com) was designed to help developers sell their apps and watchfaces for the Pebble smartwatch as easily, securely, and globally as possible. We learned a lot when we created a payment system for our Kiezel Watchfaces, and we wanted to improve that system and open it to all developers!



**We strongly believe you deserve to get paid.**

As a team we felt that bringing a solid payment system to the Pebble ecosystem would not only increase developer interest but also bring a much greater quality of apps and watchfaces to Pebble users.

## How Does it Work?

KiezelPay apps have 3 possible statuses - unlicensed, trial, and licensed.

When the app is compiled with the trial setting enabled, it will check its status on our server as soon as the KiezelPay library is initialized for the first time after a clean install - otherwise, the app will check its status when told to do so by the developer (e.g. [PinyWings](http://apps.getpebble.com/en_US/application/54e69569ad38b6399f000017) checks for the app's status after the first level, allowing users to play the first level before purchasing the game).

[![KiezelPay Flow](/images/blog/2016-04-05-kiezelpay/kiezelpay.png)](/assets/images/blog/2016-04-05-kiezelpay/kiezelpay.png)

The diagram above describes the flow of communication between the Pebble app and the KiezelPay servers, including what it looks like when the optional 'trial' and 'periodic rechecks after purchase' features are enabled.

## Why Use KiezelPay?

KiezelPay is secure, simple to integrate, and jam packed with features like trial based apps and watchfaces, discount/promo codes, a day-­to-­day sales dashboard, worldwide transactions, and handles international taxes with ease!

### Security

The first thing that comes to mind when thinking about a payment system is security. Whatever solution we created, we knew it had to be difficult to manipulate the system into giving away free usage of the app, and that the payments should be performed in a secure and trustworthy environment.

We ensure that all vital information and critical security checks happen in the application's C code, and that all communication with the KiezelPay servers use checksums, app secrets, and [nonces](https://en.wikipedia.org/wiki/Cryptographic_nonce) to help secure the system.

*We put a lot of effort into securing our platform, and if you would like to learn more we invite you to contact us at [support@kiezelpay.com](mailto:support@kiezelpay.com).*

### Taxes/Legal

International tax laws are becoming increasingly difficult to handle. Many governments have noticed that the digital goods sector is growing rapidly, and they are losing a lot of money because foreign companies can sell their digital goods with easy without having to pay local sales tax.

For these reasons, the EU recently changed their digital goods tax system, which now requires everyone to charge VAT to anyone from the EU buying digital goods from them, regardless of where the company/person selling those goods is located, and regardless of the amount sold... and many more countries are either following suit, or creating new tax requirements for digital goods of their own.

Trying to stay on top of tax requirements is an insurmountable burden for a single developer that just wants to make a few bucks selling their apps. At KiezelPay, we have spent an enormous amount of time with international accountants and lawyers to ensure we're compliant with current international taxes and laws - not only for accepting payments, but getting the developer paid legally and correctly in a timely manner.

### Ease of Integration

Pebble goes to great lengths to make their development platform accessible to new and experienced developers alike, and we wanted to ensure our platform was the same. An average developer should be able to setup KiezelPay and integrate it into their app in about an hour.

Once a developer creates a product in KiezelPay, they can download a pre-built watchface that includes the KiezelPay integration that has been configured for the product they just setup!

### Features

Our KiezelPay platform currently offers you the following features:

- **Trial usage**: You, as the developer, can choose if you want to allow users to test your app before purchasing by having a trial period. With a simple setting in your KiezelPay account, you can enable/disable trials, and define how long they last. After the trial is expired, the user will be required to purchase to continue.
- **Discounts**: Want to reward that user that helped you hunt down a hard to find bug with a free license or have a holiday specific pricing? No problem! Our system allows you to create all kinds of discounts for every situation: percentage based or fixed amount, one time valid or during a specific period in time, with code or for anyone that purchases, etc.
- **Dashboard**:​ Your KiezelPay account will show you all kinds of information about your apps. You can see a nice graph with your day­-to-­day income, easily see how much money you have made in total, how much you will receive at the next payout, and when that payout will happen.
- **Purchase History**: We made it easy to find any of your customers to reach out to them, see information about when they purchased the app, and what may have gone wrong during failed purchases.
- **Test mode**: By changing a single define in the KiezelPay library header file, you can run your app in test mode, allowing you to test the complete KiezelPay purchase process without having to pay for real.

## The Future!

Kiezel is always looking to improve KiezelPay and would love any feedback you may have. We plan to improve KiezelPay in the coming weeks by adding the following:

- Acceptance of Credit/Debit Card transactions
- New dashboard analytics and graphs
- Developer initiated refunds
- Support for selling complete packages of apps/faces instead of only single
apps/faces
- In­-app purchases
- And even more!

KiezelPay is officially now live and open to all developers to sign up for free. To sign up visit our site at [KiezelPay.com](https://kiezelpay.com), and join the [KiezelPay Discord server](https://discord.gg/zbqrxh8).

We hope you enjoy what we’ve created!

Kristof Verpoorten & Jaron Pulver

KiezelPay LLC


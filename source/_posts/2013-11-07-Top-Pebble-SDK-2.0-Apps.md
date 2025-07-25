---
author: cherie
tags:
- '#makeawesomehappen'
---

Yesterday, we announced the beta release of our 2.0 SDK and got overwhelmingly helpful feedback from all of you. Today, we are equally excited to announce that your favorite apps are now also available on v2.0, ready to download! We contacted some of the developers to get their feedback on the new SDK, along with some tips and tricks for those of you that are just starting out with the new Pebble SDK.


  
Apps: [7-Minute Workout](#seven-minute-workout) | [WatchNote](#watchnote)   
Apps (iOS Only): [Smartwatch+](#smartwatch+-and-smartstatus) | [Smartwatch Pro for iOS](#smartwatch-pro-for-ios) | [SmartStatus](#smartwatch+-and-smartstatus) | [PebbleCam](#pebblecam)  
Apps (Android Only): [Canvas for Pebble](#canvas-for-pebble) | [Glance for Pebble](#glance-for-pebble) | [Music Boss for Pebble](#music-boss-for-pebble) | [Pebble Notifier](#pebble-notifier) | [Pebble Tasker](#pebble-tasker)  
Watchfaces: [Dotz](#dotz-watchface-fancy-watchface-maurice-watchface-modern-watchface) | [Fancy](#dotz-watchface-fancy-watchface-maurice-watchface-modern-watchface) | [Maurice](#dotz-watchface-fancy-watchface-maurice-watchface-modern-watchface) | [Modern](#dotz-watchface-fancy-watchface-maurice-watchface-modern-watchface) |  [Noms](#noms) | [Revolution](#revolution)  



---
####Smartwatch Pro for iOS
[Max Bäumle](http://appstore.com/smartwatchproforpebble)  	
A companion application for your phone that provides useful additional functionality with your Pebble watch including displaying upcoming calendar events, your Twitter timeline, volume control and more.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartwatchpro.jpeg)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartwatchpro.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartwatchpro.pbw)  
######Current/Future 2.0 Features:
I am planning to implement Event Services and persistent storage for various parts of the application.  	
######Time to Port: 
2 days for migrating from 1.x to 2.0 without adding new features.	  
######Thoughts on SDK:
Overall, the new SDK feels much more mature than the 1.x preview. Feature-wise, dynamic memory allocation is definitely among my personal favorites since it opens up the possibility to implement more innovative features in the future.	Improved SDK installation process, rewritten quick start guides and sample code will make it a lot easier for starters to get familiar with development for the Pebble watch platform.    
######Tips:
Refer to the 2.0 migration guide if you are converting an existing project. The `pebble` command line tool will come in handy for that as well. Do not hesitate to [contact Pebble developer support](/contact) or Twitter (@PebbleDev) if you are getting stuck. I can assure you they will do their best to help you out with any request  

---
####Seven-Minute Workout	
[Alex Kennberg](http://kennberg.com/7min)  
Personal guide through the high-intensity 7 minute workout as was featured in the New York Times.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/7-minscreen.png)](http://kennberg.com/7min/)	
[Download](http://kennberg.com/7min/)	
######Time to Port:
1 hour
######Thoughts on SDK:	
Great documentation, polished APIs, and solid foundation for more features.	

---
####Music Boss for Pebble	
[Reboot's Ramblings](http://musicboss.ca)	
Adjust volume while listening to music, change music apps and even launch your current music app right from your Pebble.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/musicbossscreen.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/musicboss.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/musicboss.pbw)  
######Current/Future 2.0 Features:
I am planning on using tap events for some new features, but wanted to make sure users were able to transition to the new OS without issues and still be able to use the Music Boss they know and love	
######Thoughts on SDK:
The Pebble team is really trying to make coding for the Pebble Smart watch easier for developers. They are cleaning up certain design architectures and streamlining the app build and install tools. It's never been better to start coding for the Pebble.	
######Tips:
If you are stuck, check the forums, if you are still stuck, reach out to other Pebble developers. My experience has been that we (and they) are very willing to help fellow devs.

---
####Pebble Tasker	
[Hernan Cosi - KodeK Apps](https://play.google.com/store/apps/details?id=com.kodek.pebbletasker&hl=en)	
Allows you to control your Android phone through Tasker directly from your watch.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/taskerscreen.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/tasker.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/tasker.pbw)  
######Current/Future 2.0 Features:
None yet, but there are a few new features planned.	
######Time to Port:
Less than a weekend. Could be done in just a few hours now that I'm familiar with the new API.	
######Thoughts on SDK:
By far my favorite feature is the new 'pebble' tool and all its new functionality.	Run 'pebble build && pebble install' to quickly deploy your app's latest changes. 
######Tips:
'pebble --debug logs' will be incredibly useful if you're working with AppMessage packets.
							
---
####Smartwatch+ and SmartStatus
[Robert Hesse](http://smartwatchplusios.appspot.com)	
Companion app that enhances the Pebble experience for iOS users | Watch face for Smartwatch+  
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartwatchplus.gif)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartwatchplus.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartwatchplus.pbw)  
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartstatus.gif)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartstatus.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/smartstatus.pbw)  
######Current/Future 2.0 Features:
BluetoothConnectionService, malloc, Persistent Storage	
######Time to Port:
~8h	
######Thoughts on SDK:
malloc allows to pack much more capable apps into the app size limit	
<a class="anchor" name="watchnote"></a>
######Tips:
Use malloc!

---
####WatchNote	
[Leistner Apps](http://www.facebook.com/Watchnote)  	
Create, edit and send multiple notes from your smartphone to your wrist.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/watchnotescreen.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/watchnote.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/watchnote.pbw)  
######Current/Future 2.0 Features:
At the moment we don't use 2.0 features	
######Time to Port:
about 8 to 10 hours	
######Thoughts on SDK:
I like the massive amount of new possibilities.	

---
####Glance for Pebble	
[Finebyte](http://www.finebyte.co.uk)	
Glance gives fast access to the information you need and enables quick responses to messages right from your Pebble.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/glance.gif)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/glance.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/glance.pbw)  
######Current/Future 2.0 Features:
Bluetooth connection monitoring and Battery status. Tap gestures are coming!	
######Time to Port:
Just over a week	
######Thoughts on SDK:
Getting more access to the Pebble hardware - both the basics like BT and battery, and some new fun toys like the accelerometer. 
######Tips:
Be careful with your memory allocation - remember you need to check your _creates and allocations were successful!

---
####Canvas for Pebble
[Steve Penna](http://pebblecanvas.blogspot.co.uk/)	
Design and share dynamic Pebble watch-faces on your Android phone	
[Coming Soon]()	 
######Current/Future 2.0 Features:
Persistent storage, dynamic memory allocation, watch state (bluetooth connection / battery), utility functions (e.g. atoi), proper debugging via websockets	
######Time to Port:
A few days to do a basic port, many weeks to add cool new features based on the new capabilities (including updates to the Android app)	
######Thoughts on SDK:
Dynamic memory allocation and persistent storage - I can't decide between the two but they are the most liberating features in the 2.0 SDK!	The new debugging features are incredibly useful (e.g. pebble install, pebble logs), in combination with the app_log functionality. 
######Tips:
Use debug liberally and #IFDEF it for when you get everything working ;)

---
####Pebble Notifier	
[Dattas Moonchaser](https://github.com/dattas/pebble-notifier)  
Sends any notification from your Android phone to your Pebble.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/notifierscreen.png)]()
######Thoughts on SDK:
I am quite excited to see persistent storage!	

---
####PebbleCam  	
[Heiko Behrens & Marcel Jackwerth](http://PebbleCam.com)	
Stream your iPhone's camera to your Pebble and take high quality pictures remotely.  	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/pebblecamscreen.png)](http://pebblecam.com/pebble-2-0-firmware)  
[Download](http://pebblecam.com/pebble-2-0-firmware)  
######Current/Future 2.0 Featues:
Better tool chain to automatically build the Pebble app whenever the iOS app is being compiled.	
######Time to Port:
Less than three hours.	
######Thoughts on SDK:
The Pebble SDK 2.x is far more convenient and faster to develop with - simpler setup, hassle-free deployment and more comfortable testing.	
######Tips:
Have a look at the JavaScript Framework, that's a huge opportunity - no need for an additional mobile app, always-running app that can retrieve and crunch data from the web, a simplified installation and configuration for Pebble's end users.

---
####Dotz Watchface | Fancy Watchface | Maurice Watchface | Modern Watchface	
[Łukasz Zalewski]()  
Animated watchface which wont eat your battery | Fancy look analogue watchface | Pointy look analogue watchface | Modern look analogue watchface  
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/dotz.gif)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/dotz.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/dotz.pbw)  
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/fancy.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/fancy.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/fancy.pbw)  
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/maurice.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/maurice.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/maurice.pbw)  
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/modern.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/modern.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/modern.pbw)  
######Current/Future 2.0 Features:
Will be coming in the future	
######Time to Port:
4 hours | 1 hour | 1 hour | 1 hour	
######Thoughts on SDK:
Cleaning up workspace for pebble projects, my pebble projects now have much nicer structure and code is easier to read.	
######Tips:  
Remember to initialize the accelerometer service handler properly even if you're using only the accel_service_peek, or your application will keep on crashing.

---
####Revolution 	
[Douwe Maan](http://www.douwemaan.com) 	
Beautiful watchface with big, clear digits and smooth animations.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/revolution.png)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/revolution.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/revolution.pbw)  
######Time to Port:
2 hours  	
######Thoughts on SDK:
The new JavaScript and persistence frameworks open a world of possibilities for new Pebble apps	

---
####Noms	
[Fazli Sapuan](https://github.com/fuzzie360/pebble-noms)	
Watch face "noms" the time every minute.	
[![](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/noms.gif)](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/noms.pbw)  
[Download](http://pebble-static.s3.amazonaws.com/watchfaces/beta20/apps/noms.pbw)
######Time to Port:
15 mins  	
######Thoughts on SDK;
The workflow is more streamlined and API is saner than ever before.	

---
Stay up-to-date with the latest Pebble developer news with [RSS](/atom.xml)!

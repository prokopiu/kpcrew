# KPCrew 2.3-alpha4 (11/2022)
FlyWithLua scripts to simulate a virtual first officer in X-Plane 11. 
THIS IS A COMPLETE REWRITE AND STILL IN ALPHA. PLEASE REMOVE ANY OLDER KPCREW FILES FROM SCRIPTS AND MODULES FOLDER!

** do not use the DEPARTURE BRIEFING section and do not press the SPEAK button or X-Plane will crash!!** 
I will fix it in the next release.

## Introduction
Coming from the FSX/P3D world I know the FS2Crew products which I had for all payware aircraft if available. I always wished that I could get something like that for X-Plane. FlyWithLua turned out to be a great programming environment for X-Plane and I decided to try replicating something like FS2Crew for the Zibo B738. 

Why the Zibo? Because it is the most accessible and function-rich freeware aircraft in X-Plane and I love the Boeing 737s.

### What does it do? 

Basically you have a helping hand, a virtual first officer which is able to run procedures on your command. These procedures are as close as I can have them to real procedures, partially I get inspiration from FS2Crew (a great tool I would always recommend).

There are other tools out there which do similar things, the most versatile one being XFirstOfficer. I had a KPCrew version with XFirstOfficer but it turned out a lot of work and although quite versatile, restricted me at some locations due to the way the steps are defined. Still XFirstOfficer is great and I can recommend it to people who want to quickly bring together small procedures without programming.

Having said that, KPCrew is one big programming exercise and I can understand that it will be difficult for people without experience in Lua programming to change or extend things. If you want to do that then look at other tools as mentioned above.

### Other Aircraft Supported?

Will there be other aircraft? Yes, it will also contain the FJS B737-200 and many other planes if I have the addon and find the time to research it.

### History of KPCrew
KPCrew went through several iterations, initially I called it Zibocrew. The initial concept was clunky and inflexible. I think I now have a good enough concept to easily extend the scripts. I even have now background events. As it is with Lua, you can see all that I did but when you change code you are on your own – I will not have the time to support this or hold hands with the installation. This is one of the reasons why I hesitated to release this publicly.

**[Go to the manual](https://github.com/prokopiu/kpcrew/wiki/%23-KPCrew-2.3-alpha3-(10-2022))**

---------------------
### Code from other developers used in KPCrew:
 - xml2lua (https://github.com/manoelcampos/xml2lua) from manoelcampus to read the simbrief XML
 - metar (https://github.com/tjormola/metar) from tjormola which I have changed slightly to embedd it and improve the parsing
 - weatherlib (https://github.com/tjormola/weatherlib) needed by metar.lua

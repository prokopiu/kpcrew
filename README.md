# KPCrew 2.3-alpha11 (12/2025) WIP
FlyWithLua scripts to simulate a virtual first officer in X-Plane 12 (not testing in in XP11 any more). 
THIS IS A COMPLETE REWRITE AND STILL IN ALPHA. PLEASE REMOVE ANY OLDER KPCREW FILES FROM SCRIPTS AND MODULES FOLDER!

**Note: If your scripts fail with "too many create_commands" error message then rename kphardware.lua to kphardware.lua.off**

## Introduction
Coming from the FSX/P3D world I know the FS2Crew products which I had for all payware aircraft if available. I always wished that I could get something like that for X-Plane. FlyWithLua turned out to be a great programming environment for X-Plane and I decided to try replicating something like FS2Crew for the Zibo B738. 

Why the Zibo? Because it is the most accessible and function-rich freeware aircraft in X-Plane and I love the Boeing 737s.

In the meantime, I did a complete rewrite of many SOPs to follow a default, abbreviated flow to be able to add more aircraft much quicker than before. You now have the following aircraft supported, more to come:
 - Zibo B738 full SOP
 - XP12 CitationX individual SOP
 - XP12 A330-300 DFLT SOP
 - X-Crafts freeware E-Jets (go to X-Crafts website) DFLT SOP
 - Laminar MD-82 DFLT SOP
 - ToLiss A319, A320 & A321 DFLT Flow (A330 and A340 coming)

### What does it do? 

Basically you have a helping hand, a virtual first officer which is able to run procedures on your command. These procedures are as close as I can have them to real procedures, partially I get inspiration from FS2Crew (a great tool I would always recommend).

There are other tools out there which do similar things, the most versatile one being XFirstOfficer. I had a KPCrew version with XFirstOfficer but it turned out a lot of work and although quite versatile, restricted me at some locations due to the way the steps are defined. Still XFirstOfficer is great and I can recommend it to people who want to quickly bring together small procedures without programming.

Having said that, KPCrew is one big programming exercise and I can understand that it will be difficult for people without experience in Lua programming to change or extend things. If you want to do that then look at other tools as mentioned above.

### Other Aircraft Supported?

Will there be other aircraft? Yes, due to the new approach you will see more supported aircraft soon such as Aerobask jets, larger ToLiss Airbusses etc...

### History of KPCrew
KPCrew went through several iterations, initially I called it Zibocrew. The initial concept was clunky and inflexible. I think I now have a good enough concept to easily extend the scripts. I even have now background events. As it is with Lua, you can see all that I did but when you change code you are on your own – I will not have the time to support this or hold hands with the installation. This is one of the reasons why I hesitated to release this publicly.

**[Go to the manual](https://github.com/prokopiu/kpcrew/wiki/%23-KPCrew-2.3-alpha10-(04.2025))**

---------------------
### Code from other developers used in KPCrew:
 - xml2lua (https://github.com/manoelcampos/xml2lua) from manoelcampus to read the simbrief XML
 - metar (https://github.com/tjormola/metar) from tjormola which I have changed slightly to embedd it and improve the parsing
 - weatherlib (https://github.com/tjormola/weatherlib) needed by metar.lua

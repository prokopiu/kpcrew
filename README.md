# kpcrew
FlyWithLua scripts to simulate a virtual first officer in X-Plane 11

## Introduction
Coming from the FSX/P3D world I know the FS2Crew products which I had for all payware aircraft if available. I always wished that I could get something like that for X-Plane. FlyWithLua turned out to be a great programming environment for X-Plane and I decided to try replicating something like FS2Crew for the Zibo B738. 

Why the Zibo? Because it is the most accessible and function-rich freeware aircraft in X-Plane and I love the Boeing 737s.

What does it do? 

Basically you have a helping hand, a virtual first officer which is able to run procedures on your command. These procedures are as close as I can have them to real procedures, partially I get inspiration from FS2Crew (a great tool I would always recommend).

There are other tools out there which do similar things, the most versatile one being XFirstOfficer. I had a KPCrew version with XFirstOfficer but it turned out a lot of work and although quite versatile, restricted me at some locations due to the way the steps are defined. Still XFirstOfficer is great and I can recommend it to people who want to quickly bring together small procedures without programming.

Having said that, KPCrew is one big programming exercise and I can understand that it will be difficult for people without experience in Lua programming to change or extend things. If you want to do that then look at other tools as mentioned above.

Will there be other aircraft? Yes, it will also contain the FJS B737-200 and many other planes if I have the addon and find the time to research it.

KPCrew went through several iterations, initially I called it Zibocrew. The initial concept was clunky and inflexible. I think I now have a good enough concept to easily extend the scripts. I even have now background events. As it is with Lua, you can see all that I did but when you change code you are on your own – I will not have the time to support this or hold hands with the installation. This is one of the reasons why I hesitated to release this publicly.

I am also working on a way to make the checklists more intelligent. At the moment, using the Easy mode will set all checklist items correctly and tick the box for you. In the future and when using manual mode, the checklist will pause at certain steps until you have corrected the item.

## Installation
### The KPCrew Zip-file
KPCrew comes in a Zip-file and needs to be manually installed under your X-Plane-11 folder.

Modules and Scripts are FlyWithLua specific folders, B738 is the Zibo specific folder. Other aircraft folders will follow in future versions. It also contains this manual.

### Prerequisites
You need to have the freeware FlyWithLua NG plugin minimum version 2.7 but I recommend the latest version. See [https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/].

I also use Xchecklist to display and automatize my own clist.txt for each supported aircraft. See [https://forums.x-plane.org/index.php?/files/file/20785-xchecklist-linwinmac3264/].

And get yourself BetterPushbackC if you really are one of those that have missed out on this great tool :-) [https://github.com/skiselkov/BetterPushbackC/releases]

Read the instructions for each of those plugins. I will not support them.

### Unpacking and Installing
The Modules and Scripting folders need to be placed in <your x-plane root folder>\Resources\plugins\FlyWithLua . If you have older versions of KPCrew files just overwrite them. Please also overwrite your kpcrewconfig.lua file as it may change in the future and KPCrew will not load if it is incomplete (at least until I found a way to handle missing items). 

In the aircraft specific folder you will find aircraft specific options. Normally I offer a special clist.txt which works in conjunction with KPCrew.
If you want to use that clist.txt you have to place it in the aircraft folder (e.g. wherever you have your Zibo installed under the <your x-plane root folder>\Aircraft folder. You also need the Xchecklist plugin as mentioned above.

### Uninstall
To uninstall remove the lua files from Scripts and Modules and replace the clist.txt with the original.

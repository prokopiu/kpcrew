# KPCrew 2.3-alpha4 (11/2022)
FlyWithLua scripts to simulate a virtual first officer in X-Plane 11. 
THIS IS A COMPLETE REWRITE AND STILL IN ALPHA. PLEASE REMOVE ANY OLDER KPCREW FILES FROM SCRIPTS AND MODULES FOLDER!

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

### Code from other developers used in KPCrew:
 - xml2lua (https://github.com/manoelcampos/xml2lua) from manoelcampus to read the simbrief XML
 - metar (https://github.com/tjormola/metar) from tjormola which I have changed slightly to embedd it and improve the parsing
 - weatherlib (https://github.com/tjormola/weatherlib) needed by metar.lua

<div style="page-break-after: always;"></div>

## Installation

### Video Manuals
 - Installation EN: [https://youtu.be/iyKS1WWdwpg](https://youtu.be/iyKS1WWdwpg)
 - Installation DE: [https://youtu.be/iowFI55s-io](https://youtu.be/iowFI55s-io)

### Prerequisites
You need to have the freeware FlyWithLua NG plugin minimum version 2.8.x but I recommend to download the latest version. See [FlyWithLua on the Forum XP11](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) or
[FlyWithLua on the Forum XP12](https://forums.x-plane.org/index.php?/files/file/82888-flywithlua-ng-next-generation-plus-edition-for-x-plane-12-win-lin-mac/)

And get yourself BetterPushback if you really are one of those that have missed out on this great tool :-) [BetterPushback](https://github.com/skiselkov/BetterPushbackC/releases)

### The KPCrew-x.x.x.zip File
KPCrew comes in a Zip-file and needs to be manually installed under your X-Plane-11 folder. The ZIP contains the following folders:
- kpcrew
  - aircraft  --> contains aircraft specific files such as Flows or Honeycomb profiles
    - KPCrew v2.3 B738 Flows.pdf --> current flows and checklists for Zibo Mod
    - KPCREW Alpha Default.json --> a generic Honeycomb Alpha profile - works only with KPHardware
    - KPCREW Bravo Profile.json --> a generic Honeycomb Bravo profile - works only with KPHardware
  - documentation  --> documentation for KPCrew
    - KPCrew Flows.xlsx  --> The Flows for all supported aircraft
    - manual.md  --> this manual
    - manual.pdf  --> PDF version of this manual
  - modules  --> files to go in the FlyWithlua module folder; all the KPCrew and aircraft modules
    - modules  --> files to go in the FlyWithlua module folder; all the KPCrew and aircraft modules
      - briefings --> briefing related files and saved briefings
      - checklists --> checklist functionality
      - hardware --> hardware modules
        - honeycombAlpha.lua --> commands for Alpha Yoke
        - honeycombBravo.lua --> commands for Bravo Throttle
      - preferences --> preference related functions and saved preferences
      - procedures --> procudre related functionality
      - sop --> Standard Operating Procedures logic and aircraft modules
      - systems --> all aircraft systems and functions (also for kphardware)
        - B738 --> Zibo module
        - DFLT --> XP11 default aircraft module
        - .lua files with general logic
      - .lua
  - scripts  -->  files to go in the FlyWithlua module folder; the main lua script
    - kpcrew23.lua  --> the main script to start KPCrew with supported aircraft
    - kphardware.lua --> if you choose to install this as well
  - readme.md  --> a readme file
  - LICENSE  --> the license terms

### How to Install
Modules and Scripts are FlyWithLua specific folders. Find them  here:

- Your X-Plane-11/12 Root Folder
  - Resources
    - plugins
      - FlyWithLua
        - scripts  --> put kpcrew2.lua here (overwrite older versions)
        - modules  --> put all lua files in modules folder here

**Make sure that you removed any older files from previous versions of KPCrew (2, 2.1 and 1.x also called Zibocrew)**

### How to Uninstall
Simply remove all the above lua files from the **scripts** and **modules** folder.

### X-Plane Commands
You can assign commands to buttons or keys for most of the above items:

 - **kp/crew/master** = KPCrew Masterbutton
 - **kp/crew/next** = KPCrew Nextbutton
 - **kp/crew/prev** = KPCrew Prevbutton
 - **kp/crew/flowwindow** = KPCrew Toggle Flow Window
 - **kp/crew/sopwindow** = KPCrew Toggle SOP Window
 - **kp/crew/openmaster** = KPCrew Open Master Window (Control window)
 - **kp/crew/briefwindow** = KPCrew Toggle Briefing Window
	
### FlyWithLua Macros

You can also perform certain actions from the FlyWithLua Macro section:

 - **KPCrew Toggle Control Window** Makes control window visible when completely hidden

<div style="page-break-after: always;"></div>

## How does KPCrew Work?

### Video Manuals
 - Overview EN: [https://youtu.be/0Cx_MhlDruQ](https://youtu.be/0Cx_MhlDruQ)
 - Overview DE: [https://youtu.be/ui8vP0OSKLA](https://youtu.be/ui8vP0OSKLA)

More to follow....

### Startup
Once you have installed the lua files in the correct places, next time your X-Plane starts it will also automatically start KPCrew. If you have loaded one of the supported aircraft add-ons (currently the Zibo Mod B738) you can call up the control window on the bottom right of the X-Plane window. Either use a custom key/button with command "_kp/crew/openmaster_" called "_KPCrew Open Master Window_" or find the Macro "_KPCrew Toggle Control Window_".

![Control Window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/controlwindow.png)

### The Control Window

These are the elements of the Control Window:

 - **[SOP]**: Opens the Standard Operating Procedure window with all associated flows
 - **[FLOW]**: Opens the currently selected flow (Procedure or Checklist)
 - **[<-]**: Select previous item
 - **[FLOW WINDOW]**: Information where in the flow you are and the status of the flow item. Click to execute master button.
 - **[->]**: Select next item. Can also be used to skip flows and flow items
 - **[RESET]**: Resets the currently selected flow
 - **[BRIEF]**: Shows the flight briefing window to provide information to KPCrew
 - **[PREF]**: Shows the preferences to set for KPCrew
 - **[>]**: Minimize the control window (master window)
	
<div style="page-break-after: always;"></div>

### Listing and Selecting Flows

Each supported aircraft has an SOP defined which can be looked at by opening the SOP window.

![SOP Window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/sopwindow.PNG)

By double-clicking on a line, you select the respective flow. It should show in the control window. You can also use the [<-] and [->] button in the control window to move through flows. Red means the flow selected or the cursor over it, green means the flow was executed in an automatic mode and is finished. Dark green background mark procedures, black background are checklists. There are slightly different rules with checklists and procedures.

<div style="page-break-after: always;"></div>

### The Flow Window

Each procedure or Checklist can be displayed in the Flow Window.

![FLOW Window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/flowindow.PNG)

When opened for the first time in a session, you can immediately see which items are OK and which items you need to check/attend to. The open items are in RED. All the other lines in white.
White lines are comments/instructions or anything not part of an automated flow.
If you use any of the automated modes and let a procedure/checklist be run, all correct items will be colored green when executed. Outstanding items are grey or red. Incorrect items stay red and the flow will stop.
In this example DC POWER SWITCH is the next item to attend to and it is not correctly set.
You can reset the displayed flow by pressing on the RESET button. The flow can then be restarted again.

![Running flow](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/runningflow.PNG)

<div style="page-break-after: always;"></div>

### Preferences Window

You can set a number of KPCrew preferences which will apply to all aircraft modules and some aircraft specific preferences which depend on the selected aircraft.
For this you can open the PREFERENCES window:

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/preferenceswindow.PNG)

The **v GENERAL PREFERENCES** section applies to the application in general, Below you will see a **v [ICAO] PREFERENCES** which covers the selected aircraft. Click on it to open.


Since Markdown accepts plain HTML and CSS, simply add this line wherever you want to force page break.

<div style="page-break-after: always;"></div>

## Preferences

### Preferences Window

You can set a number of KPCrew preferences which will apply to all aircraft modules and some aircraft specific preferences which depend on the selected aircraft.
For this you can open the PREFERENCES window:

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/preferenceswindow.PNG)

The **v GENERAL PREFERENCES** section applies to the application in general, Below you will see a **v [ICAO] PREFERENCES** which covers the selected aircraft.

#### GENERAL PREFERENCES

 - **Assistance Level**:  [No assistance][Guided][Some automation][Fully automatic]
   - **_No assistance_**: To execute on a flow will only open the flow window and show the procedure/checklist with all open items in red, otherwise in grey.
   - **_Guided_**: When starting the flow with the Master button, it will go through all items and stop at red ones waiting for you to fix the item. You can skip it with the Next button [->].
   - **_Some automation_**: When starting the flow with the Master button, it will go through all items and execute logic (if available) if it is not one of your tasks (your role being CPT, PF,...). Items that are your responsibility still need to be fixed by yourself.
   - **_Fully automatic_**: When starting the flow with the Master button, it will go through all items and execute logic (if available). Ideally you will not have to intervene in this mode and can concentrate on other things. Note, checklists still need your intervention - the other role speaks the challenge and you have to check and answer.
 - **Weight Units**: [KGS / LBS] Displays and treats all weights either as KG or LBS
 - **EFIS Default Baro Mode(Both)**: [HPA / IN] Sets the default mode on the EFIS to either HPA (mb) or IN (inchHg)
 - **Default Transition Altitude (ft)**: Set the transition altitude default. Use the TALT of the region your are flying in mostly
 - **Default Transition Level (FL)**: Set the transition level default. Use the TLVL of the region your are flying in mostly
 - **Speak Checklists**: (deprecated) Speak either all sides of the checklist (will be disabled in next release) or only challenge.
 - **Flow window on start**: When you start a flow with the master button you can force the Flow window to open. Default is not to open windows.
 - **Flow window at end**: At the end of a flow you can automatically close the Flow window or leave it open to deal with it yourself.
 - **On end of Flow**: At the end of a flow you can jump to the next flow to avoid you having to call up each flow manually. If you want to be in control then use _Do not jump option_.
 - **Transponder**: In USA mode it will turn on the transponder at beginning of taxi and at the end with shutdown mode. In EUR mode it will turn on XDPR when entering runway and when exiting the runway in cleanup mode.
 - **SIMBRIEF Username**: enter your username so that KPCrew can pull your latest filed OFP
 - **VATSIM METAR**: When you turn Load ON then KPCrew will load the VATSIM METARs from airports in your flight briefing every couple of minutes. If you turn this option off KPCrew will generate some METAR based on the local weather. When you have Real Weather Download on in X-Plane, it wil lonly display the local METAR for your origin. Otherwise the same METAR applies to destination and alternate airport.

#### AIRCRAFT SPECIFIC PREFERENCES

Every supported aircraft will have a set of settings which are unique to it. Here you can see samples for the DFLT module (default aircraft from Laminar) or the Zibo Mod preferences.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/DFLTprefs.PNG)

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/B738prefs.PNG)

### LOAD/SAVE Preferences

Your preferences can be saved and then reloaded with the next start of the simulator or the FlyWithLua plugin. KPCrew will initialize the name field with the ICAO code of the loaded aircraft (or DFLT if not supported).
Preferences are currently saved individually with every aircraft. You may have to set them again when loading a new aircraft. 
You can use any name in the name field and save current preferences.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/loadsaveprefs.PNG)

<div style="page-break-after: always;"></div>

## Briefings

One important component of KPCrew is to provide as much as possible information about the flight you are planning. This not only helps you but also helps KPCrew to improve the automation of procedures and checklists.

### BRIEFINGS Window

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/briefings.PNG)

There are many sections you can open and provide information. You can open and close them as needed. AT the bottom of the window you can save the current state of you briefings under any name. The file will be written to your kpcrew_prefs folder in FlyWithLua.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/loadsavebrief.PNG)

#### INFORMATION section

This section is always open and provides many information about the current session. The loaded aircraft, weights, current position in coordinates that can also be used in CIVA INS, METARs for all selected airports and a flight time recorder.
Flight times are: 
 - OFF: off block time (triggered by pushback/startup procedure). 
 - OUT: takeoff time triggered by takeoff procedure
 - IN: landing time (triggered by after landing / cleanup)
 - ON: on blocks time (triggered by shutdown procedure)
 
#### FLIGHT section

Fields with an asterix(*) in the name are mandatory for your automatic procedures to work correctly.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/briefflight.PNG)

 - **Simbrief Data Load:** If you have filed a flight with Simbrief.com and provided a username in preferences then many fields in the following sections will be filled by what you have in your OFP. Italis fields can be filled from Simbrief.
 - **_ATC Callsign:_** Callsign that you filed with ATC (VATSIM/ICAO...)
 - **_*Origin ICAO:_** ICAO code of origin airport
 - **_*Destinaton ICAO:_** ICAO code of destination airport
 - **_Alternate ICAO:_** ICAO code of alternate airport
 - **_Route:_** optional route from Simbrief
 
#### FLIGHT CRUISE section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/flightclimb.PNG)

The CRUISE section is mostly informational. You must fill out the Cruise Flight Level.

 - **_Air Distance from OFP (nm):_** Air distance (considering the route waypoints) 
 - **_*Cruise Level (FL):_** Final cruise flight level.
 - **_Average Wind (999/99)_:** Average wind along the whole enroute part. Gives an indication of how adverse the wind will be on your flight. 
 - **_Average Wind Component:_** Average wind component along the enroute part shows you if you have more of a tailwind, crosswind or more of a headwind and how strong it is.
 - **_Average ISA_:** Shows the deviation from the International Standard Atmosphere temperature for your enroute altitude.
 - **_Critical MORA (FT)_:** Critical MInimum Off-Route Altitude. MORAs give at least 1,000 feet altitude clearance above terrain along the route. The minimum MORA tells you that in an emergency you should not descend below this altitude unless you have verified that you can do so safely.

#### FLIGHT FUEL & LOAD section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/flightload.PNG)

The FUEL & LOAD allows you to set payload and fuel and send it to the aircraft. At the moment not all aircraft and all XP versions support all of that but I am working on improving this if possible.

 - **_*Takeoff Fuel KGS/LB:_** This is the calculated fuel you should have on board as a minimum. Will be loaded to XP aircraft if supported
 - **_Final Reserve + Alternate KGS/LB:_** Final reserve and fuel needed to reach the alternate airport at destination. You should not go below this without good reasons.
 - **Usable fuel:**  Usable fuel calculates for you how much fuel can be used for the flight without exceeding the fuel limits
 - **_*Payload KGS/LB:_** Payload to be added. Payload is PAX and Cargo. Can be loaded in some aircraft. If it does not work you have to set it yourself.
 - **Payload & Fuel [Load Airplane]:** Press the button to load at least the fuel and sometimes also the payload in X-Plane.

#### TAXI DETAILS section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/flighttaxi.PNG)

If available, provide information about the parking position, the pushback, start sequence and optionally the taxi route.
Frequencies are for use with online flying and can be directly sent to COM1 active frequency by pressing the **[<->]** button.

 - **Ground Frequency:** Frequency of active Ground controller
 - **Tower Frequency:** Frequency of the active Tower 
 - **Parking Stand:** Parking stand number or designation
 - **Gate/Stand:** Select if it is a gate, a stand with push or a stand you do not require push
 - **Push Direction:** A little reminder for yourself where you should push (use Betterpushback - no integration yet)
 - **Start Sequence:** Select which engine(s) you want to start in which sequence (aircraft specifc)
 - **Taxi Route:** If available and for our information only provide the taxi route (e.g. from the charts or online instructions)

<div style="page-break-after: always;"></div>

#### DEPARTURE ATIS section

Use this to note down the ATIS from online stations or copy a generated METAR.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/depatis.PNG)

 - **ATIS Frequency:** Frequency of ATIS service
 - **ATIS Information:** Letter of the current ATIS information
 - **ATIS Wind HDG/SPD:** Wind hhh/vv
 - **ATIS Visibility m:** Visibility in meters
 - **ATIS Weather Phenomena:** General phenomena such as rain, fog etc
 - **ATIS Clouds:** Cloud coverage
 - **ATIS Temp/Dewpoint:** Temperature/Dewpoint 
 - **\*ATIS QNH:** QNH in inchHG or mb (HPA)
 - **ATIS Trends:** Trends such as NOSIG, TEMPO
 - **METAR [Reload METAR]:** Load the fields from a METAR in FLIGHT INFORMATION field

<div style="page-break-after: always;"></div>

#### DEPARTURE CLEARANCE section

Use this to note down the clearance from ATC

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/depclrnc.PNG)

 - **Clearance Frequency:** Frequency of Clearance Delivery
 - **_*XPDR SQUAWK_:** Transponder Code
 - **_*Transition Altitude (ft)_:** Transition Altitude in ft
 - **_*Departure Runway_:** Departure runway designation
 - **Runway Condition:** Runway Condition {DRY|WET|CONTAMINATED}
 - **\*Initial Heading:** Initial heading after departure
 - **_*Initial Altitude (ft)_:** Initial altitude
 - **\*Initial CRS 1:** Course NAV 1
 - **\*Initial CRS 2:** Course NAV 2
 
<div style="page-break-after: always;"></div>

#### DEPARTURE ROUTING section

(may need to be revised - makes not sense in the briefing flow)

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/deprouting.PNG)

 - **Departure Type:** {SID|VECTORS|TRACKING}
 - **Departure Route:** Name of Standard Instrument Departure route
 - **Departure Transition:** Transition waypoint out of the SID
 - **NADP:** {NOT REQUIRED|SEE SID}
 - **Departure Frequency:** Frequency of Departure controller

<div style="page-break-after: always;"></div>

#### DEPARTURE RETURN TO AIRPORT section

Only use this if you want to be fully prepared - otherwise it is optional and not needed.
The idea is to prepare the return to the same airport and if you need to then use the COPY button to put this in the approach flows further down.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/depreturn.PNG)

 - **Expect Approach:** Aircraft specific list of approach types
 - **NAV1/ILS Frequency:** ILS (NAV1) frequency for the approach if applicable
 - **NAV1 CRS:** Course of ILS if applicable
 - **NAV2 Frequency:** NAV2 frequency for the approach if applicable
 - **NAV2 CRS:** Course of NAV2 if applicable
 - **FAF Altitude (ft):** Final approach fix altitude if applicable
 - **Decision Height/Altitude:** Decision Height or altitude depending on your settings
 - **Go-Around Heading:** Initial heading in case of go-around
 - **Go-Around Altitude:** Go-around altitude
 - **Set approach section [Copy Data]:** Use the button to copy all this into the approach section which will be used by the procedures
 
<div style="page-break-after: always;"></div>

#### DEPARTURE TAKEOFF section

This determines all the activities and automations during the takeoff run.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/takeoff.PNG)

 - **T/O Thrust:** List of aircraft specific takeoff power rating modes
 - **\*T/O Anti Ice:** Aircraft specific Anti-ice options like {NOT REQUIRED|ENGINES ONLY|ENGINES & WING}
 - **\*T/O Packs:** Aircraft specific Packs settings like {ON|OFF|AUTO}
 - **\*T/O Bleed Settings:** Aircraft specific Bleed air settings like {OFF|ON|UNDER PRESSURIZED}
 - **\*Elevator Trim:** Elevator trim setting for takeoff
 - **\*Rudder Trim:** Rudder trim setting for takeoff (usually 0 in sim)
 - **\*Aileron Trim:** Aileron trim setting for takeoff (usually 0 in sim)
 - **\*T/O Flaps:** Aircraft specific flap setting for takeoff
 - **Forced Return:** On forced return you are above or below MLW {UNDERWEIGHT|OVERWEIGHT}
 - **Departure MSA (ft):** Minimum save altitude in departure sector (might move to other section)
 - **\*V1:** Aircraft and circumstances specific V1 speed
 - **\*VR:** Aircraft and circumstances specific rotation speed
 - **\*V2:** Aircraft and circumstances specific V2 speed
 - **\*Autopilot Modes:** Aircraft specific setting of initial A/P modes e.g. {LNAV/VNAV|HDG/FLCH} for B738
 - **Load FMS Takeoff Data [Load FMC Data]:** Copy FMS information into some fields above (does not work with all aircraft)

#### DEPARTURE BRIEFING section

A text you can read aloud which contains a makeshift departure briefing by the pilot flying (yourself)

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/depbrief.PNG)

<div style="page-break-after: always;"></div>

#### ARRIVAL ATIS section

Use this to note down the ATIS from online stations or copy a generated METAR.

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/arrmetar.PNG)

 - **ATIS Frequency:** Frequency of ATIS service
 - **ATIS Information:** Letter of the current ATIS information
 - **ATIS Wind HDG/SPD:** Wind hhh/vv
 - **ATIS Visibility m:** Visibility in meters
 - **ATIS Weather Phenomena:** General phenomena such as rain, fog etc
 - **ATIS Clouds:** Cloud coverage
 - **ATIS Temp/Dewpoint:** Temperature/Dewpoint 
 - **\*ATIS QNH:** QNH in inchHG or mb (HPA)
 - **ATIS Trends:** Trends such as NOSIG, TEMPO
 - **METAR [Load Arrival METAR]:** Load the fields from a METAR in FLIGHT INFORMATION fields

<div style="page-break-after: always;"></div>

#### ARRIVAL DATA section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/arrdata.PNG)

 - **Approach Frequency:** Frequency of approach controller service
 - **_\*Transition Level (FL):_** Active transition level at destination as Flight Level
 - **Arrival Type:** Type of arrival as {STAR|VECTORS}
 - **Arrival Route:** Name of Standard Arrival Route (STAR)
 - **Arrival Transition:** Name of transition waypoint into the arrival route
 - **Arrival MSA (ft):** Minimum Safe Altitude in arrival sector
 - **_\*Airport Elevation (ft):_** Official airport elevation in ft (get from chart or Simbrief)
 - **NADP:** {NOT REQUIRED|SEE SID}

<div style="page-break-after: always;"></div>

#### APPROACH DATA section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/approach.PNG)

 - **Tower Frequency:** Frequency of tower controller service
 - **Expect Approach:** Aircraft specific list of approach types
 - **_*Arrival Runway_:** Arrival runway designation
 - **Runway Condition:** Runway Condition {DRY|WET|CONTAMINATED}
 - **NAV1/ILS Frequency:** ILS (NAV1) frequency for the approach if applicable
 - **NAV1 CRS:** Course of ILS if applicable
 - **NAV2 Frequency:** NAV2 frequency for the approach if applicable
 - **NAV2 CRS:** Course of NAV2 if applicable
 - **FAF Altitude (ft):** Final approach fix altitude if applicable
 - **Decision Height/Altitude:** Decision Height or altitude depending on your settings
 - **Go-Around Heading:** Initial heading in case of go-around
 - **Go-Around Altitude:** Go-around altitude

<div style="page-break-after: always;"></div>

#### APPROACH AIRCRAFT section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/appaircraft.PNG)

 - **\*Landing Flaps:** Aircraft and circumstances specific landing flap setting
 - **\*Vref:** Aircraft and circumstances specific reference speed
 - **\*Vapp:** Aircraft and circumstances specific approach speed (usually take Vref+5)
 - **\*Autobrake:** Aircraft specific auto-brake setting
 - **\*Packs:** Aircraft specific setting of the PACKS during landing
 - **\*Anti Ice:** Aircraft and circumstances specific setting of the anti-ice systems
 - **Reverse Thrust:** Aircraft specific reerse thrust application e.g. {NONE|MINIMUM|FULL}
 - **Load FMS Landing Data [Load FMC Landing Data]:** Copy FMS data to fields (e.g. Vref) if available with your aircraft

<div style="page-break-after: always;"></div>

#### APPROACH GROUND section

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/appground.PNG)

 - **Ground Frequency:** Ground controller frequency
 - **Gate/Stand:** We will park at {GATE|STAND|STAND PUSH-IN REQUIRED}
 - **Parking Position:** If available the parking position designation
 - **\*Power at Stand:** Which type of power is availabel at stand: {EXTERNAL POWER|NO POWER}
 - **Taxi to Position via:** If available the route from the runway exit point to your parking position.


#### APPROACH BRIEFING section

A text you can read aloud which contains a makeshift approach briefing by the pilot flying (yourself)

![PREFERENCES window](https://raw.githubusercontent.com/prokopiu/kpcrew/kpcrew23/documentation/images/appbriefing.PNG)


# KPHardware 2.3-alpha1 (09/2022)
FlyWithLua scripts to standardize hardware functions on many aircraft.
THIS IS A NEW MODULE AND CAN BE OPTIONALLY INSTALLED WITH OR WITHOUT KPCREW!

## Introduction
Are you also tired of having to program individual profiles for Honeycomb devices or switch XP11 Joystick/Keyboard preferences with every aircraft?

### What does it do? 
I use my kphardware lua script to create profiles for individual aircraft once and then use standard commands to program the joystick/keyboard commands.
You set yourself one profile and use it for all supported aircraft.

## Changes
TBD

## Installation

### Prerequisites
You need to have the freeware FlyWithLua NG plugin minimum version 2.7 but I recommend to download the latest version. See [FlyWithLua on the Forum](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) 

### The KPHardware-x.x.x.zip File
KPCrew comes in a Zip-file and needs to be manually installed under your X-Plane-11 folder. The ZIP contains the following folders:
- kpcrew
  - documentation  --> documentation for KPCrew
    - kphardware_manual.md  --> this manual
    - kphardware_manual.pdf  --> PDF version of this manual
  - modules  --> files to go in the FlyWithlua module folder; all the KPCrew and aircraft modules
    - hardware --> hardware modules
      - honeycombAlpha.lua --> commands for Alpha Yoke
      - honeycombBravo.lua --> commands for Bravo Throttle
    - systems --> all aircraft systems and functions (also for kphardware)
      - B738 --> Zibo module
      - DFLT --> XP11 default aircraft module
      - .lua files with general logic
  - scripts  -->  files to go in the FlyWithlua module folder; the main lua script
    - kphardware.lua --> this runs the hardware modules and makes datarefs and commands available
  - readme.md  --> a readme file
  - LICENSE  --> the license terms

### How to Install
Modules and Scripts are FlyWithLua specific folders. Find them  here:

- Your X-Plane-11 Root Folder
  - Resources
    - plugins
      - FlyWithLua
        - scripts  --> put kpcrew2.lua here (overwrite older versions)
        - modules  --> put all lua files in modules folder here

**Make sure that you removed any older files from previous versions of KPHardware first **

### How to Uninstall
Simply remove all the above lua files and folders from the **scripts** and **modules** folder in Resources\plugins\FlyWithLua. 
** DO NOT DELETE SCRIPTS AND MODULE FOLDER!! **


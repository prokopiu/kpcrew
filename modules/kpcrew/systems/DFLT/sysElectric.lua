-- DFLT  airplane 
-- Electric system functionality

local sysElectric = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

-- GA Battery Masters
sysElectric.bat1Switch = TwoStateCmdSwitch:new("bat1","sim/cockpit/electrical/battery_on",0,"sim/electrical/battery_1_on","sim/electrical/battery_1_off","sim/electrical/battery_1_toggle")
sysElectric.bat2Switch = TwoStateCmdSwitch:new("bat2","sim/cockpit/electrical/battery_on",0,"sim/electrical/battery_2_on","sim/electrical/battery_2_off","sim/electrical/battery_2_toggle")

-- GA Alternator Masters
sysElectric.alt1Switch = TwoStateCmdSwitch:new("alt1","sim/cockpit/electrical/generator_on",0,"sim/electrical/generator_1_on","sim/electrical/generator_1_off","sim/electrical/generator_1_toggle")
sysElectric.alt2Switch = TwoStateCmdSwitch:new("alt2","sim/cockpit/electrical/generator_on",1,"sim/electrical/generator_2_on","sim/electrical/generator_2_off","sim/electrical/generator_2_toggle")

-- GA Avionics Bus
sysElectric.avionicsBus = TwoStateCmdSwitch:new("avionics","sim/cockpit/electrical/avionics_on",0,"sim/systems/avionics_on","sim/systems/avionics_off","sim/systems/avionics_toggle")

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

return sysElectric
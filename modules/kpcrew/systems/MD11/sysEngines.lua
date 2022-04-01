-- DFLT airplane 
-- Engine related functionality

local sysEngines = {
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

local drefEngine1Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil = "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil = "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire = "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire = "sim/cockpit2/annunciators/engine_fires"

----------- Switches

-- Reverse Toggle
sysEngines.reverseToggle = TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,"sim/engines/thrust_reverse_toggle") 

----------- Annunciators

-- ENGINE FIRE annunciator
sysEngines.engineFireAnc = CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire,0) > 0 or get(drefEngine2Fire,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- OIL PRESSURE annunciator
sysEngines.OilPressureAnc = CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get(drefEngine1Starter,0) > 0 and get(drefEngine2Starter,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- Reverse Thrust
sysEngines.reverseAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get("sim/cockpit/warnings/annunciators/reverse",0) > 0 then
		return 1
	else
		return 0
	end
end)

sysEngines.eng1FireLight = SimpleAnnunciator:new("eng1fire","Rotate/aircraft/systems/fire_eng_1_alert_lt",0)
sysEngines.eng2FireLight = SimpleAnnunciator:new("eng2fire","Rotate/aircraft/systems/fire_eng_2_alert_lt",0)
sysEngines.eng3FireLight = SimpleAnnunciator:new("eng3fire","Rotate/aircraft/systems/fire_eng_3_alert_lt",0)

sysEngines.engFireLights = CustomAnnunciator:new("firelights",
function () 
	if sysEngines.eng1FireLight:getStatus() == 1 or sysEngines.eng2FireLight:getStatus() == 1 or sysEngines.eng3FireLight:getStatus() == 1  then
		return 1
	else
		return 0
	end
end)

sysEngines.apuFireLight = SimpleAnnunciator:new("apufire","Rotate/aircraft/systems/fire_apu_alert_lt",0)

-- eng ign off light
sysEngines.engIgnOffLight = SimpleAnnunciator:new("engignlight","Rotate/aircraft/systems/eng_ign_off_lt",0)

return sysEngines
-- A350 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysEngines = {
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

local drefEngine1Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire 		= "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire 		= "sim/cockpit2/annunciators/engine_fires"

----------- Switches

-- Reverse Toggle
sysEngines.reverseToggle 	= TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,
	"sim/engines/thrust_reverse_toggle") 

-- engine start switches
sysEngines.startLever1 		= TwoStateDrefSwitch:new("master1","1-sim/eng/cutoff/L/switch",0)
sysEngines.startLever2 		= TwoStateDrefSwitch:new("master2","1-sim/eng/cutoff/R/switch",0)
sysEngines.startLeverGroup 	= SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- engine START SLECTOR
sysEngines.startSelector	= TwoStateDrefSwitch:new("startselector","1-sim/eng/startSwitch",0)

----------- Annunciators

-- ** ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire,0) > 0 or get(drefEngine2Fire,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get(drefEngine1Starter,0) > 0 and get(drefEngine2Starter,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("enginestarter",
function ()
	if get("sim/cockpit/warnings/annunciators/reverse") > 0 then
		return 1
	else
		return 0
	end
end)

return sysEngines
-- A20N JarDesign airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysEngines = {
	engModeCrank 	= -1,
	engModeNorm 	= 0,
	engModeIgnStart	= 1
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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

local drefEngine1Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire 		= "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire 		= "sim/cockpit2/annunciators/engine_fires"

----------- Switches

-- Reverse Toggle
sysEngines.reverseToggle = TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,"sim/engines/thrust_reverse_toggle") 

-- Engine Master Switches
sysEngines.engMaster1 = TwoStateDrefSwitch:new("engmstr1","sim/custom/xap/engines/eng1msw",0)
sysEngines.engMaster2 = TwoStateDrefSwitch:new("engmstr2","sim/custom/xap/engines/eng2msw",0)
sysEngines.engMstrGroup = SwitchGroup:new("engMstrs")
sysEngines.engMstrGroup:addSwitch(sysEngines.engMaster1)
sysEngines.engMstrGroup:addSwitch(sysEngines.engMaster2)

-- Engine Mode Selector
sysEngines.engModeSelector = TwoStateDrefSwitch:new("engmode","sim/custom/xap/engines/startsel",0)

-- Fire Tests
sysEngines.apuFireTest = TwoStateDrefSwitch:new("apufire","sim/custom/xap/firetest/apu",0)

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

sysEngines.oilqty1 = SimpleAnnunciator:new("oilqty1","sim/custom/xap/engines/oilquan_eng1",0)
sysEngines.oilqty2 = SimpleAnnunciator:new("oilqty1","sim/custom/xap/engines/oilquan_eng2",0)

return sysEngines
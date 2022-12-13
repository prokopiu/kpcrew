-- A359 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysEngines = {
	startSelectorNORM = 1
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

--------- Switch datarefs common

local drefStartLever1		= "1-sim/eng/cutoff/L/switch"
local drefStartLever2		= "1-sim/eng/cutoff/R/switch"
local drefIgnitionSelector	= "1-sim/eng/startSwitch"

--------- Annunciator datarefs common

local drefReverserState		= "sim/cockpit/warnings/annunciators/reverse"
local drefThrustLever1		= "1-sim/L/throttle"
local drefThrustLever2		= "1-sim/R/throttle"
local drefReverseLever1		= "1-sim/L/reverser"
local drefReverseLever2		= "1-sim/R/reverser"
local drefEngine1Fire 	 	= ""
local drefEngine2Fire 	 	= ""
local drefAPUFire 		 	= ""
local drefEngine1Starter 	= ""
local drefEngine2Starter 	= ""
local drefEngine1Oil 	 	= ""
local drefEngine2Oil 	 	= ""

--------- Switch commands common

local cmdReverserToggle		= "sim/engines/thrust_reverse_toggle"
local cmdStartLever1Off		= ""
local cmdStartLever1On		= ""
local cmdStartLever1Tgl		= ""
local cmdStartLever2Off		= ""
local cmdStartLever2On		= ""
local cmdStartLever2Tgl		= ""
local cmdIgnSelectorDown	= ""
local cmdIgnSelectorUp		= ""

--------- Actuator definitions

-- Reverse Toggle
sysEngines.reverseToggle 	= TwoStateToggleSwitch:new("reverse",drefReverserState,0,cmdReverserToggle) 

-- engine start switches
sysEngines.startLever1 		= TwoStateDrefSwitch:new("master1",drefStartLever1,0)
sysEngines.startLever2 		= TwoStateDrefSwitch:new("master2",drefStartLever2,0)
sysEngines.startLeverGroup 	= SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- engine START SELECTOR
sysEngines.ignSelectSwitch	= TwoStateDrefSwitch:new("startselector",drefIgnitionSelector,0)

----------- Annunciators

-- ** Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("reverserstate",
function ()
	if get(drefReverserState,0) > 0 then
		return 1
	else
		return 0
	end
end)

-- Thrust lever state
sysEngines.thrustLever1 	= SimpleAnnunciator:new ("",drefThrustLever1,0)
sysEngines.thrustLever2 	= SimpleAnnunciator:new ("",drefThrustLever2,0)

-- Reverser lever state
sysEngines.reverseLever1 	= SimpleAnnunciator:new("",drefReverseLever1,0)
sysEngines.reverseLever2 	= SimpleAnnunciator:new("",drefReverseLever2,0)

-- ** ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
function ()
	-- if get(drefEngine1Fire,0) > 0 or get(drefEngine2Fire,1) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- ** OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
function ()
	-- if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	-- if get(drefEngine1Starter,0) > 0 and get(drefEngine2Starter,1) > 0 then
		-- return 1
	-- else
		return 0
	-- end
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
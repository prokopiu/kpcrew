-- A333 airplane 
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

-- Starter Switches
sysEngines.engStart1Switch	= TwoStateDrefSwitch:new("starter1","laminar/A333/switches/engine1_start_pos",0)
sysEngines.engStart2Switch	= TwoStateDrefSwitch:new("starter2","laminar/A333/switches/engine2_start_pos",0)
sysEngines.engStart3Switch	= InopSwitch:new("starter3")
sysEngines.engStart4Switch	= InopSwitch:new("starter4")
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get("laminar/A333/switches/engine1_start_pos",0) > 0 or get("laminar/A333/switches/engine2_start_pos",1) > 0 then
		return 1
	else
		return 0
	end
end)

-- Airbus ENG MODE SELECTOR
sysEngines.engModeSelector	= TwoStateDrefSwitch:new("engmodesel","sim/cockpit2/engine/actuators/eng_mode_selector",0)

-- ** OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
function ()
	-- if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- Oil Quantity
sysEngines.oilqty1 = SimpleAnnunciator:new("oilqty1","sim/flightmodel/engine/ENGN_oil_quan",-1)
sysEngines.oilqty2 = SimpleAnnunciator:new("oilqty2","sim/flightmodel/engine/ENGN_oil_quan",1)

-- ** ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
function ()
	if get("laminar/A333/annun/engine1_fire",0) > 0 or get("laminar/A333/annun/engine2_fire",1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("reversers",
function ()
	if get("laminar/A333/fws/tla1_rev") > 0 or get("laminar/A333/fws/tla2_rev") then
		return 1
	else
		return 0
	end
end)

return sysEngines
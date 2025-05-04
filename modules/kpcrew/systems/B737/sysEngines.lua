-- B737 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

logMsg("B737 sysEngines")

-- STARTER Switches
-- if kc_is_zibo then
	-- sysEngines.engStart1Switch 	= MultiStateCmdSwitch:new("","laminar/B738/engine/starter1_pos",0,
		-- "laminar/B738/knob/eng1_start_left","laminar/B738/knob/eng1_start_right",0,3,true)
	-- sysEngines.engStart2Switch 	= MultiStateCmdSwitch:new("","laminar/B738/engine/starter2_pos",0,
		-- "laminar/B738/knob/eng2_start_left","laminar/B738/knob/eng2_start_right",0,3,true)
-- else
	-- sysEngines.engStart1Switch 	= MultiStateCmdSwitch:new("","laminar/B738/spring_knob/starter_1",0,
		-- "laminar/B738/knob/starter1_dn","laminar/B738/knob/starter1_up",-1,2,true)
	-- sysEngines.engStart2Switch 	= MultiStateCmdSwitch:new("","laminar/B738/spring_knob/starter_2",0,
		-- "laminar/B738/knob/starter2_dn","laminar/B738/knob/starter2_up",-1,2,true)
-- end
-- sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
-- sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
-- sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

return sysEngines

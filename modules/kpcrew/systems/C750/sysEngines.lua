-- C750 airplane 
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

-- Starter Switches
sysEngines.engStart1Switch	= TwoStateCmdSwitch:new("starter1","laminar/CitX/engine/starter_left",0,
	"laminar/CitX/engine/cmd_starter_left","laminar/CitX/engine/cmd_starter_stop","nocommand")
sysEngines.engStart2Switch	= TwoStateCmdSwitch:new("starter2","laminar/CitX/engine/starter_right",0,
	"laminar/CitX/engine/cmd_starter_right","laminar/CitX/engine/cmd_starter_stop","nocommand")
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

sysEngines.igniter1 		= TwoStateCustomSwitch:new("igniter1","laminar/CitX/engine/ignition_switch_left",0,
	function () 
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_up")
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_up")
	end,
	function () 
		if get("laminar/CitX/engine/ignition_switch_left") == 1 then
			command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
		elseif get("laminar/CitX/engine/ignition_switch_left") == -1 then
			command_once("laminar/CitX/engine/cmd_ignition_switch_left_up")
		end
	end,
	function () 
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
	end	
)
sysEngines.igniter2 		= TwoStateCustomSwitch:new("igniter1","laminar/CitX/engine/ignition_switch_right",0,
	function () 
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_up")
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_up")
	end,
	function () 
		if get("laminar/CitX/engine/ignition_switch_right") == 1 then
			command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
		elseif get("laminar/CitX/engine/ignition_switch_right") == -1 then
			command_once("laminar/CitX/engine/cmd_ignition_switch_right_up")
		end
	end,
	function () 
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
	end	
)
sysEngines.igniterGroup = SwitchGroup:new("igniters")
sysEngines.igniterGroup:addSwitch(sysEngines.igniter1)
sysEngines.igniterGroup:addSwitch(sysEngines.igniter2)

return sysEngines
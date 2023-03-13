-- C750 airplane 
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

local drefReverserState		= "sim/cockpit2/annunciators/reverser_on"
local drefEngine1Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire 		= "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire 		= "sim/cockpit2/annunciators/engine_fires"

----------- Switches

-- Starter Switches
sysEngines.engStart1Switch	= TwoStateCmdSwitch:new("starter1","laminar/CitX/engine/starter_left",0,
	"laminar/CitX/engine/cmd_starter_left","laminar/CitX/engine/cmd_starter_stop","nocommand")
sysEngines.engStart2Switch	= TwoStateCmdSwitch:new("starter2","laminar/CitX/engine/starter_right",0,
	"laminar/CitX/engine/cmd_starter_right","laminar/CitX/engine/cmd_starter_stop","nocommand")
-- sysEngines.engStart3Switch	= InopSwitch:new("starter3")
-- sysEngines.engStart4Switch	= InopSwitch:new("starter4")
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
-- sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
-- sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)

-- Reversers
sysEngines.reverser1 		= TwoStateCustomSwitch:new("reverse1",drefReverserState,-1,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_1")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_1")
	end,
	function () 
	end	
)
sysEngines.reverser2 		= TwoStateCustomSwitch:new("reverse2",drefReverserState,1,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_2")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_2")
	end,
	function () 
	end	
)
sysEngines.reverser3 		= TwoStateCustomSwitch:new("reverse3",drefReverserState,2,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_3")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_3")
	end,
	function () 
	end	
)
sysEngines.reverser4 		= TwoStateCustomSwitch:new("reverse4",drefReverserState,3,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_4")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_4")
	end,
	function () 
	end	
)
sysEngines.reverserGroup 	= SwitchGroup:new("reversers")
sysEngines.reverserGroup:addSwitch(sysEngines.reverser1)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser2)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser3)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser4)

-- ** Magnetos
sysEngines.magnetoOff		= InopSwitch:new("magnetoOff")
sysEngines.magnetoL			= InopSwitch:new("magnetoL")
sysEngines.magnetoR			= InopSwitch:new("magnetoR")
sysEngines.magnetoBoth		= InopSwitch:new("magnetoBoth")
sysEngines.magnetoStartOn	= InopSwitch:new("magnetoStart")
sysEngines.magnetoStartStop	= InopSwitch:new("magnetoStart")

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
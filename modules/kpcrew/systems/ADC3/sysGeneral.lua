-- ADC3 airplane 
-- aircraft general systems

-- @classmod sysGeneral
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("ADC3 sysGeneral")

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1",drefSlider,-1,
	function () 
		command_once("sim/flight_controls/door_open_1")
	end,
	function () 
		command_once("sim/flight_controls/door_close_1")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",0) == 0 then
			command_once("sim/flight_controls/door_open_1")
		else
			command_once("sim/flight_controls/door_close_1")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo","sim/cockpit2/switches/door_open",1,
	function () 
		command_once("sim/flight_controls/door_open_2")
	end,
	function () 
		command_once("sim/flight_controls/door_close_2")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",1) == 0 then
			command_once("sim/flight_controls/door_open_6")
		else
			command_once("sim/flight_controls/door_close_6")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",1) ~= 0 then
			return 1
		else
			return 0
		end
	end)

-- Door annunciators
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1","sim/cockpit2/switches/door_open",0)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago","sim/cockpit2/switches/door_open",1)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

return sysGeneral
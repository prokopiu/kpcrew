-- E55P airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysGeneral = {
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("E55P sysGeneral")

sysGeneral.doorL1			= TwoStateCmdSwitch:new("doorl1","sim/cockpit2/switches/door_open",-1,
	"sim/flight_controls/door_open_1","sim/flight_controls/door_close_1","sim/flight_controls/door_toggle_1")
sysGeneral.doorL2			= InopSwitch:new("doorl2")
sysGeneral.doorR1			= InopSwitch:new("doorr1")
sysGeneral.doorR2			= InopSwitch:new("doorr2")
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo","sim/cockpit2/switches/custom_slider_on",1,
	function () 
		set_array("sim/cockpit2/switches/custom_slider_on",1,1)
		set_array("sim/cockpit2/switches/custom_slider_on",2,1)
	end,
	function () 
		set_array("sim/cockpit2/switches/custom_slider_on",1,0)
		set_array("sim/cockpit2/switches/custom_slider_on",2,0)
	end,
	function () 
		command_once("sim/operation/slider_02")
		command_once("sim/operation/slider_03")
	end,
	function () 
		if get("sim/cockpit2/switches/custom_slider_on",1) ~= 0 or get("sim/cockpit2/switches/custom_slider_on",2) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","sim/cockpit2/switches/custom_slider_on",3)
sysGeneral.cockpitDoor 		= InopSwitch:new("cockpitdoor")
sysGeneral.stairsL1 		= InopSwitch:new("stairs1")

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairsL1)

-- Door annunciators
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1","sim/cockpit2/switches/door_open",-1)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2","sim/cockpit2/switches/custom_slider_on",2)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1","sim/cockpit2/switches/custom_slider_on",2)
sysGeneral.doorR2Anc 		= SimpleAnnunciator:new("doorr2","sim/cockpit2/switches/custom_slider_on",2)
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo","sim/cockpit2/switches/custom_slider_on",1)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago","sim/cockpit2/switches/custom_slider_on",3)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorL2Anc:getStatus() +
				sysGeneral.doorR1Anc:getStatus() +
				sysGeneral.doorR2Anc:getStatus() +
				sysGeneral.doorFCargoAnc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)


return sysGeneral
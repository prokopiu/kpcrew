-- A333 airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysGeneral = {
	wiperPosOff 	= 0,
	wiperPosSlow 	= 1,
	wiperPosFast	= 2
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

-- Landing Gear
sysGeneral.GearSwitch 		= TwoStateCmdSwitch:new("gear","sim/cockpit2/controls/gear_handle_down",0,
	"sim/flight_controls/landing_gear_down","sim/flight_controls/landing_gear_up","nocommand")

-- Gear Lights for annunciators
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear", "laminar/A333/annun/landing_gear/left_green",0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("gear", "laminar/A333/annun/landing_gear/nose_green",0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear", "laminar/A333/annun/landing_gear/right_green",0)
sysGeneral.gearLeftRedAnc 	= InopSwitch:new("gear")
sysGeneral.gearRightRedAnc 	= InopSwitch:new("gear")
sysGeneral.gearNodeRedAnc 	= InopSwitch:new("gear")

-- light on when gears extended else 0
sysGeneral.gearLightsAnc 	= CustomAnnunciator:new("gearlights", 
function () 
	local sum = sysGeneral.gearLeftGreenAnc:getStatus() +
				sysGeneral.gearRightGreenAnc:getStatus() +
				sysGeneral.gearNodeGreenAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

-- park brake
sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
function ()
	if get("laminar/A333/switches/park_brake_pos") > 0 then
		return 1
	else
		return 0
	end
end)

local drefSlider 			= "sim/cockpit2/switches/door_open"

-- Doors
sysGeneral.doorL1			= TwoStateToggleSwitch:new("doorl1",drefSlider,-1,"sim/flight_controls/door_toggle_1")
sysGeneral.doorL2			= TwoStateToggleSwitch:new("doorl2",drefSlider,2,"sim/flight_controls/door_toggle_3")
sysGeneral.doorL3			= TwoStateToggleSwitch:new("doorl3",drefSlider,4,"sim/flight_controls/door_toggle_5")
sysGeneral.doorL4			= TwoStateToggleSwitch:new("doorl4",drefSlider,6,"sim/flight_controls/door_toggle_7")
sysGeneral.doorR1			= TwoStateToggleSwitch:new("doorr1",drefSlider,1,"sim/flight_controls/door_toggle_2")
sysGeneral.doorR2			= TwoStateToggleSwitch:new("doorr2",drefSlider,3,"sim/flight_controls/door_toggle_4")
sysGeneral.doorR3			= TwoStateToggleSwitch:new("doorr3",drefSlider,5,"sim/flight_controls/door_toggle_6")
sysGeneral.doorR4			= TwoStateToggleSwitch:new("doorr4",drefSlider,7,"sim/flight_controls/door_toggle_8")
sysGeneral.doorFCargo 		= TwoStateToggleSwitch:new("doorfcargo",drefSlider,8,"sim/flight_controls/door_toggle_9")
sysGeneral.doorACargo 		= TwoStateToggleSwitch:new("dooracrago",drefSlider,9,"sim/flight_controls/door_toggle_10")
sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL3)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL4)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR3)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR4)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)

-- Door annunciators
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1",drefSlider,-1)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2",drefSlider,2)
sysGeneral.doorL3Anc 		= SimpleAnnunciator:new("doorl3",drefSlider,4)
sysGeneral.doorL4Anc 		= SimpleAnnunciator:new("doorl4",drefSlider,6)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1",drefSlider,1)
sysGeneral.doorR2Anc 		= SimpleAnnunciator:new("doorr2",drefSlider,3)
sysGeneral.doorR3Anc 		= SimpleAnnunciator:new("doorr3",drefSlider,5)
sysGeneral.doorR4Anc 		= SimpleAnnunciator:new("doorr4",drefSlider,7)
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo",drefSlider,8)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago",drefSlider,9)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorL2Anc:getStatus() +
				sysGeneral.doorL3Anc:getStatus() +
				sysGeneral.doorL4Anc:getStatus() +
				sysGeneral.doorR1Anc:getStatus() +
				sysGeneral.doorR2Anc:getStatus() +
				sysGeneral.doorR3Anc:getStatus() +
				sysGeneral.doorR4Anc:getStatus() +
				sysGeneral.doorFCargoAnc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

-- Weather Radar
sysGeneral.wxRadar			= TwoStateCustomSwitch:new("reverse1","laminar/A333/switches/weather_radar_pos",0,
	function () 
		command_once("laminar/A333/switches/weather_radar_right")
		command_once("laminar/A333/switches/weather_radar_right")
	end,
	function () 
		command_once("laminar/A333/switches/weather_radar_right")
		command_once("laminar/A333/switches/weather_radar_right")
		command_once("laminar/A333/switches/weather_radar_left")
	end,
	function () 
	end	
)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","sim/cockpit2/switches/wiper_speed_switch",-1)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperleft","sim/cockpit2/switches/wiper_speed_switch",1)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "laminar/A333/annun/master_caution",0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "laminar/A333/annun/master_warning",0)

return sysGeneral
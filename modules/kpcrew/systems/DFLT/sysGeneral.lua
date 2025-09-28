-- DFLT airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysGeneral = {
	cmdParkbrake		= "sim/flight_controls/brakes_toggle_max"
}

logMsg("DFLT sysGeneral")

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

local drefSlider 			= "sim/cockpit2/switches/custom_slider_on"
local drefParkbrake			= "sim/cockpit2/controls/parking_brake_ratio"
local drefGearLever			= "sim/cockpit/switches/gear_handle_status"
local drefWiperLeft			= "sim/cockpit2/switches/wiper_speed_switch"
local drefWiperRight		= "sim/cockpit2/switches/wiper_speed_switch"
local indxWiperLeft			= -1
local indxWiperRight		= 1
local drefNoSmoking			= "sim/cockpit2/switches/no_smoking"
local drefSeatBelts			= "sim/cockpit/switches/fasten_seat_belts"

--------- Annunciator datarefs common

local drefAnnGearLeftGreen	= "sim/flightmodel/movingparts/gear1def"
local drefAnnGearRghtGreen	= "sim/flightmodel/movingparts/gear2def"
local drefAnnGearNoseGreen	= "sim/flightmodel/movingparts/gear3def"

--------- Switch commands common

local cmdParkbrake			= "sim/flight_controls/brakes_toggle_max"
local cmdGearDown			= "sim/flight_controls/landing_gear_down"
local cmdGearUp				= "sim/flight_controls/landing_gear_up"

-- Optional Gound objects
sysGeneral.groundObjects = InopSwitch:new("ground objects")

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateToggleSwitch:new("parkbrake",drefParkbrake,0,
	cmdParkbrake)

sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
function ()
	if get(drefParkbrake) > 0 then
		return 1
	else
		return 0
	end
end)

-- Landing Gear
sysGeneral.GearSwitch 		= TwoStateCmdSwitch:new("gear",drefGearLever,0,
	cmdGearDown,cmdGearUp,"nocommand")

-- Gear Lights for annunciators
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear",drefAnnGearLeftGreen,0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("gear",drefAnnGearRghtGreen,0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear",drefAnnGearNoseGreen,0)
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

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1",drefSlider,-1,
	function () 
		command_once("sim/flight_controls/door_open_1")
		if get(drefSlider,0) == 0 then
		   command_once("sim/operation/slider_01")
		end
	end,
	function () 
		command_once("sim/flight_controls/door_close_1")
		if get(drefSlider,0) ~= 0 then
		   command_once("sim/operation/slider_01")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",0) == 0 then
			command_once("sim/flight_controls/door_open_1")
		else
			command_once("sim/flight_controls/door_close_1")
		end
		command_once("sim/operation/slider_01")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",0) ~= 0 or get(drefSlider,0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorL2			= TwoStateCustomSwitch:new("doorl2",drefSlider,1,
	function () 
		command_once("sim/flight_controls/door_open_2")
		if get(drefSlider,1) == 0 then
		   command_once("sim/operation/slider_02")
		end
	end,
	function () 
		command_once("sim/flight_controls/door_close_2")
		if get(drefSlider,1) ~= 0 then
		   command_once("sim/operation/slider_02")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",1) == 0 then
			command_once("sim/flight_controls/door_open_1")
		else
			command_once("sim/flight_controls/door_close_1")
		end
		command_once("sim/operation/slider_02")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",1) ~= 0 or get(drefSlider,1) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR1			= TwoStateCustomSwitch:new("doorr1",drefSlider,2,
	function () 
		command_once("sim/flight_controls/door_open_3")
		if get(drefSlider,2) == 0 then
		   command_once("sim/operation/slider_03")
		end
	end,
	function () 
		command_once("sim/flight_controls/door_close_3")
		if get(drefSlider,2) ~= 0 then
		   command_once("sim/operation/slider_03")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",2) == 0 then
			command_once("sim/flight_controls/door_open_3")
		else
			command_once("sim/flight_controls/door_close_3")
		end
		command_once("sim/operation/slider_03")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",2) ~= 0 or get(drefSlider,2) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR2			= TwoStateCustomSwitch:new("doorr2",drefSlider,3,
	function () 
		command_once("sim/flight_controls/door_open_4")
		if get(drefSlider,3) == 0 then
		   command_once("sim/operation/slider_04")
		end
	end,
	function () 
		command_once("sim/flight_controls/door_close_4")
		if get(drefSlider,3) ~= 0 then
		   command_once("sim/operation/slider_04")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",3) == 0 then
			command_once("sim/flight_controls/door_open_4")
		else
			command_once("sim/flight_controls/door_close_4")
		end
		command_once("sim/operation/slider_04")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",3) ~= 0 or get(drefSlider,3) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo",drefSlider,4,
	function () 
		command_once("sim/flight_controls/door_open_5")
		if get(drefSlider,4) == 0 then
		   command_once("sim/operation/slider_05")
		end
	end,
	function () 
		command_once("sim/flight_controls/door_close_5")
		if get(drefSlider,4) ~= 0 then
		   command_once("sim/operation/slider_05")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",4) == 0 then
			command_once("sim/flight_controls/door_open_5")
		else
			command_once("sim/flight_controls/door_close_5")
		end
		command_once("sim/operation/slider_05")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",4) ~= 0 or get(drefSlider,4) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo",drefSlider,5,
	function () 
		command_once("sim/flight_controls/door_open_6")
		if get(drefSlider,5) == 0 then
		   command_once("sim/operation/slider_06")
		end
	end,
	function () 
		command_once("sim/flight_controls/door_close_6")
		if get(drefSlider,5) ~= 0 then
		   command_once("sim/operation/slider_06")
		end
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",5) == 0 then
			command_once("sim/flight_controls/door_open_6")
		else
			command_once("sim/flight_controls/door_close_6")
		end
		command_once("sim/operation/slider_06")
	end,
	function () 
		if get("sim/cockpit2/switches/door_open",5) ~= 0 or get(drefSlider,5) ~= 0 then
			return 1
		else
			return 0
		end
	end)
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
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1",drefSlider,0)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2",drefSlider,1)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1",drefSlider,2)
sysGeneral.doorR2Anc 		= SimpleAnnunciator:new("doorr2",drefSlider,3)
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo",drefSlider,4)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago",drefSlider,5)

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

-- Windows
sysGeneral.window1			= InopSwitch:new("window1")
sysGeneral.window2			= InopSwitch:new("window2")
sysGeneral.windowGroup 		= SwitchGroup:new("doors")
sysGeneral.windowGroup:addSwitch(sysGeneral.window1)
sysGeneral.windowGroup:addSwitch(sysGeneral.window2)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft",drefWiperLeft,indxWiperLeft)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperright",drefWiperRight,indxWiperRight)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= InopSwitch:new("irsunit1")
sysGeneral.irsUnit2Switch 	= InopSwitch:new("irsunit2")
sysGeneral.irsUnit3Switch 	= InopSwitch:new("irsunit3")
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("nosmoke",drefNoSmoking,0)

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts",drefSeatBelts,0)

sysGeneral.tocheck		 = InopSwitch:new("tockeck")

-- ---------- Annunciators

-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "sim/cockpit2/annunciators/master_caution",0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "sim/cockpit2/annunciators/master_warning",0)

sysGeneral.chrono			= InopSwitch:new("chrono")
sysGeneral.clock			= TwoStateCustomSwitch:new("clock","sim/cockpit2/clock_timer/chrono_running",-1,
	function ()
		set_array("sim/cockpit2/clock_timer/chrono_running",0,kc_et_timer_on)
	end,
	function ()
		set_array("sim/cockpit2/clock_timer/chrono_running",0,kc_et_timer_off)
	end,
	function ()
		set_array("sim/cockpit2/clock_timer/chrono_time",0,0)
	end,
	function ()
		if get("sim/cockpit2/clock_timer/chrono_running",0) == kc_et_timer_on then
			return 1
		else
			return 0
		end
	end)

return sysGeneral
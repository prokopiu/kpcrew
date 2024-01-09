-- DFLT airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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

--------- Switch datarefs common

local drefSlider 			= "sim/cockpit2/switches/custom_slider_on"
local drefParkbrake			= "sim/cockpit2/controls/parking_brake_ratio"
local drefGearLever			= "sim/cockpit/switches/gear_handle_status"
local drefBaroLeft			= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"
local drefBaroRight 		= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot"
local drefBaroStby	 		= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby"

--------- Annunciator datarefs common

local drefCurrentBaro 		= "sim/weather/barometer_sealevel_inhg"

--------- Switch commands common

local cmdParkbrake			= "sim/flight_controls/brakes_toggle_max"
local cmdGearDown			= "sim/flight_controls/landing_gear_down"
local cmdGearUp				= "sim/flight_controls/landing_gear_up"
local cmdBaroLeftDown		= "sim/instruments/barometer_down"
local cmdBaroLeftUp			= "sim/instruments/barometer_up"
local cmdBaroRightDown		= "sim/instruments/barometer_copilot_down"
local cmdBaroRightUp		= "sim/instruments/barometer_copilot_up"
local cmdBaroStbyDown		= "sim/instruments/barometer_stby_down"
local cmdBaroStbyUp			= "sim/instruments/barometer_stby_up"

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateToggleSwitch:new("parkbrake","sim/cockpit2/controls/parking_brake_ratio",0,
	"sim/flight_controls/brakes_toggle_max")

sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
function ()
	if get("sim/cockpit2/controls/parking_brake_ratio") > 0 then
		return 1
	else
		return 0
	end
end)

-- Landing Gear
sysGeneral.GearSwitch 		= TwoStateCmdSwitch:new("gear","sim/cockpit2/controls/gear_handle_down",0,
	"sim/flight_controls/landing_gear_down","sim/flight_controls/landing_gear_up","nocommand")

-- Gear Lights for annunciators
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear", "sim/flightmodel/movingparts/gear1def",0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("gear", "sim/flightmodel/movingparts/gear2def",0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear", "sim/flightmodel/movingparts/gear3def",0)
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

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)

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

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","sim/cockpit2/switches/wiper_speed_switch",-1)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperleft","sim/cockpit2/switches/wiper_speed_switch",1)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- Baro standard toggle
sysGeneral.barostdPilot 	= InopSwitch:new("barostdpilot")
sysGeneral.barostdCopilot 	= InopSwitch:new("barostdcopilot")
sysGeneral.barostdStandby 	= InopSwitch:new("barostdstandby")
sysGeneral.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdPilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdCopilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdStandby)

-- Baro mode
sysGeneral.baroModePilot 	= InopSwitch:new("baromodepilot")
sysGeneral.baroModeCoPilot 	= InopSwitch:new("baromodecopilot")
sysGeneral.baroModeStandby 	= InopSwitch:new("baromodecopilot")
sysGeneral.baroModeGroup 	= SwitchGroup:new("baromodegroup")
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModePilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeCoPilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeStandby)

-- Baro value
sysGeneral.baroPilot 		= MultiStateCmdSwitch:new("baropilot",drefBaroLeft,0,
	cmdBaroLeftDown,cmdBaroLeftUp)
sysGeneral.baroCoPilot 		= MultiStateCmdSwitch:new("barocopilot",drefBaroRight,0,
	cmdBaroRightDown,cmdBaroRightUp)
sysGeneral.baroStandby 		= MultiStateCmdSwitch:new("barostandby",drefBaroStby,0,
	cmdBaroStbyDown,cmdBaroStbyUp)
sysGeneral.baroGroup 		= SwitchGroup:new("barogroup")
sysGeneral.baroGroup:addSwitch(sysGeneral.baroPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroCoPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroStandby)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= InopSwitch:new("irsunit1")
sysGeneral.irsUnit2Switch 	= InopSwitch:new("irsunit2")
sysGeneral.irsUnit3Switch 	= InopSwitch:new("irsunit3")
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)



------------ Annunciators




-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "sim/cockpit2/annunciators/master_caution",0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "sim/cockpit2/annunciators/master_warning",0)


-- baro mbar/inhg
sysGeneral.baroMbar 		= CustomAnnunciator:new("mbar",
function () 
	return get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") * 33.8639 
end)
sysGeneral.baroInhg 		= CustomAnnunciator:new("inhg",
function () 
	return get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") 
end)


return sysGeneral
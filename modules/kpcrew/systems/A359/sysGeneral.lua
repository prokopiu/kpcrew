-- A350 airplane 
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
local drefBaroStby	 		= "AirbusFBW/ISIBaroSetting"
local drefBaroLeftMode 		= "1-sim/pres/pressModeLeft/switch"
local drefBaroRightMode 	= "1-sim/pres/pressModeRight/switch"
local drefBaroStbyMode		= "1-sim/175/button"
local drefBaroLeftStd 		= "AirbusFBW/BaroStdCapt"
local drefBaroRightStd		= "AirbusFBW/BaroStdFO"
local drefBaroStbyStd		= "AirbusFBW/ISIBaroStd"

--------- Annunciator datarefs common

local drefCurrentBaro 		= "sim/weather/barometer_sealevel_inhg"

--------- Switch commands common

local cmdParkbrake			= "sim/flight_controls/brakes_toggle_max"
local cmdGearDown			= "sim/flight_controls/landing_gear_down"
local cmdGearUp				= "sim/flight_controls/landing_gear_up"
local cmdBaroLeftDown		= "1-sim/comm/pressLeftRotaryDN"
local cmdBaroLeftUp			= "1-sim/comm/pressLeftRotaryUP"
local cmdBaroRightDown		= "1-sim/comm/pressRightRotaryDN"
local cmdBaroRightUp		= "1-sim/comm/pressRightRotaryUP"
local cmdBaroStbyDown		= "sim/instruments/barometer_stby_down"
local cmdBaroStbyUp			= "sim/instruments/barometer_stby_up"

--------- Actuator definitions

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateToggleSwitch:new("parkbrake",drefParkbrake,0,
	cmdParkbrake)

-- Landing Gear
sysGeneral.GearSwitch 		= TwoStateCmdSwitch:new("gear",drefGearLever,0,
	cmdGearDown,cmdGearUp,"nocommand")

-- Doors
sysGeneral.doorL1			= TwoStateToggleSwitch:new("doorl1",drefSlider,0,"sim/operation/slider_01")
sysGeneral.doorL2			= TwoStateToggleSwitch:new("doorl2",drefSlider,0,"sim/operation/slider_02")
sysGeneral.doorR1			= TwoStateToggleSwitch:new("doorr1",drefSlider,0,"sim/operation/slider_03")
sysGeneral.doorR2			= TwoStateToggleSwitch:new("doorr2",drefSlider,0,"sim/operation/slider_04")
sysGeneral.doorFCargo 		= TwoStateToggleSwitch:new("doorfcargo",drefSlider,0,"sim/operation/slider_05")
sysGeneral.doorACargo 		= TwoStateToggleSwitch:new("dooracrago",drefSlider,0,"sim/operation/slider_06")
sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)

-- Baro standard toggle
sysGeneral.barostdPilot 	= TwoStateDrefSwitch:new("barostdpilot",drefBaroLeftStd,0)
sysGeneral.barostdCopilot 	= TwoStateDrefSwitch:new("barostdcopilot",drefBaroRightStd,0)
sysGeneral.barostdStandby 	= TwoStateDrefSwitch:new("barostdstandby",drefBaroStbyStd,0)
sysGeneral.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdPilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdCopilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdStandby)

-- Baro mode
sysGeneral.baroModePilot 	= TwoStateDrefSwitch:new("baromodepilot",drefBaroLeftMode,0)
sysGeneral.baroModeCoPilot 	= TwoStateDrefSwitch:new("baromodecopilot",drefBaroRightMode,0)
sysGeneral.baroModeStandby 	= TwoStateDrefSwitch:new("baromodecopilot",drefBaroRightMode,0)
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

-- Windshield Wipers
sysGeneral.wiperSwitch = TwoStateDrefSwitch:new("wiper left","1-sim/misc/wiper/L/switch",0)
sysGeneral.wiperSwitch2 = TwoStateDrefSwitch:new("wiper right","1-sim/misc/wiper/R/switch",0)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperSwitch)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperSwitch2)

------------ Annunciators
-- park brake
sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
function ()
	if get("sim/cockpit2/controls/parking_brake_ratio") > 0 then
		return 1
	else
		return 0
	end
end)

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

-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "sim/cockpit2/annunciators/master_caution",0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "sim/cockpit2/annunciators/master_warning",0)

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
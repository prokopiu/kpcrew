-- A20N JarDesign airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysGeneral = {
	wiperPosOff 	= 0,
	wiperPosSlow 	= 1,
	wiperPosFast	= 2,
	
	ecamModeENG		= 11,
	ecamModeBLEED	= 7,
	ecamModePRESS	= 3,
	ecamModeELEC	= 6,
	ecamModeHYD		= 0,
	ecamModeFUEL	= 1,
	ecamModeAPU		= 2,
	ecamModeCOND	= 8,
	ecamModeDOOR	= 9,
	ecamModeWHEEL	= 5,
	ecamModeFCTL	= 4,
	
	adirsModeOFF	= 0,
	adirsModeNAV	= 1,
	adirsModeATT	= 2
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local Annunciator 			= require "kpcrew.systems.Annunciator"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

local drefCurrentBaro 		= "sim/weather/barometer_sealevel_inhg"
local drefSlider 			= "sim/cockpit2/switches/custom_slider_on"

-- Parking Brake
sysGeneral.parkBrakeSwitch = TwoStateToggleSwitch:new("parkbrake","sim/cockpit2/controls/parking_brake_ratio",0,"sim/flight_controls/brakes_toggle_max")

-- Landing Gear
sysGeneral.GearSwitch = TwoStateCmdSwitch:new("gear","sim/cockpit2/controls/gear_handle_down",0,"sim/flight_controls/landing_gear_down","sim/flight_controls/landing_gear_up","nocommand")

-- Doors
sysGeneral.doorL1 = TwoStateToggleSwitch:new("doorl1",drefSlider,0,"sim/operation/slider_01")
sysGeneral.doorL2 = TwoStateToggleSwitch:new("doorl2",drefSlider,0,"sim/operation/slider_02")
sysGeneral.doorR1 = TwoStateToggleSwitch:new("doorr1",drefSlider,0,"sim/operation/slider_03")
sysGeneral.doorR2 = TwoStateToggleSwitch:new("doorr2",drefSlider,0,"sim/operation/slider_04")
sysGeneral.doorFCargo = TwoStateToggleSwitch:new("doorfcargo",drefSlider,0,"sim/operation/slider_05")
sysGeneral.doorACargo = TwoStateToggleSwitch:new("dooracrago",drefSlider,0,"sim/operation/slider_06")

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)

-- Baro standard toggle
-- sysGeneral.barostdPilot = TwoStateToggleSwitch:new("barostdpilot","laminar/B738/EFIS/baro_set_std_pilot",0,"laminar/B738/EFIS_control/capt/push_button/std_press")
-- sysGeneral.barostdCopilot = TwoStateToggleSwitch:new("barostdcopilot","laminar/B738/EFIS/baro_set_std_copilot",0,"laminar/B738/EFIS_control/fo/push_button/std_press")
-- sysGeneral.barostdStandby = TwoStateToggleSwitch:new("barostdstandby","laminar/B738/gauges/standby_alt_std_mode",0,"laminar/B738/toggle_switch/standby_alt_baro_std")

sysGeneral.barostdGroup = SwitchGroup:new("barostdgroup")
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdPilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdCopilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdStandby)

-- Baro mode
sysGeneral.baroModePilot = InopSwitch:new("baromodepilot")
sysGeneral.baroModeCoPilot = InopSwitch:new("baromodecopilot")
sysGeneral.baroModeStandby = InopSwitch:new("baromodecopilot")

sysGeneral.baroModeGroup = SwitchGroup:new("baromodegroup")
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModePilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeCoPilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeStandby)

-- Baro value

sysGeneral.baroPilot = MultiStateCmdSwitch:new("baropilot","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",0,"sim/instruments/barometer_down","sim/instruments/barometer_up")
sysGeneral.baroCoPilot = MultiStateCmdSwitch:new("barocopilot","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot",0,"sim/instruments/barometer_copilot_down","sim/instruments/barometer_copilot_up")
sysGeneral.baroStandby = MultiStateCmdSwitch:new("barostandby","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby",0,"sim/instruments/barometer_stby_down","sim/instruments/barometer_stby_up")

sysGeneral.baroGroup = SwitchGroup:new("barogroup")
sysGeneral.baroGroup:addSwitch(sysGeneral.baroPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroCoPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroStandby)

sysGeneral.irsUnit1Switch = TwoStateDrefSwitch:new("irsunit1","sim/custom/xap/adirs/mode_sel_1",0)
sysGeneral.irsUnit2Switch = TwoStateDrefSwitch:new("irsunit2","sim/custom/xap/adirs/mode_sel_2",0)
sysGeneral.irsUnit3Switch = TwoStateDrefSwitch:new("irsunit3","sim/custom/xap/adirs/mode_sel_3",0)
sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","sim/custom/xap/icerain/wiper_l",0)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperleft","sim/custom/xap/icerain/wiper_r",0)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- ECAM Mode panel
sysGeneral.ECAMMode = TwoStateDrefSwitch:new("lecammode","sim/custom/xap/disp/sys/mode",0)

-- Chocks
sysGeneral.chocksLeft = TwoStateDrefSwitch:new("checksleft","sim/custom/xap/chocks_l",0)
sysGeneral.chocksRight = TwoStateDrefSwitch:new("checksright","sim/custom/xap/chocks_r",0)
sysGeneral.chocksGroup = SwitchGroup:new("chocks")
sysGeneral.chocksGroup:addSwitch(sysGeneral.chocksLeft)
sysGeneral.chocksGroup:addSwitch(sysGeneral.chocksRight)

-- OxygenSupply
sysGeneral.oxyCrewSupply = TwoStateDrefSwitch:new("crewOxySupl","sim/custom/xap/oxy/crewsupp",0)

-- Passenger Signs
sysGeneral.seatBeltSwitch 	= TwoStateDrefSwitch:new("seatbelts","sim/cockpit/switches/fasten_seat_belts",0)
sysGeneral.noSmokingSwitch 	= TwoStateDrefSwitch:new("nosmoking","sim/cockpit/switches/no_smoking",0)
sysGeneral.emerExitLights = TwoStateDrefSwitch:new("emerexitlight","sim/custom/xap/extlight/emer_ext_lt",0)

-- CLOCK
sysGeneral.timerStartStop = TwoStateToggleSwitch:new("timerstartstop","sim/time/timer_is_running_sec",0,"sim/instruments/timer_start_stop")
sysGeneral.timerReset = TwoStateToggleSwitch:new("timerreset","sim/cockpit2/clock_timer/timer_running",0,"sim/instruments/timer_reset")
sysGeneral.etReset = TwoStateDrefSwitch:new("etreset","sim/custom/xap/et_timer/mode",0)

-- Anti Skid
sysGeneral.antiSkid = TwoStateDrefSwitch:new("antiskid","sim/custom/xap/wheels/ant_skeed",0)

-- WX Radar
sysGeneral.wxRadar = TwoStateDrefSwitch:new("exradar","sim/cockpit2/EFIS/EFIS_weather_on",0)

-- Cockpit Doors
sysGeneral.cockpitDoor = TwoStateDrefSwitch:new("cockpitdoor","sim/custom/xap/c_door",0)
sysGeneral.cockpitLock = TwoStateDrefSwitch:new("cockpitLock","jd/c_door/lock",0)

------------ Annunciators
-- park brake
sysGeneral.parkbrakeAnc = CustomAnnunciator:new("parkbrake",
function ()
	if get("sim/cockpit2/controls/parking_brake_ratio") > 0 then
		return 1
	else
		return 0
	end
end)

-- Gear Lights for annunciators
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear", "sim/flightmodel/movingparts/gear1def", 0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("gear", "sim/flightmodel/movingparts/gear2def", 0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear", "sim/flightmodel/movingparts/gear3def", 0)
sysGeneral.gearLeftRedAnc = Annunciator:new("gear")
sysGeneral.gearRightRedAnc = Annunciator:new("gear")
sysGeneral.gearNodeRedAnc = Annunciator:new("gear")

-- light on when gears extended else 0
sysGeneral.gearLightsAnc = CustomAnnunciator:new("gearlights", 
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
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "sim/cockpit2/annunciators/master_caution", 0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "sim/cockpit2/annunciators/master_warning", 0)

-- Door annunciators
sysGeneral.doorL1Anc = SimpleAnnunciator:new("doorl1",drefSlider,0)
sysGeneral.doorL2Anc = SimpleAnnunciator:new("doorl2",drefSlider,1)
sysGeneral.doorR1Anc = SimpleAnnunciator:new("doorr1",drefSlider,2)
sysGeneral.doorR2Anc = SimpleAnnunciator:new("doorr2",drefSlider,3)
sysGeneral.doorFCargoAnc = SimpleAnnunciator:new("doorfcargo",drefSlider,4)
sysGeneral.doorACargoAnc = SimpleAnnunciator:new("dooracrago",drefSlider,5)

sysGeneral.doorsAnc = CustomAnnunciator:new("doors", 
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
sysGeneral.baroMbar = CustomAnnunciator:new("mbar",
function () 
	return get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") * 33.8639 
end)
sysGeneral.baroInhg = CustomAnnunciator:new("inhg",
function () 
	return get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") 
end)

-- Oxygen pressure
-- sysGeneral.oxyPsi = SimpleAnnunciator:new("oxypsi","xhsi/mfd/",0)

-- GPWS annunciator group
sysGeneral.gpwsAnnunciators = CustomAnnunciator:new("gpwsannunc",
function () 
	local sum = get("sim/custom/xap/gpws_flap") +
				get("sim/custom/xap/gpws_gs") +
				get("sim/custom/xap/gpws_sys") +
				get("sim/custom/xap/gpws_terr")
	if sum < 4 then 
		return 1
	else
		return 0
	end
end)



return sysGeneral
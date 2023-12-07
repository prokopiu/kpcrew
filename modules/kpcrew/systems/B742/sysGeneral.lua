-- DFLT airplane 
-- aircraft general systems

local sysGeneral = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"
local Annunciator = require "kpcrew.systems.Annunciator"

local drefCurrentBaro = "sim/weather/barometer_sealevel_inhg"
local drefSlider = "sim/cockpit2/switches/custom_slider_on"

-- Parking Brake
sysGeneral.parkBrakeSwitch = TwoStateToggleSwitch:new("parkbrake","laminar/B747/flt_ctrls/parking_brake_ratio",0,"laminar/B747/flt_ctrls/parking_brake_toggle")

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
sysGeneral.barostdPilot = TwoStateToggleSwitch:new("barostdpilot","laminar/B738/EFIS/baro_set_std_pilot",0,"laminar/B738/EFIS_control/capt/push_button/std_press")
sysGeneral.barostdCopilot = TwoStateToggleSwitch:new("barostdcopilot","laminar/B738/EFIS/baro_set_std_copilot",0,"laminar/B738/EFIS_control/fo/push_button/std_press")
sysGeneral.barostdStandby = TwoStateToggleSwitch:new("barostdstandby","laminar/B738/gauges/standby_alt_std_mode",0,"laminar/B738/toggle_switch/standby_alt_baro_std")

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

sysGeneral.irsUnit1Switch = InopSwitch:new("irsunit1")
sysGeneral.irsUnit2Switch = InopSwitch:new("irsunit2")
sysGeneral.irsUnit3Switch = InopSwitch:new("irsunit3")

sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

sysGeneral.wiperLeft = MultiStateCmdSwitch:new("wiperleft","laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_pos",0,"laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_dn","laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_up")
sysGeneral.wiperRight = MultiStateCmdSwitch:new("wiperright","laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_pos",0,"laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_dn","laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_up")
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

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


return sysGeneral
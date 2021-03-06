-- B738 airplane 
-- aircraft general systems

local sysGeneral = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"

-- Parking Brake
sysGeneral.parkBrakeSwitch = TwoStateToggleSwitch:new("parkbrake","sim/cockpit2/controls/parking_brake_ratio",0,"laminar/B738/push_button/park_brake_on_off")

-- Landing Gear
sysGeneral.GearSwitch = TwoStateCmdSwitch:new("gear","laminar/B738/controls/gear_handle_down",0,"sim/flight_controls/landing_gear_down","sim/flight_controls/landing_gear_up","laminar/B738/push_button/gear_off")

-- Doors
sysGeneral.doorL1 = TwoStateToggleSwitch:new("doorl1","737u/doors/L1",0,"laminar/B738/door/fwd_L_toggle")
sysGeneral.doorL2 = TwoStateToggleSwitch:new("doorl2","737u/doors/L2",0,"laminar/B738/door/aft_L_toggle")
sysGeneral.doorR1 = TwoStateToggleSwitch:new("doorr1","737u/doors/R1",0,"laminar/B738/door/fwd_R_toggle")
sysGeneral.doorR2 = TwoStateToggleSwitch:new("doorr2","737u/doors/R2",0,"laminar/B738/door/aft_R_toggle")
sysGeneral.doorFCargo = TwoStateToggleSwitch:new("doorfcargo","737u/doors/Fwd_Cargo",0,"laminar/B738/door/fwd_cargo_toggle")
sysGeneral.doorACargo = TwoStateToggleSwitch:new("dooracrago","737u/doors/aft_Cargo",0,"laminar/B738/door/aft_cargo_toggle")

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
sysGeneral.baroModePilot = TwoStateCmdSwitch:new("baromodepilot","laminar/B738/EFIS_control/capt/baro_in_hpa",0,"laminar/B738/EFIS_control/capt/baro_in_hpa_up","laminar/B738/EFIS_control/capt/baro_in_hpa_dn","nocommand")
sysGeneral.baroModeCoPilot = TwoStateCmdSwitch:new("baromodecopilot","laminar/B738/EFIS_control/fo/baro_in_hpa",0,"laminar/B738/EFIS_control/fo/baro_in_hpa_dn","laminar/B738/EFIS_control/fo/baro_in_hpa_up","nocommand")
sysGeneral.baroModeStandby = TwoStateToggleSwitch:new("baromodecopilot","laminar/B738/EFIS_control/fo/baro_in_hpa",0,"laminar/B738/EFIS_control/fo/baro_in_hpa_dn","laminar/B738/EFIS_control/fo/baro_in_hpa_up","nocommand")

sysGeneral.baroModeGroup = SwitchGroup:new("baromodegroup")
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModePilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeCoPilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeStandby)

-- Baro value

sysGeneral.baroPilot = MultiStateCmdSwitch:new("baropilot","laminar/B738/EFIS/baro_sel_in_hg_pilot",0,"laminar/B738/pilot/barometer_down","laminar/B738/pilot/barometer_up")
sysGeneral.baroCoPilot = MultiStateCmdSwitch:new("barocopilot","laminar/B738/EFIS/baro_sel_in_hg_copilot",0,"laminar/B738/copilot/barometer_down","laminar/B738/copilot/barometer_up")
sysGeneral.baroStandby = MultiStateCmdSwitch:new("barostandby","laminar/B738/knobs/standby_alt_baro",0,"laminar/B738/knob/standby_alt_baro_dn","laminar/B738/knob/standby_alt_baro_up")

sysGeneral.baroGroup = SwitchGroup:new("barogroup")
sysGeneral.baroGroup:addSwitch(sysGeneral.baroPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroCoPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroStandby)

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
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear", "laminar/B738/annunciator/left_gear_safe", 0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("gear", "laminar/B738/annunciator/right_gear_safe", 0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear", "laminar/B738/annunciator/nose_gear_safe", 0)
sysGeneral.gearLeftRedAnc = SimpleAnnunciator:new("gear", "laminar/B738/annunciator/left_gear_transit", 0)
sysGeneral.gearRightRedAnc = SimpleAnnunciator:new("gear", "laminar/B738/annunciator/right_gear_transit", 0)
sysGeneral.gearNodeRedAnc = SimpleAnnunciator:new("gear", "laminar/B738/annunciator/nose_gear_transit", 0)

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
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "laminar/B738/annunciator/master_caution_light", 0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "sim/cockpit2/annunciators/master_warning", 0)

-- Door annunciators
sysGeneral.doorL1Anc = SimpleAnnunciator:new("doorl1","737u/doors/L1",0)
sysGeneral.doorL2Anc = SimpleAnnunciator:new("doorl2","737u/doors/L2",0)
sysGeneral.doorR1Anc = SimpleAnnunciator:new("doorr1","737u/doors/R1",0)
sysGeneral.doorR2Anc = SimpleAnnunciator:new("doorr2","737u/doors/R2",0)
sysGeneral.doorFCargoAnc = SimpleAnnunciator:new("doorfcargo","737u/doors/Fwd_Cargo",0)
sysGeneral.doorACargoAnc = SimpleAnnunciator:new("dooracrago","737u/doors/aft_Cargo",0)

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

return sysGeneral
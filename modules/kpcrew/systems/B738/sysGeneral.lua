-- B738 airplane 
-- aircraft general systems

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

local sysGeneral = {
	irsUnitMin = 0,
	irsUnitMax = 3,
	irsUnitOFF = 0,
	irsUnitALIGN = 1,
	irsUnitNAV = 2,
	irsUnitATT = 3;

	wiperPark = 0,
	wiperInt = 1,
	wiperLow = 2,
	wiperHigh = 3
}

-- Parking Brake
sysGeneral.parkBrakeSwitch = TwoStateToggleSwitch:new("parkbrake","sim/cockpit2/controls/parking_brake_ratio",0,"laminar/B738/push_button/park_brake_on_off")

-- Landing Gear
-- sysGeneral.GearSwitch = TwoStateCmdSwitch:new("gear","laminar/B738/controls/gear_handle_down",0,"sim/flight_controls/landing_gear_down","sim/flight_controls/landing_gear_up","laminar/B738/push_button/gear_off")
sysGeneral.GearSwitch = TwoStateCustomSwitch:new("gear","laminar/B738/controls/gear_handle_down",0,
function () command_once("sim/flight_controls/landing_gear_down") end,
function () command_once("sim/flight_controls/landing_gear_up") end,
function () command_once("laminar/B738/push_button/gear_off") end)

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

sysGeneral.cockpitDoor = TwoStateToggleSwitch:new("","laminar/B738/door/flt_dk_door_ratio",0,"laminar/B738/toggle_switch/flt_dk_door_open")

-- Passenger Signs

sysGeneral.seatBeltSwitch = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/seatbelt_sign_pos",0,"laminar/B738/toggle_switch/seatbelt_sign_dn","laminar/B738/toggle_switch/seatbelt_sign_up")
sysGeneral.noSmokingSwitch = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/no_smoking_pos",0,"laminar/B738/toggle_switch/no_smoking_dn","laminar/B738/toggle_switch/no_smoking_up")

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
sysGeneral.baroModeCoPilot = TwoStateCmdSwitch:new("baromodecopilot","laminar/B738/EFIS_control/fo/baro_in_hpa",0,"laminar/B738/EFIS_control/fo/baro_in_hpa_up","laminar/B738/EFIS_control/fo/baro_in_hpa_dn","nocommand")
sysGeneral.baroModeStandby = TwoStateToggleSwitch:new("baromodes","laminar/B738/EFIS_control/fo/baro_in_hpa",0,"laminar/B738/EFIS_control/fo/baro_in_hpa_dn","laminar/B738/EFIS_control/fo/baro_in_hpa_up","nocommand")

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

--- systems not used by kphardware

-- IRS
sysGeneral.irsUnit1Switch = MultiStateCmdSwitch:new("irsunit1","laminar/B738/toggle_switch/irs_left",0,"laminar/B738/toggle_switch/irs_L_left","laminar/B738/toggle_switch/irs_L_right")
sysGeneral.irsUnit2Switch = MultiStateCmdSwitch:new("irsunit2","laminar/B738/toggle_switch/irs_right",0,"laminar/B738/toggle_switch/irs_R_left","laminar/B738/toggle_switch/irs_R_right")
sysGeneral.irsUnit3Switch = InopSwitch:new("irsunit3")

sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
-- sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

-- Wipers

sysGeneral.wiperLeftSwitch = MultiStateCmdSwitch:new("","laminar/B738/switches/left_wiper_pos",0,"laminar/B738/knob/left_wiper_dn","laminar/B738/knob/left_wiper_up")
sysGeneral.wiperRightSwitch = MultiStateCmdSwitch:new("","laminar/B738/switches/right_wiper_pos",0,"laminar/B738/knob/right_wiper_dn","laminar/B738/knob/right_wiper_up")

sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeftSwitch)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRightSwitch)

-- Emergency Exit Lights
sysGeneral.emerExitLightsSwitch = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/emer_exit_lights",0,"laminar/B738/toggle_switch/emer_exit_lights_up","laminar/B738/toggle_switch/emer_exit_lights_dn")
sysGeneral.emerExitLightsCover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",9,"laminar/B738/button_switch_cover09")

-- FDR recorder
sysGeneral.fdrSwitch = TwoStateToggleSwitch:new("","laminar/B738/switches/fdr_pos",0,"laminar/B738/toggle_switch/fdr")
sysGeneral.fdrCover = TwoStateToggleSwitch:new("","laminar/B738/switches/fdr_cover_pos",0,"laminar/B738/toggle_switch/fdr_cover")

-- Voice Recorder
sysGeneral.vcrSwitch = TwoStateCmdSwitch:new("","laminar/B738/toggle_switch/vcr",0,"laminar/B738/toggle_switch/vcr_auto","laminar/B738/toggle_switch/vcr_on")

-- Attendence button 
sysGeneral.attendanceButton = TwoStateToggleSwitch:new("","laminar/B738/push_button/attend_pos",0,"laminar/B738/push_button/attend")

-- Equipment Cooling
sysGeneral.equipCoolExhaust = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/eq_cool_exhaust",0,"laminar/B738/toggle_switch/eq_cool_exhaust")
sysGeneral.equipCoolSupply = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/eq_cool_supply",0,"laminar/B738/toggle_switch/eq_cool_supply")

-- Passenger lights
sysGeneral.noSmokingSwitch = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/no_smoking_pos",0,"laminar/B738/toggle_switch/no_smoking_dn","laminar/B738/toggle_switch/no_smoking_up")
sysGeneral.seatBeltSwitch = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/seatbelt_sign_pos",0,"laminar/B738/toggle_switch/seatbelt_sign_dn","laminar/B738/toggle_switch/seatbelt_sign_up")

-- DISPLAY UNITS
sysGeneral.displayUnitsFO = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/main_pnl_du_fo",0,"laminar/B738/toggle_switch/main_pnl_du_fo_left","laminar/B738/toggle_switch/main_pnl_du_fo_right")
sysGeneral.displayUnitsCPT = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/main_pnl_du_capt",0,"laminar/B738/toggle_switch/main_pnl_du_capt_left","laminar/B738/toggle_switch/main_pnl_du_capt_right")

-- LOWER DU
sysGeneral.lowerDuFO = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/lower_du_fo",0,"laminar/B738/toggle_switch/lower_du_fo_left","laminar/B738/toggle_switch/lower_du_fo_right")
sysGeneral.lowerDuCPT = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/lower_du_capt",0,"laminar/B738/toggle_switch/lower_du_capt_left","laminar/B738/toggle_switch/lower_du_capt_right")

-- GPWS

sysGeneral.flapInhibitSwitch 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/gpws_flap_pos",0,"laminar/B738/toggle_switch/gpws_flap")
sysGeneral.gearInhibitSwitch 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/gpws_gear_pos",0,"laminar/B738/toggle_switch/gpws_gear")
sysGeneral.terrainInhibitSwitch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/gpws_terr_pos",0,"laminar/B738/toggle_switch/gpws_terr")

sysGeneral.flapInhibitCover 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/gpws_flap_cover_pos",0,"laminar/B738/toggle_switch/gpws_flap_cover")
sysGeneral.gearInhibitCover 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/gpws_gear_cover_pos",0,"laminar/B738/toggle_switch/gpws_gear_cover")
sysGeneral.terrainInhibitCover 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/gpws_terr_cover_pos",0,"laminar/B738/toggle_switch/gpws_terr_cover")

-- Autobrake
sysGeneral.autobreak = MultiStateCmdSwitch:new("","laminar/B738/autobrake/autobrake_pos",0,"laminar/B738/knob/autobrake_dn","laminar/B738/knob/autobrake_up")

-- Lights Test
sysGeneral.lightTest = TwoStateCmdSwitch:new("","laminar/B738/toggle_switch/bright_test",0,"laminar/B738/toggle_switch/bright_test_ip","laminar/B738/toggle_switch/bright_test_dn")

-- capt chronometer
sysGeneral.clockDispModeCPT = MultiStateCmdSwitch:new("","laminar/B738/clock/clock_display_mode_capt",0,"laminar/B738/push_button/chrono_disp_mode_capt","laminar/B738/push_button/chrono_disp_mode_capt")
sysGeneral.clockDispModeFO = MultiStateCmdSwitch:new("","laminar/B738/clock/clock_display_mode_fo",0,"laminar/B738/push_button/chrono_disp_mode_fo","laminar/B738/push_button/chrono_disp_mode_fo")
sysGeneral.clockDispModeGrp = SwitchGroup:new("dispmodeclock")
sysGeneral.clockDispModeGrp:addSwitch(sysGeneral.clockDispModeCPT)
sysGeneral.clockDispModeGrp:addSwitch(sysGeneral.clockDispModeFO)

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

sysGeneral.gearLightsRed = CustomAnnunciator:new("gearlightsred", 
function () 
	local sum = sysGeneral.gearLeftRedAnc:getStatus() +
				sysGeneral.gearRightRedAnc:getStatus() +
				sysGeneral.gearNodeRedAnc:getStatus()
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

-- Fire Warning
sysGeneral.fireWarningAnc = SimpleAnnunciator:new("firewarning", "laminar/B738/push_button/fire_bell_cutout1",0)

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

sysGeneral.irs1Align = SimpleAnnunciator:new("","laminar/B738/annunciator/irs_align_left",0)
sysGeneral.irs2Align = SimpleAnnunciator:new("","laminar/B738/annunciator/irs_align_right",0)
sysGeneral.irs1OnDC = SimpleAnnunciator:new("","laminar/B738/annunciator/irs_on_dc_left",0)
sysGeneral.irs2OnDC = SimpleAnnunciator:new("","laminar/B738/annunciator/irs_on_dc_right",0)

sysGeneral.annunciators = CustomAnnunciator:new("annunc",
function () 
	local sum = get("laminar/B738/annunciator/six_pack_air_cond") +
				get("laminar/B738/annunciator/six_pack_apu") + 
				get("laminar/B738/annunciator/six_pack_doors") + 
				get("laminar/B738/annunciator/six_pack_elec") + 
				get("laminar/B738/annunciator/six_pack_eng") + 
				get("laminar/B738/annunciator/six_pack_fire") + 
				get("laminar/B738/annunciator/six_pack_flt_cont") + 
				get("laminar/B738/annunciator/six_pack_fuel") + 
				get("laminar/B738/annunciator/six_pack_hyd") + 
				get("laminar/B738/annunciator/six_pack_ice") + 
				get("laminar/B738/annunciator/six_pack_irs") + 
				get("laminar/B738/annunciator/six_pack_overhead")
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)				

return sysGeneral
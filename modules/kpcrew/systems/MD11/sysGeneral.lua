-- MD11 airplane 
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
sysGeneral.parkBrakeSwitch = TwoStateCmdSwitch:new("parkbrake","Rotate/aircraft/controls/park_brake",0,"Rotate/aircraft/controls_c/park_brake_up","Rotate/aircraft/controls_c/park_brake_dn","nocommand")

-- Landing Gear
sysGeneral.GearSwitch = TwoStateCmdSwitch:new("gear","Rotate/aircraft/controls/gear_handle",0,"Rotate/aircraft/controls_c/gear_handle_dn","Rotate/aircraft/controls_c/gear_handle_up","nocommand")

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
sysGeneral.barostdPilot = TwoStateCustomSwitch:new("barostdPilot","Rotate/aircraft/controls/baro_std_set_l",0,
	function () 
		command_once("Rotate/aircraft/controls_c/baro_std_set_l") 
		set("Rotate/aircraft/controls/baro_std_set_l",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/baro_std_set_l") 
		set("Rotate/aircraft/controls/baro_std_set_l",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/baro_std_set_l") 
		set("Rotate/aircraft/controls/baro_std_set_l",-1)
	end
)
-- TwoStateToggleSwitch:new("barostdpilot","Rotate/aircraft/controls/baro_std_set_l",0,"Rotate/aircraft/controls_c/baro_std_set_l")
sysGeneral.barostdCopilot = TwoStateCustomSwitch:new("barostdCopilot","Rotate/aircraft/controls/baro_std_set_r",0,
	function () 
		command_once("Rotate/aircraft/controls_c/baro_std_set_r") 
		set("Rotate/aircraft/controls/baro_std_set_r",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/baro_std_set_r") 
		set("Rotate/aircraft/controls/baro_std_set_r",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/baro_std_set_r") 
		set("Rotate/aircraft/controls/baro_std_set_r",-1)
	end
)
-- TwoStateToggleSwitch:new("barostdcopilot","Rotate/aircraft/controls/baro_std_set_r",0,"Rotate/aircraft/controls_c/baro_std_set_r")
sysGeneral.barostdStandby = TwoStateCustomSwitch:new("barostdstandby","Rotate/aircraft/systems/stby_baroset_inhg",0,
	function () 
		set("Rotate/aircraft/systems/stby_baroset_inhg",29.92)
	end,
	function () 
		set("Rotate/aircraft/systems/stby_baroset_inhg",29.92)
	end,
	function () 
		set("Rotate/aircraft/systems/stby_baroset_inhg",29.92)
	end
)

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

sysGeneral.baroPilot = MultiStateCmdSwitch:new("baropilot","Rotate/aircraft/systems/gcp_baroset_qnh_hpa",0,"Rotate/aircraft/controls_c/baro_set_l_dn","Rotate/aircraft/controls_c/baro_set_l_up")
sysGeneral.baroCoPilot = MultiStateCmdSwitch:new("barocopilot","Rotate/aircraft/systems/gcp_baroset_qnh_hpa",1,"Rotate/aircraft/controls_c/baro_set_r_dn","Rotate/aircraft/controls_c/baro_set_r_up")
sysGeneral.baroStandby = MultiStateCmdSwitch:new("barostandby","Rotate/aircraft/systems/stby_baroset_hpa",0,"Rotate/aircraft/controls_c/stby_baro_set_dn","Rotate/aircraft/controls_c/stby_baro_set_up")

sysGeneral.baroGroup = SwitchGroup:new("barogroup")
sysGeneral.baroGroup:addSwitch(sysGeneral.baroPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroCoPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroStandby)

sysGeneral.irsUnit1Switch = TwoStateCmdSwitch:new("irsunit1","Rotate/aircraft/controls/irs_switch_1",0,"Rotate/aircraft/controls_c/irs_switch_1_up","Rotate/aircraft/controls_c/irs_switch_1_dn","nocommand")
sysGeneral.irsUnit2Switch = TwoStateCmdSwitch:new("irsunit2","Rotate/aircraft/controls/irs_switch_2",0,"Rotate/aircraft/controls_c/irs_switch_2_up","Rotate/aircraft/controls_c/irs_switch_2_dn","nocommand")
sysGeneral.irsUnit3Switch = TwoStateCmdSwitch:new("irsunit3","Rotate/aircraft/controls/irs_switch_3",0,"Rotate/aircraft/controls_c/irs_switch_3_up","Rotate/aircraft/controls_c/irs_switch_3_dn","nocommand")

sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

-- Weather Radar
sysGeneral.wxSystemSwitch = MultiStateCmdSwitch:new("","Rotate/aircraft/controls/wx_sys",0,"Rotate/aircraft/controls_c/wx_sys_dn","Rotate/aircraft/controls_c/wx_sys_up")

sysGeneral.ancLightTest = TwoStateDrefSwitch:new("","Rotate/aircraft/controls/annun_test",0)
-- Rotate/aircraft/controls_c/annun_test

sysGeneral.emerExitSwitch = MultiStateCmdSwitch:new("","Rotate/aircraft/controls/emer_lts",0,"Rotate/aircraft/controls_c/emer_lts_dn","Rotate/aircraft/controls_c/emer_lts_up")

sysGeneral.noSmokeSigns = MultiStateCmdSwitch:new("","Rotate/aircraft/controls/nosmoke_lts",0,"Rotate/aircraft/controls_c/nosmoke_lts_dn","Rotate/aircraft/controls_c/nosmoke_lts_up")

sysGeneral.seatBeltSigns = MultiStateCmdSwitch:new("","Rotate/aircraft/controls/seatbelts_lts",0,"Rotate/aircraft/controls_c/seatbelts_lts_dn","Rotate/aircraft/controls_c/seatbelts_lts_up")

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
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear", "Rotate/aircraft/systems/gear_down_l_lt", 0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("gear", "Rotate/aircraft/systems/gear_down_r_lt", 0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear", "Rotate/aircraft/systems/gear_down_c_lt", 0)
sysGeneral.gearLeftRedAnc = SimpleAnnunciator:new("gear", "Rotate/aircraft/systems/gear_disag_l_lt", 0)
sysGeneral.gearRightRedAnc = SimpleAnnunciator:new("gear", "Rotate/aircraft/systems/gear_disag_r_lt", 0)
sysGeneral.gearNodeRedAnc = SimpleAnnunciator:new("gear", "Rotate/aircraft/systems/gear_disag_c_lt", 0)

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
	return get("Rotate/aircraft/systems/gcp_baroset_qnh_hpa") 
end)
sysGeneral.baroInhg = CustomAnnunciator:new("inhg",
function () 
	return get("Rotate/aircraft/systems/gcp_baroset_qnh_inhg") 
end)

-- cargo fire test
sysGeneral.cargoFireTestAnc = SimpleAnnunciator:new("cargofire","Rotate/aircraft/systems/fire_cargo_fwd_flow_disag_lt",0)

-- VCR Test
sysGeneral.vrcTest = SimpleAnnunciator:new("vcrtest","Rotate/aircraft/controls/voice_rcdr_test",0)
-- Rotate/aircraft/controls_c/voice_rcdr_test

return sysGeneral
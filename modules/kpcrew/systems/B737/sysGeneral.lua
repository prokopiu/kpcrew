-- B737 airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysGeneral.Autobrake
-- sysGeneral.GearSwitch
-- sysGeneral.chrono		
-- sysGeneral.clock
-- sysGeneral.cockpitDoor 	
-- sysGeneral.doorACargo 	
-- sysGeneral.doorACargoAnc 
-- sysGeneral.doorFCargo 	
-- sysGeneral.doorFCargoAnc 
-- sysGeneral.doorGroup 	
-- sysGeneral.doorL1		
-- sysGeneral.doorL1Anc 	
-- sysGeneral.doorL2		
-- sysGeneral.doorL2Anc 	
-- sysGeneral.doorR1		
-- sysGeneral.doorR1Anc 	
-- sysGeneral.doorR2		
-- sysGeneral.doorR2Anc 	
-- sysGeneral.doorsAnc 		
-- sysGeneral.gearLeftGreenAnc 
-- sysGeneral.gearLeftRedAnc 	
-- sysGeneral.gearLightsAnc 	
-- sysGeneral.gearNodeGreenAnc 
-- sysGeneral.gearNodeRedAnc 	
-- sysGeneral.gearRightGreenAnc
-- sysGeneral.gearRightRedAnc 
-- sysGeneral.groundObjects
-- sysGeneral.irsUnit1Switch
-- sysGeneral.irsUnit2Switch
-- sysGeneral.irsUnit3Switch
-- sysGeneral.irsUnitGroup
-- sysGeneral.masterCautionAnc 
-- sysGeneral.masterWarningAnc 
-- sysGeneral.noSmokingSwitch
-- sysGeneral.parkBrakeSwitch
-- sysGeneral.parkbrakeAnc
-- sysGeneral.passSignsSwitch
-- sysGeneral.stairsL1 		
-- sysGeneral.tocheck		 
-- sysGeneral.window1		
-- sysGeneral.window2		
-- sysGeneral.windowGroup 	
-- sysGeneral.wiperGroup 	
-- sysGeneral.wiperLeft 	
-- sysGeneral.wiperRight 	
-- Macro: kc_macro_doors_ext
-- Macro: kc_macro_set_groundobjects
-- Macro: kc_macro_set_autobrake
-- Macro: kc_macro_set_irs

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

logMsg("B737 sysGeneral")

--------- Switch datarefs common
local drefParkbrake			= "sim/cockpit2/controls/parking_brake_ratio"
local drefGearLever			= "laminar/B738/controls/gear_handle_down"
local drefDoorL1			= "737u/doors/L1"
local drefDoorL2			= "737u/doors/L2"
local drefDoorR1			= "737u/doors/R1"
local drefDoorR2			= "737u/doors/R2"
local drefDoorFCargo		= "737u/doors/Fwd_Cargo"
local drefDoorACargo		= "737u/doors/aft_Cargo"
local drefDoorCockpit		= "laminar/B738/door/flt_dk_door_ratio"
local drefStairs			= "laminar/B738/airstairs_hide"
local drefWiperLeft			= "laminar/B738/switches/left_wiper_pos"
local drefWiperRight		= "laminar/B738/switches/right_wiper_pos"
local drefIRSUnit1			= "laminar/B738/toggle_switch/irs_left"
local drefIRSUnit2			= "laminar/B738/toggle_switch/irs_right"
local drefNoSmoking			= "laminar/B738/toggle_switch/no_smoking_pos"
local drefSeatBelts			= "laminar/B738/toggle_switch/seatbelt_sign_pos"
local drefAutoBrakePos		= "laminar/B738/autobrake/autobrake_pos"

--------- Annunciator datarefs common
local drefAnnGearLeftGreen	= "laminar/B738/annunciator/left_gear_safe"
local drefAnnGearRghtGreen	= "laminar/B738/annunciator/right_gear_safe"
local drefAnnGearNoseGreen	= "laminar/B738/annunciator/nose_gear_safe"
local drefAnnGearLeftRed	= "laminar/B738/annunciator/left_gear_transit"
local drefAnnGearRghtRed	= "laminar/B738/annunciator/right_gear_transit"
local drefAnnGearNoseRed	= "laminar/B738/annunciator/nose_gear_transit"

--------- Switch commands common
local cmdParkbrake			= "laminar/B738/push_button/park_brake_on_off"
local cmdStairsTgl			= "laminar/B738/airstairs_ext_toggle"
local cmdWiperDnL			= "laminar/B738/knob/left_wiper_dn"
local cmdWiperDnR			= "laminar/B738/knob/right_wiper_dn"
local cmdWiperUpL			= "laminar/B738/knob/left_wiper_up"
local cmdWiperUpR			= "laminar/B738/knob/right_wiper_up"
local cmdIRSUnit1Left		= "laminar/B738/toggle_switch/irs_L_left"
local cmdIRSUnit1Right		= "laminar/B738/toggle_switch/irs_L_right"
local cmdIRSUnit2Left		= "laminar/B738/toggle_switch/irs_R_left"
local cmdIRSUnit2Right		= "laminar/B738/toggle_switch/irs_R_right"
local cmdSeatBeltsDn		= "laminar/B738/toggle_switch/seatbelt_sign_dn"
local cmdSeatBeltsUp		= "laminar/B738/toggle_switch/seatbelt_sign_up"
local cmdNoSmokeDn			= "laminar/B738/toggle_switch/no_smoking_dn"
local cmdNoSmokeUp			= "laminar/B738/toggle_switch/no_smoking_up"
local cmdAutobrakeDn		= "laminar/B738/knob/autobrake_dn"
local cmdAutobrakeUp		= "laminar/B738/knob/autobrake_up"
local cmdGearDown			= "laminar/B738/push_button/gear_down"
local cmdGearUp				= "laminar/B738/push_button/gear_up"

----------- Switches

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateToggleSwitch:new("parkbrake",drefParkbrake,0,cmdParkbrake)
sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
	function () if get(drefParkbrake) > 0 then return 1 else return 0 end end)

-- Landing Gear
sysGeneral.GearSwitch 		= TwoStateCustomSwitch:new("gear",drefGearLever,0,
	function () command_once(cmdGearDown) end,
	function () command_once(cmdGearUp) end,
	function () command_once("laminar/B738/push_button/gear_off") end)

-- Gear Lights for annunciators
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("gear",drefAnnGearLeftGreen,0)
sysGeneral.gearRightGreenAnc= SimpleAnnunciator:new("gear",drefAnnGearRghtGreen,0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("gear",drefAnnGearNoseGreen,0)
sysGeneral.gearLeftRedAnc 	= SimpleAnnunciator:new("gear",drefAnnGearLeftRed,0)
sysGeneral.gearRightRedAnc 	= SimpleAnnunciator:new("gear",drefAnnGearRghtRed,0)
sysGeneral.gearNodeRedAnc 	= SimpleAnnunciator:new("gear",drefAnnGearNoseRed,0)

-- light on when gears extended else 0
sysGeneral.gearLightsAnc 	= CustomAnnunciator:new("gearlights", 
	function () 
		local sum = sysGeneral.gearLeftGreenAnc:getStatus() +
					sysGeneral.gearRightGreenAnc:getStatus() +
					sysGeneral.gearNodeGreenAnc:getStatus()
		if sum > 0 then return 1 else return 0 end end)

-- Doors
sysGeneral.doorL1			= TwoStateToggleSwitch:new("doorl1",drefDoorL1,0,	"laminar/B738/door/fwd_L_toggle")
sysGeneral.doorL2			= TwoStateToggleSwitch:new("doorl2",drefDoorL2,0,	"laminar/B738/door/aft_L_toggle")
sysGeneral.doorR1			= TwoStateToggleSwitch:new("doorr1",drefDoorR1,0,	"laminar/B738/door/fwd_R_toggle")
sysGeneral.doorR2			= TwoStateToggleSwitch:new("doorr2",drefDoorR2,0,	"laminar/B738/door/aft_R_toggle")
sysGeneral.doorFCargo		= TwoStateToggleSwitch:new("doorfcargo",drefDoorFCargo,0,"laminar/B738/door/fwd_cargo_toggle")
sysGeneral.doorACargo 		= TwoStateToggleSwitch:new("dooracrago",drefDoorACargo,0,"laminar/B738/door/aft_cargo_toggle")
sysGeneral.cockpitDoor 		= TwoStateToggleSwitch:new("cockpit",drefDoorCockpit,0,"laminar/B738/toggle_switch/flt_dk_door_open")

sysGeneral.stairs 			= TwoStateCustomSwitch:new("stairs",drefStairs,0,
	function () if get(drefStairs) ~= 0 then command_once(cmdStairsTgl) end end,
	function ()	if get(drefStairs) == 0 then command_once(cmdStairsTgl) end end,
	function () command_once(cmdStairsTgl) end,
	function () if get(drefStairs) == 0 then return 1 else return 0 end end)

sysGeneral.doorGroup 		= SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairs)

-- Door annunciators
sysGeneral.doorL1Anc = SimpleAnnunciator:new("doorl1",drefDoorL1,0)
sysGeneral.doorL2Anc = SimpleAnnunciator:new("doorl2",drefDoorL2,0)
sysGeneral.doorR1Anc = SimpleAnnunciator:new("doorr1",drefDoorR1,0)
sysGeneral.doorR2Anc = SimpleAnnunciator:new("doorr2",drefDoorR2,0)
sysGeneral.doorFCargoAnc = SimpleAnnunciator:new("doorfcargo",drefDoorFCargo,0)
sysGeneral.doorACargoAnc = SimpleAnnunciator:new("dooracrago",drefDoorACargo,0)

sysGeneral.doorsAnc = CustomAnnunciator:new("doors", 
	function () 
		local sum = sysGeneral.doorL1Anc:getStatus() +
					sysGeneral.doorL2Anc:getStatus() +
					sysGeneral.doorR1Anc:getStatus() +
					sysGeneral.doorR2Anc:getStatus() +
					sysGeneral.doorFCargoAnc:getStatus() +
					sysGeneral.doorACargoAnc:getStatus()
		if sum > 0 then return 1 else return 0 end end)

-- Wiper Switches
sysGeneral.wiperLeft 		= MultiStateCmdSwitch:new("wiperL",drefWiperLeft,0,cmdWiperDnL,cmdWiperUpL,0,3,true)
sysGeneral.wiperRight 		= MultiStateCmdSwitch:new("wiperR",drefWiperRight,0,cmdWiperDnR,cmdWiperUpR,0,3,true)
sysGeneral.wiperGroup 		= SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch = MultiStateCmdSwitch:new("irsunit1",drefIRSUnit1,0,cmdIRSUnit1Left,cmdIRSUnit1Right,0,3,true)
sysGeneral.irsUnit2Switch = MultiStateCmdSwitch:new("irsunit2",drefIRSUnit2,0,cmdIRSUnit2Left,cmdIRSUnit2Right,0,3,true)
sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)

sysGeneral.noSmokingSwitch	= TwoStateCmdSwitch:new("nosmoke",drefNoSmoking,0,cmdNoSmokeDn,cmdNoSmokeUp,0,2,true)
sysGeneral.passSignsSwitch	= TwoStateCmdSwitch:new("seatbelts",drefSeatBelts,0,cmdSeatBeltsDn,cmdSeatBeltsUp,0,1,true)

sysGeneral.Autobrake = MultiStateCmdSwitch:new("autobrake",drefAutoBrakePos,0,cmdAutobrakeDn,cmdAutobrakeUp,0,5,true)

--------- Macros

-- IRS off 0=OFF, 1=ALIGN, 2=NAV, 3=ATT
function kc_macro_set_irs(mode)
	command_once("laminar/B738/toggle_switch/irs_L_left")
	command_once("laminar/B738/toggle_switch/irs_L_left")
	command_once("laminar/B738/toggle_switch/irs_L_left")
	command_once("laminar/B738/toggle_switch/irs_R_left")
	command_once("laminar/B738/toggle_switch/irs_R_left")
	command_once("laminar/B738/toggle_switch/irs_R_left")
	if mode == 0 then -- off
	elseif mode == 1 then -- ALIGN
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
	elseif mode == 2 then -- NAV 
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
	elseif mode == 3 then -- ATT 
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
	end
end

-- autobrake
function kc_macro_set_autobrake(index)
	-- retract flaps 8 steps
	for i = 1, 5 do
		command_once(cmdAutobrakeDn)
	end

	for i = 1, index do
		command_once(cmdAutobrakeUp)
	end
end

return sysGeneral
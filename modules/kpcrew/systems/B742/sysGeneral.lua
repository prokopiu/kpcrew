-- B742 airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysGeneral.parkBrakeSwitch
-- sysGeneral.parkbrakeAnc
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
-- sysGeneral.cockpitDoor 	
-- sysGeneral.noSmokingSwitch
-- sysGeneral.passSignsSwitch
-- Macro: kc_macro_set_irs
-- Macro: kc_macro_set_autobrake

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

logMsg("B742 sysGeneral")

--- Switch datarefs common
local drefSliderDoor		= "B742/anim/commanded_pax_doors"
local drefSliderCargo		= "sim/cockpit2/switches/custom_slider_on"
local drefParkbrake			= "B742/controls/park_brake_lever"
local drefSlider 			= "sim/cockpit2/switches/custom_slider_on"
local drefNoSmoking			= "B742/OVHD/no_smoking_button"
local drefSeatBelts			= "B742/OVHD/fasten_belts"
local drefWiperLeft			= "B742/OVHD/WSHLD_wiper_sel_L"
local drefWiperRight		= "B742/OVHD/WSHLD_wiper_sel_R"
local drefIRS1				= "B742/INS1/ovhd_mode"
local drefIRS2				= "B742/INS2/ovhd_mode"
local drefIRS3				= "B742/INS3/ovhd_mode"
local drefAutoBrakePos		= "B742/OVHD/auto_brake_sel"

----------- Switches

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateDrefSwitch:new("parkbrake",drefParkbrake,0)
sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
function () if get(drefParkbrake) > 0 then return 1 else return 0 end end)

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1",drefSliderDoor,-1,
	function () set_array(drefSliderDoor,0,1) end,
	function () set_array(drefSliderDoor,0,0) end,
	function () 
		if get(drefSliderDoor,0) == 0 then
			set_array(drefSliderDoor,0,1)
		else
			set_array(drefSliderDoor,0,0)
		end
	end,
	function () if get(drefSliderDoor,0) ~= 0 then return 1 else return 0 end end)
sysGeneral.doorL2			= TwoStateCustomSwitch:new("doorl2",drefSliderDoor,4,
	function () set_array(drefSliderDoor,4,1) end,
	function () set_array(drefSliderDoor,4,0) end,
	function () 
		if get(drefSliderDoor,4) == 0 then
			set_array(drefSliderDoor,4,1)
		else
			set_array(drefSliderDoor,4,0)
		end
	end,
	function () if get(drefSliderDoor,4) ~= 0 then return 1 else return 0 end end)
sysGeneral.doorR1			= TwoStateCustomSwitch:new("doorr1",drefSliderDoor,5,
	function () set_array(drefSliderDoor,5,1) end,
	function () set_array(drefSliderDoor,5,0) end,
	function () 
		if get(drefSliderDoor,5) == 0 then
			set_array(drefSliderDoor,5,1)
		else
			set_array(drefSliderDoor,5,0)
		end
	end,
	function () if get(drefSliderDoor,5) ~= 0 then return 1 else return 0 end end)
sysGeneral.doorR2			= TwoStateCustomSwitch:new("doorr2",drefSliderDoor,9,
	function () set_array(drefSliderDoor,9,1) end,
	function () set_array(drefSliderDoor,9,0) end,
	function () 
		if get(drefSliderDoor,9) == 0 then
			set_array(drefSliderDoor,9,1)
		else
			set_array(drefSliderDoor,9,0)
		end
	end,
	function () if get(drefSliderDoor,9) ~= 0 then return 1 else return 0 end end)
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo",drefSliderCargo,-1,
	function () set_array(drefSliderCargo,0,1) end,
	function () set_array(drefSliderCargo,0,0) end,
	function () 
		if get(drefSliderCargo,0) == 0 then
			set_array(drefSliderCargo,0,1)
		else
			set_array(drefSliderCargo,0,0)
		end
	end,
	function () if get(drefSliderCargo,0) ~= 0 then return 1 else return 0 end end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo",drefSliderCargo,1,
	function () set_array(drefSliderCargo,1,1) end,
	function () set_array(drefSliderCargo,1,0) end,
	function () 
		if get(drefSliderCargo,1) == 0 then
			set_array(drefSliderCargo,1,1)
		else
			set_array(drefSliderCargo,1,0)
		end
	end,
	function () if get(drefSliderCargo,1) ~= 0 then return 1 else return 0 end end)

sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor",drefSlider,3)

sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("nosmoke",drefNoSmoking,0)

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts",drefSeatBelts,0)

-- Wiper Switches
sysGeneral.wiperLeft 		= TwoStateDrefSwitch:new("wiperleft",drefWiperLeft,0)
sysGeneral.wiperRight 		= TwoStateDrefSwitch:new("wiperright",drefWiperRight,0)
sysGeneral.wiperGroup 		= SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1",drefIRS1,0)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2",drefIRS2,0)
sysGeneral.irsUnit3Switch 	= TwoStateDrefSwitch:new("irsunit3",drefIRS3,0)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

-- Autobrake
sysGeneral.Autobrake	= TwoStateDrefSwitch:new("autobrake",drefAutoBrakePos,0)

--------- Macros

-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- off
		set("B742/INS1/ovhd_mode",0)
		set("B742/INS2/ovhd_mode",0)
		set("B742/INS3/ovhd_mode",0)
	elseif mode == 1 then -- ALIGN
		set("B742/INS1/ovhd_mode",2)
		set("B742/INS2/ovhd_mode",2)
		set("B742/INS3/ovhd_mode",2)
	elseif mode == 2 then -- NAV 
		set("B742/INS1/ovhd_mode",3)
		set("B742/INS2/ovhd_mode",3)
		set("B742/INS3/ovhd_mode",3)
	end
end

function kc_macro_set_autobrake(index)
	sysGeneral.Autobrake:setValue(index)	
end

return sysGeneral
-- B742 airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateDrefSwitch:new("parkbrake","B742/controls/park_brake_lever",0)

sysGeneral.parkbrakeAnc 	= CustomAnnunciator:new("parkbrake",
function ()
	if get("B742/controls/park_brake_lever") > 0 then
		return 1
	else
		return 0
	end
end)

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1","B742/anim/commanded_pax_doors",-1,
	function () 
		set_array("B742/anim/commanded_pax_doors",0,1)
	end,
	function () 
		set_array("B742/anim/commanded_pax_doors",0,0)
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",0) == 0 then
			set_array("B742/anim/commanded_pax_doors",0,1)
		else
			set_array("B742/anim/commanded_pax_doors",0,0)
		end
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorL2			= TwoStateCustomSwitch:new("doorl2","B742/anim/commanded_pax_doors",4,
	function () 
		set_array("B742/anim/commanded_pax_doors",4,1)
	end,
	function () 
		set_array("B742/anim/commanded_pax_doors",4,0)
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",4) == 0 then
			set_array("B742/anim/commanded_pax_doors",4,1)
		else
			set_array("B742/anim/commanded_pax_doors",4,0)
		end
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",4) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR1			= TwoStateCustomSwitch:new("doorr1","B742/anim/commanded_pax_doors",5,
	function () 
		set_array("B742/anim/commanded_pax_doors",5,1)
	end,
	function () 
		set_array("B742/anim/commanded_pax_doors",5,0)
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",5) == 0 then
			set_array("B742/anim/commanded_pax_doors",5,1)
		else
			set_array("B742/anim/commanded_pax_doors",5,0)
		end
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",5) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR2			= TwoStateCustomSwitch:new("doorr2","B742/anim/commanded_pax_doors",9,
	function () 
		set_array("B742/anim/commanded_pax_doors",9,1)
	end,
	function () 
		set_array("B742/anim/commanded_pax_doors",9,0)
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",9) == 0 then
			set_array("B742/anim/commanded_pax_doors",9,1)
		else
			set_array("B742/anim/commanded_pax_doors",9,0)
		end
	end,
	function () 
		if get("B742/anim/commanded_pax_doors",9) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo","B742/anim/commanded_cargo_doors",-1,
	function () 
		set_array("B742/anim/commanded_cargo_doors",0,1)
	end,
	function () 
		set_array("B742/anim/commanded_cargo_doors",0,0)
	end,
	function () 
		if get("B742/anim/commanded_cargo_doors",0) == 0 then
			set_array("B742/anim/commanded_cargo_doors",0,1)
		else
			set_array("B742/anim/commanded_cargo_doors",0,0)
		end
	end,
	function () 
		if get("B742/anim/commanded_cargo_doors",0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo","B742/anim/commanded_cargo_doors",1,
	function () 
		set_array("B742/anim/commanded_cargo_doors",1,1)
	end,
	function () 
		set_array("B742/anim/commanded_cargo_doors",1,0)
	end,
	function () 
		if get("B742/anim/commanded_cargo_doors",1) == 0 then
			set_array("B742/anim/commanded_cargo_doors",1,1)
		else
			set_array("B742/anim/commanded_cargo_doors",1,0)
		end
	end,
	function () 
		if get("B742/anim/commanded_cargo_doors",1) ~= 0 then
			return 1
		else
			return 0
		end
	end)

sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/custom_slider_on",3)

sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("nosmoke","B742/OVHD/no_smoking_button",0)

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts","B742/OVHD/fasten_belts",0)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","B742/OVHD/WSHLD_wiper_sel_L",0)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperright","B742/OVHD/WSHLD_wiper_sel_R",0)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1","B742/INS1/ovhd_mode",0)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2","B742/INS2/ovhd_mode",0)
sysGeneral.irsUnit3Switch 	= TwoStateDrefSwitch:new("irsunit3","B742/INS3/ovhd_mode",0)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

return sysGeneral
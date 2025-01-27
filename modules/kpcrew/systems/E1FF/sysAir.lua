-- E1FF X-Crafts Freeware airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysAir = {
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

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("E1FF sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","sim/cockpit2/switches/generic_lights_switch",14)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","sim/cockpit2/switches/generic_lights_switch",15)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","sim/cockpit2/switches/generic_lights_switch",28)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","sim/cockpit2/switches/generic_lights_switch",29)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- ISOLATION VLV Switch
sysAir.isoValveSwitch 		= TwoStateCustomSwitch:new("isolation","sim/cockpit2/bleedair/actuators/isol_valve_left",0,
	function ()
		set("sim/cockpit2/bleedair/actuators/isol_valve_left",1)
		set("sim/cockpit2/bleedair/actuators/isol_valve_right",1)
	end,
	function ()
		set("sim/cockpit2/bleedair/actuators/isol_valve_left",0)
		set("sim/cockpit2/bleedair/actuators/isol_valve_right",0)
	end,
	function ()
		if get("sim/cockpit2/bleedair/actuators/isol_valve_left") == 0 then
			set("sim/cockpit2/bleedair/actuators/isol_valve_left",1)
			set("sim/cockpit2/bleedair/actuators/isol_valve_right",1)
		else
			set("sim/cockpit2/bleedair/actuators/isol_valve_left",0)
			set("sim/cockpit2/bleedair/actuators/isol_valve_right",0)
		end
	end,
	function ()
		if get("sim/cockpit2/bleedair/actuators/isol_valve_left") == 0 and 
			get("sim/cockpit2/bleedair/actuators/isol_valve_right") == 0 then
			return 0
		else
			return 1
		end
	end)

return sysAir
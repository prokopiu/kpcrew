-- ToLiss Airbusses
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements Overwriten
-- sysAir.packLeftSwitch 
-- sysAir.packRightSwitch
-- sysAir.packSwitchGroup
-- sysAir.isoValveSwitch
-- sysAir.bleedEng1Switch
-- sysAir.bleedEng2Switch
-- sysAir.bleedEng3Switch
-- sysAir.bleedEng4Switch
-- sysAir.engBleedGroup
-- sysAir.apuBleedSwitch
-- sysAir.oxygenMaster
-- sysAir.vacuumAnc
-- Macro: kc_macro_air
-- Macro: kc_ab_air_has_white_lights
-- Macro: kc_ab_air_has_no_white_lights

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

--------- Switch datarefs common
local drefPackSwitchLeft	= "AirbusFBW/Pack1Switch"
local drefPackSwitchRight	= "AirbusFBW/Pack2Switch"
local drefEngineBleed1		= "AirbusFBW/ENG1BleedSwitch"
local drefEngineBleed2		= "AirbusFBW/ENG2BleedSwitch"
local drefEngineBleed3		= "AirbusFBW/ENG3BleedSwitch"
local drefEngineBleed4		= "AirbusFBW/ENG4BleedSwitch"
local drefAPUBleed			= "AirbusFBW/APUBleedSwitch"
local drefOxygenMaster		= "sim/cockpit2/oxygen/actuators/demand_flow_setting"

--------- Annunciator datarefs common
local drefAirANC 			= "sim/cockpit2/annunciators/low_vacuum"

logMsg("A3TL sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1",drefPackSwitchLeft,0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2",drefPackSwitchRight,0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- BLEED AIR
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1",drefEngineBleed1,0)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2",drefEngineBleed2,0)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
if PLANE_ICAO == "A346" then
	sysAir.bleedEng3Switch 		= TwoStateDrefSwitch:new("bleed3",drefEngineBleed3,0)
	sysAir.bleedEng4Switch 		= TwoStateDrefSwitch:new("bleed4",drefEngineBleed4,0)
	sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
	sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)
end

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed",drefAPUBleed,0)

--------- Macros

-- Macro: Airbus check air panel to have white lights
function kc_ab_air_has_white_lights()
	local stdbleeds = get("AirbusFBW/Pack1Switch") == 0 or
		get("AirbusFBW/Pack2Switch") == 0 or
		get("AirbusFBW/HotAirSwitch") == 0 or
		get("AirbusFBW/ENG1BleedSwitch") == 0 or
		get("AirbusFBW/ENG2BleedSwitch") == 0 or
		get("AirbusFBW/RamAirSwitch") == 1

	local a346bleeds = true
	if PLANE_ICAO == "A346" then
		a346bleeds = get("AirbusFBW/ENG3BleedSwitch") == 0 or
		get("AirbusFBW/ENG4BleedSwitch") == 0
	end 
	
	return stdbleeds and a346bleeds
end

-- Macro: Airbus air panel has no white lights
function kc_ab_air_has_no_white_lights()
	set("AirbusFBW/Pack1Switch",1)
	set("AirbusFBW/Pack2Switch",1)
	set("AirbusFBW/HotAirSwitch",1)
	set("AirbusFBW/ENG1BleedSwitch",1)
	set("AirbusFBW/ENG2BleedSwitch",1)
	if PLANE_ICAO == "A346" then
		set("AirbusFBW/ENG3BleedSwitch",1)
		set("AirbusFBW/ENG4BleedSwitch",1)
	end 
	set("AirbusFBW/RamAirSwitch",0)
	set("AirbusFBW/PackFlowSel",1)
	
	set("AirbusFBW/CockpitTemp",22)
	set("AirbusFBW/FwdCabinTemp",22)
	set("AirbusFBW/AftCabinTemp",22)
	
	set("AirbusFBW/BlowerSwitch",0)
	set("AirbusFBW/ExtractSwitch",0)
	set("AirbusFBW/CabinFanSwitch",1)
end

return sysAir
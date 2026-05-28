-- B742 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysAir.packLeftSwitch 	
-- sysAir.packRightSwitch 	
-- sysAir.packCenterSwitch 	+
-- sysAir.packSwitchGroup 	
-- sysAir.recircFanLeft 	
-- sysAir.recircFanRight 	
-- sysAir.recircFan3 + 		
-- sysAir.recircFan4 +		
-- sysAir.recircSwitchGroup 
-- sysAir.isoValveSwitch +
-- sysAir.isoValve1 +	
-- sysAir.isoValve2 +	
-- sysAir.bleedEng1Switch 
-- sysAir.bleedEng2Switch 
-- sysAir.bleedEng3Switch +
-- sysAir.bleedEng4Switch +
-- sysAir.engBleedGroup 
-- sysAir.apuBleedSwitch
-- sysAir.trimAirSwitch
-- Macro: kc_macro_air

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

logMsg("B742 sysAir")

--------- Switch datarefs common
local drefPackSwitchLeft	= "B742/AIR_COND/pack_valves_rotary"
local drefPackSwitchRight	= "B742/AIR_COND/pack_valves_rotary"
local drefAPUBleed			= "B742/APU/APU_bleed_air_sw"
local drefOxygenMaster		= "sim/cockpit2/oxygen/actuators/demand_flow_setting"
local drefRecircFan			= "B742/AIR_COND/recilc_fan_zones_sw"
local drefIsoValve			= "B742/AIR_COND/pack_isolation_valves"
local drefEngineBleed		= "B742/AIR_COND/bleed_air_valves"
local drefTrimAir			= "B742/AIR_COND/trim_air_sw"

--------- Annunciator datarefs common
local drefAirANC 			= "sim/cockpit2/annunciators/low_vacuum"

----------- Switches

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1",drefPackSwitchLeft,-1)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2",drefPackSwitchRight,1)
sysAir.packCenterSwitch 	= TwoStateDrefSwitch:new("pack3",drefPackSwitchRight,2)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packCenterSwitch)

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateDrefSwitch:new("recirc1",drefRecircFan,-1)
sysAir.recircFanRight 		= TwoStateDrefSwitch:new("recirc2",drefRecircFan,1)
sysAir.recircFan3 			= TwoStateDrefSwitch:new("recirc3",drefRecircFan,2)
sysAir.recircFan4 			= TwoStateDrefSwitch:new("recirc4",drefRecircFan,3)
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFan3)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFan4)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= SwitchGroup:new("IsoValves")
sysAir.isoValve1 			= TwoStateDrefSwitch:new("pack1",drefIsoValve,-1)
sysAir.isoValve2 			= TwoStateDrefSwitch:new("pack2",drefIsoValve,1)
sysAir.isoValveSwitch:addSwitch(sysAir.isoValve1)
sysAir.isoValveSwitch:addSwitch(sysAir.isoValve2)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1",drefEngineBleed,-1)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2",drefEngineBleed,1)
sysAir.bleedEng3Switch 		= TwoStateDrefSwitch:new("bleed3",drefEngineBleed,2)
sysAir.bleedEng4Switch 		= TwoStateDrefSwitch:new("bleed4",drefEngineBleed,3)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed",drefAPUBleed,0)

-- TRIM/RAM air
sysAir.trimAirSwitch 		= TwoStateDrefSwitch:new("trimair",drefTrimAir,0)

--------- Macros

-- Macro: Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.recircSwitchGroup:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		if activeBriefings:get("takeoff:packs") > 1 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
		sysAir.isoValveSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
	elseif flightphase == kc_phase_takeoff then
		if activeBriefings:get("takeoff:packs") > 1 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
		sysAir.isoValveSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
	elseif flightphase == kc_phase_climb then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		sysAir.engBleedGroup:actuate(1) 
	elseif flightphase == kc_phase_approach then
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		if activeBriefings:get("approach:packs") == 1 then
			sysAir.packSwitchGroup:actuate(0)
		else
			sysAir.packSwitchGroup:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysAir
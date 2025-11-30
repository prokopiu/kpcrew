-- DFLT airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements:
-- sysAir.trimAirSwitch
-- sysAir.recircFanLeft
-- sysAir.recircFanRight
-- sysAir.recircSwitchGroup
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

local sysAir = {
}

logMsg("DFLT sysAir")

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

--------- Switch datarefs common
local drefPackSwitchLeft	= "sim/cockpit2/bleedair/actuators/pack_left"
local drefPackSwitchRight	= "sim/cockpit2/bleedair/actuators/pack_right"
local drefAPUBleed			= "sim/cockpit2/bleedair/actuators/apu_bleed"
local drefOxygenMaster		= "sim/cockpit2/oxygen/actuators/demand_flow_setting"

--------- Annunciator datarefs common
local drefAirANC 			= "sim/cockpit2/annunciators/low_vacuum"

----------- Switches

-- TRIM/RAM air
sysAir.trimAirSwitch 		= InopSwitch:new("trimair")

-- RECIRC fans
sysAir.recircFanLeft 		= InopSwitch:new("recirc1")
sysAir.recircFanRight 		= InopSwitch:new("recirc2")
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1",drefPackSwitchLeft,0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2",drefPackSwitchRight,0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= InopSwitch:new("isolation")

-- BLEED AIR
sysAir.bleedEng1Switch 		= InopSwitch:new("bleed1")
sysAir.bleedEng2Switch 		= InopSwitch:new("bleed2")
-- sysAir.bleedEng3Switch 		= InopSwitch:new("bleed3")
-- sysAir.bleedEng4Switch 		= InopSwitch:new("bleed4")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
-- sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
-- sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed",drefAPUBleed,0)

-- Oxygen Supply
sysAir.oxygenMaster			= TwoStateDrefSwitch:new("oxygen",drefOxygenMaster,0)

----------- Annunciators

-- ** VACUUM annunciator
sysAir.vacuumAnc 			= CustomAnnunciator:new("vacuum",
function ()
	if get(drefAirANC,0) == 1 or get(drefAirANC,1) == 1 then
		return 1
	else
		return 0
	end
end)

--------- Macros

-- Macro: Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:actuate(0)
		end
		if kc_is_airbus == false and kc_has_iso_valvle then	
			sysAir.isoValveSwitch:actuate(0)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(0)
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(0)
		end
		if kc_has_recirc then
			sysAir.recircSwitchGroup:actuate(0)
		end
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(0)
		end
		if kc_has_apu then
			sysAir.apuBleedSwitch:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:actuate(1)
		end
		if kc_has_oxygen then
			sysAir.oxygenMaster:actuate(0)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(1)
		end
		if kc_has_recirc then
			sysAir.recircSwitchGroup:actuate(1)
		end
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_before_start then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:actuate(0)
		end
		if kc_has_oxygen then
			sysAir.oxygenMaster:actuate(0)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(1)
		end
		if kc_has_recirc then
			sysAir.recircSwitchGroup:actuate(1)
		end
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(1)
		end
		if kc_is_airbus == false and kc_has_iso_valvle then	
			sysAir.isoValveSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_after_start then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:actuate(1)
		end
		if kc_is_airbus == false and kc_has_iso_valvle then	
			sysAir.isoValveSwitch:actuate(1)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(1)
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(0)
		end
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_before_takeoff then
		if kc_has_press_cab then
			if activeBriefings:get("takeoff:packs") < 2 then 
				sysAir.packSwitchGroup:setValue(1)
			else
				sysAir.packSwitchGroup:setValue(0)
			end
		end
		if kc_is_airbus == false and kc_has_iso_valvle then	
			sysAir.isoValveSwitch:actuate(1)
		end		
		if kc_has_engine_bleed then
			if activeBriefings:get("takeoff:bleeds") > 1 then 
				sysAir.engBleedGroup:actuate(1) 
			else
				sysAir.engBleedGroup:actuate(0) 
			end
		end
		if kc_has_apu then
			sysAir.apuBleedSwitch:actuate(0)
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(1)
		end
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_takeoff then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:setValue(1)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(1) 
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(1)
		end	
	elseif flightphase == kc_phase_climb then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:setValue(1)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(1) 
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(1)
		end	
	elseif flightphase == kc_phase_approach then
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(1)
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(1)
		end	
		if kc_has_press_cab then
			if activeBriefings:get("approach:packs") == 1 then
				sysAir.packSwitchGroup:actuate(0)
			else
				sysAir.packSwitchGroup:actuate(1)
			end
		end
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_press_cab then
			sysAir.packSwitchGroup:setValue(1)
		end
		if kc_has_engine_bleed then
			sysAir.engBleedGroup:actuate(0)
		end
		if kc_has_oxygen then 
			sysAir.oxygenMaster:actuate(0)
		end	
		if kc_has_trim_air then
			sysAir.trimAirSwitch:actuate(0)
		end
	else
		logMsg("Invalid flightphase")
	end	
end

-- Macro: Airbus check air panel to have white lights
function kc_ab_air_has_white_lights()
	return false
end

-- Macro: Airbus air panel has no white lights
function kc_ab_air_has_no_white_lights()
	return true
end

return sysAir

-- Air conditioning and Pressurization functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
System Elements:
sysAir.packSwitchGroup up to 2
		sysAir.packSwitch1 
		sysAir.packSwitch2
sysAir.engBleedGroup up to 4
		sysAir.bleedEngSwitch1
		sysAir.bleedEngSwitch2
		sysAir.bleedEngSwitch3
		sysAir.bleedEngSwitch4
sysAir.apuBleedSwitch
sysAir.gasperSwitch
sysAir.isoValveGroup
		sysAir.isoValveSwitch1
		sysAir.isoValveSwitch2
		sysAir.isoValveSwitch3
sysAir.recircSwitchGroup
		sysAir.recircFanSwitch1
		sysAir.recircFanSwitch2
sysAir.EquipCoolingSwitch
sysAir.trimAirSwitch
sysAir.tempSelectGroup
		sysAir.tempZoneSelect1
		sysAir.tempZoneSelect2
		sysAir.tempZoneSelect3
sysAir.cargoHeatGroup
		sysAir.cargoHeatSwitch1
		sysAir.cargoHeatSwitch2
sysAir.landAltSelector
sysAir.flightAltSelector
sysAir.oxygenSwitch
sysAir.vacuumAnc
]]

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

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysAirDefinitions")

----------- Switches

-- === Pack Switches
if kc_has_packs then
	-- sysAir.packSwitchGroup
	sysAir.packSwitchGroup 		= SwitchGroup:new("PackSwitches")
	-- sysAir.packSwitch1 
	sysAir.packSwitch1 			= kc_setup_element(def.packSwitch1)
	-- sysAir.packSwitch1 			= TwoStateDrefSwitch:new("p1","sim/cockpit2/bleedair/actuators/pack_left",0)
	sysAir.packSwitchGroup:addSwitch(sysAir.packSwitch1)
	if kc_num_packs > 1 then
		-- sysAir.packSwitch2
		sysAir.packSwitch2 		= kc_setup_element(def.packSwitch2)
		sysAir.packSwitchGroup:addSwitch(sysAir.packSwitch2)
	end
else
	-- sysAir.packSwitchGroup
	sysAir.packSwitchGroup 		= SwitchGroup:new("PackSwitches")
	-- 		sysAir.packSwitch1 
	sysAir.packSwitch1 			= kc_setup_element({etype=kc_swtype_inop, name="PackSwitch 1"})
	sysAir.packSwitchGroup:addSwitch(sysAir.packSwitch1)
end

-- === Pack Switches
if kc_has_engine_bleed then
	-- sysAir.engBleedGroup
	sysAir.engBleedGroup 		= SwitchGroup:new("Bleed Switches")
	-- sysAir.engBleedSwitch1 
	sysAir.engBleedSwitch1 			= kc_setup_element(def.engBleedSwitch1)
	sysAir.engBleedGroup:addSwitch(sysAir.engBleedSwitch1)
	if kc_num_packs > 1 then
		-- sysAir.engBleedSwitch2
		sysAir.engBleedSwitch2 		= kc_setup_element(def.engBleedSwitch2)
		sysAir.engBleedGroup:addSwitch(sysAir.engBleedSwitch2)
	end
	if kc_num_packs > 2 then
		-- sysAir.engBleedSwitch3
		sysAir.engBleedSwitch3 		= kc_setup_element(def.engBleedSwitch3)
		sysAir.engBleedGroup:addSwitch(sysAir.engBleedSwitch3)
	end
	if kc_num_packs > 3 then
		-- sysAir.engBleedSwitch4
		sysAir.engBleedSwitch4 		= kc_setup_element(def.engBleedSwitch4)
		sysAir.engBleedGroup:addSwitch(sysAir.engBleedSwitch4)
	end
else
	-- sysAir.packSwitchGroup
	sysAir.engBleedGroup 		= SwitchGroup:new("Bleed Switches")
	-- 		sysAir.packSwitch1 
	sysAir.engBleedSwitch1 			= kc_setup_element({etype=kc_swtype_inop, name="Bleed Switch 1"})
	sysAir.engBleedGroup:addSwitch(sysAir.engBleedSwitch1)
end

-- APU Bleed
if kc_has_apu_bleed then
	sysAir.apuBleedSwitch 			= kc_setup_element(def.apuBleedSwitch)
else
	sysAir.apuBleedSwitch 			= kc_setup_element({etype=kc_swtype_inop, name="APU Bleed Switch"})
end

-- Gasper Switch
if kc_has_gasper_ctrl then
	sysAir.gasperSwitch 			= kc_setup_element(def.gasperSwitch)
else
	sysAir.gasperSwitch 			= kc_setup_element({etype=kc_swtype_inop, name="Gasper Switch"})
end

-- ISOLATION VLV
if kc_has_iso_valves then
	-- sysAir.isoValveGroup
	sysAir.isoValveGroup 		= SwitchGroup:new("Iso Valves")
	-- sysAir.isoValveSwitch1
	sysAir.isoValveSwitch1		= kc_setup_element(def.isoValveSwitch1)
	sysAir.isoValveGroup:addSwitch(sysAir.isoValveSwitch1)
	if kc_num_iso_valves > 1 then
		-- sysAir.isoValveSwitch2
		sysAir.isoValveSwitch2		= kc_setup_element(def.isoValveSwitch2)
		sysAir.isoValveGroup:addSwitch(sysAir.isoValveSwitch2)
	end
	if kc_num_iso_valves > 2 then
		-- sysAir.isoValveSwitch3
		sysAir.isoValveSwitch3		= kc_setup_element(def.isoValveSwitch3)
		sysAir.isoValveGroup:addSwitch(sysAir.isoValveSwitch3)
	end
else
	-- sysAir.isoValveGroup
	sysAir.isoValveGroup 		= SwitchGroup:new("Iso Valves")
	-- sysAir.isoValveSwitch1
	sysAir.isoValveSwitch1		= kc_setup_element({etype=kc_swtype_inop, name="Isolation valve 1"})
	sysAir.isoValveGroup:addSwitch(sysAir.isoValveSwitch1)
end

-- Recirculation valve
if kc_has_recirc_fans then
	-- sysAir.recircSwitchGroup
	sysAir.recircSwitchGroup	= SwitchGroup:new("Recirculation Valves")
	-- sysAir.recircFanSwitch1
	sysAir.recircFanSwitch1		= kc_setup_element(def.recircFanSwitch1)
	sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanSwitch1)
	if kc_num_recirc_fans > 1 then
		-- sysAir.recircFanSwitch2
		sysAir.recircFanSwitch2		= kc_setup_element(def.recircFanSwitch2)
		sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanSwitch2)
	end
else
	-- sysAir.recircSwitchGroup
	sysAir.recircSwitchGroup 		= SwitchGroup:new("Iso Valves")
	-- sysAir.recircFanSwitch1
	sysAir.recircFanSwitch1		= kc_setup_element({etype=kc_swtype_inop, name="Recirculation valve 1"})
	sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanSwitch1)
end

-- Equipment Cooling Switch
if kc_has_eqip_cooling then
	sysAir.equipCoolingSwitch 		= kc_setup_element(def.equipCoolingSwitch)
else
	sysAir.equipCoolingSwitch 		= kc_setup_element({etype=kc_swtype_inop, name="Equipment Cooling Switch"})
end

-- Trim air Switch
if kc_has_trim_air then
	sysAir.trimAirSwitch 		= kc_setup_element(def.trimAirSwitch)
else
	sysAir.trimAirSwitch 		= kc_setup_element({etype=kc_swtype_inop, name="Trimair Switch"})
end

-- Temperature zone selector
if kc_has_air_temp_ctrl then
	-- sysAir.tempSelectGroup
	sysAir.tempSelectGroup 		= SwitchGroup:new("Temp selectors")
	-- sysAir.tempZoneSelect1
	sysAir.tempZoneSelect1		= kc_setup_element(def.tempZoneSelect1)
	sysAir.tempSelectGroup:addSwitch(sysAir.tempZoneSelect1)
	if kc_num_air_temp_ctrl > 1 then
		-- sysAir.tempZoneSelect2
		sysAir.tempZoneSelect2		= kc_setup_element(def.tempZoneSelect2)
		sysAir.tempSelectGroup:addSwitch(sysAir.tempZoneSelect2)
	end
	if kc_num_air_temp_ctrl > 2 then
		-- sysAir.tempZoneSelect3
		sysAir.tempZoneSelect3		= kc_setup_element(def.tempZoneSelect3)
		sysAir.tempSelectGroup:addSwitch(sysAir.tempZoneSelect3)
	end
else
	-- sysAir.tempSelectGroup
	sysAir.tempSelectGroup 		= SwitchGroup:new("Temp selectors")
	-- sysAir.tempZoneSelect1
	sysAir.tempZoneSelect1		= kc_setup_element({etype=kc_swtype_inop, name="Temp selector 1"})
	sysAir.tempSelectGroup:addSwitch(sysAir.tempZoneSelect1)
end

-- Cargo heat
if kc_has_cargo_heat then
	-- sysAir.cargoHeatGroup
	sysAir.cargoHeatGroup 		= SwitchGroup:new("Cargo heat switches")
	-- sysAir.cargoHeatSwitch1
	sysAir.cargoHeatSwitch1		= kc_setup_element(def.cargoHeatSwitch1)
	sysAir.cargoHeatGroup:addSwitch(sysAir.cargoHeatSwitch1)
	if kc_num_cargo_heat > 1 then
		-- sysAir.cargoHeatSwitch2
		sysAir.cargoHeatSwitch2		= kc_setup_element(def.cargoHeatSwitch2)
		sysAir.cargoHeatGroup:addSwitch(sysAir.cargoHeatSwitch2)
	end
else
	-- sysAir.cargoHeatGroup
	sysAir.cargoHeatGroup 		= SwitchGroup:new("Cargo heat switches")
	-- sysAir.cargoHeatSwitch2
	sysAir.cargoHeatSwitch1		= kc_setup_element({etype=kc_swtype_inop, name="Temp selector 1"})
	sysAir.cargoHeatGroup:addSwitch(sysAir.cargoHeatSwitch1)
end

-- Landing altitude
if kc_has_land_altitude then
	sysAir.landAltSelector 		= kc_setup_element(def.landAltSelector)
else
	sysAir.landAltSelector 		= kc_setup_element({etype=kc_swtype_inop, name="Landing altitude"})
end

-- Flight altitude
if kc_has_flight_alt then
	sysAir.flightAltSelector 	= kc_setup_element(def.flightAltSelector)
else
	sysAir.flightAltSelector 	= kc_setup_element({etype=kc_swtype_inop, name="Flight altitude"})
end

-- Oxygen Supply
if kc_has_oxygen then
	sysAir.oxygenSwitch 		= kc_setup_element(def.oxygenSwitch)
else
	sysAir.oxygenSwitch 		= kc_setup_element({etype=kc_swtype_inop, name="Oxygen master"})
end

----------- Annunciators

-- ** VACUUM annunciator
sysAir.vacuumAnc 			= kc_setup_element(def.vacuumAnc)

--------- Macros

-- Macro: Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Air flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(0) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(0) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then sysAir.isoValveGroup:actuate(0) end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(0) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(0) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(0) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_land_altitude then sysAir.landAltSelector:setValue(0) end
		if kc_has_flight_alt then sysAir.flightAltSelector:setValue(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(0) end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(1) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(1) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then sysAir.isoValveGroup:actuate(0) end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(0) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_land_altitude then sysAir.landAltSelector:setValue(0) end
		if kc_has_flight_alt then sysAir.flightAltSelector:setValue(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(0) end
	elseif flightphase == kc_phase_prel_preflight then
	elseif flightphase == kc_phase_preflight then
	elseif flightphase == kc_phase_before_start then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(0) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(1) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(1) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then 
			if kc_is_airbus == false then
				sysAir.isoValveGroup:actuate(1) 
			else
				sysAir.isoValveGroup:actuate(0) 
			end
		end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(0) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_land_altitude then sysAir.landAltSelector:setValue(1110) end
		if kc_has_flight_alt then sysAir.flightAltSelector:setValue(1110) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(0) end
	elseif flightphase == kc_phase_after_start then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(1) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(1) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then 
			if kc_is_airbus == false then
				sysAir.isoValveGroup:actuate(1) 
			else
				sysAir.isoValveGroup:actuate(0) 
			end
		end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(1) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(1) end
	elseif flightphase == kc_phase_taxi_rwy then
	elseif flightphase == kc_phase_before_takeoff then
		if kc_has_packs then 
			if activeBriefings:get("takeoff:packs") < 2 then 
				sysAir.packSwitchGroup:setValue(1)
			else
				sysAir.packSwitchGroup:setValue(0)
			end
		end
		if kc_has_engine_bleed then 
			if activeBriefings:get("takeoff:bleeds") > 1 then 
				sysAir.engBleedGroup:actuate(1) 
			else
				sysAir.engBleedGroup:actuate(0) 
			end		
		end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then 
			if kc_is_airbus == false then
				sysAir.isoValveGroup:actuate(1) 
			else
				sysAir.isoValveGroup:actuate(0) 
			end
		end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(1) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(1) end
	elseif flightphase == kc_phase_takeoff then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(1) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(1) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then 
			if kc_is_airbus == false then
				sysAir.isoValveGroup:actuate(1) 
			else
				sysAir.isoValveGroup:actuate(0) 
			end
		end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(1) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(1) end
	elseif flightphase == kc_phase_climb then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(1) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(1) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then 
			if kc_is_airbus == false then
				sysAir.isoValveGroup:actuate(1) 
			else
				sysAir.isoValveGroup:actuate(0) 
			end
		end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(0) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(1) end	elseif flightphase == kc_phase_enroute then
	elseif flightphase == kc_phase_descent then
	elseif flightphase == kc_phase_arrival then
	elseif flightphase == kc_phase_approach then
		if kc_has_packs then 
			if activeBriefings:get("approach:packs") == 1 then 
				sysAir.packSwitchGroup:setValue(0)
			else
				sysAir.packSwitchGroup:setValue(1)
			end
		end
		if kc_has_packs then sysAir.packSwitchGroup:actuate(1) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(1) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(0) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then 
			if kc_is_airbus == false then
				sysAir.isoValveGroup:actuate(1) 
			else
				sysAir.isoValveGroup:actuate(0) 
			end
		end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(0) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_land_altitude then sysAir.landAltSelector:setValue(2220) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(1) end
	elseif flightphase == kc_phase_landing then
	elseif flightphase == kc_phase_taxi_stand then
	elseif flightphase == kc_phase_afterland then
	elseif flightphase == kc_phase_shutdown then
		if kc_has_packs then sysAir.packSwitchGroup:actuate(1) end
		if kc_has_engine_bleed then sysAir.engBleedGroup:actuate(0) end
		if kc_has_apu_bleed then sysAir.apuBleedSwitch:actuate(1) end
		if kc_has_gasper_ctrl then sysAir.gasperSwitch:actuate(0) end
		if kc_has_iso_valve then sysAir.isoValveGroup:actuate(1) end
		if kc_has_recirc_fans then sysAir.recircSwitchGroup:actuate(1) end
		if kc_has_eqip_cooling then sysAir.EquipCoolingSwitch:actuate(0) end
		if kc_has_trim_air then sysAir.trimAirSwitch:actuate(1) end
		if kc_has_air_temp_ctrl then sysAir.tempSelectGroup:actuate(0) end
		if kc_has_cargo_heat then sysAir.cargoHeatGroup:actuate(0) end
		if kc_has_land_altitude then sysAir.landAltSelector:setValue(0) end
		if kc_has_flight_alt then sysAir.flightAltSelector:setValue(0) end
		if kc_has_oxygen then sysAir.oxygenSwitch:actuate(0) end
	else
		logMsg("Invalid flightphase")
	end	
end

return sysAir
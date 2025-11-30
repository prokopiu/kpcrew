-- DFLT airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysAice.windowHeat1
-- sysAice.windowHeat2
-- sysAice.windowHeat3
-- sysAice.windowHeat4
-- sysAice.windowHeatGroup
-- sysAice.probeHeatASwitch
-- sysAice.probeHeatBSwitch
-- sysAice.probeHeatGroup
-- sysAice.wingAntiIce
-- sysAice.wingAntiIce2
-- sysAice.wingAiceGroup
-- sysAice.engAntiIce1 
-- sysAice.engAntiIce2 
-- sysAice.engAntiIce3 
-- sysAice.engAntiIce4 
-- sysAice.engAntiIceGroup
-- sysAice.antiiceAnc
-- Macro: kc_macro_aice
-- Macro: kc_ab_air_has_white_lights
-- Macro: kc_ab_air_has_no_white_lights

local sysAice = {
}

logMsg("DFLT sysAice")

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

--------- Switch datarefs common
local drefWindowHeat		= "sim/cockpit2/ice/ice_window_heat_on_window"
local drefProbeHeat1		= "sim/cockpit/switches/pitot_heat_on"
local drefProbeHeat2		= "sim/cockpit/switches/pitot_heat_on2"
local drefWingAice1			= "sim/cockpit/switches/anti_ice_surf_heat_left"
local drefWingAice2			= "sim/cockpit/switches/anti_ice_surf_heat_right"
local drefEngineAice		= "sim/cockpit/switches/anti_ice_inlet_heat_per_engine"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdWindowHeat1On		= "sim/ice/window_heat_on"
local cmdWindowHeat2On		= "sim/ice/window2_heat_on"
local cmdWindowHeat3On		= "sim/ice/window3_heat_on"
local cmdWindowHeat4On		= "sim/ice/window4_heat_on"
local cmdWindowHeat1Off		= "sim/ice/window_heat_off"
local cmdWindowHeat2Off		= "sim/ice/window2_heat_off"
local cmdWindowHeat3Off		= "sim/ice/window3_heat_off"
local cmdWindowHeat4Off		= "sim/ice/window4_heat_off"
local cmdWindowHeat1Tgl		= "sim/ice/window_heat_tog"
local cmdWindowHeat2Tgl		= "sim/ice/window2_heat_tog"
local cmdWindowHeat3Tgl		= "sim/ice/window3_heat_tog"
local cmdWindowHeat4Tgl		= "sim/ice/window4_heat_tog"
local cmdProbeHeat1On		= "sim/ice/pitot_heat0_on"
local cmdProbeHeat2On		= "sim/ice/pitot_heat1_on"
local cmdProbeHeat1Off		= "sim/ice/pitot_heat0_off"
local cmdProbeHeat2Off		= "sim/ice/pitot_heat1_off"
local cmdProbeHeat1Tgl		= "sim/ice/pitot_heat0_tog"
local cmdProbeHeat2Tgl		= "sim/ice/pitot_heat1_tog"

----------- Switches

-- Window Heat
sysAice.windowHeat1 		= TwoStateCmdSwitch:new("winheat1",drefWindowHeat,-1,
	cmdWindowHeat1On,cmdWindowHeat1Off,cmdWindowHeat1Tgl)
sysAice.windowHeat2 		= TwoStateCmdSwitch:new("winheat2",drefWindowHeat,1,
	cmdWindowHeat2On,cmdWindowHeat2Off,cmdWindowHeat2Tgl)
sysAice.windowHeat3 		= TwoStateCmdSwitch:new("winheat3",drefWindowHeat,2,
	cmdWindowHeat3On,cmdWindowHeat3Off,cmdWindowHeat3Tgl)
sysAice.windowHeat4 		= TwoStateCmdSwitch:new("winheat4",drefWindowHeat,3,
	cmdWindowHeat4On,cmdWindowHeat4Off,cmdWindowHeat4Tgl)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe/Pitot heat
sysAice.probeHeatASwitch 	= TwoStateCmdSwitch:new("probeheat1",drefProbeHeat1,0,
	cmdProbeHeat1On,cmdProbeHeat1Off,cmdProbeHeat1Tgl)
sysAice.probeHeatBSwitch 	= TwoStateCmdSwitch:new("probeheat2",drefProbeHeat2,0,
	cmdProbeHeat2On,cmdProbeHeat2Off,cmdProbeHeat2Tgl)
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice",drefWingAice1,0)
sysAice.wingAntiIce2 		= TwoStateDrefSwitch:new("wingaice2",drefWingAice2,0)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice",drefEngineAice,-1)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice",drefEngineAice,1)
sysAice.engAntiIce3 		= TwoStateDrefSwitch:new("eng3aice",drefEngineAice,2)
sysAice.engAntiIce4 		= TwoStateDrefSwitch:new("eng4aice",drefEngineAice,3)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

----------- Annunciators

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if sysAice.wingAiceGroup:getStatus() > 0 or sysAice.engAntiIceGroup:getStatus() > 0  then
		return 1
	else
		return 0
	end
end)

--------- Macros

-- Macro: set aice systems per flight phase
function kc_macro_aice(flightphase)
	logMsg("Anti-Ice flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_eng_antiice then
			sysAice.engAntiIceGroup:actuate(0)
		end
		if kc_has_wing_antiice then
			sysAice.wingAiceGroup:actuate(0)
		end
		if kc_has_window_heat then
			sysAice.windowHeatGroup:actuate(0)
		end		
		if kc_has_pitot_heat then 
			sysAice.probeHeatGroup:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_pitot_heat then 
			sysAice.probeHeatGroup:actuate(0)
		end
		if kc_is_airbus == false and kc_has_window_heat  then
			sysAice.windowHeatGroup:actuate(1)
		end
		if kc_has_eng_antiice then
			sysAice.engAntiIceGroup:actuate(0)
		end
		if kc_has_wing_antiice then
			sysAice.wingAiceGroup:actuate(0)
		end
	elseif flightphase == kc_phase_before_start then
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(1)	end
		if kc_is_airbus == false and kc_has_window_heat  then sysAice.windowHeatGroup:actuate(1) end
		if kc_has_eng_antiice then sysAice.engAntiIceGroup:actuate(0) end
		if kc_has_wing_antiice then	sysAice.wingAiceGroup:actuate(0) end
	elseif flightphase == kc_phase_after_start then
		if kc_has_window_heat  then
			if kc_is_airbus then	
				sysAice.windowHeatGroup:actuate(0)
			else
				sysAice.windowHeatGroup:actuate(1)
			end
		end
		if kc_has_eng_antiice and kc_is_airbus ~= true then
			if activeBriefings:get("takeoff:antiice") == 1 then
				sysAice.engAntiIceGroup:actuate(0)
			else
				sysAice.engAntiIceGroup:actuate(1)
			end
		end
		if kc_has_wing_antiice and kc_is_airbus ~= true then
			if activeBriefings:get("takeoff:antiice") == 3 then
				sysAice.wingAiceGroup:actuate(1)
			else
				sysAice.wingAiceGroup:actuate(0)
			end
		end
		if kc_has_pitot_heat and kc_is_airbus ~= true  then
			sysAice.probeHeatGroup:actuate(1)
		end 
	elseif flightphase == kc_phase_descent then
		if kc_has_window_heat and kc_is_airbus ~= true then
			sysAice.windowHeatGroup:actuate(1)
		end
		if kc_has_eng_antiice and kc_is_airbus ~= true then
			if activeBriefings:get("approach:antiice") == 1 then
				sysAice.engAntiIceGroup:actuate(0)
			else
				sysAice.engAntiIceGroup:actuate(1)
			end
		end
		if kc_has_wing_antiice and kc_is_airbus ~= true then
			if activeBriefings:get("approach:antiice") == 3 then
				sysAice.wingAiceGroup:actuate(1)
			else
				sysAice.wingAiceGroup:actuate(0)
			end
		end
		if kc_has_pitot_heat and kc_is_airbus ~= true then
			sysAice.probeHeatGroup:actuate(1)
		end		
	elseif flightphase == kc_phase_afterland then
		if kc_has_window_heat  then
			sysAice.windowHeatGroup:actuate(0)
		end
		if kc_has_eng_antiice then
			sysAice.engAntiIceGroup:actuate(0)
		end
		if kc_has_wing_antiice then
			sysAice.wingAiceGroup:actuate(0)
		end
		if kc_has_pitot_heat then
			sysAice.probeHeatGroup:actuate(0)
		end	
	else 
		logMsg("Invalid flightphase")
	end
end

return sysAice
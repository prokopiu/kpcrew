-- DFLT airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
System Elements
sysAice.engAntiIceGroup
		sysAice.engAntiIce1 
		sysAice.engAntiIce2 
		sysAice.engAntiIce3 
		sysAice.engAntiIce4
sysAice.wingAiceGroup
		sysAice.wingAntiIce1
		sysAice.wingAntiIce2
sysAice.windowHeatGroup
		sysAice.windowHeat1
		sysAice.windowHeat2
		sysAice.windowHeat3
		sysAice.windowHeat4
sysAice.probeHeatGroup
		sysAice.probeHeatSwitch1
		sysAice.probeHeatSwitch2
-- sysAice.antiiceAnc
]]

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

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysAiceDefinitions")

----------- Switches

-- === ENG anti ice
if kc_has_eng_antiice then
	sysAice.engAntiIceGroup = SwitchGroup:new("Engine Aice Switches")
	sysAice.engAntiIce1 	= kc_setup_element(def.engAntiIce1)
	sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
	if kc_num_eng_antiice > 1 then
		sysAice.engAntiIce2 = kc_setup_element(def.engAntiIce2)
		sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
	end
	if kc_num_eng_antiice > 2 then
		sysAice.engAntiIce3 = kc_setup_element(def.engAntiIce3)
		sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
	end
	if kc_num_eng_antiice > 3 then
		sysAice.engAntiIce4 = kc_setup_element(def.engAntiIce4)
		sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)
	end
else
	sysAice.engAntiIceGroup = SwitchGroup:new("Engine Aice Switches")
	sysAice.engAntiIce1 	= kc_setup_element({etype=kc_swtype_inop, name="Engine antiice"})
	sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
end

-- === Wing anti ice
if kc_has_wing_antiice then
	sysAice.wingAiceGroup 		= SwitchGroup:new("Wing Aice")
	sysAice.wingAntiIce1 		= kc_setup_element(def.wingAntiIce1)
	sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce1)
	if kc_num_wing_antiice > 1 then
		sysAice.wingAntiIce2 	= kc_setup_element(def.wingAntiIce2)
		sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)
	end
else
	sysAice.wingAiceGroup 		= SwitchGroup:new("Wing Aice")
	sysAice.wingAntiIce1 		= kc_setup_element({etype=kc_swtype_inop, name="Wing antiice"})
	sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce1)
end

-- === Window Heat
if kc_has_window_heat then
	sysAice.windowHeatGroup 	= SwitchGroup:new("Window Heat")
	sysAice.windowHeat1 		= kc_setup_element(def.windowHeat1)
	sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
	if kc_num_window_heat > 1 then
		sysAice.windowHeat2 	= kc_setup_element(def.windowHeat2)
		sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
	end
	if kc_num_window_heat > 2 then
		sysAice.windowHeat3 	= kc_setup_element(def.windowHeat3)
		sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
	end
	if kc_num_window_heat > 3 then
		sysAice.windowHeat4 		= kc_setup_element(def.windowHeat4)
		sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)
	end
else
	sysAice.windowHeatGroup 	= SwitchGroup:new("Window Heat")
	sysAice.windowHeat1 		= kc_setup_element({etype=kc_swtype_inop, name="Window heat"})
	sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
end

-- === Probe/Pitot heat
if kc_has_pitot_heat then
	sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
	sysAice.probeHeatSwitch1 	= kc_setup_element(def.probeHeatSwitch1)
	sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatSwitch1)
	if kc_num_pitot_heat > 1 then
		sysAice.probeHeatSwitch2= kc_setup_element(def.probeHeatSwitch2)
		sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatSwitch2)
	end
else
	sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
	sysAice.probeHeatSwitch1 	= kc_setup_element({etype=kc_swtype_inop, name="Probe heat"})
	sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatSwitch1)
end

----------- Annunciators

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= kc_setup_element(def.antiiceAnc)

--------- Macros

-- Macro: set aice systems per flight phase
function kc_macro_aice(flightphase)
	logMsg("Anti-Ice flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then 
		if kc_has_eng_antiice then sysAice.engAntiIceGroup:actuate(0) end
		if kc_has_wing_antiice then sysAice.wingAiceGroup:actuate(0) end
		if kc_has_window_heat then sysAice.windowHeatGroup:actuate(0) end		
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(0) end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_eng_antiice then sysAice.engAntiIceGroup:actuate(0) end
		if kc_has_wing_antiice then sysAice.wingAiceGroup:actuate(0) end
		if kc_has_window_heat then 
			if kc_is_airbus == false then 
				sysAice.windowHeatGroup:actuate(1) 
			else
				sysAice.windowHeatGroup:actuate(0) 
			end
		end		
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(0) end
	elseif flightphase == kc_phase_prel_preflight then
	elseif flightphase == kc_phase_preflight then
	elseif flightphase == kc_phase_before_start then
		if kc_has_eng_antiice then sysAice.engAntiIceGroup:actuate(0) end
		if kc_has_wing_antiice then sysAice.wingAiceGroup:actuate(0) end
		if kc_has_window_heat then 
			if kc_is_airbus == false then 
				sysAice.windowHeatGroup:actuate(1) 
			else
				sysAice.windowHeatGroup:actuate(0) 
			end
		end		
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(1) end
	elseif flightphase == kc_phase_after_start then
		if kc_has_eng_antiice then 
			if activeBriefings:get("takeoff:antiice") == 1 then
				sysAice.engAntiIceGroup:actuate(0) 
			else
				sysAice.engAntiIceGroup:actuate(1) 
			end
		end
		if kc_has_wing_antiice then
			if activeBriefings:get("takeoff:antiice") == 3 then
				sysAice.wingAiceGroup:actuate(1)
			else
				sysAice.wingAiceGroup:actuate(0)
			end
		end
		if kc_has_window_heat  then
			if kc_is_airbus then	
				sysAice.windowHeatGroup:actuate(0)
			else
				sysAice.windowHeatGroup:actuate(1)
			end
		end
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(1) end
	elseif flightphase == kc_phase_taxi_rwy then
	elseif flightphase == kc_phase_before_takeoff then
	elseif flightphase == kc_phase_takeoff then
	elseif flightphase == kc_phase_climb then
	elseif flightphase == kc_phase_descent then
		if kc_has_eng_antiice then 
			if activeBriefings:get("approach:antiice") == 1 then
				sysAice.engAntiIceGroup:actuate(0) 
			else
				sysAice.engAntiIceGroup:actuate(1) 
			end
		end
		if kc_has_wing_antiice then
			if activeBriefings:get("approach:antiice") == 3 then
				sysAice.wingAiceGroup:actuate(1)
			else
				sysAice.wingAiceGroup:actuate(0)
			end
		end
		if kc_has_window_heat  then
			if kc_is_airbus then	
				sysAice.windowHeatGroup:actuate(0)
			else
				sysAice.windowHeatGroup:actuate(1)
			end
		end
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(1) end
	elseif flightphase == kc_phase_arrival then
	elseif flightphase == kc_phase_approach then
	elseif flightphase == kc_phase_landing then
	elseif flightphase == kc_phase_taxi_stand then
	elseif flightphase == kc_phase_afterland then
		if kc_has_eng_antiice then sysAice.engAntiIceGroup:actuate(0) end
		if kc_has_wing_antiice then sysAice.wingAiceGroup:actuate(0) end
		if kc_has_window_heat then sysAice.windowHeatGroup:actuate(0) end		
		if kc_has_pitot_heat then sysAice.probeHeatGroup:actuate(0) end
	elseif flightphase == kc_phase_shutdown then
	else 
		logMsg("Invalid flightphase")
	end
end

return sysAice
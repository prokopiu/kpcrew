-- B744 MSPARKS airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B744 sysMacros")

-- custom cold & dark activities
function kc_macro_custom_cold_dark()

	if get("laminar/B747/electrical/utilityleft1") ~= 0 then
		command_once("laminar/B747/button_switch/elec_util_L")
	end
	if get("laminar/B747/electrical/utilityright2") ~= 0 then
		command_once("laminar/B747/button_switch/elec_util_R")
	end

end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()

	if get("laminar/B747/electrical/utilityleft1") == 0 then
		command_once("laminar/B747/button_switch/elec_util_L")
	end
	if get("laminar/B747/electrical/utilityright2") == 0 then
		command_once("laminar/B747/button_switch/elec_util_R")
	end

end

-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- OFF
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
	elseif mode == 1 then -- ALIGN
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_up")
		
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_up")
		
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_up")
	elseif mode == 2 then -- NAV 
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_up")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_L_up")
		
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_up")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_R_up")
		
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_dn")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_up")
		command_once("laminar/B747/flt_mgmt/iru/mode_sel_dial_C_up")
	end
end

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,30)
		command_once("laminar/B747/electrical/apu/sel_dial_dn")
		command_once("laminar/B747/electrical/apu/sel_dial_dn")
		command_once("laminar/B747/electrical/apu/sel_dial_up")
		sysElectric.apuStartSwitch:setValue(2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysElectric.apuStartSwitch:setValue(1)
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get("sim/cockpit2/electrical/APU_N1_percent") == 100 then
		if get("laminar/B747/button_switch/position",16) == 0 then
			command_once("laminar/B747/button_switch/elec_apu_gen_1")
		end
		if get("laminar/B747/button_switch/position",17) == 0 then
			command_once("laminar/B747/button_switch/elec_apu_gen_2")
		end
		if get("laminar/B747/button_switch/position",81) == 0 then
			command_once("laminar/B747/button_switch/bleed_air_vlv_apu")
		end
		kc_procvar_set(trigger,false)
	end
end

-- APU stop macro
function kc_macro_apustop()
	if get("laminar/B747/button_switch/position",16) ~= 0 then
		command_once("laminar/B747/button_switch/elec_apu_gen_1")
	end
	if get("laminar/B747/button_switch/position",17) ~= 0 then
		command_once("laminar/B747/button_switch/elec_apu_gen_2")
	end
	if get("laminar/B747/button_switch/position",81) ~= 0 then
		command_once("laminar/B747/button_switch/bleed_air_vlv_apu")
	end
	sysElectric.apuMaster:setValue(0)
	command_once("laminar/B747/electrical/apu/sel_dial_dn")
	command_once("laminar/B747/electrical/apu/sel_dial_dn")
end

-- ====================================== Fuel system flight phase 
function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	elseif flightphase == kc_phase_before_start then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(1)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(1)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	else
		logMsg("Invalid flightphase")
	end	
	-- turn off center pumps if not enough fuel
	if get("laminar/B747/fuel/fuel_tank_display_qty",0) + get("laminar/B747/fuel/fuel_tank_display_qty",7) < 1000 then
		sysFuel.fuelPumpCtrRight:actuate(0)
		sysFuel.fuelPumpCtrLeft:actuate(0)
	end
end

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(0)
		sysAir.engBleedGroup:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(0)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
	elseif flightphase == kc_phase_before_takeoff then
		if activeBriefings:get("takeoff:packs") < 2 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
		sysAir.isoValveSwitch:actuate(1)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_takeoff then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(1)
	elseif flightphase == kc_phase_approach then
		sysAir.engBleedGroup:actuate(1)
		if activeBriefings:get("approach:packs") == 1 then
			sysAir.packSwitchGroup:actuate(0)
		else
			sysAir.packSwitchGroup:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== A/P & Glareshield related functions
function kc_macro_mcp(flightphase)
	logMsg("MCP flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.yawDamper:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.vspSelector:setValue(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	elseif flightphase == kc_phase_before_takeoff then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.yawDamper:actuate(1)
		sysMCP.athrSwitch:actuate(1)
		sysMCP.vspSelector:setValue(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	elseif flightphase == kc_phase_afterland then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.yawDamper:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.vspSelector:setValue(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	else 
		logMsg("Invalid flightphase")
	end
end

-- ====================================== Lights related functions
function kc_macro_lights(flightphase)
	logMsg("Lights flight phase: " .. kcSopFlightPhase[flightphase])

	-- Cold & dark
	if flightphase == kc_phase_colddark then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(0)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)

		sysLights.instrLightGroup:actuate(0)
		sysLights.domeLightGroup:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		-- turnaround
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)

		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_before_start then
		-- before start
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)

		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
		end
	elseif flightphase == kc_phase_taxi_rwy then
		-- taxi
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)
		sysLights.domeLightGroup:actuate(0)
			
		if kc_is_daylight() == false then
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
		end	
	elseif flightphase == kc_phase_before_takeoff then
		-- before takeoff
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		
		if kc_is_daylight() == false then
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
		end	
	elseif flightphase == kc_phase_approach then
		-- approach
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		
		if kc_is_daylight() == false then
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
		end	
	elseif flightphase == kc_phase_afterland then
		-- after land
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		
		if kc_is_daylight() == false then
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
		end	
	elseif flightphase == kc_phase_shutdown then
		-- shutdown
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.emerLights:actuate(1)
		
		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(0)
			sysLights.panelLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
		end	
	else
		logMsg("Invalid flightphase")
	end	
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,25)
		command_once("sim/engines/mixture_max")
		if trigger == "engstart1" then
			if get("laminar/B747/fuel/fuel_control/toggle_sw_pos",0) == 0 then
				command_once("laminar/B747/fuel/fuel_control_1/toggle_switch")
			end
			if get("laminar/B747/air/engine1/bleed_valve_pos") == 0 then
				command_once("laminar/B747/toggle_switch/engine_start1")
			end
		end
		if trigger == "engstart2" then
			if get("laminar/B747/fuel/fuel_control/toggle_sw_pos",1) == 0 then
				command_once("laminar/B747/fuel/fuel_control_2/toggle_switch")
			end
			if get("laminar/B747/air/engine2/bleed_valve_pos") == 0 then
				command_once("laminar/B747/toggle_switch/engine_start2")
			end
		end
		if trigger == "engstart3" then
			if get("laminar/B747/fuel/fuel_control/toggle_sw_pos",2) == 0 then
				command_once("laminar/B747/fuel/fuel_control_3/toggle_switch")
			end
			if get("laminar/B747/air/engine3/bleed_valve_pos") == 0 then
				command_once("laminar/B747/toggle_switch/engine_start3")
			end
		end
		if trigger == "engstart4" then
			if get("laminar/B747/fuel/fuel_control/toggle_sw_pos",3) == 0 then
				command_once("laminar/B747/fuel/fuel_control_4/toggle_switch")
			end
			if get("laminar/B747/air/engine4/bleed_valve_pos") == 0 then
				command_once("laminar/B747/toggle_switch/engine_start4")
			end
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				-- command_once("laminar/B747/toggle_switch/engine_start1")
			end
			if trigger == "engstart2" then
				-- command_once("laminar/B747/toggle_switch/engine_start2")
			end
			if trigger == "engstart3" then
				-- command_once("laminar/B747/toggle_switch/engine_start3")
			end
			if trigger == "engstart4" then
				-- command_once("laminar/B747/toggle_switch/engine_start4")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Autobrake 
function kc_macro_set_autobrake(index)
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	if mode == 0 then -- RTO
	elseif mode == 1 then -- OFF
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 2 then -- 1 
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 3 then -- 2
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 4 then -- 3
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 4 then -- 4
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 4 then -- MAX
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	end
end

return sysMacros
-- B742 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B742 sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set("B742/OVHD/anti_skid_on_off_sw",0)
	set("B742/OVHD/anti_skid_on_off_cap",1)
	set("B742/OVHD/body_gear_steer_sw",0)
	set("B742/OVHD/body_gear_steer_cap",0)
	
	set("B742/OVHD/emerg_lights_cap",1)
	
	set_array("B742/FE/galley_pwr_sw",0,0)
	set_array("B742/FE/galley_pwr_sw",1,0)
	set_array("B742/FE/galley_pwr_sw",2,0)
	set_array("B742/FE/galley_pwr_sw",3,0)
	
	set_array("B742/HYD/air_pump_sw",0,0)
	set_array("B742/HYD/air_pump_sw",1,0)
	set_array("B742/HYD/air_pump_sw",2,0)
	set_array("B742/HYD/air_pump_sw",3,0)

	set_array("B742/FE/galley_chiller_sw",0,0)
	set_array("B742/FE/galley_chiller_sw",1,0)
	set_array("B742/FE/galley_chiller_sw",2,0)	
	
	set("B742/FE/galley_control_lav_fan_sw",0)
	set("B742/cockpit_light/storm_on_off",0)
	set("B742/OVHD/radio_master_bus_ESS_on",0)
	set("B742/OVHD/radio_master_bus_NO2_on",0)
	
	set("B742/controls/fuel_cut_off_pos_1",0)
	set("B742/controls/fuel_cut_off_pos_2",0)
	set("B742/controls/fuel_cut_off_pos_3",0)
	set("B742/controls/fuel_cut_off_pos_4",0)
	
	set("B742/AIR_COND/trim_air_sw",0)
	sysEFIS.wxrPilot:actuate(0)
	set("B742/ELEC/ESS_bus_sel",0)
	
	sysEngines.engStarterGroup:actuate(0)

	set_array("B742/OVHD/alt_flaps_LE_sw",0,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",1,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",2,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",3,0)	

	set("B742/OVHD/alt_flaps_TE_sw_inbd",0)
	set("B742/OVHD/alt_flaps_TE_sw_outbd",0)
	
	set("B742/OVHD/stby_ignition_sel",0)
	
	kc_macro_set_autobrake(kc_AutoBrakeOff)
	
	set_array("B742/AP_panel/pitch_rotary",0,0)
	set_array("B742/AP_panel/pitch_rotary",1,0)
	
	set("B742/FUEL/scavenge_pump_sw",0)
	
	set("B742/AIR_COND/mode_sel_rotary",1)
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set("B742/OVHD/anti_skid_on_off_sw",1)
	set("B742/OVHD/anti_skid_on_off_cap",0)
	
	set("B742/OVHD/emerg_lights_sw",1)
	set("B742/OVHD/emerg_lights_cap",0)
	
	set_array("B742/FE/galley_chiller_sw",0,1)
	set_array("B742/FE/galley_chiller_sw",1,1)
	set_array("B742/FE/galley_chiller_sw",2,1)	
	
	set("B742/FE/galley_control_lav_fan_sw",1)

	sysFuel.fuelCrossFeed:actuate(0)
	sysFuel.fuelCrossFeed1:actuate(1)
	sysFuel.fuelCrossFeed2:actuate(1)

	set("B742/OVHD/radio_master_bus_ESS_on",1)
	set("B742/OVHD/radio_master_bus_NO2_on",1)
	
	set_array("B742/HYD/air_pump_sw",0,0)
	set_array("B742/HYD/air_pump_sw",1,0)
	set_array("B742/HYD/air_pump_sw",2,0)
	set_array("B742/HYD/air_pump_sw",3,0)

	set("B742/controls/fuel_cut_off_pos_1",0)
	set("B742/controls/fuel_cut_off_pos_2",0)
	set("B742/controls/fuel_cut_off_pos_3",0)
	set("B742/controls/fuel_cut_off_pos_4",0)
	
	set("B742/AIR_COND/trim_air_sw",1)
	sysEFIS.wxrPilot:setValue(1)
	
	set("B742/FE/DC_bus_isolation_2_sw",1)
	set("B742/FE/DC_bus_isolation_3_sw",1)
	set("B742/FE/DC_bus_isolation_4_sw",1)

	set("B742/ELEC/ESS_bus_sel",1)
	
	set("B742/OVHD/body_gear_steer_sw",1)
	set("B742/OVHD/body_gear_steer_cap",1)
	
	sysEngines.engStarterGroup:actuate(0)
	
	set_array("B742/OVHD/alt_flaps_LE_sw",0,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",1,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",2,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",3,0)	

	set("B742/OVHD/alt_flaps_TE_sw_inbd",0)
	set("B742/OVHD/alt_flaps_TE_sw_outbd",0)
	
	set("B742/OVHD/stby_ignition_sel",0)
	
	kc_macro_set_autobrake(kc_AutoBrakeOff)
	
	set_array("B742/AP_panel/pitch_rotary",0,0)
	set_array("B742/AP_panel/pitch_rotary",1,0)
	
	set("B742/FUEL/scavenge_pump_sw",0)
	
	set("B742/AIR_COND/mode_sel_rotary",1)
end


-- ====================================== Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		set_array("B742/FE/galley_pwr_sw",0,0)
		set_array("B742/FE/galley_pwr_sw",1,0)
		set_array("B742/FE/galley_pwr_sw",2,0)
		set_array("B742/FE/galley_pwr_sw",3,0)
		
		set_array("B742/FUEL/fuel_heat_sw",0,0)
		set_array("B742/FUEL/fuel_heat_sw",1,0)
		set_array("B742/FUEL/fuel_heat_sw",2,0)
		set_array("B742/FUEL/fuel_heat_sw",3,0)
		
		sysElectric.batterySwitch:actuate(0) 
		sysElectric.stbyPowerSwitch:actuate(0)
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.gpuGenBusGroup:actuate(0)
		sysElectric.apuGenBusGroup:actuate(0)
		sysElectric.apuStartSwitch:actuate(0)
		
		set("B742/FUEL/scavenge_pump_sw",0)
	elseif flightphase == kc_phase_turnaround then
		set_array("B742/FE/galley_pwr_sw",0,1)
		set_array("B742/FE/galley_pwr_sw",1,1)
		set_array("B742/FE/galley_pwr_sw",2,1)
		set_array("B742/FE/galley_pwr_sw",3,1)

		set_array("B742/FUEL/fuel_heat_sw",0,0)
		set_array("B742/FUEL/fuel_heat_sw",1,0)
		set_array("B742/FUEL/fuel_heat_sw",2,0)
		set_array("B742/FUEL/fuel_heat_sw",3,0)
		
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
		
		set("B742/FUEL/scavenge_pump_sw",0)
	elseif flightphase == kc_phase_before_start then
		set_array("B742/FE/galley_pwr_sw",0,0)
		set_array("B742/FE/galley_pwr_sw",1,0)
		set_array("B742/FE/galley_pwr_sw",2,0)
		set_array("B742/FE/galley_pwr_sw",3,0)
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
		set_array("B742/FE/galley_pwr_sw",0,1)
		set_array("B742/FE/galley_pwr_sw",1,1)
		set_array("B742/FE/galley_pwr_sw",2,1)
		set_array("B742/FE/galley_pwr_sw",3,1)
		set("B742/AUX_PWR/APU_split_sys_sw",1)
	elseif flightphase == kc_phase_shutdown then
		sysElectric.genSwitchGroup:actuate(0)
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
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.discAPSwitch:actuate(0)
	elseif flightphase == kc_phase_after_start then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(1)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.discAPSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(1)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
		sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
	elseif flightphase == kc_phase_afterland then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end 

-- ====================================== Fuel system flight phase 
function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
		sysFuel.fuelCrossFeed1:actuate(1)
		sysFuel.fuelCrossFeed4:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysFuel.allFuelPumpGroup:actuate(1)
		if get("sim/flightmodel/weight/m_fuel") > 4500 then
			sysFuel.fuelPump5:actuate(1)
			sysFuel.fuelPump6:actuate(1)
		else
			sysFuel.fuelPump5:actuate(0)
			sysFuel.fuelPump6:actuate(0)
		end
		sysFuel.fuelCrossFeed:actuate(0)
		sysFuel.fuelCrossFeed1:actuate(1)
		sysFuel.fuelCrossFeed4:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

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

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,1)
		set_array("B742/HYD/air_pump_sw",1,1)
		set_array("B742/HYD/air_pump_sw",2,1)
		set_array("B742/HYD/air_pump_sw",3,1)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,1)
		set_array("B742/HYD/air_pump_sw",1,1)
		set_array("B742/HYD/air_pump_sw",2,1)
		set_array("B742/HYD/air_pump_sw",3,1)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,1)
		set_array("B742/HYD/air_pump_sw",1,1)
		set_array("B742/HYD/air_pump_sw",2,1)
		set_array("B742/HYD/air_pump_sw",3,1)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
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

-- set flaps based on index
function kc_macro_set_flap(flapindex)
	set("sim/cockpit2/controls/flap_ratio",sysControls.flaps_pos[flapindex])
end

function kc_macro_set_autobrake(index)
	sysControls.Autobrake:setValue(index)	
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		if trigger == "engstart1" then
			set("B742/controls/fuel_cut_off_pos_1",1)
			sysEngines.engStart1Switch:actuate(1)
		end
		if trigger == "engstart2" then
			set("B742/controls/fuel_cut_off_pos_2",1)
			sysEngines.engStart2Switch:actuate(1)
		end
		if trigger == "engstart3" then
			set("B742/controls/fuel_cut_off_pos_3",1)
			sysEngines.engStart3Switch:actuate(1)
		end
		if trigger == "engstart4" then
			set("B742/controls/fuel_cut_off_pos_4",1)	
			sysEngines.engStart4Switch:actuate(1)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				sysEngines.engStart1Switch:actuate(0)
			end
			if trigger == "engstart2" then
				sysEngines.engStart2Switch:actuate(0)
			end
			if trigger == "engstart3" then
				sysEngines.engStart3Switch:actuate(0)
			end
			if trigger == "engstart4" then
				sysEngines.engStart4Switch:actuate(0)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("B742/controls/fuel_cut_off_pos_1",0)
	set("B742/controls/fuel_cut_off_pos_2",0)
	set("B742/controls/fuel_cut_off_pos_3",0)
	set("B742/controls/fuel_cut_off_pos_4",0)	
end

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,30)
		sysElectric.apuGenBus2:actuate(1)
		sysElectric.apuGenBus3:actuate(1)
		sysElectric.apuGenBus4:actuate(1)
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
		sysElectric.apuStartSwitch:setValue(1)
		sysElectric.apuGenBus2:actuate(0)
		sysElectric.apuGenBus3:actuate(0)
		sysElectric.apuGenBus4:actuate(0)
		sysElectric.apuGenBus1:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

-- APU start background
function kc_macro_apustop()
	sysElectric.apuGenBusGroup:actuate(0)
	sysAir.apuBleedSwitch:actuate(0)
	sysElectric.apuMaster:setValue(0)
end

return sysMacros
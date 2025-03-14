-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

logMsg("DFLT sysMacros")

-- ====================================== States related macros
function kc_macro_state_cold_and_dark()
	logMsg("DFLT kc_macro_state_cold_and_dark")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	kc_macro_mcp_cold_dark()

	if kc_is_turboprop or kc_is_ga then
		sysEngines.mixtureLever:actuate(0)
	end

	if kc_has_proplever then
		sysEngines.propLever:setValue(kc_prop_lvr_feather)
	end
	
	if kc_has_irs then
		kc_macro_set_irs(0)
	end
	
	sysGeneral.parkBrakeSwitch:actuate(1) 
	
	if kc_has_ground_obj then
		kc_macro_set_groundobjects(1)
	end
	
	if kc_has_retractgear then
		sysGeneral.GearSwitch:actuate(1)
	end
	if kc_has_speedbrake then
		sysControls.Speedbrake:setValue(0)
	end
	
	kc_macro_set_flap(0)
	
	if kc_has_wipers then
		sysGeneral.wiperGroup:actuate(0)
	end
	
	sysEngines.throttlePos:actuate(0)
	kc_macro_stop_engine()
	
	if kc_has_aileron_trim then
		sysControls.aileronReset:actuate(1)
	end
	if kc_has_rudder_trim then
		sysControls.rudderReset:actuate(1)
	end
	
	kc_macro_hydraulic_off()
	
	if kc_has_emer_lights then
		sysLights.emerLights:actuate(0)
	end
	
	kc_macro_fuelpumps_off()
	if kc_has_fuel_select then
		sysFuel.fuelSwitchGroup:actuate(0)
	end
	
	if kc_has_press_cab then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(0)
	end
	if kc_has_oxygen then
		sysAir.oxygenMaster:actuate(0)
	end
	if kc_has_engine_bleed then
		sysAir.engBleedGroup:actuate(0)
	end
	
	if kc_has_eng_antiice then
		sysAice.engAntiIceGroup:actuate(0)
	end
	if kc_has_wing_antiice then
		sysAice.wingAntiIce:actuate(0)
	end
	if kc_has_window_heat then
		sysAice.windowHeatGroup:actuate(0)
	end
	
	if kc_has_pitot_heat then 
		sysAice.probeHeatGroup:actuate(0)
	end
	
	if kc_has_seatbelt_sgn then
		sysGeneral.seatBeltSwitch:actuate(0)
	end
	if kc_has_nosmoke_sgn then
		sysGeneral.noSmokingSwitch:actuate(0)
	end

	if kc_has_autobrake then
		kc_macro_set_autobrake(0)
	end
	
	if kc_is_airbus == false then
		sysEngines.engIgnitionGroup:actuate(0)	
	end 
	
	sysElectric.gen1Switch:actuate(0)
	if kc_get_nr_generators() > 1 then
		sysElectric.gen2Switch:actuate(0)
	end
	if kc_get_nr_generators() > 2 then
		sysElectric.gen3Switch:actuate(0)
	end
	if kc_get_nr_generators() > 3 then
		sysElectric.gen4Switch:actuate(0)
	end

	if kc_has_apu then
		sysElectric.apuStartSwitch:actuate(0)
	end
	if kc_has_gpu then
		sysElectric.gpuConnect:actuate(0)
	end
	
	kc_macro_elec_cold_dark()
	
	kc_macro_custom_cold_dark()

end

function kc_macro_state_turnaround()
	logMsg("DFLT kc_macro_state_turnaround")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	sysGeneral.parkBrakeSwitch:actuate(1) 

	if kc_has_retractgear then
		sysGeneral.GearSwitch:actuate(1)
	end
	if kc_has_speedbrake then
		sysControls.Speedbrake:setValue(0)
	end
	
	kc_macro_set_flap(0)
	
	if kc_has_wipers then
		sysGeneral.wiperGroup:actuate(0)
	end
	
	sysEngines.throttlePos:actuate(0)
	kc_macro_stop_engine()
	
	if kc_has_autobrake then
		kc_macro_set_autobrake(0)
	end
	
	sysElectric.batterySwitch:actuate(1) 
	sysElectric.battery2Switch:actuate(1)
	
	kc_macro_lights_preflight()
	
	if kc_is_airbus then
		sysElectric.gen1Switch:actuate(1)
		if kc_get_nr_generators() > 1 then
			sysElectric.gen2Switch:actuate(1)
		end
		if kc_get_nr_generators() > 2 then
			sysElectric.gen3Switch:actuate(1)
		end
		if kc_get_nr_generators() > 3 then
			sysElectric.gen4Switch:actuate(1)
		end
	else
		sysElectric.gen1Switch:actuate(0)
		if kc_get_nr_generators() > 1 then
			sysElectric.gen2Switch:actuate(0)
		end
		if kc_get_nr_generators() > 2 then
			sysElectric.gen3Switch:actuate(0)
		end
		if kc_get_nr_generators() > 3 then
			sysElectric.gen4Switch:actuate(0)
		end
	end	
	
	if kc_has_gpu and activeBriefings:get("departure:activateAPUPowerUp") == 2 then
		sysElectric.gpuConnect:actuate(1)
		sysElectric.gpuGenBusGroup:actuate(1)
	end
	
	if kc_has_apu and activeBriefings:get("departure:activateAPUPowerUp") == 1 then
		kc_procvar_set("apustart",true)
		kc_procvar_set("apuonline",true)
	end 
	
	kc_macro_hydraulic_initial()
	
	if kc_has_irs then
		if kc_is_airbus == true then 
			kc_macro_set_irs(1)
		else
			kc_macro_set_irs(2)
		end
	end
	
	if kc_has_seatbelt_sgn then
		sysGeneral.seatBeltSwitch:actuate(1)
	end
	if kc_has_nosmoke_sgn then
		sysGeneral.noSmokingSwitch:actuate(1)
	end

	if kc_has_emer_lights then
		sysLights.emerLights:actuate(1)
	end
	
	kc_macro_fuelpumps_off()
	if kc_has_fuel_select then
		sysFuel.fuelSwitchGroup:actuate(0)
	end
	
	if kc_has_press_cab then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(0)
	end
	if kc_has_oxygen then
		sysAir.oxygenMaster:actuate(0)
	end
	if kc_has_engine_bleed then
		sysAir.engBleedGroup:actuate(0)
	end
	
	if kc_has_avionics_sw then
		sysElectric.avionicsSwitchGroup:actuate(1)
	end
	if kc_has_inv_ess_bus then
		if kc_is_airbus then
			sysElectric.inverterSwitchGroup:actuate(0)
		else
			sysElectric.inverterSwitchGroup:actuate(1)
		end
	end
	if kc_has_bus_ties then
		sysElectric.dcBusTie:actuate(1)
	end

	if kc_has_seatbelt_sgn then
		sysGeneral.seatBeltSwitch:actuate(1)
	end
	if kc_has_nosmoke_sgn then
		sysGeneral.noSmokingSwitch:actuate(1)
	end

	if kc_has_pitot_heat then 
		sysAice.probeHeatGroup:actuate(0)
	end
	
	if kc_has_window_heat  then
		sysAice.windowHeatGroup:actuate(1)
	end

	kc_macro_set_local_baro()

	kc_macro_set_xpdrmode(sysRadios.stby)
	kc_macro_set_xpdrcode(2000)
	
	if kc_is_airbus == false then
		sysEngines.engIgnitionGroup:actuate(0)	
	end 
	
	kc_macro_doors_preflight()
	kc_macro_mcp_preflight()	
	
	if kc_is_turboprop or kc_is_ga then
		sysEngines.mixtureLever:actuate(0)
	end

	if kc_has_proplever then
		sysEngines.propLever:setValue(kc_prop_lvr_feather)
	end	
	
	kc_macro_custom_turnaround()
end

-- ====================================== Lights related functions

function kc_macro_lights_preflight()
	logMsg("DFLT kc_macro_lights_preflight")
	-- set the lights as needed during preflight/turnaround
	sysLights.landLightGroup:actuate(0)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(0)
	end
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(0)
	end
	if kc_has_pos_lights then
		sysLights.positionSwitch:actuate(1)
	end
	if kc_has_beacon then
		sysLights.beaconSwitch:actuate(0)
	end
	if kc_has_strobe_lights then
		sysLights.strobesSwitch:actuate(0)
	end
	if kc_has_instr_lights then
		sysLights.instrLightGroup:actuate(1)
	end
	if kc_is_daylight() then
		if kc_has_dome_lights then
			sysLights.domeLightSwitch:actuate(0)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_has_panel_lights then
			sysLights.panelLightGroup:actuate(0)
		end
	else
		if kc_has_dome_lights then
			sysLights.domeLightSwitch:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(1)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(1)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(1)
		end
		if kc_has_panel_lights then
			sysLights.panelLightGroup:actuate(1)
		end
	end
end

function kc_macro_lights_before_start()
	-- set the lights as needed when preparing for push and engine start
	kc_macro_lights_preflight()
	if kc_has_beacon then
		sysLights.beaconSwitch:actuate(1)
	end
	if kc_has_strb_as_bcn then
		sysLights.strobesSwitch:actuate(1)
	end
	if kc_is_daylight() == false then		
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
	end
end

function kc_macro_lights_before_taxi()
	kc_macro_lights_before_start()
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(1)
	end
	if kc_has_ll_as_taxi then
		sysLights.landLightGroup:actuate(1)
	end
	if kc_has_dome_lights then
		sysLights.domeLightSwitch:actuate(0)
	end
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	kc_macro_lights_before_taxi()
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(0)
	end
	sysLights.landLightGroup:actuate(1)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(1)
	end
	if kc_has_strobe_lights then
		sysLights.strobesSwitch:actuate(1)
	end
end

function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	kc_macro_lights_for_takeoff()
	sysLights.landLightGroup:actuate(0)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(0)
	end
	if kc_has_logo_lights then
		sysLights.logoSwitch:actuate(0)
	end
end

function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	kc_macro_lights_climb_10k()
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() == false then		
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(1)
		end
	end
end

function kc_macro_lights_approach()
	-- set the lights when in the approach
	kc_macro_lights_descend_10k()
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(1)
	end
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() == false then		
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(1)
		end
	end	
end

function kc_macro_lights_cleanup()
	-- set the lights on cleaning up after landing
	kc_macro_lights_approach()
	sysLights.landLightGroup:actuate(0)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(0)
	end
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(1)
	end
	if kc_has_ll_as_taxi then
		sysLights.landLightGroup:actuate(1)
	end
	if kc_has_strobe_lights then
		sysLights.strobesSwitch:actuate(0)
	end
end

function kc_macro_lights_arrive_parking()
	-- set the lights when arriving the parking position
	kc_macro_lights_cleanup()
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(0)
	end
	if kc_has_ll_as_taxi then
		sysLights.landLightGroup:actuate(0)
	end
end

function kc_macro_lights_after_shutdown()
	-- set the lights when engines are stopped
	kc_macro_lights_arrive_parking()
	if kc_has_pos_lights then
		sysLights.positionSwitch:actuate(1)
	end
	if kc_has_beacon then
		sysLights.beaconSwitch:actuate(0)
	end
	if kc_has_strobe_lights then
		sysLights.strobesSwitch:actuate(0)
	end
	if kc_is_daylight() then		
		if kc_has_dome_lights then
			sysLights.domeLightSwitch:actuate(0)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_has_panel_lights then
			sysLights.panelLightGroup:actuate(0)
		end
	else
		if kc_has_dome_lights then
			sysLights.domeLightSwitch:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(1)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(1)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(1)
		end
		if kc_has_panel_lights then
			sysLights.panelLightGroup:actuate(1)
		end
	end

end

function kc_macro_lights_cold_dark()
	-- set the lights for cold & dark mode
	
	sysLights.landLightGroup:actuate(0)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(0)
	end
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(0)
	end
	if kc_has_pos_lights then
		sysLights.positionSwitch:actuate(0)
	end
	if kc_has_beacon then
		sysLights.beaconSwitch:actuate(0)
	end
	if kc_has_strobe_lights then
		sysLights.strobesSwitch:actuate(0)
	end
	if kc_has_instr_lights then
		sysLights.instrLightGroup:actuate(0)
	end
	if kc_has_dome_lights then
		sysLights.domeLightSwitch:actuate(0)
	end
	if kc_has_logo_lights then
		sysLights.logoSwitch:actuate(0)
	end
	if kc_has_wing_lights then
		sysLights.wingSwitch:actuate(0)
	end
	if kc_has_wheel_lights then
		sysLights.wheelSwitch:actuate(0)
	end
	if kc_has_panel_lights then
		sysLights.panelLightGroup:actuate(0)
	end
end

function kc_macro_lights_all_on()
	-- set the lights all on for test and checks
	sysLights.landLightGroup:actuate(1)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(1)
	end
	if kc_has_taxi_light then
		sysLights.taxiSwitch:actuate(1)
	end
	if kc_has_pos_lights then
		sysLights.positionSwitch:actuate(1)
	end
	if kc_has_beacon then
		sysLights.beaconSwitch:actuate(1)
	end
	if kc_has_strobe_lights then
		sysLights.strobesSwitch:actuate(1)
	end
	if kc_has_instr_lights then
		sysLights.instrLightGroup:actuate(1)
	end
	if kc_has_dome_lights then
		sysLights.domeLightSwitch:actuate(1)
	end
	if kc_has_logo_lights then
		sysLights.logoSwitch:actuate(1)
	end
	if kc_has_wing_lights then
		sysLights.wingSwitch:actuate(1)
	end
	if kc_has_wheel_lights then
		sysLights.wheelSwitch:actuate(1)
	end
	if kc_has_panel_lights then
		sysLights.panelLightGroup:actuate(1)
	end
end

-- ====================================== Door related functions
function kc_macro_doors_preflight()
	if kc_has_doors then
		sysGeneral.doorL1:actuate(1)
		if kc_has_stairs then
			if activeBriefings:get("taxi:gateStand") > 1 then
				sysGeneral.stairsL1:actuate(1)
			else
				sysGeneral.stairsL1:actuate(0)
			end
		end
		sysGeneral.doorL2:actuate(0)
		sysGeneral.doorR1:actuate(0)
		sysGeneral.doorR2:actuate(0)
		if kc_has_cargo_doors then
			sysGeneral.doorFCargo:actuate(1)
			sysGeneral.doorACargo:actuate(1)
		end
		if kc_has_cockpit_door then
			sysGeneral.cockpitDoor:actuate(1)
		end
	end
end

function kc_macro_doors_before_start()
	if kc_has_doors then
		sysGeneral.doorL1:actuate(0)
		if kc_has_stairs then
			sysGeneral.stairsL1:actuate(0)
		end
		sysGeneral.doorL2:actuate(0)
		sysGeneral.doorR1:actuate(0)
		sysGeneral.doorR2:actuate(0)
		if kc_has_cargo_doors then
			sysGeneral.doorFCargo:actuate(0)
			sysGeneral.doorACargo:actuate(0)
		end
		if kc_has_cockpit_door then
			sysGeneral.cockpitDoor:actuate(0)
		end
	end
end

function kc_macro_doors_after_shutdown()
	if kc_has_doors then
		sysGeneral.doorL1:actuate(1)
		if kc_has_stairs then
			if activeBriefings:get("taxi:gateStand") > 1 then
				sysGeneral.stairsL1:actuate(1)
			else
				sysGeneral.stairsL1:actuate(0)
			end
		end
		sysGeneral.doorL2:actuate(0)
		sysGeneral.doorR1:actuate(0)
		sysGeneral.doorR2:actuate(0)
		if kc_has_cargo_doors then
			sysGeneral.doorFCargo:actuate(1)
			sysGeneral.doorACargo:actuate(1)
		end
		if kc_has_cockpit_door then
			sysGeneral.cockpitDoor:actuate(1)
		end
	end
end

function kc_macro_doors_cold_dark()
	if kc_has_doors then
		sysGeneral.doorL1:actuate(1)
		if kc_has_stairs then
			if activeBriefings:get("taxi:gateStand") > 1 then
				sysGeneral.stairsL1:actuate(1)
			else
				sysGeneral.stairsL1:actuate(0)
			end
		end
		sysGeneral.doorL2:actuate(0)
		sysGeneral.doorR1:actuate(0)
		sysGeneral.doorR2:actuate(0)
		if kc_has_cargo_doors then
			sysGeneral.doorFCargo:actuate(0)
			sysGeneral.doorACargo:actuate(0)
		end
		if kc_has_cockpit_door then
			sysGeneral.cockpitDoor:actuate(1)
		end
	end
end

function kc_macro_doors_all_open()
	if kc_has_doors then
		sysGeneral.doorGroup:actuate(1)
	end
end

function kc_macro_doors_all_closed()
	if kc_has_doors then
		sysGeneral.doorGroup:actuate(0)
	end
end

-- ====================================== A/P & Glareshield related functions

function kc_macro_mcp_cold_dark()
	if kc_has_flightdir then
		sysMCP.fdirGroup:actuate(0)
	end
	if kc_has_autothrottle then
		sysMCP.athrSwitch:actuate(0)
	end
	if kc_has_ils then
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
	end
	if kc_has_ias_sel then
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	end
	if kc_has_hdg_sel then
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	end
	if kc_has_alt_sel then
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	end
	if kc_has_vsp_sel then
		sysMCP.vspSelector:setValue(0)
	end
	if kc_has_autopilot then
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
	end
	if kc_has_yawdamper then
		sysMCP.yawDamper:actuate(0)
	end
end

function kc_macro_mcp_preflight()
	if kc_has_flightdir then
		sysMCP.fdirGroup:actuate(1)
	end
	if kc_has_autothrottle then
		sysMCP.athrSwitch:actuate(0)
	end
	if kc_has_yawdamper then
		sysMCP.yawDamper:actuate(0)
	end
	if kc_has_ias_sel then
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	end
	if kc_has_hdg_sel then
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	end
	if kc_has_alt_sel then
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	end
	if kc_has_vsp_sel then
		sysMCP.vspSelector:actuate(0)
	end
	if kc_has_autopilot then
		sysMCP.discAPSwitch:actuate(0)
	end
end

function kc_macro_mcp_takeoff()
	if kc_has_flightdir then
		sysMCP.fdirGroup:actuate(1)
	end
	if kc_has_autothrottle then
		sysMCP.athrSwitch:actuate(1)
	end
	if kc_has_ias_sel then
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	end
	if kc_has_hdg_sel then
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	end
	if kc_has_alt_sel then
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	end
	if activeBriefings:get("takeoff:apMode") > 1 then
		if kc_has_vnav and kc_has_lnav then
			sysMCP.lnavSwitch:actuate(1)
			sysMCP.vnavSwitch:actuate(1)
		else
			sysMCP.vorlocSwitch:actuate(1)
		end
	else
		sysMCP.hdgselSwitch:actuate(1)
		if kc_has_flch_ias then
			sysMCP.iasSelector:setValue(1)
		else
			sysMCP.vsSwitch:actuate(1)
		end
	end
	if kc_has_ils then
		sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
		sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
	end
	if kc_has_vsp_sel then
		sysMCP.vspSelector:actuate(0)
	end
	if kc_has_autopilot then
		sysMCP.discAPSwitch:actuate(0)
	end
end

function kc_macro_mcp_goaround()
	if kc_has_flightdir then
		sysMCP.fdirGroup:actuate(1)
	end
	if kc_has_autothrottle then
		sysMCP.athrSwitch:actuate(1)
	end
	if kc_has_ias_sel then
		sysMCP.iasSelector:setValue(activeBriefings:get("approach:gav2"))
	end
	if kc_has_hdg_sel then
		sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading"))
	end
	if kc_has_alt_sel then
		sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude"))
	end
	if activeBriefings:get("takeoff:apMode") > 1 then
		if kc_has_vnav and kc_has_lnav then
			sysMCP.lnavSwitch:actuate(1)
			sysMCP.vnavSwitch:actuate(1)
		else
			sysMCP.vorlocSwitch:actuate(1)
		end
	else
		sysMCP.hdgselSwitch:actuate(1)
		if kc_has_flch_ias then
			sysMCP.iasSelector:setValue(1)
		else
			sysMCP.vsSwitch:actuate(1)
		end
	end
	if kc_has_ias_sel then
		sysMCP.speedSwitch:actuate(1)
	end
	if kc_has_yawdamper then
		sysMCP.yawDamper:actuate(1)
	end
end

function kc_macro_mcp_after_landing()
	if kc_has_flightdir then
		sysMCP.fdirGroup:actuate(0)
	end
	if kc_has_autothrottle then
		sysMCP.athrSwitch:actuate(0)
	end
	if kc_has_hdg_sel then
		sysMCP.hdgSelector:setValue(0)
	end
	if kc_has_ias_sel then
		sysMCP.speedSwitch:actuate(0)
	end
	if kc_has_autopilot then
		sysMCP.discAPSwitch:actuate(0)
	end
	if kc_has_yawdamper then
		sysMCP.yawDamper:actuate(0)
	end
end

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("sim/cockpit/misc/barometer_setting",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit/misc/barometer_setting2",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- packs all on
function kc_macro_packs_on()
	if kc_has_press_cab then
		sysAir.packSwitchGroup:actuate(1)
	end
end

-- packs all on
function kc_macro_packs_off()
	if kc_has_press_cab then
		sysAir.packSwitchGroup:actuate(0)
	end
end

-- packs for takeoff
function kc_macro_packs_takeoff()
	if kc_has_press_cab then
		if activeBriefings:get("takeoff:packs") < 2 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
	end
end

-- bleeds on
function kc_macro_bleeds_on()
	if kc_has_press_cab then
		sysAir.engBleedGroup:actuate(1)
	end
end

-- bleeds off
function kc_macro_bleeds_off()
	if kc_has_press_cab then
		sysAir.engBleedGroup:actuate(0) 
	end
end

-- bleeds takeoff 
function kc_macro_bleeds_takeoff()
	if activeBriefings:get("takeoff:bleeds") > 1 then 
		sysAir.engBleedGroup:actuate(1) 
	else
		sysAir.engBleedGroup:actuate(0) 
	end
	if kc_has_apu then
		sysAir.apuBleedSwitch:actuate(0)
	end
end

-- =============

-- hyd pumps initial setup
function kc_macro_hydraulic_initial()
	if kc_has_hyd_elec_pmps == true then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	end 
	if kc_has_hyd_eng_pmps == true then
		sysHydraulic.engHydPumpGroup:actuate(0)
	end
end

-- hyd pumps all off
function kc_macro_hydraulic_off()
	if kc_has_hyd_elec_pmps == true then
		sysHydraulic.elecHydPumpGroup:actuate(0)
	end
	if kc_has_hyd_eng_pmps == true then
		sysHydraulic.engHydPumpGroup:actuate(0)
	end
end

-- hyd pumps all on
function kc_macro_hydraulic_on()
	if kc_has_hyd_elec_pmps == true then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	end
	if kc_has_hyd_eng_pmps == true then
		sysHydraulic.engHydPumpGroup:actuate(1)
	end
end

-- cold & dark electric
function kc_macro_elec_cold_dark()
	sysElectric.genSwitchGroup:actuate(0)
	if kc_has_avionics_sw == true then
		sysElectric.avionicsSwitchGroup:actuate(0)
	end
	if kc_has_inv_ess_bus == true then
		sysElectric.inverterSwitchGroup:actuate(0)
	end
	if kc_has_bus_ties == true then
		sysElectric.dcBusTie:actuate(0)
	end
	sysElectric.batterySwitch:actuate(0) 
	sysElectric.battery2Switch:actuate(0) 	
end

-- preflight electric
function kc_macro_elec_preflight()
	sysElectric.genSwitchGroup:actuate(0)
	if kc_has_avionics_sw == true then
		sysElectric.avionicsSwitchGroup:actuate(0)
	end
	if kc_has_inv_ess_bus == true then
		sysElectric.inverterSwitchGroup:actuate(0)
	end
	if kc_has_bus_ties == true then
		sysElectric.dcBusTie:actuate(0)
	end
	sysElectric.batterySwitch:actuate(0) 
	sysElectric.battery2Switch:actuate(0) 	
end

-- ===========
function kc_macro_below_10000_ft()
	kc_macro_lights_descend_10k()
	sysGeneral.seatBeltSwitch:actuate(1)
end

-- 10000 feet activities up and down
function kc_macro_above_10000_ft()
	kc_macro_lights_climb_10k()
	sysGeneral.seatBeltSwitch:actuate(0)
end

function kc_macro_at_trans_alt()
	command_once("sim/instruments/barometer_std")
	command_once("sim/instruments/barometer_copilot_std")
end

function kc_macro_at_trans_lvl()
	if math.abs(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")-29.921249) < 0.01 then 
		command_once("sim/instruments/barometer_std")
	end
	if activeBriefings:get("arrival:atisQNH") ~= "" then
		if activePrefSet:get("general:baro_mode_hpa") then
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
		else
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH"))) 
		end
	end
end

-- wait for climbing through 10.000 ft then execute items
function kc_bck_climb_through_10k(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 then
		kc_speakNoText(0,"ten thousand")
		kc_macro_above_10000_ft()
		kc_procvar_set(trigger,false)
	end
end

-- wait for descending through 10.000 ft then execute items
function kc_bck_descend_through_10k(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < 10000 then
		kc_speakNoText(0,"ten thousand")
		kc_macro_below_10000_ft()
		kc_procvar_set(trigger,false)
	end
end

-- wait for climbing through trans alt then execute items
function kc_bck_transition_altitude(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > tonumber(activeBriefings:get("departure:transalt")) then
		kc_speakNoText(0,"transition altitude")
		kc_macro_at_trans_alt()
		kc_procvar_set(trigger,false)
	end
end

-- wait for descending through trans lvl then execute items
function kc_bck_transition_level(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < tonumber(activeBriefings:get("arrival:translvl")) then
		kc_speakNoText(0,"transition level")
		kc_macro_at_trans_lvl()
		kc_procvar_set(trigger,false)
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
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
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
		command_once("sim/engines/mixture_max")
		if trigger == "engstart1" then
			command_begin("sim/starters/engage_start_run_1")
		end
		if trigger == "engstart2" then
			command_begin("sim/starters/engage_start_run_2")
		end
		if trigger == "engstart3" then
			command_begin("sim/starters/engage_start_run_3")
		end
		if trigger == "engstart4" then
			command_begin("sim/starters/engage_start_run_4")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("sim/starters/engage_start_run_1")
			end
			if trigger == "engstart2" then
				command_end("sim/starters/engage_start_run_2")
			end
			if trigger == "engstart3" then
				command_end("sim/starters/engage_start_run_3")
			end
			if trigger == "engstart4" then
				command_end("sim/starters/engage_start_run_4")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("sim/cockpit2/engine/actuators/mixture_ratio_all",0)
end

-- set flaps based on index
function kc_macro_set_flap(flapindex)

	for i = 1, kc_get_nr_flapdetents() do
		command_once("sim/flight_controls/flaps_up")
	end 
	
	for i = 1, flapindex do
		command_once("sim/flight_controls/flaps_down")
	end

end

-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- off
		-- do nothing in DFLT
	elseif mode == 1 then -- ALIGN
		-- do nothing in DFLT
	elseif mode == 2 then -- NAV 
		-- do nothing in DFLT
	end
end

-- ground objects 1=on 0=off
function kc_macro_set_groundobjects(state)
	if state == 1 then
		-- nothing for DFLT
	else
		-- nothing for DFLT
	end
end

-- ======== fuel
function kc_macro_fuelpumps_off()
	if kc_has_fuel_pumps then
		sysFuel.allFuelPumpGroup:actuate(0)
	end
	if kc_has_fuel_xfeed then
		sysFuel.crossFeed:actuate(0)
	end
end

function kc_macro_fuelpumps_on()
	if kc_has_fuel_pumps then
		sysFuel.allFuelPumpGroup:actuate(1)
	end
	if kc_has_fuel_xfeed then
		sysFuel.crossFeed:actuate(0)
	end
end

function kc_macro_fuelpumps_stand()
	if kc_has_fuel_pumps then
		kc_macro_fuelpumps_off()
	end
end

function kc_macro_fuelpumps_shutdown()
	if kc_has_fuel_pumps then
		kc_macro_fuelpumps_off()
	end
end

-- === transponder
function kc_macro_set_xpdrmode(mode)
	sysRadios.xpdrSwitch:setValue(mode)
end

function kc_macro_set_xpdrcode(code)
	sysRadios.xpdrCode:setValue(code)
end

return sysMacros
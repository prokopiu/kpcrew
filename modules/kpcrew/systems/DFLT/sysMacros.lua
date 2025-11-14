-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

logMsg("DFLT sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
end

-- set the aircraft into cold and dark state
function kc_macro_state_cold_and_dark()
	logMsg("DFLT kc_macro_state_cold_and_dark")
	
	-- clear kpcrew internal timers
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	-- doors and external objects
	kc_macro_doors_ext(kc_phase_colddark)

	-- internal and external lights
	kc_macro_lights(kc_phase_colddark)

	sysGeneral.parkBrakeSwitch:actuate(1) 
	
	-- electric system settings
	kc_macro_elec_system(kc_phase_colddark)

	-- fuel system settings
	kc_macro_fuel(kc_phase_colddark)

	-- air system settings
	kc_macro_air(kc_phase_colddark)

	-- hyd system settings
	kc_macro_hyd(kc_phase_colddark)

	-- anti-ice settings
	kc_macro_aice(kc_phase_colddark)
	
	-- MCP settings
	kc_macro_mcp(kc_phase_colddark)

	kc_macro_set_xpdrmode(sysRadios.off)
	kc_macro_set_xpdrcode(2000)
	
	if kc_is_turboprop or kc_is_ga then
		sysEngines.mixtureLever:actuate(0)
	end

	if kc_has_proplever then
		sysEngines.propLever:setValue(kc_prop_lvr_feather)
	end
	
	if kc_has_irs then
		kc_macro_set_irs(0)
	end
	
	if kc_has_retractgear then
		sysGeneral.GearSwitch:actuate(1)
	end
	if kc_has_speedbrake then
		sysControls.Speedbrake:actuate(0)
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
	
	if kc_has_seatbelt_sgn then
		sysGeneral.passSignsSwitch:actuate(0)
	end
	if kc_has_nosmoke_sgn then
		sysGeneral.noSmokingSwitch:actuate(0)
	end

	if kc_has_autobrake then
		kc_macro_set_autobrake(kc_AutoBrakeOff)
	end
	
	if kc_is_airbus == false and kc_has_ignition then
		sysEngines.engIgnitionGroup:actuate(0)	
	end 
	
	if kc_has_apu then
		sysElectric.apuStartSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	end
	if kc_has_gpu then
		sysElectric.gpuGenBusGroup:actuate(0)
		sysElectric.gpuConnect:actuate(0)
	end
	
	if kc_has_windows then
		sysGeneral.windowGroup:actuate(0)
	end
	
	kc_macro_custom_cold_dark()
end

function kc_macro_state_turnaround()
	logMsg("DFLT kc_macro_state_turnaround")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	-- doors and external objects
	kc_macro_doors_ext(kc_phase_turnaround)

	sysGeneral.parkBrakeSwitch:actuate(1) 

	if kc_has_gpu then
		sysElectric.gpuConnect:actuate(1)
		sysElectric.gpuGenBusGroup:actuate(1)
	end
	
	-- electric system settings
	kc_macro_elec_system(kc_phase_turnaround)

	-- air system settings
	kc_macro_air(kc_phase_turnaround)

	-- fuel system settings
	kc_macro_fuel(kc_phase_turnaround)
	
	-- hyd system settings
	kc_macro_hyd(kc_phase_turnaround)

	-- anti-ice settings
	kc_macro_aice(kc_phase_turnaround)
	
	-- MCP settings
	kc_macro_mcp(kc_phase_turnaround)

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
		kc_macro_set_autobrake(kc_AutoBrakeOff)
	end
	
	if kc_has_apu and activeBriefings:get("departure:activateAPUPowerUp") == 1 then
		kc_procvar_set("apustart",true)
		kc_procvar_set("apuonline",true)
	end 
	
	if kc_has_irs then
		kc_macro_set_irs(2)
	end
	
	if kc_has_seatbelt_sgn then
		sysGeneral.passSignsSwitch:actuate(1)
	end
	if kc_has_nosmoke_sgn then
		sysGeneral.noSmokingSwitch:actuate(1)
	end

	kc_macro_set_local_baro()

	kc_macro_set_xpdrmode(sysRadios.stby)
	kc_macro_set_xpdrcode(2000)
	
	if kc_is_airbus == false then
		sysEngines.engIgnitionGroup:actuate(0)	
	end 

	if kc_is_turboprop or kc_is_ga then
		sysEngines.mixtureLever:actuate(0)
	end

	if kc_has_proplever then
		sysEngines.propLever:setValue(kc_prop_lvr_feather)
	end	
	
	if kc_has_windows then
		sysGeneral.windowGroup:actuate(0)
	end

	-- internal and external lights
	kc_macro_lights(kc_phase_turnaround)
	
	kc_macro_custom_turnaround()
end

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("sim/cockpit/misc/barometer_setting",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit/misc/barometer_setting2",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- ===========
function kc_macro_below_10000_ft()
	kc_macro_lights_descend_10k()
	sysGeneral.passSignsSwitch:actuate(1)
end

-- 10000 feet activities up and down
function kc_macro_above_10000_ft()
	kc_macro_lights_climb_10k()
	sysGeneral.passSignsSwitch:actuate(0)
end

function kc_macro_at_trans_alt()
	sysEFIS.barostdGroup:actuate(1)
end

function kc_macro_at_trans_lvl()
	if math.abs(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")-29.921249) < 0.01 then 
		sysEFIS.barostdGroup:actuate(0)
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

-- auxiliary function
function kc_bck_auxiliary(trigger)
	kc_procvar_set(trigger,false)
end

function kc_macro_additional_bck_procs()
end

function kc_bck_callouts(trigger)
	local flightphase = math.abs(activeBckVars:get("general:flight_state"))
	if flightphase == kc_phase_takeoff then
		logMsg("takeoff")
		if kc_callout_v1 then
			if kc_procvar_exists("v1callout") == false then
				kc_procvar_initialize_count("v1callout",1)
			end
			if kc_procvar_get("v1callout") == 1 then
				if get("sim/flightmodel/position/indicated_airspeed") >= activeBriefings:get("takeoff:v1") then	
					kc_speakNoText(0,"vee 1")
					kc_procvar_set("v1callout",0)
				end
			end
		end
		if kc_callout_vr then
			if kc_procvar_exists("vrcallout") == false then
				kc_procvar_initialize_count("vrcallout",1)
			end
			if kc_procvar_get("vrcallout") == 1 then
				if get("sim/flightmodel/position/indicated_airspeed") >= activeBriefings:get("takeoff:vr") then	
					kc_speakNoText(0,"rotate")
					kc_procvar_set("vrcallout",0)
				end
			end		end
		if kc_callout_v2 then
			if kc_procvar_exists("v2callout") == false then
				kc_procvar_initialize_count("v2callout",1)
			end
			if kc_procvar_get("v2callout") == 1 then
				if get("sim/flightmodel/position/indicated_airspeed") >= activeBriefings:get("takeoff:v2") then	
					kc_speakNoText(0,"vee 2")
					kc_procvar_set("v2callout",0)
				end
			end
		end
	end
end

return sysMacros
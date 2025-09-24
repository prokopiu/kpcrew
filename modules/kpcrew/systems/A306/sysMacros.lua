-- A306 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("A306 sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set("A300/brakes/brake_system",3)
	set("A300/GND/airstairs_state",1)
	set("A300/GND/chocks_enabled",1)
	set("A300/SMOKEDET/main1",0)
	set("A300/SMOKEDET/main2",0)
	set("A300/SMOKEDET/main_mid1",0)
	set("A300/SMOKEDET/main_mid2",0)
	set("A300/SMOKEDET/main_aft1",0)
	set("A300/SMOKEDET/main_aft2",0)
	set("A300/SMOKEDET/cargo_after1",0)
	set("A300/SMOKEDET/cargo_after2",0)
	set("A300/SMOKEDET/cargo_after_bulk1",0)
	set("A300/SMOKEDET/cargo_after_bulk2",0)
	set("A300/SMOKEDET/cargo_forward1",0)
	set("A300/SMOKEDET/cargo_forward2",0)
	set("A300/OXYGEN/low_pressure_supply",0)
	set("A300/OXYGEN/low_press_current2",0)
	sysElectric.apuMaster:actuate(0)
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set("A300/brakes/brake_system",0)
	set("A300/SMOKEDET/main1",1)
	set("A300/SMOKEDET/main2",1)
	set("A300/SMOKEDET/main_mid1",1)
	set("A300/SMOKEDET/main_mid2",1)
	set("A300/SMOKEDET/main_aft1",1)
	set("A300/SMOKEDET/main_aft2",1)
	set("A300/SMOKEDET/cargo_after1",1)
	set("A300/SMOKEDET/cargo_after2",1)
	set("A300/SMOKEDET/cargo_after_bulk1",1)
	set("A300/SMOKEDET/cargo_after_bulk2",1)
	set("A300/SMOKEDET/cargo_forward1",1)
	set("A300/SMOKEDET/cargo_forward2",1)
	set("A300/OXYGEN/low_pressure_supply",1)
	set("A300/OXYGEN/low_press_current2",1)
end

-- ====================================== Set ground objects 1=on 0=off
function kc_macro_set_groundobjects(state)
	if state == 1 then
		set("A300/GND/airstairs_state",1)
		set("A300/GND/chocks_enabled",1)
		set("A300/GND/loader_state",1)
	else
		set("A300/GND/airstairs_state",0)
		set("A300/GND/chocks_enabled",0)
		set("A300/GND/loader_state",0)
		set_array("A300/GND/cargo_boxes_show",0,0)
		set_array("A300/GND/cargo_boxes_show",0,1)
		set_array("A300/GND/cargo_boxes_show",0,2)
		set_array("A300/GND/cargo_boxes_show",0,3)
	end
end

-- ====================================== General settings like doors and external objects
function kc_macro_doors_ext(flightphase)
	-- Cold & dark
	if flightphase == kc_phase_colddark then
		if kc_is_cargo then
			sysGeneral.doorL1:actuate(1)
			sysGeneral.doorL2:actuate(0)
			sysGeneral.doorR1:actuate(0)
			sysGeneral.doorR2:actuate(0)
			sysGeneral.doorFCargo:actuate(0)
			sysGeneral.doorACargo:actuate(0)
		end
		sysGeneral.cockpitDoor:actuate(1)
		kc_macro_set_groundobjects(1)
	elseif flightphase == kc_phase_turnaround then
	-- Turnaround
		if kc_is_cargo then
			sysGeneral.doorL1:actuate(1)
			sysGeneral.doorL2:actuate(1)
			sysGeneral.doorR1:actuate(0)
			sysGeneral.doorR2:actuate(0)
			sysGeneral.doorFCargo:actuate(0)
			sysGeneral.doorACargo:actuate(0)
		end
		sysGeneral.cockpitDoor:actuate(1)
		kc_macro_set_groundobjects(1)
	elseif flightphase == kc_phase_before_start then
	-- Before start
		if kc_is_cargo then
			sysGeneral.doorL1:actuate(0)
			sysGeneral.doorL2:actuate(0)
			sysGeneral.doorR1:actuate(0)
			sysGeneral.doorR2:actuate(0)
			sysGeneral.doorFCargo:actuate(0)
			sysGeneral.doorACargo:actuate(0)
		end
		sysGeneral.cockpitDoor:actuate(0)
		kc_macro_set_groundobjects(0)
	elseif flightphase == kc_phase_shutdown then
	-- Shutdown
		if kc_is_cargo then
			sysGeneral.doorL1:actuate(1)
			sysGeneral.doorL2:actuate(1)
			sysGeneral.doorR1:actuate(0)
			sysGeneral.doorR2:actuate(0)
			sysGeneral.doorFCargo:actuate(0)
			sysGeneral.doorACargo:actuate(0)
		end
		sysGeneral.cockpitDoor:actuate(1)
		kc_macro_set_groundobjects(1)
	else
		logMsg("Invalid flightphase")
	end
end

-- ====================================== Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.batterySwitch:actuate(0) 
		sysElectric.battery2Switch:actuate(0) 
		sysElectric.battery3Switch:actuate(0) 
	elseif flightphase == kc_phase_turnaround then
		sysElectric.genSwitchGroup:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.battery3Switch:actuate(1) 
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.battery3Switch:actuate(1) 
	elseif flightphase == kc_phase_shutdown then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.battery3Switch:actuate(1) 
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
		sysHydraulic.PTU:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.PTU:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.PTU:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.PTU:actuate(0)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.PTU:actuate(0)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.PTU:actuate(0)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.PTU:actuate(1)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== anti-ice system flight phase 
function kc_macro_aice(flightphase)
	logMsg("Anti-Ice flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAice.engAntiIceGroup:actuate(0)
		sysAice.wingAiceGroup:actuate(0)
		sysAice.windowHeatGroup:actuate(0)
		sysAice.probeHeatGroup:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAice.engAntiIceGroup:actuate(0)
		sysAice.wingAiceGroup:actuate(0)
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
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
	elseif flightphase == kc_phase_descent then
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
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
	elseif flightphase == kc_phase_afterland then
		sysAice.engAntiIceGroup:actuate(0)
		sysAice.wingAiceGroup:actuate(0)
		sysAice.windowHeatGroup:actuate(0)
		sysAice.probeHeatGroup:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end

-- kc_irs_off			= 0
-- kc_irs_align			= 1
-- kc_irs_nav			= 1
-- kc_irs_att			= 2
function kc_macro_set_irs(mode)
	if mode == 0 then -- off
		sysGeneral.irsUnitGroup:setValue(kc_irs_off)
	elseif mode == 1 then -- ALIGN
		sysGeneral.irsUnitGroup:setValue(kc_irs_align)
	elseif mode == 2 then -- NAV 
		sysGeneral.irsUnitGroup:setValue(kc_irs_nav)
	end
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		set("A300/engine_ignition_switch",1)
		if trigger == "engstart1" then
			set("A300/mixture_ratio1_target",1)
			if get("A300/engine/starter1") == 0 then
				command_once("A300/starter1_toggle")
			end
			kc_speakNoText(0,"Starting Engine 1")
		end
		if trigger == "engstart2" then
			set("A300/mixture_ratio2_target",1)
			if get("A300/engine/starter2") == 0 then
				command_once("A300/starter2_toggle")
			end			
			kc_speakNoText(0,"Starting Engine 2")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				-- command_end("sim/starters/engage_start_run_1")
			end
			if trigger == "engstart2" then
				-- command_end("sim/starters/engage_start_run_2")
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

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,3)
		sysElectric.apuMaster:actuate(1)
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_once("A300/apu_start_button")
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get("A300/APU/n1") > 98 then
		sysElectric.apuGenBusGroup:setValue(1)
		sysAir.apuBleedSwitch:setValue(1)
		kc_procvar_set(trigger,false)
	end
end

return sysMacros
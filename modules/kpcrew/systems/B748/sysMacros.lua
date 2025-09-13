-- B748 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B748 sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
end

-- ====================================== Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.dcBusTie:actuate(0)
		sysElectric.acBusTie:actuate(0)
		sysElectric.batterySwitch:actuate(0) 
		sysElectric.stbyPowerSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysElectric.genSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
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
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPumpGroup:actuate(0)
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
		sysHydraulic.engHydPumpGroup:actuate(1)
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
		sysFuel.allFuelPumpGroup:actuate(1)
		sysFuel.fuelCrossFeed:actuate(0)
	elseif flightphase == kc_phase_before_start then
		sysFuel.allFuelPumpGroup:actuate(1)
		sysFuel.fuelCrossFeed:actuate(0)
	elseif flightphase == kc_phase_shutdown then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
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
	elseif flightphase == kc_phase_turnaround then
		sysAice.engAntiIceGroup:actuate(0)
		sysAice.wingAiceGroup:actuate(0)
		sysAice.windowHeatGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAice.windowHeatGroup:actuate(1)
		if activeBriefings:get("takeoff:antiice") == 1 then
			sysAice.engAntiIceGroup:actuate(0)
		else
			sysAice.engAntiIceGroup:actuate(1)
		end
		if activeBriefings:get("takeoff:antiice") == 3 then
			sysAice.wingAiceGroup:actuate(1)
		else
			sysAice.wingAiceGroup:actuate(0)
		end
	elseif flightphase == kc_phase_descent then
		sysAice.windowHeatGroup:actuate(1)
		if activeBriefings:get("approach:antiice") == 1 then
			sysAice.engAntiIceGroup:actuate(0)
		else
			sysAice.engAntiIceGroup:actuate(1)
		end
		if activeBriefings:get("approach:antiice") == 3 then
			sysAice.wingAiceGroup:actuate(1)
		else
			sysAice.wingAiceGroup:actuate(0)
		end
	elseif flightphase == kc_phase_afterland then
		sysAice.engAntiIceGroup:actuate(0)
		sysAice.wingAiceGroup:actuate(0)
		sysAice.windowHeatGroup:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end

-- button
function kc_bck_auxiliary(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,-2)
		set(activeBckVars:get("general:auxiliary1"),1)
	else
		if kc_procvar_get(delayvar) <= 0 then
			set(activeBckVars:get("general:auxiliary1"),0)
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Arm Speedbrake
function kc_macro_arm_speedbrake()
	set("SSG/CTRL/spdbrk_arm_sw",0)
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
	if get("ssg/APU/n2") > 98 then
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
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
		if trigger == "engstart1" then
			set("ssg/ENG/eng1_cutoff_sw",1)
			set("ssg/ENG/eng1_st_sw",1)
			kc_speakNoText(0,"Starting Engine 1")
		end
		if trigger == "engstart2" then
			set("ssg/ENG/eng2_cutoff_sw",1)
			set("ssg/ENG/eng2_st_sw",1)
			kc_speakNoText(0,"Starting Engine 2")
		end
		if trigger == "engstart3" then
			set("ssg/ENG/eng3_cutoff_sw",1)
			set("ssg/ENG/eng3_st_sw",1)
			kc_speakNoText(0,"Starting Engine 3")
		end
		if trigger == "engstart4" then
			set("ssg/ENG/eng4_cutoff_sw",1)
			set("ssg/ENG/eng4_st_sw",1)
			kc_speakNoText(0,"Starting Engine 4")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then

			end
			if trigger == "engstart2" then

			end
			if trigger == "engstart3" then

			end
			if trigger == "engstart4" then

			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- off
		sysGeneral.irsUnitGroup:setValue(kc_irs_off)
	elseif mode == 1 then -- ALIGN
		sysGeneral.irsUnitGroup:setValue(kc_irs_align)
	elseif mode == 2 then -- NAV 
		sysGeneral.irsUnitGroup:setValue(kc_irs_nav)
	end
end

return sysMacros
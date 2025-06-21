-- ADC3 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("ADC3 sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,0)
	set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,0)
	if get("sim/cockpit/engine/idle_speed",0) == 1 then
		command_once("sim/engines/idle_hi_lo_toggle")
	end
end

-- ====================================== Fuel system flight phase 
function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysFuel.allFuelPumpGroup:actuate(0)
		set("awx/c47/cockpit/fuel_tank_selector_left",0)
		set("awx/c47/cockpit/fuel_tank_selector_right",0)
	elseif flightphase == kc_phase_turnaround then
		sysFuel.allFuelPumpGroup:actuate(0)
		set("awx/c47/cockpit/fuel_tank_selector_left",0)
		set("awx/c47/cockpit/fuel_tank_selector_right",0)
	elseif flightphase == kc_phase_before_start then
		sysFuel.allFuelPumpGroup:actuate(0)
		set("awx/c47/cockpit/fuel_tank_selector_left",2)
		set("awx/c47/cockpit/fuel_tank_selector_right",3)	
	elseif flightphase == kc_phase_before_takeoff then
		sysFuel.allFuelPumpGroup:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysFuel.allFuelPumpGroup:actuate(0)
		set("awx/c47/cockpit/fuel_tank_selector_left",0)
		set("awx/c47/cockpit/fuel_tank_selector_right",0)
	else
		logMsg("Invalid flightphase")
	end	
end
function kc_macro_doors_ext(flightphase)
	-- Cold & dark
	if flightphase == kc_phase_colddark then
		command_once("sim/flight_controls/door_close_1")
		command_once("sim/flight_controls/door_close_2")
		command_once("sim/flight_controls/door_close_3")
		command_once("sim/flight_controls/door_open_3")
	elseif flightphase == kc_phase_turnaround then
	-- Turnaround
		command_once("sim/flight_controls/door_close_1")
		command_once("sim/flight_controls/door_close_2")
		command_once("sim/flight_controls/door_open_3")
		command_once("sim/flight_controls/door_open_2")
	elseif flightphase == kc_phase_before_start then
	-- Before start
		command_once("sim/flight_controls/door_close_1")
		command_once("sim/flight_controls/door_close_2")
		command_once("sim/flight_controls/door_close_3")
		command_once("sim/flight_controls/door_close_4")
	elseif flightphase == kc_phase_shutdown then
	-- Shutdown
		command_once("sim/flight_controls/door_close_1")
		command_once("sim/flight_controls/door_close_2")
		command_once("sim/flight_controls/door_close_3")
		command_once("sim/flight_controls/door_open_3")
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
		kc_procvar_set(delayvar,2)
		if trigger == "engstart1" then
			sysFuel.fuelPumpLeftAft:actuate(1)
			-- set_array("sim/cockpit2/engine/actuators/hardware_throttle_ratio",0,0.3)
			set_array("sim/cockpit/engine/ignition_on",0,3)
			-- set_array("sim/cockpit2/engine/actuators/primer_on",0,1)
			command_begin("sim/starters/engage_starter_1")
			-- set("awx/c47/Cockpit/mixture_lever_L",2)
		end
		if trigger == "engstart2" then
			-- set_array("sim/cockpit2/engine/actuators/hardware_throttle_ratio",1,0.3)
			sysFuel.fuelPumpRightAft:actuate(1)
			set_array("sim/cockpit/engine/ignition_on",1,3)
			-- set_array("sim/cockpit2/engine/actuators/primer_on",1,1)
			command_begin("sim/starters/engage_starter_2")
			-- set("awx/c47/Cockpit/mixture_lever_R",2)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("sim/starters/engage_starter_1")
				sysFuel.fuelPumpLeftAft:actuate(0)
				-- set_array("sim/cockpit2/engine/actuators/primer_on",0,0)
			end
			if trigger == "engstart2" then
				command_end("sim/starters/engage_starter_2")
				sysFuel.fuelPumpRightAft:actuate(0)
				-- set_array("sim/cockpit2/engine/actuators/primer_on",1,0)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set_array("sim/cockpit2/engine/actuators/hardware_throttle_ratio",0,0)
	set_array("sim/cockpit2/engine/actuators/hardware_throttle_ratio",1,0)
	sysFuel.fuelPumpLeftAft:actuate(0)
	sysFuel.fuelPumpRightAft:actuate(0)
	set_array("sim/cockpit2/engine/actuators/primer_on",0,0)
	set_array("sim/cockpit2/engine/actuators/primer_on",1,0)	
	set_array("sim/cockpit/engine/ignition_on",0,0)	
	set_array("sim/cockpit/engine/ignition_on",1,0)
	set("awx/c47/Cockpit/mixture_lever_L",0)
	set("awx/c47/Cockpit/mixture_lever_R",0)
end

return sysMacros
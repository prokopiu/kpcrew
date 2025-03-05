-- Laminar A330 variants airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("A33L sysMacros")

-- ====================================== Lights related functions

function kc_macro_lights_cold_dark()
	-- set the lights for cold & dark mode
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	
	-- internal
	sysLights.domeLightGroup:actuate(0)
	sysLights.instrLightGroup:actuate(0)
	sysLights.panelLightGroup:actuate(0)
end

function kc_macro_lights_preflight()

	-- set the lights as needed during preflight/turnaround
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	
	-- internal
	sysLights.domeLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.instrLightGroup:actuate(1)
		sysLights.panelLightGroup:actuate(0)
	else
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.panelLightGroup:actuate(1)
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	end
end

function kc_macro_lights_before_taxi()

	-- set the lights as needed during preflight/turnaround
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0.5)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	
	-- internal
	sysLights.domeLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.instrLightGroup:actuate(1)
		sysLights.panelLightGroup:actuate(0)
	else
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(1)
		sysLights.panelLightGroup:actuate(0.3)
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	end
end

function kc_macro_lights_for_takeoff()
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:setValue(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	
	-- internal
	sysLights.domeLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.instrLightGroup:actuate(1)
		sysLights.panelLightGroup:setValue(0)
	else
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.panelLightGroup:actuate(0.3)
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	end
end

function kc_macro_lights_climb_10k()
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
end

function kc_macro_lights_descend_10k()
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
end

function kc_macro_lights_approach()
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:setValue(0.5)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
end

function kc_macro_lights_cleanup()
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0.5)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	
	sysLights.domeLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.instrLightGroup:actuate(1)
		sysLights.panelLightGroup:setValue(0)
	else
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.panelLightGroup:actuate(0.3)
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	end
end 

function kc_macro_lights_after_shutdown()
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:setValue(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	
	sysLights.domeLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.instrLightGroup:actuate(1)
		sysLights.panelLightGroup:setValue(0)
	else
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(1)
		sysLights.panelLightGroup:actuate(0.3)
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	end
end

-- ========= fuel
-- fuel pumps all off
function kc_macro_fuelpumps_off()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,0)
		set_array("AirbusFBW/FuelOHPArray",9,0)
		set_array("AirbusFBW/FuelOHPArray",10,0)
		set_array("AirbusFBW/FuelOHPArray",11,0)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,0)
		set_array("AirbusFBW/FuelOHPArray",16,0)
		set_array("AirbusFBW/FuelOHPArray",17,0)
		set_array("AirbusFBW/FuelOHPArray",18,0)
		set_array("AirbusFBW/FuelOHPArray",19,0)
		set_array("AirbusFBW/FuelOHPArray",20,0)
		set_array("AirbusFBW/FuelOHPArray",21,0)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,0)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end
end

function kc_macro_fuelpumps_stand()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,0)
		set_array("AirbusFBW/FuelOHPArray",9,0)
		set_array("AirbusFBW/FuelOHPArray",10,0)
		set_array("AirbusFBW/FuelOHPArray",11,0)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,0)
		set_array("AirbusFBW/FuelOHPArray",16,0)
		set_array("AirbusFBW/FuelOHPArray",17,1)
		set_array("AirbusFBW/FuelOHPArray",18,1)
		set_array("AirbusFBW/FuelOHPArray",19,1)
		set_array("AirbusFBW/FuelOHPArray",20,1)
		set_array("AirbusFBW/FuelOHPArray",21,1)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,1)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end

end

function kc_macro_fuelpumps_shutdown()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,0)
		set_array("AirbusFBW/FuelOHPArray",9,0)
		set_array("AirbusFBW/FuelOHPArray",10,0)
		set_array("AirbusFBW/FuelOHPArray",11,0)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,0)
		set_array("AirbusFBW/FuelOHPArray",16,0)
		set_array("AirbusFBW/FuelOHPArray",17,1)
		set_array("AirbusFBW/FuelOHPArray",18,1)
		set_array("AirbusFBW/FuelOHPArray",19,1)
		set_array("AirbusFBW/FuelOHPArray",20,1)
		set_array("AirbusFBW/FuelOHPArray",21,1)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,1)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end
end

-- fuel pumps on as needed
function kc_macro_fuelpumps_on()
	set_array("AirbusFBW/FuelOHPArray",0,1)
	set_array("AirbusFBW/FuelOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",2,1)
	set_array("AirbusFBW/FuelOHPArray",3,1)
	set_array("AirbusFBW/FuelOHPArray",4,1)
	set_array("AirbusFBW/FuelOHPArray",5,1)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,1)
		set_array("AirbusFBW/FuelOHPArray",9,1)
		set_array("AirbusFBW/FuelOHPArray",10,1)
		set_array("AirbusFBW/FuelOHPArray",11,1)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,1)
		set_array("AirbusFBW/FuelOHPArray",16,1)
		set_array("AirbusFBW/FuelOHPArray",17,1)
		set_array("AirbusFBW/FuelOHPArray",18,1)
		set_array("AirbusFBW/FuelOHPArray",19,1)
		set_array("AirbusFBW/FuelOHPArray",20,1)
		set_array("AirbusFBW/FuelOHPArray",21,1)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,1)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end
end

-- ========= fuel
-- fuel pumps all off
function kc_macro_fuelpumps_off()
	sysFuel.fuelPumpLeftAft:actuate(0)
	sysFuel.fuelPumpRightAft:actuate(0)
	sysFuel.fuelPump3:actuate(0)
	sysFuel.fuelPump4:actuate(0)
	sysFuel.fuelPump5:actuate(0)
	sysFuel.fuelPump6:actuate(0)
	sysFuel.fuelPump7:actuate(0)
	sysFuel.fuelPump8:actuate(0)
	sysFuel.crossFeed:actuate(0)
end

function kc_macro_fuelpumps_stand()
	sysFuel.fuelPumpLeftAft:actuate(0)
	sysFuel.fuelPumpRightAft:actuate(0)
	sysFuel.fuelPump3:actuate(0)
	sysFuel.fuelPump4:actuate(0)
	sysFuel.fuelPump5:actuate(0)
	sysFuel.fuelPump6:actuate(0)
	sysFuel.fuelPump7:actuate(0)
	sysFuel.fuelPump8:actuate(0)
	sysFuel.crossFeed:actuate(0)
end

function kc_macro_fuelpumps_shutdown()
	sysFuel.fuelPumpLeftAft:actuate(0)
	sysFuel.fuelPumpRightAft:actuate(0)
	sysFuel.fuelPump3:actuate(0)
	sysFuel.fuelPump4:actuate(0)
	sysFuel.fuelPump5:actuate(0)
	sysFuel.fuelPump6:actuate(0)
	sysFuel.fuelPump7:actuate(0)
	sysFuel.fuelPump8:actuate(0)
	sysFuel.crossFeed:actuate(0)
end

-- fuel pumps on as needed
function kc_macro_fuelpumps_on()
	sysFuel.fuelPumpLeftAft:actuate(1)
	sysFuel.fuelPumpRightAft:actuate(1)
	sysFuel.fuelPump3:actuate(1)
	sysFuel.fuelPump4:actuate(1)
	sysFuel.fuelPump5:actuate(1)
	sysFuel.fuelPump6:actuate(1)
	sysFuel.fuelPump7:actuate(1)
	sysFuel.fuelPump8:actuate(1)
	sysFuel.crossFeed:actuate(0)
end

-- autobrake
function kc_macro_set_autobrake(index)
	if index ~= kc_AutoBrakeOff then
		if index == 1 and get("laminar/A333/annun/auto_brake/lo_on") == 0 then
			command_once("sim/flight_controls/brakes_1_auto")
		elseif index == 2 and get("laminar/A333/annun/auto_brake/med_on") == 0 then
			command_once("sim/flight_controls/brakes_2_auto")
		elseif index == 3 and get("laminar/A333/annun/auto_brake/max_on") == 0 then
			command_once("sim/flight_controls/brakes_rto_auto")
		end
	else
		if get("laminar/A333/annun/auto_brake/lo_on") > 0 then
			command_once("sim/flight_controls/brakes_1_auto")
		end
		if get("laminar/A333/annun/auto_brake/med_on") > 0 then
			command_once("sim/flight_controls/brakes_2_auto")
		end
		if get("laminar/A333/annun/auto_brake/max_on") > 0 then
			command_once("sim/flight_controls/brakes_rto_auto")
		end
	end
end

-- IRS off 0=OFF, 1=NAV, 2=ATT
function kc_macro_set_irs(mode)
	command_once("laminar/A333/knobs/adirs/ir1_knob_left")
	command_once("laminar/A333/knobs/adirs/ir1_knob_left")
	command_once("laminar/A333/knobs/adirs/ir2_knob_left")
	command_once("laminar/A333/knobs/adirs/ir2_knob_left")
	command_once("laminar/A333/knobs/adirs/ir3_knob_left")
	command_once("laminar/A333/knobs/adirs/ir3_knob_left")
	if mode == 0 then -- OFF
		-- do nothing see above
	elseif mode == 1 then -- ALIGN
		command_once("laminar/A333/knobs/adirs/ir1_knob_right")
		command_once("laminar/A333/knobs/adirs/ir2_knob_right")
		command_once("laminar/A333/knobs/adirs/ir3_knob_right")
	elseif mode == 2 then -- NAV 
		command_once("laminar/A333/knobs/adirs/ir1_knob_right")
		command_once("laminar/A333/knobs/adirs/ir2_knob_right")
		command_once("laminar/A333/knobs/adirs/ir3_knob_right")
		command_once("laminar/A333/knobs/adirs/ir1_knob_right")
		command_once("laminar/A333/knobs/adirs/ir2_knob_right")		
		command_once("laminar/A333/knobs/adirs/ir3_knob_right")
	end
end

function kc_macro_set_xpdrmode(mode)
	command_once("laminar/A333/transponder/ta_ra_left")
	command_once("laminar/A333/transponder/ta_ra_left")
	command_once("laminar/A333/transponder/ta_ra_left")
	command_once("laminar/A333/transponder/auto_on_off_left")
	command_once("laminar/A333/transponder/auto_on_off_left")
	command_once("laminar/A333/transponder/auto_on_off_right")
	if mode ~= sysRadios.stby then
		if mode == sysRadios.ta then
			command_once("laminar/A333/transponder/ta_ra_right")
		elseif mode == sysRadios.tara then
			command_once("laminar/A333/transponder/ta_ra_right")
			command_once("laminar/A333/transponder/ta_ra_right")
		end
	end
end

-- Airbus set EngineMode 0=off 1=ign/start 2=crank
function kc_macro_set_eng_mode(mode)
	if mode == 0 then
		command_once("laminar/A333/switch/eng_mode_right")
		command_once("laminar/A333/switch/eng_mode_right")
		command_once("laminar/A333/switch/eng_mode_left")
	elseif mode == 1 then
		command_once("laminar/A333/switch/eng_mode_right")
		command_once("laminar/A333/switch/eng_mode_right")
	elseif mode == 2 then
		command_once("laminar/A333/switch/eng_mode_left")
		command_once("laminar/A333/switch/eng_mode_left")
	end
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,20)
		
		if trigger == "engstart1" then
			set("laminar/A333/switches/engine1_start_pos",1)
		end
		if trigger == "engstart2" then
			set("laminar/A333/switches/engine2_start_pos",1)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

return sysMacros
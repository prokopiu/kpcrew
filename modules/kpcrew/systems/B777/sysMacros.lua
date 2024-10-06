-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

-- ====================================== States related macros
function kc_macro_state_cold_and_dark()
	logMsg("kc_macro_state_cold_and_dark")
	kc_macro_lights_cold_dark()
end

function kc_macro_state_turnaround()
	logMsg("kc_macro_state_turnaround")
	kc_macro_lights_preflight()
end

-- ====================================== Lights related functions
function kc_macro_lights_preflight()
	-- set the lights as needed during preflight/turnaround
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
	end
end

function kc_macro_lights_before_start()
	-- set the lights as needed when preparing for push and engine start
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_before_taxi()
	-- set the lights as needed when ready to taxi
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_approach()
	-- set the lights when in the approach
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_cleanup()
	-- set the lights on cleaning up after landing
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_arrive_parking()
	-- set the lights when arriving the parking position
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
	end
end

function kc_macro_lights_after_shutdown()
	-- set the lights when engines are stopped
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
	end
end

function kc_macro_lights_cold_dark()
	-- set the lights for cold & dark mode
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	-- internal
	sysLights.domeLightGroup:actuate(0)
	sysLights.instrLightGroup:actuate(0)
end

function kc_macro_lights_all_on()
	-- set the lights all on for test and checks
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.logoSwitch:actuate(1)
	sysLights.wingSwitch:actuate(1)
	sysLights.wheelSwitch:actuate(1)
	-- internal
	sysLights.domeLightGroup:actuate(1)
	sysLights.instrLightGroup:actuate(1)
end


return sysMacros


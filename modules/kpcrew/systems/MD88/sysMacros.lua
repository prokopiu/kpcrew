-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local sysMacros = {
}

-- ====================================== States related macros
function kc_macro_state_cold_and_dark()
	logMsg("kc_macro_state_cold_and_dark")
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	kc_macro_mcp_cold_dark()
end

function kc_macro_state_turnaround()
	logMsg("kc_macro_state_turnaround")
	kc_macro_lights_preflight()
	kc_macro_doors_preflight()
	kc_macro_mcp_cold_dark()
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(1)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(1)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(0)
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
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(1)
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
	sysLights.domeLightSwitch:actuate(0)
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
	sysLights.domeLightSwitch:actuate(1)
	sysLights.instrLightGroup:actuate(1)
end

-- ====================================== Door related functions
function kc_macro_doors_preflight()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_before_start()
	sysGeneral.doorL1:actuate(0)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(0)
end

function kc_macro_doors_after_shutdown()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_cold_dark()
	sysGeneral.doorL1:actuate(0)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_all_open()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(1)
	sysGeneral.doorR1:actuate(1)
	sysGeneral.doorR2:actuate(1)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_all_closed()
	sysGeneral.doorL1:actuate(0)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(1)
end

-- ====================================== A/P & Glareshield related functions

function kc_macro_mcp_cold_dark()
	sysMCP.fdirPilotSwitch:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.crs1Selector:setValue(1)
	sysMCP.crs2Selector:setValue(1)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	sysMCP.vspSelector:setValue(0)
	sysMCP.discAPSwitch:actuate(0)
	sysMCP.yawDamper:actuate(0)
	sysMCP.ap1Switch:actuate(0)
end

function kc_macro_mcp_preflight()
	sysMCP.fdirPilotSwitch:actuate(1)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.yawDamper:actuate(0)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
end

function kc_macro_mcp_takeoff()
	sysMCP.fdirPilotSwitch:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	if activeBriefings:get("takeoff:apMode") == 1 then
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	else
		sysMCP.hdgselSwitch:actuate(1)
	end
end

function kc_macro_mcp_goaround()
	sysMCP.fdirPilotSwitch:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.iasSelector:setValue(activeBriefings:get("approach:gav2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading"))
	sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude"))
	if activeBriefings:get("takeoff:apMode") == 1 then
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	else
		sysMCP.hdgselSwitch:actuate(1)
	end
	sysMCP.speedSwitch:actuate(1)
	sysMCP.yawDamper:actuate(1)
end

function kc_macro_mcp_after_landing()
	sysMCP.fdirPilotSwitch:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.hdgselSwitch:actuate(0)
	sysMCP.speedSwitch:actuate(0)
	sysMCP.ap1Switch:actuate(0)
	sysMCP.yawDamper:actuate(0)
end

return sysMacros


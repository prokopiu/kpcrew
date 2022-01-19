-- DFLT airplane (X-Plane 11 default)
-- aircraft lights specific functionality
local sysLights = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2
}

local drefBeacon = "sim/cockpit/electrical/beacon_lights_on"
local cmdBeaconOn = "sim/lights/beacon_lights_on"
local cmdBeaconOff = "sim/lights/beacon_lights_off"
local cmdBeaconToggle = "sim/lights/beacon_lights_toggle"

local drefNavigationLight = "sim/cockpit2/switches/navigation_lights_on"
local cmdNavLightsOn = "sim/lights/nav_lights_on"
local cmdNavLightsOff = "sim/lights/nav_lights_off"
local cmdNavLightsToggle = "sim/lights/nav_lights_toggle"

local drefStobeLights = "sim/cockpit2/switches/strobe_lights_on"
local cmdStrobeLightsOn = "sim/lights/strobe_lights_on"
local cmdStrobeLightsOff = "sim/lights/strobe_lights_off"
local cmdStrobeLightsToggle = "sim/lights/strobe_lights_toggle"

local drefTaxiLights = "sim/cockpit2/switches/taxi_light_on"
local cmdTaxiLightsOn = "sim/lights/taxi_lights_on"
local cmdTaxiLightsOff = "sim/lights/taxi_lights_off"
local cmdTaxiLightsToggle = "sim/lights/taxi_lights_toggle"

local drefLandingLights = "sim/cockpit2/switches/landing_lights_on"
local cmdLandingLightsOn = "sim/lights/landing_lights_on"
local cmdLandingLightsOff = "sim/lights/landing_lights_off"
local cmdLandingLightsToggle = "sim/lights/landing_lights_toggle"

local drefInstrumentLights = "sim/cockpit/electrical/instrument_brightness"

-- many lights are in the generic lights array
local drefGenericLights = "sim/cockpit2/switches/generic_lights_switch"
local function setGenericLight(index,mode)
	set_array(drefGenericLights,index,mode)
end
local function getGenericLight(index)
	return get(drefGenericLights,index)
end

-- Beacon/Anticollision light
function sysLights.setBeaconMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdBeaconOff)
	end
	if mode == sysLights.modeOn then
		command_once(cmdBeaconOn)
	end
	if mode == sysLights.modeToggle then
		command_once(cmdBeaconToggle)
	end
end

function sysLights.getBeaconMode()
	return get(drefBeacon)
end

-- Navigation Lights
function sysLights.setNavLightMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdNavLightsOff)
	end
	if mode == sysLights.modeOn then
		command_once(cmdNavLightsOn)
	end
	if mode == sysLights.modeToggle then
		command_once(cmdNavLightsToggle)
	end
end

function sysLights.getNavLightMode()
	return get(drefNavigationLight)
end

-- Strobe Lights
function sysLights.setStrobeLightMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdStrobeLightsOff)
	end
	if mode == sysLights.modeOn then
		command_once(cmdStrobeLightsOn)
	end
	if mode == sysLights.modeToggle then
		command_once(cmdStrobeLightsToggle)
	end
end

function sysLights.getStrobeLightMode()
	return get(drefStobeLights)
end

-- Taxi Lights
function sysLights.setTaxiLightMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdTaxiLightsOff)
	end
	if mode == sysLights.modeOn then
		command_once(cmdTaxiLightsOn)
	end
	if mode == sysLights.modeToggle then
		command_once(cmdTaxiLightsToggle)
	end
end

function sysLights.getTaxiLightMode()
	return get(drefTaxiLights)
end

-- Landing Lights
function sysLights.setLandingLightsMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdLandingLightsOff)
	end
	if mode == sysLights.modeOn then
		command_once(cmdLandingLightsOn)
	end
	if mode == sysLights.modeToggle then
		command_once(cmdLandingLightsToggle)
	end
end

function sysLights.getLandingLightMode()
	return get(drefLandingLights)
end

-- Logo Lights
function sysLights.setLogoLightsMode(mode)
	if mode == sysLights.modeOff then
		setGenericLight(0,0)
	end
	if mode == sysLights.modeOn then
		setGenericLight(0,1)
	end
	if mode == sysLights.modeToggle then
		if getGenericLight(0) == 0 then 
			setGenericLight(0,1)
		else
			setGenericLight(0,0)
		end
	end
end

function sysLights.getLogoLightMode()
	return getGenericLight(0)
end

-- Wing Lights
function sysLights.setWingLightsMode(mode)
	if mode == sysLights.modeOff then
		setGenericLight(3,0)
	end
	if mode == sysLights.modeOn then
		setGenericLight(3,1)
	end
	if mode == sysLights.modeToggle then
		if getGenericLight(3) == 0 then 
			setGenericLight(3,1)
		else
			setGenericLight(3,0)
		end
	end
end

function sysLights.getWingLightsMode()
	return getGenericLight(3)
end

-- RWY Turnoff Lights
function sysLights.setRwyLightsMode(mode)
	if mode == sysLights.modeOff then
		setGenericLight(1,0)
		setGenericLight(2,0)
	end
	if mode == sysLights.modeOn then
		setGenericLight(1,1)
		setGenericLight(2,1)
	end
	if mode == sysLights.modeToggle then
		if getGenericLight(1) == 0 then 
			setGenericLight(1,1)
			setGenericLight(2,1)
		else
			setGenericLight(1,0)
			setGenericLight(2,0)
		end
	end
end

function sysLights.getRwyLightsMode()
	return getGenericLight(1)
end

return sysLights
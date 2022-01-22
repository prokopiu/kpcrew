-- DFLT airplane (X-Plane 11 default)
-- aircraft lights specific functionality
local sysLights = {
	Off = 0,
	On = 1,
	Toggle = 2
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
local drefCockpitLights = "sim/cockpit/electrical/cockpit_lights"

-- many lights are in the generic lights array
-- unfortunately these datarefs vary from Laminar plane to plane
local drefGenericLights = "sim/cockpit2/switches/generic_lights_switch"
local function setGenericLight(index,mode)
	set_array(drefGenericLights,index,mode)
end
local function getGenericLight(index)
	return get(drefGenericLights,index)
end
-- allocations of generic lights (differs from aircraft to aircraft)
local GenLights = { ["Logo"] = 0, ["Wing"] = 3, ["Wheel"] = 5, ["RwyLeft"] = 1, ["RwyRight"] = 2 }

-- a cluster of instrument lights in this array
local drefInstrumentLight = "sim/cockpit2/switches/instrument_brightness_ratio"
local function setInstrumentLight(index,mode)
	set_array(drefInstrumentLight,index,mode)
end
local function getInstrumentLight(index)
	return get(drefInstrumentLight,index)
end

-- Beacon/Anticollision light
function sysLights.setBeaconMode(mode)
	if mode == sysLights.Off then
		command_once(cmdBeaconOff)
	end
	if mode == sysLights.On then
		command_once(cmdBeaconOn)
	end
	if mode == sysLights.Toggle then
		command_once(cmdBeaconToggle)
	end
end

function sysLights.getBeaconMode()
	return get(drefBeacon)
end

-- Navigation Lights
function sysLights.setNavLightMode(mode)
	if mode == sysLights.Off then
		command_once(cmdNavLightsOff)
	end
	if mode == sysLights.On then
		command_once(cmdNavLightsOn)
	end
	if mode == sysLights.Toggle then
		command_once(cmdNavLightsToggle)
	end
end

function sysLights.getNavLightMode()
	return get(drefNavigationLight)
end

-- Strobe Lights
function sysLights.setStrobeLightMode(mode)
	if mode == sysLights.Off then
		command_once(cmdStrobeLightsOff)
	end
	if mode == sysLights.On then
		command_once(cmdStrobeLightsOn)
	end
	if mode == sysLights.Toggle then
		command_once(cmdStrobeLightsToggle)
	end
end

function sysLights.getStrobeLightMode()
	return get(drefStobeLights)
end

-- Taxi Lights
function sysLights.setTaxiLightMode(mode)
	if mode == sysLights.Off then
		command_once(cmdTaxiLightsOff)
	end
	if mode == sysLights.On then
		command_once(cmdTaxiLightsOn)
	end
	if mode == sysLights.Toggle then
		command_once(cmdTaxiLightsToggle)
	end
end

function sysLights.getTaxiLightMode()
	return get(drefTaxiLights)
end

-- Landing Lights
function sysLights.setLandingLightsMode(mode)
	if mode == sysLights.Off then
		command_once(cmdLandingLightsOff)
	end
	if mode == sysLights.On then
		command_once(cmdLandingLightsOn)
	end
	if mode == sysLights.Toggle then
		command_once(cmdLandingLightsToggle)
	end
end

function sysLights.getLandingLightMode()
	return get(drefLandingLights)
end

----------- GENERIC LIGHTS might nit work the same way on all default planes -------------

-- Logo Lights
function sysLights.setLogoLightsMode(mode)
	if mode == sysLights.Off then
		setGenericLight(GenLights["Logo"],0)
	end
	if mode == sysLights.On then
		setGenericLight(GenLights["Logo"],1)
	end
	if mode == sysLights.Toggle then
		if getGenericLight(GenLights["Logo"]) == 0 then 
			setGenericLight(GenLights["Logo"],1)
		else
			setGenericLight(GenLights["Logo"],0)
		end
	end
end

function sysLights.getLogoLightMode()
	return getGenericLight(GenLights["Logo"])
end

-- Wing Lights
function sysLights.setWingLightsMode(mode)
	if mode == sysLights.Off then
		setGenericLight(GenLights["Wing"],0)
	end
	if mode == sysLights.On then
		setGenericLight(GenLights["Wing"],1)
	end
	if mode == sysLights.Toggle then
		if getGenericLight(GenLights["Wing"]) == 0 then 
			setGenericLight(GenLights["Wing"],1)
		else
			setGenericLight(GenLights["Wing"],0)
		end
	end
end

function sysLights.getWingLightsMode()
	return getGenericLight(GenLights["Wing"])
end

-- Wheel well Lights
function sysLights.setWheelLightsMode(mode)
	if mode == sysLights.Off then
		setGenericLight(GenLights["Wheel"],0)
	end
	if mode == sysLights.On then
		setGenericLight(GenLights["Wheel"],1)
	end
	if mode == sysLights.Toggle then
		if getGenericLight(GenLights["Wheel"]) == 0 then 
			setGenericLight(GenLights["Wheel"],1)
		else
			setGenericLight(GenLights["Wheel"],0)
		end
	end
end

function sysLights.getWheelLightsMode()
	return getGenericLight(GenLights["Wheel"])
end

-- RWY Turnoff Lights
function sysLights.setRwyLightsMode(mode)
	if mode == sysLights.Off then
		setGenericLight(GenLights["RwyLeft"],0)
		setGenericLight(GenLights["RwyRight"],0)
	end
	if mode == sysLights.On then
		setGenericLight(GenLights["RwyLeft"],1)
		setGenericLight(GenLights["RwyRight"],1)
	end
	if mode == sysLights.Toggle then
		if getGenericLight(GenLights["RwyLeft"]) == 0 then 
			setGenericLight(GenLights["RwyLeft"],1)
			setGenericLight(GenLights["RwyRight"],1)
		else
			setGenericLight(GenLights["RwyLeft"],0)
			setGenericLight(GenLights["RwyRight"],0)
		end
	end
end

function sysLights.getRwyLightsMode()
	return getGenericLight(GenLights["RwyLeft"])
end

-- Instrument Lights - switch them all on or off
function sysLights.setInstrumentLightsMode(mode)
	if mode == sysLights.Off then
		set(drefInstrumentLights,0)
	end
	if mode == sysLights.On then
		set(drefInstrumentLights,1)
	end
	if mode == sysLights.Toggle then
		if get(drefInstrumentLights) == 0 then 
			set(drefInstrumentLights,1)
		else
			set(drefInstrumentLights,0)
		end
	end
end

function sysLights.getInstrumentLightsMode()
	return get(drefInstrumentLights)
end

-- Cockpit Lights - switch them all on or off
function sysLights.setCockpitLightsMode(mode)
	if mode == sysLights.Off then
		set(drefCockpitLights,0)
	end
	if mode == sysLights.On then
		set(drefCockpitLights,1)
	end
	if mode == sysLights.Toggle then
		if get(drefCockpitLights) == 0 then 
			set(drefCockpitLights,1)
		else
			set(drefCockpitLights,0)
		end
	end
end

function sysLights.getCockpitLightsMode()
	return get(drefCockpitLights)
end

return sysLights
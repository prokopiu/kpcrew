-- B738 airplane (X-Plane 11 default)
-- aircraft lights specific functionality
local sysLights = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2,
	modeTaxiLow = 3,
	modeLLExtend = 3,
	modeLLRetract = 4,
	modeStrobePosOff = 0,
	modeStrobePosRed = -1,
	modeStrobePosWhite = 1
}

local drefBeacon = "sim/cockpit/electrical/beacon_lights_on"
local cmdBeaconOn = "sim/lights/beacon_lights_on"
local cmdBeaconOff = "sim/lights/beacon_lights_off"
local cmdBeaconToggle = "sim/lights/beacon_lights_toggle"

local drefNavigationLight = "sim/cockpit/electrical/nav_lights_on"
local cmdNavLightsOn = "laminar/B738/toggle_switch/position_light_down"
local cmdNavLightsOff = "laminar/B738/toggle_switch/position_light_up"

local drefStrobeLights = "sim/cockpit/electrical/strobe_lights_on"
local cmdStrobeLightsOn = "laminar/B738/toggle_switch/position_light_up"
local cmdStrobeLightsOff = "laminar/B738/toggle_switch/position_light_down"

local drefTaxiLights = "laminar/B738/toggle_switch/taxi_light_brightness_pos"
local cmdTaxiLightsUp = "laminar/B738/toggle_switch/taxi_light_brightness_pos_up"
local cmdTaxiLightsDn = "laminar/B738/toggle_switch/taxi_light_brightness_pos_dn"

local drefLandingLights = {
	["RetLeft"] = "laminar/B738/switch/land_lights_ret_left_pos",
	["RetRight"] = "laminar/B738/switch/land_lights_ret_right_pos",
	["Left"] = "laminar/B738/switch/land_lights_right_pos",
	["Right"] = "laminar/B738/switch/land_lights_right_pos"
}

local cmdLandingLightsOn = { 
	["RetLeft"] = "laminar/B738/switch/land_lights_ret_left_dn", 
	["RetRight"] = "laminar/B738/switch/land_lights_ret_right_dn", 
	["Left"] = "laminar/B738/switch/land_lights_left_on", 
	["Right"] = "laminar/B738/switch/land_lights_right_on"
}
local cmdLandingLightsOff = {
	["RetLeft"] = "laminar/B738/switch/land_lights_ret_left_up", 
	["RetRight"] = "laminar/B738/switch/land_lights_ret_right_up", 
	["Left"] = "laminar/B738/switch/land_lights_left_off", 
	["Right"] = "laminar/B738/switch/land_lights_right_off"
}

local drefInstrumentLights = "laminar/B738/electric/panel_brightness"
local function setInstrumentLight(index,mode)
	set_array(drefInstrumentLights,index,mode)
end
local function getInstrumentLight(index)
	return get(drefInstrumentLights,index)
end

local drefCockpitLights = "laminar/B738/toggle_switch/cockpit_dome_pos"
local cmdCockpitLightsUp = "laminar/B738/toggle_switch/cockpit_dome_up"
local cmdCockpitLightsDn = "laminar/B738/toggle_switch/cockpit_dome_dn"

local drefLogoLight = "laminar/B738/toggle_switch/logo_light"

local cmdRwyLightsOn = { ["Left"] = "laminar/B738/switch/rwy_light_left_on", ["Right"] = "laminar/B738/switch/rwy_light_right_on" }
local cmdRwyLightsOff = { ["Left"] = "laminar/B738/switch/rwy_light_left_off", ["Right"] = "laminar/B738/switch/rwy_light_right_off" }
local cmdRwyLightsToggle = { ["Left"] = "laminar/B738/switch/rwy_light_left_toggle", ["Right"] = "laminar/B738/switch/rwy_light_right_toggle" }

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
	if mode == sysLights.modeOff and get(drefNavigationLight) == 1 then
		command_once(cmdNavLightsOff)
	end
	if mode == sysLights.modeOn and get(drefNavigationLight) == 0 then
		command_once(cmdNavLightsOn)
	end
	if mode == sysLights.modeToggle then	
		if get(drefNavigationLight) == 1 then
			command_once(cmdNavLightsOff)
		end
		if get(drefNavigationLight) == 0 then
			command_once(cmdNavLightsOn)
		end
	end
end

function sysLights.getNavLightMode()
	return get(drefNavigationLight)
end

-- Strobe Lights
function sysLights.setStrobeLightMode(mode)
	if mode == sysLights.modeOff and get(drefStrobeLights) == 1 then
		command_once(cmdStrobeLightsOff)
	end
	if mode == sysLights.modeOn and get(drefStrobeLights) == 0 then
		command_once(cmdStrobeLightsOn)
		command_once(cmdStrobeLightsOn)
	end
	if mode == sysLights.modeToggle then	
		if get(drefStrobeLights) == 1 then
			command_once(cmdStrobeLightsOff)
		end
		if get(drefStrobeLights) == 0 then
			command_once(cmdStrobeLightsOn)
		end
	end
end

function sysLights.getStrobeLightMode()
	return get(drefStobeLights)
end

-- Taxi Lights 0=off 1=HIGH 2=TOGGLE HIGH 3=LOW
function sysLights.setTaxiLightMode(mode)
	if mode == sysLights.modeOff then	
		command_once(cmdTaxiLightsUp)
		command_once(cmdTaxiLightsUp)
	end
	if mode == sysLights.modeOn then
		command_once(cmdTaxiLightsDn)
		command_once(cmdTaxiLightsDn)
	end
	if mode == sysLights.modeToggle then
		if get(drefTaxiLights) < 2 then
			command_once(cmdTaxiLightsUp)
			command_once(cmdTaxiLightsUp)
		else
			command_once(cmdTaxiLightsDn)
			command_once(cmdTaxiLightsDn)
		end
	end
	if mode == sysLights.modeTaxiLow then
		command_once(cmdTaxiLightsUp)
		command_once(cmdTaxiLightsUp)
		command_once(cmdTaxiLightsDn)
	end
end

function sysLights.getTaxiLightMode()
	return get(drefTaxiLights)
end

-- Landing Lights
-- light: 0=ALL, 1=RETLEFT, 2=RETRIGHT, 3=LEFT, 4=RIGHT, 5=FIXED, 6=RET
-- mode: 0=OFF, 1=ON, 2=TOGGLE 3=EXTEND RETs 4=RETRACT RETs
function sysLights.isetLandingLightsMode(light,mode)
	if light == 0 or light == 3 or light == 5 then
		if mode == sysLights.modeOff then 
			command_once(cmdLandingLightsOff["Left"])
		end
		if mode == sysLights.modeOn then 
			command_once(cmdLandingLightsOn["Left"])
		end
		if mode == sysLights.modeToggle then 
			if get(drefLandingLights["Left"]) == 0 then
				command_once(cmdLandingLightsOn["Left"])
			else
				command_once(cmdLandingLightsOff["Left"])
			end
		end
	end
	if light == 0 or light == 4 or light == 5 then
		if mode == sysLights.modeOff then 
			command_once(cmdLandingLightsOff["Right"])
		end
		if mode == sysLights.modeOn then 
			command_once(cmdLandingLightsOn["Right"])
		end
		if mode == sysLights.modeToggle then 
			if get(drefLandingLights["Right"]) == 0 then
				command_once(cmdLandingLightsOn["Right"])
			else
				command_once(cmdLandingLightsOff["Right"])
			end
		end
	end
	if light == 0 or light == 1 or light == 6 then
		if mode == sysLights.modeOff then 
			command_once(cmdLandingLightsOff["RetLeft"])
			command_once(cmdLandingLightsOff["RetLeft"])
		end
		if mode == sysLights.modeOn then 
			command_once(cmdLandingLightsOn["RetLeft"])
			command_once(cmdLandingLightsOn["RetLeft"])
		end
		if mode == sysLights.modeToggle then 
			if get(drefLandingLights["RetLeft"]) == 0 then
				command_once(cmdLandingLightsOn["RetLeft"])
				command_once(cmdLandingLightsOn["RetLeft"])
			else
				command_once(cmdLandingLightsOff["RetLeft"])
				command_once(cmdLandingLightsOff["RetLeft"])
			end
		end
		if mode == sysLights.modeLLExtend then 
			command_once(cmdLandingLightsOff["RetLeft"])
			command_once(cmdLandingLightsOff["RetLeft"])
			command_once(cmdLandingLightsOn["RetLeft"])
		end
		if mode == sysLights.modeLLRetract then 
			command_once(cmdLandingLightsOff["RetLeft"])
			command_once(cmdLandingLightsOff["RetLeft"])
		end
	end
	if light == 0 or light == 2 or light == 6 then
		if mode == sysLights.modeOff then 
			command_once(cmdLandingLightsOff["RetRight"])
			command_once(cmdLandingLightsOff["RetRight"])
		end
		if mode == sysLights.modeOn then 
			command_once(cmdLandingLightsOn["RetRight"])
			command_once(cmdLandingLightsOn["RetRight"])
		end
		if mode == sysLights.modeToggle then 
			if get(drefLandingLights["RetRight"]) == 0 then
				command_once(cmdLandingLightsOn["RetRight"])
				command_once(cmdLandingLightsOn["RetRight"])
			else
				command_once(cmdLandingLightsOff["RetRight"])
				command_once(cmdLandingLightsOff["RetRight"])
			end
		end
		if mode == sysLights.modeLLExtend then 
			command_once(cmdLandingLightsOff["RetRight"])
			command_once(cmdLandingLightsOff["RetRight"])
			command_once(cmdLandingLightsOn["RetRight"])
		end
		if mode == sysLights.modeLLRetract then 
			command_once(cmdLandingLightsOff["RetRight"])
			command_once(cmdLandingLightsOff["RetRight"])
		end
	end
end

function sysLights.setLandingLightsMode(mode)
	sysLights.isetLandingLightsMode(0,mode)
end

function sysLights.getLandingLightMode()
	return get(drefLandingLights)
end

----------- GENERIC LIGHTS might nit work the same way on all default planes -------------

-- Logo Lights
function sysLights.setLogoLightsMode(mode)
	if mode == sysLights.modeOff then
		set(drefLogoLight,0)
	end
	if mode == sysLights.modeOn then
		set(drefLogoLight,1)
	end
	if mode == sysLights.modeToggle then
		if get(drefLogoLight) == 0  then 
			set(drefLogoLight,1)
		else
			set(drefLogoLight,0)
		end
	end
end

function sysLights.getLogoLightMode()
	return get(drefLogoLight)
end

-- Wing Lights
function sysLights.setWingLightsMode(mode)
	if mode == sysLights.modeOff then
		setGenericLight(GenLights["Wing"],0)
	end
	if mode == sysLights.modeOn then
		setGenericLight(GenLights["Wing"],1)
	end
	if mode == sysLights.modeToggle then
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
	if mode == sysLights.modeOff then
		setGenericLight(GenLights["Wheel"],0)
	end
	if mode == sysLights.modeOn then
		setGenericLight(GenLights["Wheel"],1)
	end
	if mode == sysLights.modeToggle then
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
-- light 0=all, 1=left, 2=right
function sysLights.isetRwyLightsMode(light, mode)
	if light == 0 or light == 1 then
		if mode == sysLights.modeOff then
			command_once(cmdRwyLightsOff["Left"])
		end
		if mode == sysLights.modeOn then
			command_once(cmdRwyLightsOn["Left"])
		end
		if mode == sysLights.modeToggle then
			command_once(cmdRwyLightsToggle["Left"])
		end
	end
	if light == 0 or light == 2 then
		if mode == sysLights.modeOff then
			command_once(cmdRwyLightsOff["Right"])
		end
		if mode == sysLights.modeOn then
			command_once(cmdRwyLightsOn["Right"])
		end
		if mode == sysLights.modeToggle then
			command_once(cmdRwyLightsToggle["Right"])
		end
	end
end

function sysLights.setRwyLightsMode(mode)
	sysLights.isetRwyLightsMode(0,mode)
end

function sysLights.getRwyLightsMode()
	return getGenericLight(GenLights["RwyLeft"])
end

-- Instrument Lights - switch them all on or off
-- light: 
function sysLights.isetInstrumentLightsMode(light, mode)
	if mode == sysLights.modeOff then
		set_array(drefInstrumentLights,light,0)
	end
	if mode == sysLights.modeOn then
		set_array(drefInstrumentLights,light,1)
	end
	if mode == sysLights.modeToggle then
		if get(drefInstrumentLights,light) == 0 then 
			set_array(drefInstrumentLights,light,1)
		else
			set_array(drefInstrumentLights,light,0)
		end
	end
end

function sysLights.setInstrumentLightsMode(mode)
	sysLights.isetInstrumentLightsMode(0,mode)
	sysLights.isetInstrumentLightsMode(1,mode)
	sysLights.isetInstrumentLightsMode(2,mode)
	sysLights.isetInstrumentLightsMode(3,mode)
end

function sysLights.getInstrumentLightsMode()
	return get(drefInstrumentLights)
end

-- Cockpit Lights - switch them all on or off
function sysLights.setCockpitLightsMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdCockpitLightsUp)
		command_once(cmdCockpitLightsUp)
		command_once(cmdCockpitLightsDn)
	end
	if mode == sysLights.modeOn then
		command_once(cmdCockpitLightsDn)
		command_once(cmdCockpitLightsDn)
	end
	if mode == sysLights.modeToggle then
		if get(drefCockpitLights) == 0 then 
			command_once(cmdCockpitLightsDn)
			command_once(cmdCockpitLightsDn)
		else
			command_once(cmdCockpitLightsUp)
			command_once(cmdCockpitLightsUp)
			command_once(cmdCockpitLightsDn)
		end
	end
end

function sysLights.getCockpitLightsMode()
	return get(drefCockpitLights)
end

return sysLights
-- DFLT airplane 
-- aircraft general systems
local sysGeneral = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2,
	modeGearUp = 0,
	modeGearDown = 1,
	modeFlapsUp = 0,
	modeFlapsDown = 1,
    GearLightGreenLeft = "greenLeft", 
	GearLightGreenRight = "greenRight", 
	GearLightGreenNose = "greenNose", 
	GearLightRedLeft = "redLeft", 
	GearLightRedRight = "redRight", 
	GearLightRedNose = "redNose"
}

local drefParkBrake = "sim/cockpit2/controls/parking_brake_ratio"

local drefGearHandle = "sim/cockpit2/controls/gear_handle_down"
local cmdGearUp = "sim/flight_controls/landing_gear_up"
local cmdGearDown = "sim/flight_controls/landing_gear_down"

local drefGearLights = { 
	[GearLightGreenLeft] = "sim/flightmodel/movingparts/gear1def", 
	[GearLightGreenRight] = "sim/flightmodel/movingparts/gear2def", 
	[GearLightGreenNose] = "sim/flightmodel/movingparts/gear3def", 
}

local drefFlapPos = "sim/flightmodel2/controls/flap_ratio"
local cmdFlapsUp = "sim/flight_controls/flaps_up"
local cmdFlapsDown = "sim/flight_controls/flaps_down"

-- Flaps
-- mode 0=up one notch, 1=down one notch
function sysGeneral.actFlapLever(mode)
	if mode == sysGeneral.modeFlapsDown then
		command_once(cmdFlapsDown)
	end
	if mode == sysGeneral.modeFlapsUp then
		command_once(cmdFlapsUp)
	end
end

function sysGeneral.getFlapsPos()
	return get(drefFlapPos)
end

-- Gears
-- mode 0=UP 1=DOWN 2=TOGGLE
function sysGeneral.setGearMode(mode)
	if mode == sysGeneral.modeGearUp then
		command_once(cmdGearUp)
	end
	if mode == sysGeneral.modeGearDown then
		command_once(cmdGearDown)
	end
	if mode == sysGeneral.modeToggle then
		if get(drefGearHandle) == 0 then
			command_once(cmdGearDown)
		else
			command_once(cmdGearUp)
		end
	end
end

function sysGeneral.getGearMode()
	return get(drefGearHandle)
end

-- light = "greenLeft", "greenRight", "greenNose", "redLeft", "redRight", "redNose"
function sysGeneral.getGearLight(light)
	if light == GearLightGreenLeft then
		if get(drefGearLights[GearLightGreenLeft]) == 1 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightGreenRight then
		if get(drefGearLights[GearLightGreenRight]) == 1 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightGreenNose then
		if get(drefGearLights[GearLightGreenNose]) == 1 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightRedLeft then
		if get(drefGearLights[GearLightGreenLeft]) < 1 and get(drefGearLights[GearLightGreenLeft]) > 0 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightRedRight then
		if get(drefGearLights[GearLightGreenRight]) < 1 and get(drefGearLights[GearLightGreenRight]) > 0 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightRedNose then
		if get(drefGearLights[GearLightGreenNose]) < 1 and get(drefGearLights[GearLightGreenNose]) > 0 then
			return 1
		else
			return 0
		end
	end
end

-- Park Brake
function sysGeneral.setParkBrakeMode(mode)
	if mode == sysGeneral.modeOff then
		set(drefParkBrake,0)
	end
	if mode == sysGeneral.modeOn then
		set(drefParkBrake,1)
	end
	if mode == sysGeneral.modeToggle then
		if get(drefParkBrake) == 0 then
			set(drefParkBrake,1) 
		else	
			set(drefParkBrake,0)
		end
	end
end

function sysGeneral.getParkBrakeMode()
	return get(drefParkBrake)
end

return sysGeneral
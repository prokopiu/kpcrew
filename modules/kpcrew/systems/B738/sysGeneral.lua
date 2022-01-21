-- B738 airplane 
-- aircraft general systems
local sysGeneral = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2,
	modeGearUp = 0,
	modeGearDown = 1,
	modeGearOff = 3,
    GearLightGreenLeft = "greenLeft", 
	GearLightGreenRight = "greenRight", 
	GearLightGreenNose = "greenNose", 
	GearLightRedLeft = "redLeft", 
	GearLightRedRight = "redRight", 
	GearLightRedNose = "redNose"
}

local drefParkBrake = "sim/cockpit2/controls/parking_brake_ratio"

local drefGearHandle = "laminar/B738/controls/gear_handle_down"
local cmdGearUp = "sim/flight_controls/landing_gear_up"
local cmdGearDown = "sim/flight_controls/landing_gear_down"
local cmdGearOff = "laminar/B738/push_button/gear_off"

local drefGearLights = { 
	[GearLightGreenLeft] = "laminar/B738/annunciator/left_gear_safe", 
	[GearLightGreenRight] = "laminar/B738/annunciator/right_gear_safe", 
	[GearLightGreenNose] = "laminar/B738/annunciator/nose_gear_safe", 
	[GearLightRedLeft] = "laminar/B738/annunciator/left_gear_transit", 
	[GearLightRedRight] = "laminar/B738/annunciator/right_gear_transit", 
	[GearLightRedNose] = "laminar/B738/annunciator/nose_gear_transit"
}

local drefFlapPos = "laminar/B738/flt_ctrls/flap_lever"
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
-- mode 0=UP 1=DOWN 2=TOGGLE 3=OFF
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
	if mode == sysGeneral.modeGearOff then
		command_once(cmdGearOff)
	end
end

function sysGeneral.getGearMode()
	return get(drefGearHandle)
end

-- light = "greenLeft", "greenRight", "greenNose", "redLeft", "redRight", "redNose"
function sysGeneral.getGearLight(light)
	return get(drefGearLights[light])
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
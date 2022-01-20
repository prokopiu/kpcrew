-- DFLT airplane 
-- aircraft general systems
local sysGeneral = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2,
	modeGearUp = 0,
	modeGearDown = 1,
	modeGearOff = 2
}

local drefParkBrake = "sim/cockpit2/controls/parking_brake_ratio"

local drefGearHandle = "laminar/B738/controls/gear_handle_down"
local cmdGearUp = "sim/flight_controls/landing_gear_up"
local cmdGearDown = "sim/flight_controls/landing_gear_down"
local cmdGearOff = "laminar/B738/push_button/gear_off"

-- Gears
-- mode 0=UP 1=DOWN 2=OFF
function sysGeneral.setGearMode(mode)
	if mode == sysGeneral.modeGearUp then
		command_once(cmdGearUp)
	end
	if mode == sysGeneral.modeGearDown then
		command_once(cmdGearDown)
	end
	if mode == sysGeneral.modeGearOff then
		command_once(cmdGearOff)
	end
end

function sysGeneral.getGearMode()
	return get(drefGearHandle)
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
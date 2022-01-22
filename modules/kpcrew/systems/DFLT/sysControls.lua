-- DFLT airplane 
-- Flight Controls functionality
local sysControls = {
	Off = 0,
	On = 1,
	Toggle = 2,
 	Up = 1,
	Down = 0,
	Left = 0,
	Right = 1,
	Center = 2
}

local drefFlapPos = "sim/flightmodel2/controls/flap_ratio"
local cmdFlapsUp = "sim/flight_controls/flaps_up"
local cmdFlapsDown = "sim/flight_controls/flaps_down"

local cmdElevTrimDown = "sim/flight_controls/pitch_trim_down"
local cmdElevTrimUp = "sim/flight_controls/pitch_trim_up"

local cmdRudderTrimLeft = "sim/flight_controls/rudder_trim_left"
local cmdRudderTrimRight = "sim/flight_controls/rudder_trim_right"
local cmdRudderTrimCenter = "sim/flight_controls/rudder_trim_center"

local cmdAileronTrimLeft = "sim/flight_controls/aileron_trim_left"
local cmdAileronTrimRight = "sim/flight_controls/aileron_trim_right"
local cmdAileronTrimCenter = "sim/flight_controls/aileron_trim_center"

-- Aileron Trim
-- mode 0=left, 1=right, 2=center
function sysControls.actAileronTrim(mode)
	if mode == sysControls.Left then 
		command_once(cmdAileronTrimLeft)
	end
	if mode == sysControls.Right then 
		command_once(cmdAileronTrimRight)
	end
	if mode == sysControls.Center then 
		command_once(cmdAileronTrimCenter)
	end
end

-- Rudder Trim
-- mode 0=left, 1=right, 2=center
function sysControls.actRudderTrim(mode)
	if mode == sysControls.Left then 
		command_once(cmdRudderTrimLeft)
	end
	if mode == sysControls.Right then 
		command_once(cmdRudderTrimRight)
	end
	if mode == sysControls.Center then 
		command_once(cmdRudderTrimCenter)
	end
end

-- Elevator Trim
-- mode 0=down 1=up
function sysControls.actElevatorTrim(mode)
	if mode == sysControls.Down then 
		command_once(cmdElevTrimDown)
	end
	if mode == sysControls.Up then 
		command_once(cmdElevTrimUp)
	end
end

-- Flaps
-- mode 0=up one notch, 1=down one notch
function sysControls.actFlapLever(mode)
	if mode == sysControls.Down then
		command_once(cmdFlapsDown)
	end
	if mode == sysControls.Up then
		command_once(cmdFlapsUp)
	end
end

function sysControls.getFlapsPos()
	return get(drefFlapPos)
end

return sysControls
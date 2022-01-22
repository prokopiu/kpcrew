-- DFLT airplane 
-- Flight Controls functionality
local sysControls = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2,
 	actFlapsUp = 0,
	actFlapsDown = 1
}

local drefFlapPos = "sim/flightmodel2/controls/flap_ratio"
local cmdFlapsUp = "sim/flight_controls/flaps_up"
local cmdFlapsDown = "sim/flight_controls/flaps_down"

-- Flaps
-- mode 0=up one notch, 1=down one notch
function sysControls.actFlapLever(mode)
	if mode == sysControls.actFlapsDown then
		command_once(cmdFlapsDown)
	end
	if mode == sysControls.actFlapsUp then
		command_once(cmdFlapsUp)
	end
end

function sysControls.getFlapsPos()
	return get(drefFlapPos)
end

return sysControls
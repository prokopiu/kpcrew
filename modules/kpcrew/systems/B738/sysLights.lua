-- B738 airplane (X-Plane 11 default)
-- aircraft lights specific functionality
local sysLights = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2
}

local drefBeacon = "sim/cockpit/electrical/beacon_lights_on"
local cmdBeaconOn = "sim/lights/beacon_lights_on"
local cmdBeaconOff = "sim/lights/beacon_lights_off"

-- Beacon/Anticollision light
function sysLights.setBeaconMode(mode)
	if mode == sysLights.modeOff then
		command_once(cmdBeaconOff)
	end
	if mode == sysLights.modeOn then
		command_once(cmdBeaconOn)
	end
	if mode == sysLights.modeToggle then
		if sysLights.getBeaconMode() == 1 then
			command_once(cmdBeaconOff)
		else
			command_once(cmdBeaconOn)
		end
	end
end

function sysLights.getBeaconMode()
	return get(drefBeacon)
end

return sysLights
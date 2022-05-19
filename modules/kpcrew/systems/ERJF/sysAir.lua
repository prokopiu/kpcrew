-- DFLT airplane 
-- Air and Pneumatics functionality

local sysAir = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"
local drefAirANC = "sim/cockpit/warnings/annunciators/bleed_air_off"

-- VACUUM annunciator
sysAir.vacuumAnc = CustomAnnunciator:new("vacuum",
function ()
	if get(drefAirANC,0) == 1 or get(drefAirANC,1) == 1 then
		return 1
	else
		return 0
	end
end)

return sysAir
-- B738 airplane 
-- Air and Pneumatics functionality

local sysAir = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"

local drefPackLeftANC = "laminar/B738/annunciator/pack_left"
local drefPackRightANC = "laminar/B738/annunciator/pack_right"

-- VACUUM annunciator
sysAir.vacuumAnc = CustomAnnunciator:new("vacuum",
function ()
	if get(drefPackLeftANC,0) == 1 or get(drefPackRightANC,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysAir
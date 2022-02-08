-- B738 airplane 
-- Anti Ice functionality

local sysAice = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"

local drefAiceWingLeft = "laminar/B738/annunciator/wing_ice_on_L"
local drefAiceWingRight = "laminar/B738/annunciator/wing_ice_on_R"
local drefAiceEng1 = "laminar/B738/annunciator/cowl_ice_on_0"
local drefAiceEng2 = "laminar/B738/annunciator/cowl_ice_on_1"

-- ANTI ICE annunciator
sysAice.antiiceAnc = CustomAnnunciator:new("antiice",
function ()
	if get(drefAiceWingLeft) > 0 or get(drefAiceWingRight) > 0 or get(drefAiceEng1) > 0 or get(drefAiceEng2) > 0 then
		return 1
	else
		return 0
	end
end)

return sysAice
-- MD82 airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysGeneral = {
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("MD82 sysGeneral")

drefSlider = "sim/cockpit2/switches/custom_slider_on"

-- Doors
sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1",drefSlider,-1)
sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2",drefSlider,3)
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1",drefSlider,6)
sysGeneral.doorR2			= InopSwitch:new("doorr2")
sysGeneral.doorFCargo 		= TwoStateDrefSwitch:new("doorfcargo",drefSlider,7)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo",drefSlider,9)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor",drefSlider,10)
sysGeneral.stairsL1 		= TwoStateDrefSwitch:new("stairs1",drefSlider,2)

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairsL1)

-- Door annunciators
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1",drefSlider,-1)
sysGeneral.stairsL1Anc 		= SimpleAnnunciator:new("stairsl1",drefSlider,2)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2",drefSlider,3)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1",drefSlider,6)
sysGeneral.doorR2Anc 		= InopSwitch:new("doorr2")
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo",drefSlider,7)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago",drefSlider,9)
sysGeneral.cockpitDoorAnc 	= SimpleAnnunciator:new("dooracockpit",drefSlider,10)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorL2Anc:getStatus() +
				sysGeneral.doorR1Anc:getStatus() +
				-- sysGeneral.doorR2Anc:getStatus() +
				sysGeneral.doorFCargoAnc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus() +
				sysGeneral.stairsL1:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

return sysGeneral
-- B46X airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

logMsg("B46X sysGeneral")

-- Doors
sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","sim/cockpit2/switches/door_open",1)
sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2","sim/cockpit2/switches/door_open",7)
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","sim/cockpit2/switches/door_open",3)
sysGeneral.doorR2			= TwoStateDrefSwitch:new("doorr2","sim/cockpit2/switches/door_open",5)
sysGeneral.doorFCargo 		= TwoStateDrefSwitch:new("doorfcargo","sim/cockpit2/switches/door_open",6)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","sim/cockpit2/switches/door_open",8)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","thranda/cockpit/animations/doormanip",9)
sysGeneral.stairsL1 		= TwoStateDrefSwitch:new("stairs1","thranda/cockpit/animations/doormanip",2)

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
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1","sim/cockpit2/switches/door_open",1)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2","sim/cockpit2/switches/door_open",7)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1","sim/cockpit2/switches/door_open",3)
sysGeneral.doorR2Anc 		= SimpleAnnunciator:new("doorr2","sim/cockpit2/switches/door_open",5)
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo","sim/cockpit2/switches/door_open",6)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago","sim/cockpit2/switches/door_open",8)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorL2Anc:getStatus() +
				sysGeneral.doorR1Anc:getStatus() +
				sysGeneral.doorR2Anc:getStatus() +
				sysGeneral.doorFCargoAnc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

-- Wiper Switches
sysGeneral.wiperLeft 		= TwoStateDrefSwitch:new("wiperleft","thranda/actuators/wiperActL",0)
sysGeneral.wiperRight 		= TwoStateDrefSwitch:new("wiperright","thranda/actuators/wiperActR",0)
sysGeneral.wiperGroup 		= SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("strobes","sim/cockpit/switches/no_smoking",0)

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts","sim/cockpit2/switches/fasten_seat_belts",0)

-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution","thranda/sound/MasterCaution",0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning","thranda/sound/MasterWarning",0)

return sysGeneral
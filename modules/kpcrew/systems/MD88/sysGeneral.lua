-- MD88 Rotate airplane 
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

logMsg("MD88 sysGeneral")

-- Doors
sysGeneral.doorL1			= TwoStateCmdSwitch:new("doorl1","Rotate/md80/doors/main_cabin_door_ratio",0,
	"Rotate/md80/doors/main_cabin_door_open","Rotate/md80/doors/main_cabin_door_close","nocommand")
sysGeneral.doorL2			= TwoStateCmdSwitch:new("doorl2","Rotate/md80/doors/back_cabin_door_ratio",0,
	"Rotate/md80/doors/back_cabin_door_open","Rotate/md80/doors/cockpit_door_close","nocommand")
sysGeneral.doorR1			= InopSwitch:new("doorr1")
sysGeneral.doorR2			= InopSwitch:new("doorr2")
sysGeneral.doorFCargo 		= TwoStateCmdSwitch:new("doorfcargo","Rotate/md80/doors/load_door_ratio",0,
	"Rotate/md80/doors/load_door_open","Rotate/md80/doors/load_door_close","nocommand")
sysGeneral.doorACargo 		= InopSwitch:new("dooracargo")
sysGeneral.cockpitDoor 		= TwoStateCmdSwitch:new("cockpitdoor","Rotate/md80/doors/cockpit_door_ratio",0,
	"Rotate/md80/doors/cockpit_door_open","Rotate/md80/doors/cockpit_door_close","nocommand")
sysGeneral.stairsL1 		= TwoStateCmdSwitch:new("stairs1","Rotate/md80/doors/main_stair_ratio",0,
	"Rotate/md80/doors/main_stair_open","Rotate/md80/doors/main_stair_close","nocommand")
	InopSwitch:new("stairs1")

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
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1","Rotate/md80/doors/main_cabin_door_ratio",0)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2","Rotate/md80/doors/back_cabin_door_ratio",0)
sysGeneral.doorR1Anc 		= InopSwitch:new("doorr1")
sysGeneral.doorR2Anc 		= InopSwitch:new("doorr2")
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo","Rotate/md80/doors/load_door_ratio",0)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago","Rotate/md80/doors/load_door_ratio",0)

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

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1","Rotate/md80/instruments/irs_mode_switch",0)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2","Rotate/md80/instruments/irs2_mode_switch",0)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)

sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("nosmoke","Rotate/md80/systems/no_smoking_switch",0)

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts","Rotate/md80/systems/seatbelts_switch",0)

return sysGeneral
-- A306 airplane 
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

logMsg("A306 sysGeneral")

-- Optional Gound objects
sysGeneral.groundObjects = InopSwitch:new("ground objects")

-- Doors
sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","A300/GND/doors_target",1)
sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2","A300/GND/doors_target",2) --main cargo
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","A300/GND/doors_target",3)
sysGeneral.doorR2			= InopSwitch:new("doorr2")
sysGeneral.doorFCargo 		= TwoStateDrefSwitch:new("doorfcargo","A300/GND/doors_target",4)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","A300/GND/doors_target",5)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/door_open_ratio",5)
sysGeneral.stairsL1 		= InopSwitch:new("stairs1")

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
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1","A300/GND/doors_target",1)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2","A300/GND/doors_target",2)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1","A300/GND/doors_target",3)
sysGeneral.doorR2Anc 		= InopSwitch:new("doorr2")
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo","A300/GND/doors_target",4)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago","A300/GND/doors_target",5)

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
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1","A300/IRS/irs1_state",0)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2","A300/IRS/irs2_state",0)
sysGeneral.irsUnit3Switch 	= TwoStateDrefSwitch:new("irsunit3","A300/IRS/irs3_state",0)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

sysGeneral.noSmokingSwitch	= TwoStateCmdSwitch:new("nosmoke","A300/no_smoking_on",0,
		"A300/no_smoking_up","A300/no_smoking_down","nocommand")

-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "A300/master_caution",0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "A300/master_warning",0)

-- T/O Config check
sysGeneral.tocheck		 = TwoStateDrefSwitch:new("tockeck","A300/takeoff_test_activate",0)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","A300/wiper_left_speed",0)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperright","A300/wiper_right_speed",0)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

return sysGeneral
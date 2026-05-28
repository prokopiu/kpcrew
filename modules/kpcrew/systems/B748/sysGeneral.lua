-- B748 airplane 
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

local drefSlider 			= "sim/cockpit2/switches/custom_slider_on"

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("B748 sysGeneral")

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1",drefSlider,-1,
	function () 
		if get(drefSlider,0) == 0 then
		   command_once("sim/operation/slider_01")
		end
	end,
	function () 
		if get(drefSlider,0) ~= 0 then
		   command_once("sim/operation/slider_01")
		end
	end,
	function () 
		command_once("sim/operation/slider_01")
	end,
	function () 
		if get(drefSlider,0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
-- main cargo door for cargo variant
sysGeneral.doorL2			= TwoStateCustomSwitch:new("doorl2",drefSlider,15,
	function () 
		if get(drefSlider,15) == 0 then
		   command_once("sim/operation/slider_16")
		end
	end,
	function () 
		if get(drefSlider,15) ~= 0 then
		   command_once("sim/operation/slider_16")
		end
	end,
	function () 
		command_once("sim/operation/slider_16")
	end,
	function () 
		if get(drefSlider,15) ~= 0 then
			return 1
		else
			return 0
		end
	end)
-- Front cargo door
sysGeneral.doorR1			= TwoStateCustomSwitch:new("doorr1",drefSlider,16,
	function () 
		if get(drefSlider,16) == 0 then
		   command_once("sim/operation/slider_17")
		end
	end,
	function () 
		if get(drefSlider,16) ~= 0 then
		   command_once("sim/operation/slider_17")
		end
	end,
	function () 
		command_once("sim/operation/slider_17")
	end,
	function () 
		if get(drefSlider,16) ~= 0 then
			return 1
		else
			return 0
		end
	end)
-- cargo tail stand
sysGeneral.doorR2			= TwoStateCustomSwitch:new("doorr2",drefSlider,20,
	function () 
		if get(drefSlider,20) == 0 then
		   command_once("sim/operation/slider_21")
		end
	end,
	function () 
		if get(drefSlider,20) ~= 0 then
		   command_once("sim/operation/slider_21")
		end
	end,
	function () 
		command_once("sim/operation/slider_21")
	end,
	function () 
		if get(drefSlider,20) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo",drefSlider,12,
	function () 
		if get(drefSlider,12) == 0 then
		   command_once("sim/operation/slider_13")
		end
	end,
	function () 
		if get(drefSlider,12) ~= 0 then
		   command_once("sim/operation/slider_13")
		end
	end,
	function () 
		command_once("sim/operation/slider_13")
	end,
	function () 
		if get(drefSlider,12) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo",drefSlider,13,
	function () 
		if get(drefSlider,13) == 0 then
		   command_once("sim/operation/slider_14")
		end
	end,
	function () 
		if get(drefSlider,13) ~= 0 then
		   command_once("sim/operation/slider_14")
		end
	end,
	function () 
		command_once("sim/operation/slider_14")
	end,
	function () 
		if get(drefSlider,13) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.cockpitDoor 		= InopSwitch:new("cockpitdoor")
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
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1",drefSlider,-1)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2",drefSlider,15)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1",drefSlider,16)
sysGeneral.doorR2Anc 		= SimpleAnnunciator:new("doorr2",drefSlider,20)
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo",drefSlider,12)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago",drefSlider,13)

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

sysGeneral.noSmokingSwitch	= InopSwitch:new("nosmoke")

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts","ssg/PASS/passenger_signal_sw",0)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1","ssg/Nav/align1_sw",0)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2","ssg/Nav/align2_sw",0)
sysGeneral.irsUnit3Switch 	= TwoStateDrefSwitch:new("irsunit3","ssg/Nav/align3_sw",0)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

return sysGeneral
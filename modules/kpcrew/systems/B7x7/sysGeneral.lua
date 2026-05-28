-- B7x7 FF B757 & B767 airplane 
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

logMsg("B7x7 sysGeneral")


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
sysGeneral.doorL2			= TwoStateCustomSwitch:new("doorl2",drefSlider,2,
	function () 
		if get(drefSlider,2) == 0 then
		   command_once("sim/operation/slider_03")
		end
	end,
	function () 
		if get(drefSlider,2) ~= 0 then
		   command_once("sim/operation/slider_03")
		end
	end,
	function () 
		command_once("sim/operation/slider_03")
	end,
	function () 
		if get(drefSlider,2) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR1			= InopSwitch:new("doorr1")
sysGeneral.doorR2			= InopSwitch:new("doorr2")
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo",drefSlider,6,
	function () 
		if get(drefSlider,6) == 0 then
		   command_once("sim/operation/slider_07")
		end
	end,
	function () 
		if get(drefSlider,6) ~= 0 then
		   command_once("sim/operation/slider_07")
		end
	end,
	function () 
		command_once("sim/operation/slider_07")
	end,
	function () 
		if get(drefSlider,6) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo",drefSlider,5,
	function () 
		if get(drefSlider,5) == 0 then
		   command_once("sim/operation/slider_06")
		end
	end,
	function () 
		if get(drefSlider,5) ~= 0 then
		   command_once("sim/operation/slider_06")
		end
	end,
	function () 
		command_once("sim/operation/slider_06")
	end,
	function () 
		if get(drefSlider,5) ~= 0 then
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
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1",drefSlider,0)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2",drefSlider,2)
sysGeneral.doorR1Anc 		= InopSwitch:new("doorr1")
sysGeneral.doorR2Anc 		= InopSwitch:new("doorr2")
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo",drefSlider,5)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago",drefSlider,6)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorL2Anc:getStatus() +
				-- sysGeneral.doorR1Anc:getStatus() +
				-- sysGeneral.doorR2Anc:getStatus() +
				sysGeneral.doorFCargoAnc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateCustomSwitch:new("irsunit1","1-sim/irs/1/modeSel",0,null,null,null,
	function () return get("anim/rhotery/3") end,null,
	function (value)
		set("anim/rhotery/3/anim",value)
		set("anim/rhotery/3",value)
	end)
sysGeneral.irsUnit2Switch 	= TwoStateCustomSwitch:new("irsunit2","1-sim/irs/2/modeSel",0,null,null,null,
	function () return get("anim/rhotery/4") end,null,
	function (value)
		set("anim/rhotery/4/anim",value)
		set("anim/rhotery/4",value)
	end)
sysGeneral.irsUnit3Switch 	= TwoStateCustomSwitch:new("irsunit3","1-sim/irs/3/modeSel",0,null,null,null,
	function () return get("anim/rhotery/5") end,null,
	function (value)
		set("anim/rhotery/5/anim",value)
		set("anim/rhotery/5",value)
	end)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

sysGeneral.noSmokingSwitch	= TwoStateCustomSwitch:new("nosmoke","sim/cockpit2/switches/no_smoking",0,
	function ()
		local ndmod = get("sim/cockpit2/switches/no_smoking")
		if ndmod < 2 then
			set("sim/cockpit2/switches/no_smoking",ndmod+1)
			set("anim/rhotery/11",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("sim/cockpit2/switches/no_smoking")
		if ndmod > 0 then
			set("sim/cockpit2/switches/no_smoking",ndmod-1)
			set("anim/rhotery/11",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		return get("sim/cockpit2/switches/no_smoking")
	end,null,
	function (value)
		set("sim/cockpit2/switches/no_smoking",value)
		set("anim/rhotery/11",value)
	end)

sysGeneral.passSignsSwitch	= TwoStateCustomSwitch:new("seatbelts","sim/cockpit2/switches/fasten_seat_belts",0,
	function ()
		local ndmod = get("sim/cockpit2/switches/fasten_seat_belts")
		if ndmod < 2 then
			set("sim/cockpit2/switches/fasten_seat_belts",ndmod+1)
			set("anim/rhotery/12",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("sim/cockpit2/switches/fasten_seat_belts")
		if ndmod > 0 then
			set("sim/cockpit2/switches/fasten_seat_belts",ndmod-1)
			set("anim/rhotery/12",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		return get("sim/cockpit2/switches/fasten_seat_belts")
	end,null,
	function (value)
		set("sim/cockpit2/switches/fasten_seat_belts",value)
		set("anim/rhotery/12",value)
	end)

return sysGeneral
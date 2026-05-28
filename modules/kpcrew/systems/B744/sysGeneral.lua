-- B744 MSPARKS airplane 
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

local drefSlider 			= "sim/cockpit2/switches/custom_slider_on"

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("B744 sysGeneral")

-- Parking Brake
sysGeneral.parkBrakeSwitch = TwoStateDrefSwitch:new("parkbrake","laminar/B747/flt_ctrls/parking_brake_ratio",0)

-- Doors
sysGeneral.doorL1 = TwoStateDrefSwitch:new("doorl1","sim/cockpit2/switches/door_open",1)


sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)

sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/door_open",0)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateCustomSwitch:new("irsunit1","laminar/B747/pfd/capt/irs",0,
	function ()
	end,
	function ()
	end,
	function ()
	end,
	function ()
		return 2
	end)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateCustomSwitch:new("wiperleft","laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_pos",0,
	function ()
		command_once("laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_up")
	end,
	function ()
		command_once("laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_dn")
		command_once("laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/antiice/wndshlsd_wiper_L/sel_dial_pos") > 0 then
			return 1
		else 
			return 0
		end
	end)

sysGeneral.wiperRight = MultiStateCmdSwitch:new("wiperright","laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_pos",0,
	function ()
		command_once("laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_up")
	end,
	function ()
		command_once("laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_dn")
		command_once("laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/antiice/wndshlsd_wiper_R/sel_dial_pos") > 0 then
			return 1
		else 
			return 0
		end
	end)

sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

sysGeneral.noSmokingSwitch	= TwoStateCustomSwitch:new("nosmoke","sim/cockpit2/switches/no_smoking",0,
	function ()
		command_once("laminar/B747/safety/no_smoking/sel_dial_dn")
		command_once("laminar/B747/safety/no_smoking/sel_dial_dn")
		command_once("laminar/B747/safety/no_smoking/sel_dial_up")
	end,
	function ()
		command_once("laminar/B747/safety/no_smoking/sel_dial_dn")
		command_once("laminar/B747/safety/no_smoking/sel_dial_dn")
	end,
	function ()
	end)
	
sysGeneral.passSignsSwitch	= TwoStateCustomSwitch:new("seatbelts","sim/cockpit/switches/fasten_seat_belts",0,
	function ()
		command_once("laminar/B747/safety/seat_belts/sel_dial_dn")
		command_once("laminar/B747/safety/seat_belts/sel_dial_dn")
		command_once("laminar/B747/safety/seat_belts/sel_dial_up")
	end,
	function ()
		command_once("laminar/B747/safety/seat_belts/sel_dial_dn")
		command_once("laminar/B747/safety/seat_belts/sel_dial_dn")
	end,
	function ()
	end)

return sysGeneral
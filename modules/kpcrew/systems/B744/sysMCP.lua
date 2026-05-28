-- B744 MSPARKS airplane 
-- MCP functionality

-- @classmod sysMCP
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

sysMCP = require("kpcrew.systems.DFLT.sysMCP")

logMsg("B744 sysMCP")

-- Flight Directors
sysMCP.fdirPilotSwitch 		= TwoStateCustomSwitch:new("fdir left","laminar/B747/autopilot/AFDS/status_annun_pilot",0,
	function ()
		if get("laminar/B747/autopilot/AFDS/status_annun_pilot") == 0 then
			command_once("laminar/B747/toggle_switch/flight_dir_L")
		end
	end,
	function ()
		if get("laminar/B747/autopilot/AFDS/status_annun_pilot") ~= 0 then
			command_once("laminar/B747/toggle_switch/flight_dir_L")
		end
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/autopilot/AFDS/status_annun_pilot") == 0 then
			return 0
		else
			return 1
		end
	end)
	
sysMCP.fdirCoPilotSwitch 	= TwoStateCustomSwitch:new("fdir right","laminar/B747/autopilot/AFDS/status_annun_copilot",0,
	function ()
		if get("laminar/B747/autopilot/AFDS/status_annun_copilot") == 0 then
			command_once("laminar/B747/toggle_switch/flight_dir_R")
		end
	end,
	function ()
		if get("laminar/B747/autopilot/AFDS/status_annun_copilot") ~= 0 then
			command_once("laminar/B747/toggle_switch/flight_dir_R")
		end
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/autopilot/AFDS/status_annun_copilot") == 0 then
			return 0
		else
			return 1
		end
	end)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","laminar/B747/autopilot/AFDS/mode_box_status_pilot",0)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","laminar/B747/autopilot/ias_dial_value",0,
	"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up",100,340,false)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","laminar/B747/autopilot/heading/altitude_dial_ft",0,
	"sim/autopilot/altitude_down","sim/autopilot/altitude_up",0,50000,false)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","laminar/B747/autopilot/heading/degrees",0,
	"sim/autopilot/heading_down","sim/autopilot/heading_up",0,359,false)
	
-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav","laminar/B747/autopilot/vnav_state",0,
	"laminar/B747/autopilot/button_switch/VNAV")

-- LNAV mode
sysMCP.lnavSwitch 			= TwoStateCustomSwitch:new("lnav","laminar/B747/autopilot/FMA/armed_roll_mode",0,
	"laminar/B747/autopilot/button_switch/LNAV")

-- ATHR
sysMCP.athrSwitch = TwoStateToggleSwitch:new("athr","laminar/B747/autothrottle/armed",0,
	"laminar/B747/toggle_switch/autothrottle")

-- N1 Boeing
sysMCP.n1Switch = TwoStateToggleSwitch:new("n1","laminar/B747/autothrottle/armed",0,
	"laminar/B747/autopilot/button_switch/thrust_mode")

-- Flight Directors annunciator
sysMCP.fdirAnc = SimpleAnnunciator:new("fdiranc","laminar/B747/button_switch/position",82)

-- YAW DAMPER
sysMCP.yawDamper			= SwitchGroup:new("fdirs")
sysMCP.yawDamper1			= TwoStateCustomSwitch:new("yawdamper1","",0,
	function ()
		if get("laminar/B747/button_switch/position",82) == 0 then
			command_once("laminar/B747/button_switch/yaw_damper_upr")
		end
	end,
	function ()
		if get("laminar/B747/button_switch/position",82) ~= 0 then
			command_once("laminar/B747/button_switch/yaw_damper_upr")
		end
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/button_switch/position",82) == 0 then
			return 0
		else
			return 1
		end
	end)
sysMCP.yawDamper2			= TwoStateCustomSwitch:new("yawdamper2","laminar/B747/button_switch/position",83,
	function ()
		if get("laminar/B747/button_switch/position",83) == 0 then
			command_once("laminar/B747/button_switch/yaw_damper_lwr")
		end
	end,
	function ()
		if get("laminar/B747/button_switch/position",83) ~= 0 then
			command_once("laminar/B747/button_switch/yaw_damper_lwr")
		end
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/button_switch/position",83) == 0 then
			return 0
		else
			return 1
		end
	end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper1)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper2)
	
return sysMCP

-- SPEED
-- sysMCP.speedSwitch = TwoStateToggleSwitch:new("speed",drefSPDLight,0,"laminar/B747/autopilot/button_switch/speed_mode")

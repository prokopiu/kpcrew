-- B46X airplane 
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

logMsg("B46X sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","thranda/autopilot/FD_Show_Pilot",0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","thranda/autopilot/FD_Show_CoPilot",0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","thranda/autopilot/FD_Show_Pilot",0)

-- **APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach","sim/cockpit2/autopilot/approach_status",0,
	"sim/autopilot/glide_slope")
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc","sim/cockpit2/autopilot/approach_status",0)

-- **SPEED Mode
sysMCP.speedSwitch 			= TwoStateCustomSwitch:new("speed","sim/cockpit2/autopilot/altitude_mode",0,
	function ()
		if get("sim/cockpit2/autopilot/altitude_mode") ~= 5 then
			command_once("sim/autopilot/speed_hold")
		end
	end,
	function ()
		if get("sim/cockpit2/autopilot/altitude_mode") == 5 then
			command_once("sim/autopilot/speed_hold")
		end
	end,
	function ()
		command_once("sim/autopilot/speed_hold")
	end,
	function ()
		if get("sim/cockpit2/autopilot/altitude_mode") == 5 then
			return 1
		else
			return 0
		end
	end)
sysMCP.spdAnc 				= SimpleAnnunciator:new("spdanc","sim/cockpit2/autopilot/autothrottle_enabled",0)

-- === Selectors

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","thranda/anim/ASIbug4_pilot",0,
	"thranda/knob/RheostatDn104","thranda/knob/RheostatUp104",100,340,false)

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","sim/cockpit2/autopilot/vvi_dial_fpm",0,
	"sim/autopilot/nose_down_pitch_mode","sim/autopilot/nose_up_pitch_mode",-7900,7900,true)

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/servos_off_any")
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/servos_off_any")

-- YAW Damper
sysMCP.yawDamper	= TwoStateCustomSwitch:new("yawdamper","thranda/autopilot/YawDamperSwitch",0,
	function ()
		set("thranda/autopilot/YawDamperSwitch",1)
		set("thranda/autopilot/YawDamperSwitch2",1)
	end,
	function ()
		set("thranda/autopilot/YawDamperSwitch",0)
		set("thranda/autopilot/YawDamperSwitch2",0)
	end,
	function ()
		if get("thranda/autopilot/YawDamperSwitch") == 0 then
			set("thranda/autopilot/YawDamperSwitch",1)
			set("thranda/autopilot/YawDamperSwitch2",1)
		else
			set("thranda/autopilot/YawDamperSwitch",0)
			set("thranda/autopilot/YawDamperSwitch2",0)
		end
	end,
	function ()
		return get("thranda/autopilot/YawDamperSwitch") == 0
	end)
-- YAW DAMPER
sysMCP.yawDamper			= TwoStateCustomSwitch:new("yawdamper","thranda/autopilot/YawDamperSwitch",0,
	function ()
		set("thranda/autopilot/YawDamperSwitch",1)
		set("thranda/autopilot/YawDamperSwitch2",1)
	end,
	function ()
		set("thranda/autopilot/YawDamperSwitch",0)
		set("thranda/autopilot/YawDamperSwitch2",0)
	end,
	function ()
		if get("thranda/autopilot/YawDamperSwitch") == 0 then
			set("thranda/autopilot/YawDamperSwitch",1)
			set("thranda/autopilot/YawDamperSwitch2",1)
		else
			set("thranda/autopilot/YawDamperSwitch",0)
			set("thranda/autopilot/YawDamperSwitch2",0)
		end
	end,
	function ()
		return get("thranda/autopilot/YawDamperSwitch")
	end)


return sysMCP
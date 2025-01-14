-- Rotate MD88 airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

-- Flight Directors
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","Rotate/md80/autopilot/fd_toggle",0)
sysMCP.fdirCoPilotSwitch 	= InopSwitch:new("fdir right")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

-- ATHR
sysMCP.athrSwitch 			= TwoStateDrefSwitch:new("athr","Rotate/md80/autopilot/at_switch",0)

-- CRS 1&2
sysMCP.crs1Selector 		= TwoStateDrefSwitch:new("crs1","Rotate/md80/autopilot/nav1_crs",0)
sysMCP.crs2Selector 		= TwoStateDrefSwitch:new("crs2","Rotate/md80/autopilot/nav2_crs",0)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","sim/cockpit/autopilot/airspeed",0,
	"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up",100,340,false)

-- HDG
sysMCP.hdgSelector 			= TwoStateDrefSwitch:new("hdg","Rotate/md80/autopilot/hdg_sel_deg_pilot",0)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","Rotate/md80/autopilot/alt_sel_ft",0)

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","sim/cockpit2/autopilot/vvi_dial_fpm",0,
	"sim/autopilot/vertical_speed_down","sim/autopilot/vertical_speed_up",-7900,7900,true)
	
-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/disconnect")
	
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/disconnect")

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateDrefSwitch:new("yawdamper","Rotate/md80/systems/yaw_damper_switch",0)

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateDrefSwitch:new("autopilot1","Rotate/md80/autopilot/ap_toggle",0)

return sysMCP



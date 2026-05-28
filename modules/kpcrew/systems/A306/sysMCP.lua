-- A306 airplane 
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

logMsg("A306 sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","A300/MCDU/fdir1_on",0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","A300/MCDU/fdir2_on",0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","A300/MCDU/fdir1_on",0)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","A300/MCDU/altitude_dial",0,
	"A300/MCDU/altitude_down","A300/MCDU/altitude_up",0,50000,false)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt","A300/MCDU/altitude_dial",0)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","A300/MCDU/heading_dial",0,
	"A300/MCDU/heading_down","A300/MCDU/heading_up",0,359,false)

-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1","A300/FMS/vor1_course",0,
	"A300/radios/VOR1/course/dial_down","A300/radios/VOR1/course/dial_up",0,359,false)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2","A300/FMS/vor2_course",0,
	"A300/radios/VOR2/course/dial_down","A300/radios/VOR2/course/dial_up",0,359,false)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","A300/MCDU/airspeed_dial",0,
	"A300/MCDU/airspeed_down","A300/MCDU/airspeed_up",100,340,false)

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","A300/MCDU/vvi_dial",0,
	"A300/MCDU/vvi_down","A300/MCDU/vvi_up",-7900,7900,true)

-- YAW DAMPER
sysMCP.yawDamper			= SwitchGroup:new("yaw dampers")
sysMCP.yawDamper1			= TwoStateToggleSwitch:new("yawdamper1","A300/fctl/yaw_damper1",0,
	"A300/fctl/yaw_damper1_toggle")
sysMCP.yawDamper2			= TwoStateToggleSwitch:new("yawdamper2","A300/fctl/yaw_damper2",0,
	"A300/fctl/yaw_damper2_toggle")
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper1)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper2)
	
sysMCP.apDiscYoke 			= TwoStateCmdSwitch:new("discapyoke","A300/MCDU/ap1_on",0,
	"A300/MCDU/yoke_ap_disconnect_captain","A300/MCDU/yoke_ap_disconnect_captain","A300/MCDU/yoke_ap_disconnect_captain")

sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr","A300/MCDU/autothrottle_on",0,
	"A300/MCDU/autothrottle_toggle")
	
return sysMCP
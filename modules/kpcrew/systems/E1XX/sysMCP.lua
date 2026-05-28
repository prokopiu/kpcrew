-- E1XX airplane 
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

logMsg("E1XX sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdir left","sim/cockpit2/autopilot/flight_director_mode",0,
	"XCrafts/ERJ/fdir_toggle")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","sim/cockpit2/autopilot/flight_director_mode",0)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","XCrafts/ERJ/autopilot/altitude",0,
	nil,nil,0,50000,false,100)

-- **ATHR
-- -1=hard off, not even armed. 0=servos declutched (arm, hold), 1=airspeed hold, 2=N1 target hold, 3=retard, 4=reserved for future use
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr","XCrafts/ERJ/autothrottle_armed",0,
	"XCrafts/ERJ/AutoThrottle")
sysMCP.athrAnc				= SimpleAnnunciator:new("athr","XCrafts/ERJ/autothrottle_armed",0)

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav","XCrafts/ERJ/VNAV_armed",0,
	"XCrafts/ERJ/VNAV")
	
return sysMCP
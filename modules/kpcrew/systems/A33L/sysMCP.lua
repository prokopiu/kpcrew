-- Laminar A330 variants airplane 
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

logMsg("A33L sysMCP")

-- Flight Directors (DFLT only one supported)
sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdir left","laminar/A333/annun/capt_flight_director_on",0,
	"sim/autopilot/fdir_command_bars_toggle")
sysMCP.fdirCoPilotSwitch 	= TwoStateToggleSwitch:new("fdir right","laminar/A333/annun/fo_flight_director_on",0,
	"sim/autopilot/fdir2_command_bars_toggle")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","laminar/A333/annun/capt_flight_director_on",0)

return sysMCP
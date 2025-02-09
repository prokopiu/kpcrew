-- ToLiss Airbusses airplane 
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

logMsg("A3TL sysMCP")

-- Flight Directors (DFLT only one supported)
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","AirbusFBW/FD1Engage",0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","AirbusFBW/FD2Engage",0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","AirbusFBW/FD1Engage",0)

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateCustomSwitch:new("yawdamper","",0,
function ()
end,
function ()
end,
function ()
end,
function ()
	return 1
end)

return sysMCP
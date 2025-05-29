-- SF34 airplane 
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

logMsg("SF34 sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdir left","les/sf34a/acft/avio/anm/dcp_fd_button_pilot",0,
	"les/sf34a/acft/avio/mnp/dcp_fd_button_pilot")
sysMCP.fdirCoPilotSwitch 	= TwoStateToggleSwitch:new("fdir right","les/sf34a/acft/avio/anm/dcp_fd_button_copilot",0,
	"les/sf34a/acft/avio/mnp/dcp_fd_button_copilot")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","les/sf34a/acft/avio/anm/dcp_fd_button_pilot",0)

sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc","les/sf34a/acft/aplt/anm/cw_ap_disco_button_pilot",0,
	"les/sf34a/acft/aplt/mnp/cw_ap_disco_button_pilot")
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"les/sf34a/acft/aplt/mnp/cw_ap_disco_button_pilot")

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateToggleSwitch:new("yawdamper","les/sf34a/acft/aplt/anm/yaw_damper_engage_switch",0,
	"les/sf34a/acft/aplt/mnp/yaw_damper_engage_switch")
	
return sysMCP
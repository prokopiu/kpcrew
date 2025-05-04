-- B737 airplane 
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

logMsg("B737 sysMCP")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateCmdSwitch:new("yawdamper","sim/cockpit2/switches/yaw_damper_on",0,
	"sim/systems/yaw_damper_on","sim/systems/yaw_damper_off","nocommand")

-- NAVIGATION SWITCHES
sysMCP.vhfNavSwitch 		= MultiStateCmdSwitch:new("vhfnav","laminar/B738/toggle_switch/vhf_nav_source",0,
	"laminar/B738/toggle_switch/vhf_nav_source_lft","laminar/B738/toggle_switch/vhf_nav_source_rgt",-1,1,true)

-- Flight Directors
if kc_is_zibo then
	sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdirpilot","laminar/B738/autopilot/flight_director_pos",0,
		"laminar/B738/autopilot/flight_director_toggle")
	sysMCP.fdirCoPilotSwitch 	= TwoStateToggleSwitch:new("fdircopilot","laminar/B738/autopilot/flight_director_fo_pos",0,
		"laminar/B738/autopilot/flight_director_fo_toggle")
	sysMCP.fdirAnc 				= CustomAnnunciator:new("fdiranc",
	function ()
		if get("laminar/B738/autopilot/flight_director_pos") > 0 or get("laminar/B738/autopilot/flight_director_fo_pos") > 0 then
			return 1
		else
			return 0
		end
	end)
else
	sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdirpilot","sim/cockpit2/autopilot/flight_director_mode",0)
	sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdircopilot","sim/cockpit2/autopilot/flight_director2_mode",0)
	sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","sim/cockpit2/autopilot/flight_director_mode",0)
end
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)




return sysMCP
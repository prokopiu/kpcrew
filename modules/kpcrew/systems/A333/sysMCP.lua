-- A333 airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMCP = {
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

require "kpcrew.systems.DFLT.sysMCP"

local drefVORLocLight 		= "sim/cockpit2/autopilot/nav_status"
local drefLNAVLight 		= "sim/cockpit2/radios/actuators/HSI_source_select_pilot"
local drefSPDLight 			= "sim/cockpit2/autopilot/autothrottle_on"
local drefVSLight 			= "sim/cockpit2/autopilot/vvi_status"
local drefVNAVLight 		= "sim/cockpit2/autopilot/fms_vnav"

-- Flight Directors (DFLT only one supported)
sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdir left","laminar/A333/annun/capt_flight_director_on",0,
	"sim/autopilot/fdir_command_bars_toggle")
sysMCP.fdirCoPilotSwitch 	= TwoStateToggleSwitch:new("fdir right","laminar/A333/annun/fo_flight_director_on",0,
	"sim/autopilot/fdir2_command_bars_toggle")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
-- Flight Directors annunciator (CAPT only)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","laminar/A333/annun/capt_flight_director_on",0)

-- HDG Select/mode annunciator
sysMCP.hdgAnc 				= CustomAnnunciator:new("hdganc",
function () 
	-- if get("sim/cockpit2/autopilot/heading_status") > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)


-- NAV mode annunciator
sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () 
	-- if get(drefVORLocLight) > 0 or get(drefLNAVLight) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- APR Select/mode annunciator
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc","sim/cockpit2/autopilot/approach_status",0)

-- SPD mode annunciator
sysMCP.spdAnc 				= SimpleAnnunciator:new("spdanc","sim/cockpit2/autopilot/autothrottle_on",0)

-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () 
	-- if get(drefVSLight) > 0 or get(drefVNAVLight) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- ALT mode annunciator
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc","sim/cockpit2/autopilot/altitude_hold_status",0)

-- A/P mode annunciator
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc","sim/cockpit2/autopilot/servos_on",0)

-- BC mode annunciator
sysMCP.bcAnc 				= InopSwitch:new("bc")

return sysMCP
-- C750 airplane 
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

local drefVORLocLight 		= "laminar/CitX/autopilot/nav_mode_on"
local drefHDGLight			= "sim/cockpit2/autopilot/heading_mode"
local drefSPDLight 			= "laminar/CitX/autopilot/flc_mode_on"
local drefVSLight 			= "laminar/CitX/autopilot/vs_mode_on"
local drefVNAVLight 		= "sim/cockpit2/autopilot/fms_vnav"
local drefAPRLight			= "laminar/CitX/autopilot/app_mode_on"
local drefLALTLight			= "laminar/CitX/autopilot/alt_mode_on"
local drefBCLight			= "laminar/CitX/autopilot/bc_mode_on"
local drefAPLight			= "laminar/CitX/autopilot/left_ap"

--------- Switches

-- HDG SEL
sysMCP.hdgselSwitch 		= TwoStateToggleSwitch:new("hdgsel",drefHDGLight,0,
	"laminar/CitX/autopilot/cmd_hdg_mode")

-- VORLOC
sysMCP.vorlocSwitch 		= TwoStateToggleSwitch:new("vorloc",drefVORLocLight,0,
	"laminar/CitX/autopilot/cmd_nav_mode")

-- ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold",drefLALTLight,0,
	"laminar/CitX/autopilot/cmd_alt_mode")

-- APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach",drefAPRLight,0,
	"laminar/CitX/autopilot/cmd_app_mode")

-- VS
sysMCP.vsSwitch 			= TwoStateToggleSwitch:new("vs",drefVSLight,0,
	"laminar/CitX/autopilot/cmd_vs_mode")

-- SPEED
sysMCP.speedSwitch 			= TwoStateToggleSwitch:new("speed",drefSPDLight,0,
	"laminar/CitX/autopilot/cmd_flc_mode")

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1",drefAPLight,0,
	"laminar/CitX/autopilot/cmd_ap_toggle")

-- BACKCOURSE
sysMCP.backcourse 			= TwoStateToggleSwitch:new("backcourse",drefBCLight,0,
	"laminar/CitX/autopilot/cmd_bc_mode")

-- TOGA
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot","sim/cockpit2/autopilot/TOGA_status",0,
	"sim/autopilot/take_off_go_around")

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav",drefVNAVLight,0,
	"laminar/CitX/autopilot/cmd_vnav_mode")

-- HDG Select/mode annunciator
sysMCP.hdgAnc 				= CustomAnnunciator:new("hdganc",
function () 
	if get(drefHDGLight) > 0 then
		return 1
	else
		return 0
	end
end)


-- NAV mode annunciator
sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () 
	if get(drefVORLocLight) > 0  then
		return 1
	else
		return 0
	end
end)

-- APR Select/mode annunciator
sysMCP.aprAnc 				= CustomAnnunciator:new("apranc",
function ()
	if get(drefAPRLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- SPD mode annunciator
sysMCP.spdAnc 				= CustomAnnunciator:new("spdanc",
function ()
	if get(drefSPDLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () 
	if get(drefVSLight) > 0 or get(drefVNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ALT mode annunciator
sysMCP.altAnc 				= CustomAnnunciator:new("altanc",
function ()
	if get(drefLALTLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- A/P mode annunciator
sysMCP.apAnc 				= CustomAnnunciator:new("apanc",
function ()
	if get(drefAPLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- BC mode annunciator
sysMCP.bcAnc 				= CustomAnnunciator:new("REV",
function () 
	if get(drefBCLight) > 0 then
		return 1
	else
		return 0
	end
end)

return sysMCP
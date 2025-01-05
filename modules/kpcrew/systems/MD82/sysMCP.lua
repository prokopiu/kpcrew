-- MD82 airplane 
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

local drefVORLocLight = "sim/cockpit2/autopilot/nav_status"
local drefLNAVLight = "sim/cockpit2/radios/actuators/HSI_source_select_pilot"
local drefSPDLight = "sim/cockpit2/autopilot/autothrottle_on"
local drefVSLight = "sim/cockpit2/autopilot/vvi_status"
local drefVNAVLight = "sim/cockpit2/autopilot/fms_vnav"

sysMCP = require("kpcrew.systems.DFLT.sysMCP")

-- A/P mode annunciator
sysMCP.apAnc = SimpleAnnunciator:new("autopilotanc","sim/cockpit2/autopilot/autopilot_on_or_cws",0)

-- CWS Boeing only
sysMCP.cwsaSwitch = TwoStateToggleSwitch:new("cwsa","sim/cockpit2/autopilot/servos_on",0,"sim/autopilot/fdir_servos_toggle")
sysMCP.cwsbSwitch = InopSwitch:new("cwsb")

-- TURNRATE
sysMCP.turnRateSelector 	= MultiStateCmdSwitch:new("turnrate","sim/cockpit2/autopilot/bank_angle_mode",0,
	"sim/autopilot/bank_limit_down","sim/autopilot/bank_limit_up",0,6,false)
	
-- ATHR
sysMCP.athrSwitch = TwoStateToggleSwitch:new("athr","laminar/md82/autopilot/autothrottle_switch",0,"laminar/md82cmd/autopilot/autothrottle_switch")

return sysMCP
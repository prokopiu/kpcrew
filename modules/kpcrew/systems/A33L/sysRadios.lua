-- Laminar A330 variants airplane 
-- Radio functionality

-- @classmod sysRadios
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

sysRadios = require("kpcrew.systems.DFLT.sysRadios")

logMsg("A33L sysRadios")

sysRadios.xpdrSwitch 		= MultiStateCmdSwitch:new("xpdrmode","laminar/A333/transponder/ta_ra_knob_pos",0,
	"laminar/A333/transponder/ta_ra_left","laminar/A333/transponder/ta_ra_right",0,2,true)
sysRadios.stby				= 0
sysRadios.alt				= 0
sysRadios.ta				= 1
sysRadios.tara				= 2

return sysRadios
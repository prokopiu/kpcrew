-- SF34 airplane 
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

logMsg("SF34 sysRadios")

sysRadios.off				= 0
sysRadios.stby				= 1
sysRadios.alt				= 2
sysRadios.ta				= 3
sysRadios.tara				= 3

sysRadios.xpdrSwitch 		= TwoStateCustomSwitch:new ("xpdrmode","les/sf34a/acft/avio/anm/pl2_atc_func_knob",0,
	function()
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
	end,
	function()
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_dn")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_dn")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_dn")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
	end,
	function()
	end,
	function()
		return get("les/sf34a/acft/avio/anm/pl2_atc_func_knob")
	end)

return sysRadios
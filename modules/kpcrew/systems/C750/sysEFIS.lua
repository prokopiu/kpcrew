-- Laminar C750  airplane 
-- EFIS functionality

-- @classmod sysEFIS
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

local sysEFIS = {
	mapRange_5 		= 0,
	mapRange10 		= 1,
	mapRange20 		= 2,
	mapRange40 		= 3,
	mapRange80 		= 4,
	mapRange160 	= 5,
	mapRange320 	= 6,
	mapRange640 	= 6,
	
	mapModeAPP 		= 0,
	mapModeVOR 		= 1,
	mapModeMAP 		= 2,
	mapModePLAN 	= 4,
	
	voradfVOR 		= 1,
	voradfOFF 		= 0,
	voradfADF 		= -1,
	
	minsTypeRadio 	= 0,
	minsTypeBaro 	= 1
}

sysEFIS = require("kpcrew.systems.DFLT.sysEFIS")

return sysEFIS
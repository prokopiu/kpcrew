-- Laminar C750  airplane 
-- EFIS functionality

-- @classmod sysEFIS
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

sysEFIS = require("kpcrew.systems.DFLT.sysEFIS")

sysEFIS.mapRange_5 	= 0
sysEFIS.mapRange10 	= 1
sysEFIS.mapRange20 	= 2
sysEFIS.mapRange40 	= 3
sysEFIS.mapRange80 	= 4
sysEFIS.mapRange160 = 5
sysEFIS.mapRange320 = 6
sysEFIS.mapRange640 = 6

sysEFIS.mapModeAPP 	= 0
sysEFIS.mapModeVOR 	= 1
sysEFIS.mapModeMAP 	= 2
sysEFIS.mapModePLAN = 4

sysEFIS.voradfVOR 	= 1
sysEFIS.voradfOFF 	= 0
sysEFIS.voradfADF 	= -1

sysEFIS.minsTypeRadio = 0
sysEFIS.minsTypeBaro = 1

return sysEFIS
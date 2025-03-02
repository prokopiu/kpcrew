-- ToLiss Airbusses
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

logMsg("A3TL sysRadios")

sysRadios.xpdrSwitch 		= TwoStateDrefSwitch:new ("xpdrmode","AirbusFBW/XPDRPower",0)
	
sysRadios.xpdrCode 			= TwoStateDrefSwitch:new ("xpdrcode","sim/cockpit2/radios/actuators/transponder_code",0)

sysRadios.stby				= 0
sysRadios.alt				= 2
sysRadios.ta				= 3
sysRadios.tara				= 4

return sysRadios
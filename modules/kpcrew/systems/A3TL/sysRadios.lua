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

function kc_macro_set_xpdrmode(mode)
	sysRadios.xpdrSwitch:setValue(mode)
end

function kc_macro_set_xpdrcode(xpdrcode)
	local digit1 = math.floor(xpdrcode/1000)
	local digit2 = math.floor((xpdrcode-digit1*1000)/100)
	local digit3 = math.floor((xpdrcode-digit1*1000-digit2*100)/10)
	local digit4 = math.floor((xpdrcode-digit1*1000-digit2*100-digit3*10))
	set("AirbusFBW/XPDR1",digit4)
	set("AirbusFBW/XPDR2",digit3)
	set("AirbusFBW/XPDR3",digit2)
	set("AirbusFBW/XPDR4",digit1)
end

return sysRadios
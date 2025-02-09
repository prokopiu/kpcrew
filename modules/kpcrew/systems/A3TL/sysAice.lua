-- ToLiss Airbusses
-- Anti Ice functionality

-- @classmod sysAice
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

sysAice = require("kpcrew.systems.DFLT.sysAice")

logMsg("A3TL sysAice")

-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("winheat1","AirbusFBW/ProbeHeatSwitch",0)
sysAice.windowHeat2 		= InopSwitch:new("winheat2")
sysAice.windowHeat3 		= InopSwitch:new("winheat3")
sysAice.windowHeat4 		= InopSwitch:new("winheat4")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateDrefSwitch:new("probeheat1","AirbusFBW/ProbeHeatSwitch",0)
sysAice.probeHeatBSwitch 	= InopSwitch:new("probeheat2")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- ENG anti ice
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIce1 		= TwoStateCmdSwitch:new("eng1aice","AirbusFBW/ATA30SwitchAnims",3,
	"toliss_airbus/antiicecommands/ENG1On","toliss_airbus/antiicecommands/ENG1Off","nocommand")
sysAice.engAntiIce2 		= TwoStateCmdSwitch:new("eng2aice","AirbusFBW/ATA30SwitchAnims",4,
	"toliss_airbus/antiicecommands/ENG2On","toliss_airbus/antiicecommands/ENG1Off","nocommand")
if PLANE_ICAO == "A346" then
	sysAice.engAntiIce3 		= TwoStateCmdSwitch:new("eng3aice","AirbusFBW/ATA30SwitchAnims",5,
		"toliss_airbus/antiicecommands/ENG3On","toliss_airbus/antiicecommands/ENG1Off","nocommand")
	sysAice.engAntiIce4 		= TwoStateCmdSwitch:new("eng4aice","AirbusFBW/ATA30SwitchAnims",6,
		"toliss_airbus/antiicecommands/ENG4On","toliss_airbus/antiicecommands/ENG1Off","nocommand")
else
	sysAice.engAntiIce3 		= InopSwitch:new("eng3aice")
	sysAice.engAntiIce4 		= InopSwitch:new("eng4aice")
end	
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","AirbusFBW/ATA30SwitchAnims",2,
	"toliss_airbus/antiicecommands/WingOn","toliss_airbus/antiicecommands/WingOff","nocommand")
sysAice.wingAntiIce2 		= InopSwitch:new("wingaice2")
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

return sysAice
-- ToLiss Airbusses
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysAice.windowHeatGroup
-- sysAice.probeHeatGroup
-- sysAice.engAntiIce1 
-- sysAice.engAntiIce2 
-- sysAice.engAntiIce3 
-- sysAice.engAntiIce4 
-- sysAice.wingAiceGroup
-- Macro: kc_ab_air_has_white_lights
-- Macro: kc_ab_air_has_no_white_lights

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

--------- Switch datarefs common
local drefWindowHeat		= "AirbusFBW/ProbeHeatSwitch"
local drefEngineAice		= "AirbusFBW/ATA30SwitchAnims"

--------- Switch commands common
local cmdEngineAice1On		= "toliss_airbus/antiicecommands/ENG1On"
local cmdEngineAice2On		= "toliss_airbus/antiicecommands/ENG2On"
local cmdEngineAice3On		= "toliss_airbus/antiicecommands/ENG3On"
local cmdEngineAice4On		= "toliss_airbus/antiicecommands/ENG4On"
local cmdEngineAice1Off		= "toliss_airbus/antiicecommands/ENG1Off"
local cmdEngineAice2Off		= "toliss_airbus/antiicecommands/ENG2Off"
local cmdEngineAice3Off		= "toliss_airbus/antiicecommands/ENG3Off"
local cmdEngineAice4Off		= "toliss_airbus/antiicecommands/ENG4Off"
local cmdWingAice1On		= "toliss_airbus/antiicecommands/WingOn"
local cmdWingAice1Off		= "toliss_airbus/antiicecommands/WingOff"

logMsg("A3TL sysAice")

-- Window Heat & Probeheat in Airbus
sysAice.windowHeatGroup 	= TwoStateDrefSwitch:new("winheat1",drefWindowHeat,0)

-- Probe/Pitot heat
sysAice.probeHeatGroup 	= TwoStateDrefSwitch:new("probeheat1",drefWindowHeat,0)

-- ENG anti ice
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIce1 		= TwoStateCmdSwitch:new("eng1aice",drefEngineAice,2,
	cmdEngineAice1On,cmdEngineAice1Off,"nocommand")
sysAice.engAntiIce2 		= TwoStateCmdSwitch:new("eng2aice",drefEngineAice,3,
	cmdEngineAice2On,cmdEngineAice2Off,"nocommand")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
if PLANE_ICAO == "A346" then
	sysAice.engAntiIce3 	= TwoStateCmdSwitch:new("eng3aice",drefEngineAice,5,
		cmdEngineAice3On,cmdEngineAice2Off,"nocommand")
	sysAice.engAntiIce4 	= TwoStateCmdSwitch:new("eng4aice",drefEngineAice,6,
		cmdEngineAice4On,cmdEngineAice2Off,"nocommand")
	sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
	sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)
end	

-- Wing anti ice
sysAice.wingAiceGroup 		= TwoStateCmdSwitch:new("wingaice",drefEngineAice,1,
	cmdWingAice1On,cmdWingAice1Off,"nocommand")

--------- Macros

return sysAice
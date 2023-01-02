-- C750 airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysAice = {
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

-- Window Heat
sysAice.windowHeat1 		= TwoStateCmdSwitch:new("winheat1","laminar/CitX/ice/windshield_left",0,
	"laminar/CitX/ice/cmd_windshield_left_dwn","laminar/CitX/ice/cmd_windshield_left_up","nocommand")
sysAice.windowHeat2 		= TwoStateCmdSwitch:new("winheat2","laminar/CitX/ice/windshield_right",0,
	"laminar/CitX/ice/cmd_windshield_right_dwn","laminar/CitX/ice/cmd_windshield_right_up","nocommand")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateToggleSwitch:new("probeheat1","laminar/CitX/ice/pitot_static_left",0,
	"laminar/CitX/ice/cmd_pitot_static_left_toggle")
sysAice.probeHeatBSwitch 	= TwoStateToggleSwitch:new("probeheat2","laminar/CitX/ice/pitot_static_right",0,
	"laminar/CitX/ice/cmd_pitot_static_right_toggle")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateToggleSwitch:new("wingaice","laminar/CitX/ice/stabilizer_left",0,
	"laminar/CitX/ice/cmd_stabilizer_left_toggle")
sysAice.wingAntiIce2 		= TwoStateToggleSwitch:new("wingaice2","laminar/CitX/ice/stabilizer_right",0,
	"laminar/CitX/ice/cmd_stabilizer_right_toggle")
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateToggleSwitch:new("eng1aice","laminar/CitX/ice/engine_left",0,
	"laminar/CitX/ice/cmd_engine_left_toggle")
sysAice.engAntiIce2 		= TwoStateToggleSwitch:new("eng2aice","laminar/CitX/ice/engine_right",0,
	"laminar/CitX/ice/cmd_engine_right_toggle")
-- sysAice.engAntiIce3 		= InopSwitch:new("eng3aice")
-- sysAice.engAntiIce4 		= InopSwitch:new("eng4aice")
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
-- sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
-- sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

-- ==== Annunciators

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if get("laminar/CitX/ice/stabilizer_left") > 0 or get("laminar/CitX/ice/stabilizer_right") > 0  or 
	   get("laminar/CitX/ice/engine_left") > 0 or get("laminar/CitX/ice/engine_right") > 0 then
		return 1
	else
		return 0
	end
end)

return sysAice
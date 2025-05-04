-- B737 airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysAice = require("kpcrew.systems.DFLT.sysAice")

logMsg("B737 sysAice")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

-- Probe heat
if kc_is_zibo then
	sysAice.probeHeatASwitch 	= TwoStateToggleSwitch:new("probeheat1","laminar/B738/toggle_switch/capt_probes_pos",0,
		"laminar/B738/toggle_switch/capt_probes_pos")
	sysAice.probeHeatBSwitch 	= TwoStateToggleSwitch:new("probeheat2","laminar/B738/toggle_switch/fo_probes_pos",0,
		"laminar/B738/toggle_switch/fo_probes_pos")
else
	sysAice.probeHeatASwitch 	= TwoStateCmdSwitch:new("probeheat1","laminar/B738/toggle_switch/capt_probes_pos",0,
		"laminar/B738/toggle_switch/capt_probes_pos_on","laminar/B738/toggle_switch/capt_probes_pos_off","nocommand")
	sysAice.probeHeatBSwitch 	= TwoStateCmdSwitch:new("probeheat2","laminar/B738/toggle_switch/fo_probes_pos",0,
		"laminar/B738/toggle_switch/fo_probes_pos_on","laminar/B738/toggle_switch/fo_probes_pos_off","nocommand")
end
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
if kc_is_zibo then
	sysAice.wingAntiIce 		= TwoStateToggleSwitch:new("wingaice","laminar/B738/ice/wing_heat_pos",0,
		"laminar/B738/toggle_switch/wing_heat")
else
	sysAice.wingAntiIce 		= TwoStateCmdSwitch:new("wingaice","sim/cockpit/switches/anti_ice_surf_heat",0,
		"sim/ice/wing_heat_on","sim/ice/wing_heat_off","nocommand")
end

return sysAice
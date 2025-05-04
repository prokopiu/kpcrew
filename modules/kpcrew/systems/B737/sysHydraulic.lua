-- B737 airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
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

sysHydraulic = require("kpcrew.systems.DFLT.sysHydraulic")

logMsg("B737 sysHydraulic")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

if kc_is_zibo then
	sysHydraulic.elecHydPump1 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/electric_hydro_pumps1_pos",0,
		"laminar/B738/toggle_switch/electric_hydro_pumps1")
	sysHydraulic.elecHydPump2 	= TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/electric_hydro_pumps2_pos",0,
		"laminar/B738/toggle_switch/electric_hydro_pumps2")
else
	sysHydraulic.elecHydPump1 	= TwoStateCmdSwitch:new("","sim/cockpit2/switches/electric_hydraulic_pump_on",0,
		"sim/flight_controls/hydraulic_acmp_on","sim/flight_controls/hydraulic_acmp_off","sim/flight_controls/hydraulic_acmp_tog")
	sysHydraulic.elecHydPump2 	= TwoStateCmdSwitch:new("","sim/cockpit2/switches/electric_hydraulic_pump2_on",0,
		"sim/flight_controls/hydraulic_acmp2_on","sim/flight_controls/hydraulic_acmp2_off","sim/flight_controls/hydraulic_acmp2_tog")
end
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)
return sysHydraulic
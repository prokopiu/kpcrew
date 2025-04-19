-- DFLT airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local sysHydraulic = {
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

local drefHydPressure1 		= "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 		= "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

sysHydraulic.hydTestSwitch 	= TwoStateToggleSwitch:new("","Rotate/aircraft/controls/hyd_pres_test",0,
	"Rotate/aircraft/controls_c/hyd_pres_test_grd")

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = InopSwitch:new("hydrauliclow")

return sysHydraulic
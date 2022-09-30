-- A320N JarDesign airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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

local drefHydPressure1 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

-- ---- Annunciators

-- ACCU Pressure
sysHydraulic.accuPress = SimpleAnnunciator:new("accupress","sim/custom/xap/brakes/accu_press",0)

-- brake pressure
sysHydraulic.leftBrakePress = SimpleAnnunciator:new("leftbrkpress","sim/custom/xap/brakes/left_br_press",0)
sysHydraulic.rightBrakePress = SimpleAnnunciator:new("rghtbrkpress","sim/custom/xap/brakes/rght_br_press",0)

-- Hydraulic pumps
sysHydraulic.yellowElecPumpSwitch = TwoStateDrefSwitch:new("elecyellowpump","sim/custom/xap/hydr/y/elpump/mode",0)
sysHydraulic.blueElecPumpSwitch = TwoStateDrefSwitch:new("elecbluewpump","sim/custom/xap/hydr/b/elpump/mode",0)
sysHydraulic.ptuSwitch = TwoStateDrefSwitch:new("ptu","sim/custom/xap/hydr/ptu/mode",0)
sysHydraulic.eng1Pump = TwoStateDrefSwitch:new("eng1pump","sim/custom/xap/hydr/g/engpump/mode",0)
sysHydraulic.eng2Pump = TwoStateDrefSwitch:new("eng1pump","sim/custom/xap/hydr/y/engpump/mode",0)

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic
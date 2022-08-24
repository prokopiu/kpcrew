-- DFLT airplane 
-- Hydraulic system functionality

local sysHydraulic = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

local drefHydPressure1 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

-- hydraulic demand pumps
sysHydraulic.demandPump1Switch = MultiStateCmdSwitch:new("demand1","laminar/B747/hydraulics/dem_mode_1",0,"laminar/B747/hydraulics/sel_dial/dmd_pump_01_dn","laminar/B747/hydraulics/sel_dial/dmd_pump_01_up")
sysHydraulic.demandPump2Switch = MultiStateCmdSwitch:new("demand2","laminar/B747/hydraulics/dem_mode_2",0,"laminar/B747/hydraulics/sel_dial/dmd_pump_02_dn","laminar/B747/hydraulics/sel_dial/dmd_pump_02_up")
sysHydraulic.demandPump3Switch = MultiStateCmdSwitch:new("demand3","laminar/B747/hydraulics/dem_mode_3",0,"laminar/B747/hydraulics/sel_dial/dmd_pump_03_dn","laminar/B747/hydraulics/sel_dial/dmd_pump_03_up")
sysHydraulic.demandPump4Switch = MultiStateCmdSwitch:new("demand4","laminar/B747/hydraulics/dem_mode_4",0,"laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn","laminar/B747/hydraulics/sel_dial/dmd_pump_04_up")
sysHydraulic.demandPumpGroup = SwitchGroup:new("demandpumps")
sysHydraulic.demandPumpGroup:addSwitch(sysHydraulic.demandPump1Switch)
sysHydraulic.demandPumpGroup:addSwitch(sysHydraulic.demandPump2Switch)
sysHydraulic.demandPumpGroup:addSwitch(sysHydraulic.demandPump3Switch)
sysHydraulic.demandPumpGroup:addSwitch(sysHydraulic.demandPump4Switch)


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
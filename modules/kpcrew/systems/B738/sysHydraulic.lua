-- B738 airplane 
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

local drefElHydPressure1 = "laminar/B738/annunciator/hyd_el_press_a"
local drefElHydPressure2 = "laminar/B738/annunciator/hyd_el_press_b"
local drefHydPressure1 = "laminar/B738/annunciator/hyd_press_a"
local drefHydPressure2 = "laminar/B738/annunciator/hyd_press_b"

-- ===== Switches

sysHydraulic.elecHydPump1 = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/electric_hydro_pumps1_pos",0,"laminar/B738/toggle_switch/electric_hydro_pumps1")
sysHydraulic.elecHydPump2 = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/electric_hydro_pumps2_pos",0,"laminar/B738/toggle_switch/electric_hydro_pumps2")

sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

sysHydraulic.engHydPump1 = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/hydro_pumps1_pos",0,"laminar/B738/toggle_switch/hydro_pumps1")
sysHydraulic.engHydPump2 = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/hydro_pumps2_pos",0,"laminar/B738/toggle_switch/hydro_pumps2")

sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

sysHydraulic.hydPumpGroup = SwitchGroup:new("hydpumps")
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

-- ===== Annunciators

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 or get(drefElHydPressure1,0) == 1 or get(drefElHydPressure2,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic
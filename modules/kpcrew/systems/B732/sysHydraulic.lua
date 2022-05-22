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

local drefElHydPressure1 = "FJS/732/FltControls/HydSysAPressNeedle"
local drefElHydPressure2 = "FJS/732/FltControls/HydSysBPressNeedle"
local drefHydPressure1 = "FJS/732/FltControls/HydSysAPressNeedle"
local drefHydPressure2 = "FJS/732/FltControls/HydSysBPressNeedle"

-- ===== Switches

sysHydraulic.elecHydPump1 = TwoStateDrefSwitch:new("","FJS/732/FltControls/Elec1HydPumpSwitch",0)
sysHydraulic.elecHydPump2 = TwoStateDrefSwitch:new("","FJS/732/FltControls/Elec2HydPumpSwitch",0)

sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

sysHydraulic.engHydPump1 = TwoStateDrefSwitch:new("","FJS/732/FltControls/Eng1HydPumpSwitch",0)
sysHydraulic.engHydPump2 = TwoStateDrefSwitch:new("","FJS/732/FltControls/Eng2HydPumpSwitch",0)

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
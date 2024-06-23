-- C750 airplane 
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

local drefHydPressure1 		= "sim/cockpit2/annunciators/hydraulic_pressure"

-- HYD Electric Pumps
sysHydraulic.elecHydPumpA = TwoStateToggleSwitch:new("hydpump","laminar/CitX/hydraulics/aux_pump",0,
	"laminar/CitX/hydraulics/cmd_aux_pump_toggle")
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPumpA)

-- HYD ENGINE Pumps

sysHydraulic.engHydPump1 = TwoStateToggleSwitch:new("enghyd1","laminar/CitX/hydraulics/unload_pump_A",0,
	"laminar/CitX/hydraulics/cmd_unload_pump_A_toggle")
sysHydraulic.engHydPump2 = TwoStateToggleSwitch:new("enghyd2","laminar/CitX/hydraulics/unload_pump_B",0,
	"laminar/CitX/hydraulics/cmd_unload_pump_B_toggle")
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
	
------ Annunciators

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydPressure1,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic
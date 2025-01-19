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

-- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = TwoStateDrefSwitch:new("elechydpump","sim/cockpit2/switches/electric_hydraulic_pump_on",0)

-- HYD Engine Pumps
-- XCrafts Freeware E175 and E195
if PLANE_ICAO == "E190" then
	sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","XCrafts/ERJ_195/Hydraulics1",0)
	sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","XCrafts/ERJ_195/Hydraulics2",0)
elseif PLANE_ICAO == "E170" then
	sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","XCrafts/ERJ_175/Hydraulics1",0)
	sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","XCrafts/ERJ_175/Hydraulics2",0)
else
	sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","sim/cockpit2/hydraulics/actuators/engine_pump",0)
	sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","sim/cockpit2/hydraulics/actuators/engine_pump",1)
end
sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3","sim/cockpit2/hydraulics/actuators/engine_pump",2)
sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4","sim/cockpit2/hydraulics/actuators/engine_pump",3)
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)

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
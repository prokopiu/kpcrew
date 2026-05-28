-- ToLiss Airbusses
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysHydraulic.elecHydPumpGroup
-- sysHydraulic.engHydPumpGroup
-- sysHydraulic.engHydPump1
-- sysHydraulic.engHydPump2
-- sysHydraulic.engHydPump3
-- sysHydraulic.engHydPump4

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

logMsg("A3TL sysHydraulic")

--------- Switch datarefs common
local drefElecHydPump		= "AirbusFBW/HydOHPArray"
local drefEngHydPump1		= "AirbusFBW/HydOHPArray"

--------- Annunciator datarefs common

--------- Switch commands common

-- ----- HYD Electric Pumps
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	sysHydraulic.elecHydPump1	= TwoStateDrefSwitch:new("elechydpump1",drefElecHydPump,3)
else
	sysHydraulic.elecHydPump1	= TwoStateDrefSwitch:new("elechydpump1",drefElecHydPump,9)
end
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1",drefEngHydPump1,-1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2",drefEngHydPump1,1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3",drefEngHydPump1,2)
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
	sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4",drefEngHydPump1,3)
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
end

return sysHydraulic
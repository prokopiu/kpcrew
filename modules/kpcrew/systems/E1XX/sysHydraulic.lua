-- E1XX airplane 
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

logMsg("E1XX sysHydraulic")

-- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","XCrafts/ERJ/Hydraulics1",0)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","XCrafts/ERJ/Hydraulics2",0)
sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3","XCrafts/hydraulic/sys3_elec_pump_a_switch",0)
sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4","XCrafts/hydraulic/sys3_elec_pump_b_switch",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.elecHydPump3)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.elecHydPump4)

-- PTU / Transfer Pump
sysHydraulic.PTU			= TwoStateDrefSwitch:new("ptu","XCrafts/hydraulic/PTU_switch",0)

return sysHydraulic
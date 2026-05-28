-- A306 airplane 
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

logMsg("A306 sysHydraulic")

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPump0	= TwoStateDrefSwitch:new("elechydpump","A300/HYD/hydraulic_elec_status",0)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.engHydPump0)
sysHydraulic.elecHydPump1	= TwoStateDrefSwitch:new("enghydpump3","A300/HYD/eng1_A_switch_position",0)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.elecHydPump2	= TwoStateDrefSwitch:new("enghydpump2","A300/HYD/eng2_B_switch_position",0)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup= SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","A300/HYD/eng1_switch_position",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","A300/HYD/eng2_switch_position",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)


-- PTU / Transfer Pump
sysHydraulic.PTU			= SwitchGroup:new("ptus")
sysHydraulic.ptu1			= TwoStateDrefSwitch:new("ptu1","A300/HYD/hydraulic_ptu_blue_status",0)
sysHydraulic.ptu2			= TwoStateDrefSwitch:new("ptu2","A300/HYD/hydraulic_ptu_yellow_status",0)
sysHydraulic.PTU:addSwitch(sysHydraulic.ptu1)
sysHydraulic.PTU:addSwitch(sysHydraulic.ptu2)

return sysHydraulic
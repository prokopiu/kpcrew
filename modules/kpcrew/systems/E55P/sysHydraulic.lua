-- E55P airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

logMsg("E55P sysHydraulic")

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateCmdSwitch:new("enghydpump1","aerobask/hyd/sw_pump1",0,
	"aerobask/hyd/pump1_up","aerobask/hyd/pump1_dn","nocommand")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateCmdSwitch:new("enghydpump2","aerobask/hyd/sw_pump2",0,
	"aerobask/hyd/pump2_up","aerobask/hyd/pump2_dn","nocommand")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

return sysHydraulic
-- MD82 airplane 
-- Engine related functionality

-- @classmod sysEngines
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

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

logMsg("MD82 sysEngines")

return sysEngines

-- sysEngines.ignition = MultiStateCmdSwitch:new("ignition","laminar/md82/ignition_sys",0,
	-- "laminar/md82cmd/ignition_sys_dwn","laminar/md82cmd/ignition_sys_up",0,4,true)

-- sysEngines.engStart1Switch = KeepPressedSwitchCmd:new("eng1start","sim/flightmodel2/engines/starter_is_running",-1,
	-- "sim/ignition/engage_starter_1")
-- sysEngines.engStart2Switch = KeepPressedSwitchCmd:new("eng1start","sim/flightmodel2/engines/starter_is_running",1,
	-- "sim/ignition/engage_starter_2")
-- sysEngines.engStart1Cover = TwoStateToggleSwitch:new("eng1startc","laminar/md82/safeguard",-1,
	-- "laminar/md82cmd/safeguard00")
-- sysEngines.engStart2Cover = TwoStateToggleSwitch:new("eng2startc","laminar/md82/safeguard",1,
	-- "laminar/md82cmd/safeguard01")

-- sysEngines.fuelLever1	= TwoStateDrefSwitch:new("fuellever1","sim/cockpit2/engine/actuators/mixture_ratio",-1)
-- sysEngines.fuelLever2	= TwoStateDrefSwitch:new("fuellever1","sim/cockpit2/engine/actuators/mixture_ratio",1)

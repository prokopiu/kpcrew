-- MD82 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local sysEngines = {
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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

local drefEngine1Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil = "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil = "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire = "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire = "sim/cockpit2/annunciators/engine_fires"

----------- Switches

-- Reverse Toggle
sysEngines.reverseToggle = TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,"sim/engines/thrust_reverse_toggle") 

-- Start Pump DC
sysEngines.startPumpDc = TwoStateCmdSwitch:new("startPump","sim/cockpit/engine/fuel_pump_on",0,
	"sim/fuel/fuel_pumps_on","sim/fuel/fuel_pumps_off","sim/fuel/fuel_pumps_tog")

sysEngines.ignition = MultiStateCmdSwitch:new("ignition","laminar/md82/ignition_sys",0,
	"laminar/md82cmd/ignition_sys_dwn","laminar/md82cmd/ignition_sys_up",0,4,true)

sysEngines.engStart1Switch = KeepPressedSwitchCmd:new("eng1start","sim/flightmodel2/engines/starter_is_running",-1,
	"sim/ignition/engage_starter_1"
sysEngines.engStart2Switch = KeepPressedSwitchCmd:new("eng1start","sim/flightmodel2/engines/starter_is_running",1,
	"sim/ignition/engage_starter_2"
sysEngines.engStart1Cover = TwoStateToggleSwitch:new("eng1startc","laminar/md82/safeguard",-1,
	"laminar/md82cmd/safeguard00")
sysEngines.engStart2Cover = TwoStateToggleSwitch:new("eng2startc","laminar/md82/safeguard",1,
	"laminar/md82cmd/safeguard01")

sysEngines.fuelLever1	= TwoStateDrefSwitch:new("fuellever1","sim/cockpit2/engine/actuators/mixture_ratio",-1)
sysEngines.fuelLever2	= TwoStateDrefSwitch:new("fuellever1","sim/cockpit2/engine/actuators/mixture_ratio",1)

----------- Annunciators

-- ENGINE FIRE annunciator
sysEngines.engineFireAnc = CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire,0) > 0 or get(drefEngine2Fire,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- OIL PRESSURE annunciator
sysEngines.OilPressureAnc = CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get(drefEngine1Starter,0) > 0 and get(drefEngine2Starter,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- Reverse Thrust
sysEngines.reverseAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get("sim/cockpit/warnings/annunciators/reverse",0) > 0 then
		return 1
	else
		return 0
	end
end)

return sysEngines
-- E1XX airplane 
-- Electric system functionality

-- @classmod sysElectric
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

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

logMsg("E1XX sysElectric")

-- ---- Inverters
sysElectric.inverter1Switch 		= TwoStateDrefSwitch:new("inverter1","sim/cockpit/engine/inverter_on",-1)
sysElectric.inverter2Switch 		= TwoStateDrefSwitch:new("inverter2","sim/cockpit/engine/inverter_on",1)
sysElectric.inverter3Switch 		= TwoStateDrefSwitch:new("inverter2","XCrafts/electrical/TRU_ESS_switch",0)
sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter1Switch)
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter2Switch)
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter3Switch)

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateDrefSwitch:new("dcbustie","XCrafts/electrical/dc_bus_tie_switch",0)

-- AC Bus Tie
sysElectric.acBusTie				= TwoStateDrefSwitch:new("acbustie","XCrafts/electrical/ac_bus_tie_switch",0)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","XCrafts/ERJ/APU_switch",0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","XCrafts/ERJ/APU_switch",0)
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","sim/cockpit/electrical/generator_apu_on",0)
sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("sim/cockpit/engine/APU_N1") == 100 then
			return 1
		else
			return 0
		end
	end)

-- GPU
sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","XCrafts/other/GPU",0,
	function () 
		set("XCrafts/other/GPU",0)
	end,
	function () 
		set("XCrafts/other/GPU",1)
	end,
	function () 
		if get("XCrafts/other/GPU") == 0 then
			set("XCrafts/other/GPU",1)
		else
			set("XCrafts/other/GPU",0)
		end
	end,
	function ()
		if get("XCrafts/other/GPU") == 0 then
			return 1
		else
			return 0
		end		
	end)
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","XCrafts/electric/GPU_sw",0)
sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","XCrafts/electric/GPU_sw",0)

return sysElectric

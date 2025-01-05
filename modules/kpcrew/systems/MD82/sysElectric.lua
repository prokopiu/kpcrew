-- MD82 airplane 
-- Electric system functionality

-- @classmod sysElectric
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

local sysElectric = {
	VOLTMTR_APU 	= 0,
	VOLTMTR_EXT 	= 1,
	VOLTMTR_LEFT 	= 2,
	VOLTMTR_RIGHT 	= 3,
	VOLTMTR_BATVOLT = 4,
	VOLTMTR_BATAMP 	= 5
}

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

return sysElectric

-- GPU Bus Switches
-- sysElectric.gpuGenBus1 		= TwoStateToggleSwitch:new("gpubus1","laminar/md82/electrical/cross_tie_GPU_L",0,
	-- "laminar/md82cmd/electrical/cross_tie_GPU_L")
-- sysElectric.gpuGenBus2 		= TwoStateToggleSwitch:new("gpubus2","laminar/md82/electrical/cross_tie_GPU_R",0,
	-- "laminar/md82cmd/electrical/cross_tie_GPU_R")

-- APU Bus Switches
-- sysElectric.apuGenBus1 		= TwoStateToggleSwitch:new("apubus1","laminar/md82/electrical/cross_tie_APU_L",0,
	-- "laminar/md82cmd/electrical/cross_tie_APU_L")
-- sysElectric.apuGenBus2 		= TwoStateToggleSwitch:new("apubus2","laminar/md82/electrical/cross_tie_APU_R",0,
	-- "laminar/md82cmd/electrical/cross_tie_APU_R")

-- Voltmeter MD82
-- sysElectric.voltmeterSwitch = MultiStateCmdSwitch:new("voltmeter","laminar/md82/electrical/voltmeter_source",0,
	-- "laminar/md82cmd/electrical/voltmeter_source_dwn","laminar/md82cmd/electrical/voltmeter_source_up",0,5,true)

-- sysElectric.galleyPower = TwoStateToggleSwitch:new("galleypwr","sim/cockpit2/switches/generic_lights_switch",36,
	-- "sim/lights/generic_37_light_tog")

-- sysElectric.dcBusXTie = TwoStateToggleSwitch:new("dcbusxtie","laminar/md82/electrical/cross_tie_DC",0,
	-- "laminar/md82cmd/electrical/cross_tie_DC")
	
-- sysElectric.acBusXTie = TwoStateToggleSwitch:new("acbusxtie","laminar/md82/electrical/cross_tie_AC",0,
	-- "laminar/md82cmd/electrical/cross_tie_AC")
	
-- GPU on bus annunciator
-- sysElectric.gpuOnBus = CustomAnnunciator:new("gpuonbus",
-- function () 
	-- if get("sim/cockpit/electrical/gpu_on") == 1 and 
		-- get("laminar/md82/electrical/cross_tie_GPU_L") == 1 and
		-- get("laminar/md82/electrical/cross_tie_GPU_R") == 1 then
		-- return 1
	-- else
		-- return 0
	-- end
-- end)
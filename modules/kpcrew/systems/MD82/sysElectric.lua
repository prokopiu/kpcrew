-- MD82 airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu

local sysElectric = {
	VOLTMTR_APU = 0,
	VOLTMTR_EXT = 1,
	VOLTMTR_LEFT = 2,
	VOLTMTR_RIGHT = 3,
	VOLTMTR_BATVOLT = 4,
	VOLTMTR_BATAMP = 5
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

-- Battery Power
sysElectric.batterySwitch 		= TwoStateCmdSwitch:new("GPU","sim/cockpit/electrical/battery_array_on",0,
	"sim/electrical/battery_1_on","sim/electrical/battery_1_off","sim/electrical/battery_1_toggle")

-- Ground Power
sysElectric.gpuSwitch 		= TwoStateCmdSwitch:new("GPU","sim/cockpit/electrical/gpu_on",0,
	"sim/electric/gpu_on","sim/electric/gpu_off","sim/electric/gpu_toggle","nocommand")

-- GPU Bus Switches
sysElectric.gpuGenBus1 		= TwoStateToggleSwitch:new("gpubus1","laminar/md82/electrical/cross_tie_GPU_L",0,
	"laminar/md82cmd/electrical/cross_tie_GPU_L")
sysElectric.gpuGenBus2 		= TwoStateToggleSwitch:new("gpubus2","laminar/md82/electrical/cross_tie_GPU_R",0,
	"laminar/md82cmd/electrical/cross_tie_GPU_R")

-- APU MASTER
sysElectric.apuMasterSwitch = TwoStateCmdSwitch:new("apu","sim/cockpit/engine/APU_switch",0,
	"sim/electrical/APU_on","sim/electrical/APU_off","nocommand")
-- APU Starter
sysElectric.apuStartSwitch 	= KeepPressedSwitchCmd:new("apu","sim/cockpit/engine/APU_switch",0,
	"sim/electrical/APU_start")

-- APU Bus Switches
sysElectric.apuGenBus1 		= TwoStateToggleSwitch:new("apubus1","laminar/md82/electrical/cross_tie_APU_L",0,
	"laminar/md82cmd/electrical/cross_tie_APU_L")
sysElectric.apuGenBus2 		= TwoStateToggleSwitch:new("apubus2","laminar/md82/electrical/cross_tie_APU_R",0,
	"laminar/md82cmd/electrical/cross_tie_APU_R")

-- Voltmeter MD82
sysElectric.voltmeterSwitch = MultiStateCmdSwitch:new("voltmeter","laminar/md82/electrical/voltmeter_source",0,
	"laminar/md82cmd/electrical/voltmeter_source_dwn","laminar/md82cmd/electrical/voltmeter_source_up",0,5,true)

sysElectric.galleyPower = TwoStateToggleSwitch:new("galleypwr","sim/cockpit2/switches/generic_lights_switch",36,
	"sim/lights/generic_37_light_tog")

-- == Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- GPU on bus annunciator
sysElectric.gpuOnBus = CustomAnnunciator:new("gpuonbus",
function () 
	if get("sim/cockpit/electrical/gpu_on") == 1 and 
		get("laminar/md82/electrical/cross_tie_GPU_L") == 1 and
		get("laminar/md82/electrical/cross_tie_GPU_R") == 1 then
		return 1
	else
		return 0
	end
end)


return sysElectric
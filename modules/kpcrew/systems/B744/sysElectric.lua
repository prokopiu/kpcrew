-- B744 airplane 
-- Electric system functionality

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

local sysElectric = {
	acPwrMin = 0,
	acPwrMax = 6,
	
	acPwrSTBY = 0,
	acPwrGRD = 1,
	acPwrGEN1 = 2,
	acPwrAPU = 3,
	acPwrGEN2 = 4,
	acPwrINV = 5,
	acPwrTEST = 6,
	
	dcPwrMin = 0,
	dcPwrMax = 6,
	
	dcPwrSTBY = 0,
	dcPwrBBUS = 1,
	dcPwrBAT = 2,
	dcPwrTR1 = 3,
	dcPwrTR2 = 4,
	dcPwrTR3 = 5,
	dcPwrTEST = 6
}

------------- Switches

-- DC and AC PWR knobs
sysElectric.dcPowerSwitch = MultiStateCmdSwitch:new("dcpower","laminar/B738/knob/dc_power",0,"laminar/B738/knob/dc_power_dn","laminar/B738/knob/dc_power_up")
sysElectric.acPowerSwitch = MultiStateCmdSwitch:new("acpower","laminar/B738/knob/ac_power",0,"laminar/B738/knob/ac_power_dn","laminar/B738/knob/ac_power_up")

-- BATTERY Switch
sysElectric.batterySwitch = TwoStateToggleSwitch:new("bat","sim/cockpit/electrical/battery_array_on",0,"laminar/B747/button_switch/elec_battery")
sysElectric.batteryCover = TwoStateToggleSwitch:new("batcover","laminar/B747/button_switch_cover/position",9,"laminar/B747/button_switch_cover09")

-- Cabin Util Power Boeing
sysElectric.cabUtilPwr = TwoStateToggleSwitch:new("cabutil","laminar/B738/toggle_switch/cab_util_pos",0,"laminar/B738/autopilot/cab_util_toggle")
sysElectric.ifePwr = TwoStateToggleSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,"laminar/B738/autopilot/ife_pass_seat_toggle")

-- Standby Power
sysElectric.stbyPowerSwitch = MultiStateCmdSwitch:new("","laminar/B747/electrical/standby_power/sel_dial_pos",0,"laminar/B747/electrical/standby_power/sel_dial_dn","laminar/B747/electrical/standby_power/sel_dial_up")

-- Ground Power
sysElectric.extGen1Switch = TwoStateToggleSwitch:new("","laminar/B747/elec_ext_pwr_1/switch_mode",0,"laminar/B747/button_switch/elec_ext_pwr_1")
sysElectric.extGen2Switch = TwoStateToggleSwitch:new("","laminar/B747/elec_ext_pwr_1/switch_mode",0,"laminar/B747/button_switch/elec_ext_pwr_2")

-- APU Bus Switches
sysElectric.apuBus1 = TwoStateToggleSwitch:new("","laminar/B747/electrical/apu_pwr1_on",0,"laminar/B747/button_switch/elec_apu_gen_1")
sysElectric.apuBus2 = TwoStateToggleSwitch:new("","laminar/B747/electrical/apu_pwr2_on",0,"laminar/B747/button_switch/elec_apu_gen_2")

-- GEN drive shaft
sysElectric.genDrive1Switch = TwoStateCmdSwitch:new("","laminar/B738/one_way_switch/drive_disconnect1_pos",0,"laminar/B738/one_way_switch/drive_disconnect1","laminar/B738/one_way_switch/drive_disconnect1_off")
sysElectric.genDrive2Switch = TwoStateCmdSwitch:new("","laminar/B738/one_way_switch/drive_disconnect2_pos",0,"laminar/B738/one_way_switch/drive_disconnect2","laminar/B738/one_way_switch/drive_disconnect2_off")
sysElectric.genDriveSwitches = SwitchGroup:new("genDriveSwitches")
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive1Switch)
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive2Switch)

sysElectric.genDrive1Cover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",4,"laminar/B738/button_switch_cover04")
sysElectric.genDrive2Cover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",5,"laminar/B738/button_switch_cover05")
sysElectric.genDriveCovers = SwitchGroup:new("genDriveCovers")
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive1Cover)
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive2Cover)

-- BUS TRANSFER
sysElectric.busTransSwitch = TwoStateCmdSwitch:new("","sim/cockpit2/electrical/cross_tie",0,"sim/electrical/cross_tie_on","sim/electrical/cross_tie_off")
sysElectric.busTransCover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",6,"laminar/B738/button_switch_cover06")

-- GEN Switches
sysElectric.gen1Switch = MultiStateCmdSwitch:new("","laminar/B738/electrical/gen1_pos",0,"laminar/B738/toggle_switch/gen1_dn","laminar/B738/toggle_switch/gen1_up")
sysElectric.gen2Switch = MultiStateCmdSwitch:new("","laminar/B738/electrical/gen2_pos",0,"laminar/B738/toggle_switch/gen2_dn","laminar/B738/toggle_switch/gen2_up")

sysElectric.genSwitchGroup = SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

sysElectric.apuStartSwitch = MultiStateCmdSwitch:new("","laminar/B747/electrical/apu/sel_dial_pos",0,"laminar/B747/electrical/apu/sel_dial_dn","laminar/B747/electrical/apu/sel_dial_up")

-- ======== Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = CustomAnnunciator:new("apurunning",
	function (self) if get("laminar/B747/electrical/apu_pwr1_avail") > 0 or 
	get("laminar/B747/electrical/apu_pwr2_avail") > 0 then return 1 else return 0 end end)
	
-- GPU AVAILABLE annunciator (EXT PWR)
sysElectric.gpuAvailAnc = CustomAnnunciator:new("gpuavail",
	function (self) if get("laminar/B747/electrical/ext_pwr1_avail") > 0 or 
	get("laminar/B747/electrical/ext_pwr2_avail") > 0 then return 1 else return 0 end end)

sysElectric.gpuOnBus = SimpleAnnunciator:new("gpubus","laminar/B747/elec_ext_pwr_1/switch_mode",0)

-- APU GEN BUS OFF
sysElectric.apuOnBus = CustomAnnunciator:new("apubus",function (self) 
if get("laminar/B747/electrical/apu_pwr1_on") > 0 or get("laminar/B747/electrical/apu_pwr2_on") > 0 then return 1 else return 0 end end)

sysElectric.transferBus1 = SimpleAnnunciator:new("trbus1","laminar/B738/annunciator/trans_bus_off1",0)
sysElectric.transferBus2 = SimpleAnnunciator:new("trbus2","laminar/B738/annunciator/trans_bus_off2",0)

sysElectric.sourceOff1 = SimpleAnnunciator:new("srcoff1","laminar/B738/annunciator/source_off1",0)
sysElectric.sourceOff2 = SimpleAnnunciator:new("srcoff2","laminar/B738/annunciator/source_off2",0)

sysElectric.stbyPwrOff = SimpleAnnunciator:new("","laminar/B738/annunciator/standby_pwr_off",0)

sysElectric.gen1off = SimpleAnnunciator:new("","sim/cockpit2/annunciators/generator_off",0)
sysElectric.gen2off = SimpleAnnunciator:new("","sim/cockpit2/annunciators/generator_off",1)

sysElectric.batt1Volt = SimpleAnnunciator:new("bat1volt","sim/cockpit2/electrical/battery_voltage_actual_volts",0)
sysElectric.batt2Volt = SimpleAnnunciator:new("bat2volt","sim/cockpit2/electrical/battery_voltage_actual_volts",1)

return sysElectric
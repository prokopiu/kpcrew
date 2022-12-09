-- B738 airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

------------- Switches

-- DC and AC PWR knobs
sysElectric.dcPowerSwitch 	= MultiStateCmdSwitch:new("dcpower","laminar/B738/knob/dc_power",0,
	"laminar/B738/knob/dc_power_dn","laminar/B738/knob/dc_power_up",0,6,true)
sysElectric.acPowerSwitch 	= MultiStateCmdSwitch:new("acpower","laminar/B738/knob/ac_power",0,
	"laminar/B738/knob/ac_power_dn","laminar/B738/knob/ac_power_up",0,6,true)

-- BATTERY Switch
sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("batter1","laminar/B738/electric/battery_pos",0,
	"laminar/B738/switch/battery_dn","laminar/B738/push_button/batt_full_off")
sysElectric.batteryCover 	= TwoStateToggleSwitch:new("batt1cvr","laminar/B738/button_switch/cover_position",2,
	"laminar/B738/button_switch_cover02")

-- Cabin Util Power Boeing
sysElectric.cabUtilPwr 		= TwoStateToggleSwitch:new("cabutil","laminar/B738/toggle_switch/cab_util_pos",0,
	"laminar/B738/autopilot/cab_util_toggle")
sysElectric.ifePwr 			= TwoStateToggleSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,
	"laminar/B738/autopilot/ife_pass_seat_toggle")

-- Standby Power
sysElectric.stbyPowerSwitch = MultiStateCmdSwitch:new("stbypwr","laminar/B738/electric/standby_bat_pos",0,
	"laminar/B738/switch/standby_bat_left","laminar/B738/switch/standby_bat_right",-1,1,false)
sysElectric.stbyPowerCover 	= TwoStateToggleSwitch:new("stbypwrcvr","laminar/B738/button_switch/cover_position",3,
	"laminar/B738/button_switch_cover03")

-- Ground Power
sysElectric.gpuSwitch 		= MultiStateCmdSwitch:new("GPU","laminar/B738/electric/dc_gnd_service",0,
	"laminar/B738/toggle_switch/gpu_dn","laminar/B738/toggle_switch/gpu_up",-1,1,true)

-- APU Bus Switches
sysElectric.apuGenBus1 		= MultiStateCmdSwitch:new("apubus1","laminar/B738/electrical/apu_gen1_pos",0,
	"laminar/B738/toggle_switch/apu_gen1_up","laminar/B738/toggle_switch/apu_gen1_dn",-1,1,true)
sysElectric.apuGenBus2 		= MultiStateCmdSwitch:new("apubus2","laminar/B738/electrical/apu_gen2_pos",0,
	"laminar/B738/toggle_switch/apu_gen2_up","laminar/B738/toggle_switch/apu_gen2_dn",-1,1,true)

-- GEN drive shaft
sysElectric.genDrive1Switch = TwoStateCmdSwitch:new("drive1","laminar/B738/one_way_switch/drive_disconnect1_pos",0,
	"laminar/B738/one_way_switch/drive_disconnect1","laminar/B738/one_way_switch/drive_disconnect1_off")
sysElectric.genDrive2Switch = TwoStateCmdSwitch:new("drive2","laminar/B738/one_way_switch/drive_disconnect2_pos",0,
	"laminar/B738/one_way_switch/drive_disconnect2","laminar/B738/one_way_switch/drive_disconnect2_off")
sysElectric.genDriveSwitches = SwitchGroup:new("genDriveSwitches")
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive1Switch)
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive2Switch)

sysElectric.genDrive1Cover 	= TwoStateToggleSwitch:new("drive1cvr","laminar/B738/button_switch/cover_position",4,
	"laminar/B738/button_switch_cover04")
sysElectric.genDrive2Cover 	= TwoStateToggleSwitch:new("drive2cvr","laminar/B738/button_switch/cover_position",5,
	"laminar/B738/button_switch_cover05")
sysElectric.genDriveCovers 	= SwitchGroup:new("genDriveCovers")
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive1Cover)
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive2Cover)

-- BUS TRANSFER
sysElectric.busTransSwitch 	= TwoStateCmdSwitch:new("bustrans","sim/cockpit2/electrical/cross_tie",0,
	"sim/electrical/cross_tie_on","sim/electrical/cross_tie_off")
sysElectric.busTransCover 	= TwoStateToggleSwitch:new("bustranscvr","laminar/B738/button_switch/cover_position",6,
	"laminar/B738/button_switch_cover06")

-- GEN Switches
sysElectric.gen1Switch 		= MultiStateCmdSwitch:new("gen1","laminar/B738/electrical/gen1_pos",0,
	"laminar/B738/toggle_switch/gen1_dn","laminar/B738/toggle_switch/gen1_up",-1,1,true)
sysElectric.gen2Switch 		= MultiStateCmdSwitch:new("gen2","laminar/B738/electrical/gen2_pos",0,
	"laminar/B738/toggle_switch/gen2_dn","laminar/B738/toggle_switch/gen2_up",-1,1,true)
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- APU Starter
sysElectric.apuStartSwitch 	= MultiStateCmdSwitch:new("apu","laminar/B738/spring_toggle_switch/APU_start_pos",0,
	"laminar/B738/spring_toggle_switch/APU_start_pos_dn","laminar/B738/spring_toggle_switch/APU_start_pos_up",-1,1,true)

-- Avionics Bus
sysElectric.avionicsBus		= InopSwitch:new("aviobus")

-- ======== Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- GPU AVAILABLE annunciator
sysElectric.gpuAvailAnc 	= CustomAnnunciator:new("gpuavail",function (self) 
if get("laminar/B738/annunciator/ground_power_avail") > 0 or 
	(get("laminar/B738/annunciator/ground_power_avail") == 0 and 
	(get("laminar/B738/electrical/apu_power_bus1") == 1 or 
	get("laminar/B738/electrical/apu_power_bus2") == 1)) then return 1 else return 0 end end)
	
sysElectric.gpuOnBus = SimpleAnnunciator:new("gpubus","sim/cockpit/electrical/gpu_on",0)

-- APU GEN BUS OFF
sysElectric.apuGenBusOff 	= CustomAnnunciator:new("apubus",function (self) 
if get("laminar/B738/annunciator/apu_gen_off_bus") > 0 then return 1 else return 0 end end)
-- if get("laminar/B738/annunciator/apu_gen_off_bus") > 0 or (get("laminar/B738/annunciator/apu_gen_off_bus") == 0 and (get("laminar/B738/electrical/apu_power_bus1") == 1 or get("laminar/B738/electrical/apu_power_bus2") == 1)) then return 1 else return 0 end end)

sysElectric.transferBus1 	= SimpleAnnunciator:new("trbus1","laminar/B738/annunciator/trans_bus_off1",0)
sysElectric.transferBus2 	= SimpleAnnunciator:new("trbus2","laminar/B738/annunciator/trans_bus_off2",0)

sysElectric.sourceOff1 		= SimpleAnnunciator:new("srcoff1","laminar/B738/annunciator/source_off1",0)
sysElectric.sourceOff2 		= SimpleAnnunciator:new("srcoff2","laminar/B738/annunciator/source_off2",0)

sysElectric.stbyPwrOff 		= SimpleAnnunciator:new("stbypwroff","laminar/B738/annunciator/standby_pwr_off",0)

sysElectric.gen1off 		= SimpleAnnunciator:new("gen1off","sim/cockpit2/annunciators/generator_off",0)
sysElectric.gen2off 		= SimpleAnnunciator:new("gen2off","sim/cockpit2/annunciators/generator_off",1)

sysElectric.batt1Volt 		= SimpleAnnunciator:new("bat1volt","sim/cockpit2/electrical/battery_voltage_actual_volts",0)
sysElectric.batt2Volt 		= SimpleAnnunciator:new("bat2volt","sim/cockpit2/electrical/battery_voltage_actual_volts",1)

return sysElectric
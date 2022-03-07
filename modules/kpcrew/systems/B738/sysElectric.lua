-- B738 airplane 
-- Electric system functionality

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
sysElectric.batterySwitch = TwoStateCmdSwitch:new("","laminar/B738/electric/battery_pos",0,"laminar/B738/push_button/batt_full_off","laminar/B738/switch/battery_dn")
sysElectric.batteryCover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",2,"laminar/B738/button_switch_cover02")

-- Cabin Util Power Boeing
sysElectric.cabUtilPwr = TwoStateToggleSwitch:new("cabutil","laminar/B738/toggle_switch/cab_util_pos",0,"laminar/B738/autopilot/cab_util_toggle")
sysElectric.ifePwr = TwoStateToggleSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,"laminar/B738/autopilot/ife_pass_seat_toggle")

-- Standby Power
sysElectric.stbyPowerSwitch = MultiStateCmdSwitch:new("","laminar/B738/electric/standby_bat_pos",0,"laminar/B738/switch/standby_bat_left","laminar/B738/switch/standby_bat_right")
sysElectric.stbyPowerCover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",3,"laminar/B738/button_switch_cover03")

-- Ground Power
sysElectric.gpuSwitch = MultiStateCmdSwitch:new("","laminar/B738/electric/dc_gnd_service",0,"laminar/B738/toggle_switch/gpu_dn","laminar/B738/toggle_switch/gpu_up")

-- APU Bus Switches
sysElectric.apuGenBus1 = MultiStateCmdSwitch:new("","laminar/B738/electrical/apu_power_bus1",0,"laminar/B738/toggle_switch/apu_gen1_dn","laminar/B738/toggle_switch/apu_gen1_up")
sysElectric.apuGenBus2 = MultiStateCmdSwitch:new("","laminar/B738/electrical/apu_power_bus2",0,"laminar/B738/toggle_switch/apu_gen2_dn","laminar/B738/toggle_switch/apu_gen2_up")


-- GEN drive shaft
sysElectric.genDrive1Switch = TwoStateCmdSwitch:new("","laminar/B738/one_way_switch/drive_disconnect1_pos",0,"laminar/B738/one_way_switch/drive_disconnect1","laminar/B738/one_way_switch/drive_disconnect1_off")
sysElectric.genDrive2Switch = TwoStateCmdSwitch:new("","laminar/B738/one_way_switch/drive_disconnect2_pos",0,"laminar/B738/one_way_switch/drive_disconnect2","laminar/B738/one_way_switch/drive_disconnect2_off")

sysElectric.genDrive1Cover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",4,"laminar/B738/button_switch_cover04")
sysElectric.genDrive2Cover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",5,"laminar/B738/button_switch_cover05")

-- BUS TRANSFER
sysElectric.busTransSwitch = TwoStateCmdSwitch:new("","sim/cockpit2/electrical/cross_tie",0,"sim/electrical/cross_tie_on","sim/electrical/cross_tie_off")
sysElectric.busTransCover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",6,"laminar/B738/button_switch_cover06")

-- ======== Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- GPU AVAILABLE annunciator
sysElectric.gpuAvailAnc = CustomAnnunciator:new("gpuavail",function (self) 
if get("laminar/B738/annunciator/ground_power_avail") > 0 or (get("laminar/B738/annunciator/ground_power_avail") == 0 and (get("laminar/B738/electrical/apu_power_bus1") == 1 or get("laminar/B738/electrical/apu_power_bus2") == 1)) then return 1 else return 0 end end)
sysElectric.gpuOnBus = CustomAnnunciator:new("apubus",function (self) 
if get("laminar/B738/electric/dc_gnd_service") > 0 or (get("laminar/B738/electric/dc_gnd_service") == 0 and (get("laminar/B738/electrical/apu_power_bus1") == 1 or get("laminar/B738/electrical/apu_power_bus2") == 1)) then return 1 else return 0 end end)

-- APU GEN BUS OFF
sysElectric.apuGenBusOff = CustomAnnunciator:new("apubus",function (self) 
if get("laminar/B738/annunciator/apu_gen_off_bus") > 0 or (get("laminar/B738/annunciator/apu_gen_off_bus") == 0 and (get("laminar/B738/electrical/apu_power_bus1") == 1 or get("laminar/B738/electrical/apu_power_bus2") == 1)) then return 1 else return 0 end end)

sysElectric.transferBus1 = SimpleAnnunciator:new("trbus1","laminar/B738/annunciator/trans_bus_off1",0)
sysElectric.transferBus2 = SimpleAnnunciator:new("trbus2","laminar/B738/annunciator/trans_bus_off2",0)

sysElectric.sourceOff1 = SimpleAnnunciator:new("srcoff1","laminar/B738/annunciator/source_off1",0)
sysElectric.sourceOff2 = SimpleAnnunciator:new("srcoff2","laminar/B738/annunciator/source_off2",0)

sysElectric.stbyPwrOff = SimpleAnnunciator:new("","laminar/B738/annunciator/standby_pwr_off",0)

return sysElectric
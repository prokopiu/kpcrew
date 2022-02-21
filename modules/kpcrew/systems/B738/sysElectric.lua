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

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch = require "kpcrew.systems.InopSwitch"

------------- Switches

-- DC and AC PWR knobs
sysElectric.dcPowerSwitch = MultiStateCmdSwitch:new("dcpower","laminar/B738/knob/dc_power",0,"laminar/B738/knob/dc_power_dn","laminar/B738/knob/dc_power_up")
sysElectric.acPowerSwitch = MultiStateCmdSwitch:new("acpower","laminar/B738/knob/ac_power",0,"laminar/B738/knob/ac_power_dn","laminar/B738/knob/ac_power_up")

-- BATTERY Switch
sysElectric.batterySwitch = TwoStateCustomSwitch:new("battery","laminar/B738/electric/battery_pos",0,
function ()
	if get("laminar/B738/button_switch/cover_position",2) == 1 then
		command_once("laminar/B738/button_switch_cover02")
	end
	command_once("sim/electrical/battery_1_on")
	command_once("laminar/B738/switch/battery_dn")
end,
function ()
		if get("laminar/B738/button_switch/cover_position",2) == 0 then
			command_once("laminar/B738/button_switch_cover02")
		end
		command_once("sim/electrical/battery_1_off")
		command_once("laminar/B738/push_button/batt_full_off")
end,	
function ()
	if get("laminar/B738/electric/battery_pos") == 0 then
		self.funcOn()
	else
		self.funcOff()
	end
end)

-- Cabin Util Power Boeing
sysElectric.cabUtilPwr = TwoStateToggleSwitch:new("cabutil","laminar/B738/toggle_switch/cab_util_pos",0,"laminar/B738/autopilot/cab_util_toggle")
sysElectric.ifePwr = TwoStateToggleSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,"laminar/B738/autopilot/ife_pass_seat_toggle")

-- Standby Power
sysElectric.stbyPowerCover = TwoStateToggleSwitch:new("","laminar/B738/button_switch/cover_position",3,"laminar/B738/button_switch_cover03")

-- Ground Power
sysElectric.gpuSwitch = MultiStateCmdSwitch:new("","laminar/B738/electric/dc_gnd_service",0,"laminar/B738/toggle_switch/gpu_dn","laminar/B738/toggle_switch/gpu_up")

-- APU Bus Switches
sysElectric.apuGenBus1 = MultiStateCmdSwitch:new("","laminar/B738/electrical/apu_power_bus1",0,"laminar/B738/toggle_switch/apu_gen1_dn","laminar/B738/toggle_switch/apu_gen1_up")
sysElectric.apuGenBus2 = MultiStateCmdSwitch:new("","laminar/B738/electrical/apu_power_bus2",0,"laminar/B738/toggle_switch/apu_gen2_dn","laminar/B738/toggle_switch/apu_gen2_up")

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

return sysElectric
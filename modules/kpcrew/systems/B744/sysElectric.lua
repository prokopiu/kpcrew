-- B747 MSPARKS Rotate airplane 
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

logMsg("B744 sysElectric")

-- BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch = TwoStateToggleSwitch:new("bat","sim/cockpit/electrical/battery_array_on",0,
	"laminar/B747/button_switch/elec_battery")
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.batteryCover = TwoStateToggleSwitch:new("batcover","laminar/B747/button_switch_cover/position",9,
	"laminar/B747/button_switch_cover09")

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","laminar/B747/electrical/ext_pwr1_avail",0,
function ()
	if get("laminar/B747/electrical/ext_pwr1_avail") == 0 then
		command_once("laminar/B747/electrical/connect_power")
	end
end,
function ()
	if get("laminar/B747/electrical/ext_pwr1_avail") ~= 0 then
		command_once("laminar/B747/electrical/connect_power")
	end
end,
function ()
end,
function ()
	return get("laminar/B747/electrical/ext_pwr1_avail")
end)	
sysElectric.gpuGenBus1 		= TwoStateCustomSwitch:new("gpubus1","laminar/B747/electrical/topleftbus",0,
	function ()
		if get("laminar/B747/electrical/topleftbus") == 0 then
			command_once("laminar/B747/button_switch/elec_ext_pwr_1")
		end
	end,
	function ()
		if get("laminar/B747/electrical/topleftbus") ~= 0 then
			command_once("laminar/B747/button_switch/elec_ext_pwr_1")
		end
	end,
	function ()
	end,
	function ()
		return get("laminar/B747/electrical/topleftbus")
	end)
	
sysElectric.gpuGenBus2 		= TwoStateCustomSwitch:new("goubus2","laminar/B747/electrical/toprightbus",0,
	function ()
		if get("laminar/B747/electrical/toprightbus") == 0 then
			command_once("laminar/B747/button_switch/elec_ext_pwr_2")
		end
	end,
	function ()
		if get("laminar/B747/electrical/toprightbus") ~= 0 then
			command_once("laminar/B747/button_switch/elec_ext_pwr_2")
		end
	end,
	function ()
	end,
	function ()
		return get("laminar/B747/electrical/toprightbus")
	end)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
if kc_has_apu then
	sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","sim/cockpit2/electrical/APU_starter_switch",0)
	sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","sim/cockpit2/electrical/APU_starter_switch",0)
	sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","laminar/B747/electrical/apu_pwr1_on",0)
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2","laminar/B747/electrical/apu_pwr2_on",0)
else
	sysElectric.apuMaster	 	= InopSwitch:new("apuswitch")
	sysElectric.apuStartSwitch 	= InopSwitch:new("apuswitch")
	sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
end
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("sim/cockpit/engine/APU_N1") > 98 then
			return 1
		else
			return 0
		end
	end)

-- ---- Inverters
sysElectric.dcBusTie1 		= TwoStateToggleSwitch:new("bustie1","laminar/B747/electrical/bus1hot",0,
	"laminar/B747/button_switch/elec_bus_tie_1")
sysElectric.dcBusTie2 		= TwoStateToggleSwitch:new("bustie2","laminar/B747/electrical/bus2hot",0,
	"laminar/B747/button_switch/elec_bus_tie_2")
sysElectric.dcBusTie3 		= TwoStateToggleSwitch:new("bustie3","laminar/B747/electrical/bus3hot",0,
	"laminar/B747/button_switch/elec_bus_tie_3")
sysElectric.dcBusTie4 		= TwoStateToggleSwitch:new("bustie4","laminar/B747/electrical/bus4hot",0,
	"laminar/B747/button_switch/elec_bus_tie_4")
sysElectric.dcBusTie			 	= SwitchGroup:new("bus ties")
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie1)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie2)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie3)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie4)

-- standby power
sysElectric.stbyPowerSwitch = TwoStateCustomSwitch:new("stbySwitch","laminar/B747/electrical/standby_power/sel_dial_pos",0,
	function ()
		command_once("laminar/B747/electrical/standby_power/sel_dial_dn")
		command_once("laminar/B747/electrical/standby_power/sel_dial_dn")
		command_once("laminar/B747/electrical/standby_power/sel_dial_up")
	end,
	function ()
		command_once("laminar/B747/electrical/standby_power/sel_dial_dn")
		command_once("laminar/B747/electrical/standby_power/sel_dial_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/electrical/standby_power/sel_dial_pos") > 0 then
			return 1
		else
			return 0
		end
	end)
	
sysElectric.gpuOnBus = SimpleAnnunciator:new("","laminar/B747/electrical/topleftbus",0)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateToggleSwitch:new("gen1","sim/cockpit/electrical/generator_on",-1,
	"laminar/B747/button_switch/elec_gen_ctrl_1")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 	= TwoStateToggleSwitch:new("gen2","sim/cockpit/electrical/generator_on",1,
	"laminar/B747/button_switch/elec_gen_ctrl_2")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
sysElectric.gen3Switch 		= TwoStateToggleSwitch:new("gen3","sim/cockpit/electrical/generator_on",2,
	"laminar/B747/button_switch/elec_gen_ctrl_3")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
sysElectric.gen4Switch 		= TwoStateToggleSwitch:new("gen4","sim/cockpit/electrical/generator_on",3,
	"laminar/B747/button_switch/elec_gen_ctrl_4")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)


return sysElectric


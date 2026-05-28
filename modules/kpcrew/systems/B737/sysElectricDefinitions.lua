-- B737 airplane 
-- Hydraulic functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
Systems covered:	
Batteries:			 
]]

--[[
	template = {
		etype = type_...,
		name = "name",
		drefName = "name of dref",
		drefIndex = 0,
		cmd1 = "on, tgl or dn",
		cmd2 = "off or up",
		cmd3 = "tgl",
		msMin = minimum,
		msMax = maximum,
		msRead = true/false,
		msDiff = difference,
		funcOn = function...,
		funcOff = function ...,
		funcTgl = function ...,
		funcStat = function ...,
		funcStep = function...,
		funcSet = function
	}
]]

local def = require("kpcrew.systems.DFLT.sysElectricDefinitions")

kc_has_batteries	= true		-- Aircraft has batteries
kc_num_batteries	= 1
kc_has_generators	= true		-- Aircraft has engine generators
kc_num_generators	= 2
kc_has_inverters	= false		-- Aircraft has inverters			
kc_num_inverters	= 2			
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_gpu_gens		= true		-- Aircraft has GPU generators
kc_num_gpu_gens		= 1	
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_apu			= true		-- Aircraft has an APU
kc_has_apu_master	= false		-- Aircraft (Airbus) have also APU Master
kc_has_apu_gens		= true		-- Aircraft has APU generators
kc_num_apu_gens		= 2	
kc_has_standby_pwr	= true		-- Aircraft has standby power
kc_num_standby_pwr	= 1
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_num_avionics_sw  = 2	
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC

-- === For Briefing

--[[
System Elements:
sysElectric.btGroup 	
	sysElectric.btSwitch1 	
	sysElectric.btSwitch2 
	sysElectric.btSwitch3 	
sysElectric.genSwitchGroup
	sysElectric.genSwitch1
	sysElectric.genSwitch2
	sysElectric.genSwitch3
	sysElectric.genSwitch4
sysElectric.inverterSwitchGroup
	sysElectric.inverterSwitch1 		
	sysElectric.inverterSwitch2 		
sysElectric.gpuConnect
sysElectric.gpuGenBusGroup
	sysElectric.gpuGenBus1
	sysElectric.gpuGenBus2	
sysElectric.apuStart
sysElectric.apuMaster	 
sysElectric.apuGenBusGroup
	sysElectric.apuGenBus1 	
	sysElectric.apuGenBus2 	
sysElectric.stbyPowerGroup
	sysElectric.stbyPowerSwitch1
	sysElectric.stbyPowerSwitch2
sysElectric.avionicsSwitchGroup
	sysElectric.avionicsBus1
	sysElectric.avionicsBus2
sysElectric.dcBusTie
sysElectric.acBusTie
]]

sysElectricDefinitions = {

	btSwitch1 = {
		etype = kc_swtype_customCmd,
		name = "Battery 1",
		drefName = "laminar/B738/electric/battery_pos",
		drefIndex = 0,
		funcOn = function () command_once("laminar/B738/switch/battery_dn") if get("laminar/B738/button_switch/cover_position",2) ~= 0 then command_once("laminar/B738/button_switch_cover02") end end,
		funcOff = function () if get("laminar/B738/button_switch/cover_position",2) == 0 then command_once("laminar/B738/button_switch_cover02") end command_once("laminar/B738/push_button/batt_full_off") end,
		funcTgl = function () 
		    if get("sim/cockpit/electrical/battery_on",0) == 0 then
			  command_once("laminar/B738/switch/battery_dn")
			  if get("laminar/B738/button_switch/cover_position",2) ~= 0 then command_once("laminar/B738/button_switch_cover02") end
			else
			  command_once("laminar/B738/push_button/batt_full_off")
			  if get("laminar/B738/button_switch/cover_position",2) == 0 then command_once("laminar/B738/button_switch_cover02") end
		    end
		end,
		funcStat = function () if get("laminar/B738/electric/battery_pos",0) == 1 then return 1 else return 0 end end
	},
	genSwitch1 = {
		etype = kc_swtype_dref,
		name = "Gen 1",
		drefName = "laminar/B738/electrical/gen1_pos",
		drefIndex = 0
	},
	genSwitch2 = {
		etype = kc_swtype_dref,
		name = "Gen 2",
		drefName = "laminar/B738/electrical/gen2_pos",
		drefIndex = 0
	},
	gpuConnect = {
		etype = kc_swtype_customCmd,
		name = "GPU Connect",
		drefName = "laminar/B738/gpu_available",
		drefIndex = 0,
		funcOn = function () if get("laminar/B738/gpu_available") == 0 then command_once("laminar/B738/gpu_toggle") end end,
		funcOff = function () if get("laminar/B738/gpu_available") == 1 then command_once("laminar/B738/gpu_toggle") end end,
		funcTgl = function () command_once("laminar/B738/gpu_toggle") end,
		funcStat = function () return get("laminar/B738/gpu_available") end
	},
	gpuGenBus1 = {
		etype = kc_swtype_2StateCmd,
		name = "GPU Gen 1",
		drefName = "sim/cockpit2/electrical/GPU_generator_on",
		drefIndex = 0,
		cmd1 = "laminar/B738/toggle_switch/gpu_dn",
		cmd2 = "laminar/B738/toggle_switch/gpu_up",
		cmd3 = "nocommand"
	},
	apuStart = {
		etype = kc_swtype_multistate,
		name = "APU Start",
		drefName = "laminar/B738/spring_toggle_switch/APU_start_pos",
		drefIndex = 0,
		cmd1 = "laminar/B738/spring_toggle_switch/APU_start_pos_dn",
		cmd2 = "laminar/B738/spring_toggle_switch/APU_start_pos_up",
		msMin = -1,
		msMax = 1,
		msRead = true
	},
	apuGenBus1 = {
		etype = kc_swtype_multistate,
		name = "APU Bus Gen 1",
		drefName = "laminar/B738/electrical/apu_gen1_pos",
		drefIndex = 0,
		cmd1 = "laminar/B738/toggle_switch/apu_gen1_up",
		cmd2 = "laminar/B738/toggle_switch/apu_gen1_dn",
		msMin = -1,
		msMax = 1,
		msRead = true
	},
	apuGenBus2 = {
		etype = kc_swtype_multistate,
		name = "APU Bus Gen 2",
		drefName = "laminar/B738/electrical/apu_gen2_pos",
		drefIndex = 0,
		cmd1 = "laminar/B738/toggle_switch/apu_gen2_up",
		cmd2 = "laminar/B738/toggle_switch/apu_gen2_dn",
		msMin = -1,
		msMax = 1,
		msRead = true
	},
	stbyPowerSwitch1 = {
		etype = kc_swtype_customCmd,
		name = "STBY Switch 1",
		drefName = "laminar/B738/electric/standby_bat_pos",
		drefIndex = 0,
		funcOn = function () command_once("laminar/B738/switch/standby_bat_on") 
			if get("laminar/B738/button_switch/cover_position",3) ~= 0 then command_once("laminar/B738/button_switch_cover03") end end,
		funcOff = function () if get("laminar/B738/button_switch/cover_position",3) == 0 then command_once("laminar/B738/button_switch_cover03") end
			command_once("laminar/B738/switch/standby_bat_off") end,
		funcTgl = function () if get("laminar/B738/electric/standby_bat_pos") == 0 then 
			command_once("laminar/B738/switch/standby_bat_right")
			if get("laminar/B738/button_switch/cover_position",3) ~= 0 then command_once("laminar/B738/button_switch_cover03") end
			else command_once("laminar/B738/switch/standby_bat_left")
				if get("laminar/B738/button_switch/cover_position",3) == 0 then command_once("laminar/B738/button_switch_cover03") end end end,
		funcStat = function () if get("laminar/B738/electric/standby_bat_pos") == 1 then return 1 else return 0 end end
	},
	dcBusTie = {
		etype = kc_swtype_inop,
		name = "DC Bus Tie"
	},
	acBusTie = {
		etype = kc_swtype_customCmd,
		name = "AC Bus Tie",
		drefName = "sim/cockpit2/electrical/cross_tie",
		drefIndex = 0,
		funcOn = function () command_once("sim/electrical/cross_tie_on") 
			if get("laminar/B738/button_switch/cover_position",6) ~= 0 then command_once("laminar/B738/button_switch_cover06") end end,
		funcOff = function () if get("laminar/B738/button_switch/cover_position",6) == 0 then command_once("laminar/B738/button_switch_cover06") end
			command_once("sim/electrical/cross_tie_off") end,
		funcTgl = function () 
		    if get("sim/cockpit2/electrical/cross_tie",0) == 0 then
			  command_once("sim/electrical/cross_tie_on")
			  if get("laminar/B738/button_switch/cover_position",6) ~= 0 then command_once("laminar/B738/button_switch_cover06") end
			else
			  command_once("sim/electrical/cross_tie_off")
			  if get("laminar/B738/button_switch/cover_position",6) == 0 then command_once("laminar/B738/button_switch_cover06") end
		    end
		end,
		funcStat = function () if get("sim/cockpit2/electrical/cross_tie") == 1 then return 1 else return 0 end end
	},
	apuRunningAnc = {
		etype = kc_swtype_customAnn,
		name = "apu running Ann",
		funcOn = function () if get("laminar/B738/annunciator/apu_gen_off_bus") > 0 then return 1 else return 0 end end
	},
	lowVoltageAnc = {
		etype = kc_swtype_annunciator,
		name = "Low voltage",
		drefName = "sim/cockpit2/annunciators/low_voltage",
		drefIndex = 0
	},
	gpuOnBus = {
		etype = kc_swtype_annunciator,
		name = "GPU on bus",
		drefName = "laminar/B738/gpu_available",
		drefIndex = 0
	}
}

return sysElectricDefinitions
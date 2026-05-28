-- DFLT airplane 
-- Electric functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

kc_has_batteries	= true		-- Aircraft has batteries
kc_num_batteries	= 3
kc_has_generators	= true		-- Aircraft has engine generators
kc_num_generators	= 4
kc_has_inverters	= false		-- Aircraft has inverters			
kc_num_inverters	= 2			
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_gpu_gens		= true		-- Aircraft has GPU generators
kc_num_gpu_gens		= 1	
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_apu			= true		-- Aircraft has an APU
kc_has_apu_master	= false		-- Aircraft (Airbus) have also APU Master
kc_has_apu_gens		= true		-- Aircraft has APU generators
kc_num_apu_gens		= 1	
kc_has_standby_pwr	= false		-- Aircraft has standby power
kc_num_standby_pwr	= 1
kc_has_avionics_sw  = true		-- Aircraft has Avionics switch
kc_num_avionics_sw  = 2	
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC

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
		etype = kc_swtype_dref,
		name = "Battery 1",
		drefName = "sim/cockpit2/electrical/battery_on",
		drefIndex = -1
	},
	btSwitch2 = {
		etype = kc_swtype_dref,
		name = "Battery 2",
		drefName = "sim/cockpit2/electrical/battery_on",
		drefIndex = 1
	},
	btSwitch3 = {
		etype = kc_swtype_dref,
		name = "Battery 3",
		drefName = "sim/cockpit2/electrical/battery_on",
		drefIndex = 2
	},
	genSwitch1 = {
		etype = kc_swtype_dref,
		name = "Gen 1",
		drefName = "sim/cockpit2/electrical/generator_on",
		drefIndex = -1
	},
	genSwitch2 = {
		etype = kc_swtype_dref,
		name = "Gen 2",
		drefName = "sim/cockpit2/electrical/generator_on",
		drefIndex = 1
	},
	genSwitch3 = {
		etype = kc_swtype_dref,
		name = "Gen 3",
		drefName = "sim/cockpit2/electrical/generator_on",
		drefIndex = 2
	},
	genSwitch4 = {
		etype = kc_swtype_dref,
		name = "Gen 4",
		drefName = "sim/cockpit2/electrical/generator_on",
		drefIndex = 3
	},
	inverterSwitch1 = {
		etype = kc_swtype_dref,
		name = "Inverter 1",
		drefName = "sim/cockpit2/electrical/inverter_on",
		drefIndex = -1
	},
	inverterSwitch2 = {
		etype = kc_swtype_dref,
		name = "Inverter 2",
		drefName = "sim/cockpit2/electrical/inverter_on",
		drefIndex = 1
	},
	gpuConnect = {
		etype = kc_swtype_customCmd,
		name = "GPU Connect",
		drefName = "sim/cockpit2/electrical/GPU_generator_on",
		drefIndex = 0,
		funcOn = function () set("sim/cockpit2/electrical/GPU_generator_on",1) command_once("sim/ground_ops/service_plane") end,
		funcOff = function () set("sim/cockpit2/electrical/GPU_generator_on",0) end,
		funcTgl = function () end,
		funcStat = function () return get("sim/cockpit2/electrical/GPU_generator_on") end
	},
	gpuGenBus1 = {
		etype = kc_swtype_dref,
		name = "GPU Gen 1",
		drefName = "sim/cockpit2/electrical/GPU_generator_on",
		drefIndex = 0
	},
	gpuGenBus2 = {
		etype = kc_swtype_inop,
		name = "GPU Gen 2"
	},
	apuStart = {
		etype = kc_swtype_dref,
		name = "APU Start",
		drefName = "sim/cockpit2/electrical/APU_starter_switch",
		drefIndex = 0
	},
	apuMaster = {
		etype = kc_swtype_inop,
		name = "APU Master"
	},
	apuGenBus1 = {
		etype = kc_swtype_dref,
		name = "APU Bus Gen 1",
		drefName = "sim/cockpit2/electrical/APU_generator_on",
		drefIndex = 0
	},
	apuGenBus2 = {
		etype = kc_swtype_inop,
		name = "APU Bus Gen 2"
	},
	stbyPowerSwitch1 = {
		etype = kc_swtype_inop,
		name = "STBY Switch 1"
	},
	stbyPowerSwitch2 = {
		etype = kc_swtype_inop,
		name = "STBY Switch 2"
	},
	avionicsBus1 = {
		etype = kc_swtype_dref,
		name = "Avionic Switch 1",
		drefName = "sim/cockpit2/switches/avionics_power_on",
		drefIndex = -1
	},
	avionicsBus2 = {
		etype = kc_swtype_dref,
		name = "Avionic Switch 2",
		drefName = "sim/cockpit2/switches/avionics_power_on",
		drefIndex = 1
	},
	dcBusTie = {
		etype = kc_swtype_dref,
		name = "DC Bus Tie",
		drefName = "sim/cockpit2/switches/avionics_power_on",
		drefIndex = 0
	},
	acBusTie = {
		etype = kc_swtype_inop,
		name = "AC Bus Tie"
	},
	apuRunningAnc = {
		etype = kc_swtype_customAnn,
		name = "apu running Ann",
		funcOn = function () if get("sim/cockpit/engine/APU_N1") > 98 then return 1 else return 0 end end
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
		drefName = "sim/cockpit2/electrical/GPU_generator_on",
		drefIndex = 0
	}
}

return sysElectricDefinitions
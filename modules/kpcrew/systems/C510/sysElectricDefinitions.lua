-- C510 airplane 
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
kc_has_apu			= false		-- Aircraft has an APU
kc_has_apu_master	= false		-- Aircraft (Airbus) have also APU Master
kc_has_apu_gens		= false		-- Aircraft has APU generators
kc_num_apu_gens		= 1	
kc_has_standby_pwr	= true		-- Aircraft has standby power
kc_num_standby_pwr	= 1
kc_has_avionics_sw  = true		-- Aircraft has Avionics switch
kc_num_avionics_sw  = 1	
kc_has_bus_ties		= false		-- Aircraft has bus ties for AC & DC

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
		drefName = "vskylabs/510x/electrical/bat_emer_sw",
		drefIndex = 0,
		funcOn = function () set("vskylabs/510x/electrical/bat_emer_sw",2) end,
		funcOff = function () set("vskylabs/510x/electrical/bat_emer_sw",1) end,
		funcTgl = function () if get("vskylabs/510x/electrical/bat_emer_sw") == 1 then set("vskylabs/510x/electrical/bat_emer_sw",2)
			else set("vskylabs/510x/electrical/bat_emer_sw",1) end end,
		funcStat = function () return get("vskylabs/510x/electrical/bat_emer_sw") -1 end		
	},
	genSwitch1 = {
		etype = kc_swtype_customCmd,
		name = "Gen 1",
		drefName = "vskylabs/510x/electrical/gen0_off_reset_sw",
		drefIndex = 0,
		funcOn = function () set("vskylabs/510x/electrical/gen0_off_reset_sw",2) end,
		funcOff = function () set("vskylabs/510x/electrical/gen0_off_reset_sw",1) end,
		funcTgl = function () if get("vskylabs/510x/electrical/gen0_off_reset_sw") < 2 then set("vskylabs/510x/electrical/gen0_off_reset_sw",2)
			else set("vskylabs/510x/electrical/gen0_off_reset_sw",1) end end,
		funcStat = function () return get("vskylabs/510x/electrical/gen0_off_reset_sw") -1 end
	},
	genSwitch2 = {
		etype = kc_swtype_customCmd,
		name = "Gen 2",
		drefName = "vskylabs/510x/electrical/gen1_off_reset_sw",
		drefIndex = 0,
		funcOn = function () set("vskylabs/510x/electrical/gen1_off_reset_sw",2) end,
		funcOff = function () set("vskylabs/510x/electrical/gen1_off_reset_sw",1) end,
		funcTgl = function () if get("vskylabs/510x/electrical/gen1_off_reset_sw") < 2 then set("vskylabs/510x/electrical/gen1_off_reset_sw",2)
			else set("vskylabs/510x/electrical/gen1_off_reset_sw",1) end end,
		funcStat = function () return get("vskylabs/510x/electrical/gen1_off_reset_sw") -1 end
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
	stbyPowerSwitch1 = {
		etype = kc_swtype_customCmd,
		name = "STBY Switch 1",
		drefName = "vskylabs/510x/electrical/stby_avionics_sw",
		drefIndex = 0,
		funcOn = function () set("vskylabs/510x/electrical/stby_avionics_sw",2) end,
		funcOff = function () set("vskylabs/510x/electrical/stby_avionics_sw",1) end,
		funcTgl = function () if get("vskylabs/510x/electrical/stby_avionics_sw") < 2 then set("vskylabs/510x/electrical/stby_avionics_sw",2)
			else set("vskylabs/510x/electrical/stby_avionics_sw",1) end end,
		funcStat = function () return get("vskylabs/510x/electrical/stby_avionics_sw") -1 end
	},
	avionicsBus1 = {
		etype = kc_swtype_dref,
		name = "Avionic Switch 1",
		drefName = "sim/cockpit2/switches/avionics_power_on",
		drefIndex = 0
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
	},
	apuRunningAnc = {
		etype = kc_swtype_customAnn,
		name = "apu running Ann",
		funcOn = function () if get("sim/cockpit/engine/APU_N1") > 98 then return 1 else return 0 end end
	}
}

return sysElectricDefinitions
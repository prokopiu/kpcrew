-- DFLT airplane 
-- Engines functionality

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

kc_num_engines		= -1		-- Number of engines from acf
kc_has_ignition		= true		-- Aircraft has ignition switches
kc_num_ignition		= 4
kc_has_reversers	= true		-- Aircraft has reversers
kc_num_reversers	= 4
kc_has_magneto_sw	= false		-- Aircraft has magneto switches
kc_num_magneto_sw	= 4

kc_ab_engm_norm		= 1			-- Airbus engine mode norm
kc_ab_engm_strt		= 2			-- Airbus engine mode start
kc_ab_engm_crnk		= 0			-- Airbus engine mode crank
kc_has_rated_to		= false		-- Aircraft has rated thrust setting for T/O
kc_has_proplever	= false		-- Aircraft has prop lever
kc_prop_lvr_min		= 125		-- Prop lever Minimum
kc_prop_lvr_feather	= 105		-- Prop lever feather
kc_prop_lvr_max		= 178		-- Prop lever maximum
kc_has_mixlever		= false		-- Airctaft has mixture lever
kc_mixture_off		= 0
kc_mixture_min		= 0.4
kc_mixture_rich		= 1
kc_n2_after_start	= 40
kc_needs_throttle_idle = true	-- Aircraft needs idle throttle on start

--[[
System Elements
sysEngines.engStarterGroup
	sysEngines.engStartSwitch1
	sysEngines.engStartSwitch2
	sysEngines.engStartSwitch3 	
	sysEngines.engStartSwitch4
sysEngines.engineStarterAnc - 1 if a starter is running

sysEngines.engIgnitionGroup - Ignition Switches
	sysEngines.engIgnition1	
	sysEngines.engIgnition2
	sysEngines.engIgnition3
	sysEngines.engIgnition4

sysEngines.reverserGroup  - activate reversers for engines
	sysEngines.reverser1
	sysEngines.reverser2
	sysEngines.reverser3
	sysEngines.reverser4
sysEngines.reverseAnc

sysEngines.magnetoGroup 
sysEngines.magneto1 
sysEngines.magneto2
sysEngines.magneto3
sysEngines.magneto4

sysEngines.throttlePos
sysEngines.mixtureLever
sysEngines.propLever
sysEngines.engineFireAnc
sysEngines.OilPressureAnc

sysEngines.oilqty1
sysEngines.oilqty2
sysEngines.oilqty3
sysEngines.oilqty4

]]

sysEnginesDefinitions = {

	engStartSwitch1 = {
		etype = kc_swtype_customCmd,
		name = "Eng Starter 1",
		drefName = "sim/flightmodel2/engines/starter_is_running",
		drefIndex = -1,
		funcOn = function () kc_procvar_set("engstart1",true) end,
		funcOff = function () kc_procvar_set("engstart1",false) end,
		funcTgl = function () end,
		funcStat = function () return get("sim/flightmodel2/engines/starter_is_running",0) end
	},
	engStartSwitch2 = {
		etype = kc_swtype_customCmd,
		name = "Eng Starter 2",
		drefName = "sim/flightmodel2/engines/starter_is_running",
		drefIndex = 1,
		funcOn = function () kc_procvar_set("engstart2",true) end,
		funcOff = function () kc_procvar_set("engstart2",false) end,
		funcTgl = function () end,
		funcStat = function () return get("sim/flightmodel2/engines/starter_is_running",1) end
	},
	engStartSwitch3 = {
		etype = kc_swtype_customCmd,
		name = "Eng Starter 3",
		drefName = "sim/flightmodel2/engines/starter_is_running",
		drefIndex = 2,
		funcOn = function () kc_procvar_set("engstart3",true) end,
		funcOff = function () kc_procvar_set("engstart3",false) end,
		funcTgl = function () end,
		funcStat = function () return get("sim/flightmodel2/engines/starter_is_running",2) end
	},
	engStartSwitch4 = {
		etype = kc_swtype_customCmd,
		name = "Eng Starter 4",
		drefName = "sim/flightmodel2/engines/starter_is_running",
		drefIndex = 3,
		funcOn = function () kc_procvar_set("engstart4",true) end,
		funcOff = function () kc_procvar_set("engstart4",false) end,
		funcTgl = function () end,
		funcStat = function () return get("sim/flightmodel2/engines/starter_is_running",3) end
	},
	engineStarterAnc = {
		etype = kc_swtype_customAnn,
		name = "Engine starters Ann",
		funcOn = function () if get("sim/flightmodel2/engines/starter_is_running",0) > 0 or 
			get("sim/flightmodel2/engines/starter_is_running",1) > 0 or 
			get("sim/flightmodel2/engines/starter_is_running",2) > 0 or 
			get("sim/flightmodel2/engines/starter_is_running",3) > 0 then return 1 else return 0 end end
	},
	engIgnition1 = {
		etype = kc_swtype_dref,
		name = "Ignition 1",
		drefName = "sim/cockpit2/engine/actuators/auto_ignite_on",
		drefIndex = -1
	},
	engIgnition2 = {
		etype = kc_swtype_dref,
		name = "Ignition 3",
		drefName = "sim/cockpit2/engine/actuators/auto_ignite_on",
		drefIndex = 1
	},
	engIgnition3 = {
		etype = kc_swtype_dref,
		name = "Ignition 3",
		drefName = "sim/cockpit2/engine/actuators/auto_ignite_on",
		drefIndex = 2
	},
	engIgnition4 = {
		etype = kc_swtype_dref,
		name = "Ignition 4",
		drefName = "sim/cockpit2/engine/actuators/auto_ignite_on",
		drefIndex = 3
	},
	reverser1 = {
		etype = kc_swtype_2StateCmd,
		name = "Reverser 1",
		drefName = "sim/cockpit2/annunciators/reverser_on",
		drefIndex = -1,
		funcOn = function () command_begin("sim/engines/thrust_reverse_hold_1") end,
		funcOff = function () command_end("sim/engines/thrust_reverse_hold_1") end,
		funcTgl = function () end,
		funcStat = function () return get("sim/cockpit2/annunciators/reverser_on",0) end
	},
	reverser2 = {
		etype = kc_swtype_2StateCmd,
		name = "Reverser 2",
		drefName = "sim/cockpit2/annunciators/reverser_on",
		drefIndex = 1,
		funcOn = function () command_begin("sim/engines/thrust_reverse_hold_2") end,
		funcOff = function () command_end("sim/engines/thrust_reverse_hold_2") end,
		funcTgl = function () end,
		funcStat = function () return get("sim/cockpit2/annunciators/reverser_on",0) end
	},
	reverser3 = {
		etype = kc_swtype_2StateCmd,
		name = "Reverser 3",
		drefName = "sim/cockpit2/annunciators/reverser_on",
		drefIndex = 2,
		funcOn = function () command_begin("sim/engines/thrust_reverse_hold_3") end,
		funcOff = function () command_end("sim/engines/thrust_reverse_hold_3") end,
		funcTgl = function () end,
		funcStat = function () return get("sim/cockpit2/annunciators/reverser_on",0) end
	},
	reverser4 = {
		etype = kc_swtype_2StateCmd,
		name = "Reverser 4",
		drefName = "sim/cockpit2/annunciators/reverser_on",
		drefIndex = 3,
		funcOn = function () command_begin("sim/engines/thrust_reverse_hold_4") end,
		funcOff = function () command_end("sim/engines/thrust_reverse_hold_4") end,
		funcTgl = function () end,
		funcStat = function () return get("sim/cockpit2/annunciators/reverser_on",0) end
	},
	magneto1 = {
		etype = kc_swtype_inop,
		name = "Magneto 1"
	},
	magneto2 = {
		etype = kc_swtype_inop,
		name = "Magneto 2"
	},
	magneto3 = {
		etype = kc_swtype_inop,
		name = "Magneto 3"
	},
	magneto4 = {
		etype = kc_swtype_inop,
		name = "Magneto 4"
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

return sysEnginesDefinitions
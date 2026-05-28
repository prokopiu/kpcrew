-- DFLT airplane 
-- Air conditioning and Pressurization functionality

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

logMsg("Air Definitions DFLT")

-- Definitions:
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_packs		= true 		-- Aircraft has switchable packs
kc_num_packs		= 2
kc_has_engine_bleed = true		-- Aircraft has switchable engine bleeds
kc_num_bleeds		= 1
kc_has_apu_bleed 	= false		-- Aircraft has switchable APU bleeds
kc_has_gasper_ctrl	= false		-- Aircraft has gasper supply manipulators
kc_has_iso_valves	= false		-- Aircraft has switchable isolation valve
kc_num_iso_valves	= 1
kc_has_recirc_fans	= false		-- Aircraft has switcable recirculating fans
kc_num_recirc_fans	= 1
kc_has_eqip_cooling	= false		-- Aircraft has switchable equipment cooling
kc_has_trim_air		= false		-- Aircraft has switchable trim air
kc_has_air_temp_ctrl= false		-- Aircraft has air temparture controls
kc_num_air_temp_ctrl= 2
kc_has_cargo_heat	= false		-- Aircraft has cargo heat controls
kc_num_cargo_heat	= 1
kc_has_land_altitude= false		-- Aircraft requires landing altitude to be dialed in
kc_has_flight_alt	= false		-- Aircraft requires flight altitude to be dialed in
kc_has_oxygen		= true		-- Aircraft has switchable oxygen supply

--[[
System Elements:
sysAir.packSwitchGroup up to 2
		sysAir.packSwitch1 
		sysAir.packSwitch2
sysAir.engBleedGroup up to 4
		sysAir.engBleedSwitch1
		sysAir.engBleedSwitch2
		sysAir.engBleedSwitch3
		sysAir.engBleedSwitch4
sysAir.apuBleedSwitch
sysAir.gasperSwitch
sysAir.isoValveGroup
		sysAir.isoValveSwitch1
		sysAir.isoValveSwitch2
		sysAir.isoValveSwitch3
sysAir.recircSwitchGroup
		sysAir.recircFanSwitch1
		sysAir.recircFanSwitch2
sysAir.equipCoolingSwitch
sysAir.trimAirSwitch
sysAir.tempSelectGroup
		sysAir.tempZoneSelect1
		sysAir.tempZoneSelect2
		sysAir.tempZoneSelect3
sysAir.cargoHeatGroup
		sysAir.cargoHeatSwitch1
		sysAir.cargoHeatSwitch2
sysAir.landAltSelector
sysAir.flightAltSelector
sysAir.oxygenSwitch
sysAir.vacuumAnc
]]

sysAirDefinitions = {

	packSwitch1 = {
		etype = kc_swtype_dref,
		name = "Pack Switch 1",
		drefName = "sim/cockpit2/bleedair/actuators/pack_left",
		drefIndex = 0
	},
	packSwitch2 = {
		etype = kc_swtype_dref,
		name = "Pack Switch 2",
		drefName = "sim/cockpit2/bleedair/actuators/pack_right",
		drefIndex = 0
	},
	engBleedSwitch1 = {
		etype = kc_swtype_dref,
		name = "Engine Bleed 1",
		drefName = "sim/cockpit2/pressurization/actuators/bleed_air_mode",
		drefIndex = 0
	},
	engBleedSwitch2 = {
		etype = kc_swtype_inop,
		name = "Engine Bleed 2"
	},
	engBleedSwitch3 = {
		etype = kc_swtype_inop,
		name = "Engine Bleed 3"
	},
	engBleedSwitch4 = {
		etype = kc_swtype_inop,
		name = "Engine Bleed 4"
	},
	apuBleedSwitch = {
		etype = kc_swtype_dref,
		name = "APU Bleed Switch",
		drefName = "sim/cockpit2/bleedair/actuators/apu_bleed",
		drefIndex = 0
	},
	equipCoolingSwitch = {
		etype = kc_swtype_inop,
		name = "Equipment Cooling Switch"
	},
	gasperSwitch = {
		etype = kc_swtype_inop,
		name = "Gasper Switch"
	},
	isoValveSwitch1 = {
		etype = kc_swtype_inop,
		name = "Isolation valve 1"
	},
	isoValveSwitch2 = {
		etype = kc_swtype_inop,
		name = "Isolation valve 2"
	},
	isoValveSwitch3 = {
		etype = kc_swtype_inop,
		name = "Isolation valve 3"
	},
	recircFanSwitch1 = {
		etype = kc_swtype_inop,
		name = "Recirculation switch 1"
	},
	recircFanSwitch2 = {
		etype = kc_swtype_inop,
		name = "Recirculation switch 2"
	},
	trimAirSwitch = {
		etype = kc_swtype_inop,
		name = "Trimair Switch"
	},
	tempZoneSelect1 = {
		etype = kc_swtype_inop,
		name = "Temperature 1"
	},
	tempZoneSelect2 = {
		etype = kc_swtype_inop,
		name = "Temperature 2"
	},
	tempZoneSelect3 = {
		etype = kc_swtype_inop,
		name = "Temperature 3"
	},
	cargoHeatSwitch1 = {
		etype = kc_swtype_inop,
		name = "Cargo heat 1"
	},
	cargoHeatSwitch2 = {
		etype = kc_swtype_inop,
		name = "Cargo heat 2"
	},
	landAltSelector = {
		etype = kc_swtype_inop,
		name = "Landing altitude"
	},
	flightAltSelector = {
		etype = kc_swtype_inop,
		name = "Flight altitude"
	},
	oxygenSwitch = {
		etype = kc_swtype_dref,
		name = "Oxygen master",
		drefName = "sim/cockpit2/oxygen/actuators/demand_flow_setting",
		drefIndex = 0
	},
	vacuumAnc = {
		etype = kc_swtype_customAnn,
		name = "Vacuum annunciator",
		funcOn = function () 
			if get("sim/cockpit2/annunciators/low_vacuum",0) == 1 or 
			   get("sim/cockpit2/annunciators/low_vacuum",1) == 1 then
				return 1 else return 0 end end
	}
}

return sysAirDefinitions
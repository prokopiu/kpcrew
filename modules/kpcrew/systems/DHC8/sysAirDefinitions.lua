-- DHC8 airplane 
-- Air conditioning and Pressurization functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
Systems covered:
Packs: 			Aircraft packs are the air conditioning units that condition and pressurize hot 
				bleed air from the engines to create a comfortable and safe cabin environment
Bleeds: 		Engine bleeds are a system that takes hot, high-pressure air from the engine's 
				compressor to power aircraft systems like cabin pressurization and air conditioning. 
APU Bleed: 		Takes hot, high-pressure air from the APU compressor to power aircraft systems like 
				cabin pressurization and air conditioning while engines are off. 
Gaspers: 		Is an adjustable, personalized vent in an aircraft cabin that provides a directed 
				flow of cool air to a passenger, often located above each seat.
Isolation valves: An aircraft isolation valve is a shut-off valve that separates or isolates different 
				parts of a system, such as the bleed air duct or hydraulic lines, to prevent a leak or 
				failure in one section from affecting the entire system. 
Recirc fans: 	Aircraft recirculation fans pull cabin air, which passes through HEPA filters to clean it, 
				before it is mixed with fresh, outside air to reduce the demand on the engines. 
Equipment cooling: Aircraft equipment is cooled using systems that circulate air or liquid to dissipate heat, 
				with common methods including using bleed air from the engines to power air conditioning packs, 
				and liquid cooling loops for components like avionics. 
Trim air: 		Trim air is hot air from the aircraft's engines used to heat and cool different cabin zones 
				independently. 
Air temp: 		Aircraft air temperature is controlled by a system that draws hot air from the engines, 
				cools and filters it, and then mixes it with "trim air" to achieve the desired temperature 
				for different cabin zones, which are regulated by sensors and controllers. 
Cargo heat: 	Cargo heat is a system that uses hot engine bleed air or electric heaters to keep the temperature 
				in the cargo hold above a minimum level, preventing temperature-sensitive goods from freezing during flight. 
Landing altitude: The landing altitude setting for an aircraft's pressurization is the destination airport's 
				field elevation, which the system uses to automatically adjust the cabin pressure to near-zero 
				differential at touchdown, ensuring passenger comfort and safety. 
Flight altitude: The flight altitude setting for pressurization is when the aircraft's system automatically 
				adjusts the cabin to a lower, breathable pressure, typically equivalent to an altitude 
				of 6,000 to 8,000 feet, despite the plane flying at much higher altitudes. 
Oxygen supply: 	Aircraft use compressed gas cylinders for crew and chemically-generated oxygen for 
				passengers in emergencies, which is supplied to masks that automatically drop when 
				cabin pressure drops. 
Air temperatur controls: Pilots can adjust the temperature of the cockpit, while cabin crew can 
				make small, zone-specific adjustments to the forward and aft cabin temperatures. 
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

local def = require("kpcrew.systems.DFLT.sysAirDefinitions")

-- Definitions:
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_packs		= true 		-- Aircraft has switchable packs
kc_num_packs		= 2
kc_has_engine_bleed = true		-- Aircraft has switchable engine bleeds
kc_num_engine_bleed	= 2
kc_has_apu_bleed 	= false		-- Aircraft has switchable APU bleeds
kc_has_gasper_ctrl	= false		-- Aircraft has gasper supply manipulators
kc_has_iso_valves	= false		-- Aircraft has switchable isolation valve
kc_num_iso_valves	= 1
kc_has_recirc_fans	= true		-- Aircraft has switchable recirculating fans
kc_num_recirc_fans	= 1
kc_has_eqip_cooling	= false		-- Aircraft has switchable equipment cooling
kc_has_trim_air		= false		-- Aircraft has switchable trim air
kc_has_air_temp_ctrl= true		-- Aircraft has air temparture controls
kc_num_air_temp_ctrl= 1
kc_has_cargo_heat	= false		-- Aircraft has cargo heat controls
kc_num_cargo_heat	= 1
kc_has_land_altitude= false		-- Aircraft requires landing altitude to be dialed in
kc_has_flight_alt	= false		-- Aircraft requires flight altitude to be dialed in
kc_has_oxygen		= false		-- Aircraft has switchable oxygen supply

-- For Briefing
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "OFF|ON"
kc_TakeoffBleeds 	= "OFF|ON"

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

sysAirDefinitions.packSwitch1.etype = kc_swtype_dref
sysAirDefinitions.packSwitch1.name = "Pack Switch 1"
sysAirDefinitions.packSwitch1.drefName = "sim/cockpit2/bleedair/actuators/pack_left"
sysAirDefinitions.packSwitch1.drefIndex = 0

sysAirDefinitions.packSwitch2.etype = kc_swtype_dref
sysAirDefinitions.packSwitch2.name = "Pack Switch 2"
sysAirDefinitions.packSwitch2.drefName = "sim/cockpit2/bleedair/actuators/pack_right"
sysAirDefinitions.packSwitch2.drefIndex = 0

sysAirDefinitions.engBleedSwitch1.etype = kc_swtype_dref
sysAirDefinitions.engBleedSwitch1.name = "Engine Bleed 1"
sysAirDefinitions.engBleedSwitch1.drefName = "custom_Q100/left_bleed"
sysAirDefinitions.engBleedSwitch1.drefIndex = 0

sysAirDefinitions.engBleedSwitch2.etype = kc_swtype_dref
sysAirDefinitions.engBleedSwitch2.name = "Engine Bleed 2"
sysAirDefinitions.engBleedSwitch2.drefName = "custom_Q100/right_bleed"
sysAirDefinitions.engBleedSwitch2.drefIndex = 0

sysAirDefinitions.apuBleedSwitch.etype = kc_swtype_dref
sysAirDefinitions.apuBleedSwitch.name = "APU Bleed Switch"
sysAirDefinitions.apuBleedSwitch.drefName = "sim/cockpit2/bleedair/actuators/apu_bleed"
sysAirDefinitions.apuBleedSwitch.drefIndex = 0

sysAirDefinitions.recircFanSwitch1.etype = kc_swtype_dref
sysAirDefinitions.recircFanSwitch1.name = "Recirculation switch 1"
sysAirDefinitions.recircFanSwitch1.drefName = "custom_Q100/air_con_recirc"
sysAirDefinitions.recircFanSwitch1.drefIndex = 0

return sysAirDefinitions
-- DFLT airplane 
-- Hydraulic functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
Systems covered:	
Engine Hydraulic Pump:	An airplane engine hydraulic pump converts mechanical energy from the engine 
						into hydraulic energy to power flight control surfaces, landing gear, and brakes. 
						It functions by pumping hydraulic fluid through the system to generate the necessary 
						pressure for these components to operate. 
						
Electric Hydraulic Pump:An airplane's electric hydraulic pump converts electrical energy into pressurized 
						hydraulic fluid to operate systems like flight controls, landing gear, and brakes. 
						It acts as a backup or primary power source, independent of the main engines, 
						to ensure hydraulic power is always available. 
						
PTU:					An airplane's PTU (Power Transfer Unit) is a hydraulic device that moves power 
						between independent hydraulic systems, activating like a "barking dog" sound to 
						provide backup pressure for critical functions (like flight controls, landing gear) 
						when one system is low, ensuring safety without mixing fluids. 
						
Hydraulic Reservoir:	An airplane hydraulic reservoir is a tank that stores hydraulic fluid, providing 
						a reserve supply, compensating for thermal expansion/contraction, and allowing air 
						to vent or be pressurized for consistent fluid delivery to power flight controls, 
						landing gear, and other vital systems.
						
RAT:					An airplane Ram Air Turbine (RAT) is a small, emergency backup propeller that deploys 
						from an aircraft to generate hydraulic or electrical power from the airstream, 
						keeping critical systems like flight controls operational after a total power failure. 
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

kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_num_hyd_elec_pmps= 2			
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps
kc_num_hyd_eng_pmps = 4			
kc_has_PTU			= false		-- Aircraft has power transfer unit
kc_has_RAT			= false		-- Aircraft has Ram Air Turbine		

-- === For Briefing

--[[
System Elements
sysHydraulic.elecHydPumpGroup
		sysHydraulic.elecHydPump1
		sysHydraulic.elecHydPump2
sysHydraulic.engHydPumpGroup
		sysHydraulic.engHydPump1
		sysHydraulic.engHydPump2
		sysHydraulic.engHydPump3
		sysHydraulic.engHydPump4
sysHydraulic.PTU
sysHydraulic.RAT
sysHydraulic.hydraulicLowAnc
sysHydraulic.hydPressureLow
]]

sysHydraulicDefinitions = {

	elecHydPump1 = {
		etype = kc_swtype_dref,
		name = "Elec Hyd Pump 1",
		drefName = "sim/cockpit2/switches/electric_hydraulic_pump_on",
		drefIndex = 0
	},
	elecHydPump2 = {
		etype = kc_swtype_dref,
		name = "Elec Hyd Pump 2",
		drefName = "sim/cockpit2/switches/electric_hydraulic_pump2_on",
		drefIndex = 0
	},
	elecHydPump3 = {
		etype = kc_swtype_dref,
		name = "Elec Hyd Pump 3",
		drefName = "sim/cockpit2/switches/electric_hydraulic_pump3_on",
		drefIndex = 0
	},
	engHydPump1 = {
		etype = kc_swtype_dref,
		name = "Eng Hyd Pump 1",
		drefName = "sim/cockpit2/hydraulics/actuators/engine_pump",
		drefIndex = 0
	},
	engHydPump2 = {
		etype = kc_swtype_dref,
		name = "Eng Hyd Pump 2",
		drefName = "sim/cockpit2/hydraulics/actuators/engine_pumpA",
		drefIndex = 0
	},
	engHydPump3 = {
		etype = kc_swtype_dref,
		name = "Eng Hyd Pump 3",
		drefName = "sim/cockpit2/hydraulics/actuators/engine_pumpB",
		drefIndex = 0
	},
	engHydPump4 = {
		etype = kc_swtype_dref,
		name = "Eng Hyd Pump 4",
		drefName = "sim/cockpit2/hydraulics/actuators/engine_pumpC",
		drefIndex = 0
	},
	PTU = {
		etype = kc_swtype_dref,
		name = "PTU",
		drefName = "sim/cockpit2/hydraulics/actuators/PTU",
		drefIndex = 0
	},
	RAT = {
		etype = kc_swtype_dref,
		name = "RAT",
		drefName = "sim/cockpit2/hydraulics/actuators/ram_air_turbine_on",
		drefIndex = 0
	},
	hydPressure1 = {
		etype = kc_swtype_annunciator,
		name = "Hyd Pressure 1",
		drefName = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1",
		drefIndex = 0
	},
	hydPressure2 = {
		etype = kc_swtype_annunciator,
		name = "Hyd Pressure 2",
		drefName = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2",
		drefIndex = 0
	},
	hydPressure3 = {
		etype = kc_swtype_annunciator,
		name = "Hyd Pressure 3",
		drefName = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1",
		drefIndex = 0
	},
	hydraulicLowAnc = {
		etype = kc_swtype_customAnn,
		name = "Hyd Low Ann",
		funcOn = function () if sysHydraulic.hydPressureGroup:getStatus() == 0 then return 0 else return 1 end end
	}
}

return sysHydraulicDefinitions
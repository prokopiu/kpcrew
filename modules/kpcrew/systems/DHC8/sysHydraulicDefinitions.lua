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

local def = require("kpcrew.systems.DFLT.sysHydraulicDefinitions")

kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_num_hyd_elec_pmps= 3			
kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps
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


return sysHydraulicDefinitions
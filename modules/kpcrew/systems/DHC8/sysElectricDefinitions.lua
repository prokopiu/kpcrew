-- DFLT airplane 
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
kc_num_batteries	= 3
kc_has_generators	= true		-- Aircraft has engine generators
kc_num_generators	= 4
kc_has_inverters	= false		-- Aircraft has inverters			
kc_num_inverters	= 2			
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_apu			= true		-- Aircraft has an APU
kc_has_apu_master	= false		-- Aircraft (Airbus) have also APU Master
kc_has_apu_gens		= true		-- Aircraft has APU generators
kc_num_apu_gens		= 1	
kc_has_gpu_gens		= true		-- Aircraft has GPU generators
kc_num_gpu_gens		= 1	
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = true		-- Aircraft has Avionics switch
kc_num_avionics_sw  = 2	
kc_has_standby_pwr	= false		-- Aircraft has standby power
kc_remove_gpu_after	= true		-- remove GPU after start

-- === For Briefing

--[[
System Elements

]]

return sysElectricDefinitions
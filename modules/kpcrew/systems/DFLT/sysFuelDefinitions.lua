-- DFLT airplane 
-- Aircraft fuel functionality

-- @classmod sysFuelDefinitions
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

kc_NumTanks			= -1		-- Number of tanks from acf
kc_MaxFuel 			= -1		-- Maximum Fuel Capacity from ACF
kc_MFL				= {[0]=-1,[1]=-1,[2]=-1,[3]=-1,[4]=-1,[5]=-1,[6]=-1,[7]=-1,[8]=-1}
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_FuelTankCntrInd  = 2
kc_FFPH 			= -1		-- Fuel Flow per hour from acf

kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_num_fuel_pumps	= 4
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_num_fuel_xfeed	= 1
kc_has_fuel_select	= false		-- Aircraft has fuel tank selector
kc_has_fuel_cutoff	= false		-- Aircraft has fuel cutoff switches
kc_num_fuel_cutoff	= 4

--[[
System Elements:
sysFuel.allFuelPumpGroup
	sysFuel.fuelPump1
	sysFuel.fuelPump2
	sysFuel.fuelPump3
	sysFuel.fuelPump4
	sysFuel.fuelPump5
	sysFuel.fuelPump6
	sysFuel.fuelPump7
	sysFuel.fuelPump8
	sysFuel.fuelPump9
	sysFuel.fuelPump10
	sysFuel.fuelPump11
	sysFuel.fuelPump12
	sysFuel.fuelPump13
	sysFuel.fuelPump14
	sysFuel.fuelPump15
	sysFuel.fuelPump16
	sysFuel.fuelPump17
	sysFuel.fuelPump18
	sysFuel.fuelPump19
	sysFuel.fuelPump20
sysFuel.fuelXFeedGroup
	sysFuel.xfeedSwitch1
	sysFuel.xfeedSwitch2
	sysFuel.xfeedSwitch3
sysFuel.fuelSwitchGroup
	sysFuel.fuelSwitch1
	sysFuel.fuelSwitch2
	sysFuel.fuelSwitch3
	sysFuel.fuelSwitch4
sysFuel.fuelSelector

sysFuel.centerTankLbs
sysFuel.centerTankKgs
sysFuel.allTanksLbs 
sysFuel.allTanksKgs 
	
sysFuel.fuel_balanced()
sysFuel.fuelLowAnc
sysFuel.auxFuelPumpsAnc

Macro: kc_macro_fuel
]]

sysFuelDefinitions = {
	fuelPump1 = {
		etype = kc_swtype_dref,
		name = "Fuel pump 1",
		drefName = "sim/cockpit/engine/fuel_pump_on",
		drefIndex = -1
	},
	fuelPump2 = {
		etype = kc_swtype_dref,
		name = "Fuel pump 2",
		drefName = "sim/cockpit/engine/fuel_pump_on",
		drefIndex = 1
	},
	fuelPump3 = {
		etype = kc_swtype_dref,
		name = "Fuel pump 3",
		drefName = "sim/cockpit/engine/fuel_pump_on",
		drefIndex = 2
	},
	fuelPump4 = {
		etype = kc_swtype_dref,
		name = "Fuel pump 4",
		drefName = "sim/cockpit/engine/fuel_pump_on",
		drefIndex = 3
	},
	xfeedSwitch1 = {
		etype = kc_swtype_2StateCmd,
		name = "Fuel xfeed 1",
		drefName = "sim/cockpit2/fuel/auto_crossfeed",
		drefIndex = 0,
		cmd1 = "sim/fuel/auto_crossfeed_on_open",
		cmd2 = "sim/fuel/auto_crossfeed_off",
		cmd3 = "nocommand"
	},
	xfeedSwitch2 = {
		etype = kc_swtype_inop,
		name = "Fuel xfeed 2"
	},
	xfeedSwitch3 = {
		etype = kc_swtype_inop,
		name = "Fuel xfeed 3"
	},
	fuelSwitch1 = {
		etype = kc_swtype_inop,
		name = "Fuel cutoff 1"
	},
	fuelSwitch2 = {
		etype = kc_swtype_inop,
		name = "Fuel cutoff 2"
	},
	fuelSwitch3 = {
		etype = kc_swtype_inop,
		name = "Fuel cutoff 3"
	},
	fuelSwitch4 = {
		etype = kc_swtype_inop,
		name = "Fuel cutoff 4"
	},
	auxFuelPumpsAnc = {
		etype = kc_swtype_customAnn,
		name = "Aux fuel ann",
		funcOn = function () if sysFuel.allFuelPumpGroup:getStatus() > 0 then  return 1 else return 0 end end
	},
	fuelLowAnc = {
		etype = kc_swtype_customAnn,
		name = "Fuel low ann",
		funcOn = function () if get("sim/cockpit2/annunciators/fuel_pressure_low",0) > 0 or get("sim/cockpit2/annunciators/fuel_pressure_low",1) > 0 or get("sim/cockpit2/annunciators/fuel_pressure_low",2) > 0 or get("sim/cockpit2/annunciators/fuel_pressure_low",3) > 0 then return 1 else return 0 end end
	}
}

return sysFuelDefinitions
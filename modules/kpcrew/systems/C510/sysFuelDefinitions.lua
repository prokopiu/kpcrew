-- C510 airplane 
-- Aircraft fuel functionality

-- @classmod sysFuelDefinitions
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
Systems covered:
Fuel Pumps:
Fuel Switches:	
Fuel Crossfeed:
Fuel tanks:
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
	
kc_swtype_2StateCmd
kc_swtype_toggleCmd
kc_swtype_multistate
kc_swtype_dref
kc_swtype_inop
kc_swtype_customCmd
kc_swtype_annunciator
kc_swtype_customAnn

]]

kc_NumTanks			= -1		-- Number of tanks from acf
kc_MaxFuel 			= -1		-- Maximum Fuel Capacity from ACF
kc_MFL				= {[0]=-1,[1]=-1,[2]=-1,[3]=-1,[4]=-1,[5]=-1,[6]=-1,[7]=-1,[8]=-1}
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_FuelTankCntrInd  = 2
kc_FFPH 			= -1		-- Fuel Flow per hour from acf

kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_num_fuel_pumps	= 2
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_num_fuel_xfeed	= 1
kc_has_fuel_select	= false		-- Aircraft has fuel tank selector
kc_has_fuel_cutoff	= true		-- Aircraft has fuel cutoff switches
kc_num_fuel_cutoff	= 2

-- === For Briefing
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief

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
		drefName = "vskylabs/510x/fuel_sys/left_booster_sw",
		drefIndex = 0
	},
	fuelPump2 = {
		etype = kc_swtype_dref,
		name = "Fuel pump 2",
		drefName = "vskylabs/510x/fuel_sys/right_booster_sw",
		drefIndex = 0
	},
	xfeedSwitch1 = {
		etype = kc_swtype_customCmd,
		name = "Fuel xfeed 1",
		drefName = "sim/cockpit2/switches/custom_slider_on",
		drefIndex = -1,
		funcOn = function () set_array("sim/cockpit2/switches/custom_slider_on",0,2) end,
		funcOff = function () set_array("sim/cockpit2/switches/custom_slider_on",0,1) end,
		funcTgl = function () set_array("sim/cockpit2/switches/custom_slider_on",0,0) end,
		funcStat = function () if get("sim/cockpit2/switches/custom_slider_on",0) ~= 1 then return 1 else return 0 end end
	},
	fuelSwitch1 = {
		etype = kc_swtype_toggleCmd,
		name = "Fuel cutoff 1",
		drefName = "vsl/510x/throttle_anim_L",
		drefIndex = 0,
		cmd1 = "vskylabs/510x/throttles/throttle_L_cutoff_toggle"
	},
	fuelSwitch2 = {
		etype = kc_swtype_toggleCmd,
		name = "Fuel cutoff 2",
		drefName = "vsl/510x/throttle_anim_R",
		drefIndex = 0,
		cmd1 = "vskylabs/510x/throttles/throttle_R_cutoff_toggle"
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
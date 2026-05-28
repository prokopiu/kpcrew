-- DFLT airplane 
-- Anti ice functionality

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

kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_num_eng_antiice	= 4		
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_num_wing_antiice	= 2		
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_num_window_heat	= 4		
kc_has_pitot_heat	= true		-- Aircraft has pitot heat
kc_num_pitot_heat	= 2			


--[[
System Elements
sysAice.engAntiIceGroup
		sysAice.engAntiIce1 
		sysAice.engAntiIce2 
		sysAice.engAntiIce3 
		sysAice.engAntiIce4
sysAice.wingAiceGroup
		sysAice.wingAntiIce1
		sysAice.wingAntiIce2
sysAice.windowHeatGroup
		sysAice.windowHeat1
		sysAice.windowHeat2
		sysAice.windowHeat3
		sysAice.windowHeat4
sysAice.probeHeatGroup
		sysAice.probeHeatSwitch1
		sysAice.probeHeatSwitch2
]]

sysAiceDefinitions = {

	engAntiIce1 = {
		etype = kc_swtype_dref,
		name = "Eng Aice 1",
		drefName = "sim/cockpit/switches/anti_ice_inlet_heat_per_engine",
		drefIndex = -1
	},
	engAntiIce2 = {
		etype = kc_swtype_dref,
		name = "Eng Aice 2",
		drefName = "sim/cockpit/switches/anti_ice_inlet_heat_per_engine",
		drefIndex = 1
	},
	engAntiIce3 = {
		etype = kc_swtype_dref,
		name = "Eng Aice 3",
		drefName = "sim/cockpit/switches/anti_ice_inlet_heat_per_engine",
		drefIndex = 2
	},
	engAntiIce4 = {
		etype = kc_swtype_dref,
		name = "Eng Aice 4",
		drefName = "sim/cockpit/switches/anti_ice_inlet_heat_per_engine",
		drefIndex = 3
	},
	wingAntiIce1 = {
		etype = kc_swtype_dref,
		name = "Wing Antiice 1",
		drefName = "sim/cockpit/switches/anti_ice_surf_heat_left",
		drefIndex = 0
	},
	wingAntiIce2 = {
		etype = kc_swtype_dref,
		name = "Wing Antiice 2",
		drefName = "sim/cockpit/switches/anti_ice_surf_heat_right",
		drefIndex = 0
	},
	windowHeat1 = {
		etype = kc_swtype_2StateCmd,
		name = "Window Heat 1",
		drefName = "sim/cockpit2/ice/ice_window_heat_on_window",
		drefIndex = -1,
		cmd1="sim/ice/window_heat_on",
		cmd2="sim/ice/window_heat_off",
		cmd3="sim/ice/window_heat_tog"
	},
	windowHeat2 = {
		etype = kc_swtype_2StateCmd,
		name = "Window Heat 2",
		drefName = "sim/cockpit2/ice/ice_window_heat_on_window",
		drefIndex = 1,
		cmd1="sim/ice/window2_heat_on",
		cmd2="sim/ice/window2_heat_off",
		cmd3="sim/ice/window2_heat_tog"
	},
	windowHeat3 = {
		etype = kc_swtype_2StateCmd,
		name = "Window Heat 3",
		drefName = "sim/cockpit2/ice/ice_window_heat_on_window",
		drefIndex = 2,
		cmd1="sim/ice/window3_heat_on",
		cmd2="sim/ice/window3_heat_off",
		cmd3="sim/ice/window3_heat_tog"
	},
	windowHeat4 = {
		etype = kc_swtype_2StateCmd,
		name = "Window Heat 4",
		drefName = "sim/cockpit2/ice/ice_window_heat_on_window",
		drefIndex = 3,
		cmd1="sim/ice/window4_heat_on",
		cmd2="sim/ice/window4_heat_off",
		cmd3="sim/ice/window4_heat_tog"
	},
	probeHeatSwitch1 = {
		etype = kc_swtype_2StateCmd,
		name = "Probe heat switch 1",
		drefName = "sim/cockpit/switches/pitot_heat_on",
		drefIndex = 0,
		cmd1="sim/ice/pitot_heat0_on",
		cmd2="sim/ice/pitot_heat0_off",
		cmd3="sim/ice/pitot_heat0_tog"
	},
	probeHeatSwitch2 = {
		etype = kc_swtype_2StateCmd,
		name = "Probe heat switch 2",
		drefName = "sim/cockpit/switches/pitot_heat_on2",
		drefIndex = 0,
		cmd1="sim/ice/pitot_heat1_on",
		cmd2="sim/ice/pitot_heat1_off",
		cmd3="sim/ice/pitot_heat1_tog"
	},
	antiiceAnc = {
		etype = kc_swtype_customAnn,
		name = "Anti-Ice annunciator",
		funcOn = function () 
			if sysAice.wingAiceGroup:getStatus() > 0 or 
			   sysAice.engAntiIceGroup:getStatus() > 0 then
				return 1 else return 0 end end
	}
}

return sysAiceDefinitions
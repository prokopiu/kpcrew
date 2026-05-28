-- C510 airplane 
-- Anti ice functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
Systems covered:
Engine Anti-Ice: An airplane engine anti-ice system heats the engine's intake by diverting hot air 
				from the compressor to prevent ice buildup that could damage the engine. 
				
Wing Anti-Ice:	An airplane's wing anti-ice system prevents ice buildup by using hot air from the 
				engines or electric heating elements to warm the leading edges of the wings. This keeps 
				the critical wing surfaces clear of ice during flight, which is essential for 
				maintaining lift and control. 

Window Heat:	Airplane window heating uses electrical elements to prevent ice and fog buildup 
				and make the windows more resistant to impact damage from things like hail or birds. 

Probe Heat:		An airplane's pitot or probe heat system uses electrical heating elements to prevent 
				ice from blocking the pitot tube, which ensures accurate airspeed readings. 
				This is crucial for flight safety, as a blocked pitot tube can cause erroneous airspeed, 
				altitude, and vertical speed indications. 
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

kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_num_eng_antiice	= 2		
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_num_wing_antiice	= 1		
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_num_window_heat	= 2		
kc_has_pitot_heat	= true		-- Aircraft has pitot heat
kc_num_pitot_heat	= 1			

-- === For Briefing
kc_TakeoffAntiice 	= "OFF|ENGINE|ENGINE & WING"
kc_LandingAntiice 	= "OFF|ENGINE|ENGINE & WING"

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
	wingAntiIce1 = {
		etype = kc_swtype_dref,
		name = "Wing Antiice 1",
		drefName = "vskylabs/510x/anti_icing/wing_stab_sw",
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
	probeHeatSwitch1 = {
		etype = kc_swtype_dref,
		name = "Probe heat switch 1",
		drefName = "vskylabs/510x/anti_icing/pitot_icing_sw",
		drefIndex = 0
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
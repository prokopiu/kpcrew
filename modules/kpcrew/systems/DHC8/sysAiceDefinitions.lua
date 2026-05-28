-- DHC8 airplane 
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

local def = require("kpcrew.systems.DFLT.sysAiceDefinitions")

kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_num_eng_antiice	= 1		
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_num_wing_antiice	= 1		
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_num_window_heat	= 1		
kc_has_pitot_heat	= true		-- Aircraft has pitot heat
kc_num_pitot_heat	= 2			

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

sysAiceDefinitions.engAntiIce1.etype = kc_swtype_multistate
sysAiceDefinitions.engAntiIce1.name = "Eng Aice 1"
sysAiceDefinitions.engAntiIce1.drefName = "custom_Q100/prop_heat_switch"
sysAiceDefinitions.engAntiIce1.drefIndex = 0
sysAiceDefinitions.engAntiIce1.cmd1="custom_Q100/prop_heat_down"
sysAiceDefinitions.engAntiIce1.cmd2="custom_Q100/prop_heat_up"
sysAiceDefinitions.engAntiIce1.msMin = -2
sysAiceDefinitions.engAntiIce1.msMax = 2
sysAiceDefinitions.engAntiIce1.msRead = true
sysAiceDefinitions.engAntiIce1.msDiff = 1
	
sysAiceDefinitions.wingAntiIce1.etype = kc_swtype_multistate
sysAiceDefinitions.wingAntiIce1.name = "Wing Antiice 1"
sysAiceDefinitions.wingAntiIce1.drefName = "custom_Q100/wing_boot_switch"
sysAiceDefinitions.wingAntiIce1.drefIndex = 0
sysAiceDefinitions.wingAntiIce1.cmd1="custom_Q100/wing_heat_down"
sysAiceDefinitions.wingAntiIce1.cmd2="custom_Q100/wing_heat_up"
sysAiceDefinitions.wingAntiIce1.msMin = 0
sysAiceDefinitions.wingAntiIce1.msMax = 2
sysAiceDefinitions.wingAntiIce1.msRead = true
sysAiceDefinitions.wingAntiIce1.msDiff = 1

sysAiceDefinitions.windowHeat1.etype = kc_swtype_multistate
sysAiceDefinitions.windowHeat1.name = "Window heat 1"
sysAiceDefinitions.windowHeat1.drefName = "custom_Q100/window_heat"
sysAiceDefinitions.windowHeat1.drefIndex = 0
sysAiceDefinitions.windowHeat1.cmd1="custom_Q100/window_heat_down"
sysAiceDefinitions.windowHeat1.cmd2="custom_Q100/window_heat_up"
sysAiceDefinitions.windowHeat1.msMin = 0
sysAiceDefinitions.windowHeat1.msMax = 2
sysAiceDefinitions.windowHeat1.msRead = true
sysAiceDefinitions.windowHeat1.msDiff = 1

sysAiceDefinitions.probeHeatSwitch1.etype = kc_swtype_dref
sysAiceDefinitions.probeHeatSwitch1.name = "Probe heat switch 1"
sysAiceDefinitions.probeHeatSwitch1.drefName = "sim/cockpit/switches/pitot_heat_on"
sysAiceDefinitions.probeHeatSwitch1.drefIndex = 0

sysAiceDefinitions.probeHeatSwitch2.etype = kc_swtype_dref
sysAiceDefinitions.probeHeatSwitch2.name = "Probe heat switch 2"
sysAiceDefinitions.probeHeatSwitch2.drefName = "sim/cockpit/switches/pitot_heat_on2"
sysAiceDefinitions.probeHeatSwitch2.drefIndex = 0
	
return sysAiceDefinitions
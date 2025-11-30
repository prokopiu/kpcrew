-- B737 airplane 
-- Aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysLights.beaconSwitch
-- sysLights.beaconAnc
-- sysLights.positionSwitch
-- sysLights.positionAnc
-- sysLights.strobesSwitch 
-- sysLights.strobesAnc
-- sysLights.taxiSwitch 	
-- sysLights.taxiAnc
-- sysLights.llLeftSwitch 	
-- sysLights.llRightSwitch 
-- sysLights.ll3rdSwitch 	
-- sysLights.ll4thSwitch 	
-- sysLights.landLightGroup
-- sysLights.landingAnc
-- sysLights.wingSwitch
-- sysLights.wingAnc
-- sysLights.wheelSwitch
-- sysLights.wheelAnc
-- sysLights.logoSwitch
-- sysLights.logoAnc
-- sysLights.rwyLeftSwitch 	
-- sysLights.rwyRightSwitch
-- sysLights.rwyLightGroup 
-- sysLights.runwayAnc
-- sysLights.domeLightSwitch 
-- sysLights.domeLightSwitch2
-- sysLights.domeLightGroup 
-- sysLights.instr1Light
-- sysLights.instr2Light
-- sysLights.instr3Light
-- sysLights.instr4Light
-- sysLights.instr5Light
-- sysLights.instr6Light
-- sysLights.instrLightGroup
-- sysLights.instrumentAnc
-- sysLights.panel1Light
-- sysLights.panel2Light
-- sysLights.panel3Light
-- sysLights.panel4Light
-- sysLights.panelLightGroup 
-- sysLights.emerLights
-- Macro: kc_macro_lights
-- Macro: kc_macro_lights_climb_10k
-- Macro: kc_macro_lights_descend_10k
-- UI: panel_render

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysLights = require("kpcrew.systems.DFLT.sysLights")

logMsg("B737 sysLights")

--------- Switch datarefs common
local drefBeaconLight		= "sim/cockpit/electrical/beacon_lights_on"
local drefPositionLights	= "laminar/B738/toggle_switch/position_light_pos"
local drefStrobeLights		= "laminar/B738/toggle_switch/position_light_pos"
local drefTaxiLights		= "laminar/B738/toggle_switch/taxi_light_brightness_pos"
local drefRWYLeft 			= "laminar/B738/toggle_switch/rwy_light_left"
local drefRWYRight 			= "laminar/B738/toggle_switch/rwy_light_right"
local drefWingLight			= "laminar/B738/toggle_switch/wing_light"
local drefWheelLight		= "laminar/B738/toggle_switch/wheel_light"
local drefLLRetLeft 		= "laminar/B738/switch/land_lights_ret_left_pos"
local drefLLRetRight 		= "laminar/B738/switch/land_lights_ret_right_pos"
local drefLLLeft 			= "laminar/B738/switch/land_lights_left_pos"
local drefLLRight 			= "laminar/B738/switch/land_lights_right_pos"
local drefGenericLights 	= "laminar/B738/electric/generic_brightness"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "laminar/B738/electric/panel_brightness"
local drefCockpitLights		= "sim/cockpit/electrical/cockpit_lights"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdPositionOn			= "laminar/B738/toggle_switch/position_light_steady"
local cmdPositionOff		= "laminar/B738/toggle_switch/position_light_off"
local cmdStrobesOn			= "laminar/B738/toggle_switch/position_light_strobe"
local cmdStrobesOff			= "laminar/B738/toggle_switch/position_light_off"
local cmdTaxiOn				= "laminar/B738/toggle_switch/taxi_light_brightness_on"
local cmdTaxiOff			= "laminar/B738/toggle_switch/taxi_light_brightness_off"
local cmdTaxiTgl			= "laminar/B738/toggle_switch/taxi_light_brightness_toggle"
local cmdRWY1On				= "laminar/B738/switch/rwy_light_left_on"
local cmdRWY1Off			= "laminar/B738/switch/rwy_light_left_off"
local cmdRWY1Tgl			= "laminar/B738/switch/rwy_light_left_toggle"
local cmdRWY2On				= "laminar/B738/switch/rwy_light_right_on"
local cmdRWY2Off			= "laminar/B738/switch/rwy_light_right_off"
local cmdRWY2Tgl			= "laminar/B738/switch/rwy_light_right_toggle"
local cmdWingOn				= "laminar/B738/switch/wing_light_on"
local cmdWingOff			= "laminar/B738/switch/wing_light_off"
local cmdWingTgl			= "laminar/B738/switch/wing_light_toggle"
local cmdLL1On				= "laminar/B738/switch/land_lights_ret_left_on"
local cmdLL1Off				= "laminar/B738/switch/land_lights_ret_left_off"
local cmdLL2On				= "laminar/B738/switch/land_lights_ret_right_on"
local cmdLL2Off				= "laminar/B738/switch/land_lights_ret_right_off"
local cmdLL3On				= "laminar/B738/switch/land_lights_left_on"
local cmdLL3Off				= "laminar/B738/switch/land_lights_left_off"
local cmdLL4On				= "laminar/B738/switch/land_lights_right_on"
local cmdLL4Off				= "laminar/B738/switch/land_lights_right_off"

local cmdBeaconOn			= "sim/lights/beacon_lights_on"
local cmdBeaconOff			= "sim/lights/beacon_lights_off"
local cmdBeaconTgl			= "sim/lights/beacon_lights_toggle"

----------- Switches

-- ** Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCmdSwitch:new("position",drefPositionLights,0,cmdPositionOn,cmdPositionOff,"nocommand")
-- ** Position Light(s) status
sysLights.positionAnc 		= CustomAnnunciator:new("positionlights",
	function () if get(drefPositionLights) ~= 0 then return 1 else return 0 end end)

-- ** Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCmdSwitch:new("strobes",drefStrobeLights,0,cmdStrobesOn,cmdStrobesOff,"nocommand")
-- ** Strobe Light(s) status
sysLights.strobesAnc 			= CustomAnnunciator:new("strobelights",
	function () if get(drefStrobeLights) == 2 then return 1 else return 0 end end)

-- ** Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCmdSwitch:new("taxi",drefTaxiLights,0,cmdTaxiOn,cmdTaxiOff,cmdTaxiTgl)
-- ** Taxi Light(s) status
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
	function () if get(drefTaxiLights) > 0 then return 1 else return 0 end end)

-- ** RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateCmdSwitch:new("rwyleft",drefRWYLeft,0,cmdRWY1On,cmdRWY1Off,cmdRWY1Tgl)
sysLights.rwyRightSwitch 	= TwoStateCmdSwitch:new("rwyright",drefRWYRight,0,cmdRWY2On,cmdRWY2Off,cmdRWY2Tgl)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- ** Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCmdSwitch:new("llretleft",drefLLRetLeft,0,cmdLL1On,cmdLL1Off,"nocommand")
sysLights.llRightSwitch 	= TwoStateCmdSwitch:new("llretright",drefLLRetRight,0,cmdLL2On,cmdLL2Off,"nocommand")
sysLights.ll3rdSwitch 		= TwoStateCmdSwitch:new("llleft",drefLLLeft,0,cmdLL3On,cmdLL3Off,"nocommand")
sysLights.ll4thSwitch 		= TwoStateCmdSwitch:new("llright",drefLLRight,0,cmdLL4On,cmdLL4Off,"nocommand")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)

-- ** Wing Lights
sysLights.wingSwitch 		= TwoStateCmdSwitch:new("wing",drefWingLight,0,cmdWingOn,cmdWingOff,cmdWingTgl)
-- ** Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefWingLight,0)

-- ** Wheel well Lights
sysLights.wheelSwitch 		= TwoStateDrefSwitch:new("wheel",drefWheelLight,0)
-- ** Wheel well Light(s) status
sysLights.wheelAnc 			= SimpleAnnunciator:new("wheellight",drefWheelLight,0)

-- ** Logo Light
sysLights.logoSwitch 		= TwoStateCmdSwitch:new("logo","laminar/B738/toggle_switch/logo_light",0,
	"laminar/B738/switch/logo_light_on","laminar/B738/switch/logo_light_off","laminar/B738/switch/logo_light_toggle")
-- ** Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","laminar/B738/toggle_switch/logo_light",0)

-- ** Dome Light
sysLights.domeLightSwitch 	= TwoStateCustomSwitch:new("dome","laminar/B738/toggle_switch/cockpit_dome_pos",0,
	function ()
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
	end,
	function ()
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B738/toggle_switch/cockpit_dome_pos") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("",drefPanelLights,-1)
sysLights.instr2Light		= TwoStateDrefSwitch:new("",drefPanelLights,1)
sysLights.instr3Light		= TwoStateDrefSwitch:new("",drefPanelLights,2)
sysLights.instr4Light		= TwoStateDrefSwitch:new("",drefPanelLights,3)
sysLights.instr5Light		= TwoStateDrefSwitch:new("",drefInstrLights,-1)
sysLights.instr6Light		= TwoStateDrefSwitch:new("",drefInstrLights,1)
sysLights.instr7Light		= TwoStateDrefSwitch:new("",drefInstrLights,3)
sysLights.instr8Light		= TwoStateDrefSwitch:new("",drefInstrLights,24)
sysLights.instr9Light		= TwoStateDrefSwitch:new("",drefInstrLights,25)
sysLights.instr10Light		= TwoStateDrefSwitch:new("",drefInstrLights,26)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr9Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr10Light)
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights",drefPanelLights,-1)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1",drefGenericLights,6)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2",drefGenericLights,7)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3",drefGenericLights,8)
sysLights.panel4Light		= TwoStateDrefSwitch:new("panellight4",drefGenericLights,12)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel4Light)

sysLights.emerLights = TwoStateCustomSwitch:new("emer","laminar/B738/toggle_switch/emer_exit_lights",0,
	function ()
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		if get("laminar/B738/button_switch/cover_position",9) ~= 0 then
			command_once("laminar/B738/button_switch_cover09")
		end	
	end,
	function ()
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		if get("laminar/B738/button_switch/cover_position",9) == 0 then
			command_once("laminar/B738/button_switch_cover09")
		end
	end,
	function ()
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		if get("laminar/B738/button_switch/cover_position",9) == 0 then
			command_once("laminar/B738/button_switch_cover09")
		end	
	end,
	function ()
		if get("laminar/B738/toggle_switch/emer_exit_lights") > 0 then
			return 1
		else
			return 0
		end
	end)

--------- Macros

function kc_macro_lights(flightphase)
	logMsg("Lights flight phase: " .. kcSopFlightPhase[flightphase])

	-- Cold & dark
	if flightphase == kc_phase_colddark then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(0)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
			sysLights.wheelSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(0.1)
		end
	elseif flightphase == kc_phase_before_start then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(0)
			sysLights.wheelSwitch:actuate(0)
			sysLights.panelLightGroup:actuate(0.1)
		end
	elseif flightphase == kc_phase_taxi_rwy then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(0.2)
		end
	elseif flightphase == kc_phase_before_takeoff then
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(0.2)
		end
	elseif flightphase == kc_phase_approach then
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(0.2)
		end
	elseif flightphase == kc_phase_afterland then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(0.2)
		end
	else
		logMsg("Invalid flightphase")
	end	

end

return sysLights

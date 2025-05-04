-- B737 airplane 
-- Aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"

sysLights = require("kpcrew.systems.DFLT.sysLights")

logMsg("B737 sysLights")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

-- ** Position Lights, single onoff command driven
if kc_is_zibo then
	sysLights.positionSwitch 	= TwoStateCmdSwitch:new("position","laminar/B738/toggle_switch/position_light_pos",0,
		"laminar/B738/toggle_switch/position_light_steady","laminar/B738/toggle_switch/position_light_off","nocommand")
else
	sysLights.positionSwitch 	= TwoStateCustomSwitch:new("strobes","laminar/B738/toggle_switch/position_light_pos",0,
	function () 
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_down")
	end,
	function () 
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_up")
	end,
	function () 
		if get("laminar/B738/toggle_switch/position_light_pos") == -1 then 
			command_once("laminar/B738/toggle_switch/position_light_down")
			command_once("laminar/B738/toggle_switch/position_light_down")
			command_once("laminar/B738/toggle_switch/position_light_up")
		else
			command_once("laminar/B738/toggle_switch/position_light_down")
			command_once("laminar/B738/toggle_switch/position_light_down")
		end
	end,
	function () 
		if get("laminar/B738/toggle_switch/position_light_pos") ~= 0 then 
			return 1
		else
			return 0
		end
	end)	
end
-- ** Position Light(s) status
sysLights.positionAnc 		= CustomAnnunciator:new("positionlights",
function () 
	if get("laminar/B738/toggle_switch/position_light_pos") ~= 0 then
		return 1
	else
		return 0
	end
end)

-- ** Strobe Lights, single onoff command driven
if kc_is_zibo then
	sysLights.strobesSwitch 	= TwoStateCmdSwitch:new("strobes","laminar/B738/toggle_switch/position_light_pos",0,
		"laminar/B738/toggle_switch/position_light_strobe","laminar/B738/toggle_switch/position_light_off","nocommand")
	-- ** Strobe Light(s) status
	sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","laminar/B738/toggle_switch/position_light_pos",0)
else
	sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","laminar/B738/toggle_switch/position_light_pos",0,
	function () 
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_up")
	end,
	function () 
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_down")
	end,
	function () 
		if get("laminar/B738/toggle_switch/position_light_pos") == 1 then 
			command_once("laminar/B738/toggle_switch/position_light_down")
			command_once("laminar/B738/toggle_switch/position_light_down")
		else
			command_once("laminar/B738/toggle_switch/position_light_up")
			command_once("laminar/B738/toggle_switch/position_light_up")
		end
	end,
	function () 
		if get("laminar/B738/toggle_switch/position_light_pos") == 1 then 
			return 1
		else
			return 0
		end
	end)	
end
sysLights.strobesAnc 			= CustomAnnunciator:new("strobelights",
function () 
	if get("laminar/B738/toggle_switch/position_light_pos") == 2 then
		return 1
	else
		return 0
	end
end)

-- ** Taxi/Nose Lights, single onoff command driven
if kc_is_zibo then
	sysLights.taxiSwitch 		= TwoStateCmdSwitch:new("taxi","laminar/B738/toggle_switch/taxi_light_brightness_pos",0,
		"laminar/B738/toggle_switch/taxi_light_brightness_on","laminar/B738/toggle_switch/taxi_light_brightness_off",
		"laminar/B738/toggle_switch/taxi_light_brigh_toggle")
	-- ** Taxi Light(s) status
else
	sysLights.taxiSwitch 		= TwoStateCustomSwitch:new("taxi","laminar/B738/toggle_switch/taxi_light_brightness_pos",0,
	function () 
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
	end,
	function () 
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
	end,
	function () 
		if get("laminar/B738/toggle_switch/taxi_light_brightness_pos") > 0 then 
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
		else
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
		end
	end,
	function () 
		if get("laminar/B738/toggle_switch/taxi_light_brightness_pos") > 0 then 
			return 1
		else
			return 0
		end
	end)	
end
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
function () 
	if get("laminar/B738/toggle_switch/taxi_light_brightness_pos") > 0 then
		return 1
	else
		return 0
	end
end)

-- ** RWY Turnoff Lights (2)
if kc_is_zibo then
	sysLights.rwyLeftSwitch 	= TwoStateCmdSwitch:new("rwyleft",drefRWYLeft,0,
		"laminar/B738/switch/rwy_light_left_on","laminar/B738/switch/rwy_light_left_off","laminar/B738/switch/rwy_light_left_toggle")
	sysLights.rwyRightSwitch 	= TwoStateCmdSwitch:new("rwyright",drefRWYRight,0,
		"laminar/B738/switch/rwy_light_right_on","laminar/B738/switch/rwy_light_right_off","laminar/B738/switch/rwy_light_right_toggle")
else
	sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefGenericLights,2)
	sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright",drefGenericLights,3)
end
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- ** Wing Lights
if kc_is_zibo then
	sysLights.wingSwitch 		= TwoStateCmdSwitch:new("wing","laminar/B738/toggle_switch/wing_light",0,
		"laminar/B738/switch/wing_light_on","laminar/B738/switch/wing_light_off","laminar/B738/switch/wing_light_toggle")
else
	sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefGenericLights,-1)
end
-- ** Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights,-1)

-- ** Wheel well Lights
if kc_is_zibo then
	sysLights.wheelSwitch 		= TwoStateDrefSwitch:new("wheel","laminar/B738/toggle_switch/wheel_light",0)
else
	sysLights.wheelSwitch 		= TwoStateDrefSwitch:new("wheel",drefGenericLights,5)
end
-- ** Wheel well Light(s) status
sysLights.wheelAnc 			= SimpleAnnunciator:new("wheellights",drefGenericLights,5)

-- ** Logo Light
if kc_is_zibo then
	sysLights.logoSwitch 		= TwoStateCmdSwitch:new("logo","laminar/B738/toggle_switch/logo_light",0,
		"laminar/B738/switch/logo_light_on","laminar/B738/switch/logo_light_off","laminar/B738/switch/logo_light_toggle")
	-- ** Logo Light(s) status
	sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","laminar/B738/toggle_switch/logo_light",0)
else
	sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo",drefGenericLights,1)
	-- ** Logo Light(s) status
	sysLights.logoAnc 			= SimpleAnnunciator:new("logolights",drefGenericLights,1)
end

-- ** Dome Light
if kc_is_zibo then
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
else
	sysLights.domeLightSwitch 	= TwoStateCmdSwitch:new("dome",drefGenericLights,9)
end
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)

sysLights.emerLights		= InopSwitch:new("emerlights")


-- Emergency Exit Lights
if kc_is_zibo then
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
else
	sysLights.emerLights = TwoStateCustomSwitch:new("","laminar/B738/toggle_switch/emer_exit_lights",0,
	function ()
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		if get("laminar/B738/button_switch/guard_cover_pos",5) ~= 0 then
			command_once("laminar/B738/guard_cover05")
		end	
	end,
	function ()
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		if get("laminar/B738/button_switch/guard_cover_pos",5) == 0 then
			command_once("laminar/B738/guard_cover05")
		end
	end,
	function ()
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		if get("laminar/B738/button_switch/guard_cover_pos",5) == 0 then
			command_once("laminar/B738/guard_cover05")
		end	
	end,
	function ()
		if get("laminar/B738/toggle_switch/emer_exit_lights") > 0 then
			return 1
		else
			return 0
		end
	end)

end

return sysLights

-- B7x7 FF B757 & B767 airplane 
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

logMsg("B7x7 sysLights")

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft","1-sim/lights/landingL/switch",0,
	function () 
		set("1-sim/lights/landingL/switch/anim",1)
		set("1-sim/lights/landingL/switch",1)		
	end,
	function () 
		set("1-sim/lights/landingL/switch/anim",0)
		set("1-sim/lights/landingL/switch",0)		
	end,
	function () 
		if get("1-sim/lights/landingL/switch") == 0 then
			set("1-sim/lights/landingL/switch/anim",1)
			set("1-sim/lights/landingL/switch",1)
		else
			set("1-sim/lights/landingL/switch/anim",0)
			set("1-sim/lights/landingL/switch",0)	
		end
	end,
	function () return get("1-sim/lights/landingL/switch") end,null,
	function (value)
		set("1-sim/lights/landingL/switch/anim",value)
		set("1-sim/lights/landingL/switch",value)
	end)
sysLights.llRightSwitch 	= TwoStateCustomSwitch:new("llright","1-sim/lights/landingR/switch",0,
	function () 
		set("1-sim/lights/landingR/switch/anim",1)
		set("1-sim/lights/landingR/switch",1)		
	end,
	function () 
		set("1-sim/lights/landingR/switch/anim",0)
		set("1-sim/lights/landingR/switch",0)		
	end,
	function () 
		if get("1-sim/lights/landingR/switch") == 0 then
			set("1-sim/lights/landingR/switch/anim",1)
			set("1-sim/lights/landingR/switch",1)
		else
			set("1-sim/lights/landingR/switch/anim",0)
			set("1-sim/lights/landingR/switch",0)	
		end
	end,
	function () return get("1-sim/lights/landingR/switch") end,null,
	function (value)
		set("1-sim/lights/landingR/switch/anim",value)
		set("1-sim/lights/landingR/switch",value)
	end)
sysLights.ll3rdSwitch 		= TwoStateCustomSwitch:new("ll3rd","1-sim/lights/landingN/switch",0,
	function () 
		set("1-sim/lights/landingN/switch/anim",1)
		set("1-sim/lights/landingN/switch",1)		
	end,
	function () 
		set("1-sim/lights/landingN/switch/anim",0)
		set("1-sim/lights/landingN/switch",0)		
	end,
	function () 
		if get("1-sim/lights/landingN/switch") == 0 then
			set("1-sim/lights/landingN/switch/anim",1)
			set("1-sim/lights/landingN/switch",1)
		else
			set("1-sim/lights/landingN/switch/anim",0)
			set("1-sim/lights/landingN/switch",0)	
		end
	end,
	function () return get("1-sim/lights/landingN/switch") end,null,
	function (value)
		set("1-sim/lights/landingN/switch/anim",value)
		set("1-sim/lights/landingN/switch",value)
	end)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if sysLights.llLeftSwitch:getStatus() > 0 or sysLights.llRightSwitch:getStatus() > 0  or sysLights.ll3rdSwitch:getStatus() > 0 then
		return 1
	else
		return 0
	end
end)

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateCustomSwitch:new("rwyleft","1-sim/lights/runwayL/switch",0,
	function () 
		set("1-sim/lights/runwayL/switch/anim",1)
		set("1-sim/lights/runwayL/switch",1)		
	end,
	function () 
		set("1-sim/lights/runwayL/switch/anim",0)
		set("1-sim/lights/runwayL/switch",0)		
	end,
	function () 
		if get("1-sim/lights/runwayL/switch") == 0 then
			set("1-sim/lights/runwayL/switch/anim",1)
			set("1-sim/lights/runwayL/switch",1)
		else
			set("1-sim/lights/runwayL/switch/anim",0)
			set("1-sim/lights/runwayL/switch",0)	
		end
	end,
	function () return get("1-sim/lights/runwayL/switch") end,null,
	function (value)
		set("1-sim/lights/runwayL/switch/anim",value)
		set("1-sim/lights/runwayL/switch",value)
	end)
sysLights.rwyRightSwitch 	= TwoStateCustomSwitch:new("rwyleft","1-sim/lights/runwayR/switch",0,
	function () 
		set("1-sim/lights/runwayR/switch/anim",1)
		set("1-sim/lights/runwayR/switch",1)		
	end,
	function () 
		set("1-sim/lights/runwayR/switch/anim",0)
		set("1-sim/lights/runwayR/switch",0)		
	end,
	function () 
		if get("1-sim/lights/runwayR/switch") == 0 then
			set("1-sim/lights/runwayR/switch/anim",1)
			set("1-sim/lights/runwayR/switch",1)
		else
			set("1-sim/lights/runwayR/switch/anim",0)
			set("1-sim/lights/runwayR/switch",0)	
		end
	end,
	function () return get("1-sim/lights/runwayR/switch") end,null,
	function (value)
		set("1-sim/lights/runwayR/switch/anim",value)
		set("1-sim/lights/runwayR/switch",value)
	end)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)
-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get("1-sim/lights/runwayL/switch",0) > 0 or get("1-sim/lights/runwayR/switch",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= SwitchGroup:new("taxilights")
sysLights.taxiSwitch:addSwitch(sysLights.rwyLeftSwitch) 
sysLights.taxiSwitch:addSwitch(sysLights.rwyRightSwitch) 
-- Taxi Light(s) status
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
function () 
	if get("1-sim/lights/runwayL/switch",0) > 0 or get("1-sim/lights/runwayR/switch",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position","anim/43/button",0,
	function () 
		set("anim/43/button/anim",1)
		set("anim/43/button",1)		
	end,
	function () 
		set("anim/43/button/anim",0)
		set("anim/43/button",0)		
	end,
	function () 
		if get("anim/43/button") == 0 then
			set("anim/43/button/anim",1)
			set("anim/43/button",1)
		else
			set("anim/43/button/anim",0)
			set("anim/43/button",0)	
		end
	end,
	function () return get("anim/43/button") end,null,
	function (value)
		set("anim/43/button/anim",value)
		set("anim/43/button",value)
	end)
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","anim/43/button",0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","anim/45/button",0,
	function () 
		set("anim/45/button/anim",1)
		set("anim/45/button",1)		
	end,
	function () 
		set("anim/45/button/anim",0)
		set("anim/45/button",0)		
	end,
	function () 
		if get("anim/45/button") == 0 then
			set("anim/45/button/anim",1)
			set("anim/45/button",1)
		else
			set("anim/45/button/anim",0)
			set("anim/45/button",0)	
		end
	end,
	function () return get("anim/45/button") end,null,
	function (value)
		set("anim/45/button/anim",value)
		set("anim/45/button",value)
	end)
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","anim/45/button",0)

-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateCustomSwitch:new("beacon","anim/44/button",0,
	function () 
		set("anim/44/button/anim",1)
		set("anim/44/button",1)		
	end,
	function () 
		set("anim/44/button/anim",0)
		set("anim/44/button",0)		
	end,
	function () 
		if get("anim/44/button") == 0 then
			set("anim/44/button/anim",1)
			set("anim/44/button",1)
		else
			set("anim/44/button/anim",0)
			set("anim/44/button",0)	
		end
	end,
	function () return get("anim/44/button") end,null,
	function (value)
		set("anim/44/button/anim",value)
		set("anim/44/button",value)
	end)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","anim/44/button",0)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateCustomSwitch:new("wing","anim/46/button",0,
	function () 
		set("anim/46/button/anim",1)
		set("anim/46/button",1)		
	end,
	function () 
		set("anim/46/button/anim",0)
		set("anim/46/button",0)		
	end,
	function () 
		if get("anim/46/button") == 0 then
			set("anim/46/button/anim",1)
			set("anim/46/button",1)
		else
			set("anim/46/button/anim",0)
			set("anim/46/button",0)	
		end
	end,
	function () return get("anim/46/button") end,null,
	function (value)
		set("anim/46/button/anim",value)
		set("anim/46/button",value)
	end)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights","anim/46/button",0)

-- **Logo Light
sysLights.logoSwitch 		= TwoStateCustomSwitch:new("logo","anim/52/button",0,
	function () 
		set("anim/52/button/anim",1)
		set("anim/52/button",1)		
	end,
	function () 
		set("anim/52/button/anim",0)
		set("anim/52/button",0)		
	end,
	function () 
		if get("anim/52/button") == 0 then
			set("anim/52/button/anim",1)
			set("anim/52/button",1)
		else
			set("anim/52/button/anim",0)
			set("anim/52/button",0)	
		end
	end,
	function () return get("anim/52/button") end,null,
	function (value)
		set("anim/52/button/anim",value)
		set("anim/52/button",value)
	end)
-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","anim/52/button",0)

-- ---- internal lights

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","1-sim/EICAS/CDUbrtRotary",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","1-sim/EICAS2/CDUbrtRotary",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("panellight4","lights/glareshield1_rhe",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("panellight4","lights/aisel_rhe",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights","1-sim/EICAS/CDUbrtRotary",0)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","lights/flood_rhe",0)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2","lights/aux_rhe",0)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3","lights/panel_rhe",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","lights/dome/flood_rhe",0)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get("lights/dome/flood_rhe",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

sysLights.emerLights		= TwoStateDrefSwitch:new("emerlights","1-sim/emer/lights",0)

return sysLights

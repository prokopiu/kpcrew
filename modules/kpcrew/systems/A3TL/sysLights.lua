-- ToLiss Airbusses 
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

sysLights = require("kpcrew.systems.DFLT.sysLights")

logMsg("A3TL sysLights")

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon","AirbusFBW/OHPLightSwitches",-1)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","AirbusFBW/OHPLightSwitches",-1)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position","AirbusFBW/OHPLightSwitches",2,
function () 
	if get("AirbusFBW/OHPLightSwitches",2) == 0 then
		set_array("AirbusFBW/OHPLightSwitches",2,1)
	end
end,
function ()
	set_array("AirbusFBW/OHPLightSwitches",2,0)
end,
function () 
	if get("AirbusFBW/OHPLightSwitches",2) == 0 then
		set_array("AirbusFBW/OHPLightSwitches",2,1)
	else
		set_array("AirbusFBW/OHPLightSwitches",2,0)
	end
end,
function ()
	if get("AirbusFBW/OHPLightSwitches",2) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Position Light(s) status
sysLights.positionAnc 		= CustomAnnunciator:new("positionlights",
function () 
	if get("AirbusFBW/OHPLightSwitches",2) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft","AirbusFBW/OHPLightSwitches",4,
function () 
	set_array("AirbusFBW/OHPLightSwitches",4,2)
end,
function ()
	set_array("AirbusFBW/OHPLightSwitches",4,0)
end,
function () 
	if get("AirbusFBW/OHPLightSwitches",4) == 0 then
		set_array("AirbusFBW/OHPLightSwitches",4,2)
	else
		set_array("AirbusFBW/OHPLightSwitches",4,0)
	end
end,
function ()
	if get("AirbusFBW/OHPLightSwitches",4) == 2 then 
		return 1
	else
		return 0
	end
end)
sysLights.llRightSwitch 	= TwoStateCustomSwitch:new("llright","AirbusFBW/OHPLightSwitches",5,
function () 
	set_array("AirbusFBW/OHPLightSwitches",5,2)
end,
function ()
	set_array("AirbusFBW/OHPLightSwitches",5,0)
end,
function () 
	if get("AirbusFBW/OHPLightSwitches",5) == 0 then
		set_array("AirbusFBW/OHPLightSwitches",5,2)
	else
		set_array("AirbusFBW/OHPLightSwitches",5,0)
	end
end,
function ()
	if get("AirbusFBW/OHPLightSwitches",5) == 2 then 
		return 1
	else
		return 0
	end
end)
sysLights.ll3rdSwitch 		= InopSwitch:new("ll3rd")
sysLights.ll4thSwitch 		= InopSwitch:new("ll3rd")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get("AirbusFBW/OHPLightSwitches",4) == 2 or get("AirbusFBW/OHPLightSwitches",5) == 2 then
		return 1
	else
		return 0
	end
end)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","AirbusFBW/OHPLightSwitches",7,
function () 
	set_array("AirbusFBW/OHPLightSwitches",7,2)
end,
function ()
	set_array("AirbusFBW/OHPLightSwitches",7,0)
end,
function () 
	if get("AirbusFBW/OHPLightSwitches",7) == 0 then
		set_array("AirbusFBW/OHPLightSwitches",7,2)
	else
		set_array("AirbusFBW/OHPLightSwitches",7,0)
	end
end,
function ()
	if get("AirbusFBW/OHPLightSwitches",7) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Strobe Light(s) status
sysLights.strobesAnc 		= CustomAnnunciator:new("strobelights",
function () 
	if get("AirbusFBW/OHPLightSwitches",7) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi","AirbusFBW/OHPLightSwitches",3)

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","AirbusFBW/OHPLightSwitches",3)

-- Logo Light
sysLights.logoSwitch 		= TwoStateCustomSwitch:new("logo","AirbusFBW/OHPLightSwitches",2,
function () 
	if get("AirbusFBW/OHPLightSwitches",2) < 2 then
		set_array("AirbusFBW/OHPLightSwitches",2,2)
	end
end,
function ()
	if get("AirbusFBW/OHPLightSwitches",2) > 0 then
		set_array("AirbusFBW/OHPLightSwitches",2,1)
	end
end,
function () 
	if get("AirbusFBW/OHPLightSwitches",2) == 0 then
		set_array("AirbusFBW/OHPLightSwitches",2,2)
	else
		set_array("AirbusFBW/OHPLightSwitches",2,1)
	end
end,
function ()
	if get("AirbusFBW/OHPLightSwitches",2) == 2 then 
		return 1
	else
		return 0
	end
end)

-- Logo Light(s) status
sysLights.logoAnc 			= CustomAnnunciator:new("logolights",
function () 
	if get("AirbusFBW/OHPLightSwitches",2) == 2 then 
		return 1
	else
		return 0
	end
end)

-- Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing","AirbusFBW/OHPLightSwitches",1)

-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights","AirbusFBW/OHPLightSwitches",1)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft","AirbusFBW/OHPLightSwitches",6)
sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- runway turnoff lights
sysLights.runwayAnc 		= SimpleAnnunciator:new("runwaylights","AirbusFBW/OHPLightSwitches",6)

-- Dome Light
if PLANE_ICAO ~= "A339" then
	sysLights.domeLightSwitch 	= TwoStateCustomSwitch:new("dome","ckpt/oh/domeLight/anim",0,
	function () 
		command_once("toliss_airbus/lightcommands/DomeLightDown")
		command_once("toliss_airbus/lightcommands/DomeLightDown")
		command_once("toliss_airbus/lightcommands/DomeLightUp")
	end,
	function ()
		command_once("toliss_airbus/lightcommands/DomeLightDown")
		command_once("toliss_airbus/lightcommands/DomeLightDown")
	end,
	function () 
		if get("AirbusFBW/OHPLightSwitches",2) == 0 then
			set_array("AirbusFBW/OHPLightSwitches",2,2)
		else
			set_array("AirbusFBW/OHPLightSwitches",2,1)
		end
	end,
	function ()
		if get("AirbusFBW/OHPLightSwitches",2) == 2 then 
			return 1
		else
			return 0
		end
	end)
else
	sysLights.domeLightSwitch 	= TwoStateCustomSwitch:new("dome","AirbusFBW/OHPLightSwitches",13,
	function () 
		set_array("AirbusFBW/OHPLightSwitches",13,1)
	end,
	function ()
		set_array("AirbusFBW/OHPLightSwitches",13,0)
	end,
	function () 
		if get("AirbusFBW/OHPLightSwitches",13) == 0 then
			set_array("AirbusFBW/OHPLightSwitches",13,1)
		else
			set_array("AirbusFBW/OHPLightSwitches",13,0)
		end
	end,
	function ()
		if get("AirbusFBW/OHPLightSwitches",13) > 0 then 
			return 1
		else
			return 0
		end
	end)
end

sysLights.domeLightSwitch2 	= InopSwitch:new("dome2")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)

-- Dome Light(s) status
if PLANE_ICAO ~= "A339" then
	sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
	function () 
		if get( "sim/cockpit/electrical/cockpit_lights",0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
else
	sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
	function () 
		if get("AirbusFBW/OHPLightSwitches",13) ~= 0 then
			return 1
		else
			return 0
		end
	end)
end

sysLights.emerLights		= TwoStateCmdSwitch:new("emerlights","ckpt/oh/emerExitLight/anim",0,
"toliss_airbus/lightcommands/EmerExitLightUp","toliss_airbus/lightcommands/EmerExitLightDown","nocommand")

return sysLights

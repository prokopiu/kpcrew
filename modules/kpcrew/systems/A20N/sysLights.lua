-- ToLiss A20n airplane 
-- Aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateCustomSwitch:new("beacon","AirbusFBW/OHPLightSwitches",0,
	function () 
		command_once("toliss_airbus/lightcommands/BeaconOn")
	end,
	function () 
		command_once("toliss_airbus/lightcommands/BeaconOff")
	end,
	function () 
		command_once("toliss_airbus/lightcommands/BeaconToggle")
	end,
	function () 
		return get("AirbusFBW/OHPLightSwitches",0)
	end
)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch = TwoStateDrefSwitch:new("strobes","AirbusFBW/OHPLightSwitches",7)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch = TwoStateDrefSwitch:new("taxi","AirbusFBW/OHPLightSwitches",3)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch = TwoStateDrefSwitch:new("llleft","AirbusFBW/OHPLightSwitches",4)
sysLights.llRightSwitch = TwoStateDrefSwitch:new("llright","AirbusFBW/OHPLightSwitches",5)
sysLights.landLightGroup = SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch = TwoStateDrefSwitch:new("logo","AirbusFBW/OHPLightSwitches",2)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch = TwoStateDrefSwitch:new("rwyleft","AirbusFBW/OHPLightSwitches",3)
sysLights.rwyRightSwitch = TwoStateDrefSwitch:new("rwyright","AirbusFBW/OHPLightSwitches",6)
sysLights.rwyLightGroup = SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Dome Light
sysLights.domeLightSwitch = InopSwitch:new("wheel","ckpt/oh/domeLight/anim",0)

-- Instrument Lights
sysLights.instr1Light = TwoStateDrefSwitch:new("instr1","AirbusFBW/OHPBrightnessLevel",0)
sysLights.instr2Light = TwoStateDrefSwitch:new("","AirbusFBW/PanelFloodBrightnessLevel",0)
sysLights.instr3Light = TwoStateDrefSwitch:new("","AirbusFBW/PanelBrightnessLevel",0)
sysLights.instr4Light = TwoStateDrefSwitch:new("","AirbusFBW/PedestalFloodBrightnessLevel",0)
sysLights.instr5Light = TwoStateDrefSwitch:new("","AirbusFBW/DUBrightness",0)
sysLights.instr6Light = TwoStateDrefSwitch:new("","AirbusFBW/FCUIntegralBrightness",0)
sysLights.instrLightGroup = SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)

--------- Annunciators
-- annunciator to mark any landing lights on
sysLights.landingAnc = CustomAnnunciator:new("landinglights",
function () 
	if get("AirbusFBW/OHPLightSwitches",3) > 0 or get("AirbusFBW/OHPLightSwitches",6) > 0 then
		return 1
	else
		return 0
	end
end)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc = SimpleAnnunciator:new("beaconlights","AirbusFBW/OHPLightSwitches",0)

-- Strobe Light(s) status
sysLights.strobesAnc = SimpleAnnunciator:new("strobelights","AirbusFBW/OHPLightSwitches",7)

-- Taxi Light(s) status
sysLights.taxiAnc = SimpleAnnunciator:new("strobelights","AirbusFBW/OHPLightSwitches",3)

-- Logo Light(s) status
sysLights.logoAnc = SimpleAnnunciator:new("logolights","AirbusFBW/OHPLightSwitches",2)

-- runway turnoff lights
sysLights.runwayAnc = CustomAnnunciator:new("runwaylights",
function () 
	if get("AirbusFBW/OHPLightSwitches",4) > 0 or get("AirbusFBW/OHPLightSwitches",5) > 0 then
		return 1
	else
		return 0
	end
end)

-- Dome Light(s) status
sysLights.domeAnc = InopSwitch:new("domelights",
function () 
	if get("ckpt/oh/domeLight/anim") ~= 0 then
		return 1
	else
		return 0
	end
end)

return sysLights
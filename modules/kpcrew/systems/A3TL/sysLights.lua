-- ToLiss Airbusses 
-- Aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysLights.beaconSwitch
-- sysLights.beaconAnc
-- sysLights.positionSwitch
-- sysLights.positionAnc 
-- sysLights.strobesSwitch
-- sysLights.strobesAnc
-- sysLights.llLeftSwitch
-- sysLights.llRightSwitch
-- sysLights.ll3rdSwitch 	
-- sysLights.ll4thSwitch 	
-- sysLights.landLightGroup
-- sysLights.landingAnc
-- sysLights.taxiSwitch
-- sysLights.taxiAnc
-- sysLights.logoSwitch
-- sysLights.logoAnc
-- sysLights.wingSwitch
-- sysLights.wingAnc
-- sysLights.rwyLeftSwitch 
-- sysLights.rwyRightSwitch
-- sysLights.rwyLightGroup 
-- sysLights.runwayAnc
-- sysLights.domeLightSwitch
-- sysLights.domeLightSwitch2
-- sysLights.domeLightGroup 
-- sysLights.domeAnc
-- sysLights.emerLights
-- Macro: kc_macro_lights

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

--------- Switch datarefs common
local drefBeaconLight		= "AirbusFBW/OHPLightSwitches"
local drefPositionLights	= "AirbusFBW/OHPLightSwitches"
local drefStrobeLights		= "AirbusFBW/OHPLightSwitches"
local drefTaxiLights		= "AirbusFBW/OHPLightSwitches"
local drefLandingLights 	= "AirbusFBW/OHPLightSwitches"
local drefLogoLights		= "AirbusFBW/OHPLightSwitches"
local drefWingLights		= "AirbusFBW/OHPLightSwitches"
local drefRWYLights			= "AirbusFBW/OHPLightSwitches"
local drefDomeLight			= "AirbusFBW/OHPLightSwitches"
local drefEmerLights		= "ckpt/oh/emerExitLight/anim"
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"
local drefCockpitLights		= "sim/cockpit/electrical/cockpit_lights"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdEmerLightsOn		= "toliss_airbus/lightcommands/EmerExitLightUp"
local cmdEmerLightsOff		= "toliss_airbus/lightcommands/EmerExitLightDown"


-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon",drefBeaconLight,-1)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights",drefBeaconLight,-1)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position",drefPositionLights,2,
function () 
	if get(drefPositionLights,2) == 0 then
		set_array(drefPositionLights,2,1)
	end
end,
function ()
	set_array(drefPositionLights,2,0)
end,
function () 
	if get(drefPositionLights,2) == 0 then
		set_array(drefPositionLights,2,1)
	else
		set_array(drefPositionLights,2,0)
	end
end,
function ()
	if get(drefPositionLights,2) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Position Light(s) status
sysLights.positionAnc 		= CustomAnnunciator:new("positionlights",
function () 
	if get(drefPositionLights,2) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft",drefLandingLights,4,
function () 
	set_array(drefLandingLights,4,2)
end,
function ()
	set_array(drefLandingLights,4,0)
end,
function () 
	if get(drefLandingLights,4) == 0 then
		set_array(drefLandingLights,4,2)
	else
		set_array(drefLandingLights,4,0)
	end
end,
function ()
	if get(drefLandingLights,4) == 2 then 
		return 1
	else
		return 0
	end
end)
sysLights.llRightSwitch 	= TwoStateCustomSwitch:new("llright",drefLandingLights,5,
function () 
	set_array(drefLandingLights,5,2)
end,
function ()
	set_array(drefLandingLights,5,0)
end,
function () 
	if get(drefLandingLights,5) == 0 then
		set_array(drefLandingLights,5,2)
	else
		set_array(drefLandingLights,5,0)
	end
end,
function ()
	if get(drefLandingLights,5) == 2 then 
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
	if get(drefLandingLights,4) == 2 or get(drefLandingLights,5) == 2 then
		return 1
	else
		return 0
	end
end)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes",drefStrobeLights,7,
function () 
	set_array(drefStrobeLights,7,2)
end,
function ()
	set_array(drefStrobeLights,7,0)
end,
function () 
	if get(drefStrobeLights,7) == 0 then
		set_array(drefStrobeLights,7,2)
	else
		set_array(drefStrobeLights,7,0)
	end
end,
function ()
	if get(drefStrobeLights,7) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Strobe Light(s) status
sysLights.strobesAnc 		= CustomAnnunciator:new("strobelights",
function () 
	if get(drefStrobeLights,7) > 0 then 
		return 1
	else
		return 0
	end
end)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi",drefTaxiLights,3)

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights",drefTaxiLights,3)

-- Logo Light
sysLights.logoSwitch 		= TwoStateCustomSwitch:new("logo",drefLogoLights,2,
function () 
	if get(drefLogoLights,2) < 2 then
		set_array(drefLogoLights,2,2)
	end
end,
function ()
	if get(drefLogoLights,2) > 0 then
		set_array(drefLogoLights,2,1)
	end
end,
function () 
	if get(drefLogoLights,2) == 0 then
		set_array(drefLogoLights,2,2)
	else
		set_array(drefLogoLights,2,1)
	end
end,
function ()
	if get(drefLogoLights,2) == 2 then 
		return 1
	else
		return 0
	end
end)

-- Logo Light(s) status
sysLights.logoAnc 			= CustomAnnunciator:new("logolights",
function () 
	if get(drefLogoLights,2) == 2 then 
		return 1
	else
		return 0
	end
end)

-- Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefWingLights,1)

-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefWingLights,1)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefRWYLights,6)
sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- runway turnoff lights
sysLights.runwayAnc 		= SimpleAnnunciator:new("runwaylights",drefRWYLights,6)

-- Dome Light
if PLANE_ICAO ~= "A339" then
	sysLights.domeLightSwitch 	= TwoStateCustomSwitch:new("dome",drefDomeLight,8,
	function ()
		set_array(drefDomeLight,8,2)
	end,
	function ()
		set_array(drefDomeLight,8,0)
	end,
	function () 
		if get(drefDomeLight,8) == 0 then
			set_array(drefDomeLight,8,2)
		else
			set_array(drefDomeLight,8,0)
		end
	end,
	function ()
		if get(drefDomeLight,8) > 0 then 
			return 1
		else
			return 0
		end
	end)
else
	sysLights.domeLightSwitch 	= TwoStateCustomSwitch:new("dome",drefDomeLight,13,
	function () 
		set_array(drefDomeLight,13,1)
	end,
	function ()
		set_array(drefDomeLight,13,0)
	end,
	function () 
		if get(drefDomeLight,13) == 0 then
			set_array(drefDomeLight,13,1)
		else
			set_array(drefDomeLight,13,0)
		end
	end,
	function ()
		if get(drefDomeLight,13) > 0 then 
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
		if get(drefDomeLight,8) ~= 0 then
			return 1
		else
			return 0
		end
	end)
else
	sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
	function () 
		if get(drefDomeLight,13) ~= 0 then
			return 1
		else
			return 0
		end
	end)
end

sysLights.emerLights		= TwoStateCmdSwitch:new("emerlights",drefEmerLights,0,
cmdEmerLightsOn,cmdEmerLightsOff,"nocommand")

-- ====================================== Lights related functions
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
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
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
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
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
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	elseif flightphase == kc_phase_before_takeoff then
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:setValue(2)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	elseif flightphase == kc_phase_approach then
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:setValue(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end

		kc_macro_lights_descend_10k()
	elseif flightphase == kc_phase_afterland then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:setValue(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	else
		logMsg("Invalid flightphase")
	end	

end

return sysLights

-- B742 airplane 
-- Aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysLights.beaconSwitch 	
-- sysLights.beaconAnc 		
-- sysLights.strobesSwitch 	
-- sysLights.strobesAnc 	
-- sysLights.positionSwitch 
-- sysLights.positionAnc 	
-- sysLights.llLeftSwitch 	
-- sysLights.llRightSwitch 	
-- sysLights.ll3rdSwitch 	
-- sysLights.ll4thSwitch 	
-- sysLights.landLightGroup 
-- sysLights.rwyLeftSwitch 	
-- sysLights.rwyRightSwitch 
-- sysLights.rwyLightGroup 	
-- sysLights.runwayAnc 		
-- sysLights.taxiSwitch 	
-- sysLights.taxiAnc 		
-- sysLights.logoSwitch 	
-- sysLights.logoAnc 		
-- sysLights.wingSwitch 	
-- sysLights.wingAnc 		
-- sysLights.domeLightSwitch 	
-- sysLights.domeLightSwitch2 	
-- sysLights.domeLightGroup 	
-- sysLights.domeAnc 
-- sysLights.panel1Light		
-- sysLights.panel2Light		
-- sysLights.panel3Light		
-- sysLights.panelLightGroup
-- sysLights.instr1Light		
-- sysLights.instr2Light		
-- sysLights.instr3Light		
-- sysLights.instr4Light		
-- sysLights.instr5Light		
-- sysLights.instr6Light		
-- sysLights.instrLightGroup
-- sysLights.emerLights

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

logMsg("B742 sysLights")

--------- Switch datarefs common
local drefBeaconLight		= "B742/ext_light/beacon_sw"
local drefPositionLights	= "B742/ext_light/NAV_sw"
local drefStrobeLights		= "B742/ext_light/strobe_sw"
local drefLandingLeft	 	= "B742/ext_light/landing_outbd_L_sw"	
local drefLandingRight	 	= "B742/ext_light/landing_outbd_R_sw"	
local drefLandingLeft2	 	= "B742/ext_light/landing_inbd_L_sw"	
local drefLandingRight2	 	= "B742/ext_light/landing_inbd_R_sw"	
local drefRWYLightL			= "B742/ext_light/runway_turnoff_L_sw"
local drefRWYLightR			= "B742/ext_light/runway_turnoff_R_sw"
local drefLogoLights		= "B742/ext_light/logo_sw"
local drefWingLights		= "B742/ext_light/wing_sw"
local drefDomeLight			= "B742/cockpit_light/dome"
local drefPanelLights1 		= "B742/cockpit_light/main_panel_bkgr"
local drefPanelLights2 		= "B742/cockpit_light/map_left_panel"
local drefPanelLights3 		= "B742/cockpit_light/map_right_panel"
local drefInstrLights1 		= "B742/cockpit_light/center_fwd_panel"
local drefInstrLights2 		= "B742/cockpit_light/control_stand_panel"
local drefInstrLights3 		= "B742/cockpit_light/front_left_big_panel"
local drefInstrLights4 		= "B742/cockpit_light/front_panel"
local drefInstrLights5 		= "B742/cockpit_light/front_right_big_panel"
local drefInstrLights6 		= "B742/cockpit_light/FE_panel"
local drefEmerLightsSw		= "B742/OVHD/emerg_lights_sw"
local drefEmerLightsCap		= "B742/OVHD/emerg_lights_cap"

--------- Annunciator datarefs common

--------- Switch commands common

----------- Switches

-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon",drefBeaconLight,0)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights",drefBeaconLight,0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes",drefStrobeLights,0)
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights",drefStrobeLights,0)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position",drefPositionLights,0)
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights",drefPositionLights,0)

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft",drefLandingLeft,0)
sysLights.llRightSwitch 	= TwoStateDrefSwitch:new("llright",drefLandingRight,0)
sysLights.ll3rdSwitch 		= TwoStateDrefSwitch:new("ll3rd",drefLandingLeft2,0)
sysLights.ll4thSwitch 		= TwoStateDrefSwitch:new("ll4th",drefLandingRight2,0)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefRWYLightL,0)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright",drefRWYLightR,0)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get(drefRWYLightL) > 0 or get(drefRWYLightR) > 0 then
		return 1
	else
		return 0
	end
end)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 	= SwitchGroup:new("taxilights")
sysLights.taxiSwitch:addSwitch(sysLights.rwyLeftSwitch)
sysLights.taxiSwitch:addSwitch(sysLights.rwyRightSwitch)
sysLights.taxiAnc 		= CustomAnnunciator:new("taxilights",
function () return sysLights.runwayAnc:getStatus() end)

-- **Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo",drefLogoLights,0)
-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights",drefLogoLights,0)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefWingLights,0)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefWingLights, 0)

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome",drefDomeLight,0)
sysLights.domeLightSwitch2 	= InopSwitch:new("dome2")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () if get(drefDomeLight) ~= 0 then return 1 else return 0 end end)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1",drefPanelLights1,0)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2",drefPanelLights2,0)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3",drefPanelLights3,0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("instrlite1",drefInstrLights1,0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("instrlite2",drefInstrLights2,0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("instrlite3",drefInstrLights3,0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("instrlite4",drefInstrLights4,0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("instrlite5",drefInstrLights5,0)
sysLights.instr6Light		= TwoStateDrefSwitch:new("instrlite6",drefInstrLights6,0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)

sysLights.emerLights		= TwoStateCustomSwitch:new("emerlights",drefEmerLightsSw,0,
	function() set(drefEmerLightsSw,1) set(drefEmerLightsCap,0) end,
	function() set(drefEmerLightsSw,0) set(drefEmerLightsCap,1) end,
	function() 
		if get(drefEmerLightsSw) == 0 then
			set(drefEmerLightsSw,1)
			set(drefEmerLightsCap,0)
		else
			set(drefEmerLightsSw,0)
			set(drefEmerLightsCap,1)
		end
	end,
	function() return get(drefEmerLightsSw)	end)

--------- Macros

return sysLights

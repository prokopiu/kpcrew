-- B748 airplane 
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

logMsg("B748 sysLights")

-- ** means it is needed for kphardware to work
-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon","ssg/LGT/lgt_bcn_sw",0)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","ssg/LGT/lgt_bcn_sw",0)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position","ssg/LGT/lgt_nav_sw",0)
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","ssg/LGT/lgt_nav_sw",0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes","ssg/LGT/lgt_stb_sw",0)
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","ssg/LGT/lgt_stb_sw",0)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi","ssg/LGT/lgt_taxi_sw",0)
-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","ssg/LGT/lgt_taxi_sw",0)

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft","ssg/LGT/lgt_outL_sw",0)
sysLights.llRightSwitch 	= TwoStateDrefSwitch:new("llright","ssg/LGT/lgt_outR_sw",0)
sysLights.ll3rdSwitch 		= TwoStateDrefSwitch:new("ll3rd","ssg/LGT/lgt_inL_sw",0)
sysLights.ll4thSwitch 		= TwoStateDrefSwitch:new("ll4th","ssg/LGT/lgt_inR_sw",0)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)
-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get("ssg/LGT/lgt_outL_sw",0) > 0 or get("ssg/LGT/lgt_outR_sw",0) > 0  or get("ssg/LGT/lgt_inL_sw",0) > 0 or get("ssg/LGT/lgt_inR_sw",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing","ssg/LGT/lgt_wing_sw",0)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights","ssg/LGT/lgt_wing_sw",0)

-- **Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")
-- Wheel well Light(s) status
sysLights.wheelAnc 			= InopSwitch:new("wheellights")

-- **Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo","ssg/LGT/lgt_logo_sw",0)
-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","ssg/LGT/lgt_logo_sw",0)

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft","ssg/LGT/lgt_rwyL_sw",0)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright","ssg/LGT/lgt_rwyR_sw",0)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)
-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get("ssg/LGT/lgt_rwyL_sw",0) > 0 or get("ssg/LGT/lgt_rwyR_sw",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- ---- internal lights

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","ssg/LGT/dome_sw",0)
sysLights.domeLightSwitch2 	= InopSwitch:new("dome2")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get("ssg/LGT/dome_sw",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("i1","ssg/LGT/lcd_out_brt_sw",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("i2","ssg/LGT/lcd_in_brt_sw",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("i3","ssg/LGT/lcd_upper_brt_sw",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("i4","ssg/LGT/lcd_lower_brt_sw",0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("i5","ssg/LGT/lcd_out_brt_sw",0)
sysLights.instr6Light		= TwoStateDrefSwitch:new("i6","ssg/LGT/lcd_in_brt_sw",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "ssg/LGT/lcd_out_brt_sw",0)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","ssg/LGT/cp_fld_sw",0)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2","ssg/LGT/pnl_up_sw",0)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3","ssg/LGT/fo_fld_sw",0)
sysLights.panel4Light		= TwoStateDrefSwitch:new("panellight4","ssg/LGT/glaresheld_pnl_sw",0)
sysLights.panel5Light		= TwoStateDrefSwitch:new("panellight5","ssg/LGT/glaresheld_sw",0)
sysLights.panel6Light		= TwoStateDrefSwitch:new("panellight6","ssg/LGT/Pnl_ovhd_sw",0)
sysLights.panel7Light		= TwoStateDrefSwitch:new("panellight7","ssg/LGT/std_fld_sw",0)
sysLights.panel8Light		= TwoStateDrefSwitch:new("panellight8","ssg/LGT/std_pnl_sw",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel4Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel5Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel6Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel7Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel8Light)

sysLights.emerLights		= TwoStateCustomSwitch:new("emerlights","ssg/LGT/emerg_lights_sw",0,
	function () 
		set("ssg/LGT/emerg_lights_sw",0)
		set("ssg/LGT/emerg_lights_cover",0)
	end,
	function () 
		set("ssg/LGT/emerg_lights_sw",-1)
		set("ssg/LGT/emerg_lights_cover",1)
	end,
	function ()
		if get("ssg/LGT/emerg_lights_sw") < 0 then
			set("ssg/LGT/emerg_lights_sw",0)
			set("ssg/LGT/emerg_lights_cover",0)
		else
			set("ssg/LGT/emerg_lights_sw",-1)
			set("ssg/LGT/emerg_lights_cover",1)
		end
	end,
	function ()
		if get("ssg/LGT/emerg_lights_sw") < 0 then
			return 0
		else
			return 1
		end
	end)

return sysLights

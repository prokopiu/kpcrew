-- A350 airplane 
-- EFIS functionality

-- @classmod sysEFIS
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysEFIS = {
	mapRange_5 		= 0,
	mapRange10 		= 1,
	mapRange20 		= 2,
	mapRange40 		= 3,
	mapRange80 		= 4,
	mapRange160 	= 5,
	mapRange320 	= 6,
	mapRange640 	= 6,
	
	mapModeAPP 		= 0,
	mapModeVOR 		= 1,
	mapModeMAP 		= 2,
	mapModePLAN 	= 4,
	
	voradfVOR 		= 1,
	voradfOFF 		= 0,
	voradfADF 		= -1,
	
	minsTypeRadio 	= 0,
	minsTypeBaro 	= 1
}

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

--------- Switch datarefs common


--------- Annunciator datarefs common


--------- Switch commands common


--------- Actuator definitions


-- MAP ZOOM
sysEFIS.mapZoomPilot 		= MultiStateCmdSwitch:new("mapzoompilot","sim/cockpit/switches/EFIS_map_range_selector",0,
	"sim/instruments/map_zoom_in","sim/instruments/map_zoom_out",0,6,false)
sysEFIS.mapZoomCopilot 		= InopSwitch:new("mapzoomcopilot")

-- MAP MODE
sysEFIS.mapModePilot 		= MultiStateCmdSwitch:new("mapmodepilot","sim/cockpit/switches/EFIS_map_submode",0,
	"sim/instruments/EFIS_mode_dn","sim/instruments/EFIS_mode_up",0,4,false)
sysEFIS.mapModeCopilot 		= InopSwitch:new("mapmodecopilot")

-- CTR
sysEFIS.ctrPilot 			= InopSwitch:new("ctrpilot")
sysEFIS.ctrCopilot 			= InopSwitch:new("ctrcopilot")

-- TFC
sysEFIS.tfcPilot 			= InopSwitch:new("tfcpilot")
sysEFIS.tfcCopilot 			= InopSwitch:new("tfccopilot")

-- WX 
sysEFIS.wxrPilot 			= TwoStateToggleSwitch:new("wxrpilot",
	"sim/cockpit2/EFIS/EFIS_weather_on",0,"sim/instruments/EFIS_wxr")
sysEFIS.wxrCopilot 			= InopSwitch:new("wxrcopilot")

-- STA / VOR
sysEFIS.staPilot 			= TwoStateToggleSwitch:new("stapilot","sim/cockpit2/EFIS/EFIS_vor_on",0,
	"sim/instruments/EFIS_vor")
sysEFIS.staCopilot 			= InopSwitch:new("stacopilot")

-- WPT
sysEFIS.wptPilot 			= TwoStateToggleSwitch:new("wptpilot","sim/cockpit2/EFIS/EFIS_fix_on",0,
	"sim/instruments/EFIS_fix")
sysEFIS.wptCopilot 			= InopSwitch:new("wptcopilot")

-- ARPT
sysEFIS.arptPilot 			= TwoStateToggleSwitch:new("arptpilot","sim/cockpit/switches/EFIS_shows_airports",0,
	"sim/instruments/EFIS_apt")
sysEFIS.arptCopilot 		= InopSwitch:new("arptcopilot")

-- DATA
sysEFIS.dataPilot 			= InopSwitch:new("datapilot")
sysEFIS.dataCopilot 		= InopSwitch:new("datacopilot")

-- NAV/POS
sysEFIS.posPilot 			= InopSwitch:new("pospilot")
sysEFIS.posCopilot 			= InopSwitch:new("poscopilot")

-- TERR
sysEFIS.terrPilot 			= InopSwitch:new("terrpilot")
sysEFIS.terrCopilot 		= InopSwitch:new("terrcopilot")

-- FPV
sysEFIS.fpvPilot 			= InopSwitch:new("fpvpilot")
sysEFIS.fpvCopilot 			= InopSwitch:new("fpvcopilot")

-- MTRS
sysEFIS.mtrsPilot 			= InopSwitch:new("mtrspilot")
sysEFIS.mtrsCopilot 		= InopSwitch:new("mtrscopilot")

-- MINS type
sysEFIS.minsTypePilot 		= InopSwitch:new("minstypepilot")
sysEFIS.minsTypeCopilot 	= InopSwitch:new("minstypecopilot")

-- MINS RESET
sysEFIS.minsResetPilot 		= InopSwitch:new("minsresetpilot")
sysEFIS.minsResetCopilot 	= InopSwitch:new("minsresetcopilot")

-- MINS SET
sysEFIS.minsPilot 			= MultiStateCmdSwitch:new("minspilot","sim/cockpit/misc/radio_altimeter_minimum",0,
	"sim/instruments/dh_ref_down","sim/instruments/dh_ref_up",0,999,false)
sysEFIS.minsCopilot 		= InopSwitch:new("minscopilot")

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= InopSwitch:new("voradf1pilot")
sysEFIS.voradf1Copilot 		= InopSwitch:new("voradf1copilot")

-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= InopSwitch:new("vorad2pilot")
sysEFIS.voradf2Copilot 		= InopSwitch:new("vorad2copilot")

------------- Annunciators

-- UI
function sysEFIS:render(ypos,height)

	-- reposition when screen size changes
	if kh_efis_wnd_state < 0 then
		float_wnd_set_position(kh_efis_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 25, ypos-height)
		kh_efis_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_efis_wnd_state == 1 then
		imgui.Button("<", 17, 25)
		if imgui.IsItemActive() then 
			kh_efis_wnd_state = 0
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 25, ypos-height)
		end
	end

	if kh_efis_wnd_state == 0 then
		imgui.Button("E", 17, 25)
		if imgui.IsItemActive() then 
			kh_efis_wnd_state = 1
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 790, ypos-height)
		end
	end

	kc_imgui_label_mcp("ND:",10)
	kc_imgui_simple_actuator("MODE <",sysEFIS.mapModePilot,cmdDown,10,47,25)
	kc_imgui_simple_actuator("MODE >",sysEFIS.mapModePilot,cmdUp,10,47,25)
	kc_imgui_simple_actuator("ZOOM <",sysEFIS.mapZoomPilot,cmdDown,10,47,25)
	kc_imgui_simple_actuator("ZOOM >",sysEFIS.mapZoomPilot,cmdUp,10,47,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("WXR",sysEFIS.wxrPilot,10,30,25)
	kc_imgui_toggle_button_mcp("APT",sysEFIS.arptPilot,10,30,25)
	kc_imgui_toggle_button_mcp("NAV",sysEFIS.staPilot,10,30,25)
	kc_imgui_toggle_button_mcp("WPT",sysEFIS.wptPilot,10,30,25)
	kc_imgui_label_mcp("| MINS",10)
	kc_imgui_rotary_mcp("%04d",sysEFIS.minsPilot,10,31)
	kc_imgui_label_mcp("| BARO",10)
	kc_imgui_simple_actuator("DN",sysGeneral.baroGroup,cmdDown,10,23,25)
	kc_imgui_value("%04d ",sysGeneral.baroMbar,10)
	kc_imgui_value("%5.2f",sysGeneral.baroInhg,10)
	kc_imgui_simple_actuator("UP",sysGeneral.baroGroup,cmdUp,10,23,25)
end

return sysEFIS
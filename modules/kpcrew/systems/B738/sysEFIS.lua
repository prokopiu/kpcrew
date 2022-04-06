-- B738 airplane 
-- EFIS functionality

local sysEFIS = {
	mapRange_5 = 0,
	mapRange10 = 1,
	mapRange20 = 2,
	mapRange40 = 3,
	mapRange80 = 4,
	mapRange160 = 5,
	mapRange320 = 6,
	mapRange640 = 7,
	
	mapModeAPP = 0,
	mapModeVOR = 1,
	mapModeMAP = 2,
	mapModePLAN = 3,
	
	voradfVOR = 1,
	voradfOFF = 0,
	voradfADF = -1,
	
	minsTypeRadio = 0,
	minsTypeBaro = 1
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

------------- Switches

-- MAP ZOOM
sysEFIS.mapZoomPilot = MultiStateCmdSwitch:new("mapzoompilot","laminar/B738/EFIS/capt/map_range",0,"laminar/B738/EFIS_control/capt/map_range_dn","laminar/B738/EFIS_control/capt/map_range_up")
sysEFIS.mapZoomCopilot = MultiStateCmdSwitch:new("mapzoomcopilot","laminar/B738/EFIS/fo/map_range",0,"laminar/B738/EFIS_control/fo/map_range_dn","laminar/B738/EFIS_control/fo/map_range_up")

-- MAP MODE
sysEFIS.mapModePilot = MultiStateCmdSwitch:new("mapmodepilot","laminar/B738/EFIS_control/capt/map_mode_pos",0,"laminar/B738/EFIS_control/capt/map_mode_dn","laminar/B738/EFIS_control/capt/map_mode_up")
sysEFIS.mapModeCopilot = MultiStateCmdSwitch:new("mapmodecopilot","laminar/B738/EFIS_control/fo/map_mode_pos",0,"laminar/B738/EFIS_control/fo/map_mode_dn","laminar/B738/EFIS_control/fo/map_mode_up")

-- CTR
sysEFIS.ctrPilot = TwoStateToggleSwitch:new("ctrpilot","laminar/B738/EFIS_control/capt/exp_map",0,"laminar/B738/EFIS_control/capt/push_button/ctr_press")
sysEFIS.ctrCopilot = TwoStateToggleSwitch:new("ctrcopilot","laminar/B738/EFIS_control/fo/exp_map",0,"laminar/B738/EFIS_control/fo/push_button/ctr_press")

-- TFC
sysEFIS.tfcPilot = TwoStateToggleSwitch:new("tfcpilot","laminar/B738/EFIS/tcas_off_show",0,"laminar/B738/EFIS_control/capt/push_button/tfc_press")
sysEFIS.tfcCopilot = TwoStateToggleSwitch:new("tfccopilot","laminar/B738/EFIS/tcas_off_show_fo",0,"laminar/B738/EFIS_control/fo/push_button/tfc_press")

-- WX 
sysEFIS.wxrPilot = TwoStateToggleSwitch:new("wxrpilot","laminar/B738/EFIS/EFIS_wx_on",0,"laminar/B738/EFIS_control/capt/push_button/wxr_press")
sysEFIS.wxrCopilot = TwoStateToggleSwitch:new("wxrcopilot","laminar/B738/EFIS/fo/EFIS_wx_on",0,"laminar/B738/EFIS_control/fo/push_button/wxr_press")

-- STA / VOR
sysEFIS.staPilot = TwoStateToggleSwitch:new("stapilot","laminar/B738/EFIS/EFIS_vor_on",0,"laminar/B738/EFIS_control/capt/push_button/sta_press")
sysEFIS.staCopilot = TwoStateToggleSwitch:new("stacopilot","laminar/B738/EFIS/fo/EFIS_vor_on",0,"laminar/B738/EFIS_control/fo/push_button/sta_press")

-- WPT
sysEFIS.wptPilot = TwoStateToggleSwitch:new("wptpilot","laminar/B738/EFIS/EFIS_fix_on",0,"laminar/B738/EFIS_control/capt/push_button/wpt_press")
sysEFIS.wptCopilot = TwoStateToggleSwitch:new("wptcopilot","laminar/B738/EFIS/fo/EFIS_fix_on",0,"laminar/B738/EFIS_control/fo/push_button/wpt_press")

-- ARPT
sysEFIS.arptPilot = TwoStateToggleSwitch:new("arptpilot","laminar/B738/EFIS/EFIS_airport_on",0,"laminar/B738/EFIS_control/capt/push_button/arpt_press")
sysEFIS.arptCopilot = TwoStateToggleSwitch:new("arptcopilot","laminar/B738/EFIS/fo/EFIS_airport_on",0,"laminar/B738/EFIS_control/fo/push_button/arpt_press")

-- DATA
sysEFIS.dataPilot = TwoStateToggleSwitch:new("datapilot","laminar/B738/EFIS/capt/data_status",0,"laminar/B738/EFIS_control/capt/push_button/data_press")
sysEFIS.dataCopilot = TwoStateToggleSwitch:new("datacopilot","laminar/B738/EFIS/fo/data_status",0,"laminar/B738/EFIS_control/fo/push_button/data_press")

-- NAV/POS
sysEFIS.posPilot = TwoStateToggleSwitch:new("pospilot","laminar/B738/EFIS_control/capt/push_button/pos",0,"laminar/B738/EFIS_control/capt/push_button/pos_press")
sysEFIS.posCopilot = TwoStateToggleSwitch:new("poscopilot","laminar/B738/EFIS_control/fo/push_button/pos",0,"laminar/B738/EFIS_control/fo/push_button/pos_press")

-- TERR
sysEFIS.terrPilot = TwoStateToggleSwitch:new("terrpilot","laminar/B738/EFIS_control/capt/terr_on",0,"laminar/B738/EFIS_control/capt/push_button/terr_press")
sysEFIS.terrCopilot = TwoStateToggleSwitch:new("terrcopilot","laminar/B738/EFIS_control/fo/terr_on",0,"laminar/B738/EFIS_control/fo/push_button/terr_press")

-- FPV
sysEFIS.fpvPilot = TwoStateToggleSwitch:new("fpvpilot","laminar/B738/PFD/capt/fpv_on",0,"laminar/B738/EFIS_control/capt/push_button/fpv_press")
sysEFIS.fpvCopilot = TwoStateToggleSwitch:new("fpvcopilot","laminar/B738/PFD/fo/fpv_on",0,"laminar/B738/EFIS_control/fo/push_button/fpv_press")

-- MTRS
sysEFIS.mtrsPilot = TwoStateToggleSwitch:new("mtrspilot","laminar/B738/PFD/capt/alt_mode_is_meters",0,"laminar/B738/EFIS_control/capt/push_button/mtrs_press")
sysEFIS.mtrsCopilot = TwoStateToggleSwitch:new("mtrscopilot","laminar/B738/PFD/fo/alt_mode_is_meters",0,"laminar/B738/EFIS_control/fo/push_button/mtrs_press")

-- MINS type
sysEFIS.minsTypePilot = MultiStateCmdSwitch:new("minstypepilot","laminar/B738/EFIS_control/cpt/minimums_pfd",0,"laminar/B738/EFIS_control/cpt/minimums_dn","laminar/B738/EFIS_control/cpt/minimums_up")
sysEFIS.minsTypeCopilot = MultiStateCmdSwitch:new("minstypecopilot","laminar/B738/EFIS_control/fo/minimums_pfd",0,"laminar/B738/EFIS_control/fo/minimums_dn","laminar/B738/EFIS_control/cpt/minimums_up")

-- MINS RESET
sysEFIS.minsResetPilot = TwoStateToggleSwitch:new("minsresetpilot","laminar/B738/EFIS_control/cpt/minimums_show",0,"laminar/B738/EFIS_control/capt/push_button/rst_press")
sysEFIS.minsResetCopilot = TwoStateToggleSwitch:new("minsresetcopilot","laminar/B738/EFIS_control/fo/minimums_show",0,"laminar/B738/EFIS_control/fo/push_button/rst_press")

-- MINS SET
sysEFIS.minsPilot = MultiStateCmdSwitch:new("minspilot","laminar/B738/pfd/dh_pilot",0,"laminar/B738/pfd/dh_pilot_dn","laminar/B738/pfd/dh_pilot_up")
sysEFIS.minsCopilot = MultiStateCmdSwitch:new("minscopilot","laminar/B738/pfd/dh_copilot",0,"laminar/B738/pfd/dh_copilot_dn","laminar/B738/pfd/dh_copilot_up")

-- VOR/ADF 1
sysEFIS.voradf1Pilot = MultiStateCmdSwitch:new("voradf1pilot","laminar/B738/EFIS_control/capt/vor1_off_pfd",0,"laminar/B738/EFIS_control/capt/vor1_off_dn","laminar/B738/EFIS_control/capt/vor1_off_up")
sysEFIS.voradf1Copilot = MultiStateCmdSwitch:new("voradf1copilot","laminar/B738/EFIS_control/fo/vor1_off_pfd",0,"laminar/B738/EFIS_control/fo/vor1_off_dn","laminar/B738/EFIS_control/fo/vor1_off_up")

-- VOR/ADF 2
sysEFIS.voradf2Pilot = MultiStateCmdSwitch:new("vorad2pilot","laminar/B738/EFIS_control/capt/vor2_off_pfd",0,"laminar/B738/EFIS_control/capt/vor2_off_dn","laminar/B738/EFIS_control/capt/vor2_off_up")
sysEFIS.voradf2Copilot = MultiStateCmdSwitch:new("vorad2copilot","laminar/B738/EFIS_control/fo/vor2_off_pfd",0,"laminar/B738/EFIS_control/fo/vor2_off_dn","laminar/B738/EFIS_control/fo/vor2_off_up")


------------- Annunciators

sysEFIS.baroStandby = SimpleAnnunciator:new("","laminar/B738/knobs/standby_alt_baro",0)

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
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 1005, ypos-height)
		end
	end

	kc_imgui_label_mcp("ND:",10)
	kc_imgui_simple_actuator("MODE <",sysEFIS.mapModePilot,cmdDown,10,47,25)
	kc_imgui_simple_actuator("MODE >",sysEFIS.mapModePilot,cmdUp,10,47,25)
	kc_imgui_simple_actuator("ZOOM <",sysEFIS.mapZoomPilot,cmdDown,10,47,25)
	kc_imgui_simple_actuator("ZOOM >",sysEFIS.mapZoomPilot,cmdUp,10,47,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("WXR",sysEFIS.wxrPilot,10,30,25)
	kc_imgui_toggle_button_mcp("STA",sysEFIS.staPilot,10,30,25)
	kc_imgui_toggle_button_mcp("WPT",sysEFIS.wptPilot,10,30,25)
	kc_imgui_toggle_button_mcp("APT",sysEFIS.arptPilot,10,30,25)
	kc_imgui_toggle_button_mcp("DAT",sysEFIS.dataPilot,10,30,25)
	kc_imgui_toggle_button_mcp("POS",sysEFIS.posPilot,10,30,25)
	kc_imgui_toggle_button_mcp("TERR",sysEFIS.terrPilot,10,35,25)
	kc_imgui_label_mcp("| MINS",10)
	kc_imgui_simple_actuator("RADIO",sysEFIS.minsTypePilot,cmdUp,10,40,25)
	kc_imgui_simple_actuator("BARO",sysEFIS.minsTypePilot,cmdDown,10,40,25)
	kc_imgui_rotary_mcp("%04d",sysEFIS.minsPilot,10,31)
	kc_imgui_label_mcp("| BARO",10)
	kc_imgui_simple_actuator("DN",sysGeneral.baroGroup,cmdDown,10,23,25)
	kc_imgui_value((sysGeneral.baroModePilot:getStatus() == 0) and "%5.2f" or "%04d ",sysGeneral.baroStandby,10)
	kc_imgui_simple_actuator("UP",sysGeneral.baroGroup,cmdUp,10,23,25)
	kc_imgui_toggle_button_mcp("STD",sysGeneral.barostdGroup,10,35,25)

end

return sysEFIS
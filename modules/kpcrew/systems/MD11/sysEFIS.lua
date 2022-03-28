-- DFLT airplane 
-- EFIS functionality

local sysEFIS = {
	mapRange10 = 0,
	mapRange20 = 1,
	mapRange40 = 2,
	mapRange80 = 3,
	mapRange160 = 4,
	mapRange320 = 5,
	mapRange640 = 6,
	cnvRange = {10, 20, 40, 80, 160, 320, 640 },
	
	mapModeAPP = 0,
	mapModeVOR = 1,
	mapModeMAP = 2,
	mapModePLAN = 4,
	mapModeTCAS = 5,
	cnvModes = {0, 1, 5, 2, 4},
	
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
sysEFIS.mapZoomPilot = MultiStateCmdSwitch:new("mapzoompilot","sim/cockpit/switches/EFIS_map_range_selector",0,"Rotate/aircraft/controls_c/eis_range_decr_l","Rotate/aircraft/controls_c/eis_range_incr_l")
sysEFIS.mapZoomCopilot = InopSwitch:new("mapzoomcopilot")

-- MAP MODEs MAP VOR TCAS PLAN APPR
sysEFIS.mapPLAN = TwoStateCustomSwitch:new("PLAN","Rotate/aircraft/systems/gcp_rqst_plan_mode",0,
	function () 
	end,
	function () 
	end,	
	function () 
		if get("Rotate/aircraft/systems/gcp_rqst_plan_mode",0) == 0 then
			set_array("Rotate/aircraft/systems/gcp_rqst_plan_mode",0,1)
			set_array("Rotate/aircraft/systems/gcp_rqst_appr_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_map_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_tcas_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_vor_mode",0,0)
		end
	end
)
sysEFIS.mapMAP = TwoStateCustomSwitch:new("MAP","Rotate/aircraft/systems/gcp_rqst_map_mode",0,
	function () 
	end,
	function () 
	end,	
	function () 
		if get("Rotate/aircraft/systems/gcp_rqst_map_mode",0) == 0 then
			set_array("Rotate/aircraft/systems/gcp_rqst_plan_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_appr_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_map_mode",0,1)
			set_array("Rotate/aircraft/systems/gcp_rqst_tcas_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_vor_mode",0,0)
		end
	end
)
sysEFIS.mapVOR = TwoStateCustomSwitch:new("VOR","Rotate/aircraft/systems/gcp_rqst_vor_mode",0,
	function () 
	end,
	function () 
	end,	
	function () 
		if get("Rotate/aircraft/systems/gcp_rqst_vor_mode",0) == 0 then
			set_array("Rotate/aircraft/systems/gcp_rqst_plan_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_appr_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_map_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_tcas_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_vor_mode",0,1)
		end
	end
)
sysEFIS.mapAPPR = TwoStateCustomSwitch:new("PLAN","Rotate/aircraft/systems/gcp_rqst_appr_mode",0,
	function () 
	end,
	function () 
	end,	
	function () 
		if get("Rotate/aircraft/systems/gcp_rqst_appr_mode",0) == 0 then
			set_array("Rotate/aircraft/systems/gcp_rqst_plan_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_appr_mode",0,1)
			set_array("Rotate/aircraft/systems/gcp_rqst_map_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_tcas_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_vor_mode",0,0)
		end
	end
)
sysEFIS.mapTCAS = TwoStateCustomSwitch:new("TCAS","Rotate/aircraft/systems/gcp_rqst_tcas_mode",0,
	function () 
	end,
	function () 
	end,	
	function () 
		if get("Rotate/aircraft/systems/gcp_rqst_tcas_mode",0) == 0 then
			set_array("Rotate/aircraft/systems/gcp_rqst_plan_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_appr_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_map_mode",0,0)
			set_array("Rotate/aircraft/systems/gcp_rqst_tcas_mode",0,1)
			set_array("Rotate/aircraft/systems/gcp_rqst_vor_mode",0,0)
		end
	end
)

sysEFIS.mapModePilot = MultiStateCmdSwitch:new("mapmodepilot","sim/cockpit/switches/EFIS_map_submode",0,"sim/instruments/EFIS_mode_dn","sim/instruments/EFIS_mode_up")
sysEFIS.mapModeCopilot = InopSwitch:new("mapmodecopilot")

-- CTR
sysEFIS.ctrPilot = InopSwitch:new("ctrpilot")
sysEFIS.ctrCopilot = InopSwitch:new("ctrcopilot")

-- TFC
sysEFIS.tfcPilot = TwoStateToggleSwitch:new("tfcpilot","Rotate/aircraft/systems/instr_nd_trfc_ann",0,"Rotate/aircraft/controls_c/eis_show_traffic_l")
sysEFIS.tfcCopilot = InopSwitch:new("tfccopilot")

-- WX 
sysEFIS.wxrPilot = TwoStateToggleSwitch:new("wxrpilot","Rotate/aircraft/systems/gcp_wx_show",0,"Rotate/aircraft/controls_c/eis_wx_on_l")
sysEFIS.wxrCopilot = InopSwitch:new("wxrcopilot")

-- STA / VOR
sysEFIS.staPilot = TwoStateToggleSwitch:new("stapilot","Rotate/aircraft/systems/instr_nd_vor_ann",0,"Rotate/aircraft/controls_c/eis_show_vor_l")
sysEFIS.staCopilot = InopSwitch:new("stacopilot")

-- WPT
sysEFIS.wptPilot = TwoStateToggleSwitch:new("wptpilot","Rotate/aircraft/systems/instr_nd_wpt_ann",0,"Rotate/aircraft/controls_c/eis_show_wpt_l")
sysEFIS.wptCopilot = InopSwitch:new("wptcopilot")

-- ARPT
sysEFIS.arptPilot = TwoStateToggleSwitch:new("arptpilot","Rotate/aircraft/systems/gcp_rqst_apt_info",0,"Rotate/aircraft/controls_c/eis_show_apt_l")
sysEFIS.arptCopilot = InopSwitch:new("arptcopilot")

-- DATA
sysEFIS.dataPilot = TwoStateToggleSwitch:new("datapilot","Rotate/aircraft/systems/instr_nd_data_ann",0,"Rotate/aircraft/controls_c/eis_show_data_l")
sysEFIS.dataCopilot = InopSwitch:new("datacopilot")

-- NAV/POS
sysEFIS.posPilot = InopSwitch:new("pospilot")
sysEFIS.posCopilot = InopSwitch:new("poscopilot")

-- TERR
sysEFIS.terrPilot = InopSwitch:new("terrpilot")
sysEFIS.terrCopilot = InopSwitch:new("terrcopilot")

-- FPV
sysEFIS.fpvPilot = InopSwitch:new("fpvpilot")
sysEFIS.fpvCopilot = InopSwitch:new("fpvcopilot")

-- MTRS
sysEFIS.mtrsPilot = InopSwitch:new("mtrspilot")
sysEFIS.mtrsCopilot = InopSwitch:new("mtrscopilot")

-- MINS type
sysEFIS.minsTypePilot = MultiStateCmdSwitch:new("minstypepilot","Rotate/aircraft/systems/instr_alt_minim_baro_show",0,"Rotate/aircraft/controls_c/minim_alt_set_l_dn","Rotate/aircraft/controls_c/minim_alt_set_l_dn")
sysEFIS.minsTypeCopilot = InopSwitch:new("minstypecopilot")

-- MINS RESET
sysEFIS.minsResetPilot = InopSwitch:new("minsresetpilot")
sysEFIS.minsResetCopilot = InopSwitch:new("minsresetcopilot")

-- MINS SET
sysEFIS.minsPilot = MultiStateCmdSwitch:new("minspilot","Rotate/aircraft/systems/instr_alt_minimums_ra_rel",0,"Rotate/aircraft/controls_c/minim_alt_set_l_dn","Rotate/aircraft/controls_c/minim_alt_set_l_up")
sysEFIS.minsCopilot = InopSwitch:new("minscopilot")

-- VOR/ADF 1
sysEFIS.voradf1Pilot = InopSwitch:new("voradf1pilot")
sysEFIS.voradf1Copilot = InopSwitch:new("voradf1copilot")

-- VOR/ADF 2
sysEFIS.voradf2Pilot = InopSwitch:new("vorad2pilot")
sysEFIS.voradf2Copilot = InopSwitch:new("vorad2copilot")


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
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 1000, ypos-height)
		end
	end

	kc_imgui_label_mcp("ND:",10)
	kc_imgui_toggle_button_mcp("MAP",sysEFIS.mapMAP,10,30,25)
	kc_imgui_toggle_button_mcp("VOR",sysEFIS.mapVOR,10,30,25)
	kc_imgui_toggle_button_mcp("TCAS",sysEFIS.mapTCAS,10,35,25)
	kc_imgui_toggle_button_mcp("PLAN",sysEFIS.mapPLAN,10,35,25)
	kc_imgui_toggle_button_mcp("APPR",sysEFIS.mapAPPR,10,35,25)
	kc_imgui_simple_actuator("ZOOM <",sysEFIS.mapZoomPilot,cmdDown,10,47,25)
	kc_imgui_simple_actuator("ZOOM >",sysEFIS.mapZoomPilot,cmdUp,10,47,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("TRFC",sysEFIS.tfcPilot,10,35,25)
	kc_imgui_toggle_button_mcp("DATA",sysEFIS.dataPilot,10,35,25)
	kc_imgui_toggle_button_mcp("WPT",sysEFIS.wptPilot,10,30,25)
	kc_imgui_toggle_button_mcp("VOR",sysEFIS.staPilot,10,30,25)
	kc_imgui_toggle_button_mcp("ARPT",sysEFIS.arptPilot,10,35,25)
	kc_imgui_toggle_button_mcp("WXR",sysEFIS.wxrPilot,10,30,25)
	kc_imgui_label_mcp("| MINS",10)
	kc_imgui_rotary_mcp("%04d",sysEFIS.minsPilot,10,31)
	kc_imgui_label_mcp("| BARO",10)
	kc_imgui_simple_actuator("DN",sysGeneral.baroGroup,cmdDown,10,23,25)
	kc_imgui_value("%04d ",sysGeneral.baroMbar,10)
	kc_imgui_value("%5.2f",sysGeneral.baroInhg,10)
	kc_imgui_simple_actuator("UP",sysGeneral.baroGroup,cmdUp,10,23,25)
	kc_imgui_toggle_button_mcp("STD",sysGeneral.barostdGroup,10,30,25)
end

return sysEFIS
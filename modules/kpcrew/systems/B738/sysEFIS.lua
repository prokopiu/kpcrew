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

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch = require "kpcrew.systems.InopSwitch"

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
sysEFIS.minsPilot = MultiStateCmdSwitch:new("minspilot","laminar/B738/EFIS_control/pfd/baro_min_cpt",0,"laminar/B738/pfd/dh_pilot_dn","laminar/B738/pfd/dh_pilot_up")
sysEFIS.minsCopilot = MultiStateCmdSwitch:new("minscopilot","laminar/B738/EFIS_control/pfd/baro_min_fo",0,"laminar/B738/pfd/dh_copilot_dn","laminar/B738/pfd/dh_copilot_up")

-- VOR/ADF 1
sysEFIS.voradf1Pilot = MultiStateCmdSwitch:new("voradf1pilot","laminar/B738/EFIS_control/capt/vor1_off_pfd",0,"laminar/B738/EFIS_control/capt/vor1_off_dn","laminar/B738/EFIS_control/capt/vor1_off_up")
sysEFIS.voradf1Copilot = MultiStateCmdSwitch:new("voradf1copilot","laminar/B738/EFIS_control/fo/vor1_off_pfd",0,"laminar/B738/EFIS_control/fo/vor1_off_dn","laminar/B738/EFIS_control/fo/vor1_off_up")

-- VOR/ADF 2
sysEFIS.voradf2Pilot = MultiStateCmdSwitch:new("vorad2pilot","laminar/B738/EFIS_control/capt/vor2_off_pfd",0,"laminar/B738/EFIS_control/capt/vor2_off_dn","laminar/B738/EFIS_control/capt/vor2_off_up")
sysEFIS.voradf2Copilot = MultiStateCmdSwitch:new("vorad2copilot","laminar/B738/EFIS_control/fo/vor2_off_pfd",0,"laminar/B738/EFIS_control/fo/vor2_off_dn","laminar/B738/EFIS_control/fo/vor2_off_up")


------------- Annunciators

return sysEFIS
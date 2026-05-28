-- B737 airplane Zibo and LevelUp
-- EFIS functionality

-- @classmod sysEFIS
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysEFIS.mapZoomPilot 
-- sysEFIS.mapZoomCopilot
-- sysEFIS.mapModePilot 
-- sysEFIS.mapModeCopilot
-- sysEFIS.ctrPilot 	
-- sysEFIS.ctrCopilot 	
-- sysEFIS.tfcPilot 	
-- sysEFIS.tfcCopilot 	
-- sysEFIS.wxrPilot 	
-- sysEFIS.wxrCopilot 	
-- sysEFIS.staPilot 	
-- sysEFIS.staCopilot 	
-- sysEFIS.wptPilot 	
-- sysEFIS.wptCopilot 	
-- sysEFIS.arptPilot 	
-- sysEFIS.arptCopilot 
-- sysEFIS.dataPilot 	
-- sysEFIS.dataCopilot 
-- sysEFIS.posPilot 	
-- sysEFIS.posCopilot 	
-- sysEFIS.terrPilot 	
-- sysEFIS.terrCopilot 
-- sysEFIS.fpvPilot 	
-- sysEFIS.fpvCopilot 	
-- sysEFIS.mtrsPilot 	
-- sysEFIS.mtrsCopilot 
-- sysEFIS.minsTypePilot 	
-- sysEFIS.minsTypeCopilot 
-- sysEFIS.minsResetPilot 	
-- sysEFIS.minsResetCopilot
-- sysEFIS.minsPilot 		
-- sysEFIS.minsCopilot 	
-- sysEFIS.voradf1Pilot 	
-- sysEFIS.voradf1Copilot 	
-- sysEFIS.voradf2Pilot 	
-- sysEFIS.voradf2Copilot 	
-- sysEFIS.baroMbar 		
-- sysEFIS.baroInhg 		
-- sysEFIS.barostdPilot 	
-- sysEFIS.barostdCopilot 	
-- sysEFIS.barostdStandby 	
-- sysEFIS.barostdGroup 	
-- sysEFIS.baroModePilot 	
-- sysEFIS.baroModeCoPilot 
-- sysEFIS.baroModeStandby 
-- sysEFIS.baroModeGroup 	
-- sysEFIS.baroPilot 		
-- sysEFIS.baroCoPilot 	
-- sysEFIS.baroStandby 	
-- sysEFIS.baroGroup 	
-- UI: panel_render	

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

sysEFIS = require("kpcrew.systems.DFLT.sysEFIS")

logMsg("B737 sysEFIS")

sysEFIS.mapRange_5 		= 0
sysEFIS.mapRange10 		= 1
sysEFIS.mapRange20 		= 2
sysEFIS.mapRange40 		= 3
sysEFIS.mapRange80 		= 4
sysEFIS.mapRange160 	= 5
sysEFIS.mapRange320 	= 6
sysEFIS.mapRange640 	= 7

sysEFIS.mapModeAPP 		= 0
sysEFIS.mapModeVOR 		= 1
sysEFIS.mapModeMAP 		= 2
sysEFIS.mapModePLAN 	= 3

sysEFIS.voradfVOR 		= 1
sysEFIS.voradfOFF 		= 0
sysEFIS.voradfADF 		= -1

sysEFIS.minsTypeRadio 	= 0
sysEFIS.minsTypeBaro 	= 1

--------- Switch datarefs common
local drefEFISMapRangeL		= "laminar/B738/EFIS/capt/map_range"
local drefEFISMapRangeR		= "laminar/B738/EFIS/fo/map_range"
local drefEFISMapModeL		= "laminar/B738/EFIS_control/capt/map_mode_pos"
local drefEFISMapModeR		= "laminar/B738/EFIS_control/fo/map_mode_pos"
local drefEFISCTRL			= "laminar/B738/EFIS_control/capt/exp_map"
local drefEFISCTRR			= "laminar/B738/EFIS_control/fo/exp_map"
local drefEFISTFCL			= "laminar/B738/EFIS/tcas_on"
local drefEFISTFCR			= "laminar/B738/EFIS/tcas_on_fo"
local drefWXRModeL			= "laminar/B738/EFIS/EFIS_wx_on"
local drefWXRModeR			= "laminar/B738/EFIS/fo/EFIS_wx_on"
local drefEFISModeSTAVORL	= "laminar/B738/EFIS/EFIS_vor_on"
local drefEFISModeSTAVORR	= "laminar/B738/EFIS/fo/EFIS_vor_on"
local drefEFISModeWPTL		= "laminar/B738/EFIS/EFIS_fix_on"
local drefEFISModeWPTR		= "laminar/B738/EFIS/fo/EFIS_fix_on"
local drefEFISModeARPTL		= "laminar/B738/EFIS/EFIS_airport_on"
local drefEFISModeARPTR		= "laminar/B738/EFIS/fo/EFIS_airport_on"
local drefEFISModeDATAL		= "laminar/B738/EFIS/capt/data_status"
local drefEFISModeDATAR		= "laminar/B738/EFIS/fo/data_status"
local drefEFISModePOSL		= "laminar/B738/EFIS_control/capt/push_button/pos"
local drefEFISModePOSR		= "laminar/B738/EFIS_control/fo/push_button/pos"
local drefEFISTERRL			= "laminar/B738/EFIS_control/capt/terr_on"
local drefEFISTERRR			= "laminar/B738/EFIS_control/fo/terr_on"
local drefEFISFPVL			= "laminar/B738/PFD/capt/fpv_on"
local drefEFISFPVR			= "laminar/B738/PFD/fo/fpv_on"
local drefEFISMTRSL			= "laminar/B738/PFD/capt/alt_mode_is_meters"
local drefEFISMTRSR			= "laminar/B738/PFD/fo/alt_mode_is_meters"
local drefEFISMinimumsL		= "laminar/B738/pfd/dh_pilot"
local drefEFISMinimumsR		= "laminar/B738/pfd/dh_pilot"
local drefEFISVORADF1L		= "laminar/B738/EFIS_control/capt/vor1_off_pfd"
local drefEFISVORADF1R		= "laminar/B738/EFIS_control/fo/vor1_off_pfd"
local drefEFISVORADF2L		= "laminar/B738/EFIS_control/capt/vor2_off_pfd"
local drefEFISVORADF2R		= "laminar/B738/EFIS_control/fo/vor2_off_pfd"
local drefBaroStdLeft		= "laminar/B738/EFIS/baro_set_std_pilot"
local drefBaroStdRight 		= "laminar/B738/EFIS/baro_set_std_copilot"
local drefBaroStdStby	 	= "laminar/B738/gauges/standby_alt_std_mode"
local drefBaroModeLeft		= "laminar/B738/EFIS_control/capt/baro_in_hpa"
local drefBaroModeRight 	= "laminar/B738/EFIS_control/fo/baro_in_hpa"
local drefBaroModeStby	 	= "laminar/B738/EFIS_control/fo/baro_in_hpa"
local drefBaroLeft			= "laminar/B738/EFIS/baro_sel_in_hg_pilot"
local drefBaroRight 		= "laminar/B738/EFIS/baro_sel_in_hg_copilot"
local drefBaroStby	 		= "laminar/B738/knobs/standby_alt_baro"

--------- Switch commands common
local cmdEFISMapZoomInL		= "laminar/B738/EFIS_control/capt/map_range_dn"
local cmdEFISMapZoomOutL	= "laminar/B738/EFIS_control/capt/map_range_up"
local cmdEFISMapZoomInR		= "laminar/B738/EFIS_control/fo/map_range_dn"
local cmdEFISMapZoomOutR	= "laminar/B738/EFIS_control/fo/map_range_up"
local cmdEFISMapModeInL		= "laminar/B738/EFIS_control/capt/map_mode_dn"
local cmdEFISMapModeOutL	= "laminar/B738/EFIS_control/capt/map_mode_up"
local cmdEFISMapModeInR		= "laminar/B738/EFIS_control/fo/map_mode_dn"
local cmdEFISMapModeOutR	= "laminar/B738/EFIS_control/fo/map_mode_up"
local cmdEFISCTRTglL		= "laminar/B738/EFIS_control/capt/push_button/ctr_press"
local cmdEFISCTRTglR		= "laminar/B738/EFIS_control/fo/push_button/ctr_press"
local cmdEFISTFCTglL		= "laminar/B738/EFIS_control/capt/push_button/tfc_press"
local cmdEFISTFCTglR		= "laminar/B738/EFIS_control/fo/push_button/tfc_press"
local cmdWXRTglL			= "laminar/B738/EFIS_control/capt/push_button/wxr_press"
local cmdWXRTglR			= "laminar/B738/EFIS_control/fo/push_button/wxr_press"
local cmdEFISModeSTAVORL	= "laminar/B738/EFIS_control/capt/push_button/sta_press"
local cmdEFISModeSTAVORR	= "laminar/B738/EFIS_control/fo/push_button/sta_press"
local cmdEFISModeWPTL		= "laminar/B738/EFIS_control/capt/push_button/wpt_press"
local cmdEFISModeWPTR		= "laminar/B738/EFIS_control/fo/push_button/wpt_press"
local cmdEFISModeARPTL		= "laminar/B738/EFIS_control/capt/push_button/arpt_press"
local cmdEFISModeARPTR		= "laminar/B738/EFIS_control/fo/push_button/arpt_press"
local cmdEFISModeDATAL		= "laminar/B738/EFIS_control/capt/push_button/data_press"
local cmdEFISModeDATAR		= "laminar/B738/EFIS_control/fo/push_button/data_press"
local cmdEFISTERRL			= "laminar/B738/EFIS_control/capt/push_button/terr_press"
local cmdEFISTERRR			= "laminar/B738/EFIS_control/fo/push_button/terr_press"
local cmdEFISFPVL			= "laminar/B738/EFIS_control/capt/push_button/fpv_press"
local cmdEFISFPVR			= "laminar/B738/EFIS_control/fo/push_button/fpv_press"
local cmdEFISMTRSL			= "laminar/B738/EFIS_control/capt/push_button/mtrs_press"
local cmdEFISMTRSR			= "laminar/B738/EFIS_control/fo/push_button/mtrs_press"
local cmdEFISMinimumsDnL	= "laminar/B738/pfd/dh_pilot_dn"
local cmdEFISMinimumsUpL	= "laminar/B738/pfd/dh_pilot_up"
local cmdEFISMinimumsDnR	= "laminar/B738/pfd/dh_copilot_dn"
local cmdEFISMinimumsUpR	= "laminar/B738/pfd/dh_copilot_up"
local cmdEFISVORADF1DnL		= "laminar/B738/EFIS_control/capt/vor1_off_dn"
local cmdEFISVORADF1UpL		= "laminar/B738/EFIS_control/capt/vor1_off_up"
local cmdEFISVORADF2DnL		= "laminar/B738/EFIS_control/capt/vor2_off_dn"
local cmdEFISVORADF2UpL		= "laminar/B738/EFIS_control/capt/vor2_off_up"
local cmdEFISVORADF1DnR		= "laminar/B738/EFIS_control/fo/vor1_off_dn"
local cmdEFISVORADF1UpR		= "laminar/B738/EFIS_control/fo/vor1_off_up"
local cmdEFISVORADF2DnR		= "laminar/B738/EFIS_control/fo/vor2_off_dn"
local cmdEFISVORADF2UpR		= "laminar/B738/EFIS_control/fo/vor2_off_up"
local cmdBaroLeftStd 		= "laminar/B738/EFIS_control/capt/push_button/std_press"
local cmdBaroRightStd 		= "laminar/B738/EFIS_control/fo/push_button/std_press"
local cmdBaroStbyStd 		= "laminar/B738/toggle_switch/standby_alt_baro_std"
local cmdBaroModeUpL		= "laminar/B738/EFIS_control/capt/baro_in_hpa_up"
local cmdBaroModeDnL		= "laminar/B738/EFIS_control/capt/baro_in_hpa_dn"
local cmdBaroModeUpR		= "laminar/B738/EFIS_control/fo/baro_in_hpa_up"
local cmdBaroModeDnR		= "laminar/B738/EFIS_control/fo/baro_in_hpa_dn"
local cmdBaroLeftDown		= "laminar/B738/pilot/barometer_down"
local cmdBaroLeftUp			= "laminar/B738/pilot/barometer_up"
local cmdBaroRightDown		= "laminar/B738/copilot/barometer_down"
local cmdBaroRightUp		= "laminar/B738/copilot/barometer_up"
local cmdBaroStbyDown		= "laminar/B738/knob/standby_alt_baro_dn"

------------- Switches

-- MAP ZOOM
sysEFIS.mapZoomPilot 		= MultiStateCmdSwitch:new("mapzoompilot",drefEFISMapRangeL,0,cmdEFISMapZoomInL,cmdEFISMapZoomOutL,0,7,false)
sysEFIS.mapZoomCopilot 		= MultiStateCmdSwitch:new("mapzoomcopilot",drefEFISMapRangeR,0,cmdEFISMapZoomInR,cmdEFISMapZoomOutR,0,7,false)

-- MAP MODE
sysEFIS.mapModePilot 		= MultiStateCmdSwitch:new("mapmodepilot",drefEFISMapModeL,0,cmdEFISMapModeInL,cmdEFISMapModeOutL,0,3,false)
sysEFIS.mapModeCopilot 		= MultiStateCmdSwitch:new("mapmodecopilot",drefEFISMapModeR,0,cmdEFISMapModeInR,cmdEFISMapModeOutR,0,3,false)
	
	-- CTR
sysEFIS.ctrPilot 			= TwoStateToggleSwitch:new("ctrpilot",drefEFISCTRL,0,cmdEFISCTRTglL)
sysEFIS.ctrCopilot 			= TwoStateToggleSwitch:new("ctrcopilot",drefEFISCTRR,0,cmdEFISCTRTglR)

-- TFC
sysEFIS.tfcPilot 			= TwoStateToggleSwitch:new("tfcpilot",drefEFISTFCL,0,cmdEFISTFCTglL)
sysEFIS.tfcCopilot 			= TwoStateToggleSwitch:new("tfccopilot",drefEFISTFCR,0,cmdEFISTFCTglR)

-- WX 
sysEFIS.wxrPilot 			= TwoStateToggleSwitch:new("wxrpilot",drefWXRModeL,0,cmdWXRTglL)
sysEFIS.wxrCopilot 			= TwoStateToggleSwitch:new("wxrcopilot",drefWXRModeR,0,cmdWXRTglR)

-- STA / VOR
sysEFIS.staPilot 			= TwoStateToggleSwitch:new("stapilot",drefEFISModeSTAVORL,0,cmdEFISModeSTAVORL)
sysEFIS.staCopilot 			= TwoStateToggleSwitch:new("stacopilot",drefEFISModeSTAVORR,0,cmdEFISModeSTAVORR)

-- WPT
sysEFIS.wptPilot 			= TwoStateToggleSwitch:new("wptpilot",drefEFISModeWPTL,0,cmdEFISModeWPTL)
sysEFIS.wptCopilot 			= TwoStateToggleSwitch:new("wptcopilot",drefEFISModeWPTR,0,cmdEFISModeWPTR)

-- ARPT
sysEFIS.arptPilot 			= TwoStateToggleSwitch:new("arptpilot",drefEFISModeARPTL,0,cmdEFISModeARPTL)
sysEFIS.arptCopilot 		= TwoStateToggleSwitch:new("arptcopilot",drefEFISModeARPTR,0,cmdEFISModeARPTR)
	
-- DATA
sysEFIS.dataPilot 			= TwoStateToggleSwitch:new("datapilot",drefEFISModeDATAL,0,cmdEFISModeDATAL)
sysEFIS.dataCopilot 		= TwoStateToggleSwitch:new("datacopilot",drefEFISModeDATAR,0,cmdEFISModeDATAR)

-- NAV/POS
sysEFIS.posPilot 			= TwoStateToggleSwitch:new("pospilot",drefEFISModePOSL,0,cmdEFISModePOSL)
sysEFIS.posCopilot 			= TwoStateToggleSwitch:new("poscopilot",drefEFISModePOSR,0,cmdEFISModePOSR)

-- TERR
sysEFIS.terrPilot 			= TwoStateToggleSwitch:new("terrpilot",drefEFISTERRL,0,cmdEFISTERRL)
sysEFIS.terrCopilot 		= TwoStateToggleSwitch:new("terrcopilot",drefEFISTERRR,0,cmdEFISTERRR)
	
	-- FPV
sysEFIS.fpvPilot 			= TwoStateToggleSwitch:new("fpvpilot",drefEFISFPVL,0,cmdEFISFPVL)
sysEFIS.fpvCopilot 			= TwoStateToggleSwitch:new("fpvcopilot",drefEFISFPVR,0,cmdEFISFPVR)
	
	-- MTRS
sysEFIS.mtrsPilot 			= TwoStateToggleSwitch:new("mtrspilot",drefEFISMTRSL,0,cmdEFISMTRSL)
sysEFIS.mtrsCopilot 		= TwoStateToggleSwitch:new("mtrscopilot",drefEFISMTRSR,0,cmdEFISMTRSR)

-- MINS type
sysEFIS.minsTypePilot 		= TwoStateCustomSwitch:new("minstypepilot","laminar/B738/EFIS_control/cpt/minimums",0,
	function () 
		set("laminar/B738/EFIS_control/cpt/minimums",1)
		set("laminar/B738/EFIS_control/cpt/minimums_pfd",1)
	end,
	function () 
		set("laminar/B738/EFIS_control/cpt/minimums",0)
		set("laminar/B738/EFIS_control/cpt/minimums_pfd",0)
	end,
	function () 
		if get("laminar/B738/EFIS_control/cpt/minimums") == 0 then
			set("laminar/B738/EFIS_control/cpt/minimums",1)
			set("laminar/B738/EFIS_control/cpt/minimums_pfd",1)
		else
			set("laminar/B738/EFIS_control/cpt/minimums",0)
			set("laminar/B738/EFIS_control/cpt/minimums_pfd",0)
		end
	end
)
sysEFIS.minsTypeCopilot 	= TwoStateCustomSwitch:new("minstypecopilot","laminar/B738/EFIS_control/fo/minimums",0,
	function () 
		set("laminar/B738/EFIS_control/fo/minimums",1)
		set("laminar/B738/EFIS_control/fo/minimums_pfd",1)
	end,
	function () 
		set("laminar/B738/EFIS_control/fo/minimums",0)
		set("laminar/B738/EFIS_control/fo/minimums_pfd",0)
	end,
	function () 
		if get("laminar/B738/EFIS_control/fo/minimums") == 0 then
			set("laminar/B738/EFIS_control/fo/minimums",1)
			set("laminar/B738/EFIS_control/fo/minimums_pfd",1)
		else
			set("laminar/B738/EFIS_control/fo/minimums",0)
			set("laminar/B738/EFIS_control/fo/minimums_pfd",0)
		end
	end
)

-- MINS RESET
sysEFIS.minsResetPilot 		= TwoStateDrefSwitch:new("minsresetpilot","laminar/B738/EFIS_control/cpt/minimums_show",0)
sysEFIS.minsResetCopilot 	= TwoStateDrefSwitch:new("minsresetcopilot","laminar/B738/EFIS_control/fo/minimums_show",0)

-- MINS SET
sysEFIS.minsPilot 			= MultiStateCmdSwitch:new("minspilot",drefEFISMinimumsL,0,cmdEFISMinimumsDnL,cmdEFISMinimumsUpL,0,999,false)
sysEFIS.minsCopilot 		= MultiStateCmdSwitch:new("minscopilot",drefEFISMinimumsR,0,cmdEFISMinimumsDnR,cmdEFISMinimumsUpR,0,999,false)

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= MultiStateCmdSwitch:new("voradf1pilot",drefEFISVORADF1L,0,cmdEFISVORADF1DnL,cmdEFISVORADF1UpL,-1,1,true)
sysEFIS.voradf1Copilot 		= MultiStateCmdSwitch:new("voradf1copilot",drefEFISVORADF2L,0,cmdEFISVORADF1DnR,cmdEFISVORADF1UpR,-1,1,true)

-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= MultiStateCmdSwitch:new("vorad2pilot",drefEFISVORADF2L,0,cmdEFISVORADF1DnR,cmdEFISVORADF1UpR,-1,1,true)
sysEFIS.voradf2Copilot 		= MultiStateCmdSwitch:new("vorad2copilot",drefEFISVORADF2R,0,cmdEFISVORADF2DnR,cmdEFISVORADF2UpR,-1,1,true)

-- Baro standard toggle
sysEFIS.barostdPilot 	= TwoStateToggleSwitch:new("barostdpilot",drefBaroStdLeft,0,cmdBaroLeftStd)
sysEFIS.barostdCopilot 	= TwoStateToggleSwitch:new("barostdcopilot",drefBaroStdRight,0,cmdBaroRightStd)
sysEFIS.barostdStandby 	= TwoStateToggleSwitch:new("barostdstandby",drefBaroStdStby,0,	cmdBaroStbyStd)
sysEFIS.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysEFIS.barostdGroup:addSwitch(sysGeneral.barostdPilot)
sysEFIS.barostdGroup:addSwitch(sysGeneral.barostdCopilot)
sysEFIS.barostdGroup:addSwitch(sysGeneral.barostdStandby)

-- Baro mode
sysEFIS.baroModePilot 	= TwoStateCmdSwitch:new("baromodepilot",drefBaroModeLeft,0,cmdBaroModeUpL,cmdBaroModeDnL,"nocommand")
sysEFIS.baroModeCoPilot 	= TwoStateCmdSwitch:new("baromodecopilot",drefBaroModeRight,0,cmdBaroModeUpR,cmdBaroModeDnR,"nocommand")
sysEFIS.baroModeGroup 	= SwitchGroup:new("baromodegroup")
sysEFIS.baroModeGroup:addSwitch(sysGeneral.baroModePilot)
sysEFIS.baroModeGroup:addSwitch(sysGeneral.baroModeCoPilot)

-- Baro value
sysEFIS.baroPilot 		= MultiStateCmdSwitch:new("baropilot",drefBaroLeft,0,cmdBaroLeftDown,cmdBaroLeftUp)
sysEFIS.baroCoPilot 	= MultiStateCmdSwitch:new("barocopilot",drefBaroRight,0,cmdBaroRightDown,cmdBaroRightUp)
sysEFIS.baroStandby 	= MultiStateCmdSwitch:new("barostandby",drefBaroStby,0,cmdBaroStbyDown,cmdBaroStbyUp)
sysEFIS.baroGroup 		= SwitchGroup:new("barogroup")
sysEFIS.baroGroup:addSwitch(sysEFIS.baroPilot)
sysEFIS.baroGroup:addSwitch(sysEFIS.baroCoPilot)
sysEFIS.baroGroup:addSwitch(sysEFIS.baroStandby)

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

function kc_macro_at_trans_lvl()
	if math.abs(get("laminar/B738/EFIS/baro_sel_in_hg_pilot")-29.921249) < 0.01 then 
		sysEFIS.barostdGroup:actuate(0)
	end
	if activeBriefings:get("arrival:atisQNH") ~= "" then
		if activePrefSet:get("general:baro_mode_hpa") then
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
			set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
		else
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH"))) 
		end
	end
end

return sysEFIS
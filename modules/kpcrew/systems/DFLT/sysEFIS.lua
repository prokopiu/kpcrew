-- DFLT airplane 
-- EFIS functionality

local sysEFIS = {
	mapRange_5 = 0,
	mapRange10 = 1,
	mapRange20 = 2,
	mapRange40 = 3,
	mapRange80 = 4,
	mapRange160 = 5,
	mapRange320 = 6,
	mapRange640 = 6,
	
	mapModeAPP = 0,
	mapModeVOR = 1,
	mapModeMAP = 2,
	mapModePLAN = 4,
	
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
sysEFIS.mapZoomPilot = MultiStateCmdSwitch:new("mapzoompilot","sim/cockpit/switches/EFIS_map_range_selector",0,"sim/instruments/map_zoom_in","sim/instruments/map_zoom_out")
sysEFIS.mapZoomCopilot = InopSwitch:new("mapzoomcopilot")

-- MAP MODE
sysEFIS.mapModePilot = MultiStateCmdSwitch:new("mapmodepilot","sim/cockpit/switches/EFIS_map_submode",0,"sim/instruments/EFIS_mode_dn","sim/instruments/EFIS_mode_up")
sysEFIS.mapModeCopilot = InopSwitch:new("mapmodecopilot")

-- CTR
sysEFIS.ctrPilot = InopSwitch:new("ctrpilot")
sysEFIS.ctrCopilot = InopSwitch:new("ctrcopilot")

-- TFC
sysEFIS.tfcPilot = TwoStateToggleSwitch:new("tfcpilot","laminar/B738/EFIS/tcas_off_show",0,"laminar/B738/EFIS_control/capt/push_button/tfc_press")
sysEFIS.tfcCopilot = InopSwitch:new("tfccopilot")

-- WX 
sysEFIS.wxrPilot = TwoStateToggleSwitch:new("wxrpilot","sim/cockpit2/EFIS/EFIS_weather_on",0,"sim/instruments/EFIS_wxr")
sysEFIS.wxrCopilot = InopSwitch:new("wxrcopilot")

-- STA / VOR
sysEFIS.staPilot = TwoStateToggleSwitch:new("stapilot","sim/cockpit2/EFIS/EFIS_vor_on",0,"sim/instruments/EFIS_vor")
sysEFIS.staCopilot = InopSwitch:new("stacopilot")

-- WPT
sysEFIS.wptPilot = TwoStateToggleSwitch:new("wptpilot","sim/cockpit2/EFIS/EFIS_fix_on",0,"sim/instruments/EFIS_fix")
sysEFIS.wptCopilot = InopSwitch:new("wptcopilot")

-- ARPT
sysEFIS.arptPilot = TwoStateToggleSwitch:new("arptpilot","sim/cockpit/switches/EFIS_shows_airports",0,"sim/instruments/EFIS_apt")
sysEFIS.arptCopilot = InopSwitch:new("arptcopilot")

-- DATA
sysEFIS.dataPilot = InopSwitch:new("datapilot")
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
sysEFIS.minsTypePilot = InopSwitch:new("minstypepilot")
sysEFIS.minsTypeCopilot = InopSwitch:new("minstypecopilot")

-- MINS RESET
sysEFIS.minsResetPilot = InopSwitch:new("minsresetpilot")
sysEFIS.minsResetCopilot = InopSwitch:new("minsresetcopilot")

-- MINS SET
sysEFIS.minsPilot = MultiStateCmdSwitch:new("minspilot","sim/cockpit/misc/radio_altimeter_minimum",0,"sim/instruments/dh_ref_down","sim/instruments/dh_ref_up")
sysEFIS.minsCopilot = InopSwitch:new("minscopilot")

-- VOR/ADF 1
sysEFIS.voradf1Pilot = InopSwitch:new("voradf1pilot")
sysEFIS.voradf1Copilot = InopSwitch:new("voradf1copilot")

-- VOR/ADF 2
sysEFIS.voradf2Pilot = InopSwitch:new("vorad2pilot")
sysEFIS.voradf2Copilot = InopSwitch:new("vorad2copilot")


------------- Annunciators

return sysEFIS
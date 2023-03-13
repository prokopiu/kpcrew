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

local drefEfisLeftMapZoom		= "1-sim/fcu/ndZoomLeft/switch"
local drefEfisLeftMapMode		= "1-sim/fcu/ndModeLeft/switch"
local drefEfisRightMapZoom		= "1-sim/fcu/ndZoomRight/switch"
local drefEfisRightMapMode		= "1-sim/fcu/ndModeRight/switch"
local drefEfisLeftTfcMode		= "AirbusFBW/TCASSelectedND1"
local drefEfisRightTfcMode		= "AirbusFBW/TCASSelectedND2"
local drefEfisLeftNavMode		= "1-sim/fcu/navL/flag"
local drefEfisLeftNav2Mode		= "1-sim/fcu/navL2/flag"
local drefEfisRightNavMode		= "1-sim/fcu/navR/flag"
local drefEfisRightNav2Mode		= "1-sim/fcu/navR2/flag"
local drefEfisLeftWX			= "AirbusFBW/WXSelectedND1"
local drefEfisRightWX			= "AirbusFBW/WXSelectedND2"
local drefEfisLeftCSTR			= "AirbusFBW/NDShowCSTRCapt"
local drefEfisRightCSTR			= "AirbusFBW/NDShowCSTRFO"
local drefEfisLeftWPT			= "AirbusFBW/NDShowWPTCapt"
local drefEfisRightWPT			= "AirbusFBW/NDShowWPTFO"
local drefEfisLeftVORD			= "AirbusFBW/NDShowVORDCapt"
local drefEfisRightVORD			= "AirbusFBW/NDShowVORDFO"
local drefEfisLeftARPT			= "AirbusFBW/NDShowARPTCapt"
local drefEfisRightARPT			= "AirbusFBW/NDShowARPTFO"
local drefEfisLeftTERR			= "AirbusFBW/TerrainSelectedND1"
local drefEfisRightTERR			= "AirbusFBW/TerrainSelectedND2"
local drefEfisLeftNDB			= "AirbusFBW/NDShowNDBCapt"
local drefEfisRightNDB			= "AirbusFBW/NDShowNDBFO"
local drefEfisMeters			= "AirbusFBW/MetricAlt"

--------- Annunciator datarefs common


--------- Switch commands common


--------- Actuator definitions


-- **MAP ZOOM
sysEFIS.mapZoomPilot 		= TwoStateCustomSwitch:new("mapzoompilot",drefEfisLeftMapZoom,0,
	function () 
		local val = get(drefEfisLeftMapZoom)
		if val < 6 then 
			set(drefEfisLeftMapZoom,val+1)
		end
	end,
	function () 
		local val = get(drefEfisLeftMapZoom)
		if val > 0 then 
			set(drefEfisLeftMapZoom,val-1)
		end
	end,
	function () 
		return
	end
)
sysEFIS.mapZoomCopilot 		= TwoStateCustomSwitch:new("mapzoompilot",drefEfisRightMapZoom,0,
	function () 
		local val = get(drefEfisRightMapZoom)
		if val < 6 then 
			set(drefEfisRightMapZoom,val+1)
		end
	end,
	function () 
		local val = get(drefEfisRightMapZoom)
		if val > 0 then 
			set(drefEfisLeftMapZoom,val-1)
		end
	end,
	function () 
		return
	end
)
	
-- **MAP MODE
sysEFIS.mapModePilot 		= TwoStateCustomSwitch:new("mapmodepilot",drefEfisRightMapMode,0,
	function () 
		local val = get(drefEfisLeftMapMode)
		if val < 4 then 
			set(drefEfisLeftMapMode,val+1)
		end
	end,
	function () 
		local val = get(drefEfisLeftMapMode)
		if val > 0 then 
			set(drefEfisLeftMapMode,val-1)
		end
	end,
	function () 
		return
	end
)
sysEFIS.mapModeCopilot 		= TwoStateCustomSwitch:new("mapmodecopilot",drefEfisRightMapMode,0,
	function () 
		local val = get(drefEfisRightMapMode)
		if val < 4 then 
			set(drefEfisRightMapMode,val+1)
		end
	end,
	function () 
		local val = get(drefEfisRightMapMode)
		if val > 0 then 
			set(drefEfisRightMapMode,val-1)
		end
	end,
	function () 
		return
	end
)

-- CTR
sysEFIS.ctrPilot 			= InopSwitch:new("ctrpilot")
sysEFIS.ctrCopilot 			= InopSwitch:new("ctrcopilot")

-- TFC
sysEFIS.tfcPilot 			= TwoStateDrefSwitch:new("tfcpilot",drefEfisLeftTfcMode,0)
sysEFIS.tfcCopilot 			= TwoStateDrefSwitch:new("tfccopilot",drefEfisRightTfcMode,0)

-- WX 
sysEFIS.wxrPilot 			= TwoStateDrefSwitch:new("wxrpilot",drefEfisLeftWX,0)
sysEFIS.wxrCopilot 			= TwoStateDrefSwitch:new("wxrcopilot",drefEfisRightWX,0)

-- STA / VOR
sysEFIS.staPilot 			= TwoStateDrefSwitch:new("stapilot",drefEfisLeftVORD,0)
sysEFIS.staCopilot 			= TwoStateDrefSwitch:new("stacopilot",drefEfisRightVORD,0)

-- WPT
sysEFIS.wptPilot 			= TwoStateDrefSwitch:new("wptpilot",drefEfisLeftWPT,0)
sysEFIS.wptCopilot 			= TwoStateDrefSwitch:new("wptcopilot",drefEfisRightWPT,0)

-- ARPT
sysEFIS.arptPilot 			= TwoStateDrefSwitch:new("arptpilot",drefEfisLeftARPT,0)
sysEFIS.arptCopilot 		= TwoStateDrefSwitch:new("arptcopilot",drefEfisRightARPT,0)

-- DATA / CSTR
sysEFIS.dataPilot 			= TwoStateDrefSwitch:new("datapilot",drefEfisLeftCSTR,0)
sysEFIS.dataCopilot 		= TwoStateDrefSwitch:new("datacopilot",drefEfisRightCSTR,0)

-- NAV/POS/NDB
sysEFIS.posPilot 			= TwoStateDrefSwitch:new("pospilot",drefEfisLeftNDB,0)
sysEFIS.posCopilot 			= TwoStateDrefSwitch:new("poscopilot",drefEfisRightNDB,0)

-- TERR
sysEFIS.terrPilot 			= TwoStateDrefSwitch:new("terrpilot",drefEfisLeftTERR,0)
sysEFIS.terrCopilot 		= TwoStateDrefSwitch:new("terrcopilot",drefEfisRightTERR,0)

-- FPV
sysEFIS.fpvPilot 			= InopSwitch:new("fpvpilot")
sysEFIS.fpvCopilot 			= InopSwitch:new("fpvcopilot")

-- MTRS
sysEFIS.mtrsPilot 			= TwoStateDrefSwitch:new("mtrspilot",drefEfisMeters,0)
sysEFIS.mtrsCopilot 		= InopSwitch:new("mtrscopilot")

-- MINS type
sysEFIS.minsTypePilot 		= InopSwitch:new("minstypepilot")
sysEFIS.minsTypeCopilot 	= InopSwitch:new("minstypecopilot")

-- MINS RESET
sysEFIS.minsResetPilot 		= InopSwitch:new("minsresetpilot")
sysEFIS.minsResetCopilot 	= InopSwitch:new("minsresetcopilot")

-- MINS SET
sysEFIS.minsPilot 			= InopSwitch:new("minspilot")
sysEFIS.minsCopilot 		= InopSwitch:new("minscopilot")

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= TwoStateDrefSwitch:new("voradf1pilot",  drefEfisLeftNavMode,0)
sysEFIS.voradf1Copilot 		= TwoStateDrefSwitch:new("voradf1copilot",drefEfisRightNavMode,0)

-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= TwoStateDrefSwitch:new("vorad2pilot",drefEfisLeftNav2Mode,0)
sysEFIS.voradf2Copilot 		= TwoStateDrefSwitch:new("vorad2copilot",drefEfisRightNav2Mode,0)

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
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 800, ypos-height)
		end
	end

	kc_imgui_label_mcp("ND:",10)
	kc_imgui_simple_actuator("<MODE",sysEFIS.mapModePilot,cmdDown,10,44,25)
	kc_imgui_simple_actuator("MODE>",sysEFIS.mapModePilot,cmdUp,10,44,25)
	kc_imgui_simple_actuator("<ZOOM",sysEFIS.mapZoomPilot,cmdDown,10,44,25)
	kc_imgui_simple_actuator("ZOOM>",sysEFIS.mapZoomPilot,cmdUp,10,44,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("WXR",sysEFIS.wxrPilot,10,30,25)
	kc_imgui_toggle_button_mcp("TER",sysEFIS.terrPilot,10,30,25)
	kc_imgui_toggle_button_mcp("TFC",sysEFIS.tfcPilot,10,30,25)
	kc_imgui_toggle_button_mcp("APT",sysEFIS.arptPilot,10,30,25)
	kc_imgui_toggle_button_mcp("NAV",sysEFIS.staPilot,10,30,25)
	kc_imgui_toggle_button_mcp("WPT",sysEFIS.wptPilot,10,30,25)
	-- kc_imgui_label_mcp("| MINS",10)
	-- kc_imgui_rotary_mcp("%04d",sysEFIS.minsPilot,10,31)
	kc_imgui_label_mcp("| BARO",10)
	kc_imgui_simple_actuator("DN",sysGeneral.baroGroup,cmdDown,10,23,25)
	kc_imgui_value("%04d ",sysGeneral.baroMbar,10)
	kc_imgui_value("%5.2f",sysGeneral.baroInhg,10)
	kc_imgui_simple_actuator("UP",sysGeneral.baroGroup,cmdUp,10,23,25)
	kc_imgui_toggle_button_mcp("STD",sysGeneral.barostdGroup,10,30,25)
end

return sysEFIS
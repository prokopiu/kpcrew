-- ToLiss Airbusses
-- EFIS functionality

-- @classmod sysEFIS
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysEFIS.minsPilot 		
-- sysEFIS.fpvPilot 	
-- sysEFIS.mtrsPilot 	
-- sysEFIS.wxrPilot 	
-- sysEFIS.mapZoomPilot 
-- sysEFIS.mapModePilot 
-- sysEFIS.voradf1Pilot 	
-- sysEFIS.voradf1Copilot 	
-- sysEFIS.staPilot 	
-- sysEFIS.wptPilot 	
-- sysEFIS.arptPilot 	
-- sysEFIS.dataPilot 	
-- sysEFIS.posPilot 	
-- sysEFIS.barostdPilot 	
-- sysEFIS.barostdCopilot 	
-- sysEFIS.barostdStandby 	
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

--------- Switch datarefs common
local drefEFISMtrs			= "AirbusFBW/MetricAlt"
local drefEFISFPV			= "AirbusFBW/HDGTRKmode"
local drefWXRModeL			= "sim/cockpit2/EFIS/EFIS_weather_on"
local drefEFISMapRangeL		= "AirbusFBW/NDrangeCapt"
local drefEFISMapModeL		= "AirbusFBW/NDmodeCapt"
local drefEFISVORADF1		= "sim/cockpit2/EFIS/EFIS_1_selection_pilot"
local drefEFISVORADF2		= "sim/cockpit2/EFIS/EFIS_2_selection_pilot"
local drefEFISModeSTAVOR	= "AirbusFBW/NDShowCSTRCapt"
local drefEFISModeWPT		= "AirbusFBW/NDShowWPTCapt"
local drefEFISModeARPT		= "AirbusFBW/NDShowARPTCapt"
local drefEFISModePos		= "AirbusFBW/NDShowVORDCapt"
local drefEFISModeData		= "AirbusFBW/NDShowNDBCapt"
local drefBaroStandardL		= "AirbusFBW/BaroStdCapt"
local drefBaroStandardC		= "AirbusFBW/ISIBaroStd"
local drefBaroStandardR		= "AirbusFBW/BaroStdFO"

--------- Switch commands common
local cmdWXRTglL			= "AirbusFBW/WXPowerSwitch"
local cmdEFISModeSTAVOR		= "toliss_airbus/dispcommands/CaptCstrPushButton"
local cmdEFISModeWPT		= "toliss_airbus/dispcommands/CaptWptPushButton"
local cmdEFISModeARPT		= "toliss_airbus/dispcommands/CaptArptPushButton"
local cmdEFISModePosNav		= "toliss_airbus/dispcommands/CaptVorDPushButton"
local cmdEFISModeData		= "toliss_airbus/dispcommands/CaptNdbPushButton"

logMsg("A3TL sysEFIS")

-- MINS SET (not needed in Airbus)
sysEFIS.minsPilot 			= InopSwitch:new("minspilot")

-- MTRS
sysEFIS.mtrsPilot 			= TwoStateDrefSwitch:new("mtrspilot",drefEFISMtrs,0)

-- FPV
sysEFIS.fpvPilot 			= TwoStateDrefSwitch:new("fpvpilot",drefEFISFPV,0)

-- WX (PWS mode for Airbus)
sysEFIS.wxrPilot 			= TwoStateCustomSwitch:new("wxrpilot",cmdWXRTglL,0,
	function ()
		set(cmdWXRTglL,0)
		set("AirbusFBW/WXSwitchPWS",2)
	end,
	function ()
		set(cmdWXRTglL,1)
		set("AirbusFBW/WXSwitchPWS",0)
	end,
	function ()
	end,
	function ()
		if get(cmdWXRTglL) == 1 then
			return 0
		else
			return 1
		end
	end)
sysEFIS.wxrCopilot 			= InopSwitch:new("wxrcopilot")

-- MAP ZOOM
sysEFIS.mapZoomPilot 		= TwoStateCustomSwitch:new("mapzoompilot",drefEFISMapRangeL,0,
	function ()
		local ndmod = get(drefEFISMapRangeL)
		if ndmod < 5 then
			set(drefEFISMapRangeL,ndmod+1)
		end
	end,
	function ()
		local ndmod = get(drefEFISMapRangeL)
		if ndmod > 0 then
			set(drefEFISMapRangeL,ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get(drefEFISMapRangeL) == 0 then
			displaystr = "10"
		elseif get(drefEFISMapRangeL) == 1 then
			displaystr = "20"
		elseif get(drefEFISMapRangeL) == 2 then
			displaystr = "40"
		elseif get(drefEFISMapRangeL) == 3 then
			displaystr = "80"
		elseif get(drefEFISMapRangeL) == 4 then
			displaystr = "160"
		elseif get(drefEFISMapRangeL) == 5 then
			displaystr = "320"
		end
		return displaystr
	end)

-- MAP MODE
sysEFIS.mapModePilot 		= TwoStateCustomSwitch:new("mapmodepilot",drefEFISMapModeL,0,
	function ()
		local ndmod = get(drefEFISMapModeL)
		if ndmod < 5 then
			set(drefEFISMapModeL,ndmod+1)
		end
	end,
	function ()
		local ndmod = get(drefEFISMapModeL)
		if ndmod > 0 then
			set(drefEFISMapModeL,ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get(drefEFISMapModeL) == 0 then
			displaystr = "LS"
		elseif get(drefEFISMapModeL) == 1 then
			displaystr = "VOR"
		elseif get(drefEFISMapModeL) == 2 then
			displaystr = "NAV"
		elseif get(drefEFISMapModeL) == 3 then
			displaystr = "ARC"
		elseif get(drefEFISMapModeL) == 4 then
			displaystr = "PLAN"
		elseif get(drefEFISMapModeL) == 5 then
			displaystr = "ENG"
		end
		return displaystr
	end)

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= TwoStateCustomSwitch:new("voradf1pilot",drefEFISVORADF1,0,
	function ()
		local efis1 = get(drefEFISVORADF1)
		if efis1 < 2 then
			set(drefEFISVORADF1,efis1+1)
		end
	end,
	function ()
		local efis1 = get(drefEFISVORADF1)
		if efis1 > 0 then
			set(drefEFISVORADF1,efis1-1)
		end
	end,
	function () end,
	function ()
		local displaystr = ""
		if get(drefEFISVORADF1) == 0 then
			displaystr = "ADF"
		elseif get(drefEFISVORADF1) == 1 then
			displaystr = "OFF"
		elseif get(drefEFISVORADF1) == 2 then
			displaystr = "VOR"
		end
		return displaystr
	end)
	
-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= TwoStateCustomSwitch:new("vorad2pilot",drefEFISVORADF2,0,
	function ()
		local efis1 = get(drefEFISVORADF2)
		if efis1 < 2 then
			set(drefEFISVORADF2,efis1+1)
		end
	end,
	function ()
		local efis1 = get(drefEFISVORADF2)
		if efis1 > 0 then
			set(drefEFISVORADF2,efis1-1)
		end
	end,
	function () end,
	function ()
		local displaystr = ""
		if get(drefEFISVORADF2) == 0 then
			displaystr = "ADF"
		elseif get(drefEFISVORADF2) == 1 then
			displaystr = "OFF"
		elseif get(drefEFISVORADF2) == 2 then
			displaystr = "VOR"
		end
		return displaystr
	end)

-- MAP options STA=CSTR
sysEFIS.staPilot			= TwoStateToggleSwitch:new("CSTR",drefEFISModeSTAVOR,0,cmdEFISModeSTAVOR)

sysEFIS.wptPilot			= TwoStateToggleSwitch:new("WPT",drefEFISModeWPT,0,cmdEFISModeWPT)

sysEFIS.posPilot			= TwoStateToggleSwitch:new("VORD",drefEFISModePos,0,cmdEFISModePosNav)

-- MAP data = NDB
sysEFIS.dataPilot			= TwoStateToggleSwitch:new("NDB",drefEFISModeData,0,cmdEFISModeData)

sysEFIS.arptPilot			= TwoStateToggleSwitch:new("ARPT",drefEFISModeARPT,0,cmdEFISModeARPT)

-- Baro standard toggle
sysEFIS.barostdPilot 	= TwoStateDrefSwitch:new("barostdpilot",drefBaroStandardL,0)
sysEFIS.barostdCopilot 	= TwoStateDrefSwitch:new("barostdcopilot",drefBaroStandardR,0)
sysEFIS.barostdStandby 	= TwoStateDrefSwitch:new("barostdstandby",drefBaroStandardC,0)
sysEFIS.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdPilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdCopilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdStandby)

---------- UI related
-- render kppanels EFIS section
function sysEFIS.panel_render()
	imgui.BeginGroup()

		kc_imgui_toggle_button_mcp("CSTR",sysEFIS.staPilot,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("WPT",sysEFIS.wptPilot,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("VORD",sysEFIS.posPilot,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("NDB",sysEFIS.dataPilot,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("ARPT",sysEFIS.arptPilot,0,37,19)
	
		kc_imgui_rotary_mcp("MODE: %s",sysEFIS.mapModePilot,ypos,120)
		imgui.SameLine()
		kc_imgui_rotary_mcp("ZOOM: %s",sysEFIS.mapZoomPilot,ypos,121)
		
		kc_imgui_rotary_mcp("AOV1: %s",sysEFIS.voradf1Pilot,ypos,122)
		imgui.SameLine()
		kc_imgui_rotary_mcp("AOV2: %s",sysEFIS.voradf2Pilot,ypos,123)
	
		imgui.Separator()

		kc_imgui_cmd_button("STD","toliss_airbus/capt_baro_pull",10,40,19)
		imgui.SameLine()
		kc_imgui_number_mcp("MB",sysEFIS.baroMbar,124,40,5)
		imgui.SameLine()
		kc_imgui_number_mcp("IN",sysEFIS.baroInhg,125,45,6)
		imgui.SameLine()
		kc_imgui_cmd_button("BARO","toliss_airbus/capt_baro_push",10,40,19)

		imgui.Separator()
		
	imgui.EndGroup()	
end
	
return sysEFIS
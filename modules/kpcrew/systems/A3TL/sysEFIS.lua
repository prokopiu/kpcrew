-- ToLiss Airbusses
-- EFIS functionality

-- @classmod sysEFIS
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

sysEFIS = require("kpcrew.systems.DFLT.sysEFIS")

logMsg("A3TL sysEFIS")

-- MINS SET
sysEFIS.minsPilot 			= InopSwitch:new("minspilot")

-- MTRS
sysEFIS.mtrsPilot 			= TwoStateDrefSwitch:new("mtrspilot","AirbusFBW/MetricAlt",0)

-- FPV
sysEFIS.fpvPilot 			= TwoStateDrefSwitch:new("fpvpilot","AirbusFBW/HDGTRKmode",0)

-- WX 
sysEFIS.wxrPilot 			= TwoStateCustomSwitch:new("wxrpilot","AirbusFBW/WXPowerSwitch",0,
	function ()
		set("AirbusFBW/WXPowerSwitch",0)
		set("AirbusFBW/WXSwitchPWS",2)
	end,
	function ()
		set("AirbusFBW/WXPowerSwitch",1)
		set("AirbusFBW/WXSwitchPWS",0)
	end,
	function ()
	end,
	function ()
		if get("AirbusFBW/WXPowerSwitch") == 1 then
			return 0
		else
			return 1
		end
	end)
sysEFIS.wxrCopilot 			= InopSwitch:new("wxrcopilot")

-- MAP ZOOM
sysEFIS.mapZoomPilot 		= TwoStateCustomSwitch:new("mapzoompilot","AirbusFBW/NDrangeCapt",0,
	function ()
		local ndmod = get("AirbusFBW/NDrangeCapt")
		if ndmod < 5 then
			set("AirbusFBW/NDrangeCapt",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("AirbusFBW/NDrangeCapt")
		if ndmod > 0 then
			set("AirbusFBW/NDrangeCapt",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/NDrangeCapt") == 0 then
			displaystr = "10"
		elseif get("AirbusFBW/NDrangeCapt") == 1 then
			displaystr = "20"
		elseif get("AirbusFBW/NDrangeCapt") == 2 then
			displaystr = "40"
		elseif get("AirbusFBW/NDrangeCapt") == 3 then
			displaystr = "80"
		elseif get("AirbusFBW/NDrangeCapt") == 4 then
			displaystr = "160"
		elseif get("AirbusFBW/NDrangeCapt") == 5 then
			displaystr = "320"
		end
		return displaystr
	end)

-- MAP MODE
sysEFIS.mapModePilot 		= TwoStateCustomSwitch:new("mapmodepilot","AirbusFBW/NDmodeCapt",0,
	function ()
		local ndmod = get("AirbusFBW/NDmodeCapt")
		if ndmod < 5 then
			set("AirbusFBW/NDmodeCapt",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("AirbusFBW/NDmodeCapt")
		if ndmod > 0 then
			set("AirbusFBW/NDmodeCapt",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/NDmodeCapt") == 0 then
			displaystr = "LS"
		elseif get("AirbusFBW/NDmodeCapt") == 1 then
			displaystr = "VOR"
		elseif get("AirbusFBW/NDmodeCapt") == 2 then
			displaystr = "NAV"
		elseif get("AirbusFBW/NDmodeCapt") == 3 then
			displaystr = "ARC"
		elseif get("AirbusFBW/NDmodeCapt") == 4 then
			displaystr = "PLAN"
		elseif get("AirbusFBW/NDmodeCapt") == 5 then
			displaystr = "ENG"
		end
		return displaystr
	end)

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= TwoStateCustomSwitch:new("voradf1pilot","sim/cockpit2/EFIS/EFIS_1_selection_pilot",0,
	function ()
		local efis1 = get("sim/cockpit2/EFIS/EFIS_1_selection_pilot")
		if efis1 < 2 then
			set("sim/cockpit2/EFIS/EFIS_1_selection_pilot",efis1+1)
		end
	end,
	function ()
		local efis1 = get("sim/cockpit2/EFIS/EFIS_1_selection_pilot")
		if efis1 > 0 then
			set("sim/cockpit2/EFIS/EFIS_1_selection_pilot",efis1-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("sim/cockpit2/EFIS/EFIS_1_selection_pilot") == 0 then
			displaystr = "ADF"
		elseif get("sim/cockpit2/EFIS/EFIS_1_selection_pilot") == 1 then
			displaystr = "OFF"
		elseif get("sim/cockpit2/EFIS/EFIS_1_selection_pilot") == 2 then
			displaystr = "VOR"
		end
		return displaystr
	end)
	
-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= TwoStateCustomSwitch:new("vorad2pilot","sim/cockpit2/EFIS/EFIS_2_selection_pilot",0,
	function ()
		local efis1 = get("sim/cockpit2/EFIS/EFIS_2_selection_pilot")
		if efis1 < 2 then
			set("sim/cockpit2/EFIS/EFIS_2_selection_pilot",efis1+1)
		end
	end,
	function ()
		local efis1 = get("sim/cockpit2/EFIS/EFIS_2_selection_pilot")
		if efis1 > 0 then
			set("sim/cockpit2/EFIS/EFIS_2_selection_pilot",efis1-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("sim/cockpit2/EFIS/EFIS_2_selection_pilot") == 0 then
			displaystr = "ADF"
		elseif get("sim/cockpit2/EFIS/EFIS_2_selection_pilot") == 1 then
			displaystr = "OFF"
		elseif get("sim/cockpit2/EFIS/EFIS_2_selection_pilot") == 2 then
			displaystr = "VOR"
		end
		return displaystr
	end)

sysEFIS.pilotCSTR			= TwoStateToggleSwitch:new("CSTR","AirbusFBW/NDShowCSTRCapt",0,
	"toliss_airbus/dispcommands/CaptCstrPushButton")

sysEFIS.pilotWPT			= TwoStateToggleSwitch:new("WPT","AirbusFBW/NDShowWPTCapt",0,
	"toliss_airbus/dispcommands/CaptWptPushButton")

sysEFIS.pilotVORD			= TwoStateToggleSwitch:new("VORD","AirbusFBW/NDShowVORDCapt",0,
	"toliss_airbus/dispcommands/CaptVorDPushButton")

sysEFIS.pilotNDB			= TwoStateToggleSwitch:new("NDB","AirbusFBW/NDShowNDBCapt",0,
	"toliss_airbus/dispcommands/CaptNdbPushButton")

sysEFIS.pilotARPT			= TwoStateToggleSwitch:new("ARPT","AirbusFBW/NDShowARPTCapt",0,
	"toliss_airbus/dispcommands/CaptArptPushButton")

-- Baro standard toggle
sysEFIS.barostdPilot 	= TwoStateDrefSwitch:new("barostdpilot","AirbusFBW/BaroStdCapt",0)
sysEFIS.barostdCopilot 	= TwoStateDrefSwitch:new("barostdcopilot","AirbusFBW/BaroStdFO",0)
sysEFIS.barostdStandby 	= TwoStateDrefSwitch:new("barostdstandby","AirbusFBW/ISIBaroStd",0)
sysEFIS.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdPilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdCopilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdStandby)

-- baro mbar/inhg
sysEFIS.baroMbar 		= TwoStateCustomSwitch:new("mbar","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",0,
function () end,
function () end,
function () end,
function () 
	return string.format("%04.0f",get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") * 33.8639)
end,
function () end,
function (value) 
	return value / 33.87
end)

sysEFIS.baroInhg 		= TwoStateCustomSwitch:new("inhg","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",0,
function () end,
function () end,
function () end,
function () 
	return string.format("%05.2f",get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"))
end)


-- Baro standard toggle
sysGeneral.barostdPilot 	= sysEFIS.barostdPilot 
sysGeneral.barostdCopilot 	= sysEFIS.barostdCopilo
sysGeneral.barostdStandby 	= sysEFIS.barostdStandb
sysGeneral.barostdGroup 	= sysEFIS.barostdGroup 

-- baro mbar/inhg
sysGeneral.baroMbar 		= sysEFIS.baroMbar
sysGeneral.baroInhg 		= sysEFIS.baroInhg


-- render kppanels EFIS section
function sysEFIS.panel_render()
	imgui.BeginGroup()

		kc_imgui_toggle_button_mcp("CSTR",sysEFIS.pilotCSTR,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("WPT",sysEFIS.pilotWPT,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("VORD",sysEFIS.pilotVORD,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("NDB",sysEFIS.pilotNDB,0,37,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("ARPT",sysEFIS.pilotARPT,0,37,19)
	
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
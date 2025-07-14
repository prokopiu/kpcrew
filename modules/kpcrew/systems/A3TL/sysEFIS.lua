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
		if get("AirbusFBW/WXPowerSwitch") ~= 1 then
			return 1
		else
			return 0
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
		kc_imgui_number_mcp("MB",sysGeneral.baroMbar,124,40,5)
		imgui.SameLine()
		kc_imgui_number_mcp("IN",sysGeneral.baroInhg,112,45,6)
		imgui.SameLine()
		kc_imgui_cmd_button("BARO","toliss_airbus/capt_baro_push",10,40,19)

		imgui.Separator()
		
		-- kc_imgui_simple_actuator("DN",sysGeneral.baroGroup,cmdDown,10,23,25)
		-- imgui.SameLine()
		-- kc_imgui_value("%04d |",sysGeneral.baroMbar,10)
		-- imgui.SameLine()
		-- kc_imgui_value("%5.2f",sysGeneral.baroInhg,10)
		-- imgui.SameLine()
		-- kc_imgui_simple_actuator("UP",sysGeneral.baroGroup,slowUp,10,23,25)
		-- imgui.SameLine()

		-- kc_imgui_toggle_button_mcp("ARPT",sysEFIS.pilotARPT,0,37,19)
		
		
		
-- toliss_airbus/capt_baro_pull
-- toliss_airbus/capt_baro_push

-- AirbusFBW/BaroUnitCapt

	
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("TERR",sysMCP.vorlocSwitch,0,34,19)



		-- imgui.TextUnformatted("  EFIS ")
		-- imgui.TextUnformatted("  ND:")
		-- imgui.TextUnformatted(" ")	
		-- imgui.SameLine()	
		-- kc_imgui_simple_actuator("MODE <",sysEFIS.mapModePilot,cmdDown,10,47,25)
		-- imgui.SameLine()
		-- kc_imgui_simple_actuator("MODE >",sysEFIS.mapModePilot,cmdUp,10,47,25)
		-- imgui.SameLine()
		-- kc_imgui_simple_actuator("ZOOM <",sysEFIS.mapZoomPilot,cmdDown,10,47,25)
		-- imgui.SameLine()
		-- kc_imgui_simple_actuator("ZOOM >",sysEFIS.mapZoomPilot,cmdUp,10,47,25)
		-- imgui.TextUnformatted(" ")	
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("WXR",sysEFIS.wxrPilot,10,47,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("APT",sysEFIS.arptPilot,10,47,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("NAV",sysEFIS.staPilot,10,47,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("WPT",sysEFIS.wptPilot,10,47,25)
		-- imgui.TextUnformatted("  MINIMUMS:")	
		-- imgui.TextUnformatted(" ")	
		-- imgui.SameLine()
		-- kc_imgui_rotary_mcp("%04d",sysEFIS.minsPilot,10,31)
		-- imgui.TextUnformatted("  BARO:")	
		-- imgui.TextUnformatted(" ")	
		-- imgui.SameLine()
		


		-- imgui.Separator()
		
	imgui.EndGroup()	
end
	
return sysEFIS
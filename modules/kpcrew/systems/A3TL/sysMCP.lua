-- ToLiss Airbusses airplane 
-- MCP functionality

-- @classmod sysMCP
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

sysMCP = require("kpcrew.systems.DFLT.sysMCP")

logMsg("A3TL sysMCP")

-- Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","AirbusFBW/FD1Engage",0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","AirbusFBW/FD2Engage",0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","AirbusFBW/FD1Engage",0)

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1","AirbusFBW/AP1Engage",0,
	"toliss_airbus/ap1_push")
sysMCP.ap2Switch 			= TwoStateToggleSwitch:new("autopilot2","AirbusFBW/AP2Engage",0,
	"toliss_airbus/ap2_push")

-- YAW DAMPER
sysMCP.yawDamper			= InopSwitch:new("yawdamper")

-- Airbus LS Switch
sysMCP.lsSwitch				= TwoStateToggleSwitch:new("LS","AirbusFBW/ILSonCapt",0,
	"toliss_airbus/dispcommands/CaptLSButtonPush")
	
-- **VORLOC/NAV
sysMCP.vorlocSwitch			= TwoStateToggleSwitch:new("vorloc","AirbusFBW/LOConCapt",0,
	"AirbusFBW/LOCbutton")

-- **ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold","sim/cockpit2/autopilot/altitude_hold_status",0,
	"AirbusFBW/PushButtonAltitude")

-- **APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach","AirbusFBW/APPRilluminated",0,
	"AirbusFBW/APPRbutton")

-- **ATHR
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr","AirbusFBW/ATHRmode",0,
	"AirbusFBW/ATHRbutton")
	
-- IAS
sysMCP.iasSelector 			= TwoStateCustomSwitch:new("ias","sim/cockpit2/autopilot/airspeed_dial_kts",0,
	function ()
		command_once("sim/autopilot/airspeed_up")
	end,
	function ()
		command_once("sim/autopilot/airspeed_down")
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/SPDdashed") == 1 then 
			displaystr = displaystr.."---" 
		else
			displaystr = displaystr..get("sim/cockpit2/autopilot/airspeed_dial_kts")
		end
		if get("AirbusFBW/SPDmanaged") == 1 then displaystr = displaystr.."o" end
		return displaystr
	end)

-- HDG
sysMCP.hdgSelector 			= TwoStateCustomSwitch:new("hdg","sim/cockpit2/autopilot/heading_dial_deg_mag_pilot",0,
	function ()
		command_once("sim/autopilot/heading_up")
	end,
	function ()
		command_once("sim/autopilot/heading_down")
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/HDGdashed") == 1 then 
			displaystr = displaystr.."---" 
		else
			displaystr = displaystr..get("sim/cockpit2/autopilot/heading_dial_deg_mag_pilot")
		end
		if get("AirbusFBW/HDGmanaged") == 1 then displaystr = displaystr.."o" end
		return displaystr
	end)

-- ALT
sysMCP.altSelector 			= TwoStateCustomSwitch:new("alt","sim/cockpit2/autopilot/altitude_dial_ft",0,
	function ()
		command_once("sim/autopilot/altitude_up")
	end,
	function ()
		command_once("sim/autopilot/altitude_down")
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		displaystr = displaystr..get("sim/cockpit2/autopilot/altitude_dial_ft")
		if get("AirbusFBW/ALTmanaged") == 1 then displaystr = displaystr.."o" end
		return displaystr
	end)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt","sim/cockpit2/autopilot/altitude_dial_ft",0)
	
-- VSP
sysMCP.vspSelector 			= TwoStateCustomSwitch:new("vsp","sim/cockpit2/autopilot/vvi_dial_fpm",0,
	function ()
		command_once("sim/autopilot/vertical_speed_up")
	end,
	function ()
		command_once("sim/autopilot/vertical_speed_down")
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/VSdashed") == 1 then 
			displaystr = "-----" 
		else
			if get("sim/cockpit2/autopilot/vvi_dial_fpm") >= 0 then
				displaystr = displaystr.."+"
			end
			displaystr = displaystr..get("sim/cockpit2/autopilot/vvi_dial_fpm")
		end
		return displaystr
	end)
	
-- render kppanels MCP section
function sysMCP:panel_render()
	imgui.BeginGroup()
	
		kc_imgui_toggle_button_mcp("FD",sysMCP.fdirPilotSwitch,0,22,19)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("LS",sysMCP.lsSwitch,0,22,19)

		imgui.SameLine()
		kc_imgui_number_mcp("SPD",sysMCP.iasSelector,110,38,5)
		imgui.SameLine()
		kc_imgui_cmd_button("v","AirbusFBW/PullSPDSel",0,13,19)
		imgui.SameLine()
		kc_imgui_cmd_button("^","AirbusFBW/PushSPDSel",0,13,19)

		imgui.SameLine()
		kc_imgui_toggle_button_mcp("S/M",sysMCP.machSwitch,0,30,19)
		
		imgui.SameLine()
		kc_imgui_number_mcp("HDG",sysMCP.hdgSelector,111,38,4)
		imgui.SameLine()
		kc_imgui_cmd_button("v","AirbusFBW/PullHDGSel",0,13,19)
		imgui.SameLine()
		kc_imgui_cmd_button("^","AirbusFBW/PushHDGSel",0,13,19)

		imgui.SameLine()
		kc_imgui_toggle_button_mcp("FPV",sysEFIS.fpvPilot,0,30,19)
		
		imgui.SameLine()
		kc_imgui_number_mcp("ALT",sysMCP.altSelector,112,45,6)
		imgui.SameLine()
		kc_imgui_cmd_button("v","AirbusFBW/PullAltitude",0,13,19)
		imgui.SameLine()
		kc_imgui_cmd_button("^","AirbusFBW/PushAltitude",0,13,19)

		imgui.SameLine()
		kc_imgui_toggle_button_mcp("MTR",sysEFIS.mtrsPilot,0,30,19)

		imgui.SameLine()
		kc_imgui_number_mcp("V/S",sysMCP.vspSelector,113,45,6)
		imgui.SameLine()
		kc_imgui_cmd_button("v","AirbusFBW/PullVSSel",0,13,19)
		imgui.SameLine()
		kc_imgui_cmd_button("^","AirbusFBW/PushVSSel",0,13,19)

		imgui.SameLine()
		kc_imgui_toggle_button_mcp("LOC",sysMCP.vorlocSwitch,0,30,19)

		imgui.SameLine()
		kc_imgui_toggle_button_mcp("ALT",sysMCP.altholdSwitch,0,30,19)
		
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("APR",sysMCP.approachSwitch,0,30,19)
		
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("AP1",sysMCP.ap1Switch,0,30,19)
		
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("AP2",sysMCP.ap2Switch,0,30,19)
		
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("A/T",sysMCP.athrSwitch,0,30,19)
			
	imgui.EndGroup()
end

return sysMCP
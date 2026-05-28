-- ToLiss Airbusses airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysMCP.fdirPilotSwitch 	
-- sysMCP.fdirCoPilotSwitch 
-- sysMCP.ap1Switch	
-- sysMCP.ap2Switch	+
-- sysMCP.apAnc 	
-- sysMCP.yawDamper
-- sysMCP.lsSwitch +
-- sysMCP.vorlocSwitch
-- sysMCP.altholdSwitch
-- sysMCP.approachSwitch 
-- sysMCP.aprAnc
-- sysMCP.athrSwitch 
-- sysMCP.athrAnc
-- sysMCP.apDiscYoke
-- sysMCP.iasSelector 
-- sysMCP.hdgSelector
-- sysMCP.altSelector
-- sysMCP.vspSelector 
-- Macro: kc_macro_mcp
-- Macro: kc_macro_set_irs
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

sysMCP = require("kpcrew.systems.DFLT.sysMCP")

logMsg("A3TL sysMCP")

--------- Switch datarefs common
local drefFlightDirectorL	= "AirbusFBW/FD1Engage"
local drefFlightDirectorR	= "AirbusFBW/FD2Engage"
local drefAutopilot1		= "AirbusFBW/AP1Engage"
local drefAutopilot1		= "AirbusFBW/AP2Engage"
local drefAirbusLS1			= "AirbusFBW/ILSonCapt"
local drefNavMode			= "AirbusFBW/LOConCapt"
local drefAltHoldStatus		= "sim/cockpit2/autopilot/altitude_hold_status"
local drefApprMode			= "AirbusFBW/APPRilluminated"
local drefATMode			= "AirbusFBW/ATHRmode"
local drefAPDisconnect		= "sim/cockpit2/annunciators/autopilot_disconnect"
local drefIAS				= "sim/cockpit2/autopilot/airspeed_dial_kts"
local drefHDG				= "sim/cockpit2/autopilot/heading_dial_deg_mag_pilot"
local drefALT				= "sim/cockpit2/autopilot/altitude_dial_ft"
local drefVSP				= "sim/cockpit2/autopilot/vvi_dial_fpm"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdAutopilot1Tgl		= "toliss_airbus/ap1_push"
local cmdAutopilot2Tgl		= "toliss_airbus/ap2_push"
local cmdAirbusLS1			= "toliss_airbus/dispcommands/CaptLSButtonPush"
local cmdNavModeTgl			= "AirbusFBW/LOCbutton"
local cmdAltHoldTgl			= "AirbusFBW/PushButtonAltitude"
local cmdApprModeTgl		= "AirbusFBW/APPRbutton"
local cmdATTgl				= "AirbusFBW/ATHRbutton"
local cmdAPDisconnect		= "toliss_airbus/ap_disc_left_stick"
local cmdIASUp				= "sim/autopilot/airspeed_up"
local cmdIASDown			= "sim/autopilot/airspeed_down"
local cmdHDGUp				= "sim/autopilot/heading_up"
local cmdHDGDown			= "sim/autopilot/heading_down"
local cmdALTUp				= "sim/autopilot/altitude_up"
local cmdALTDown			= "sim/autopilot/altitude_down"
local cmdVSPUp				= "sim/autopilot/vertical_speed_up"
local cmdVSPDown			= "sim/autopilot/vertical_speed_down"

----------- Switches

-- Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left",drefFlightDirectorL,0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right",drefFlightDirectorR,0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc",drefFlightDirectorL,0)

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1",drefAutopilot1,0,cmdAutopilot1Tgl)
sysMCP.ap2Switch 			= TwoStateToggleSwitch:new("autopilot2",drefAutopilot2,0,cmdAutopilot2Tgl)
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc",drefAutopilot1,0)

-- YAW DAMPER
sysMCP.yawDamper			= InopSwitch:new("yawdamper")

-- Airbus LS Switch
sysMCP.lsSwitch				= TwoStateToggleSwitch:new("LS",drefAirbusLS1,0,cmdAirbusLS1)
	
-- **VORLOC/NAV
sysMCP.vorlocSwitch			= TwoStateToggleSwitch:new("vorloc",drefNavMode,0,cmdNavModeTgl)

-- **ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold",drefAltHoldStatus,0,cmdAltHoldTgl)

-- **APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach",drefApprMode,0,cmdApprModeTgl)
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc",drefApprMode,0)

-- **ATHR
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr",drefATMode,0,cmdATTgl)
sysMCP.athrAnc				= SimpleAnnunciator:new("athr",drefATMode,0)

-- A/P DISENGAGE
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke",drefAPDisconnect,0,cmdAPDisconnect)
	
-- IAS
sysMCP.iasSelector 			= TwoStateCustomSwitch:new("ias",drefIAS,0,
	function () command_once(cmdIASUp) end,
	function ()	command_once(cmdIASDown) end,
	function ()	end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/SPDdashed") == 1 then 
			displaystr = displaystr.."---" 
		else
			displaystr = displaystr..get(drefIAS)
		end
		if get("AirbusFBW/SPDmanaged") == 1 then displaystr = displaystr.."o" end
		return displaystr
	end)

-- HDG
sysMCP.hdgSelector 			= TwoStateCustomSwitch:new("hdg",drefHDG,0,
	function () command_once(cmdHDGUp) end,
	function () command_once(cmdHDGDown) end,
	function () end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/HDGdashed") == 1 then 
			displaystr = displaystr.."---" 
		else
			displaystr = displaystr..get(drefHDG)
		end
		if get("AirbusFBW/HDGmanaged") == 1 then displaystr = displaystr.."o" end
		return displaystr
	end)

-- ALT
sysMCP.altSelector 			= TwoStateCustomSwitch:new("alt",drefALT,0,
	function () command_once(cmdALTUp) end,
	function () command_once(cmdALTDown) end,
	function () end,
	function ()
		local displaystr = ""
		displaystr = displaystr..get(drefALT)
		if get("AirbusFBW/ALTmanaged") == 1 then displaystr = displaystr.."o" end
		return displaystr
	end)
	
-- VSP
sysMCP.vspSelector 			= TwoStateCustomSwitch:new("vsp",drefVSP,0,
	function () command_once(cmdVSPUp) end,
	function () command_once(cmdVSPDown) end,
	function () end,
	function ()
		local displaystr = ""
		if get("AirbusFBW/VSdashed") == 1 then 
			displaystr = "-----" 
		else
			if get(drefVSP) >= 0 then
				displaystr = displaystr.."+"
			end
			displaystr = displaystr..get(drefVSP)
		end
		return displaystr
	end)

--------- Macros
-- ====================================== A/P & Glareshield related functions
function kc_macro_mcp(flightphase)
	logMsg("MCP flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(0)
	elseif flightphase == kc_phase_turnaround then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	elseif flightphase == kc_phase_after_start then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	elseif flightphase == kc_phase_before_takeoff then
		sysMCP.fdirGroup:actuate(1)
	elseif flightphase == kc_phase_afterland then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.hdgSelector:setValue(0)
		sysMCP.speedSwitch:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end 

-- IRS off 0=OFF, 1=NAV, 2=ATT
function kc_macro_set_irs(mode)
logMsg("irs "..mode)
	set_array("AirbusFBW/ADIRUSwitchArray",0,mode)
	set_array("AirbusFBW/ADIRUSwitchArray",1,mode)
	set_array("AirbusFBW/ADIRUSwitchArray",2,mode)
end

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
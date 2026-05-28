-- DFLT airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysMCP.fdirPilotSwitch 	
-- sysMCP.fdirCoPilotSwitch 
-- sysMCP.fdirGroup 		
-- sysMCP.fdirAnc 			
-- sysMCP.ap1Switch	
-- sysMCP.apAnc 		
-- sysMCP.altholdSwitch 
-- sysMCP.altAnc 
-- sysMCP.hdgselSwitch
-- sysMCP.hdgAnc 
-- sysMCP.vorlocSwitch
-- sysMCP.navAnc 
-- sysMCP.approachSwitch 
-- sysMCP.aprAnc
-- sysMCP.vsSwitch 
-- sysMCP.vspAnc
-- sysMCP.speedSwitch 
-- sysMCP.spdAnc
-- sysMCP.togaPilotSwitch
-- sysMCP.athrSwitch
-- sysMCP.athrAnc
-- sysMCP.lnavSwitch 
-- sysMCP.vnavSwitch
-- sysMCP.flchSwitch
-- sysMCP.backcourse 	
-- sysMCP.bcAnc 
-- sysMCP.crs1Selector 		
-- sysMCP.crs2Selector 		
-- sysMCP.crsSelectorGroup	
-- sysMCP.n1Switch 
-- sysMCP.iasSelector
-- sysMCP.machSwitch
-- sysMCP.spdIntvSwitch
-- sysMCP.hdgSelector
-- sysMCP.turnRateSelector
-- sysMCP.altSelector
-- sysMCP.altDisplay 
-- sysMCP.altintvSwitch
-- sysMCP.vspSelector
-- sysMCP.cwsaSwitch 
-- sysMCP.cwsbSwitch 
-- sysMCP.discAPSwitch
-- sysMCP.apDiscYoke
-- sysMCP.yawDamper
-- sysMCP.lsSwitch
-- Macro: kc_macro_mcp
-- UI: panel_render

local sysMCP = {
}

logMsg("DFLT sysMCP")

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
local drefFlightDirectorL	= "sim/cockpit2/autopilot/flight_director_mode"
local drefFlightDirectorR	= "sim/cockpit2/autopilot/flight_director2_mode"
local drefAutopilot1		= "sim/cockpit2/autopilot/servos_on"
local drefAltHoldStatus		= "sim/cockpit2/autopilot/altitude_hold_status"
local drefHdgSelMode		= "sim/cockpit2/autopilot/heading_mode"
local drefNavMode			= "sim/cockpit2/autopilot/nav_status"
local drefApprMode			= "sim/cockpit2/autopilot/approach_status"
local drefAltMode			= "sim/cockpit2/autopilot/altitude_mode"
local drefTOGAMode			= "sim/cockpit2/autopilot/TOGA_status"
local drefATMode			= "sim/cockpit2/autopilot/autothrottle_enabled"
local drefCRS1				= "sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot"
local drefCRS2				= "sim/cockpit2/radios/actuators/nav2_obs_deg_mag_copilot"
local drefIAS				= "sim/cockpit2/autopilot/airspeed_dial_kts"
local drefIASMachSwitch		= "sim/cockpit2/autopilot/airspeed_is_mach"
local drefHDG				= "sim/cockpit2/autopilot/heading_dial_deg_mag_pilot"
local drefALT				= "sim/cockpit2/autopilot/altitude_dial_ft"
local drefVSP				= "sim/cockpit2/autopilot/vvi_dial_fpm"
local drefAPDisconnect		= "sim/cockpit2/annunciators/autopilot_disconnect"
local drefYawDamper			= "sim/cockpit2/annunciators/yaw_damper"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdAutopilot1Tgl		= "sim/autopilot/servos_toggle"
local cmdAltHoldTgl			= "sim/autopilot/altitude_hold"
local cmdNavModeTgl			= "sim/autopilot/NAV"
local cmdApprModeTgl		= "sim/autopilot/approach"
local cmdSpdModeTgl			= "sim/autopilot/speed_hold"
local cmdTOGASet			= "sim/autopilot/take_off_go_around"
local cmdATTgl				= "sim/autopilot/autothrottle_toggle"
local cmdCRS1Up				= "sim/radios/obs_HSI_up"
local cmdCRS1Down			= "sim/radios/obs_HSI_down"
local cmdCRS2Up				= "sim/radios/copilot_obs_HSI_up"
local cmdCRS2Down			= "sim/radios/copilot_obs_HSI_down"
local cmdIASUp				= "sim/autopilot/airspeed_up"
local cmdIASDown			= "sim/autopilot/airspeed_down"
local cmdHDGUp				= "sim/autopilot/heading_up"
local cmdHDGDown			= "sim/autopilot/heading_down"
local cmdALTUp				= "sim/autopilot/altitude_up"
local cmdALTDown			= "sim/autopilot/altitude_down"
local cmdVSPUp				= "sim/autopilot/vertical_speed_up"
local cmdVSPDown			= "sim/autopilot/vertical_speed_down"
local cmdAPDisconnect		= "sim/autopilot/disconnect"
local cmdYawDamperTgl		= "sim/systems/yaw_damper_toggle"

----------- Switches

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left",drefFlightDirectorL,0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right",drefFlightDirectorR,0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc",drefFlightDirectorL,0)

-- **AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1",drefAutopilot1,0,cmdAutopilot1Tgl)
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc",drefAutopilot1,0)

-- **ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold",drefAltHoldStatus,0,cmdAltHoldTgl)
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc",drefAltHoldStatus,0)

-- **HDG SELECT mode
sysMCP.hdgselSwitch 		= TwoStateDrefSwitch:new("hdgsel",drefHdgSelMode,0)
sysMCP.hdgAnc 				= CustomAnnunciator:new("hdganc",
function () if get(drefHdgSelMode) == 1 then return 1 else return 0 end end)

-- **VORLOC/NAV
sysMCP.vorlocSwitch			= TwoStateToggleSwitch:new("vorloc",drefNavMode,0,cmdNavModeTgl)
-- NAV mode annunciator
-- Autopilot lateral mode. (0=roll, 1=heading sel, 2=nav, 10=TO/GA, 11=Re-entry, 12=Free, 
-- 13=GPSS, 14=heading hold, 15=turn-rate, 16=rollout, 18=track)
sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () if get(drefHdgSelMode) == 2 or get(drefHdgSelMode) == 13 then return 1 else return 0 end end)

-- **APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach",drefApprMode,0,cmdApprModeTgl)
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc",drefApprMode,0)

-- **VS
sysMCP.vsSwitch 			= TwoStateCustomSwitch:new("vsmode",drefAltMode,0,
function () set(drefAltMode,4) end,
function () set(drefAltMode,0) end,
function () if get(drefAltMode) ~= 4 then set(drefAltMode,4) else set(drefAltMode,0) end end,
function () if get(drefAltMode) == 4 then return 1 else return 0 end end)
-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () if get(drefAltMode) == 4 then return 1 else return 0 end end)

-- **SPEED Mode
sysMCP.speedSwitch 			= TwoStateCustomSwitch:new("speed",drefAltMode,0,
	function () if get(drefAltMode) ~= 5 then command_once(cmdSpdModeTgl) end end,
	function () if get(drefAltMode) == 5 then command_once(cmdSpdModeTgl) end end,
	function () command_once(cmdSpdModeTgl) end,
	function () if get(drefAltMode) == 5 then return 1 else return 0 end end)
sysMCP.spdAnc 				= SimpleAnnunciator:new("spdanc","sim/cockpit2/autopilot/autothrottle_enabled",0)

-- **TOGA Button
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot",drefTOGAMode,0,cmdTOGASet)

-- **ATHR
-- -1=hard off, not even armed. 0=servos declutched (arm, hold), 1=airspeed hold, 2=N1 target hold, 3=retard, 4=reserved for future use
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr",drefATMode,0,cmdATTgl)
sysMCP.athrAnc				= SimpleAnnunciator:new("athr",drefATMode,0)

-- LNAV / GPSS mode
sysMCP.lnavSwitch 			= TwoStateCustomSwitch:new("lnav",drefHdgSelMode,0,
function () set("sim/operation/override/override_autopilot",13) end,
function () set("sim/operation/override/override_autopilot",0) end,
function ()
	if get(drefHdgSelMode) ~= 13 then
		set("sim/operation/override/override_autopilot",13)
	else
		set("sim/operation/override/override_autopilot",0)
	end
end,
function () if get(drefHdgSelMode) == 2 or get(drefHdgSelMode) == 13 then return 1 else return 0 end end)

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav","sim/cockpit2/autopilot/fms_vnav",0,
	"sim/autopilot/FMS")

-- IAS mode or Level Change or FLCH
sysMCP.flchSwitch 			= TwoStateCustomSwitch:new("flch",drefHdgSelMode,0,
function () set("sim/operation/override/override_autopilot",5) end,
function () set("sim/operation/override/override_autopilot",0) end,
function ()
	if get(drefHdgSelMode) ~= 5 then
		set("sim/operation/override/override_autopilot",5)
	else
		set("sim/operation/override/override_autopilot",0)
	end
end,
function () if get(drefHdgSelMode) == 5 then return 1 else return 0 end end)

-- BACKCOURSE
sysMCP.backcourse 			= InopSwitch:new("backcourse")
sysMCP.bcAnc 				= InopSwitch:new("bc")

-- === Selectors

-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1",drefCRS1,0,cmdCRS1Down,cmdCRS1Up,0,359,false)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2",drefCRS2,0,cmdCRS2Down,cmdCRS2Up,0,359,false)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1/EPR Switch 
sysMCP.n1Switch 			= InopSwitch:new("n1")

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias",drefIAS,0,cmdIASDown,cmdIASUp,100,340,false)

-- KTS/MACH C/O
sysMCP.machSwitch 			= TwoStateDrefSwitch:new("ktsmach",drefIASMachSwitch,0)

-- SPD INTV
sysMCP.spdIntvSwitch 		= InopSwitch:new("spdintv")

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg",drefHDG,0,cmdHDGDown,cmdHDGUp,0,359,false)

-- TURNRATE
sysMCP.turnRateSelector 	= InopSwitch:new("turnrate")

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt",drefALT,0,cmdALTDown,cmdALTUp,0,50000,false)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt",drefALT,0)

-- ALT INTV
sysMCP.altintvSwitch 		= InopSwitch:new("altintv")

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp",drefVSP,0,cmdVSPDown,cmdVSPUp,-7900,7900,true)

-- CWS Boeing only
sysMCP.cwsaSwitch 			= InopSwitch:new("cwsa")
sysMCP.cwsbSwitch 			= InopSwitch:new("cwsb")

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc",drefAPDisconnect,0,cmdAPDisconnect)
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke",drefAPDisconnect,0,cmdAPDisconnect)

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateToggleSwitch:new("yawdamper",drefYawDamper,0,cmdYawDamperTgl)

-- Airbus LS Switch
sysMCP.lsSwitch				= InopSwitch:new("LS")

--------- Macros

-- ====================================== A/P & Glareshield related functions
function kc_macro_mcp(flightphase)
	logMsg("MCP flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_flightdir then
			sysMCP.fdirGroup:actuate(0)
		end
		if kc_has_autothrottle then
			sysMCP.athrSwitch:actuate(0)
		end
		if kc_has_ils then
			sysMCP.crs1Selector:setValue(1)
			sysMCP.crs2Selector:setValue(1)
		end
		if kc_has_ias_sel then
			sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		end
		if kc_has_hdg_sel then
			sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		end
		if kc_has_alt_sel then
			sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		end
		if kc_has_vsp_sel then
			sysMCP.vspSelector:setValue(0)
		end
		if kc_has_autopilot then
			sysMCP.discAPSwitch:actuate(0)
			sysMCP.ap1Switch:actuate(0)
		end
		if kc_has_yawdamper then
			sysMCP.yawDamper:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_flightdir then
			sysMCP.fdirGroup:actuate(1)
		end
		if kc_has_autothrottle then
			sysMCP.athrSwitch:actuate(0)
		end
		if kc_has_yawdamper then
			sysMCP.yawDamper:actuate(0)
		end
		if kc_has_ias_sel then
			sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		end
		if kc_has_hdg_sel then
			sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		end
		if kc_has_alt_sel then
			sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		end
		if kc_has_vsp_sel then
			sysMCP.vspSelector:actuate(0)
		end
		if kc_has_autopilot then
			sysMCP.discAPSwitch:actuate(0)
		end
	elseif flightphase == kc_phase_after_start then
		if kc_has_flightdir then
			sysMCP.fdirGroup:actuate(1)
		end
		if kc_has_autothrottle then
			sysMCP.athrSwitch:actuate(0)
		end
		if kc_has_yawdamper then
			sysMCP.yawDamper:actuate(0)
		end
		if kc_has_ias_sel then
			sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		end
		if kc_has_hdg_sel then
			sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		end
		if kc_has_alt_sel then
			sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		end
		if kc_has_vsp_sel then
			sysMCP.vspSelector:actuate(0)
		end
		if kc_has_autopilot then
			sysMCP.discAPSwitch:actuate(0)
		end
	elseif flightphase == kc_phase_before_takeoff then
		if kc_has_flightdir then
			sysMCP.fdirGroup:actuate(1)
		end
		if kc_has_autothrottle then
			sysMCP.athrSwitch:actuate(1)
		end
		if kc_has_ias_sel and kc_is_airbus == false then
			sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		end
		if kc_has_hdg_sel and kc_is_airbus == false then
			sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		end
		if kc_has_alt_sel then
			sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		end
		if kc_is_airbus == false then
			if kc_has_vnav and kc_has_lnav then
				sysMCP.lnavSwitch:actuate(1)
				sysMCP.vnavSwitch:actuate(1)
			end
		end
		if kc_has_ils then
			sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
			sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
		end
		if kc_has_vsp_sel then
			sysMCP.vspSelector:actuate(0)
		end
		if kc_has_autopilot then
			sysMCP.discAPSwitch:actuate(0)
		end
		if kc_has_yawdamper then
			sysMCP.yawDamper:actuate(1)
		end
	elseif flightphase == kc_phase_afterland then
		if kc_has_flightdir then
			sysMCP.fdirGroup:actuate(0)
		end
		if kc_has_autothrottle then
			sysMCP.athrSwitch:actuate(0)
		end
		if kc_has_hdg_sel then
			sysMCP.hdgSelector:setValue(0)
		end
		if kc_has_ias_sel then
			sysMCP.speedSwitch:actuate(0)
		end
		if kc_has_autopilot then
			sysMCP.discAPSwitch:actuate(0)
		end
		if kc_has_yawdamper then
			sysMCP.yawDamper:actuate(0)
		end
	else 
		logMsg("Invalid flightphase")
	end
end 

function kc_bck_disconnect_ap(trigger)
	command_once(cmdAPDisconnect)
end

-- ===== UI related functions =====

function sysMCP:panel_render()
	imgui.BeginGroup()

		if kc_has_flightdir then
			kc_imgui_toggle_button_mcp("FD",sysMCP.fdirGroup,0,22,19)
		end
		if kc_has_autopilot then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("A/P",sysMCP.ap1Switch,10,30,19)
		end
		if kc_has_lnav then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LNV",sysMCP.lnavSwitch,10,30,19)
		end
		if kc_has_lnav then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("VNV",sysMCP.vnavSwitch,10,30,19)
		end
		
		-- if kc_has_ias_sel then
			-- imgui.SameLine()
			-- kc_imgui_number_mcp("SPD",sysMCP.iasSelector,110,32,5)
		-- end
		-- if kc_has_mach_switch then
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("S/M",sysMCP.machSwitch,0,30,19)
		-- end
		-- if kc_has_flch_ias then
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("FLC",sysMCP.speedSwitch,10,30,19)
		-- end
		-- if kc_has_autothrottle then
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("A/T",sysMCP.athrSwitch,0,30,19)
		-- end
		-- if kc_has_hdg_sel then
			-- imgui.SameLine()
			-- kc_imgui_number_mcp("HDG",sysMCP.hdgSelector,111,32,4)
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("HDG",sysMCP.hdgselSwitch,10,30,19)
		-- end
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("NAV",sysMCP.vorlocSwitch,10,30,19)
		if kc_has_alt_sel then
			imgui.SameLine()
			kc_imgui_number_mcp("ALT",sysMCP.altSelector,112,45,6)
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("ALT",sysMCP.altholdSwitch,10,30,19)
		end
		-- if kc_has_meter_pfd then
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("MTR",sysEFIS.mtrsPilot,0,30,19)
		-- end
		-- if kc_has_vsp_sel then
			-- imgui.SameLine()
			-- kc_imgui_number_mcp("V/S",sysMCP.vspSelector,113,45,6)
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("V/S",sysMCP.vsSwitch,10,30,19)
			-- imgui.SameLine()
			-- kc_imgui_cmd_button("DN","sim/autopilot/nose_down",10,30,19)
			-- imgui.SameLine()
			-- kc_imgui_cmd_button("UP","sim/autopilot/nose_up",10,30,19)
		-- end 
		-- if kc_has_ils then
			-- imgui.SameLine()
			-- kc_imgui_number_mcp("CRS1",sysMCP.crs1Selector,114,32,4)
			-- imgui.SameLine()
			-- kc_imgui_number_mcp("CRS2",sysMCP.crs2Selector,115,32,4)
			-- imgui.SameLine()
			-- kc_imgui_toggle_button_mcp("APR",sysMCP.approachSwitch,10,30,19)
		-- end
	imgui.EndGroup()
end
return sysMCP
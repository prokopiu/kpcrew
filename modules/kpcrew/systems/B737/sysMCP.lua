-- B737 airplane 
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

logMsg("B737 sysMCP")

--------- Switch datarefs common
local drefFlightDirectorL	= "laminar/B738/autopilot/flight_director_pos"
local drefFlightDirectorR	= "laminar/B738/autopilot/flight_director_fo_pos"
local drefAutopilot1		= "laminar/B738/autopilot/cmd_a_status"
local drefAltHoldStatus		= "laminar/B738/autopilot/alt_hld_status"
local drefNavMode			= "laminar/B738/autopilot/vorloc_status"
local drefHdgSelMode		= "laminar/B738/autopilot/hdg_sel_status"
local drefApprMode			= "laminar/B738/autopilot/app_status"
local drefVSPMode			= "laminar/B738/autopilot/vs_status"
local drefVNAVMode			= "laminar/B738/autopilot/vnav_status1"
local drefLNAVMode			= "laminar/B738/autopilot/lnav_status"
local drefTOGAMode			= "laminar/B738/autopilot/left_toga_pos"
local drefATMode			= "laminar/B738/autopilot/autothrottle_status1"
local drefCRS1				= "laminar/B738/autopilot/course_pilot"
local drefCRS2				= "laminar/B738/autopilot/course_copilot"
local drefIAS				= "laminar/B738/autopilot/mcp_speed_dial_kts"

local drefIASMachSwitch		= "sim/cockpit2/autopilot/airspeed_is_mach"
local drefHDG				= "laminar/B738/autopilot/mcp_hdg_dial"
local drefALT				= "laminar/B738/autopilot/mcp_alt_dial"
local drefVSP				= "laminar/B738/autopilot/ap_vvi_pos"
local drefAPDisconnect		= "laminar/B738/autopilot/disconnect_pos"
local drefYawDamper			= "laminar/B738/toggle_switch/yaw_dumper_pos"
local drefAPYoke			= "laminar/B738/autopilot/cmd_a_status"


--------- Annunciator datarefs common

--------- Switch commands common
local cmdFDir1Tgl			= "laminar/B738/autopilot/flight_director_toggle"
local cmdFDir2Tgl			= "laminar/B738/autopilot/flight_director_fo_toggle"
local cmdAutopilot1Tgl		= "laminar/B738/autopilot/cmd_a_press"
local cmdAltHoldTgl			= "laminar/B738/autopilot/alt_hld_press"
local cmdNavModeTgl			= "laminar/B738/autopilot/vorloc_press"
local cmdHdgModeTgl			= "laminar/B738/autopilot/hdg_sel_press"
local cmdApprModeTgl		= "laminar/B738/autopilot/app_press"
local cmdVSPTgl				= "laminar/B738/autopilot/vs_press"
local cmdATTgl				= "laminar/B738/autopilot/autothrottle_arm_toggle"
local cmdIASUp				= "sim/autopilot/airspeed_up"
local cmdIASDown			= "sim/autopilot/airspeed_down"
local cmdALTUp				= "laminar/B738/autopilot/altitude_up"
local cmdALTDown			= "laminar/B738/autopilot/altitude_dn"
local cmdHDGUp				= "laminar/B738/autopilot/heading_up"
local cmdHDGDown			= "laminar/B738/autopilot/heading_dn"
local cmdCRS1Up				= "laminar/B738/autopilot/course_pilot_dn"
local cmdCRS1Down			= "laminar/B738/autopilot/course_pilot_dn"
local cmdCRS2Up				= "laminar/B738/autopilot/course_copilot_dn"
local cmdCRS2Down			= "laminar/B738/autopilot/course_copilot_dn"
local cmdLNAVTgl			= "laminar/B738/autopilot/lnav_press"
local cmdVNAVTgl			= "laminar/B738/autopilot/vnav_press"
local cmdSpdModeTgl			= "sim/autopilot/speed_hold"
local cmdTOGASet			= "laminar/B738/autopilot/left_toga_press"
local cmdVSPUp				= "sim/autopilot/vertical_speed_up"
local cmdVSPDown			= "sim/autopilot/vertical_speed_down"
local cmdAPDisconnect		= "laminar/B738/autopilot/disconnect_toggle"
local cmdAPYoke				= "laminar/B738/autopilot/capt_disco_press"
local cmdYawDamperTgl		= "sim/systems/yaw_damper_toggle"

----------- Switches

-- Flight Directors
sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdirpilot",drefFlightDirectorL,0,cmdFDir1Tgl)
sysMCP.fdirCoPilotSwitch 	= TwoStateToggleSwitch:new("fdircopilot",drefFlightDirectorR,0,cmdFDir2Tgl)
sysMCP.fdirAnc 				= CustomAnnunciator:new("fdiranc",
	function () if get(drefFlightDirectorL) > 0 or get(drefFlightDirectorR) > 0 then return 1 else return 0 end end)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

-- **AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1",drefAutopilot1,0,cmdAutopilot1Tgl)
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc",drefAutopilot1,0)

-- **ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold",drefAltHoldStatus,0,cmdAltHoldTgl)
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc",drefAltHoldStatus,0)

-- **HDG SELECT mode
sysMCP.hdgselSwitch 		= TwoStateToggleSwitch:new("hdgsel",drefHdgSelMode,0,cmdHdgModeTgl)
sysMCP.hdgAnc 				= SimpleAnnunciator:new("hdganc",drefHdgSelMode,0)

-- **VORLOC/NAV
sysMCP.vorlocSwitch			= TwoStateToggleSwitch:new("vorloc",drefNavMode,0,cmdNavModeTgl)
sysMCP.navAnc 				= SimpleAnnunciator:new("navanc",drefNavMode,0)

-- **APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach",drefApprMode,0,cmdApprModeTgl)
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc",drefApprMode,0)

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateDrefSwitch:new("yawdamper",drefYawDamper,0)

-- **VS
sysMCP.vsSwitch 			= TwoStateToggleSwitch:new("vsmode",drefVSPMode,0,cmdVSPTgl)
sysMCP.vspAnc 				= SimpleAnnunciator:new("vspanc",drefVSPMode,0)

-- **TOGA Button
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot",drefTOGAMode,0,cmdTOGASet)

-- **ATHR
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr",drefATMode,0,cmdATTgl)
sysMCP.athrAnc				= SimpleAnnunciator:new("athr",drefATMode,0)

-- LNAV / GPSS mode
sysMCP.lnavSwitch 			= TwoStateToggleSwitch:new("lnav",drefLNAVMode,0,cmdLNAVTgl)

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav",drefVNAVMode,0,cmdVNAVTgl)
	
-- === Selectors

-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1",drefCRS1,0,cmdCRS1Down,cmdCRS1Up,0,360,false,1)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2",drefCRS2,0,cmdCRS2Down,cmdCRS2Up,0,360,false,1)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias",drefIAS,0,cmdIASDown,cmdIASUp,0,999,false,1)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt",drefALT,0,cmdALTDown,cmdALTUp,0,40000,false,100)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt",drefALT,0)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg",drefHDG,0,cmdHDGDown,cmdHDGUp,0,360,false,1)

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp",drefVSP,0,cmdVSPDown,cmdVSPUp,-7900,7900,true)

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc",drefAPDisconnect,0,cmdAPDisconnect)
sysMCP.apDiscYoke 			= TwoStateCustomSwitch:new("discapyoke",drefAPYoke,0,
	function () end,
	function () kc_procvar_set("apdisconnect",true) end,
	function () end,
	function () return get("laminar/B738/autopilot/cmd_a_status") end)

function kc_bck_disconnect_ap(trigger)
	local delayvar = "apdiscdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_once("laminar/B738/autopilot/disconnect_toggle")
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			command_once("laminar/B738/autopilot/disconnect_toggle")
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end

end

return sysMCP
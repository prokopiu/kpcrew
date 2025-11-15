-- B742 airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysMCP.fdirPilotSwitch 	
-- sysMCP.fdirCoPilotSwitch 
-- sysMCP.fdirGroup 		
-- sysMCP.fdirAnc 	

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

logMsg("B742 sysMCP")

--------- Switch datarefs common
local drefFlightDirectorL	= "B742/AP_panel/flight_dir_on_sw"
local drefFlightDirectorR	= "B742/AP_panel/flight_dir_on_sw"
local drefAutopilot1		= "B742/AP_panel/AP_engage_A"
local drefAutopilot2		= "B742/AP_panel/AP_engage_B"
local drefAltHoldStatus		= "B742/AP_panel/altitude_mode_sw"
local drefIAS				= "B742/AP_panel/AT_spd_set_rotary"
local drefALT				= "B742/AP_panel/altitude_set"
local drefHDG				= "B742/AP_panel/heading_set"
local drefVSP				= "sim/cockpit2/autopilot/vvi_dial_fpm"
local drefCRS1				= "B742/AP_panel/course_1_set"
local drefCRS2				= "B742/AP_panel/course_2_set"
local drefATMode			= "B742/AP_panel/AT_on_sw"
local drefYawDamper			= "B742/OVHD/YAW_damper_on_off_sw_up"
local drefYawDamperCap		= "B742/OVHD/YAW_damper_on_off_cap_up"
local drefYawDamper2		= "B742/OVHD/YAW_damper_on_off_sw_up"
local drefYawDamperCap2		= "B742/OVHD/YAW_damper_on_off_cap_up"
local drefNavMode			= "B742/AP_panel/AP_nav_mode_sel"
local drefApprMode			= "B742/AP_panel/AP_nav_mode_sel"

local drefHdgSelMode		= "sim/cockpit2/autopilot/heading_mode"


local drefAltMode			= "sim/cockpit2/autopilot/altitude_mode"
local drefTOGAMode			= "sim/cockpit2/autopilot/TOGA_status"


local drefIASMachSwitch		= "sim/cockpit2/autopilot/airspeed_is_mach"
local drefAPDisconnect		= "sim/cockpit2/annunciators/autopilot_disconnect"


--------- Switch commands common
local cmdVSPUp				= "sim/autopilot/vertical_speed_up"
local cmdVSPDown			= "sim/autopilot/vertical_speed_down"
----------- Switches

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left",drefFlightDirectorL,-1)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right",drefFlightDirectorR,1)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc",drefFlightDirectorL,-1)

-- **AUTOPILOT
sysMCP.ap1Switch 			= TwoStateCustomSwitch:new("autopilot1",drefAutopilot1,0,
	function () set(drefAutopilot1,2) end,
	function () set(drefAutopilot1,0) end,
	function ()
		if get(drefAutopilot1) == 0 then
			set(drefAutopilot1,2)
		else
			set(drefAutopilot1,0)
		end
	end,
	function () if get(drefAutopilot1) > 0 then return 1 else return 0 end end)
sysMCP.ap2Switch 			= TwoStateCustomSwitch:new("autopilot1",drefAutopilot2,0,
	function () set(drefAutopilot2,2) end,
	function () set(drefAutopilot2,0) end,
	function ()
		if get(drefAutopilot2) == 0 then
			set(drefAutopilot2,2)
		else
			set(drefAutopilot2,0)
		end
	end,
	function () if get(drefAutopilot2) > 0 then return 1 else return 0 end end)
sysMCP.apAnc 				= CustomAnnunciator:new("autopilotanc",
	function () if get(drefAutopilot1) > 0 or get(drefAutopilot2) > 0 then return 1 else return 0 end end)

sysMCP.altAnc 				= SimpleAnnunciator:new("altanc",drefAltHoldStatus,0)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias",drefIAS,0,nil,nil,100,340,false,1)
	
-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt",drefALT,0,	nil,nil,0,50000,false,1)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt",drefALT,0)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg",drefHDG,0,	nil,nil,0,359,false,1)
	
-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp",drefVSP,0,cmdVSPDown,cmdVSPUp,-7900,7900,true)
	
-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1",drefCRS1,0,nil,nil,0,359,false,1)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2",drefCRS2,0,nil,nil,0,359,false,1)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- **ATHR
-- -1=hard off, not even armed. 0=servos declutched (arm, hold), 1=airspeed hold, 2=N1 target hold, 3=retard, 4=reserved for future use
sysMCP.athrSwitch 			= TwoStateDrefSwitch:new("athr",drefATMode,0)
sysMCP.athrAnc				= SimpleAnnunciator:new("athr",drefATMode,0)

-- YAW DAMPER
sysMCP.yawDamper			= SwitchGroup:new("yawdamper")
sysMCP.yawDamper1			= TwoStateCustomSwitch:new("yawdamper",drefYawDamper,0,
	function () set(drefYawDamper,1) set(drefYawDamperCap,0) end,
	function ()	set(drefYawDamper,0) set(drefYawDamperCap,1) end,
	function ()
		if get(drefYawDamper) == 0 then set(drefYawDamper,1) set(drefYawDamperCap,0)
		else set(drefYawDamper,0) set(drefYawDamperCap,1) end
	end,
	function () return get(drefYawDamper) end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper1)
sysMCP.yawDamper2			= TwoStateCustomSwitch:new("yawdamper",drefYawDamper2,0,
	function () set(drefYawDamper2,1) set(drefYawDamperCap2,0) end,
	function ()	set(drefYawDamper2,0) set(drefYawDamperCap2,1) end,
	function ()
		if get(drefYawDamper2) == 0 then set(drefYawDamper2,1) set(drefYawDamperCap2,0)
		else set(drefYawDamper2,0) set(drefYawDamperCap2,1) end
	end,
	function () return get(drefYawDamper2) end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper2)

sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () if get(drefNavMode) == 0 then return 1 else return 0 end end)

sysMCP.aprAnc 				= CustomAnnunciator:new("apranc",
function () if get(drefApprMode) == 4 then return 1 else return 0 end end)

--------- Macros

-- ====================================== A/P & Glareshield related functions
function kc_macro_mcp(flightphase)
	logMsg("MCP flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.discAPSwitch:actuate(0)
	elseif flightphase == kc_phase_after_start then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(1)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.discAPSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(1)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
		sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
	elseif flightphase == kc_phase_afterland then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end 

return sysMCP
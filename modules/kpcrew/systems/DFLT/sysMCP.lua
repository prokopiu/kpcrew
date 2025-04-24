-- DFLT airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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

--------- Switches

-- Flight Directors (DFLT only one supported)
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","sim/cockpit2/autopilot/flight_director_mode",0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","sim/cockpit2/autopilot/flight_director2_mode",0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","sim/cockpit2/autopilot/flight_director_mode",0)

-- HDG SELECT mode
sysMCP.hdgselSwitch 		= TwoStateDrefSwitch:new("hdgsel","sim/cockpit2/autopilot/heading_mode",0)
sysMCP.hdgAnc 				= CustomAnnunciator:new("hdganc",
function () 
	if get("sim/cockpit2/autopilot/heading_status") == 1 or get("sim/cockpit2/autopilot/heading_status") == 14 then
		return 1
	else
		return 0
	end
end)

-- VORLOC
sysMCP.vorlocSwitch			= TwoStateToggleSwitch:new("vorloc","sim/cockpit2/autopilot/nav_status",0,
	"sim/autopilot/NAV")

-- NAV mode annunciator
-- Autopilot lateral mode. (0=roll, 1=heading sel, 2=nav, 10=TO/GA, 11=Re-entry, 12=Free, 
-- 13=GPSS, 14=heading hold, 15=turn-rate, 16=rollout, 18=track)
sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () 
	if get("sim/cockpit2/autopilot/heading_mode") == 2 or 
		get("sim/cockpit2/autopilot/heading_mode") == 13 then
		return 1
	else
		return 0
	end
end)

-- LNAV / GPSS mode
sysMCP.lnavSwitch 			= TwoStateCustomSwitch:new("lnav","sim/cockpit2/autopilot/heading_mode",0,
function ()
	set("sim/operation/override/override_autopilot",13)
end,
function ()
	set("sim/operation/override/override_autopilot",0)
end,
function ()
	if get("sim/cockpit2/autopilot/heading_mode") ~= 13 then
		set("sim/operation/override/override_autopilot",13)
	else
		set("sim/operation/override/override_autopilot",0)
	end
end,
function () 
	if get("sim/cockpit2/autopilot/heading_mode") == 2 or 
		get("sim/cockpit2/autopilot/heading_mode") == 13 then
		return 1
	else
		return 0
	end
end)

-- ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold","sim/cockpit2/autopilot/altitude_hold_status",0,
	"sim/autopilot/altitude_hold")

sysMCP.altAnc 				= SimpleAnnunciator:new("altanc","sim/cockpit2/autopilot/altitude_hold_status",0)

-- APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach","sim/cockpit2/autopilot/approach_status",0,
	"sim/autopilot/approach")

sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc","sim/cockpit2/autopilot/approach_status",0)

-- VS
sysMCP.vsSwitch 			= TwoStateCustomSwitch:new("vsmode","sim/cockpit2/autopilot/altitude_mode",0,
function ()
	set("sim/cockpit2/autopilot/altitude_mode",4)
end,
function ()
	set("sim/cockpit2/autopilot/altitude_mode",0)
end,
function ()
	if get("sim/cockpit2/autopilot/altitude_mode") ~= 4 then
		set("sim/cockpit2/autopilot/altitude_mode",4)
	else
		set("sim/cockpit2/autopilot/altitude_mode",0)
	end
end,
function () 
	if get("sim/cockpit2/autopilot/altitude_mode") == 4 then
		return 1
	else
		return 0
	end
end)

-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () 
	if get("sim/cockpit2/autopilot/altitude_mode") == 4 or get("sim/cockpit2/autopilot/fms_vnav") > 0 then
		return 1
	else
		return 0
	end
end)

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav","sim/cockpit2/autopilot/fms_vnav",0,
	"sim/autopilot/FMS")

-- IAS mode or Level Change or FLCH
sysMCP.flchSwitch 		= TwoStateCustomSwitch:new("flch","sim/cockpit2/autopilot/altitude_mode",0,
function ()
	set("sim/operation/override/override_autopilot",5)
end,
function ()
	set("sim/operation/override/override_autopilot",0)
end,
function ()
	if get("sim/cockpit2/autopilot/heading_mode") ~= 5 then
		set("sim/operation/override/override_autopilot",5)
	else
		set("sim/operation/override/override_autopilot",0)
	end
end,
function () 
	if get("sim/cockpit2/autopilot/heading_mode") == 5 then
		return 1
	else
		return 0
	end
end)

-- SPEED
sysMCP.speedSwitch 			= TwoStateDrefSwitch:new("speed","sim/cockpit2/autopilot/autothrottle_enabled",0)

sysMCP.spdAnc 				= SimpleAnnunciator:new("spdanc","sim/cockpit2/autopilot/autothrottle_enabled",0)

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1","sim/cockpit2/autopilot/servos_on",0,
	"sim/autopilot/servos_toggle")

sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc","sim/cockpit2/autopilot/servos_on",0)

-- BACKCOURSE
sysMCP.backcourse 			= InopSwitch:new("backcourse")

sysMCP.bcAnc 				= InopSwitch:new("bc")

-- TOGA
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot","sim/cockpit2/autopilot/TOGA_status",0,
	"sim/autopilot/take_off_go_around")

-- ATHR
-- -1=hard off, not even armed. 0=servos declutched (arm, hold), 1=airspeed hold, 2=N1 target hold, 3=retard, 4=reserved for future use
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr","sim/cockpit2/autopilot/autothrottle_enabled",0,
	"sim/autopilot/autothrottle_toggle")

-- === Selectors

-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1","sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot",0,
	"sim/radios/obs1_down","sim/radios/obs1_up",0,359,false)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2","sim/cockpit2/radios/actuators/nav2_obs_deg_mag_pilot",0,
	"sim/radios/obs2_down","sim/radios/obs2_up",0,359,false)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1/EPR Switch 
sysMCP.n1Switch 			= InopSwitch:new("n1")

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","sim/cockpit2/autopilot/airspeed_dial_kts",0,
	"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up",100,340,false)

-- KTS/MACH C/O
sysMCP.machSwitch 			= TwoStateDrefSwitch:new("ktsmach","sim/cockpit2/autopilot/airspeed_is_mach",0)

-- SPD INTV
sysMCP.spdIntvSwitch 		= InopSwitch:new("spdintv")

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","sim/cockpit2/autopilot/heading_dial_deg_mag_pilot",0,
	"sim/autopilot/heading_down","sim/autopilot/heading_up",0,359,false)

-- TURNRATE
sysMCP.turnRateSelector 	= InopSwitch:new("turnrate")

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","sim/cockpit2/autopilot/altitude_dial_ft",0,
	"sim/autopilot/altitude_down","sim/autopilot/altitude_up",0,50000,false)

-- ALT INTV
sysMCP.altintvSwitch 		= InopSwitch:new("altintv")

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","sim/cockpit2/autopilot/vvi_dial_fpm",0,
	"sim/autopilot/vertical_speed_down","sim/autopilot/vertical_speed_up",-7900,7900,true)

-- CWS Boeing only
sysMCP.cwsaSwitch 			= InopSwitch:new("cwsa")
sysMCP.cwsbSwitch 			= InopSwitch:new("cwsb")

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/disconnect")
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/disconnect")

-- YAW DAMPER
sysMCP.yawDamper			= TwoStateToggleSwitch:new("yawdamper","sim/cockpit2/annunciators/yaw_damper",0,
	"sim/systems/yaw_damper_toggle")

------- Annunciators

-- ===== UI related functions =====

function sysMCP:panel_render()
	imgui.BeginGroup()
		imgui.TextUnformatted("MCP ")
		kc_imgui_rotary_mcp("CRS:%03d",sysMCP.crs1Selector,10,11)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("FDIR",sysMCP.fdirGroup,10,42,25)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("ATHR",sysMCP.athrSwitch,10,42,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("SPD",sysMCP.speedSwitch,10,42,25)
		imgui.SameLine()
		kc_imgui_rotary_mcp("SPD:%03d",sysMCP.iasSelector,10,12)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("NAV",sysMCP.vorlocSwitch,10,42,25)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("HDG",sysMCP.hdgselSwitch,10,42,25)
		imgui.SameLine()
		kc_imgui_rotary_mcp("HDG:%03d",sysMCP.hdgSelector,10,13)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("ALT",sysMCP.altholdSwitch,10,42,25)
		imgui.SameLine()
		kc_imgui_rotary_mcp("ALT:%05d",sysMCP.altSelector,10,14)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("V/S",sysMCP.vsSwitch,10,42,25)
		imgui.SameLine()
		kc_imgui_rotary_mcp((sysMCP.vspSelector:getStatus() >= 0) and "VSP:+%04d" or "VSP:%05d",sysMCP.vspSelector,10,15)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("APR",sysMCP.approachSwitch,10,42,25)
		imgui.SameLine()
		kc_imgui_toggle_button_mcp("A/P",sysMCP.ap1Switch,10,59,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("N1",sysMCP.n1Switch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("VN",sysMCP.vnavSwitch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("LC",sysMCP.lvlchgSwitch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("LN",sysMCP.lnavSwitch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("AP",sysMCP.approachSwitch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("AL",sysMCP.altholdSwitch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("VS",sysMCP.vsSwitch,10,22,25)
		-- imgui.SameLine()
		-- kc_imgui_toggle_button_mcp("A/P",sysMCP.ap1Switch,10,59,25)
	imgui.EndGroup()
end

return sysMCP
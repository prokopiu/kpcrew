-- DFLT airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMCP = {
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

local drefVORLocLight 		= "sim/cockpit2/autopilot/nav_status"
local drefLNAVLight 		= "sim/cockpit2/radios/actuators/HSI_source_select_pilot"
local drefSPDLight 			= "sim/cockpit2/autopilot/autothrottle_on"
local drefVSLight 			= "sim/cockpit2/autopilot/vvi_status"
local drefVNAVLight 		= "sim/cockpit2/autopilot/fms_vnav"

--------- Switches

-- Flight Directors (DFLT only one supported)
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","sim/cockpit2/autopilot/flight_director_mode",0)
sysMCP.fdirCoPilotSwitch 	= InopSwitch:new("fdir right")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
-- Flight Directors annunciator
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","sim/cockpit2/autopilot/flight_director_mode",0)

-- HDG SEL
sysMCP.hdgselSwitch 		= TwoStateToggleSwitch:new("hdgsel","sim/cockpit2/autopilot/heading_mode",-1,
	"sim/autopilot/heading")

-- VORLOC
sysMCP.vorlocSwitch 		= TwoStateToggleSwitch:new("vorloc",drefVORLocLight,0,"sim/autopilot/NAV")

-- ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold","sim/cockpit2/autopilot/altitude_hold_status",0,
	"sim/autopilot/altitude_hold")

-- APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach","sim/cockpit2/autopilot/approach_status",0,
	"sim/autopilot/approach")

-- VS
sysMCP.vsSwitch 			= TwoStateToggleSwitch:new("vs",drefVSLight,0,"sim/autopilot/vertical_speed")

-- SPEED
sysMCP.speedSwitch 			= TwoStateToggleSwitch:new("speed",drefSPDLight,0,"sim/autopilot/autothrottle_toggle")

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1","sim/cockpit2/autopilot/servos_on",0,
	"sim/autopilot/servos_toggle")

-- BACKCOURSE
sysMCP.backcourse 			= InopSwitch:new("backcourse")

-- TOGA
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot","sim/cockpit2/autopilot/TOGA_status",0,
	"sim/autopilot/take_off_go_around")

-- ATHR
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr","sim/cockpit2/autopilot/autothrottle_enabled",0,
	"sim/autopilot/autothrottle_toggle")


-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1","sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot",0,
	"sim/radios/obs1_down","sim/radios/obs1_up",0,359,false)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2","sim/cockpit2/radios/actuators/nav2_obs_deg_mag_pilot",0,
	"sim/radios/obs2_down","sim/radios/obs2_up",0,359,false)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1 Boeing
sysMCP.n1Switch 			= InopSwitch:new("n1")

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","sim/cockpit/autopilot/airspeed",0,
	"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up",100,340,false)

-- KTS/MACH C/O
sysMCP.machSwitch 			= InopSwitch:new("mach")

-- SPD INTV
sysMCP.spdIntvSwitch 		= InopSwitch:new("spdintv")

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav",drefVNAVLight,0,"sim/autopilot/FMS")

-- LVL CHG
sysMCP.lvlchgSwitch 		= InopSwitch:new("lvlchg")

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","sim/cockpit2/autopilot/heading_dial_deg_mag_pilot",0,
	"sim/autopilot/heading_down","sim/autopilot/heading_up",0,359,false)

-- TURNRATE
sysMCP.turnRateSelector 	= InopSwitch:new("turnrate")

-- LNAV
sysMCP.lnavSwitch 			= InopSwitch:new("lnav")

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","sim/cockpit2/autopilot/altitude_dial_ft",0,
	"sim/autopilot/altitude_down","sim/autopilot/altitude_up",0,50000,false)

-- ALT INTV
sysMCP.altintvSwitch 		= InopSwitch:new("altintv")

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","sim/cockpit2/autopilot/vvi_dial_fpm",0,
	"sim/autopilot/vertical_speed_down","sim/autopilot/vertical_speed_up",-7900,7900,true)

-- CWS Boeing only
sysMCP.cwsaSwitch 			= TwoStateToggleSwitch:new("cwsa","sim/cockpit2/autopilot/servos_on",0,
	"sim/autopilot/fdir_servos_toggle")
sysMCP.cwsbSwitch 			= InopSwitch:new("cwsb")

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/disconnect")
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"sim/autopilot/disconnect")

-- NAVIGATION SWITCHES
sysMCP.vhfNavSwitch 		= InopSwitch:new("vhfnav")
sysMCP.irsNavSwitch			= InopSwitch:new("irsnav")
sysMCP.fmcNavSwitch 		= InopSwitch:new("fmcnav")
sysMCP.displaySourceSwitch 	= InopSwitch:new("dispsrc")
sysMCP.displayControlSwitch = InopSwitch:new("dispctrl")

------- Annunciators


-- HDG Select/mode annunciator
sysMCP.hdgAnc 				= CustomAnnunciator:new("hdganc",
function () 
	if get("sim/cockpit2/autopilot/heading_status") > 0 then
		return 1
	else
		return 0
	end
end)


-- NAV mode annunciator
sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () 
	if get(drefVORLocLight) > 0 or get(drefLNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- APR Select/mode annunciator
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc","sim/cockpit2/autopilot/approach_status",0)

-- SPD mode annunciator
sysMCP.spdAnc 				= SimpleAnnunciator:new("spdanc","sim/cockpit2/autopilot/autothrottle_on",0)

-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () 
	if get(drefVSLight) > 0 or get(drefVNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ALT mode annunciator
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc","sim/cockpit2/autopilot/altitude_hold_status",0)

-- A/P mode annunciator
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc","sim/cockpit2/autopilot/servos_on",0)

-- BC mode annunciator
sysMCP.bcAnc 				= InopSwitch:new("bc")

-- ===== UI related functions =====

-- render the MCP part
function sysMCP:render(ypos,height)

	-- reposition when screen size changes
	if kh_mcp_wnd_state < 0 then
		float_wnd_set_position(kh_mcp_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 25, ypos-height)
		kh_mcp_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_mcp_wnd_state == 1 then
		imgui.Button("<", 17, 25)
		if imgui.IsItemActive() then 
			kh_mcp_wnd_state = 0
			float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 25, ypos-height)
		end
	end

	if kh_mcp_wnd_state == 0 then
		imgui.Button("M", 17, 25)
		if imgui.IsItemActive() then 
			kh_mcp_wnd_state = 1
			float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 920, ypos-height)
		end
	end

	sysMCP.crs1Selector:setDefaultDelay(3)
	sysMCP.iasSelector:setDefaultDelay(4)
	sysMCP.hdgSelector:setDefaultDelay(3)
	sysMCP.altSelector:setDefaultDelay(4)
	sysMCP.vspSelector:setDefaultDelay(8)

	kc_imgui_rotary_mcp("CRS:%03d",sysMCP.crs1Selector,10,11)
	kc_imgui_toggle_button_mcp("FD",sysMCP.fdirGroup,10,22,25)
	kc_imgui_toggle_button_mcp("AT",sysMCP.athrSwitch,10,22,25)
	-- kc_imgui_toggle_button_mcp("N1",sysMCP.n1Switch,10,22,25)
	kc_imgui_toggle_button_mcp("SP",sysMCP.speedSwitch,10,22,25)
	kc_imgui_rotary_mcp("SPD:%03d",sysMCP.iasSelector,10,12)
	kc_imgui_toggle_button_mcp("VN",sysMCP.vnavSwitch,10,22,25)
	-- kc_imgui_toggle_button_mcp("LC",sysMCP.lvlchgSwitch,10,22,25)
	kc_imgui_rotary_mcp("HDG:%03d",sysMCP.hdgSelector,10,13)
	kc_imgui_toggle_button_mcp("HD",sysMCP.hdgselSwitch,10,22,25)
	-- kc_imgui_toggle_button_mcp("LN",sysMCP.lnavSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("LO",sysMCP.vorlocSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("AP",sysMCP.approachSwitch,10,22,25)
	kc_imgui_rotary_mcp("ALT:%05d",sysMCP.altSelector,10,14)
	kc_imgui_toggle_button_mcp("AL",sysMCP.altholdSwitch,10,22,25)
	kc_imgui_rotary_mcp((sysMCP.vspSelector:getStatus() >= 0) and "VSP:+%04d" or "VSP:%05d",sysMCP.vspSelector,10,15)
	kc_imgui_toggle_button_mcp("VS",sysMCP.vsSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("A/P",sysMCP.ap1Switch,10,59,25)

end

return sysMCP
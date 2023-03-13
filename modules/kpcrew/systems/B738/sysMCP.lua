-- B738 airplane 
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

local drefVORLocLight 		= "laminar/B738/autopilot/vorloc_status"
local drefLNAVLight			= "laminar/B738/autopilot/lnav_status"
local drefSPDLight 			= "laminar/B738/autopilot/speed_mode"
local drefN1Light 			= "laminar/B738/autopilot/n1_status"
local drefVSLight 			= "laminar/B738/autopilot/vs_status"
local drefLVLCHGLight 		= "laminar/B738/autopilot/lvl_chg_status"
local drefVNAVLight 		= "laminar/B738/autopilot/vnav_status1"
local drefAPStatusLight 	= "laminar/B738/autopilot/cmd_a_status"
local drefCMDBLight 		= "laminar/B738/autopilot/cmd_b_status"

--------- Switches

-- Flight Directors
sysMCP.fdirPilotSwitch 		= TwoStateToggleSwitch:new("fdirpilot","laminar/B738/autopilot/flight_director_pos",0,
	"laminar/B738/autopilot/flight_director_toggle")
sysMCP.fdirCoPilotSwitch 	= TwoStateToggleSwitch:new("fdircopilot","laminar/B738/autopilot/flight_director_fo_pos",0,
	"laminar/B738/autopilot/flight_director_fo_toggle")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

-- HDG SEL
sysMCP.hdgselSwitch 		= TwoStateToggleSwitch:new("hdgsel","laminar/B738/autopilot/hdg_sel_status",0,
	"laminar/B738/autopilot/hdg_sel_press")

-- VORLOC
sysMCP.vorlocSwitch 		= TwoStateToggleSwitch:new("vorloc","laminar/B738/autopilot/vorloc_status",0,
	"laminar/B738/autopilot/vorloc_press")

-- ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold","laminar/B738/autopilot/alt_hld_status",0,
	"laminar/B738/autopilot/alt_hld_press")

-- APPROACH
sysMCP.approachSwitch 		= TwoStateToggleSwitch:new("approach","laminar/B738/autopilot/app_status",0,
	"laminar/B738/autopilot/app_press")

-- VS MODE
sysMCP.vsSwitch 			= TwoStateToggleSwitch:new("vs","laminar/B738/autopilot/vs_status",0,
	"laminar/B738/autopilot/vs_press")

-- SPEED
sysMCP.speedSwitch 			= TwoStateToggleSwitch:new("speed","laminar/B738/autopilot/speed_status1",0,
	"laminar/B738/autopilot/speed_press")

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1","laminar/B738/autopilot/cmd_a_status",0,
	"laminar/B738/autopilot/cmd_a_press")
sysMCP.ap2Switch 			= TwoStateToggleSwitch:new("autopilot2","laminar/B738/autopilot/cmd_b_status",0,
	"laminar/B738/autopilot/cmd_b_press")

-- BACKCOURSE
sysMCP.backcourse 			= InopSwitch:new("backcourse")

-- TOGA
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot","laminar/B738/autopilot/ap_takeoff",0,
	"laminar/B738/autopilot/left_toga_press")
sysMCP.togaCopilotSwitch 	= TwoStateToggleSwitch:new("togacopilot","laminar/B738/autopilot/ap_takeoff",0,
	"laminar/B738/autopilot/right_toga_press")

-- ATHR
sysMCP.athrSwitch 			= TwoStateToggleSwitch:new("athr","laminar/B738/autopilot/autothrottle_status1",0,
	"laminar/B738/autopilot/autothrottle_arm_toggle")

-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1","laminar/B738/autopilot/course_pilot",0,
	"laminar/B738/autopilot/course_pilot_dn","laminar/B738/autopilot/course_pilot_up",0,359,false)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2","laminar/B738/autopilot/course_copilot",0,
	"laminar/B738/autopilot/course_copilot_dn","laminar/B738/autopilot/course_copilot_up",0,359,false)
sysMCP.crsSelectorGroup 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1 Boeing
sysMCP.n1Switch 			= TwoStateToggleSwitch:new("n1","laminar/B738/autopilot/n1_status",0,
	"laminar/B738/autopilot/n1_press")

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","laminar/B738/autopilot/mcp_speed_dial_kts_mach",0,
	"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up",100,340,false)

-- KTS/MACH C/O
sysMCP.machSwitch 			= TwoStateToggleSwitch:new("mach","laminar/B738/autopilot/change_over_pos",0,
	"laminar/B738/autopilot/change_over_press")

-- SPD INTV
sysMCP.spdIntvSwitch 		= TwoStateToggleSwitch:new("spdintv","laminar/B738/autopilot/spd_interv_pos",0,
	"laminar/B738/autopilot/spd_interv")

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav",drefVNAVLight,0,
	"laminar/B738/autopilot/vnav_press")

-- LVL CHG
sysMCP.lvlchgSwitch 		= TwoStateToggleSwitch:new("lvlchg",drefLVLCHGLight,0,
	"laminar/B738/autopilot/lvl_chg_press")

-- HDG
sysMCP.hdgSelector 			= TwoStateCustomSwitch:new("hdg","laminar/B738/autopilot/mcp_hdg_dial",0,
	function () 
		local lalt = get("laminar/B738/autopilot/mcp_hdg_dial")
		set("laminar/B738/autopilot/mcp_hdg_dial",lalt+1)
		-- command_once("laminar/B738/autopilot/heading_up")
	end,
	function () 
		local lalt = get("laminar/B738/autopilot/mcp_hdg_dial")
		set("laminar/B738/autopilot/mcp_hdg_dial",lalt-1)
		-- command_once("laminar/B738/autopilot/heading_dn")
	end,
	function () 
		return
	end
)

-- TURNRATE
sysMCP.turnRateSelector 	= MultiStateCmdSwitch:new("turnrate","laminar/B738/autopilot/bank_angle_pos",0,
	"laminar/B738/autopilot/bank_angle_dn","laminar/B738/autopilot/bank_angle_up",0,4,false)

-- LNAV
sysMCP.lnavSwitch 			= TwoStateToggleSwitch:new("lnav",drefLNAVLight,0,
	"laminar/B738/autopilot/lnav_press")

-- ALT
sysMCP.altSelector 			= TwoStateCustomSwitch:new("alt","laminar/B738/autopilot/mcp_alt_dial",0,
	function () 
		local lalt = get("laminar/B738/autopilot/mcp_alt_dial")
		set("laminar/B738/autopilot/mcp_alt_dial",lalt+50)
	end,
	function () 
		local lalt = get("laminar/B738/autopilot/mcp_alt_dial")
		set("laminar/B738/autopilot/mcp_alt_dial",lalt-50)
	end,
	function () 
		return
	end,
	function () 
		return get("laminar/B738/autopilot/mcp_alt_dial")
	end
)
-- ALT INTV
sysMCP.altintvSwitch 		= TwoStateToggleSwitch:new("altintv","laminar/B738/autopilot/alt_interv_pos",0,
	"laminar/B738/autopilot/alt_interv")

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","laminar/B738/autopilot/ap_vvi_pos",0,
	"sim/autopilot/vertical_speed_down","sim/autopilot/vertical_speed_up",-7900,7900,true)

-- CWS Boeing only
sysMCP.cwsaSwitch 			= TwoStateToggleSwitch:new("cwsa","laminar/B738/autopilot/cws_a_status",0,
	"laminar/B738/autopilot/cws_a_press")
sysMCP.cwsbSwitch 			= TwoStateToggleSwitch:new("cwsb","laminar/B738/autopilot/cws_b_status",0,
	"laminar/B738/autopilot/cws_b_press")

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateToggleSwitch:new("apdisc","laminar/B738/autopilot/disconnect_pos",0,
	"laminar/B738/autopilot/disconnect_toggle")
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("apdisc","laminar/B738/autopilot/disconnect_pos",0,
	"laminar/B738/autopilot/disconnect_toggle")

-- NAVIGATION SWITCHES
sysMCP.vhfNavSwitch 		= MultiStateCmdSwitch:new("vhfnav","laminar/B738/toggle_switch/vhf_nav_source",0,
	"laminar/B738/toggle_switch/vhf_nav_source_lft","laminar/B738/toggle_switch/vhf_nav_source_rgt",-1,1,true)
sysMCP.irsNavSwitch 		= MultiStateCmdSwitch:new("irsnav","laminar/B738/toggle_switch/irs_source",0,
	"laminar/B738/toggle_switch/irs_source_left","laminar/B738/toggle_switch/irs_source_right",-1,1,true)
sysMCP.fmcNavSwitch 		= MultiStateCmdSwitch:new("fmcnav","laminar/B738/toggle_switch/fmc_source",0,
	"laminar/B738/toggle_switch/fmc_source_left","laminar/B738/toggle_switch/fmc_source_right",-1,1,true)
sysMCP.displaySourceSwitch 	= MultiStateCmdSwitch:new("dispsrc","laminar/B738/toggle_switch/dspl_source",0,
	"laminar/B738/toggle_switch/dspl_source_left","laminar/B738/toggle_switch/dspl_source_right",-1,1,false)
sysMCP.displayControlSwitch = MultiStateCmdSwitch:new("dispctrl","laminar/B738/toggle_switch/dspl_ctrl_pnl",0,
	"laminar/B738/toggle_switch/dspl_ctrl_pnl_left","laminar/B738/toggle_switch/dspl_ctrl_pnl_right",-1,1,true)

---------- Annunciators

-- Flight Directors annunciator
sysMCP.fdirAnc 				= CustomAnnunciator:new("fdiranc",
function ()
	if get("laminar/B738/autopilot/flight_director_pos") > 0 or get("laminar/B738/autopilot/flight_director_fo_pos") > 0 then
		return 1
	else
		return 0
	end
end)

-- HDG Select/mode annunciator
sysMCP.hdgAnc 				= SimpleAnnunciator:new("hdganc","laminar/B738/autopilot/hdg_sel_status",0)

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
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc","laminar/B738/autopilot/app_status",0)

-- SPD mode annunciator
sysMCP.spdAnc 				= CustomAnnunciator:new("spdanc",
function () 
	if get(drefSPDLight) > 0 or get(drefN1Light) > 0 then
		return 1
	else
		return 0
	end
end)

-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () 
	if get(drefVSLight) > 0 or get(drefLVLCHGLight) > 0 or get(drefVNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ALT mode annunciator
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc","laminar/B738/autopilot/alt_hld_status",0)

-- A/P mode annunciator
sysMCP.apAnc 				= CustomAnnunciator:new("autopilotanc",
function () 
if get(drefAPStatusLight) > 0 or get(drefCMDBLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- BC mode annunciator
sysMCP.bcAnc 				= InopSwitch:new("bc")
	
-- ===== UI related functions =====

-- render the MCP part
function sysMCP:render(ypos, height)

	-- reposition when screen size changes
	if kh_mcp_wnd_state < 0 then
		float_wnd_set_position(kh_mcp_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 25, ypos - height)
		kh_mcp_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_mcp_wnd_state == 1 then
		imgui.Button("<", 17, 25)
		if imgui.IsItemActive() then 
			kh_mcp_wnd_state = 0
			float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 25, ypos - height)
		end
	end

	if kh_mcp_wnd_state == 0 then
		imgui.Button("M", 17, 25)
		if imgui.IsItemActive() then 
			kh_mcp_wnd_state = 1
			float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 1005, ypos - height)
		end
	end

	sysMCP.crs1Selector:setDefaultDelay(1)
	sysMCP.iasSelector:setDefaultDelay(1)
	sysMCP.hdgSelector:setDefaultDelay(1)
	sysMCP.altSelector:setDefaultDelay(2)
	sysMCP.vspSelector:setDefaultDelay(4)
	
	kc_imgui_rotary_mcp("CRS:%03d",sysMCP.crs1Selector,10,11)
	kc_imgui_toggle_button_mcp("FD",sysMCP.fdirPilotSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("AT",sysMCP.athrSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("N1",sysMCP.n1Switch,10,22,25)
	kc_imgui_toggle_button_mcp("SP",sysMCP.speedSwitch,10,22,25)
	kc_imgui_rotary_mcp("SPD:%03d",sysMCP.iasSelector,10,12)
	kc_imgui_toggle_button_mcp("VN",sysMCP.vnavSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("LC",sysMCP.lvlchgSwitch,10,22,25)
	kc_imgui_rotary_mcp("HDG:%03d",sysMCP.hdgSelector,10,13)
	kc_imgui_toggle_button_mcp("HD",sysMCP.hdgselSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("LN",sysMCP.lnavSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("LO",sysMCP.vorlocSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("AP",sysMCP.approachSwitch,10,22,25)
	kc_imgui_rotary_mcp("ALT:%05d",sysMCP.altSelector,10,14)
	kc_imgui_toggle_button_mcp("AL",sysMCP.altholdSwitch,10,22,25)
	kc_imgui_rotary_mcp((sysMCP.vspSelector:getStatus() >= 0) and "VSP:+%04d" or "VSP:%05d",sysMCP.vspSelector,10,15)
	kc_imgui_toggle_button_mcp("VS",sysMCP.vsSwitch,10,22,25)
	kc_imgui_toggle_button_mcp("CMDA",sysMCP.ap1Switch,10,59,25)

end

return sysMCP
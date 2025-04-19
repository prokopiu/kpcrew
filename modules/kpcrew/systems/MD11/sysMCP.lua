-- Rotate MD-11
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
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

--------- Switches

-- Flight Directors
sysMCP.fdirPilotSwitch 		= InopSwitch:new("")
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)

-- HDG SEL
sysMCP.hdgselSwitch 		= TwoStateCustomSwitch:new("hdgsel","Rotate/aircraft/controls/fgs_hdg_mode_sel",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_hdg_mode_sel_dn") 
		set("Rotate/aircraft/controls/fgs_hdg_mode_sel",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_hdg_mode_sel_dn") 
		set("Rotate/aircraft/controls/fgs_hdg_mode_sel",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_hdg_mode_sel_dn") 
		set("Rotate/aircraft/controls/fgs_hdg_mode_sel",-1)
	end
)

-- VORLOC
sysMCP.vorlocSwitch 		= TwoStateCustomSwitch:new("vorloc","Rotate/aircraft/controls/fgs_nav",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_nav") 
		set("Rotate/aircraft/controls/fgs_nav",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_nav") 
		set("Rotate/aircraft/controls/fgs_nav",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_nav") 
		set("Rotate/aircraft/controls/fgs_nav",1)
	end
)

-- APPROACH
sysMCP.approachSwitch 		= TwoStateCustomSwitch:new("appr","Rotate/aircraft/systems/afs_appr_engaged",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_appr_land") 
		set("Rotate/aircraft/controls/fgs_appr_land",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_appr_land") 
		set("Rotate/aircraft/controls/fgs_appr_land",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_appr_land") 
		set("Rotate/aircraft/controls/fgs_appr_land",1)
	end
)

-- ALTHOLD
sysMCP.altholdSwitch 		= TwoStateCustomSwitch:new("appr","Rotate/aircraft/systems/afs_pitch_mode",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_alt_mode_sel_dn") 
		set("Rotate/aircraft/controls/fgs_alt_mode_sel",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_alt_mode_sel_dn") 
		set("Rotate/aircraft/controls/fgs_alt_mode_sel",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_alt_mode_sel_dn") 
		set("Rotate/aircraft/controls/fgs_alt_mode_sel",-1)
	end
)

-- VS
sysMCP.vsSwitch 			= InopSwitch:new("vs")

-- SPEED
sysMCP.speedSwitch 			= TwoStateCustomSwitch:new("speed","Rotate/aircraft/systems/afs_at_engaged",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_spd_sel_mode_dn") 
		set("Rotate/aircraft/controls/fgs_spd_sel_mode",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_spd_sel_mode_dn") 
		set("Rotate/aircraft/controls/fgs_spd_sel_mode",-1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_spd_sel_mode_dn") 
		set("Rotate/aircraft/controls/fgs_spd_sel_mode",-1)
	end
)

-- AUTOPILOT
sysMCP.ap1Switch 			= TwoStateCustomSwitch:new("autoflight","Rotate/aircraft/controls/fgs_autoflight",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_autoflight") 
		set("Rotate/aircraft/controls/fgs_autoflight",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_autoflight") 
		set("Rotate/aircraft/controls/fgs_autoflight",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_autoflight") 
		set("Rotate/aircraft/controls/fgs_autoflight",1)
	end
)

-- BACKCOURSE
sysMCP.backcourse 			= InopSwitch:new("backcourse")

-- TOGA
sysMCP.togaPilotSwitch 		= InopSwitch:new("togapilot")

-- ATHR
sysMCP.athrSwitch 			= InopSwitch:new("athr")


-- CRS 1&2

sysMCP.crs1Selector 		= InopSwitch:new("crs1")
sysMCP.crs2Selector 		= InopSwitch:new("crs2")
sysMCP.crsSelectorGroup 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1 Boeing
sysMCP.n1Switch 			= TwoStateCustomSwitch:new("FMS SPD","Rotate/aircraft/systems/afs_fms_spd_engaged",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_fms_spd") 
		set("Rotate/aircraft/controls/fgs_fms_spd",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_fms_spd") 
		set("Rotate/aircraft/controls/fgs_fms_spd",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_fms_spd") 
		set("Rotate/aircraft/controls/fgs_fms_spd",1)
	end
)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","Rotate/aircraft/systems/gcp_spd_presel_ias",0,"Rotate/aircraft/controls_c/fgs_spd_sel_dn","Rotate/aircraft/controls_c/fgs_spd_sel_up")

-- KTS/MACH C/O
sysMCP.machSwitch 			= InopSwitch:new("mach")

-- SPD INTV
sysMCP.spdIntvSwitch 		= InopSwitch:new("spdintv")

-- VNAV
sysMCP.vnavSwitch 			= TwoStateCustomSwitch:new("PROFILE","Rotate/aircraft/systems/afs_prof_engaged",0,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_prof") 
		set("Rotate/aircraft/controls/fgs_prof",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_prof") 
		set("Rotate/aircraft/controls/fgs_prof",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/fgs_prof") 
		set("Rotate/aircraft/controls/fgs_prof",1)
	end
)

-- LVL CHG
sysMCP.lvlchgSwitch 		= InopSwitch:new("lvlchg")

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","Rotate/aircraft/systems/gcp_hdg_presel_deg",0,
	"Rotate/aircraft/controls_c/fgs_hdg_sel_dn","Rotate/aircraft/controls_c/fgs_hdg_sel_up")

-- TURNRATE
sysMCP.turnRateSelector 	= InopSwitch:new("turnrate")

-- LNAV
sysMCP.lnavSwitch 			= InopSwitch:new("lnav")

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","Rotate/aircraft/systems/gcp_alt_presel_ft",0,
	"Rotate/aircraft/controls_c/fgs_alt_sel_dn","Rotate/aircraft/controls_c/fgs_alt_sel_up")

-- ALT INTV
sysMCP.altintvSwitch 		= InopSwitch:new("altintv")

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","Rotate/aircraft/systems/gcp_vs_sel_fpm",0,
	"Rotate/aircraft/controls_c/fgs_pitch_sel_up","Rotate/aircraft/controls_c/fgs_pitch_sel_dn")

-- CWS Boeing only
sysMCP.cwsaSwitch 			= InopSwitch:new("cwsa")
sysMCP.cwsbSwitch 			= InopSwitch:new("cwsb")

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateCustomSwitch:new("apdisc","Rotate/aircraft/systems/afs_ap_engaged",0,
	function () 
		command_once("Rotate/aircraft/controls_c/ap_disc_l") 
		set("Rotate/aircraft/controls/ap_disc_l",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/ap_disc_l") 
		set("Rotate/aircraft/controls/ap_disc_l",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/ap_disc_l") 
		set("Rotate/aircraft/controls/ap_disc_l",1)
	end
)

sysMCP.apDiscYoke 			= TwoStateCustomSwitch:new("apdisc","Rotate/aircraft/controls/ap_disc_l",0,
	function () 
		command_once("Rotate/aircraft/controls_c/ap_disc_l") 
		set("Rotate/aircraft/controls/ap_disc_l",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/ap_disc_l") 
		set("Rotate/aircraft/controls/ap_disc_l",1)
	end,
	function () 
		command_once("Rotate/aircraft/controls_c/ap_disc_l") 
		set("Rotate/aircraft/controls/ap_disc_l",1)
	end
)

-- NAVIGATION SWITCHES
sysMCP.vhfNavSwitch 		= InopSwitch:new("vhfnav")
sysMCP.irsNavSwitch 		= InopSwitch:new("irsnav")
sysMCP.fmcNavSwitch 		= InopSwitch:new("fmcnav")
sysMCP.displaySourceSwitch 	= InopSwitch:new("dispsrc")
sysMCP.displayControlSwitch = InopSwitch:new("dispctrl")

------- Annunciators

-- Flight Directors annunciator
sysMCP.fdirAnc 				= InopSwitch:new("fdiranc")

-- HDG Select/mode annunciator
sysMCP.hdgAnc 				= CustomAnnunciator:new("hdganc",
function () 
	if get("Rotate/aircraft/systems/afs_roll_mode") > 0 then
		return 1
	else
		return 0
	end
end)

-- NAV mode annunciator
sysMCP.navAnc 				= CustomAnnunciator:new("navanc",
function () 
	if get("Rotate/aircraft/systems/afs_roll_mode") == 1 then
		return 1
	else
		return 0
	end
end
)

-- APR Select/mode annunciator
sysMCP.aprAnc 				= CustomAnnunciator:new("apranc",
function () 
	if get("Rotate/aircraft/systems/afs_appr_engaged") == 1 or get("Rotate/aircraft/systems/afs_land_engaged") == 1 or get("Rotate/aircraft/systems/afs_single_land_engaged") == 1 or get("Rotate/aircraft/systems/afs_dual_land_engaged") == 1 then
		return 1
	else
		return 0
	end
end)

-- SPD mode annunciator
sysMCP.spdAnc 				= CustomAnnunciator:new("spdanc",
function () 
	if get("Rotate/aircraft/systems/afs_fms_spd_engaged") == 1 or get("Rotate/aircraft/systems/afs_at_engaged") == 1 then
		return 1
	else
		return 0
	end
end)

-- Vertical mode annunciator
sysMCP.vspAnc 				= CustomAnnunciator:new("vspanc",
function () 
	if get("Rotate/aircraft/systems/afs_pitch_mode") == 4 then
		return 1
	else
		return 0
	end
end)

-- ALT mode annunciator
sysMCP.altAnc 				= CustomAnnunciator:new("altanc",
function () 
	if get("Rotate/aircraft/systems/afs_pitch_mode") == 5 then
		return 1
	else
		return 0
	end
end)

-- A/P mode annunciator
sysMCP.apAnc 				= CustomAnnunciator:new("apanc",
function () 
	if get("Rotate/aircraft/systems/afs_ap_engaged") == 1 then
		return 1
	else
		return 0
	end
end)

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
			float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 1005, ypos-height)
		end
	end

	sysMCP.iasSelector:setDefaultDelay(4)
	sysMCP.hdgSelector:setDefaultDelay(4)
	sysMCP.altSelector:setDefaultDelay(4)
	sysMCP.vspSelector:setDefaultDelay(4)

	kc_imgui_toggle_button_mcp("IAS",sysMCP.speedSwitch,10,28,25)
	kc_imgui_rotary_mcp("SPD:%03d",sysMCP.iasSelector,10,12)
	kc_imgui_toggle_button_mcp("FMS",sysMCP.n1Switch,10,28,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("PRF",sysMCP.vnavSwitch,10,28,25)
	kc_imgui_toggle_button_mcp("HDG",sysMCP.hdgselSwitch,10,28,25)
	kc_imgui_rotary_mcp("HDG:%03d",sysMCP.hdgSelector,10,13)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("NAV",sysMCP.vorlocSwitch,10,28,25)
	kc_imgui_toggle_button_mcp("APPR/LAND",sysMCP.approachSwitch,10,75,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("AL",sysMCP.altholdSwitch,10,22,25)
	kc_imgui_rotary_mcp("ALT:%05d",sysMCP.altSelector,10,14)
	kc_imgui_rotary_mcp((sysMCP.vspSelector:getStatus() >= 0) and "VSP:+%04d" or "VSP:%05d",sysMCP.vspSelector,10,15)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("AUTO FLIGHT",sysMCP.ap1Switch,10,85,25)
	kc_imgui_toggle_button_mcp(" A/P DISCO ",sysMCP.apDiscYoke,10,85,25)

end

return sysMCP
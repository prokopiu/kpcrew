-- FJS B732 airplane 
-- MCP functionality

local sysMCP = {
	fltdir_GA = -1,
	fltdir_OFF = 0,
	fltdir_HDG = 1,
	fltdir_VORLOC = 2,
	fltdir_AUTOAPP = 3,
	fltdir_MANAPP = 4,
	hdgmode_OFF = 0,
	hdgmode_ON = 1,
	hdgmode_SEL = 2
}

local fltmods = {[-1]="GA",[0]="OFF",[1]="HDG",[2]="VOR",[3]="APP",[4]="GS"}
local apmods = {[0]="MAN",[1]="VOR",[2]="APP",[3]="GS"}
local hdgmods = {[0]="OFF",[1]="ON",[2]="SEL"}
local pitchmods = {[-1]="IAS",[0]="OFF",[1]="ALT"}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

--------- Switches

-- Flight Directors
sysMCP.fdirPilotSwitch = InopSwitch:new("fdirpilot")
sysMCP.fdirCoPilotSwitch = InopSwitch:new("fdircopilot")

sysMCP.fdirGroup = SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

-- HDG SEL
sysMCP.hdgselSwitch = TwoStateCustomSwitch:new("hdgsel","FJS/732/Autopilot/APHeadingSwitch",0,
function ()
	sysMCP.hdgmodeSelector:setValue(2)
end,
function () 
	sysMCP.hdgmodeSelector:setValue(0)
end,
function ()
	if sysMCP.hdgmodeSelector:getStatus() == 0 then
		sysMCP.hdgmodeSelector:setValue(2)
	else
		sysMCP.hdgmodeSelector:setValue(0)
	end
end)

-- VORLOC
sysMCP.vorlocSwitch = InopSwitch:new("vorloc")

-- ALTHOLD
sysMCP.altholdSwitch = TwoStateDrefSwitch:new("althold","FJS/732/Autopilot/FDAltHoldSwitch",0)

-- APPROACH
sysMCP.approachSwitch = InopSwitch:new("approach")

-- VS MODE
sysMCP.vsSwitch = InopSwitch:new("vs")

-- SPEED
sysMCP.speedSwitch = InopSwitch:new("speed")

-- AUTOPILOT
sysMCP.ap1Switch = InopSwitch:new("autopilot1")
sysMCP.ap2Switch = InopSwitch:new("autopilot2")

-- BACKCOURSE
sysMCP.backcourse = InopSwitch:new("backcourse")

-- TOGA
sysMCP.togaPilotSwitch = InopSwitch:new("togapilot")
sysMCP.togaCopilotSwitch = InopSwitch:new("togacopilot")

-- ATHR
sysMCP.athrSwitch = InopSwitch:new("athr")

-- CRS 1&2

sysMCP.crs1Selector = MultiStateCmdSwitch:new("crs1","sim/cockpit/radios/nav1_obs_degm",0,"sim/radios/obs1_down","sim/radios/obs1_up")
sysMCP.crs2Selector = MultiStateCmdSwitch:new("crs2","sim/cockpit/radios/nav2_obs_degm2",0,"sim/radios/copilot_obs2_down","sim/radios/copilot_obs2_up")

sysMCP.crsSelectorGroup = SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1 Boeing
sysMCP.n1Switch = InopSwitch:new("n1")

-- IAS
sysMCP.iasSelector = MultiStateCmdSwitch:new("ias","sim/cockpit/autopilot/airspeed",0,"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up")

-- KTS/MACH C/O
sysMCP.machSwitch = InopSwitch:new("mach")

-- SPD INTV
sysMCP.spdIntvSwitch = InopSwitch:new("spdintv")

-- VNAV
sysMCP.vnavSwitch = InopSwitch:new("vnav")

-- LVL CHG
sysMCP.lvlchgSwitch = InopSwitch:new("lvlchg")

-- HDG
sysMCP.hdgSelector = MultiStateCmdSwitch:new("hdg","sim/cockpit2/autopilot/heading_dial_deg_mag_pilot",0,"sim/autopilot/heading_down","sim/autopilot/heading_down")

-- TURNRATE
sysMCP.turnRateSelector = InopSwitch:new("turnrate")

-- LNAV
sysMCP.lnavSwitch = InopSwitch:new("lnav")

-- ALT
sysMCP.altSelector = MultiStateCmdSwitch:new("alt","sim/cockpit/autopilot/altitude",0,"sim/autopilot/altitude_down","sim/autopilot/altitude_up")

-- ALT INTV
sysMCP.altintvSwitch = TwoStateToggleSwitch:new("altintv","laminar/B738/autopilot/alt_interv_pos",0,"laminar/B738/autopilot/alt_interv")

-- VSP
sysMCP.vspSelector = TwoStateCustomSwitch:new("vsp","FJS/732/Autopilot/PitchComKnob",0,
function ()
	set("FJS/732/Autopilot/PitchComKnob",get("FJS/732/Autopilot/PitchComKnob")+1)
end,
function ()
	set("FJS/732/Autopilot/PitchComKnob",get("FJS/732/Autopilot/PitchComKnob")-1)
end,
nil)

-- CWS Boeing only
sysMCP.cwsaSwitch = InopSwitch:new("cwsa")
sysMCP.cwsbSwitch = InopSwitch:new("cwsb")

-- A/P DISENGAGE
sysMCP.discAPSwitch = InopSwitch:new("apdisc")
sysMCP.apDiscYoke = InopSwitch:new("discapyoke")

-- NAVIGATION SWITCHES
sysMCP.vhfNavSwitch = InopSwitch:new("vhfnav")
sysMCP.irsNavSwitch = InopSwitch:new("irsnav")
sysMCP.fmcNavSwitch = InopSwitch:new("fmcnav")
sysMCP.displaySourceSwitch = InopSwitch:new("dispsrc")
sysMCP.displayControlSwitch = InopSwitch:new("dispctrl")

sysMCP.fltdirSelector = MultiStateCmdSwitch:new("fltdir","FJS/732/Autopilot/FDModeSelector",0,"FJS/732/Autopilot/FD_SelectLeft","FJS/732/Autopilot/FD_SelectRight")
sysMCP.apmodeSelector = MultiStateCmdSwitch:new("apmodes","FJS/732/Autopilot/APModeSelector",0,"FJS/732/Autopilot/NavSelectLeft","FJS/732/Autopilot/NavSelectRight")
sysMCP.hdgmodeSelector = MultiStateCmdSwitch:new("hdgmod","FJS/732/Autopilot/APHeadingSwitch",0,"FJS/732/Autopilot/AP_HDG_DOWN","FJS/732/Autopilot/AP_HDG_UP")
sysMCP.rollEngage = TwoStateToggleSwitch:new("rollon","FJS/732/Autopilot/APRollEngageSwitch",0,"FJS/732/Autopilot/AP_RollSelect")
sysMCP.pitchEngage = TwoStateToggleSwitch:new("pitchon","FJS/732/Autopilot/APPitchEngageSwitch",0,"FJS/732/Autopilot/AP_PitchSelect")
sysMCP.pitchSelect = MultiStateCmdSwitch:new("pitchselect","FJS/732/Autopilot/APPitchSelector",0,"FJS/732/Autopilot/PitchSelectLeft","FJS/732/Autopilot/PitchSelectRight")

---------- Annunciators

-- Flight Directors annunciator
sysMCP.fdirAnc = CustomAnnunciator:new("fdiranc",
function ()
	-- if get("laminar/B738/autopilot/flight_director_pos") > 0 or get("laminar/B738/autopilot/flight_director_fo_pos") > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- HDG Select/mode annunciator
sysMCP.hdgAnc = InopSwitch:new("hdganc") --,"laminar/B738/autopilot/hdg_sel_status",0)

-- NAV mode annunciator
sysMCP.navAnc = CustomAnnunciator:new("navanc",
function () 
	-- if get(drefVORLocLight) > 0 or get(drefLNAVLight) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- APR Select/mode annunciator
sysMCP.aprAnc = InopSwitch:new("apranc") --,"laminar/B738/autopilot/app_status",0)

-- SPD mode annunciator
sysMCP.spdAnc = CustomAnnunciator:new("spdanc",
function () 
	-- if get(drefSPDLight) > 0 or get(drefN1Light) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- Vertical mode annunciator
sysMCP.vspAnc = CustomAnnunciator:new("vspanc",
function () 
	-- if get(drefVSLight) > 0 or get(drefLVLCHGLight) > 0 or get(drefVNAVLight) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- ALT mode annunciator
sysMCP.altAnc = InopSwitch:new("altanc") --,"laminar/B738/autopilot/alt_hld_status",0)

-- A/P mode annunciator
sysMCP.apAnc = CustomAnnunciator:new("autopilotanc",
function () 
-- if get(drefAPStatusLight) > 0 or get(drefCMDBLight) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- BC mode annunciator
sysMCP.bcAnc = InopSwitch:new("bc")
	
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
			float_wnd_set_geometry(kh_mcp_wnd, 0, ypos, 1120, ypos - height)
		end
	end

	sysMCP.vspSelector:setDefaultDelay(2)

	kc_imgui_label_mcp("FD:",10)
	kc_imgui_selector_mcp("%3s",sysMCP.fltdirSelector,10,fltmods,17)
	kc_imgui_rotary_mcp("CRS1:%03d",sysMCP.crs1Selector,10,11)
	kc_imgui_rotary_mcp("HDG:%03d",sysMCP.hdgSelector,10,13)
	kc_imgui_rotary_mcp("CRS2:%03d",sysMCP.crs2Selector,10,16)
	kc_imgui_toggle_button_mcp("AL",sysMCP.altholdSwitch,10,22,25)
	kc_imgui_rotary_mcp((sysMCP.vspSelector:getStatus() >= 0) and "PITCH:+%02d" or "PITCH:%02d",sysMCP.vspSelector,10,15)
	kc_imgui_label_mcp("| A/P:",10)
	kc_imgui_selector_mcp("%3s",sysMCP.apmodeSelector,10,apmods,18)
	kc_imgui_label_mcp("HDG:",10)
	kc_imgui_selector_mcp("%3s",sysMCP.hdgmodeSelector,10,hdgmods,19)
	kc_imgui_toggle_button_mcp("RL",sysMCP.rollEngage,10,22,25)
	kc_imgui_toggle_button_mcp("PT",sysMCP.pitchEngage,10,22,25)
	kc_imgui_selector_mcp("%3s",sysMCP.pitchSelect,10,pitchmods,20)
	kc_imgui_rotary_mcp("ALT:%05d",sysMCP.altSelector,10,14)


end

return sysMCP
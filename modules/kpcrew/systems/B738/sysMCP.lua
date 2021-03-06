-- B738 airplane 
-- MCP functionality

local sysMCP = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch = require "kpcrew.systems.InopSwitch"

local drefVORLocLight = "laminar/B738/autopilot/vorloc_status"
local drefLNAVLight = "laminar/B738/autopilot/lnav_status"
local drefSPDLight = "laminar/B738/autopilot/speed_mode"
local drefN1Light = "laminar/B738/autopilot/n1_status"
local drefVSLight = "laminar/B738/autopilot/vs_status"
local drefLVLCHGLight = "laminar/B738/autopilot/lvl_chg_status"
local drefVNAVLight = "laminar/B738/autopilot/vnav_status1"
local drefAPStatusLight = "laminar/B738/autopilot/cmd_a_status"
local drefCMDBLight = "laminar/B738/autopilot/cmd_b_status"

--------- Switches

-- Flight Directors
sysMCP.fdirPilotSwitch = TwoStateToggleSwitch:new("fdirpilot","laminar/B738/autopilot/flight_director_pos",0,"laminar/B738/autopilot/flight_director_toggle")
sysMCP.fdirCoPilotSwitch = TwoStateToggleSwitch:new("fdircopilot","laminar/B738/autopilot/flight_director_fo_pos",0,"laminar/B738/autopilot/flight_director_fo_toggle")

sysMCP.fdirGroup = SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)

-- HDG SEL
sysMCP.hdgselSwitch = TwoStateToggleSwitch:new("hdgsel","laminar/B738/autopilot/hdg_sel_status",0,"laminar/B738/autopilot/hdg_sel_press")

-- VORLOC
sysMCP.vorlocSwitch = TwoStateToggleSwitch:new("vorloc","laminar/B738/autopilot/vorloc_status",0,"laminar/B738/autopilot/vorloc_press")

-- ALTHOLD
sysMCP.altholdSwitch = TwoStateToggleSwitch:new("althold","laminar/B738/autopilot/alt_hld_status",0,"laminar/B738/autopilot/alt_hld_press")

-- APPROACH
sysMCP.approachSwitch = TwoStateToggleSwitch:new("approach","laminar/B738/autopilot/app_status",0,"laminar/B738/autopilot/app_press")

-- VS MODE
sysMCP.vsSwitch = TwoStateToggleSwitch:new("vs","laminar/B738/autopilot/vs_status",0,"laminar/B738/autopilot/vs_press")

-- SPEED
sysMCP.speedSwitch = TwoStateToggleSwitch:new("speed","laminar/B738/autopilot/speed_status1",0,"laminar/B738/autopilot/speed_press")

-- AUTOPILOT
sysMCP.ap1Switch = TwoStateToggleSwitch:new("autopilot1","laminar/B738/autopilot/cmd_a_status",0,"laminar/B738/autopilot/cmd_a_press")
sysMCP.ap2Switch = TwoStateToggleSwitch:new("autopilot2","laminar/B738/autopilot/cmd_b_status",0,"laminar/B738/autopilot/cmd_b_press")

-- BACKCOURSE
sysMCP.backcourse = InopSwitch:new("backcourse")

-- TOGA
sysMCP.togaPilotSwitch = TwoStateToggleSwitch:new("togapilot","laminar/B738/autopilot/ap_takeoff",0,"laminar/B738/autopilot/left_toga_press")
sysMCP.togaCopilotSwitch = TwoStateToggleSwitch:new("togacopilot","laminar/B738/autopilot/ap_takeoff",0,"laminar/B738/autopilot/right_toga_press")

-- ATHR
sysMCP.athrSwitch = TwoStateToggleSwitch:new("athr","laminar/B738/autopilot/autothrottle_status1",0,"laminar/B738/autopilot/autothrottle_arm_toggle")

-- CRS 1&2

sysMCP.crs1Selector = MultiStateCmdSwitch:new("crs1","laminar/B738/autopilot/course_pilot",0,"laminar/B738/autopilot/course_pilot_dn","laminar/B738/autopilot/course_pilot_up")
sysMCP.crs2Selector = MultiStateCmdSwitch:new("crs2","laminar/B738/autopilot/course_copilot",0,"laminar/B738/autopilot/course_copilot_dn","laminar/B738/autopilot/course_copilot_up")

sysMCP.crsSelectorGroup = SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- N1 Boeing
sysMCP.n1Switch = TwoStateToggleSwitch:new("n1","laminar/B738/autopilot/n1_pos",0,"laminar/B738/autopilot/n1_press")

-- IAS
sysMCP.iasSelector = MultiStateCmdSwitch:new("ias","sim/cockpit/autopilot/airspeed",0,"sim/autopilot/airspeed_down","sim/autopilot/airspeed_up")

-- KTS/MACH C/O
sysMCP.machSwitch = TwoStateToggleSwitch:new("mach","laminar/B738/autopilot/change_over_pos",0,"laminar/B738/autopilot/change_over_press")

-- SPD INTV
sysMCP.spdIntvSwitch = TwoStateToggleSwitch:new("spdintv","laminar/B738/autopilot/spd_interv_pos",0,"laminar/B738/autopilot/spd_interv")

-- VNAV
sysMCP.vnavSwitch = TwoStateToggleSwitch:new("vnav",drefVNAVLight,0,"laminar/B738/autopilot/vnav_press")

-- LVL CHG
sysMCP.lvlchgSwitch = TwoStateToggleSwitch:new("lvlchg",drefLVLCHGLight,0,"laminar/B738/autopilot/lvl_chg_press")

-- HDG
sysMCP.hdgSelector = MultiStateCmdSwitch:new("hdg","laminar/B738/autopilot/mcp_hdg_dial",0,"laminar/B738/autopilot/heading_dn","laminar/B738/autopilot/heading_up")

-- TURNRATE
sysMCP.turnRateSelector = MultiStateCmdSwitch:new("turnrate","laminar/B738/autopilot/bank_angle_pos",0,"laminar/B738/autopilot/bank_angle_dn","laminar/B738/autopilot/bank_angle_up")

-- LNAV
sysMCP.lnavSwitch = TwoStateToggleSwitch:new("lnav",drefLNAVLight,0,"laminar/B738/autopilot/lnav_press")

-- ALT
sysMCP.altSelector = MultiStateCmdSwitch:new("alt","laminar/B738/autopilot/mcp_alt_dial",0,"laminar/B738/autopilot/altitude_dn","laminar/B738/autopilot/altitude_up")

-- ALT INTV
sysMCP.altintvSwitch = TwoStateToggleSwitch:new("altintv","laminar/B738/autopilot/alt_interv_pos",0,"laminar/B738/autopilot/alt_interv")

-- VSP
sysMCP.vspSelector = MultiStateCmdSwitch:new("vsp","laminar/B738/autopilot/ap_vvi_pos",0,"sim/autopilot/vertical_speed_down","sim/autopilot/vertical_speed_up")

-- CWS Boeing only
sysMCP.cwsaSwitch = TwoStateToggleSwitch:new("cwsa","laminar/B738/autopilot/cws_a_status",0,"laminar/B738/autopilot/cws_a_press")
sysMCP.cwsbSwitch = TwoStateToggleSwitch:new("cwsb","laminar/B738/autopilot/cws_b_status",0,"laminar/B738/autopilot/cws_b_press")

-- A/P DISENGAGE
sysMCP.discAPSwitch = TwoStateToggleSwitch:new("apdisc","laminar/B738/autopilot/disconnect_pos",0,"laminar/B738/autopilot/disconnect_toggle")
sysMCP.apDiscYoke = TwoStateToggleSwitch:new("discapyoke","laminar/B738/autopilot/disconnect_pos",0,"laminar/B738/autopilot/capt_disco_press")

---------- Annunciators

-- Flight Directors annunciator
sysMCP.fdirAnc = CustomAnnunciator:new("fdiranc",
function ()
	if get("laminar/B738/autopilot/flight_director_pos") > 0 or get("laminar/B738/autopilot/flight_director_fo_pos") > 0 then
		return 1
	else
		return 0
	end
end)

-- HDG Select/mode annunciator
sysMCP.hdgAnc = SimpleAnnunciator:new("hdganc","laminar/B738/autopilot/hdg_sel_status",0)

-- NAV mode annunciator
sysMCP.navAnc = CustomAnnunciator:new("navanc",
function () 
	if get(drefVORLocLight) > 0 or get(drefLNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- APR Select/mode annunciator
sysMCP.aprAnc = SimpleAnnunciator:new("apranc","laminar/B738/autopilot/app_status",0)

-- SPD mode annunciator
sysMCP.spdAnc = CustomAnnunciator:new("spdanc",
function () 
	if get(drefSPDLight) > 0 or get(drefN1Light) > 0 then
		return 1
	else
		return 0
	end
end)

-- Vertical mode annunciator
sysMCP.vspAnc = CustomAnnunciator:new("vspanc",
function () 
	if get(drefVSLight) > 0 or get(drefLVLCHGLight) > 0 or get(drefVNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ALT mode annunciator
sysMCP.altAnc = SimpleAnnunciator:new("altanc","laminar/B738/autopilot/alt_hld_status",0)

-- A/P mode annunciator
sysMCP.apAnc = CustomAnnunciator:new("autopilotanc",
function () 
if get(drefAPStatusLight) > 0 or get(drefCMDBLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- BC mode annunciator
sysMCP.bcAnc = InopSwitch:new("bc")
	
-- 
return sysMCP
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

-- VS
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
	
return sysMCP
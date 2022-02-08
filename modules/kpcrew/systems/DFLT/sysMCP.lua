-- DFLT airplane 
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

local drefVORLocLight = "sim/cockpit2/autopilot/nav_status"
local drefLNAVLight = "sim/cockpit2/radios/actuators/HSI_source_select_pilot"
local drefSPDLight = "sim/cockpit2/autopilot/autothrottle_on"
local drefVSLight = "sim/cockpit2/autopilot/vvi_status"
local drefVNAVLight = "sim/cockpit2/autopilot/fms_vnav"

--------- Switches

-- Flight Directors
sysMCP.fdirPilotSwitch = TwoStateToggleSwitch:new("fdir","sim/cockpit2/annunciators/flight_director",0,"sim/autopilot/fdir_toggle")

sysMCP.fdirGroup = SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)

-- HDG SEL
sysMCP.hdgselSwitch = TwoStateToggleSwitch:new("hdgsel","sim/cockpit/autopilot/heading_mode",0,"sim/autopilot/heading")

-- VORLOC
sysMCP.vorlocSwitch = TwoStateToggleSwitch:new("vorloc",drefVORLocLight,0,"sim/autopilot/NAV")

-- ALTHOLD
sysMCP.altholdSwitch = TwoStateToggleSwitch:new("althold","sim/cockpit2/autopilot/altitude_hold_status",0,"sim/autopilot/altitude_hold")

-- APPROACH
sysMCP.approachSwitch = TwoStateToggleSwitch:new("approach","sim/cockpit2/autopilot/approach_status",0,"sim/autopilot/approach")

-- VS
sysMCP.vsSwitch = TwoStateToggleSwitch:new("vs",drefVSLight,0,"sim/autopilot/vertical_speed")

-- SPEED
sysMCP.speedSwitch = TwoStateToggleSwitch:new("speed",drefSPDLight,0,"sim/autopilot/autothrottle_toggle")

-- AUTOPILOT
sysMCP.ap1Switch = TwoStateToggleSwitch:new("autopilot1","sim/cockpit/autopilot/autopilot_mode",0,"sim/autopilot/servos_toggle")

-- BACKCOURSE
sysMCP.backcourse = InopSwitch:new("backcourse")

-- TOGA
sysMCP.togaPilotSwitch = TwoStateToggleSwitch:new("togapilot","sim/cockpit2/autopilot/TOGA_status",0,"sim/autopilot/take_off_go_around")

-- ATHR
sysMCP.athrSwitch = TwoStateToggleSwitch:new("athr","sim/cockpit2/autopilot/autothrottle_enabled",0,"sim/autopilot/autothrottle_toggle")

-- Flight Directors annunciator
sysMCP.fdirAnc = SimpleAnnunciator:new("fdiranc","sim/cockpit2/annunciators/flight_director",0)

-- HDG Select/mode annunciator
sysMCP.hdgAnc = SimpleAnnunciator:new("hdganc","sim/cockpit2/autopilot/heading_mode",0)

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
sysMCP.aprAnc = SimpleAnnunciator:new("apranc","sim/cockpit2/autopilot/approach_status",0)

-- SPD mode annunciator
sysMCP.spdAnc = SimpleAnnunciator:new("spdanc","sim/cockpit2/autopilot/autothrottle_on",0)

-- Vertical mode annunciator
sysMCP.vspAnc = CustomAnnunciator:new("vspanc",
function () 
	if get(drefVSLight) > 0 or get(drefVNAVLight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ALT mode annunciator
sysMCP.altAnc = SimpleAnnunciator:new("altanc","sim/cockpit2/autopilot/altitude_hold_status",0)

-- A/P mode annunciator
sysMCP.apAnc = SimpleAnnunciator:new("autopilotanc","sim/cockpit2/autopilot/autopilot_on_or_cws",0)

-- BC mode annunciator
sysMCP.bcAnc = InopSwitch:new("bc")

return sysMCP
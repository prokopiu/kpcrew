-- B7x7 B757 B767 airplane 
-- MCP functionality

-- @classmod sysMCP
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

logMsg("B7x7 sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateCustomSwitch:new("fdir left","1-sim/AP/fd1Switcher/anim",0,
function ()
	if get("1-sim/AP/fd1Switcher/anim") == 1 then
		command_once("1-sim/command/AP/fd1Switcher_trigger")
	end
end,
function ()
	if get("1-sim/AP/fd1Switcher/anim") == 0 then
		command_once("1-sim/command/AP/fd1Switcher_trigger")
	end
end,
function ()
	command_once("1-sim/command/AP/fd1Switcher_trigger")
end,
function () 
	return 1-get("1-sim/AP/fd1Switcher/anim")
end)
sysMCP.fdirCoPilotSwitch 	= TwoStateCustomSwitch:new("fdir right","1-sim/AP/fd2Switcher/anim",0,
function ()
	if get("1-sim/AP/fd2Switcher/anim") == 1 then
		command_once("1-sim/command/AP/fd2Switcher_trigger")
	end
end,
function ()
	if get("1-sim/AP/fd2Switcher/anim") == 0 then
		command_once("1-sim/command/AP/fd2Switcher_trigger")
	end
end,
function ()
	command_once("1-sim/command/AP/fd2Switcher_trigger")
end,
function () 
	return 1-get("1-sim/AP/fd2Switcher/anim")
end)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","1-sim/AP/fd1Switcher/anim",0)

-- **AUTOPILOT
sysMCP.ap1Switch 			= TwoStateCustomSwitch:new("autopilot1","1-sim/AP/cmd_L_Button",0,
function ()
	if get("1-sim/AP/cmd_L_Button") == 0 then
		command_once("1-sim/comm/AP/CMD_L")
	end
end,
function ()
	if get("1-sim/AP/cmd_L_Button") == 1 then
		command_once("1-sim/comm/AP/CMD_L")
	end
end,
function ()
	command_once("1-sim/comm/AP/CMD_L")
end,
function () 
	return get("1-sim/AP/lamp/12")
end)
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc","1-sim/AP/lamp/12",0)

-- **ALTHOLD
sysMCP.altholdSwitch 		= TwoStateCustomSwitch:new("althold","1-sim/AP/altHoldButton",0,
function ()
	if get("1-sim/AP/altHoldButton") == 0 then
		command_once("1-sim/comm/AP/altHoldButton")
	end
end,
function ()
	if get("1-sim/AP/altHoldButton") == 1 then
		command_once("1-sim/comm/AP/altHoldButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/altHoldButton")
end,
function () 
	return get("1-sim/AP/lamp/8")
end)
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc","1-sim/AP/lamp/8",0)

-- **HDG SELECT mode
sysMCP.hdgselSwitch 		= TwoStateCustomSwitch:new("hdgsel","1-sim/AP/hdgConfButton",0,
function ()
	if get("1-sim/AP/hdgConfButton") == 1 then
		command_once("1-sim/comm/AP/multiHdg")
		command_once("1-sim/comm/AP/multiSelect")
	end
end,
function ()
	if get("1-sim/AP/hdgConfButton") == 0 then
		command_once("1-sim/comm/AP/multiHdg")
		command_once("1-sim/comm/AP/multiSelect")
	end
end,
function ()
		command_once("1-sim/comm/AP/multiHdg")
		command_once("1-sim/comm/AP/multiSelect")
end,
function () 
	return 1-get("1-sim/AP/hdgConfButton")
end)
sysMCP.hdgAnc 				= SimpleAnnunciator:new("hdganc","1-sim/AP/lamp/6",0)

-- HDGHOLD
sysMCP.hdgholdSwitch 		= TwoStateCustomSwitch:new("hdghold","1-sim/AP/hdgHoldButton",0,
function ()
	if get("1-sim/AP/hdgHoldButton") == 0 then
		command_once("1-sim/comm/AP/hdgHoldButton")
	end
end,
function ()
	if get("1-sim/AP/hdgHoldButton") == 1 then
		command_once("1-sim/comm/AP/hdgHoldButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/hdgHoldButton")
end,
function () 
	return get("1-sim/AP/lamp/6")
end)

-- **VORLOC
sysMCP.vorlocSwitch			= TwoStateCustomSwitch:new("vorloc","1-sim/AP/locButton",0,
function ()
	if get("1-sim/AP/locButton") == 0 then
		command_once("1-sim/comm/AP/locButton")
	end
end,
function ()
	if get("1-sim/AP/locButton") == 1 then
		command_once("1-sim/comm/AP/locButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/locButton")
end,
function () 
	return get("1-sim/AP/lamp/10")
end)

-- **SPEED Mode
sysMCP.speedSwitch 			= TwoStateCustomSwitch:new("speed","1-sim/AP/spdButton",0,
function ()
	if get("1-sim/AP/spdButton") == 0 then
		command_once("1-sim/comm/AP/multiSpd")
		command_once("1-sim/comm/AP/multiSelect")
	end
end,
function ()
	if get("1-sim/AP/spdButton") == 1 then
		command_once("1-sim/comm/AP/multiSpd")
		command_once("1-sim/comm/AP/multiSelect")
	end
end,
function ()
	command_once("1-sim/comm/AP/multiSpd")
	command_once("1-sim/comm/AP/multiSelect")
end,
function () 
	return get("1-sim/AP/lamp/2")
end)
sysMCP.spdAnc 				= SimpleAnnunciator:new("spdanc","1-sim/AP/lamp/2",0)

-- NAV mode annunciator
sysMCP.navAnc 				= SimpleAnnunciator:new("navanc","1-sim/AP/lamp/10",0)

-- **APPROACH
sysMCP.approachSwitch 		= TwoStateCustomSwitch:new("approach","1-sim/AP/appButton",0,
function ()
	if get("1-sim/AP/appButton") == 0 then
		command_once("1-sim/comm/AP/appButton")
	end
end,
function ()
	if get("1-sim/AP/appButton") == 1 then
		command_once("1-sim/comm/AP/appButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/appButton")
end,
function () 
	return get("1-sim/AP/lamp/11")
end)
sysMCP.aprAnc 				= SimpleAnnunciator:new("apranc","1-sim/AP/lamp/11",0)

-- IAS mode or Level Change or FLCH
sysMCP.flchSwitch 		= TwoStateCustomSwitch:new("flch","1-sim/AP/flchButton",0,
function ()
	if get("1-sim/AP/flchButton") == 0 then
		command_once("1-sim/comm/AP/flchButton")
	end
end,
function ()
	if get("1-sim/AP/flchButton") == 1 then
		command_once("1-sim/comm/AP/flchButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/flchButton")
end,
function () 
	return get("1-sim/AP/lamp/5")
end)

-- **VS
sysMCP.vsSwitch 			= TwoStateCustomSwitch:new("vsmode","1-sim/AP/vviButton",0,
function ()
	if get("1-sim/AP/vviButton") == 0 then
		command_once("1-sim/comm/AP/vviButton")
	end
end,
function ()
	if get("1-sim/AP/vviButton") == 1 then
		command_once("1-sim/comm/AP/vviButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/vviButton")
end,
function () 
	return get("1-sim/AP/lamp/5")
end)
-- Vertical mode annunciator
sysMCP.vspAnc 				= SimpleAnnunciator:new("vspanc","1-sim/AP/lamp/7",0)

-- LNAV
sysMCP.lnavSwitch 			= TwoStateCustomSwitch:new("lnav","1-sim/AP/lnavButton",0,
function ()
	if get("1-sim/AP/lnavButton") == 0 then
		command_once("1-sim/comm/AP/lnavButton")
	end
end,
function ()
	if get("1-sim/AP/lnavButton") == 1 then
		command_once("1-sim/comm/AP/lnavButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/lnavButton")
end,
function () 
	return get("1-sim/AP/lamp/3")
end)

-- VNAV
sysMCP.vnavSwitch 			= TwoStateCustomSwitch:new("vnav","1-sim/AP/vnavButton",0,
function ()
	if get("1-sim/AP/vnavButton") == 0 then
		command_once("1-sim/comm/AP/vnavButton")
	end
end,
function ()
	if get("1-sim/AP/vnavButton") == 1 then
		command_once("1-sim/comm/AP/vnavButton")
	end
end,
function ()
	command_once("1-sim/comm/AP/vnavButton")
end,
function () 
	return get("1-sim/AP/lamp/4")
end)

-- **TOGA Button
sysMCP.togaPilotSwitch 		= TwoStateToggleSwitch:new("togapilot","1-sim/AP/togaButton",0,
	"1-sim/comm/AP/at_toga")
	
-- **ATHR
sysMCP.athrSwitch 			= TwoStateCustomSwitch:new("athr","1-sim/AP/atSwitcher/anim",0,
function ()
	if get("1-sim/AP/atSwitcher/anim") == 1 then
		command_once("1-sim/command/AP/atSwitcher_trigger")
	end
end,
function ()
	if get("1-sim/AP/atSwitcher/anim") == 0 then
		command_once("1-sim/command/AP/atSwitcher_trigger")
	end
end,
function ()
	command_once("1-sim/command/AP/atSwitcher_trigger")
end,
function () 
	return 1-get("1-sim/AP/atSwitcher/anim")
end)
sysMCP.athrAnc				= SimpleAnnunciator:new("athr","1-sim/AP/atSwitcher/anim",0)

-- === Selectors

-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1","sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot",0,
	"1-sim/comm/vor1crsRotaryDN","1-sim/comm/vor1crsRotaryUP",0,359,false)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2","sim/cockpit2/radios/actuators/nav2_obs_deg_mag_pilot",0,
	"1-sim/comm/vor2crsRotaryDN","1-sim/comm/vor2crsRotaryUP",0,359,false)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","757Avionics/ap/spd_act",0,
	"1-sim/comm/AP/spdDN","1-sim/comm/AP/spdUP",100,340,false)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","757Avionics/ap/hdg_act",0,
	"1-sim/comm/AP/hdgDN","1-sim/comm/AP/hdgUP",0,359,false)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","757Avionics/ap/alt_act",0,
	"1-sim/comm/AP/altDN","1-sim/comm/AP/altUP",0,50000,false)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt","757Avionics/ap/alt_act",0)

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","757Avionics/ap/vs_act",0,
	"1-sim/comm/AP/vviDN","1-sim/comm/AP/vviUP",-7900,7900,false)

-- A/P DISENGAGE
sysMCP.discAPSwitch 		= TwoStateCustomSwitch:new("apdisc","1-sim/AP/desengageLever/anim",0,
function ()
	if get("1-sim/AP/desengageLever/anim") == 1 then
		command_once("1-sim/command/AP/atSwitcher_trigger")
	end
end,
function ()
	if get("1-sim/AP/desengageLever/anim") == 0 then
		command_once("1-sim/command/AP/desengageLever_button")
	end
end,
function ()
	command_once("1-sim/command/AP/desengageLever_button")
end,
function () 
	return 1-get("1-sim/command/AP/desengageLever_button")
end)
	
sysMCP.apDiscYoke 			= TwoStateToggleSwitch:new("discapyoke","sim/cockpit2/annunciators/autopilot_disconnect",0,
	"1-sim/comm/AP/ap_disc")

-- YAW DAMPER
sysMCP.yawDamper			= SwitchGroup:new("yawdamper")
sysMCP.yawDamper1			= TwoStateCustomSwitch:new("yawdamper","anim/1/button",0,
	function ()
		set("anim/1/button",1)
	end,
	function ()
		set("anim/1/button",0)
	end,
	function ()
		if get("anim/1/button") == 0 then
			set("anim/1/button",1)
		else
			set("anim/1/button",0)
		end
	end,
	function ()
		return get("anim/1/button")
	end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper1)

sysMCP.yawDamper2			= TwoStateCustomSwitch:new("yawdamper","anim/2/button",0,
	function ()
		set("anim/2/button",1)
	end,
	function ()
		set("anim/2/button",0)
	end,
	function ()
		if get("anim/2/button") == 0 then
			set("anim/2/button",1)
		else
			set("anim/2/button",0)
		end
	end,
	function ()
		return get("anim/2/button")
	end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper2)

return sysMCP
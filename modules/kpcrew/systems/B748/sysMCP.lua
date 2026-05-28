-- B748 airplane 
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

logMsg("B748 sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","ssg/B748/MCP/mcp_plt_fd_act",0)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","ssg/B748/MCP/mcp_cplt_fd_act",0)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","ssg/B748/MCP/mcp_plt_fd_act",0)

-- **AUTOPILOT
sysMCP.ap1Switch 			= TwoStateToggleSwitch:new("autopilot1","sim/cockpit2/autopilot/servos_on",0,
	"sim/autopilot/servos_toggle")
sysMCP.apAnc 				= SimpleAnnunciator:new("autopilotanc","sim/cockpit2/autopilot/servos_on",0)

-- **ATHR
-- -1=hard off, not even armed. 0=servos declutched (arm, hold), 1=airspeed hold, 2=N1 target hold, 3=retard, 4=reserved for future use
sysMCP.athrSwitch 			= TwoStateDrefSwitch:new("autopilot1","ssg/B748/MCP/mcp_at_arm_act",0)
sysMCP.athrAnc				= SimpleAnnunciator:new("autopilotanc","ssg/B748/MCP/mcp_at_arm_act",0)

-- **ALTHOLD
sysMCP.altholdSwitch 		= TwoStateToggleSwitch:new("althold","ssg/B748/MCP/mcp_alt_hold_sw",0)
sysMCP.altAnc 				= SimpleAnnunciator:new("altanc","ssg/B748/MCP/mcp_alt_hold_ann",0)

-- LNAV / GPSS mode
sysMCP.lnavSwitch 			= TwoStateCustomSwitch:new("lnav","ssg/B748/MCP/mcp_lnav_ann",0,
function ()
	if get("ssg/B748/MCP/mcp_lnav_ann") == 0 then
		activeBckVars:set("general:auxiliary1","ssg/B748/MCP/mcp_lnav_sw")
		kc_procvar_set("auxiliary",true)
	end
end,
function ()
	if get("ssg/B748/MCP/mcp_lnav_ann") == 1 then
		activeBckVars:set("general:auxiliary1","ssg/B748/MCP/mcp_lnav_sw")
		kc_procvar_set("auxiliary",true)
	end
end,
function ()
	activeBckVars:set("general:auxiliary1","ssg/B748/MCP/mcp_lnav_sw")
	kc_procvar_set("auxiliary",true)
end,
function () 
	return get("ssg/B748/MCP/mcp_lnav_ann")
end)

-- VNAV
sysMCP.vnavSwitch 			= TwoStateToggleSwitch:new("vnav","ssg/B748/MCP/mcp_vnav_sw",0,
function ()
	if get("ssg/B748/MCP/mcp_vnav_ann") == 0 then
		activeBckVars:set("general:auxiliary1","ssg/B748/MCP/mcp_vnav_sw")
		kc_procvar_set("auxiliary",true)
	end
end,
function ()
	if get("ssg/B748/MCP/mcp_vnav_ann") == 1 then
		activeBckVars:set("general:auxiliary1","ssg/B748/MCP/mcp_vnav_sw")
		kc_procvar_set("auxiliary",true)
	end
end,
function ()
	activeBckVars:set("general:auxiliary1","ssg/B748/MCP/mcp_vnav_sw")
	kc_procvar_set("auxiliary",true)
end,
function () 
	return get("ssg/B748/MCP/mcp_vnav_ann")
end)
	
-- CRS 1&2
sysMCP.crs1Selector 		= InopSwitch:new("crs1")
sysMCP.crs2Selector 		= InopSwitch:new("crs2")
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","ssg/B748/MCP/mcp_heading_bug_act",0,
	nil,nil,0,359,false,1)

-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","ssg/B748/MCP/mcp_alt_target_act",0,
	nil,nil,0,50000,false,1000)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt","ssg/B748/MCP/mcp_alt_target_act",0)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","ssg/B748/MCP/mcp_ias_mach_act",0,
	nil,nil,100,340,false,1)

-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","ssg/B748/MCP/mcp_vs_target_act",0,
	nil,nil,-7900,7900,false,1)

-- YAW DAMPER
sysMCP.yawDamper			= SwitchGroup:new("yawdamper")
sysMCP.yawDamper1			= TwoStateDrefSwitch:new("yawdamper","ssg/YAW/yaw_dp_sw",0)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper1)
sysMCP.yawDamper2			= TwoStateCustomSwitch:new("yawdamper","ssg/YAW/yaw_dp_lw_sw",0)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper2)

return sysMCP
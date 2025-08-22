-- B742 airplane 
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

logMsg("B742 sysMCP")

-- **Flight Directors 
sysMCP.fdirPilotSwitch 		= TwoStateDrefSwitch:new("fdir left","B742/AP_panel/flight_dir_on_sw",-1)
sysMCP.fdirCoPilotSwitch 	= TwoStateDrefSwitch:new("fdir right","B742/AP_panel/flight_dir_on_sw",1)
sysMCP.fdirGroup 			= SwitchGroup:new("fdirs")
sysMCP.fdirGroup:addSwitch(sysMCP.fdirPilotSwitch)
sysMCP.fdirGroup:addSwitch(sysMCP.fdirCoPilotSwitch)
sysMCP.fdirAnc 				= SimpleAnnunciator:new("fdiranc","B742/AP_panel/flight_dir_on_sw",-1)

-- **AUTOPILOT
sysMCP.ap1Switch 			= TwoStateCustomSwitch:new("autopilot1","B742/AP_panel/AP_engage_A",0,
	function ()
		set("B742/AP_panel/AP_engage_A",2)
	end,
	function ()
		set("B742/AP_panel/AP_engage_A",0)
	end,
	function ()
		if get("B742/AP_panel/AP_engage_A") == 0 then
			set("B742/AP_panel/AP_engage_A",2)
		else
			set("B742/AP_panel/AP_engage_A",0)
		end
	end,
	function ()
		if get("B742/AP_panel/AP_engage_A") > 0 then
			return 1
		else
			return 0
		end
	end)
sysMCP.ap2Switch 			= TwoStateCustomSwitch:new("autopilot1","B742/AP_panel/AP_engage_B",0,
	function ()
		set("B742/AP_panel/AP_engage_B",2)
	end,
	function ()
		set("B742/AP_panel/AP_engage_B",0)
	end,
	function ()
		if get("B742/AP_panel/AP_engage_B") == 0 then
			set("B742/AP_panel/AP_engage_B",2)
		else
			set("B742/AP_panel/AP_engage_B",0)
		end
	end,
	function ()
		if get("B742/AP_panel/AP_engage_B") > 0 then
			return 1
		else
			return 0
		end
	end)
sysMCP.apAnc 				= CustomAnnunciator:new("autopilotanc",
	function ()
		if get("B742/AP_panel/AP_engage_A") > 0 or get("B742/AP_panel/AP_engage_B") > 0 then
			return 1
		else
			return 0
		end
	end)

-- IAS
sysMCP.iasSelector 			= MultiStateCmdSwitch:new("ias","B742/AP_panel/AT_spd_set_rotary",0,
	nil,nil,100,340,false,1)
	
-- ALT
sysMCP.altSelector 			= MultiStateCmdSwitch:new("alt","B742/AP_panel/altitude_set",0,
	nil,nil,0,50000,false,1)
sysMCP.altDisplay 			= SimpleAnnunciator:new("alt","B742/AP_panel/altitude_set",0)

-- HDG
sysMCP.hdgSelector 			= MultiStateCmdSwitch:new("hdg","B742/AP_panel/heading_set",0,
	nil,nil,0,359,false,1)
	
-- VSP
sysMCP.vspSelector 			= MultiStateCmdSwitch:new("vsp","sim/cockpit2/autopilot/vvi_dial_fpm",0,
	"sim/autopilot/vertical_speed_down","sim/autopilot/vertical_speed_up",-7900,7900,true)
	
-- CRS 1&2
sysMCP.crs1Selector 		= MultiStateCmdSwitch:new("crs1","B742/AP_panel/course_1_set",0,
	nil,nil,0,359,false,1)
sysMCP.crs2Selector 		= MultiStateCmdSwitch:new("crs2","B742/AP_panel/course_2_set",0,
	nil,nil,0,359,false,1)
sysMCP.crsSelectorGroup	 	= SwitchGroup:new("crs")
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs1Selector)
sysMCP.crsSelectorGroup:addSwitch(sysMCP.crs2Selector)

-- **ATHR
-- -1=hard off, not even armed. 0=servos declutched (arm, hold), 1=airspeed hold, 2=N1 target hold, 3=retard, 4=reserved for future use
sysMCP.athrSwitch 			= TwoStateDrefSwitch:new("athr","B742/AP_panel/AT_on_sw",0)
sysMCP.athrAnc				= SimpleAnnunciator:new("athr","B742/AP_panel/AT_on_sw",0)

-- YAW DAMPER
sysMCP.yawDamper			= SwitchGroup:new("yawdamper")
sysMCP.yawDamper1			= TwoStateCustomSwitch:new("yawdamper","B742/OVHD/YAW_damper_on_off_sw_up",0,
	function ()
		set("B742/OVHD/YAW_damper_on_off_sw_up",1)
		set("B742/OVHD/YAW_damper_on_off_cap_up",0)
	end,
	function ()
		set("B742/OVHD/YAW_damper_on_off_sw_up",0)
		set("B742/OVHD/YAW_damper_on_off_cap_up",1)
	end,
	function ()
		if get("B742/OVHD/YAW_damper_on_off_sw_up") == 0 then
			set("B742/OVHD/YAW_damper_on_off_sw_up",1)
			set("B742/OVHD/YAW_damper_on_off_cap_up",0)
		else
			set("B742/OVHD/YAW_damper_on_off_sw_up",0)
			set("B742/OVHD/YAW_damper_on_off_cap_up",1)
		end
	end,
	function ()
		return get("B742/OVHD/YAW_damper_on_off_sw_up")
	end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper1)

sysMCP.yawDamper2			= TwoStateCustomSwitch:new("yawdamper","B742/OVHD/YAW_damper_on_off_sw_dn",0,
	function ()
		set("B742/OVHD/YAW_damper_on_off_sw_dn",1)
		set("B742/OVHD/YAW_damper_on_off_cap_dn",0)
	end,
	function ()
		set("B742/OVHD/YAW_damper_on_off_sw_dn",0)
		set("B742/OVHD/YAW_damper_on_off_cap_dn",1)
	end,
	function ()
		if get("B742/OVHD/YAW_damper_on_off_sw_dn") == 0 then
			set("B742/OVHD/YAW_damper_on_off_sw_dn",1)
			set("B742/OVHD/YAW_damper_on_off_cap_dn",0)
		else
			set("B742/OVHD/YAW_damper_on_off_sw_dn",0)
			set("B742/OVHD/YAW_damper_on_off_cap_dn",1)
		end
	end,
	function ()
		return get("B742/OVHD/YAW_damper_on_off_sw_dn")
	end)
sysMCP.yawDamper:addSwitch(sysMCP.yawDamper2)

return sysMCP
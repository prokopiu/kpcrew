-- B737 airplane 
-- Electric system functionality

-- @classmod sysElectric
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

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

logMsg("B737 sysElectric")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

-- BATTERY Switches
if kc_is_zibo then
	sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","laminar/B738/electric/battery_pos",0,
		function ()
			command_once("laminar/B738/switch/battery_dn")
			if get("laminar/B738/button_switch/cover_position",2) ~= 0 then
			  command_once("laminar/B738/button_switch_cover02")
			end
		end,
		function ()
			if get("laminar/B738/button_switch/cover_position",2) == 0 then
				command_once("laminar/B738/button_switch_cover02")
			end
			command_once("laminar/B738/push_button/batt_full_off")
		end,
		function ()
			if get("sim/cockpit/electrical/battery_on",0) == 0 then
				command_once("laminar/B738/switch/battery_dn")
				if get("laminar/B738/button_switch/cover_position",2) ~= 0 then
				  command_once("laminar/B738/button_switch_cover02")
				end
			else
				command_once("laminar/B738/push_button/batt_full_off")
				if get("laminar/B738/button_switch/cover_position",2) == 0 then
					command_once("laminar/B738/button_switch_cover02")
				end
			end
		end,
		function ()
			if get("laminar/B738/electric/battery_pos",0) == 1 then
				return 1
			else
				return 0
			end
		end)
else
	sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","sim/cockpit/electrical/battery_on",0,
		function ()
			-- command_once("sim/electrical/battery_1_on")
			if get("laminar/B738/button_switch/guard_cover_pos",0) ~= 0 then
			  command_once("laminar/B738/guard_cover00")
			end
		end,
		function ()
			if get("laminar/B738/button_switch/guard_cover_pos",0) == 0 then
				command_once("laminar/B738/guard_cover00")
				command_once("laminar/B738/guard_cover00")
			end
			command_once("sim/electrical/battery_1_off")
			command_once("sim/electrical/battery_1_off")
		end,
		function ()
			if get("sim/cockpit/electrical/battery_on",0) == 0 then
				-- command_once("sim/electrical/battery_1_on")
				if get("laminar/B738/button_switch/guard_cover_pos",0) ~= 0 then
				  command_once("laminar/B738/guard_cover00")
				end
			else
				command_once("sim/electrical/battery_1_off")
				if get("laminar/B738/button_switch/guard_cover_pos",0) == 0 then
					command_once("laminar/B738/guard_cover00")
				end
			end
		end,
		function ()
			if get("sim/cockpit/electrical/battery_on",0) == 1 then
				return 1
			else
				return 0
			end
		end)
end

-- Standby Power
if kc_is_zibo then
	sysElectric.stbyPowerSwitch	= TwoStateCustomSwitch:new("stbypwr","laminar/B738/electric/standby_bat_pos",0,
		function ()
			command_once("laminar/B738/switch/standby_bat_right")
			command_once("laminar/B738/switch/standby_bat_right")
			if get("laminar/B738/button_switch/cover_position",3) ~= 0 then
			  command_once("laminar/B738/button_switch_cover03")
			end
		end,
		function ()
			if get("laminar/B738/button_switch/cover_position",3) == 0 then
				command_once("laminar/B738/button_switch_cover03")
			end
			command_once("laminar/B738/switch/standby_bat_left")
		end,
		function ()
			if get("laminar/B738/electric/standby_bat_pos") == 0 then
				command_once("laminar/B738/switch/standby_bat_right")
				if get("laminar/B738/button_switch/cover_position",3) ~= 0 then
				  command_once("laminar/B738/button_switch_cover03")
				end
			else
				command_once("slaminar/B738/switch/standby_bat_left")
				if get("laminar/B738/button_switch/cover_position",3) == 0 then
					command_once("laminar/B738/button_switch_cover03")
				end
			end
		end,
		function ()
			if get("laminar/B738/electric/standby_bat_pos") == 1 then
				return 1
			else
				return 0
			end
		end)
else
	sysElectric.stbyPowerSwitch	= TwoStateCustomSwitch:new("stbypwr","sim/cockpit/electrical/battery_on",1,
		function ()
			command_once("sim/electrical/battery_2_on")
			if get("laminar/B738/button_switch/guard_cover_pos",1) ~= 0 then
			  command_once("laminar/B738/guard_cover01")
			end
		end,
		function ()
			if get("laminar/B738/button_switch/guard_cover_pos",1) == 0 then
				command_once("laminar/B738/guard_cover01")
			end
			command_once("sim/electrical/battery_2_off")
		end,
		function ()
			if get("sim/cockpit/electrical/battery_on",1) == 0 then
				command_once("sim/electrical/battery_2_on")
				if get("laminar/B738/button_switch/guard_cover_pos",1) ~= 0 then
				  command_once("laminar/B738/guard_cover01")
				end
			else
				command_once("sim/electrical/battery_2_off")
				if get("laminar/B738/button_switch/guard_cover_pos",1) == 0 then
					command_once("laminar/B738/guard_cover01")
				end
			end
		end,
		function ()
			if get("sim/cockpit/electrical/battery_on",1) == 1 then
				return 1
			else
				return 0
			end
		end)
end
	
-- Cabin Util Power Boeing
if kc_is_zibo then
	sysElectric.cabUtilPwr 		= TwoStateToggleSwitch:new("cabutil","laminar/B738/toggle_switch/cab_util_pos",0,
		"laminar/B738/autopilot/cab_util_toggle")
	sysElectric.ifePwr 			= TwoStateToggleSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,
		"laminar/B738/autopilot/ife_pass_seat_toggle")
else
	sysElectric.cabUtilPwr 		= TwoStateCmdSwitch:new("cabutil","laminar/B738/electrical/cab_util_pos",0,
		"laminar/B738/switch/cab_util_on","laminar/B738/switch/cab_util_off","nocommand")
	sysElectric.ifePwr 			= TwoStateCmdSwitch:new("ifepwr","laminar/B738/electrical/ife_switch_pos",0,
		"laminar/B738/switch/ife_pass_seat_on","laminar/B738/switch/ife_pass_seat_off","nocommand")
end

-- APU Bus Switches
if kc_is_zibo then
	sysElectric.apuGenBus1 		= MultiStateCmdSwitch:new("apubus1","laminar/B738/electrical/apu_gen1_pos",0,
		"laminar/B738/toggle_switch/apu_gen1_up","laminar/B738/toggle_switch/apu_gen1_dn",-1,1,true)
	sysElectric.apuGenBus2 		= MultiStateCmdSwitch:new("apubus2","laminar/B738/electrical/apu_gen2_pos",0,
		"laminar/B738/toggle_switch/apu_gen2_up","laminar/B738/toggle_switch/apu_gen2_dn",-1,1,true)
else
	sysElectric.apuGenBus1 		= TwoStateCmdSwitch:new("apubus1","laminar/B738/electrical/apu_genL_status",0,
		"laminar/B738/switch/apuL_dn","laminar/B738/switch/apuL_up","nocommand")
	sysElectric.apuGenBus2 		= TwoStateCmdSwitch:new("apubus2","laminar/B738/electrical/apu_genR_status",0,
		"laminar/B738/switch/apuR_dn","laminar/B738/switch/apuR_up","nocommand")
end

-- APU Starter
if kc_is_zibo then
	sysElectric.apuStartSwitch 	= MultiStateCmdSwitch:new("apu","laminar/B738/spring_toggle_switch/APU_start_pos",0,
		"laminar/B738/spring_toggle_switch/APU_start_pos_dn","laminar/B738/spring_toggle_switch/APU_start_pos_up",-1,1,true)
end 

-- APU GEN BUS OFF
if kc_is_zibo then
-- APU RUNNING annunciator
	sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
		function () 
			if get("laminar/B738/annunciator/apu_gen_off_bus") > 0 then
				return 1
			else
				return 0
			end
		end)
else
	sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
		function () 
			if get("sim/cockpit/electrical/generator_apu_on") == 1 then
				return 1
			else
				return 0
			end
		end)
end

-- ----- GPU
if kc_is_zibo then
	sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
	-- de-/activate GPU
	sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","laminar/B738/gpu_available",0,
	function ()
		if get("laminar/B738/gpu_available") == 0 then
			command_once("laminar/B738/gpu_toggle")
		end
	end,
	function ()
		if get("laminar/B738/gpu_available") == 1 then
			command_once("laminar/B738/gpu_toggle")
		end
	end,
	function ()
		command_once("laminar/B738/gpu_toggle")
	end,
	function ()
		return get("laminar/B738/gpu_available")
	end)	
	sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","sim/cockpit2/electrical/GPU_generator_on",0)
	sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
else
	sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
	-- de-/activate GPU
	sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","sim/cockpit/electrical/gpu_on",0,
	function ()
		set("sim/cockpit/electrical/gpu_on",1)
		command_once("sim/ground_ops/service_plane")
	end,
	function ()
		set("sim/cockpit/electrical/gpu_on",0)
	end,
	function ()
	end,
	function ()
		return get("sim/cockpit/electrical/gpu_on")
	end)	
	sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","sim/cockpit2/electrical/GPU_generator_on",0)
	sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
end


return sysElectric

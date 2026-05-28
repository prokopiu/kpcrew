-- B744 MSPARKS airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
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

sysHydraulic = require("kpcrew.systems.DFLT.sysHydraulic")

logMsg("B744 sysHydraulic")

-- ----- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPump1	= TwoStateCustomSwitch:new("enghydpump1","laminar/B747/hydraulics/dem_mode_1",0,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_01_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_01_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_01_up")
	end,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_01_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_01_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/hydraulics/dem_mode_1") == 0 then
			return 0
		else
			return 1
		end
	end)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPump2	= TwoStateCustomSwitch:new("enghydpump2","laminar/B747/hydraulics/dem_mode_2",0,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_02_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_02_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_02_up")
	end,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_02_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_02_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/hydraulics/dem_mode_2") == 0 then
			return 0
		else
			return 1
		end
	end)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)
sysHydraulic.elecHydPump3	= TwoStateCustomSwitch:new("elechydpump3","laminar/B747/hydraulics/dem_mode_3",0,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_03_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_03_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_03_up")
	end,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_03_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_03_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/hydraulics/dem_mode_3") == 0 then
			return 0
		else
			return 1
		end
	end)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump3)
sysHydraulic.elecHydPump4	= TwoStateCustomSwitch:new("enghydpump4","laminar/B747/hydraulics/dem_mode_4",0,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_up")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_up")
	end,
	function ()
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
		command_once("laminar/B747/hydraulics/sel_dial/dmd_pump_04_dn")
	end,
	function ()
	end,
	function ()
		if get("laminar/B747/hydraulics/dem_mode_4") == 0 then
			return 0
		else
			return 1
		end
	end)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump4)

	
-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateCustomSwitch:new("enghydpump1","laminar/B747/hydraulics/valve_1",0,
	function ()
		if get("laminar/B747/hydraulics/valve_1") == 0 then
			command_once("laminar/B747/button_switch/hyd_pump_1")
		end
	end,
	function ()
		if get("laminar/B747/hydraulics/valve_1") ~= 0 then
			command_once("laminar/B747/button_switch/hyd_pump_1")
		end
	end,
	function ()
	end,
	function ()
		return get("laminar/B747/hydraulics/valve_1")
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateCustomSwitch:new("enghydpump2","laminar/B747/hydraulics/valve_2",0,
	function ()
		if get("laminar/B747/hydraulics/valve_2") == 0 then
			command_once("laminar/B747/button_switch/hyd_pump_2")
		end
	end,
	function ()
		if get("laminar/B747/hydraulics/valve_2") ~= 0 then
			command_once("laminar/B747/button_switch/hyd_pump_2")
		end
	end,
	function ()
	end,
	function ()
		return get("laminar/B747/hydraulics/valve_2")
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.engHydPump3	= TwoStateCustomSwitch:new("enghydpump3","laminar/B747/hydraulics/valve_3",0,
	function ()
		if get("laminar/B747/hydraulics/valve_3") == 0 then
			command_once("laminar/B747/button_switch/hyd_pump_3")
		end
	end,
	function ()
		if get("laminar/B747/hydraulics/valve_3") ~= 0 then
			command_once("laminar/B747/button_switch/hyd_pump_3")
		end
	end,
	function ()
	end,
	function ()
		return get("laminar/B747/hydraulics/valve_3")
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
sysHydraulic.engHydPump4	= TwoStateCustomSwitch:new("enghydpump4","laminar/B747/hydraulics/valve_4",0,
	function ()
		if get("laminar/B747/hydraulics/valve_4") == 0 then
			command_once("laminar/B747/button_switch/hyd_pump_4")
		end
	end,
	function ()
		if get("laminar/B747/hydraulics/valve_4") ~= 0 then
			command_once("laminar/B747/button_switch/hyd_pump_4")
		end
	end,
	function ()
	end,
	function ()
		return get("laminar/B747/hydraulics/valve_4")
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)

return sysHydraulic
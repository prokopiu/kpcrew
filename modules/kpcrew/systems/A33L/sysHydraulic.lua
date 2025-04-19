-- Laminar A330 variants airplane 
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

logMsg("A33L sysHydraulic")

-- --- HYD Electric Pumps

sysHydraulic.exelcHydPump1		= TwoStateCustomSwitch:new("elechydpump1","laminar/A333/annun/hyd/elec_green_on",0,
	function ()
		command_once("laminar/A330/buttons/hyd/elec_green_on")
	end,
	function ()
		command_once("laminar/A330/buttons/hyd/elec_green_toggle")
		command_once("laminar/A330/buttons/hyd/elec_green_toggle")
	end,
	function ()
		if get("laminar/A333/annun/hyd/elec_green_on") == 1 then
			command_once("laminar/A330/buttons/hyd/elec_green_toggle")
			command_once("laminar/A330/buttons/hyd/elec_green_toggle")
		else
			command_once("laminar/A330/buttons/hyd/elec_green_on")
		end
	end,
	function ()
		return get("laminar/A333/annun/hyd/elec_green_on")
	end)
sysHydraulic.exelcHydPump2		= TwoStateCustomSwitch:new("elechydpump2","laminar/A333/annun/hyd/elec_yellow_on",0,
	function ()
		command_once("laminar/A330/buttons/hyd/elec_yellow_on")
	end,
	function ()
		command_once("laminar/A330/buttons/hyd/elec_yellow_toggle")
		command_once("laminar/A330/buttons/hyd/elec_yellow_toggle")
	end,
	function ()
		if get("laminar/A333/annun/hyd/elec_yellow_on") == 1 then
			command_once("laminar/A330/buttons/hyd/elec_yellow_toggle")
			command_once("laminar/A330/buttons/hyd/elec_yellow_toggle")
		else
			command_once("laminar/A330/buttons/hyd/elec_yellow_on")
		end
	end,
	function ()
		return get("laminar/A333/annun/hyd/elec_yellow_on")
	end)
sysHydraulic.exelcHydPump3		= TwoStateCustomSwitch:new("elechydpump2","laminar/A333/annun/hyd/elec_blue_on",0,
	function ()
		command_once("laminar/A330/buttons/hyd/elec_blue_on")
	end,
	function ()
		command_once("laminar/A330/buttons/hyd/elec_blue_toggle")
		command_once("laminar/A330/buttons/hyd/elec_blue_toggle")
	end,
	function ()
		if get("laminar/A333/annun/hyd/elec_blue_on") == 1 then
			command_once("laminar/A330/buttons/hyd/elec_blue_toggle")
			command_once("laminar/A330/buttons/hyd/elec_blue_toggle")
		else
			command_once("laminar/A330/buttons/hyd/elec_blue_on")
		end
	end,
	function ()
		return get("laminar/A333/annun/hyd/elec_blue_on")
	end)
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.exelcHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.exelcHydPump2)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.exelcHydPump3)

return sysHydraulic
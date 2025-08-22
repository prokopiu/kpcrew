-- B742 airplane 
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

logMsg("B742 sysHydraulic")

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = TwoStateCustomSwitch:new("elechydpump","B742/HYD/elec_pump_sys4_sw",0,
	function ()
		set("B742/HYD/elec_pump_sys4_sw",1)
		set("B742/HYD/elec_pump_sys4_cap",1)
	end,
	function ()
		set("B742/HYD/elec_pump_sys4_sw",0)
		set("B742/HYD/elec_pump_sys4_cap",0)
	end,
	function ()
		if get("B742/HYD/elec_pump_sys4_sw") == 0 then
			set("B742/HYD/elec_pump_sys4_sw",1)
			set("B742/HYD/elec_pump_sys4_cap",1)
		else
			set("B742/HYD/elec_pump_sys4_sw",0)
			set("B742/HYD/elec_pump_sys4_cap",0)
		end
	end,
	function ()
		return get("B742/HYD/elec_pump_sys4_sw")
	end)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","B742/HYD/eng_pump_sw",-1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","B742/HYD/eng_pump_sw",1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3","B742/HYD/eng_pump_sw",2)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4","B742/HYD/eng_pump_sw",3)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)

return sysHydraulic
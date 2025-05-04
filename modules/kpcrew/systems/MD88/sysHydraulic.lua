-- MD88 Rotate airplane 
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

logMsg("MD88 sysHydraulic")

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = TwoStateDrefSwitch:new("elechydpump","Rotate/md80/hydraulic/hyd_switch_electric",0)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateCustomSwitch:new("enghydpump1","Rotate/md80/hydraulic/hyd_switch_l",0,
	function () set("Rotate/md80/hydraulic/hyd_switch_l",2) end,
	function () set("Rotate/md80/hydraulic/hyd_switch_l",0) end,
	function ()
		if get("Rotate/md80/hydraulic/hyd_switch_l") == 0 then 
			set("Rotate/md80/hydraulic/hyd_switch_l",2)
		else
			set("Rotate/md80/hydraulic/hyd_switch_l",0)
		end
	end,
	function ()
		if get("Rotate/md80/hydraulic/hyd_switch_l") == 0 then
			return 0
		else
			return 1
		end
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateCustomSwitch:new("enghydpump2",
"Rotate/md80/hydraulic/hyd_switch_r",0,
	function () set("Rotate/md80/hydraulic/hyd_switch_r",2) end,
	function () set("Rotate/md80/hydraulic/hyd_switch_r",0) end,
	function ()
		if get("Rotate/md80/hydraulic/hyd_switch_r") == 0 then 
			set("Rotate/md80/hydraulic/hyd_switch_r",2)
		else
			set("Rotate/md80/hydraulic/hyd_switch_r",0)
		end
	end,
	function ()
		if get("Rotate/md80/hydraulic/hyd_switch_r") == 0 then
			return 0
		else
			return 1
		end
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

-- PTU / Transfer Pump
sysHydraulic.PTU			= TwoStateDrefSwitch:new("ptu","Rotate/md80/hydraulic/hyd_trans",0)

return sysHydraulic
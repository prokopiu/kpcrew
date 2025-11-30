-- B7x7 FF B767 B757 airplane 
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

logMsg("B7x7 sysHydraulic")

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup 	= SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPump1		= TwoStateCustomSwitch:new("elechydpump1","anim/9/button",0,
	function () 
		set("anim/9/button/anim",1)
		set("anim/9/button",1)		
	end,
	function () 
		set("anim/9/button/anim",0)
		set("anim/9/button",0)		
	end,
	function () 
		if get("anim/9/button") == 0 then
			set("anim/9/button/anim",1)
			set("anim/9/button",1)
		else
			set("anim/9/button/anim",0)
			set("anim/9/button",0)	
		end
	end,
	function () return get("anim/9/button") end,null,
	function (value)
		set("anim/9/button/anim",value)
		set("anim/9/button",value)
	end)
sysHydraulic.elecHydPump2		= TwoStateCustomSwitch:new("elechydpump2","anim/10/button",0,
	function () 
		set("anim/10/button/anim",1)
		set("anim/10/button",1)		
	end,
	function () 
		set("anim/10/button/anim",0)
		set("anim/10/button",0)		
	end,
	function () 
		if get("anim/10/button") == 0 then
			set("anim/10/button/anim",1)
			set("anim/10/button",1)
		else
			set("anim/10/button/anim",0)
			set("anim/10/button",0)	
		end
	end,
	function () return get("anim/10/button") end,null,
	function (value)
		set("anim/10/button/anim",value)
		set("anim/10/button",value)
	end)
sysHydraulic.elecHydPump3		= TwoStateCustomSwitch:new("elechydpump3","anim/12/button",0,
	function () 
		set("anim/12/button/anim",1)
		set("anim/12/button",1)		
	end,
	function () 
		set("anim/12/button/anim",0)
		set("anim/12/button",0)		
	end,
	function () 
		if get("anim/12/button") == 0 then
			set("anim/12/button/anim",1)
			set("anim/12/button",1)
		else
			set("anim/12/button/anim",0)
			set("anim/12/button",0)	
		end
	end,
	function () return get("anim/12/button") end,null,
	function (value)
		set("anim/12/button/anim",value)
		set("anim/12/button",value)
	end)
sysHydraulic.elecHydPump4		= TwoStateCustomSwitch:new("elechydpump4","anim/13/button",0,
	function () 
		set("anim/13/button/anim",1)
		set("anim/13/button",1)		
	end,
	function () 
		set("anim/13/button/anim",0)
		set("anim/13/button",0)		
	end,
	function () 
		if get("anim/13/button") == 0 then
			set("anim/13/button/anim",1)
			set("anim/13/button",1)
		else
			set("anim/13/button/anim",0)
			set("anim/13/button",0)	
		end
	end,
	function () return get("anim/13/button") end,null,
	function (value)
		set("anim/13/button/anim",value)
		set("anim/13/button",value)
	end)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump2)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump3)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump4)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateCustomSwitch:new("enghydpump1","anim/8/button",0,
	function () 
		set("anim/8/button/anim",1)
		set("anim/8/button",1)		
	end,
	function () 
		set("anim/8/button/anim",0)
		set("anim/8/button",0)		
	end,
	function () 
		if get("anim/8/button") == 0 then
			set("anim/8/button/anim",1)
			set("anim/8/button",1)
		else
			set("anim/8/button/anim",0)
			set("anim/8/button",0)	
		end
	end,
	function () return get("anim/8/button") end,null,
	function (value)
		set("anim/8/button/anim",value)
		set("anim/8/button",value)
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateCustomSwitch:new("enghydpump2","anim/11/button",0,
	function () 
		set("anim/11/button/anim",1)
		set("anim/11/button",1)		
	end,
	function () 
		set("anim/11/button/anim",0)
		set("anim/11/button",0)		
	end,
	function () 
		if get("anim/11/button") == 0 then
			set("anim/11/button/anim",1)
			set("anim/11/button",1)
		else
			set("anim/11/button/anim",0)
			set("anim/11/button",0)	
		end
	end,
	function () return get("anim/11/button") end,null,
	function (value)
		set("anim/11/button/anim",value)
		set("anim/11/button",value)
	end)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

return sysHydraulic
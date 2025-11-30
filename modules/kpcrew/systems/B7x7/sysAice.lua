-- B7x7 FF B757 B767 airplane 
-- Anti Ice functionality

-- @classmod sysAice
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

sysAice = require("kpcrew.systems.DFLT.sysAice")

logMsg("B7x7 sysAice")

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateCustomSwitch:new("eng1aice","anim/41/button",0,
	function () 
		set("anim/41/button/anim",1)
		set("anim/41/button",1)		
	end,
	function () 
		set("anim/41/button/anim",0)
		set("anim/41/button",0)		
	end,
	function () 
		if get("anim/41/button") == 0 then
			set("anim/41/button/anim",1)
			set("anim/41/button",1)
		else
			set("anim/41/button/anim",0)
			set("anim/41/button",0)	
		end
	end,
	function () return get("anim/41/button") end,null,
	function (value)
		set("anim/41/button/anim",value)
		set("anim/41/button",value)
	end)
sysAice.engAntiIce2 		= TwoStateCustomSwitch:new("eng2aice","anim/42/button",0,
	function () 
		set("anim/42/button/anim",1)
		set("anim/42/button",1)		
	end,
	function () 
		set("anim/42/button/anim",0)
		set("anim/42/button",0)		
	end,
	function () 
		if get("anim/42/button") == 0 then
			set("anim/42/button/anim",1)
			set("anim/42/button",1)
		else
			set("anim/42/button/anim",0)
			set("anim/42/button",0)	
		end
	end,
	function () return get("anim/42/button") end,null,
	function (value)
		set("anim/42/button/anim",value)
		set("anim/42/button",value)
	end)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateCustomSwitch:new("wingaice","anim/40/button",0,
	function () 
		set("anim/40/button/anim",1)
		set("anim/40/button",1)		
	end,
	function () 
		set("anim/40/button/anim",0)
		set("anim/40/button",0)		
	end,
	function () 
		if get("anim/40/button") == 0 then
			set("anim/40/button/anim",1)
			set("anim/40/button",1)
		else
			set("anim/40/button/anim",0)
			set("anim/40/button",0)	
		end
	end,
	function () return get("anim/40/button") end,null,
	function (value)
		set("anim/40/button/anim",value)
		set("anim/40/button",value)
	end)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)

-- Window Heat
sysAice.windowHeat1 		= TwoStateCustomSwitch:new("winheat1","anim/47/button",0,
	function () 
		set("anim/47/button/anim",1)
		set("anim/47/button",1)		
	end,
	function () 
		set("anim/47/button/anim",0)
		set("anim/47/button",0)		
	end,
	function () 
		if get("anim/47/button") == 0 then
			set("anim/47/button/anim",1)
			set("anim/47/button",1)
		else
			set("anim/47/button/anim",0)
			set("anim/47/button",0)	
		end
	end,
	function () return get("anim/47/button") end,null,
	function (value)
		set("anim/47/button/anim",value)
		set("anim/47/button",value)
	end)
sysAice.windowHeat2 		= TwoStateCustomSwitch:new("winheat2","anim/48/button",0,
	function () 
		set("anim/48/button/anim",1)
		set("anim/48/button",1)		
	end,
	function () 
		set("anim/48/button/anim",0)
		set("anim/48/button",0)		
	end,
	function () 
		if get("anim/48/button") == 0 then
			set("anim/48/button/anim",1)
			set("anim/48/button",1)
		else
			set("anim/48/button/anim",0)
			set("anim/48/button",0)	
		end
	end,
	function () return get("anim/48/button") end,null,
	function (value)
		set("anim/48/button/anim",value)
		set("anim/48/button",value)
	end)
sysAice.windowHeat3 		= TwoStateCustomSwitch:new("winheat3","anim/49/button",0,
	function () 
		set("anim/49/button/anim",1)
		set("anim/49/button",1)		
	end,
	function () 
		set("anim/49/button/anim",0)
		set("anim/49/button",0)		
	end,
	function () 
		if get("anim/49/button") == 0 then
			set("anim/49/button/anim",1)
			set("anim/49/button",1)
		else
			set("anim/49/button/anim",0)
			set("anim/49/button",0)	
		end
	end,
	function () return get("anim/49/button") end,null,
	function (value)
		set("anim/49/button/anim",value)
		set("anim/49/button",value)
	end)
sysAice.windowHeat4 		= TwoStateCustomSwitch:new("winheat4","anim/50/button",0,
	function () 
		set("anim/50/button/anim",1)
		set("anim/50/button",1)		
	end,
	function () 
		set("anim/50/button/anim",0)
		set("anim/50/button",0)		
	end,
	function () 
		if get("anim/50/button") == 0 then
			set("anim/50/button/anim",1)
			set("anim/50/button",1)
		else
			set("anim/50/button/anim",0)
			set("anim/50/button",0)	
		end
	end,
	function () return get("anim/50/button") end,null,
	function (value)
		set("anim/50/button/anim",value)
		set("anim/50/button",value)
	end)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

return sysAice
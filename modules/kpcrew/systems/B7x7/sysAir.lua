-- B7x7 FF B767 B757 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
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

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("B7x7 sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateCustomSwitch:new("pack1","1-sim/cond/leftPackSelector",0,
	function () 
		set("1-sim/cond/leftPackSelector/anim",1)
		set("1-sim/cond/leftPackSelector",1)		
	end,
	function () 
		set("1-sim/cond/leftPackSelector/anim",0)
		set("1-sim/cond/leftPackSelector",0)		
	end,
	function () 
		if get("1-sim/cond/leftPackSelector") == 0 then
			set("1-sim/cond/leftPackSelector/anim",1)
			set("1-sim/cond/leftPackSelector",1)
		else
			set("1-sim/cond/leftPackSelector/anim",0)
			set("1-sim/cond/leftPackSelector",0)	
		end
	end,
	function () return get("1-sim/cond/leftPackSelector") end,null,
	function (value)
		set("1-sim/cond/leftPackSelector/anim",value)
		set("1-sim/cond/leftPackSelector",value)
	end)
sysAir.packRightSwitch 		= TwoStateCustomSwitch:new("pack2","1-sim/cond/rightPackSelector",0,
	function () 
		set("1-sim/cond/rightPackSelector/anim",1)
		set("1-sim/cond/rightPackSelector",1)		
	end,
	function () 
		set("1-sim/cond/rightPackSelector/anim",0)
		set("1-sim/cond/rightPackSelector",0)		
	end,
	function () 
		if get("1-sim/cond/rightPackSelector") == 0 then
			set("1-sim/cond/rightPackSelector/anim",1)
			set("1-sim/cond/rightPackSelector",1)
		else
			set("1-sim/cond/rightPackSelector/anim",0)
			set("1-sim/cond/rightPackSelector",0)	
		end
	end,
	function () return get("1-sim/cond/rightPackSelector") end,null,
	function (value)
		set("1-sim/cond/rightPackSelector/anim",value)
		set("1-sim/cond/rightPackSelector",value)
	end)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateCustomSwitch:new("isolation","anim/59/button",0,
	function () 
		set("anim/59/button/anim",1)
		set("anim/59/button",1)		
	end,
	function () 
		set("anim/59/button/anim",0)
		set("anim/59/button",0)		
	end,
	function () 
		if get("anim/59/button") == 0 then
			set("anim/59/button/anim",1)
			set("anim/59/button",1)
		else
			set("anim/59/button/anim",0)
			set("anim/59/button",0)	
		end
	end,
	function () return get("anim/59/button") end,null,
	function (value)
		set("anim/59/button/anim",value)
		set("anim/59/button",value)
	end)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateCustomSwitch:new("bleed1","anim/60/button",0,
	function () 
		set("anim/60/button/anim",1)
		set("anim/60/button",1)		
	end,
	function () 
		set("anim/60/button/anim",0)
		set("anim/60/button",0)		
	end,
	function () 
		if get("anim/60/button") == 0 then
			set("anim/60/button/anim",1)
			set("anim/60/button",1)
		else
			set("anim/60/button/anim",0)
			set("anim/60/button",0)	
		end
	end,
	function () return get("anim/60/button") end,null,
	function (value)
		set("anim/60/button/anim",value)
		set("anim/60/button",value)
	end)
sysAir.bleedEng2Switch 		= TwoStateCustomSwitch:new("bleed1","anim/62/button",0,
	function () 
		set("anim/62/button/anim",1)
		set("anim/62/button",1)		
	end,
	function () 
		set("anim/62/button/anim",0)
		set("anim/62/button",0)		
	end,
	function () 
		if get("anim/62/button") == 0 then
			set("anim/62/button/anim",1)
			set("anim/62/button",1)
		else
			set("anim/62/button/anim",0)
			set("anim/62/button",0)	
		end
	end,
	function () return get("anim/62/button") end,null,
	function (value)
		set("anim/62/button/anim",value)
		set("anim/62/button",value)
	end)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateCustomSwitch:new("recirc1","anim/55/button",0,
	function () 
		set("anim/55/button/anim",1)
		set("anim/55/button",1)		
	end,
	function () 
		set("anim/55/button/anim",0)
		set("anim/55/button",0)		
	end,
	function () 
		if get("anim/55/button") == 0 then
			set("anim/55/button/anim",1)
			set("anim/55/button",1)
		else
			set("anim/55/button/anim",0)
			set("anim/55/button",0)	
		end
	end,
	function () return get("anim/55/button") end,null,
	function (value)
		set("anim/55/button/anim",value)
		set("anim/55/button",value)
	end)
sysAir.recircFanRight 		= TwoStateCustomSwitch:new("recirc2","anim/56/button",0,
	function () 
		set("anim/56/button/anim",1)
		set("anim/56/button",1)		
	end,
	function () 
		set("anim/56/button/anim",0)
		set("anim/56/button",0)		
	end,
	function () 
		if get("anim/56/button") == 0 then
			set("anim/56/button/anim",1)
			set("anim/56/button",1)
		else
			set("anim/56/button/anim",0)
			set("anim/56/button",0)	
		end
	end,
	function () return get("anim/56/button") end,null,
	function (value)
		set("anim/56/button/anim",value)
		set("anim/56/button",value)
	end)
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)

-- TRIM/RAM air
sysAir.trimAirSwitch 		= TwoStateCustomSwitch:new("trimair","anim/54/button",0,
	function () 
		set("anim/54/button/anim",1)
		set("anim/54/button",1)		
	end,
	function () 
		set("anim/54/button/anim",0)
		set("anim/54/button",0)		
	end,
	function () 
		if get("anim/54/button") == 0 then
			set("anim/54/button/anim",1)
			set("anim/54/button",1)
		else
			set("anim/54/button/anim",0)
			set("anim/54/button",0)	
		end
	end,
	function () return get("anim/54/button") end,null,
	function (value)
		set("anim/54/button/anim",value)
		set("anim/54/button",value)
	end)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateCustomSwitch:new("apubleed","anim/61/button",0,
	function () 
		set("anim/61/button/anim",1)
		set("anim/61/button",1)		
	end,
	function () 
		set("anim/61/button/anim",0)
		set("anim/61/button",0)		
	end,
	function () 
		if get("anim/61/button") == 0 then
			set("anim/61/button/anim",1)
			set("anim/61/button",1)
		else
			set("anim/61/button/anim",0)
			set("anim/61/button",0)	
		end
	end,
	function () return get("anim/61/button") end,null,
	function (value)
		set("anim/61/button/anim",value)
		set("anim/61/button",value)
	end)

-- Landing Altitude
sysAir.landingAltitude		= TwoStateCustomSwitch:new("landingalt","1-sim/press/landingAltitudeSelector",9,null,null,null,
	function () return get("1-sim/press/landingAltitudeSelector")*1000+2000 end,null,
	function (value) set("1-sim/press/landingAltitudeSelector",(value-2000)/1000) end)
	
return sysAir
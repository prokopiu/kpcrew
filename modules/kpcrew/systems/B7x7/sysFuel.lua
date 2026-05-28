-- B7x7 FF 767 & 757 airplane 
-- Fuel related functionality

-- @classmod sysFuel
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
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

logMsg("B7x7 sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateCustomSwitch:new("fuelpumpleftaft","anim/32/button",0,
	function () 
		set("anim/32/button/anim",1)
		set("anim/32/button",1)		
	end,
	function () 
		set("anim/32/button/anim",0)
		set("anim/32/button",0)		
	end,
	function () 
		if get("anim/32/button") == 0 then
			set("anim/32/button/anim",1)
			set("anim/32/button",1)
		else
			set("anim/32/button/anim",0)
			set("anim/32/button",0)	
		end
	end,
	function () return get("anim/32/button") end,null,
	function (value)
		set("anim/32/button/anim",value)
		set("anim/32/button",value)
	end)
sysFuel.fuelPumpRightAft 	= TwoStateCustomSwitch:new("fuelpumprightaft","anim/34/button",0,
	function () 
		set("anim/34/button/anim",1)
		set("anim/34/button",1)		
	end,
	function () 
		set("anim/34/button/anim",0)
		set("anim/34/button",0)		
	end,
	function () 
		if get("anim/34/button") == 0 then
			set("anim/34/button/anim",1)
			set("anim/34/button",1)
		else
			set("anim/34/button/anim",0)
			set("anim/34/button",0)	
		end
	end,
	function () return get("anim/34/button") end,null,
	function (value)
		set("anim/34/button/anim",value)
		set("anim/34/button",value)
	end)
sysFuel.fuelPump3		 	= TwoStateCustomSwitch:new("fuelpumpctrleft","anim/38/button",0,
	function () 
		if get("sim/flightmodel/weight/m_fuel2") > 200 then
			set("anim/38/button/anim",1)
			set("anim/38/button",1)	
		end
	end,
	function () 
		set("anim/38/button/anim",0)
		set("anim/38/button",0)		
	end,
	function () 
		if get("anim/38/button") == 0 then
			if get("sim/flightmodel/weight/m_fuel2") > 200 then
				set("anim/38/button/anim",1)
				set("anim/38/button",1)
			end
		else
			set("anim/38/button/anim",0)
			set("anim/38/button",0)	
		end
	end,
	function () return get("anim/38/button") end,null,
	function (value)
		set("anim/38/button/anim",value)
		set("anim/38/button",value)
	end)
sysFuel.fuelPump4		 	= TwoStateCustomSwitch:new("fuelpumpctrleft","anim/39/button",0,
	function () 
		if get("sim/flightmodel/weight/m_fuel2") > 200 then
			set("anim/39/button/anim",1)
			set("anim/39/button",1)	
		end
	end,
	function () 
		set("anim/39/button/anim",0)
		set("anim/39/button",0)		
	end,
	function () 
		if get("anim/39/button") == 0 then
			if get("sim/flightmodel/weight/m_fuel2") > 200 then
				set("anim/39/button/anim",1)
				set("anim/39/button",1)
			end
		else
			set("anim/39/button/anim",0)
			set("anim/39/button",0)	
		end
	end,
	function () return get("anim/39/button") end,null,
	function (value)
		set("anim/39/button/anim",value)
		set("anim/39/button",value)
	end)
sysFuel.fuelPump5		 	= TwoStateCustomSwitch:new("fuelpumpfwdleft","anim/35/button",0,
	function () 
		set("anim/35/button/anim",1)
		set("anim/35/button",1)		
	end,
	function () 
		set("anim/35/button/anim",0)
		set("anim/35/button",0)		
	end,
	function () 
		if get("anim/35/button") == 0 then
			set("anim/35/button/anim",1)
			set("anim/35/button",1)
		else
			set("anim/35/button/anim",0)
			set("anim/35/button",0)	
		end
	end,
	function () return get("anim/35/button") end,null,
	function (value)
		set("anim/35/button/anim",value)
		set("anim/35/button",value)
	end)
sysFuel.fuelPump6		 	= TwoStateCustomSwitch:new("fuelpumpfwdright","anim/37/button",0,
	function () 
		set("anim/37/button/anim",1)
		set("anim/37/button",1)		
	end,
	function () 
		set("anim/37/button/anim",0)
		set("anim/37/button",0)		
	end,
	function () 
		if get("anim/37/button") == 0 then
			set("anim/37/button/anim",1)
			set("anim/37/button",1)
		else
			set("anim/37/button/anim",0)
			set("anim/37/button",0)	
		end
	end,
	function () return get("anim/37/button") end,null,
	function (value)
		set("anim/37/button/anim",value)
		set("anim/37/button",value)
	end)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)

sysFuel.fuelCrossFeed 		= SwitchGroup:new("crossfeedgroup")
sysFuel.fuelCrossFeed1		= TwoStateCustomSwitch:new("crossfeedleft","anim/33/button",0,
	function () 
		set("anim/33/button/anim",1)
		set("anim/33/button",1)		
	end,
	function () 
		set("anim/33/button/anim",0)
		set("anim/33/button",0)		
	end,
	function () 
		if get("anim/33/button") == 0 then
			set("anim/33/button/anim",1)
			set("anim/33/button",1)
		else
			set("anim/33/button/anim",0)
			set("anim/33/button",0)	
		end
	end,
	function () return get("anim/33/button") end,null,
	function (value)
		set("anim/33/button/anim",value)
		set("anim/33/button",value)
	end)
sysFuel.fuelCrossFeed2		= TwoStateCustomSwitch:new("crossfeedrgt","anim/36/button",0,
	function () 
		set("anim/36/button/anim",1)
		set("anim/36/button",1)		
	end,
	function () 
		set("anim/36/button/anim",0)
		set("anim/36/button",0)		
	end,
	function () 
		if get("anim/36/button") == 0 then
			set("anim/36/button/anim",1)
			set("anim/36/button",1)
		else
			set("anim/36/button/anim",0)
			set("anim/36/button",0)	
		end
	end,
	function () return get("anim/36/button") end,null,
	function (value)
		set("anim/36/button/anim",value)
		set("anim/36/button",value)
	end)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed1)	
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed2)	

return sysFuel
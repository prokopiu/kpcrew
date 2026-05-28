-- B7x7 FF B757 / 767 airplane 
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

logMsg("B7x7 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","anim/14/button",0,
	function () 
		set("anim/14/button/anim",1)
		set("anim/14/button",1)		
	end,
	function () 
		set("anim/14/button/anim",0)
		set("anim/14/button",0)		
	end,
	function () 
		if get("anim/14/button") == 0 then
			set("anim/14/button/anim",1)
			set("anim/14/button",1)
		else
			set("anim/14/button/anim",0)
			set("anim/14/button",0)	
		end
	end,
	function () return get("anim/14/button") end,null,
	function (value)
		set("anim/14/button/anim",value)
		set("anim/14/button",value)
	end)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateCustomSwitch:new("gen1","anim/22/button",0,
	function () 
		set("anim/22/button/anim",1)
		set("anim/22/button",1)		
	end,
	function () 
		set("anim/22/button/anim",0)
		set("anim/22/button",0)		
	end,
	function () 
		if get("anim/22/button") == 0 then
			set("anim/22/button/anim",1)
			set("anim/22/button",1)
		else
			set("anim/22/button/anim",0)
			set("anim/22/button",0)	
		end
	end,
	function () return get("anim/22/button") end,null,
	function (value)
		set("anim/22/button/anim",value)
		set("anim/22/button",value)
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 		= TwoStateCustomSwitch:new("gen2","anim/25/button",0,
	function () 
		set("anim/25/button/anim",1)
		set("anim/25/button",1)		
	end,
	function () 
		set("anim/25/button/anim",0)
		set("anim/25/button",0)		
	end,
	function () 
		if get("anim/25/button") == 0 then
			set("anim/25/button/anim",1)
			set("anim/25/button",1)
		else
			set("anim/25/button/anim",0)
			set("anim/25/button",0)	
		end
	end,
	function () return get("anim/25/button") end,null,
	function (value)
		set("anim/25/button/anim",value)
		set("anim/25/button",value)
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateCustomSwitch:new("aviobus1","anim/20/button",0,
	function () 
		set("anim/20/button/anim",1)
		set("anim/20/button",1)		
	end,
	function () 
		set("anim/20/button/anim",0)
		set("anim/20/button",0)		
	end,
	function () 
		if get("anim/20/button") == 0 then
			set("anim/20/button/anim",1)
			set("anim/20/button",1)
		else
			set("anim/20/button/anim",0)
			set("anim/20/button",0)	
		end
	end,
	function () return get("anim/20/button") end,null,
	function (value)
		set("anim/20/button/anim",value)
		set("anim/20/button",value)
	end)
sysElectric.avionics2Bus		= TwoStateCustomSwitch:new("aviobus2","anim/21/button",0,
	function () 
		set("anim/21/button/anim",1)
		set("anim/21/button",1)		
	end,
	function () 
		set("anim/21/button/anim",0)
		set("anim/21/button",0)		
	end,
	function () 
		if get("anim/21/button") == 0 then
			set("anim/21/button/anim",1)
			set("anim/21/button",1)
		else
			set("anim/21/button/anim",0)
			set("anim/21/button",0)	
		end
	end,
	function () return get("anim/21/button") end,null,
	function (value)
		set("anim/21/button/anim",value)
		set("anim/21/button",value)
	end)
sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- DC Bus Tie
sysElectric.dcBusTie			= TwoStateCustomSwitch:new("dcbustie","anim/17/button",0,
	function () 
		set("anim/17/button/anim",1)
		set("anim/17/button",1)		
	end,
	function () 
		set("anim/17/button/anim",0)
		set("anim/17/button",0)		
	end,
	function () 
		if get("anim/17/button") == 0 then
			set("anim/17/button/anim",1)
			set("anim/17/button",1)
		else
			set("anim/17/button/anim",0)
			set("anim/17/button",0)	
		end
	end,
	function () return get("anim/17/button") end,null,
	function (value)
		set("anim/17/button/anim",value)
		set("anim/17/button",value)
	end)
	
-- AC Bus Tie
sysElectric.acBusTie				= TwoStateCustomSwitch:new("acbustie","anim/18/button",0,
	function () 
		set("anim/18/button/anim",1)
		set("anim/18/button",1)		
	end,
	function () 
		set("anim/18/button/anim",0)
		set("anim/18/button",0)		
	end,
	function () 
		if get("anim/18/button") == 0 then
			set("anim/18/button/anim",1)
			set("anim/18/button",1)
		else
			set("anim/18/button/anim",0)
			set("anim/18/button",0)	
		end
	end,
	function () return get("anim/18/button") end,null,
	function (value)
		set("anim/18/button/anim",value)
		set("anim/18/button",value)
	end)

-- standby power
sysElectric.stbyPowerSwitch = TwoStateCustomSwitch:new("standbypwr","1-sim/electrical/stbyPowerSelector",0,
	function ()
		set("1-sim/electrical/stbyPowerSelector",1)
		set("1-sim/electrical/stbyPowerSelector/anim",1)
		set("anim/rhotery/6",1)
	end,
	function ()
		set("1-sim/electrical/stbyPowerSelector",0)
		set("1-sim/electrical/stbyPowerSelector/anim",0)
		set("anim/rhotery/6",0)
	end,
	function ()
	end,
	function ()
		return get("1-sim/electrical/stbyPowerSelector")
	end,null,
	function (value)
		set("1-sim/electrical/stbyPowerSelector",value)
		set("1-sim/electrical/stbyPowerSelector/anim",value)
		set("anim/rhotery/6",value)
	end)

-- GPU
sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","params/gpu",0)
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBus1 		= TwoStateCustomSwitch:new("gpubus1","anim/16/button",0,
	function () 
		if get("war/overhead/left/124") == 0 then
			set("anim/16/button/anim",1)
			set("anim/16/button",1)
		end
	end,
	function () 
		if get("war/overhead/left/124") > 0 then
			set("anim/16/button/anim",1)
			set("anim/16/button",1)
		end
	end,
	function () 
		set("anim/16/button/anim",1)
		set("anim/16/button",1)
	end,
	function () 
		if get("war/overhead/left/124") > 0 then
			return 1
		else
			return 0
		end
	end)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuOnBus = CustomAnnunciator:new("",
	function () 
		if get("war/overhead/left/124") > 0 then
			return 1
		else
			return 0
		end
	end)

-- APU
sysElectric.apuMaster	 	= TwoStateCustomSwitch:new("apuswitch","1-sim/engine/APUStartSelector",0,
	function ()
		local ndmod = get("1-sim/engine/APUStartSelector")
		if ndmod < 2 then
			set("1-sim/engine/APUStartSelector",ndmod+1)
			set("1-sim/engine/APUStartSelector/anim",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("1-sim/electrical/stbyPowerSelector")
		if ndmod > 0 then
			set("1-sim/engine/APUStartSelector",ndmod-1)
			set("1-sim/engine/APUStartSelector/anim",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		if get("1-sim/engine/APUStartSelector") > 0 then 
			return 1
		else
			return 0
		end
	end,null,
	function (value)
		set("1-sim/engine/APUStartSelector",value)
		set("1-sim/engine/APUStartSelector/anim",value)
	end)
sysElectric.apuStartSwitch 	= TwoStateCustomSwitch:new("apuswitch","1-sim/engine/APUStartSelector",0,
	function ()
		local ndmod = get("1-sim/engine/APUStartSelector")
		if ndmod < 2 then
			set("1-sim/engine/APUStartSelector",ndmod+1)
			set("1-sim/engine/APUStartSelector/anim",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("1-sim/electrical/stbyPowerSelector")
		if ndmod > 0 then
			set("1-sim/engine/APUStartSelector",ndmod-1)
			set("1-sim/engine/APUStartSelector/anim",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		if get("1-sim/engine/APUStartSelector") > 0 then 
			return 1
		else
			return 0
		end
	end,null,
	function (value)
		set("1-sim/engine/APUStartSelector",value)
		set("1-sim/engine/APUStartSelector/anim",value)
	end)
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuGenBus1 		= TwoStateCustomSwitch:new("apugen","anim/15/button",0,
	function () 
		set("anim/15/button/anim",1)
		set("anim/15/button",1)		
	end,
	function () 
		set("anim/15/button/anim",0)
		set("anim/15/button",0)		
	end,
	function () 
		if get("anim/15/button") == 0 then
			set("anim/15/button/anim",1)
			set("anim/15/button",1)
		else
			set("anim/15/button/anim",0)
			set("anim/15/button",0)	
		end
	end,
	function () return get("anim/15/button") end,null,
	function (value)
		set("anim/15/button/anim",value)
		set("anim/15/button",value)
	end)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)


return sysElectric

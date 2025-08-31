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
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","anim/14/button",0)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1","anim/22/button",0)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 		= TwoStateDrefSwitch:new("gen2","anim/25/button",0)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateDrefSwitch:new("aviobus1","anim/20/button",0)
sysElectric.avionics2Bus		= TwoStateDrefSwitch:new("aviobus2","anim/21/button",0)
sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- DC Bus Tie
sysElectric.dcBusTie			= TwoStateCustomSwitch:new("dcbustie","anim/17/button",0,
function ()
	set("anim/17/button",1)
end,
function ()
	set("anim/17/button",0)
end,
function ()
	if get("anim/17/button") == 1 then
		set("anim/17/button",0)
	else
		set("anim/17/button",1)
	end
end,
function () 
	return get("anim/17/button")
end)
-- AC Bus Tie
sysElectric.acBusTie				= TwoStateCustomSwitch:new("acbustie","anim/18/button",0,
function ()
	set("anim/18/button",1)
end,
function ()
	set("anim/18/button",0)
end,
function ()
	if get("anim/18/button") == 1 then
		set("anim/18/button",0)
	else
		set("anim/18/button",1)
	end
end,
function () 
	return get("anim/18/button")
end)

-- standby power
sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("stbySwitch","1-sim/electrical/stbyPowerSelector",0)

-- GPU
sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","params/gpu",0)
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","war/overhead/left/124",0,
function ()
	if get("war/overhead/left/124") == 0 then
		set("anim/16/button",1)
	end
end,
function ()
	if get("war/overhead/left/124") > 0 then
		set("anim/16/button",1)
	end
end,
function ()
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
sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","1-sim/eng/APUswitch",0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","1-sim/eng/APUswitch",0)
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuGenBus1 		= TwoStateCustomSwitch:new("apubus1","anim/15/button",0,
function ()
	set("anim/15/button",1)
end,
function ()
	set("anim/15/button",0)
end,
function ()
	if get("anim/15/button") == 1 then
		set("anim/15/button",0)
	else
		set("anim/15/button",1)
	end
end,
function () 
	return get("anim/15/button")
end)
sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

return sysElectric

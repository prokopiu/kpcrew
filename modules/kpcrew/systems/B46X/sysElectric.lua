-- B46X airplane 
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

logMsg("B46X sysElectric")

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateCustomSwitch:new("gen1","thranda/electrical/GEN_1_Switch",0,
	function ()
		set("thranda/electrical/GEN_1_Switch",2)
	end,
	function ()
		set("thranda/electrical/GEN_1_Switch",1)
	end,
	function ()
		if get("thranda/electrical/GEN_1_Switch") == 1 then
			set("thranda/electrical/GEN_1_Switch",2)
		else
			set("thranda/electrical/GEN_1_Switch",1)
		end
	end,
	function ()
		if get("thranda/electrical/GEN_1_Switch") == 2 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 	= TwoStateCustomSwitch:new("gen2","thranda/electrical/GEN_4_Switch",0,
	function ()
		set("thranda/electrical/GEN_4_Switch",2)
	end,
	function ()
		set("thranda/electrical/GEN_4_Switch",1)
	end,
	function ()
		if get("thranda/electrical/GEN_4_Switch") == 1 then
			set("thranda/electrical/GEN_4_Switch",2)
		else
			set("thranda/electrical/GEN_4_Switch",1)
		end
	end,
	function ()
		if get("thranda/electrical/GEN_4_Switch") == 2 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateDrefSwitch:new("dcbustie","thranda/electrical/BusTieDC",0)
-- AC Bus Tie
sysElectric.acBusTie				= TwoStateDrefSwitch:new("acbustie","thranda/electrical/BusTieAC",0)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateDrefSwitch:new("aviobus1","thranda/electrical/AvionicsBus",0)
sysElectric.avionics2Bus		= TwoStateDrefSwitch:new("aviobus2","thranda/electrical/Avionics2",0)
sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- standby power
sysElectric.stbyPowerSwitch = TwoStateCustomSwitch:new("stbySwitches","thranda/electrical/StbyGen",0,
	function ()
		set("thranda/electrical/StbyGen",2)
		set("thranda/electrical/StbyInv",2)
	end,
	function ()
		set("thranda/electrical/StbyGen",1)
		set("thranda/electrical/StbyInv",1)
	end,
	function ()
		if get("thranda/electrical/StbyGen") == 2 then
			set("thranda/electrical/StbyGen",1)
			set("thranda/electrical/StbyInv",1)
		else
			set("thranda/electrical/StbyGen",2)
			set("thranda/electrical/StbyInv",2)
		end
	end,
	function ()
	end)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","thranda/electrical/ExtPwrGPUAvailable",0)	
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","thranda/electrical/ExtPwrGPUSw",0)
sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","thranda/electrical/StartStopAPU",0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","thranda/electrical/StartStopAPU",0)
sysElectric.apuGenBus1 		= TwoStateCustomSwitch:new("apubus1","thranda/electrical/APU_GEN_Switch",0,
	function ()
		set("thranda/electrical/APU_GEN_Switch",2)
	end,
	function ()
		set("thranda/electrical/APU_GEN_Switch",1)
	end,
	function ()
		if get("thranda/electrical/APU_GEN_Switch") == 2 then
			set("thranda/electrical/APU_GEN_Switch",1)
		else
			set("thranda/electrical/APU_GEN_Switch",2)
		end
	end,
	function ()
		if get("thranda/electrical/APU_GEN_Switch") == 2 then
			return 1
		else
			return 0
		end
	end)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","thranda/electrical/ExtPwrGPUSw",0)

return sysElectric

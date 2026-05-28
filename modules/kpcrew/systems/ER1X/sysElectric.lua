-- ER1X airplane 
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

logMsg("ER1X sysElectric")

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateDrefSwitch:new("aviobus1",
"sim/cockpit/electrical/avionics_EQ",0)
sysElectric.avionics2Bus		= TwoStateDrefSwitch:new("aviobus2",
"sim/cockpit/electrical/avionics_on",0)
sysElectric.avionicsSwitchGroup = SwitchGroup:new("avionics")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- GPU
sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","XCrafts/other/GPU",0,
	function () 
		set("XCrafts/other/GPU",0)
	end,
	function () 
		set("XCrafts/other/GPU",1)
	end,
	function () 
		if get("XCrafts/other/GPU") == 0 then
			set("XCrafts/other/GPU",1)
		else
			set("XCrafts/other/GPU",0)
		end
	end,
	function ()
		if get("XCrafts/other/GPU") == 0 then
			return 1
		else
			return 0
		end		
	end)
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","XCrafts/electric/GPU_sw",0)
sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","XCrafts/electric/GPU_sw",0)

return sysElectric

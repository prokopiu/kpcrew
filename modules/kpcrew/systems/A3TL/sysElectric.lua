-- ToLiss Airbusses
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

logMsg("A3TL sysElectric")

-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("battery1","AirbusFBW/BatOHPArray",-1,
	"toliss_airbus/eleccommands/Bat1On","toliss_airbus/eleccommands/Bat1Off","toliss_airbus/eleccommands/Bat1Toggle")
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2","AirbusFBW/BatOHPArray",1,
	"toliss_airbus/eleccommands/Bat2On","toliss_airbus/eleccommands/Bat2Off","toliss_airbus/eleccommands/Bat2Toggle")
sysElectric.batteryGroup:addSwitch(battery2Switch)
if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	sysElectric.battery3Switch 	= TwoStateDrefSwitch:new("battery3","AirbusFBW/ElecOHPArray",16)
	sysElectric.batteryGroup:addSwitch(battery3Switch)
end

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1",
	"AirbusFBW/ElecOHPArray",-1)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
if kc_get_nr_generators() > 1 then
	sysElectric.gen2Switch 	= TwoStateDrefSwitch:new("gen2",
		"AirbusFBW/ElecOHPArray",1)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
end
if kc_get_nr_generators() > 2 then
	sysElectric.gen3Switch 	= TwoStateDrefSwitch:new("gen3",
		"AirbusFBW/ElecOHPArray",2)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
end
if kc_get_nr_generators() > 3 then
	sysElectric.gen4Switch 	= TwoStateDrefSwitch:new("gen4",
		"AirbusFBW/ElecOHPArray",3)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)
end

-- de-/activate GPU
if PLANE_ICAO ~= "A339" then
	sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","AirbusFBW/EnableExternalPower",0)
else
	sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","AirbusFBW/EnableExternalPower",0,
	function ()
		set("AirbusFBW/EnableExternalPower",1)
		set("AirbusFBW/EnableExternalPowerB",1)
	end,
	function ()
		set("AirbusFBW/EnableExternalPower",0)
		set("AirbusFBW/EnableExternalPowerB",0)
	end,
	function ()
		if get("AirbusFBW/EnableExternalPower") == 0 then
			set("AirbusFBW/EnableExternalPower",1)
			set("AirbusFBW/EnableExternalPowerB",1)
		else
			set("AirbusFBW/EnableExternalPower",0)
			set("AirbusFBW/EnableExternalPowerB",0)
		end
	end,
	function ()
		if get("AirbusFBW/EnableExternalPower") ~= 0 then
			return 1
		else
			return 0
		end
	end)
end
-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBus1 		= TwoStateCmdSwitch:new("gpubus1","AirbusFBW/ExtPowOHPArray",-1,
	"toliss_airbus/eleccommands/ExtPowOn","toliss_airbus/eleccommands/ExtPowOff","toliss_airbus/eleccommands/ExtPowToggle")
if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	sysElectric.gpuGenBus2 		= TwoStateCmdSwitch:new("gpubus2","AirbusFBW/ExtPowOHPArray",1,
	"toliss_airbus/eleccommands/ExtPowAOn","toliss_airbus/eleccommands/ExtPowAOff","toliss_airbus/eleccommands/ExtPowAToggle")
else
	sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
end
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.gpuOnBus = CustomAnnunciator:new("gpubuson",
function ()
	if get("AirbusFBW/ExtPowOHPArray",0) == 1 then
		return 1
	else
		return 0
	end
end)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
if kc_has_apu then
	sysElectric.apuMaster 		= TwoStateDrefSwitch:new("apuswitch","AirbusFBW/APUMaster",0)
	sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","AirbusFBW/APUStarter",0)
	sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","AirbusFBW/APUGenOHPArray",-1)
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
else
	sysElectric.apuStartSwitch 	= InopSwitch:new("apuswitch")
	sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
end
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- ---- Inverters
sysElectric.inverter1Switch 		= TwoStateDrefSwitch:new("inverter1","AirbusFBW/ElecOHPArray",7)
sysElectric.inverter2Switch 		= InopSwitch:new("inverter2")
sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter1Switch)
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter2Switch)

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateDrefSwitch:new("dcbustie","AirbusFBW/ElecOHPArray",4)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("AirbusFBW/APUN") > 98 then
			return 1
		else
			return 0
		end
	end)

return sysElectric

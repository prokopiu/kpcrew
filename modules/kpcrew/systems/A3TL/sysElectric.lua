-- ToLiss Airbusses
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysElectric.batteryGroup 	
-- sysElectric.batterySwitch 	
-- sysElectric.battery2Switch 	
-- sysElectric.battery3Switch 	+
-- sysElectric.genSwitchGroup
-- sysElectric.gen1Switch
-- sysElectric.gen2Switch
-- sysElectric.gen3Switch
-- sysElectric.gen4Switch
-- sysElectric.gpuGenBusGroup
-- sysElectric.gpuConnect
-- sysElectric.gpuGenBus1
-- sysElectric.gpuGenBus2
-- sysElectric.apuGenBusGroup
-- sysElectric.apuMaster	 
-- sysElectric.apuStartSwitch
-- sysElectric.apuGenBus1 	
-- sysElectric.apuGenBus2 	
-- sysElectric.apuRunningAnc
-- sysElectric.dcBusTie	
-- sysElectric.inverter1Switch 		
-- sysElectric.inverter2Switch 		
-- sysElectric.inverterSwitchGroup 	
-- sysElectric.gpuOnBus
-- Macro: kc_bck_apustart
-- Macro: kc_bck_apuonline

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

--------- Switch datarefs common
local drefBattery1			= "AirbusFBW/BatOHPArray"
local drefBattery3			= "AirbusFBW/ElecOHPArray"
local drefGenerator1		= "AirbusFBW/ElecOHPArray"
local drefGPUOn				= "AirbusFBW/EnableExternalPower"
local drefGPUGenerator		= "AirbusFBW/ExtPowOHPArray"
local drefAPUStarter		= "AirbusFBW/APUStarter"
local drefAPUMaster			= "AirbusFBW/APUMaster"
local drefAPUGenerator		= "AirbusFBW/APUGenOHPArray"
local drefInverter1			= "AirbusFBW/ElecOHPArray"
local drefDCBusTie			= "AirbusFBW/ElecOHPArray"

--------- Switch commands common
local cmdBattery1On			= "toliss_airbus/eleccommands/Bat1On"
local cmdBattery2On			= "toliss_airbus/eleccommands/Bat2On"
local cmdBattery1Off		= "toliss_airbus/eleccommands/Bat1Off"
local cmdBattery2Off		= "toliss_airbus/eleccommands/Bat2Off"
local cmdBattery1Tgl		= "toliss_airbus/eleccommands/Bat1Tgl"
local cmdBattery2Tgl		= "toliss_airbus/eleccommands/Bat2Tgl"
local cmdGPUGenBus1On		= "toliss_airbus/eleccommands/ExtPowOn"
local cmdGPUGenBus1Off		= "toliss_airbus/eleccommands/ExtPowOff"	
local cmdGPUGenBus1Tgl		= "toliss_airbus/eleccommands/ExtPowToggle"
local cmdGPUGenBus2On		= "toliss_airbus/eleccommands/ExtPowAOn"
local cmdGPUGenBus2Off		= "toliss_airbus/eleccommands/ExtPowAOff"	
local cmdGPUGenBus2Tgl		= "toliss_airbus/eleccommands/ExtPowAToggle"
local cmdGPUGenBus3On		= "toliss_airbus/eleccommands/ExtPowOn"
local cmdGPUGenBus3Off		= "toliss_airbus/eleccommands/ExtPowOff"	
local cmdGPUGenBus3Tgl		= "toliss_airbus/eleccommands/ExtPowToggle"

--------- Annunciator datarefs common
local drefAPUN1				= "AirbusFBW/APUN"

logMsg("A3TL sysElectric")

-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("battery1",drefBattery1,-1,
	cmdBattery1On,cmdBattery1Off,cmdBattery1Tgl)
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2",drefBattery1,1,
	cmdBattery2On,cmdBattery2Off,cmdBattery2Tgl)
sysElectric.batteryGroup:addSwitch(battery2Switch)
if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	sysElectric.battery3Switch 	= TwoStateDrefSwitch:new("battery3",drefBattery3,16)
	sysElectric.batteryGroup:addSwitch(battery3Switch)
end

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1",drefGenerator1,-1)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
if kc_get_nr_generators() > 1 then
	sysElectric.gen2Switch 	= TwoStateDrefSwitch:new("gen2",drefGenerator1,1)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
end
if kc_get_nr_generators() > 2 then
	sysElectric.gen3Switch 	= TwoStateDrefSwitch:new("gen3",drefGenerator1,2)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
end
if kc_get_nr_generators() > 3 then
	sysElectric.gen4Switch 	= TwoStateDrefSwitch:new("gen4",drefGenerator1,3)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)
end

-- de-/activate GPU
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU",drefGPUOn,0)
else
	sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU",drefGPUOn,0,
	function ()
		set(drefGPUOn,1)
		if PLANE_ICAO == "A339" then
			set("AirbusFBW/EnableExternalPowerB",1)
		end
	end,
	function ()
		set(drefGPUOn,0)
		if PLANE_ICAO == "A339" then
			set("AirbusFBW/EnableExternalPowerB",0)
		end
	end,
	function ()
		if get(drefGPUOn) == 0 then
			set(drefGPUOn,1)
			if PLANE_ICAO == "A339" then
				set("AirbusFBW/EnableExternalPowerB",1)
			end
		else
			set(drefGPUOn,0)
			if PLANE_ICAO == "A339" then
				set("AirbusFBW/EnableExternalPowerB",0)
			end
		end
	end,
	function ()
		if get(drefGPUOn) ~= 0 then
			return 1
		else
			return 0
		end
	end)
end
-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	sysElectric.gpuGenBus1 		= TwoStateCmdSwitch:new("gpubus1",drefGPUGenerator,-1,
		cmdGPUGenBus1On,cmdGPUGenBus1Off,cmdGPUGenBus1Tgl)
	sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
else
	if PLANE_ICAO == "A339" then
		sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1",drefGPUGenerator,15)
		sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
		sysElectric.gpuGenBus2 		= TwoStateDrefSwitch:new("gpubus2",drefGPUGenerator,3)
		sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)
	end
	if PLANE_ICAO == "A346" then
		sysElectric.gpuGenBus1 		= TwoStateCmdSwitch:new("gpubus1",drefGPUGenerator,-1,
			cmdGPUGenBus2On,cmdGPUGenBus2Off,cmdGPUGenBus2Tgl)
		sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
		sysElectric.gpuGenBus2 		= TwoStateCmdSwitch:new("gpubus2",drefGPUGenerator,1,
			cmdGPUGenBus3On,cmdGPUGenBus3Off,cmdGPUGenBus3Tgl)
		sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)
	end
end

sysElectric.gpuOnBus = CustomAnnunciator:new("gpubuson",
function ()
	if get(drefGPUGenerator,0) == 1 then
		return 1
	else
		return 0
	end
end)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
if kc_has_apu then
	sysElectric.apuMaster 		= TwoStateDrefSwitch:new("apuswitch",drefAPUMaster,0)
	sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch",drefAPUStarter,0)
	sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1",drefAPUGenerator,-1)
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
else
	sysElectric.apuStartSwitch 	= InopSwitch:new("apuswitch")
	sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
end
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- ---- Inverters
sysElectric.inverter1Switch 		= TwoStateDrefSwitch:new("inverter1",drefInverter1,7)
sysElectric.inverter2Switch 		= InopSwitch:new("inverter2")
sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter1Switch)
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter2Switch)

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateDrefSwitch:new("dcbustie",drefDCBusTie,4)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get(drefAPUN1) > 98 then
			return 1
		else
			return 0
		end
	end)

--------- Macros

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,3)
		set("AirbusFBW/APUMaster",1)
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysElectric.apuStartSwitch:setValue(1)
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get("AirbusFBW/APUAvail") == 1 then
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

return sysElectric

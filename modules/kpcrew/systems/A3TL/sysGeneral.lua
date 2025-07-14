-- ToLiss Airbusses
-- aircraft general systems

-- @classmod sysGeneral
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("A3TL sysGeneral")

-- Optional Gound objects
sysGeneral.groundObjects = TwoStateDrefSwitch:new("ground objects","xcraft/other/ground_objects",0)

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateCmdSwitch:new("parkbrake","AirbusFBW/ParkBrake",0,
		"toliss_airbus/park_brake_set","toliss_airbus/park_brake_release","toliss_airbus/park_brake_toggle")
sysGeneral.parkbrakeAnc 	= SimpleAnnunciator:new("parkbrake","AirbusFBW/ParkBrake",0)

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","AirbusFBW/LeftWiperSwitch",0)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperright","AirbusFBW/RightWiperSwitch",0)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1","AirbusFBW/ADIRUSwitchArray",-1)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2","AirbusFBW/ADIRUSwitchArray",1)
sysGeneral.irsUnit3Switch 	= TwoStateDrefSwitch:new("irsunit3","AirbusFBW/ADIRUSwitchArray",2)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

-- Baro standard toggle
sysGeneral.barostdPilot 	= TwoStateDrefSwitch:new("barostdpilot","AirbusFBW/BaroStdCapt",0)
sysGeneral.barostdCopilot 	= TwoStateDrefSwitch:new("barostdcopilot","AirbusFBW/BaroStdFO",0)
sysGeneral.barostdStandby 	= TwoStateDrefSwitch:new("barostdstandby","AirbusFBW/ISIBaroStd",0)
sysGeneral.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdPilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdCopilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdStandby)

-- baro mbar/inhg
sysGeneral.baroMbar 		= TwoStateCustomSwitch:new("mbar","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",0,
function () end,
function () end,
function () end,
function () 
	return string.format("%04.0f",get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") * 33.8639)
end,
function () end,
function (value) 
	return value / 33.87
end)

sysGeneral.baroInhg 		= TwoStateCustomSwitch:new("inhg","sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",0,
function () end,
function () end,
function () end,
function () 
	return string.format("%05.2f",get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"))
end)

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1","AirbusFBW/PaxDoorModeArray",-1,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",0,2)
	end,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",0,0)
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",0) == 0 then
			set_array("AirbusFBW/PaxDoorModeArray",0,2)
		else
			set_array("AirbusFBW/PaxDoorModeArray",0,0)
		end
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",0) == 2 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorL2			= TwoStateCustomSwitch:new("doorl2","AirbusFBW/PaxDoorModeArray",2,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",2,2)
	end,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",2,0)
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",2) == 0 then
			set_array("AirbusFBW/PaxDoorModeArray",2,2)
		else
			set_array("AirbusFBW/PaxDoorModeArray",2,0)
		end
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",2) == 2 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR1			= TwoStateCustomSwitch:new("doorr1","AirbusFBW/PaxDoorModeArray",1,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",1,2)
	end,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",1,0)
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",1) == 0 then
			set_array("AirbusFBW/PaxDoorModeArray",1,2)
		else
			set_array("AirbusFBW/PaxDoorModeArray",1,0)
		end
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",1) == 2 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorR2			= TwoStateCustomSwitch:new("doorr2","AirbusFBW/PaxDoorModeArray",3,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",3,2)
	end,
	function () 
		set_array("AirbusFBW/PaxDoorModeArray",3,0)
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",3) == 0 then
			set_array("AirbusFBW/PaxDoorModeArray",3,2)
		else
			set_array("AirbusFBW/PaxDoorModeArray",3,0)
		end
	end,
	function () 
		if get("AirbusFBW/PaxDoorModeArray",3) == 2 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorFCargo 		= TwoStateCustomSwitch:new("doorfcargo","AirbusFBW/CargoDoorModeArray",-1,
	function () 
		set_array("AirbusFBW/CargoDoorModeArray",0,2)
	end,
	function () 
		set_array("AirbusFBW/CargoDoorModeArray",0,0)
	end,
	function () 
		if get("AirbusFBW/CargoDoorModeArrayy",0) == 0 then
			set_array("AirbusFBW/CargoDoorModeArray",0,2)
		else
			set_array("AirbusFBW/CargoDoorModeArray",0,0)
		end
	end,
	function () 
		if get("AirbusFBW/CargoDoorModeArray",0) == 2 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo","AirbusFBW/CargoDoorModeArray",1,
	function () 
		set_array("AirbusFBW/CargoDoorModeArray",1,2)
	end,
	function () 
		set_array("AirbusFBW/CargoDoorModeArray",1,0)
	end,
	function () 
		if get("AirbusFBW/CargoDoorModeArrayy",1) == 0 then
			set_array("AirbusFBW/CargoDoorModeArray",1,2)
		else
			set_array("AirbusFBW/CargoDoorModeArray",1,0)
		end
	end,
	function () 
		if get("AirbusFBW/CargoDoorModeArray",1) == 2 then
			return 1
		else
			return 0
		end
	end)
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	sysGeneral.cockpitDoor 		= TwoStateCustomSwitch:new("cockpitdoor","ckpt/door",0,
		function () 
				set("ckpt/doorLock",0)
				set("ckpt/door",80)
		end,
		function () 
				set("ckpt/doorLock",1)
				set("ckpt/door",0)
		end,
		function () 
		end,
		function () 
			if get("ckpt/door") > 0 then
				return 1
			else
				return 0
			end
		end)
else
	sysGeneral.cockpitDoor 		= TwoStateCustomSwitch:new("cockpitdoor","AirbusFBW/CockpitDoorAngle",0,
		function () 
				set("AirbusFBW/CockpitDoorSwitch",2)
				set("AirbusFBW/CockpitDoorAngle",90)
		end,
		function () 
				set("AirbusFBW/CockpitDoorAngle",0)
				set("AirbusFBW/CockpitDoorSwitch",0)
		end,
		function () 
		end,
		function () 
			if get("AirbusFBW/CockpitDoorAngle") > 80 then
				return 1
			else
				return 0
			end
		end)
end
sysGeneral.stairsL1 		= InopSwitch:new("stairs1")

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairsL1)

-- Door annunciators
sysGeneral.doorL1Anc 		= SimpleAnnunciator:new("doorl1","AirbusFBW/PaxDoorModeArray",-1)
sysGeneral.doorL2Anc 		= SimpleAnnunciator:new("doorl2","AirbusFBW/PaxDoorModeArray",2)
sysGeneral.doorR1Anc 		= SimpleAnnunciator:new("doorr1","AirbusFBW/PaxDoorModeArray",1)
sysGeneral.doorR2Anc 		= SimpleAnnunciator:new("doorr2","AirbusFBW/PaxDoorModeArray",3)
sysGeneral.doorFCargoAnc 	= SimpleAnnunciator:new("doorfcargo","AirbusFBW/CargoDoorModeArray",-1)
sysGeneral.doorACargoAnc 	= SimpleAnnunciator:new("dooracrago","AirbusFBW/CargoDoorModeArray",1)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = sysGeneral.doorL1Anc:getStatus() +
				sysGeneral.doorL2Anc:getStatus() +
				sysGeneral.doorR1Anc:getStatus() +
				sysGeneral.doorR2Anc:getStatus() +
				sysGeneral.doorFCargoAnc:getStatus() +
				sysGeneral.doorACargoAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)


sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("nosmoke","AirbusFBW/OHPLightSwitches",12)

sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts","AirbusFBW/OHPLightSwitches",11)

sysGeneral.chrono			= TwoStateToggleSwitch:new("chrono","AirbusFBW/ChronoTimeND1",0,
	"AirbusFBW/CaptChronoButton")
	
sysGeneral.clock			= TwoStateDrefSwitch:new("clock","AirbusFBW/ClockETSwitch",0)

sysGeneral.tocheck		 = TwoStateToggleSwitch:new("tockeck","AirbusFBW/ATA31ECPAnimations",25,
	"AirbusFBW/TOConfigPress")

return sysGeneral
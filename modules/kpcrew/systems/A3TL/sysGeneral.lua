-- ToLiss Airbusses
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysGeneral.chrono		
-- sysGeneral.clock
-- sysGeneral.cockpitDoor 	
-- sysGeneral.doorACargo 	
-- sysGeneral.doorACargoAnc 
-- sysGeneral.doorFCargo 	
-- sysGeneral.doorFCargoAnc 
-- sysGeneral.doorGroup 	
-- sysGeneral.doorL1		
-- sysGeneral.doorL1Anc 	
-- sysGeneral.doorL2		
-- sysGeneral.doorL2Anc 	
-- sysGeneral.doorR1		
-- sysGeneral.doorR1Anc 	
-- sysGeneral.doorR2		
-- sysGeneral.doorR2Anc 	
-- sysGeneral.doorsAnc 	
-- sysGeneral.irsUnit1Switch
-- sysGeneral.irsUnit2Switch
-- sysGeneral.irsUnit3Switch
-- sysGeneral.irsUnitGroup
-- sysGeneral.noSmokingSwitch
-- sysGeneral.parkBrakeSwitch
-- sysGeneral.parkbrakeAnc
-- sysGeneral.passSignsSwitch
-- sysGeneral.stairsL1 	
-- sysGeneral.tocheck	
-- sysGeneral.wiperGroup 	
-- sysGeneral.wiperLeft 	
-- sysGeneral.wiperRight 
-- Macro: kc_macro_set_groundobjects
-- Macro: kc_macro_set_autobrake

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

--------- Switch datarefs common
local drefParkbrake			= "AirbusFBW/ParkBrake"
local drefGearLever			= "sim/cockpit/switches/gear_handle_status"
local drefWiperLeft			= "AirbusFBW/LeftWiperSwitch"
local drefWiperRight		= "AirbusFBW/RightWiperSwitch"
local drefIRSUnit1			= "AirbusFBW/ADIRUSwitchArray"
local drefNoSmoking			= "AirbusFBW/OHPLightSwitches"
local drefSeatBelts			= "AirbusFBW/OHPLightSwitches"
local drefChrono			= "AirbusFBW/ChronoTimeND1"
local drefClockSwitch		= "AirbusFBW/ClockETSwitch"
local drefTOCheckButton		= "AirbusFBW/ATA31ECPAnimations"

--------- Annunciator datarefs common
local drefAnnGearLeftGreen	= "sim/flightmodel/movingparts/gear1def"
local drefAnnGearRghtGreen	= "sim/flightmodel/movingparts/gear2def"
local drefAnnGearNoseGreen	= "sim/flightmodel/movingparts/gear3def"

--------- Switch commands common
local cmdParkbrake			= "toliss_airbus/park_brake_toggle"
local cmdParkbrakeSet		= "toliss_airbus/park_brake_set"
local cmdParkbrakeRelease	= "toliss_airbus/park_brake_release"
local cmdChronoButton		= "AirbusFBW/CaptChronoButton"
local cmdTOConfig			= "AirbusFBW/TOConfigPress"

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateCmdSwitch:new("parkbrake",drefParkbrake,0,
		cmdParkbrakeSet,cmdParkbrakeRelease,cmdParkbrake)
sysGeneral.parkbrakeAnc 	= SimpleAnnunciator:new("parkbrake",drefParkbrake,0)

-- Wiper Switches
sysGeneral.wiperLeft 		= TwoStateDrefSwitch:new("wiperleft",drefWiperLeft,0)
sysGeneral.wiperRight 		= TwoStateDrefSwitch:new("wiperright",drefWiperRight,0)
sysGeneral.wiperGroup 		= SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- IRS/ADIRU
sysGeneral.irsUnit1Switch 	= TwoStateDrefSwitch:new("irsunit1",drefIRSUnit1,-1)
sysGeneral.irsUnit2Switch 	= TwoStateDrefSwitch:new("irsunit2",drefIRSUnit1,1)
sysGeneral.irsUnit3Switch 	= TwoStateDrefSwitch:new("irsunit3",drefIRSUnit1,2)
sysGeneral.irsUnitGroup 	= SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

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

sysGeneral.doorGroup 		= SwitchGroup:new("doors")
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

sysGeneral.noSmokingSwitch	= TwoStateDrefSwitch:new("nosmoke",drefNoSmoking,12)
sysGeneral.passSignsSwitch	= TwoStateDrefSwitch:new("seatbelts",drefNoSmoking,11)

sysGeneral.chrono			= TwoStateToggleSwitch:new("chrono",drefChrono,0,cmdChronoButton)
	
sysGeneral.clock			= TwoStateDrefSwitch:new("clock",drefClockSwitch,0)

sysGeneral.tocheck			= TwoStateToggleSwitch:new("tockeck",drefTOCheckButton,25,cmdTOConfig)
	
-- Autobrake
sysGeneral.Autobrake		= TwoStateCustomSwitch:new("autobrake","AirbusFBW/AutoBrkMax",0,
function () end,
function () end,
function () end,
function () 
	if PLANE_ICAO ~= "A346" then
		if get("AirbusFBW/AutoBrkLo") == 1 then 
			return 1
		elseif get("AirbusFBW/AutoBrkMed") == 1 then 
			return 2
		elseif get("AirbusFBW/AutoBrkMax") == 1 then
			return 3
		else
			return 0
		end
	else
		if get("AirbusFBW/AutoBrkMax") == 1 then
			return 6
		else
			return get("AirbusFBW/AutoBrkSel")
		end
	end
end)

-- autobrake
function kc_macro_set_autobrake(index)
	if PLANE_ICAO ~= "A346" then
		if index > 0 then
			if index == 1 then
				command_once("AirbusFBW/AbrkLo")
			elseif index == 2 then
				command_once("AirbusFBW/AbrkMed")
			elseif index == 3 then
				command_once("AirbusFBW/AbrkMax")
			end
		else
			command_once("AirbusFBW/AbrkLo")
			command_once("AirbusFBW/AbrkMed")
			command_once("AirbusFBW/AbrkMax")
			command_once("AirbusFBW/AbrkMax")
		end
	else
		if index < 6 then
			set("AirbusFBW/AutoBrkSel",index)
			if index == 0 and get("AirbusFBW/AutoBrkMax") == 1 then
				command_once("AirbusFBW/AbrkMax")
			end
		else
			command_once("AirbusFBW/AbrkMax")
		end
	end
end

-- ground objects 1=on 0=off
function kc_macro_set_groundobjects(state)
	if state == 1 then
		set("AirbusFBW/Chocks",1)
		command_once("toliss_airbus/park_brake_release")
	else
		command_once("toliss_airbus/park_brake_set")
		set("AirbusFBW/Chocks",0)
	end
end

return sysGeneral
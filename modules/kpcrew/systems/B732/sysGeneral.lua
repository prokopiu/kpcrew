-- B732 airplane 
-- aircraft general systems

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

local sysGeneral = {
	irsUnitMin = 0,
	irsUnitMax = 3,
	irsUnitOFF = 0,
	irsUnitALIGN = 1,
	irsUnitNAV = 2,
	irsUnitATT = 3;

	wiperPark = 0,
	wiperInt = 1,
	wiperLow = 2,
	wiperHigh = 3
}

-- Parking Brake
sysGeneral.parkBrakeSwitch = TwoStateToggleSwitch:new("parkbrake","sim/cockpit2/controls/parking_brake_ratio",0,"sim/flight_controls/brakes_toggle_max")

-- Landing Gear
sysGeneral.GearSwitch = TwoStateCmdSwitch:new("gear","kp/xsp/systems/gear_status",0,"sim/flight_controls/landing_gear_down","sim/flight_controls/landing_gear_up","nocommand")

-- Doors
sysGeneral.doorL1 = TwoStateToggleSwitch:new("doorl1","FJS/732/DoorSta/Door1",0,"FJS/732/Doors/Door1")
sysGeneral.doorL2 = TwoStateToggleSwitch:new("doorl2","FJS/732/DoorSta/Door2",0,"FJS/732/Doors/Door2")
sysGeneral.doorR1 = TwoStateToggleSwitch:new("doorr1","FJS/732/DoorSta/Door2",0,"FJS/732/Doors/Door3")
sysGeneral.doorFCargo = TwoStateDrefSwitch:new("doorfcargo","FJS/732/DoorSta/CargoDoorFor",0)
sysGeneral.doorACargo = TwoStateDrefSwitch:new("dooracrago","FJS/732/DoorSta/CargoDoorAft",0)

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)

sysGeneral.cockpitDoor = TwoStateDrefSwitch:new("","FJS/732/cabin/CockpitDoorTrig",0)

-- Passenger Signs

sysGeneral.seatBeltSwitch = TwoStateDrefSwitch:new("","FJS/732/lights/FastenBeltsSwitch",0)
sysGeneral.noSmokingSwitch = TwoStateDrefSwitch:new("","FJS/732/lights/NoSmokingSwitch",0)

-- Baro standard toggle
sysGeneral.barostdPilot = TwoStateCustomSwitch:new("barostdpilot","sim/cockpit/misc/barometer_setting",0,
function ()
	set("FJS/732/Inst/StbyBaroKnob",2992)
	set("sim/cockpit/misc/barometer_setting",get("sim/weather/barometer_sealevel_inhg"))
end,
function ()
	set("FJS/732/Inst/StbyBaroKnob",2992)
	set("sim/cockpit/misc/barometer_setting",29.92)
end,
function ()
	if get("sim/cockpit/misc/barometer_setting") == 29.92 then
		set("sim/cockpit/misc/barometer_setting",get("sim/weather/barometer_sealevel_inhg"))
	else
		set("sim/cockpit/misc/barometer_setting",29.92)
	end
end)

sysGeneral.barostdCopilot = TwoStateCustomSwitch:new("barostdcopilot","sim/cockpit/misc/barometer_setting2",0,
function ()
	set("FJS/732/Inst/StbyBaroKnob",2992)
	set("sim/cockpit/misc/barometer_setting2",get("sim/weather/barometer_sealevel_inhg"))
end,
function ()
	set("FJS/732/Inst/StbyBaroKnob",2992)
	set("sim/cockpit/misc/barometer_setting2",29.92)
end,
function ()
	if get("sim/cockpit/misc/barometer_setting2") == 29.92 then
		set("sim/cockpit/misc/barometer_setting2",get("sim/weather/barometer_sealevel_inhg"))
	else
		set("sim/cockpit/misc/barometer_setting2",29.92)
	end
end)

sysGeneral.barostdStandby = TwoStateCustomSwitch:new("barostdstandby","FJS/732/Inst/StbyBaroKnob",0,
function ()
	set("FJS/732/Inst/StbyBaroKnob",get("sim/weather/barometer_sealevel_inhg")*100)
end,
function ()
	set("FJS/732/Inst/StbyBaroKnob",2992)
end,
function ()
	if get("FJS/732/Inst/StbyBaroKnob") == 2992 then
		set("FJS/732/Inst/StbyBaroKnob",get("sim/weather/barometer_sealevel_inhg")*100)
	else
		set("FJS/732/Inst/StbyBaroKnob",2992)
	end
end)

sysGeneral.barostdGroup = SwitchGroup:new("barostdgroup")
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdPilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdCopilot)
sysGeneral.barostdGroup:addSwitch(sysGeneral.barostdStandby)

-- Baro mode
sysGeneral.baroModePilot = InopSwitch:new("baromodepilot")
sysGeneral.baroModeCoPilot = InopSwitch:new("baromodecopilot")
sysGeneral.baroModeStandby = InopSwitch:new("baromodecopilot")

sysGeneral.baroModeGroup = SwitchGroup:new("baromodegroup")
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModePilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeCoPilot)
sysGeneral.baroModeGroup:addSwitch(sysGeneral.baroModeStandby)

-- Baro value

sysGeneral.baroPilot = TwoStateCustomSwitch:new("baropilot","sim/cockpit/misc/barometer_setting",0,
function ()
	set("sim/cockpit/misc/barometer_setting",get("sim/cockpit/misc/barometer_setting")+0.01)
end,
function ()
	set("sim/cockpit/misc/barometer_setting",get("sim/cockpit/misc/barometer_setting")-0.01)
end,
nil)
sysGeneral.baroCoPilot = TwoStateCustomSwitch:new("barocopilot","sim/cockpit/misc/barometer_setting2",0,
function ()
	set("sim/cockpit/misc/barometer_setting2",get("sim/cockpit/misc/barometer_setting2")+0.01)
end,
function ()
	set("sim/cockpit/misc/barometer_setting2",get("sim/cockpit/misc/barometer_setting2")-0.01)
end,
nil)
sysGeneral.baroStandby = TwoStateCustomSwitch:new("barostandby","FJS/732/Inst/StbyBaroKnob",0,
function ()
	set("FJS/732/Inst/StbyBaroKnob",get("FJS/732/Inst/StbyBaroKnob")+1)
end,
function ()
	set("FJS/732/Inst/StbyBaroKnob",get("FJS/732/Inst/StbyBaroKnob")-1)
end,
nil)

sysGeneral.baroGroup = SwitchGroup:new("barogroup")
sysGeneral.baroGroup:addSwitch(sysGeneral.baroPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroCoPilot)
sysGeneral.baroGroup:addSwitch(sysGeneral.baroStandby)

sysGeneral.baroSynch = TwoStateCustomSwitch:new("baropilot","sim/cockpit/misc/barometer_setting",0,
function ()
	set("sim/cockpit/misc/barometer_setting2",get("sim/cockpit/misc/barometer_setting")+0.01)
	set("FJS/732/Inst/StbyBaroKnob",(get("sim/cockpit/misc/barometer_setting")+0.01)*100)
	set("sim/cockpit/misc/barometer_setting",get("sim/cockpit/misc/barometer_setting")+0.01)
end,
function ()
	set("sim/cockpit/misc/barometer_setting2",get("sim/cockpit/misc/barometer_setting")-0.01)
	set("FJS/732/Inst/StbyBaroKnob",(get("sim/cockpit/misc/barometer_setting")-0.01)*100)
	set("sim/cockpit/misc/barometer_setting",get("sim/cockpit/misc/barometer_setting")-0.01)
end,
nil)

--- systems not used by kphardware

-- IRS
sysGeneral.irsUnit1Switch = InopSwitch:new("irsunit1")
sysGeneral.irsUnit2Switch = InopSwitch:new("irsunit2")
sysGeneral.irsUnit3Switch = InopSwitch:new("irsunit3")

sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)
-- sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit3Switch)

-- Wipers

sysGeneral.wiperLeftSwitch = TwoStateDrefSwitch:new("","FJS/732/AntiIce/WiperKnob",0)
sysGeneral.wiperRightSwitch = InopSwitch:new("wiperright")

sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeftSwitch)
-- sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRightSwitch)

-- Emergency Exit Lights
sysGeneral.emerExitLightsSwitch = TwoStateDrefSwitch:new("","FJS/732/lights/EmerExitSwitch",0)
sysGeneral.emerExitLightsCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipPo_10",0)

-- Voice recorder

sysGeneral.voiceRecSwitch = TwoStateDrefSwitch:new("","FJS/732/num/FltRecSwitch",0)
sysGeneral.vcrCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipPo_15",0)

-- Attendence button 
sysGeneral.attendanceButton = TwoStateDrefSwitch:new("","FJS/732/Radios/AttCallButton",0)

-- Equipment Cooling
sysGeneral.equipCoolExhaust = InopSwitch:new("coolExhaust")
sysGeneral.equipCoolSupply = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/EquipCoolingSwitch",0)

-- Passenger lights
sysGeneral.noSmokingSwitch = TwoStateDrefSwitch:new("","FJS/732/lights/NoSmokingSwitch",0)
sysGeneral.seatBeltSwitch = TwoStateDrefSwitch:new("","FJS/732/lights/FastenBeltsSwitch",0)

-- GPWS

sysGeneral.flapInhibitSwitch 	= TwoStateDrefSwitch:new("","FJS/732/Annun/GPWS_InhibitSwitch",0)
sysGeneral.gearInhibitSwitch 	= InopSwitch:new("","laminar/B738/toggle_switch/gpws_gear_pos",0)
sysGeneral.terrainInhibitSwitch = InopSwitch:new("","laminar/B738/toggle_switch/gpws_terr_pos",0)

sysGeneral.flapInhibitCover 	= TwoStateToggleSwitch:new("","FJS/732/num/FlipPo_18",0)
sysGeneral.gearInhibitCover 	= InopSwitch:new("")
sysGeneral.terrainInhibitCover 	= InopSwitch:new("")

-- Autobrake
sysGeneral.autobreak = TwoStateDrefSwitch:new("","FJS/732/FltControls/AutoBrakeKnob",0)

-- Lights Test
sysGeneral.lightTest = TwoStateDrefSwitch:new("","FJS/732/Annun/AnnunLightsSwitch",0)

------------ Annunciators
-- park brake
sysGeneral.parkbrakeAnc = CustomAnnunciator:new("parkbrake",
function ()
	if get("sim/cockpit2/controls/parking_brake_ratio") > 0 then
		return 1
	else
		return 0
	end
end)

-- Gear Lights for annunciators
sysGeneral.gearLeftGreenAnc = SimpleAnnunciator:new("green1", "FJS/732/Annun/SysAnnunBUT_118", 0)
sysGeneral.gearRightGreenAnc = SimpleAnnunciator:new("green2","FJS/732/Annun/SysAnnunBUT_120", 0)
sysGeneral.gearNodeGreenAnc = SimpleAnnunciator:new("green3", "FJS/732/Annun/SysAnnunBUT_122", 0)
sysGeneral.gearLeftRedAnc = InopSwitch:new("red1", "FJS/732/Annun/SysAnnunBUT_117", 0)
sysGeneral.gearRightRedAnc = InopSwitch:new("red2", "FJS/732/Annun/SysAnnunBUT_119", 0)
sysGeneral.gearNodeRedAnc = InopSwitch:new("red3", "FJS/732/Annun/SysAnnunBUT_121", 0)

-- light on when gears extended else 0
sysGeneral.gearLightsAnc = CustomAnnunciator:new("gearlights", 
function () 
	local sum = sysGeneral.gearLeftGreenAnc:getStatus() +
				sysGeneral.gearRightGreenAnc:getStatus() +
				sysGeneral.gearNodeGreenAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

sysGeneral.gearLightsRed = CustomAnnunciator:new("gearlightsred", 
function () 
	local sum = sysGeneral.gearLeftRedAnc:getStatus() +
				sysGeneral.gearRightRedAnc:getStatus() +
				sysGeneral.gearNodeRedAnc:getStatus()
	if sum > 0 then 
		return 1
	else
		return 0
	end
end)

-- Master Caution
sysGeneral.masterCautionAnc = SimpleAnnunciator:new("mastercaution", "FJS/732/Annun/MasterCautionLITL", 0)

-- Master Warning
sysGeneral.masterWarningAnc = SimpleAnnunciator:new("masterwarning", "sim/cockpit2/annunciators/master_warning", 0)

-- Fire Warning
sysGeneral.fireWarningAnc = SimpleAnnunciator:new("firewarning", "FJS/732/FireProtect/FireWarnBellON",0)

-- Door annunciators
sysGeneral.doorL1Anc = SimpleAnnunciator:new("doorl1","737u/doors/L1",0)
sysGeneral.doorL2Anc = SimpleAnnunciator:new("doorl2","737u/doors/L2",0)
sysGeneral.doorR1Anc = SimpleAnnunciator:new("doorr1","737u/doors/R1",0)
sysGeneral.doorR2Anc = SimpleAnnunciator:new("doorr2","737u/doors/R2",0)
sysGeneral.doorFCargoAnc = SimpleAnnunciator:new("doorfcargo","737u/doors/Fwd_Cargo",0)
sysGeneral.doorACargoAnc = SimpleAnnunciator:new("dooracrago","737u/doors/aft_Cargo",0)

sysGeneral.doorsAnc = CustomAnnunciator:new("doors", 
function () 
	if sysGeneral.doorGroup:getStatus() > 0 then 
		return 1
	else
		return 0
	end
end)

sysGeneral.baroMb = SimpleAnnunciator:new("baromb","FJS/732/Inst/BaroMillRoll_1D",0)

return sysGeneral
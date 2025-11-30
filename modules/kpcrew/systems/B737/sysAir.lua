-- B737 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements:
-- sysAir.trimAirSwitch
-- sysAir.recircFanLeft
-- sysAir.recircFanRight
-- sysAir.recircSwitchGroup
-- sysAir.packLeftSwitch 
-- sysAir.packRightSwitch
-- sysAir.packSwitchGroup
-- sysAir.isoValveSwitch
-- sysAir.bleedEng1Switch
-- sysAir.bleedEng2Switch
-- sysAir.bleedEng3Switch
-- sysAir.bleedEng4Switch
-- sysAir.engBleedGroup
-- sysAir.apuBleedSwitch
-- sysAir.oxygenMaster


local sysAir = {
}

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

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("B737 sysAir")

--------- Switch datarefs common
local drefTrimAir			= "laminar/B738/air/trim_air_pos"
local drefRecircL			= "laminar/B738/air/l_recirc_fan_pos"
local drefRecircR			= "laminar/B738/air/r_recirc_fan_pos"
local drefPackSwitchLeft	= "laminar/B738/air/l_pack_pos"
local drefPackSwitchRight	= "laminar/B738/air/r_pack_pos"
local drefIsoValve			= "laminar/B738/air/isolation_valve_pos"
local drefBleedL			= "laminar/B738/toggle_switch/bleed_air_1_pos"
local drefBleedR			= "laminar/B738/toggle_switch/bleed_air_2_pos"
local drefAPUBleed			= "laminar/B738/toggle_switch/bleed_air_apu_pos"
local drefOxygenMaster		= "sim/cockpit2/oxygen/actuators/demand_flow_setting"

--------- Annunciator datarefs common
local drefAirANC 			= "sim/cockpit2/annunciators/low_vacuum"

--------- Switch commands common
local cmdTraimAirTgl		= "laminar/B738/toggle_switch/trim_air"
local cmdRecircLTgl			= "laminar/B738/toggle_switch/l_recirc_fan"
local cmdRecircRTgl			= "laminar/B738/toggle_switch/r_recirc_fan"
local cmdPackLeftDn			= "laminar/B738/toggle_switch/l_pack_dn"
local cmdPackLeftUp			= "laminar/B738/toggle_switch/l_pack_up"
local cmdPackRightDn		= "laminar/B738/toggle_switch/r_pack_dn"
local cmdPackRightUp		= "laminar/B738/toggle_switch/r_pack_up"
local cmdIsoValveDn			= "laminar/B738/toggle_switch/iso_valve_dn"
local cmdIsoValveUp			= "laminar/B738/toggle_switch/iso_valve_up"
local cmdBleedLTgl			= "laminar/B738/toggle_switch/bleed_air_1"
local cmdBleedRTgl			= "laminar/B738/toggle_switch/bleed_air_2"
local cmdAPUBleedTgl		= "laminar/B738/toggle_switch/bleed_air_apu"

----------- Switches

-- TRIM/RAM air
sysAir.trimAirSwitch 		= TwoStateToggleSwitch:new("trimair",drefTrimAir,0,cmdTraimAirTgl)

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateToggleSwitch:new("recirc1",drefRecircL,0,cmdRecircLTgl)
sysAir.recircFanRight 		= TwoStateToggleSwitch:new("recirc2",drefRecircR,0,cmdRecircRTgl)
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)

-- PACK switches
sysAir.packLeftSwitch 		= MultiStateCmdSwitch:new("pack1",drefPackSwitchLeft,0,cmdPackLeftDn,cmdPackLeftUp,0,2,false)
sysAir.packRightSwitch 		= MultiStateCmdSwitch:new("pack2",drefPackSwitchRight,0,cmdPackRightDn,cmdPackRightUp,0,2,false)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateDrefSwitch:new("isolation",drefIsoValve,0)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1",drefBleedL,0,cmdBleedLTgl)
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2",drefBleedR,0,cmdBleedRTgl)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)


-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateToggleSwitch:new("apubleed",drefAPUBleed,0,cmdAPUBleedTgl)

-- Oxygen Supply
sysAir.oxygenMaster			= TwoStateCustomSwitch:new("oxygen",drefOxygenMaster,0,
	function () command_once("laminar/B738/one_way_switch/pax_oxy_on") end,
	function () command_once("laminar/B738/one_way_switch/pax_oxy_norm") end,
	function () command_once("laminar/B738/one_way_switch/pax_oxy_norm") end,
	function () return get("laminar/B738/one_way_switch/pax_oxy_pos") end)
	
-- AIR temperature
sysAir.contCabTemp 			= TwoStateDrefSwitch:new("airtemp1","laminar/B738/air/cont_cab_temp/rheostat",0)
sysAir.fwdCabTemp 			= TwoStateDrefSwitch:new("airtemp2","laminar/B738/air/fwd_cab_temp/rheostat",0)
sysAir.aftCabTemp 			= TwoStateDrefSwitch:new("airtemp3","laminar/B738/air/aft_cab_temp/rheostat",0)

--------- Macros

-- Macro: Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(0)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenMaster:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		if activeBriefings:get("takeoff:packs") < 2 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
		sysAir.isoValveSwitch:actuate(1)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
		sysAir.oxygenMaster:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_takeoff then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenMaster:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenMaster:actuate(1)
	elseif flightphase == kc_phase_approach then
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenMaster:actuate(1)
		if activeBriefings:get("approach:packs") == 1 then
			sysAir.packSwitchGroup:actuate(0)
		else
			sysAir.packSwitchGroup:actuate(1)
		end
		sysAir.trimAirSwitch:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenMaster:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysAir
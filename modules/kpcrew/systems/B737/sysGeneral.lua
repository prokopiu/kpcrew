-- B737 airplane 
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

logMsg("B737 sysGeneral")

kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

-- Doors
if kc_is_zibo then
	sysGeneral.doorL1			= TwoStateToggleSwitch:new("doorl1","737u/doors/L1",0,
		"laminar/B738/door/fwd_L_toggle")
	sysGeneral.doorL2			= TwoStateToggleSwitch:new("doorl2","737u/doors/L2",0,
		"laminar/B738/door/aft_L_toggle")
	sysGeneral.doorR1			= TwoStateToggleSwitch:new("doorr1","737u/doors/R1",0,
		"laminar/B738/door/fwd_R_toggle")
	sysGeneral.doorR2			= TwoStateToggleSwitch:new("doorr2","737u/doors/R2",0,
		"laminar/B738/door/aft_R_toggle")
	sysGeneral.doorFCargo		= TwoStateToggleSwitch:new("doorfcargo","737u/doors/Fwd_Cargo",0,
		"laminar/B738/door/fwd_cargo_toggle")
	sysGeneral.doorACargo 		= TwoStateToggleSwitch:new("dooracrago","737u/doors/aft_Cargo",0,
		"laminar/B738/door/aft_cargo_toggle")
	sysGeneral.cockpitDoor 		= TwoStateToggleSwitch:new("","laminar/B738/door/flt_dk_door_ratio",0,
		"laminar/B738/toggle_switch/flt_dk_door_open")
	sysGeneral.stairs 			= TwoStateCustomSwitch:new("stairs","laminar/B738/airstairs_hide",0,
		function ()
			if get("laminar/B738/airstairs_hide") ~= 0 then
				command_once("laminar/B738/airstairs_ext_toggle")
			end
		end,
		function ()
			if get("laminar/B738/airstairs_hide") == 0 then
				command_once("laminar/B738/airstairs_ext_toggle")
			end
		end,
		function ()
			command_once("laminar/B738/airstairs_ext_toggle")
		end,
		function ()
			if get("laminar/B738/airstairs_hide") == 0 then
				return 1
			else
				return 0
			end
		end)

	-- Door annunciators
	sysGeneral.doorL1Anc = SimpleAnnunciator:new("doorl1","737u/doors/L1",0)
	sysGeneral.doorL2Anc = SimpleAnnunciator:new("doorl2","737u/doors/L2",0)
	sysGeneral.doorR1Anc = SimpleAnnunciator:new("doorr1","737u/doors/R1",0)
	sysGeneral.doorR2Anc = SimpleAnnunciator:new("doorr2","737u/doors/R2",0)
	sysGeneral.doorFCargoAnc = SimpleAnnunciator:new("doorfcargo","737u/doors/Fwd_Cargo",0)
	sysGeneral.doorACargoAnc = SimpleAnnunciator:new("dooracrago","737u/doors/aft_Cargo",0)
else
	sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","sim/cockpit2/switches/door_open",-1)
	sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2","sim/cockpit2/switches/door_open",3)
	sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","sim/cockpit2/switches/door_open",4)
	sysGeneral.doorR2			= TwoStateDrefSwitch:new("doorr2","sim/cockpit2/switches/door_open",7)
	sysGeneral.doorFCargo		= TwoStateDrefSwitch:new("doorfcargo","sim/cockpit2/switches/door_open",8)
	sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracrago","sim/cockpit2/switches/door_open",9)
	sysGeneral.cockpitDoor 		= TwoStateToggleSwitch:new("","sim/cockpit2/switches/custom_slider_on",20,
		"sim/flight_controls/canopy_toggle")
	sysGeneral.stairs 			= InopSwitch:new("stairs")
	-- Door annunciators
	sysGeneral.doorL1Anc = SimpleAnnunciator:new("doorl1","sim/cockpit2/switches/door_open",-1)
	sysGeneral.doorL2Anc = SimpleAnnunciator:new("doorl2","sim/cockpit2/switches/door_open",3)
	sysGeneral.doorR1Anc = SimpleAnnunciator:new("doorr1","sim/cockpit2/switches/door_open",4)
	sysGeneral.doorR2Anc = SimpleAnnunciator:new("doorr2","sim/cockpit2/switches/door_open",7)
	sysGeneral.doorFCargoAnc = SimpleAnnunciator:new("doorfcargo","sim/cockpit2/switches/door_open",8)
	sysGeneral.doorACargoAnc = SimpleAnnunciator:new("dooracrago","sim/cockpit2/switches/door_open",9)
end
sysGeneral.doorGroup 		= SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairs)

sysGeneral.doorsAnc = CustomAnnunciator:new("doors", 
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

-- if kc_is_zibo then
	-- sysGeneral.seatBeltSwitch 	= TwoStateCustomSwitch:new("seatbelts","laminar/B738/toggle_switch/seatbelt_sign_pos",0,
		-- function ()
		-- logMsg("test1")
			-- command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
			-- command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
		-- end,
		-- function ()
		-- logMsg("test1")
			-- command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
			-- command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
		-- end,
		-- function ()
			-- if get("laminar/B738/toggle_switch/seatbelt_sign_pos") == 0 then
				-- command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
				-- command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
			-- else
				-- command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
				-- command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
			-- end
		-- end,
		-- function ()
			-- if get("laminar/B738/toggle_switch/seatbelt_sign_pos",0) > 0 then
				-- return 1
			-- else
				-- return 0
			-- end
		-- end)
-- else
	sysGeneral.passSignsSwitch 	= TwoStateCustomSwitch:new("seatbelts","laminar/B738/toggle_switch/seatbelt_sign_pos",0,
		function ()
				logMsg("test2")
			command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
			command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
		end,
		function ()
				logMsg("test2")
			command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
			command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
		end,
		function ()
			if get("laminar/B738/toggle_switch/seatbelt_sign_pos") == 0 then
				command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
				command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
			else
				command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
				command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
			end
		end,
		function ()
			if get("laminar/B738/toggle_switch/seatbelt_sign_pos") > 0 then
				return 1
			else
				return 0
			end
		end)
-- end
		
-- Autobrake
if kc_is_zibo then
	sysGeneral.Autobrake = MultiStateCmdSwitch:new("autobrake","laminar/B738/autobrake/autobrake_pos",0,
		"laminar/B738/knob/autobrake_dn","laminar/B738/knob/autobrake_up",0,5,true)
else
	sysGeneral.Autobrake = TwoStateDrefSwitch:new("autobrake","sim/cockpit2/switches/auto_brake_level",0)
end

-- IRS
sysGeneral.irsUnit1Switch = MultiStateCmdSwitch:new("irsunit1","laminar/B738/toggle_switch/irs_left",0,
	"laminar/B738/toggle_switch/irs_L_left","laminar/B738/toggle_switch/irs_L_right",0,3,true)
sysGeneral.irsUnit2Switch = MultiStateCmdSwitch:new("irsunit2","laminar/B738/toggle_switch/irs_right",0,
	"laminar/B738/toggle_switch/irs_R_left","laminar/B738/toggle_switch/irs_R_right",0,3,true)
sysGeneral.irsUnitGroup = SwitchGroup:new("irsunits")
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit1Switch)
sysGeneral.irsUnitGroup:addSwitch(sysGeneral.irsUnit2Switch)

return sysGeneral
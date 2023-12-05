-- B733 IXEG 737 PRO 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local sysControls = {
	trimCenter 	= 2,
	trimLeft 	= 1,
	trimRight 	= 0,
	
	flapsUp 	= 0,
	flapsDown 	= 1,
	
	trimUp 		= 0,
	trimDown 	= 1,
	
	flaps_pos = {[1] = 0.125, [2] = 0.25, [3] = 0.375, [4] = 0.5, [5] = 0.625, [6] = 0.75, [7] = 0.875, [8] = 1}
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

--------- Switches

-- Flaps 
sysControls.flapsSwitch 	= TwoStateCustomSwitch:new("flaps","laminar/B738/flt_ctrls/flap_lever",0,
	function () 
		command_once("sim/flight_controls/flaps_down")
	end,
	function () 
		command_once("sim/flight_controls/flaps_up")
	end,
	function () 
		-- do nothing
	end
)

-- Pitch Trim
sysControls.pitchTrimSwitch = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_once("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		command_once("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		return
	end
)
sysControls.pitchTrimDownRepeat = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_begin("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		command_end("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		return
	end
)
sysControls.pitchTrimUpRepeat = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_begin("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		command_end("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		return
	end
)

-- Aileron Trim
sysControls.aileronTrimSwitch = TwoStateCustomSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,
	function () 
		command_once("sim/flight_controls/aileron_trim_right")
	end,
	function () 
		command_once("sim/flight_controls/aileron_trim_left")
	end,
	function () 
		return
	end
)

sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_center")

-- Rudder Trim
sysControls.rudderTrimSwitch = TwoStateCustomSwitch:new("ruddertrim","sim/cockpit2/controls/rudder_trim",0,
	function () 
		command_once("sim/flight_controls/rudder_trim_right")
	end,
	function () 
		command_once("sim/flight_controls/rudder_trim_left")
	end,
	function () 
		return
	end
)

-- ruder reset
sysControls.rudderReset 	= TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_center")

-- Yaw damper
sysControls.yawDamper 		= TwoStateDrefSwitch:new("yawdamper","ixeg/733/hydraulics/yaw_damper_act",0)

-- flaps ctrl
sysControls.altFlaps 		= InopSwitch:new("altflaps")
sysControls.altFlapsCover 	= TwoStateDrefSwitch:new("altflapscover","ixeg/733/hydraulics/alt_flaps_guard",0)
sysControls.altFlapsCtrl 	= InopSwitch:new("altflapsctrl")

-- flight controls
sysControls.fltCtrlASwitch 	= InopSwitch:new("fltctrl1")
sysControls.fltCtrlBSwitch 	= InopSwitch:new("fltctrl2")
sysControls.fltCtrlSwitches = SwitchGroup:new("fltCtrlSwitches")
sysControls.fltCtrlSwitches:addSwitch(sysControls.fltCtrlASwitch) 
sysControls.fltCtrlSwitches:addSwitch(sysControls.fltCtrlBSwitch) 

sysControls.fltCtrlACover 	= TwoStateToggleSwitch:new("fltctrl1cvr","ixeg/733/hydraulics/flt_control_A_guard",0)
sysControls.fltCtrlBCover 	= TwoStateToggleSwitch:new("fltctrl2cvr","ixeg/733/hydraulics/flt_control_B_guard",0)
sysControls.fltCtrlCovers 	= SwitchGroup:new("fltCtrlCovers")
sysControls.fltCtrlCovers:addSwitch(sysControls.fltCtrlACover) 
sysControls.fltCtrlCovers:addSwitch(sysControls.fltCtrlBCover) 

-- Spoilers
sysControls.spoilerASwitch 	= InopSwitch:new("spoilera")
sysControls.spoilerBSwitch 	= InopSwitch:new("spoilerb")
sysControls.spoilerSwitches = SwitchGroup:new("spoilerSwitches")
sysControls.spoilerSwitches:addSwitch(sysControls.spoilerASwitch) 
sysControls.spoilerSwitches:addSwitch(sysControls.spoilerBSwitch) 

sysControls.spoilerACover 	= TwoStateDrefSwitch:new("spoilercvr1","ixeg/733/hydraulics/spoiler_A_guard",0)
sysControls.spoilerBCover 	= TwoStateDrefSwitch:new("spoilercvr2","ixeg/733/hydraulics/spoiler_B_guard",0)
sysControls.spoilerCovers 	= SwitchGroup:new("spoilerCovers")
sysControls.spoilerCovers:addSwitch(sysControls.spoilerACover) 
sysControls.spoilerCovers:addSwitch(sysControls.spoilerBCover) 


--------- Annunciators

-- spoiler lever position
sysControls.spoilerLever 	= SimpleAnnunciator:new("spoilerpos","laminar/B738/flt_ctrls/speedbrake_lever",0)

-- Flaps extend
sysControls.slatsExtended 	= SimpleAnnunciator:new("falpsextended","laminar/B738/annunciator/slats_extend",0)

-- status of B737 flaps panel
sysControls.flapsPanelStatus = CustomAnnunciator:new("flapsstat",
function () 
	if get("laminar/B738/annunciator/hyd_stdby_rud") + 
		get("laminar/B738/annunciator/std_rud_on") + 
		get("laminar/B738/hydraulic/standby_on") + 
		get("laminar/B738/hydraulic/standby_status") > 0 then	
		return 1
	else
		return 0
	end
end)


return sysControls
-- B738 airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysControls = {
	trimCenter 	= 2,
	trimLeft 	= 1,
	trimRight 	= 0,
	
	flapsUp 	= 1,
	flapsDown 	= 0,
	
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
sysControls.flapsSwitch 	= MultiStateCmdSwitch:new("flaps","laminar/B738/flt_ctrls/flap_lever",0,
	"sim/flight_controls/flaps_down","sim/flight_controls/flaps_up",0,1,false)

-- Pitch Trim
sysControls.pitchTrimSwitch = MultiStateCmdSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	"laminar/B738/flight_controls/pitch_trim_up","laminar/B738/flight_controls/pitch_trim_down",-1,1,true)

-- Aileron Trim
sysControls.aileronTrimSwitch = MultiStateCmdSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_right","sim/flight_controls/aileron_trim_left",-1,1,false)

sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_center")

-- Rudder Trim
sysControls.rudderTrimSwitch = MultiStateCmdSwitch:new("ruddertrim","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_right","sim/flight_controls/rudder_trim_left",-1,1,false)

-- ruder reset
sysControls.rudderReset 	= TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_center")

-- Yaw damper
sysControls.yawDamper 		= TwoStateToggleSwitch:new("yawdamper","laminar/B738/toggle_switch/yaw_dumper_pos",0,
	"laminar/B738/toggle_switch/yaw_dumper")

-- flaps ctrl
sysControls.altFlaps 		= TwoStateToggleSwitch:new("altflaps","laminar/B738/toggle_switch/alt_flaps_pos",0,
	"laminar/B738/toggle_switch/alt_flaps")
sysControls.altFlapsCover 	= TwoStateToggleSwitch:new("altflapscover","laminar/B738/switches/alt_flaps_cover_pos",0,
	"laminar/B738/toggle_switch/alt_flaps_cover")
sysControls.altFlapsCtrl 	= MultiStateCmdSwitch:new("altflapsctrl","laminar/B738/toggle_switch/alt_flaps_ctrl",0,
	"laminar/B738/toggle_switch/alt_flaps_ctrl_dn","laminar/B738/toggle_switch/alt_flaps_ctrl_up",-1,1,false)

-- flight controls
sysControls.fltCtrlASwitch 	= MultiStateCmdSwitch:new("fltctrl1","laminar/B738/switches/flt_ctr_A_pos",0,
	"laminar/B738/toggle_switch/flt_ctr_A_dn","laminar/B738/toggle_switch/flt_ctr_A_up",-1,1,true)
sysControls.fltCtrlBSwitch 	= MultiStateCmdSwitch:new("fltctrl2","laminar/B738/switches/flt_ctr_B_pos",0,
	"laminar/B738/toggle_switch/flt_ctr_B_dn","laminar/B738/toggle_switch/flt_ctr_B_up",-1,1,true)
sysControls.fltCtrlSwitches = SwitchGroup:new("fltCtrlSwitches")
sysControls.fltCtrlSwitches:addSwitch(sysControls.fltCtrlASwitch) 
sysControls.fltCtrlSwitches:addSwitch(sysControls.fltCtrlBSwitch) 

sysControls.fltCtrlACover 	= TwoStateToggleSwitch:new("fltctrl1cvr","laminar/B738/switches/flt_ctr_A_cover_pos",0,
	"laminar/B738/toggle_switch/flt_ctr_A_cover")
sysControls.fltCtrlBCover 	= TwoStateToggleSwitch:new("fltctrl2cvr","laminar/B738/switches/flt_ctr_B_cover_pos",0,
	"laminar/B738/toggle_switch/flt_ctr_B_cover")
sysControls.fltCtrlCovers 	= SwitchGroup:new("fltCtrlCovers")
sysControls.fltCtrlCovers:addSwitch(sysControls.fltCtrlACover) 
sysControls.fltCtrlCovers:addSwitch(sysControls.fltCtrlBCover) 

-- Spoilers
sysControls.spoilerASwitch 	= TwoStateToggleSwitch:new("spoilera","laminar/B738/switches/spoiler_A_pos",0,
	"laminar/B738/toggle_switch/spoiler_A")
sysControls.spoilerBSwitch 	= TwoStateToggleSwitch:new("spoilerb","laminar/B738/switches/spoiler_B_pos",0,
	"laminar/B738/toggle_switch/spoiler_B")
sysControls.spoilerSwitches = SwitchGroup:new("spoilerSwitches")
sysControls.spoilerSwitches:addSwitch(sysControls.spoilerASwitch) 
sysControls.spoilerSwitches:addSwitch(sysControls.spoilerBSwitch) 

sysControls.spoilerACover 	= TwoStateToggleSwitch:new("spoilercvr1","laminar/B738/switches/spoiler_A_cover_pos",0,
	"laminar/B738/toggle_switch/spoiler_A_cover")
sysControls.spoilerBCover 	= TwoStateToggleSwitch:new("spoilercvr2","laminar/B738/switches/spoiler_B_cover_pos",0,
	"laminar/B738/toggle_switch/spoiler_B_cover")
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
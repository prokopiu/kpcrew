-- B738 airplane 
-- Flight Controls functionality

-- @classmod sysControls
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

sysControls = require("kpcrew.systems.DFLT.sysControls")

sysControls.flaps_pos = {[0] = 0, 	[1] = 0.125, [2] = 0.25, [3] = 0.375, [4] = 0.5, [5] = 0.625, [6] = 0.75, [7] = 0.875, [8] = 1.0}
sysControls.flaps_spd = {[0] = 230, [1] = 230,   [2] =  230, [3] =   230, [4] = 210, [5] =   190, [6] =  170, [7] =   150, [8] = 150}
sysControls.flaps_name= {[0] = "UP",[1] =   "1", [2] =  "2", [3] =   "5", [4] ="10", [5] =  "15", [6] = "25", [7] =  "30", [8] = "40"}

sysControls.trimCenter 	= 2
sysControls.trimLeft 	= 1
sysControls.trimRight 	= 0

sysControls.flapsUp 	= 0
sysControls.flapsDown 	= 1

sysControls.trimUp 		= 0
sysControls.trimDown 	= 1

sysControls.flapsSwitch	= MultiStateCmdSwitch:new ("flaps","sim/cockpit2/controls/flap_ratio",0,
	"sim/flight_controls/flaps_up","sim/flight_controls/flaps_down",0,8,true)

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
-- B738 airplane 
-- EFIS functionality

local sysEFIS = {
	mapRange_5 = 0,
	mapRange10 = 1,
	mapRange20 = 2,
	mapRange40 = 3,
	mapRange80 = 4,
	mapRange160 = 5,
	mapRange320 = 6,
	mapRange640 = 7,
	
	mapModeAPP = 0,
	mapModeVOR = 1,
	mapModeMAP = 2,
	mapModePLAN = 3,
	
	voradfVOR = 1,
	voradfOFF = 0,
	voradfADF = -1,
	
	minsTypeRadio = 0,
	minsTypeBaro = 1
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

------------- Switches

-- TFC
sysEFIS.tfcPilot = TwoStateToggleSwitch:new("tfcpilot","FJS/732/wx/TCASButton",0)

-- WX 
sysEFIS.wxrPilot = TwoStateDrefSwitch:new("wxrpilot","FJS/732/wx/WXSysKnob",0)

-- MINS SET
sysEFIS.minsPilot = TwoStateCustomSwitch:new("minspilot","sim/cockpit/misc/radio_altimeter_minimum",0,
function ()
	set("sim/cockpit/misc/radio_altimeter_minimum",get("sim/cockpit/misc/radio_altimeter_minimum")+1)
end,
function ()
	set("sim/cockpit/misc/radio_altimeter_minimum",get("sim/cockpit/misc/radio_altimeter_minimum")-1)
end,
nil)
sysEFIS.minsCopilot = TwoStateDrefSwitch:new("minscopilot","sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_copilot",0)

------------- Annunciators

sysEFIS.baroStandby = SimpleAnnunciator:new("","FJS/732/Inst/StbyBaroKnob",0)

-- UI
function sysEFIS:render(ypos,height)

	-- reposition when screen size changes
	if kh_efis_wnd_state < 0 then
		float_wnd_set_position(kh_efis_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 25, ypos-height)
		kh_efis_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_efis_wnd_state == 1 then
		imgui.Button("<", 17, 25)
		if imgui.IsItemActive() then 
			kh_efis_wnd_state = 0
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 25, ypos-height)
		end
	end

	if kh_efis_wnd_state == 0 then
		imgui.Button("E", 17, 25)
		if imgui.IsItemActive() then 
			kh_efis_wnd_state = 1
			float_wnd_set_geometry(kh_efis_wnd, 0, ypos, 400, ypos-height)
		end
	end

	kc_imgui_label_mcp("MINS:",10)
	kc_imgui_rotary_mcp("%04d",sysEFIS.minsPilot,10,31)
	kc_imgui_label_mcp("| BARO",10)
	kc_imgui_simple_actuator("DN",sysGeneral.baroSynch,cmdDown,10,23,25)
	kc_imgui_value("%5.2f",sysGeneral.baroSynch,10)
	kc_imgui_value("%4d",sysGeneral.baroMb,10)
	kc_imgui_simple_actuator("UP",sysGeneral.baroSynch,cmdUp,10,23,25)
	kc_imgui_toggle_button_mcp("STD",sysGeneral.barostdGroup,10,35,25)

end

return sysEFIS
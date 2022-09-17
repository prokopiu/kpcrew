-- B738 airplane 
-- Radio functionality

-- @classmod sysRadios
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysRadios = {
	xpdrTest 	= 0,
	xpdrStby 	= 1,
	xpdrAltOff 	= 2,
	xpdrAltOn 	= 3,
	xpdrTA 		= 4,
	xpdrTARA 	= 5
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

-- ===== COM Radios =====
sysRadios.com1StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com1_fine_down_833","sim/radios/stby_com1_fine_up_833",118000,136990,false)
sysRadios.com1StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com1_coarse_down","sim/radios/stby_com1_coarse_up",118000,136990,false)
sysRadios.com1Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/com1_right_is_selected",0,
	"sim/radios/com1_standy_flip")

sysRadios.com1ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com1_frequency_hz_833",0)
sysRadios.com1StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0)

sysRadios.com2StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com2_fine_down_833","sim/radios/stby_com2_fine_up_833",118000,136990,false)
sysRadios.com2StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com2_coarse_down","sim/radios/stby_com2_coarse_up",118000,136990,false)
sysRadios.com2Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/com2_right_is_selected",0,
	"sim/radios/com2_standy_flip")

sysRadios.com2ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com2_frequency_hz_833",0)
sysRadios.com2StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com2_standby_frequency_hz_833",0)

-- ===== NAV Radios =====
sysRadios.nav1StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav1_stdby_freq_hz",0,
	"sim/radios/stby_nav1_fine_down","sim/radios/stby_nav1_fine_up",10800,11795,false)
sysRadios.nav1StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav1_stdby_freq_hz",0,
	"sim/radios/stby_nav1_coarse_down","sim/radios/stby_nav1_coarse_up",10800,11795,false)
sysRadios.nav1Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/nav1_right_is_selected",0,
	"sim/radios/nav1_standy_flip")

sysRadios.nav1ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav1_freq_hz",0)
sysRadios.nav1StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav1_stdby_freq_hz",0)

sysRadios.nav2StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav2_stdby_freq_hz",0,
	"sim/radios/stby_nav2_fine_down","sim/radios/stby_nav2_fine_up",10800,11795,false)
sysRadios.nav2StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav2_stdby_freq_hz",0,
	"sim/radios/stby_nav2_coarse_down","sim/radios/stby_nav2_coarse_up",10800,11795,false)
sysRadios.nav2Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/nav2_right_is_selected",0,
	"sim/radios/nav2_standy_flip")

sysRadios.nav2ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav2_freq_hz",0)
sysRadios.nav2StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav2_stdby_freq_hz",0)

-- ===== ADF =====
sysRadios.adf1StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf1_stdby_freq_hz",0,
	"sim/radios/stby_adf1_ones_tens_down","sim/radios/stby_adf1_ones_tens_up",190,1750,false)
sysRadios.adf1StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf1_stdby_freq_hz",0,
	"sim/radios/stby_adf1_hundreds_thous_down","sim/radios/stby_adf1_hundreds_thous_up",190,1750,false)
sysRadios.adf1Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/adf1_right_is_selected",0,
	"sim/radios/adf1_standy_flip")

sysRadios.adf1ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf1_freq_hz",0)
sysRadios.adf1StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf1_stdby_freq_hz",0)

sysRadios.adf2StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf2_stdby_freq_hz",0,
	"sim/radios/stby_adf2_ones_tens_down","sim/radios/stby_adf2_ones_tens_up",190,1750,false)
sysRadios.adf2StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf2_stdby_freq_hz",0,
	"sim/radios/stby_adf2_hundreds_thous_down","sim/radios/stby_adf2_hundreds_thous_up",190,1750,false)
sysRadios.adf2Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/adf2_right_is_selected",0,
	"sim/radios/adf2_standy_flip")

sysRadios.adf2ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf2_freq_hz",0)
sysRadios.adf2StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf2_stdby_freq_hz",0)

sysRadios.xpdrSwitch 		= MultiStateCmdSwitch:new ("XPDR","laminar/B738/knob/transponder_pos",0,
	"laminar/B738/knob/transponder_mode_dn","laminar/B738/knob/transponder_mode_up",0,5,true)

sysRadios.xpdrCode 			= TwoStateDrefSwitch:new ("xpdrcode","sim/cockpit/radios/transponder_code",0)

-- render the MCP part
function sysRadios:render(ypos,height)

	-- reposition when screen size changes
	if  kh_radio_wnd_state < 0 then
		float_wnd_set_position(kh_radio_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_radio_wnd,  0, ypos, 25, ypos-height)
		kh_radio_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_radio_wnd_state == 1 then
		imgui.Button("<", 17, 60)
		if imgui.IsItemActive() then 
			kh_radio_wnd_state = 0
			float_wnd_set_geometry(kh_radio_wnd, 0, ypos, 25, ypos-height)
		end
	end

	if kh_radio_wnd_state == 0 then
		imgui.Button("R", 17, 60)
		if imgui.IsItemActive() then 
			kh_radio_wnd_state = 1
			float_wnd_set_geometry(kh_radio_wnd, 0, ypos, 845, ypos-height)
		end
	end

	imgui.SameLine()
	kc_imgui_com_radio("COM1:",sysRadios.com1StbyCourse,sysRadios.com1StbyFine,sysRadios.com1StandbyFreq,sysRadios.com1ActiveFreq,sysRadios.com1Flip,10,21)
	imgui.SameLine()
	kc_imgui_label_mcp("|",10)
	imgui.SameLine()
	kc_imgui_nav_radio("NAV1:",sysRadios.nav1StbyCourse,sysRadios.nav1StbyFine,sysRadios.nav1StandbyFreq,sysRadios.nav1ActiveFreq,sysRadios.nav1Flip,10,22)
	imgui.SameLine()
	kc_imgui_label_mcp("|",10)
	imgui.SameLine()
	kc_imgui_adf_radio("ADF1:",sysRadios.adf1StbyCourse,sysRadios.adf1StbyFine,sysRadios.adf1StandbyFreq,sysRadios.adf1ActiveFreq,sysRadios.adf1Flip,10,23)
	
	imgui.SetCursorPosX(25)
	kc_imgui_com_radio("COM2:",sysRadios.com2StbyCourse,sysRadios.com2StbyFine,sysRadios.com2StandbyFreq,sysRadios.com2ActiveFreq,sysRadios.com2Flip,45,31)
	imgui.SameLine()
	kc_imgui_label_mcp("|",45)
	imgui.SameLine()
	kc_imgui_nav_radio("NAV2:",sysRadios.nav2StbyCourse,sysRadios.nav2StbyFine,sysRadios.nav2StandbyFreq,sysRadios.nav2ActiveFreq,sysRadios.nav2Flip,45,32)
	imgui.SameLine()
	kc_imgui_label_mcp("|",45)
	imgui.SameLine()
	kc_imgui_adf_radio("ADF2:",sysRadios.adf2StbyCourse,sysRadios.adf2StbyFine,sysRadios.adf2StandbyFreq,sysRadios.adf2ActiveFreq,sysRadios.adf2Flip,45,33)
	imgui.SameLine()

end

return sysRadios
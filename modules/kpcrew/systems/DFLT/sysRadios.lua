-- DFLT airplane 
-- Radio functionality

-- @classmod sysRadio
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysRadio = {
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
sysRadio.com1StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com1_fine_down_833","sim/radios/stby_com1_fine_up_833",118000,136990,false)
sysRadio.com1StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com1_coarse_down","sim/radios/stby_com1_coarse_up",118000,136990,false)
sysRadio.com1Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/com1_right_is_selected",0,
	"sim/radios/com1_standy_flip")

sysRadio.com1ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com1_frequency_hz_833",0)
sysRadio.com1StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0)

sysRadio.com2StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com2_fine_down_833","sim/radios/stby_com2_fine_up_833",118000,136990,false)
sysRadio.com2StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833",0,
	"sim/radios/stby_com2_coarse_down","sim/radios/stby_com2_coarse_up",118000,136990,false)
sysRadio.com2Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/com2_right_is_selected",0,
	"sim/radios/com2_standy_flip")

sysRadio.com2ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com2_frequency_hz_833",0)
sysRadio.com2StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit2/radios/actuators/com2_standby_frequency_hz_833",0)

-- ===== NAV Radios =====
sysRadio.nav1StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav1_stdby_freq_hz",0,
	"sim/radios/stby_nav1_fine_down","sim/radios/stby_nav1_fine_up",10800,11795,false)
sysRadio.nav1StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav1_stdby_freq_hz",0,
	"sim/radios/stby_nav1_coarse_down","sim/radios/stby_nav1_coarse_up",10800,11795,false)
sysRadio.nav1Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/nav1_right_is_selected",0,
	"sim/radios/nav1_standy_flip")

sysRadio.nav1ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav1_freq_hz",0)
sysRadio.nav1StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav1_stdby_freq_hz",0)

sysRadio.nav2StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav2_stdby_freq_hz",0,
	"sim/radios/stby_nav2_fine_down","sim/radios/stby_nav2_fine_up",10800,11795,false)
sysRadio.nav2StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/nav2_stdby_freq_hz",0,
	"sim/radios/stby_nav2_coarse_down","sim/radios/stby_nav2_coarse_up",10800,11795,false)
sysRadio.nav2Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/nav2_right_is_selected",0,
	"sim/radios/nav2_standy_flip")

sysRadio.nav2ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav2_freq_hz",0)
sysRadio.nav2StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/nav2_stdby_freq_hz",0)

-- ===== ADF =====
sysRadio.adf1StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf1_stdby_freq_hz",0,
	"sim/radios/stby_adf1_ones_tens_down","sim/radios/stby_adf1_ones_tens_up",190,1750,false)
sysRadio.adf1StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf1_stdby_freq_hz",0,
	"sim/radios/stby_adf1_hundreds_thous_down","sim/radios/stby_adf1_hundreds_thous_up",190,1750,false)
sysRadio.adf1Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/adf1_right_is_selected",0,
	"sim/radios/adf1_standy_flip")

sysRadio.adf1ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf1_freq_hz",0)
sysRadio.adf1StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf1_stdby_freq_hz",0)

sysRadio.adf2StbyFine 		= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf2_stdby_freq_hz",0,
	"sim/radios/stby_adf2_ones_tens_down","sim/radios/stby_adf2_ones_tens_up",190,1750,false)
sysRadio.adf2StbyCourse 	= MultiStateCmdSwitch:new("","sim/cockpit/radios/adf2_stdby_freq_hz",0,
	"sim/radios/stby_adf2_hundreds_thous_down","sim/radios/stby_adf2_hundreds_thous_up",190,1750,false)
sysRadio.adf2Flip 			= TwoStateToggleSwitch:new("","sim/cockpit2/radios/actuators/adf2_right_is_selected",0,
	"sim/radios/adf2_standy_flip")

sysRadio.adf2ActiveFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf2_freq_hz",0)
sysRadio.adf2StandbyFreq 	= SimpleAnnunciator:new("","sim/cockpit/radios/adf2_stdby_freq_hz",0)

sysRadio.xpdrSwitch 		= InopSwitch:new ("xpdr")


-- render the MCP part
function sysRadio:render(ypos,height)

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
			float_wnd_set_geometry(kh_radio_wnd, 0, ypos, 825, ypos-height)
		end
	end

	imgui.SameLine()
	kc_imgui_com_radio("COM1:",sysRadio.com1StbyCourse,sysRadio.com1StbyFine,sysRadio.com1StandbyFreq,sysRadio.com1ActiveFreq,sysRadio.com1Flip,10,21)
	imgui.SameLine()
	kc_imgui_label_mcp("|",10)
	imgui.SameLine()
	kc_imgui_nav_radio("NAV1:",sysRadio.nav1StbyCourse,sysRadio.nav1StbyFine,sysRadio.nav1StandbyFreq,sysRadio.nav1ActiveFreq,sysRadio.nav1Flip,10,22)
	imgui.SameLine()
	kc_imgui_label_mcp("|",10)
	imgui.SameLine()
	kc_imgui_adf_radio("ADF1:",sysRadio.adf1StbyCourse,sysRadio.adf1StbyFine,sysRadio.adf1StandbyFreq,sysRadio.adf1ActiveFreq,sysRadio.adf1Flip,10,23)
	
	imgui.SetCursorPosX(25)
	kc_imgui_com_radio("COM2:",sysRadio.com2StbyCourse,sysRadio.com2StbyFine,sysRadio.com2StandbyFreq,sysRadio.com2ActiveFreq,sysRadio.com2Flip,45,31)
	imgui.SameLine()
	kc_imgui_label_mcp("|",45)
	imgui.SameLine()
	kc_imgui_nav_radio("NAV2:",sysRadio.nav2StbyCourse,sysRadio.nav2StbyFine,sysRadio.nav2StandbyFreq,sysRadio.nav2ActiveFreq,sysRadio.nav2Flip,45,32)
	imgui.SameLine()
	kc_imgui_label_mcp("|",45)
	imgui.SameLine()
	kc_imgui_adf_radio("ADF2:",sysRadio.adf2StbyCourse,sysRadio.adf2StbyFine,sysRadio.adf2StandbyFreq,sysRadio.adf2ActiveFreq,sysRadio.adf2Flip,45,33)
	imgui.SameLine()

end

return sysRadio
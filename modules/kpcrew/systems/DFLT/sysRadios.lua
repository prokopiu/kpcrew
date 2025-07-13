-- DFLT airplane 
-- Radio functionality

-- @classmod sysRadio
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysRadios = {
}

logMsg("DFLT sysRadio")

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

--------- Switch datarefs common

local drefCom1Flip 			= "sim/cockpit2/radios/actuators/com1_right_is_selected"
local drefCom2Flip 			= "sim/cockpit2/radios/actuators/com2_right_is_selected"
local drefNav1Flip 			= "sim/cockpit2/radios/actuators/nav1_right_is_selected"
local drefNav2Flip 			= "sim/cockpit2/radios/actuators/nav2_right_is_selected"
local drefAdf1Flip 			= "sim/cockpit2/radios/actuators/adf1_right_is_selected"
local drefAdf2Flip 			= "sim/cockpit2/radios/actuators/adf2_right_is_selected"
local drefXpdrSwitch 		= "sim/cockpit2/radios/actuators/transponder_mode"
local drefXpdrCode 			= "sim/cockpit2/radios/actuators/transponder_code"

--------- Annunciator datarefs common

local drefCom1ActiveFreq 	= "sim/cockpit2/radios/actuators/com1_frequency_hz_833"
local drefCom1StandbyFreq 	= "sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833"
local drefCom2ActiveFreq 	= "sim/cockpit2/radios/actuators/com2_frequency_hz_833"
local drefCom2StandbyFreq 	= "sim/cockpit2/radios/actuators/com2_standby_frequency_hz_833"
local drefNav1ActiveFreq 	= "sim/cockpit/radios/nav1_freq_hz"
local drefNav1StandbyFreq 	= "sim/cockpit/radios/nav1_stdby_freq_hz"
local drefNav2ActiveFreq 	= "sim/cockpit/radios/nav2_freq_hz"
local drefNav2StandbyFreq 	= "sim/cockpit/radios/nav2_stdby_freq_hz"
local drefAdf1ActiveFreq 	= "sim/cockpit/radios/adf1_freq_hz"
local drefAdf1StandbyFreq 	= "sim/cockpit/radios/adf1_stdby_freq_hz"
local drefAdf2ActiveFreq 	= "sim/cockpit/radios/adf2_freq_hz"
local drefAdf2StandbyFreq 	= "sim/cockpit/radios/adf2_stdby_freq_hz"

--------- Switch commands common

local cmdCom1FineDown		= "sim/radios/stby_com1_fine_down_833"
local cmdCom1FineUp			= "sim/radios/stby_com1_fine_up_833"
local cmdCom1CoarseDown		= "sim/radios/stby_com1_coarse_down"
local cmdCom1CoarseUp		= "sim/radios/stby_com1_coarse_up"
local cmdCom1Flip			= "sim/radios/com1_standy_flip"
local cmdCom2FineDown		= "sim/radios/stby_com2_fine_down_833"
local cmdCom2FineUp			= "sim/radios/stby_com2_fine_up_833"
local cmdCom2CoarseDown		= "sim/radios/stby_com2_coarse_down"
local cmdCom2CoarseUp		= "sim/radios/stby_com2_coarse_up"
local cmdCom2Flip			= "sim/radios/com2_standy_flip"
local cmdNav1FineDown		= "sim/radios/stby_nav1_fine_down"
local cmdNav1FineUp			= "sim/radios/stby_nav1_fine_up"
local cmdNav1CoarseDown		= "sim/radios/stby_nav1_coarse_down"
local cmdNav1CoarseUp		= "sim/radios/stby_nav1_coarse_up"
local cmdNav1Flip			= "sim/radios/nav1_standy_flip"
local cmdNav2FineDown		= "sim/radios/stby_nav2_fine_down"
local cmdNav2FineUp			= "sim/radios/stby_nav2_fine_up"
local cmdNav2CoarseDown		= "sim/radios/stby_nav2_coarse_down"
local cmdNav2CoarseUp		= "sim/radios/stby_nav2_coarse_up"
local cmdNav2Flip			= "sim/radios/nav2_standy_flip"
local cmdAdf1FineDown		= "sim/radios/stby_adf1_ones_tens_down"
local cmdAdf1FineUp			= "sim/radios/stby_adf1_ones_tens_up"
local cmdAdf1CoarseDown		= "sim/radios/stby_adf1_hundreds_thous_down"
local cmdAdf1CoarseUp		= "sim/radios/stby_adf1_hundreds_thous_up"
local cmdAdf1Flip			= "sim/radios/adf1_standy_flip"
local cmdAdf2FineDown		= "sim/radios/stby_adf2_ones_tens_down"
local cmdAdf2FineUp			= "sim/radios/stby_adf2_ones_tens_up"
local cmdAdf2CoarseDown		= "sim/radios/stby_adf2_hundreds_thous_down"
local cmdAdf2CoarseUp		= "sim/radios/stby_adf2_hundreds_thous_up"
local cmdAdf2Flip			= "sim/radios/adf2_standy_flip"

--------- Actuator definitions

-- ===== COM Radios =====
sysRadios.com1StbyFine 		= MultiStateCmdSwitch:new("",drefCom1StandbyFreq,0,
	cmdCom1FineDown,cmdCom1FineUp,118000,136990,false)
sysRadios.com1StbyCourse 	= MultiStateCmdSwitch:new("",drefCom1StandbyFreq,0,
	cmdCom1CoarseDown,cmdCom1CoarseUp,118000,136990,false)
sysRadios.com1Flip 			= TwoStateToggleSwitch:new("",drefCom1Flip,0,
	cmdCom1Flip)

sysRadios.com1Direct 		= MultiStateCmdSwitch:new("",drefCom1ActiveFreq,0,
	cmdCom1FineDown,cmdCom1FineUp,118000,136990,false)
sysRadios.com1ActiveFreq 	= SimpleAnnunciator:new("",drefCom1ActiveFreq,0)
sysRadios.com1StandbyFreq 	= SimpleAnnunciator:new("",drefCom1StandbyFreq,0)

sysRadios.com2StbyFine 		= MultiStateCmdSwitch:new("",drefCom2StandbyFreq,0,
	cmdCom2FineDown,cmdCom2FineUp,118000,136990,false)
sysRadios.com2StbyCourse 	= MultiStateCmdSwitch:new("",drefCom2StandbyFreq,0,
	cmdCom2CoarseDown,cmdCom2CoarseUp,118000,136990,false)
sysRadios.com2Flip 			= TwoStateToggleSwitch:new("",drefCom2Flip,0,
	cmdCom2Flip)

sysRadios.com2ActiveFreq 	= SimpleAnnunciator:new("",drefCom2ActiveFreq,0)
sysRadios.com2StandbyFreq 	= SimpleAnnunciator:new("",drefCom2StandbyFreq,0)

-- ===== NAV Radios =====
sysRadios.nav1StbyFine 		= MultiStateCmdSwitch:new("",drefNav1StandbyFreq,0,
	cmdNav1FineDown,cmdNav1FineUp,10800,11795,false)
sysRadios.nav1StbyCourse 	= MultiStateCmdSwitch:new("",drefNav1StandbyFreq,0,
	cmdNav1CoarseDown,cmdNav1CoarseUp,10800,11795,false)
sysRadios.nav1Flip 			= TwoStateToggleSwitch:new("",drefNav1Flip,0,
	cmdNav1Flip)

sysRadios.nav1ActiveFreq 	= SimpleAnnunciator:new("",drefNav1ActiveFreq,0)
sysRadios.nav1StandbyFreq 	= SimpleAnnunciator:new("",drefNav1StandbyFreq,0)

sysRadios.nav2StbyFine 		= MultiStateCmdSwitch:new("",drefNav2StandbyFreq,0,
	cmdNav2FineDown,cmdNav2FineUp,10800,11795,false)
sysRadios.nav2StbyCourse 	= MultiStateCmdSwitch:new("",drefNav2StandbyFreq,0,
	cmdNav2CoarseDown,cmdNav2CoarseUp,10800,11795,false)
sysRadios.nav2Flip 			= TwoStateToggleSwitch:new("",drefNav2Flip,0,
	cmdNav2Flip)

sysRadios.nav2ActiveFreq 	= SimpleAnnunciator:new("",drefNav2ActiveFreq,0)
sysRadios.nav2StandbyFreq 	= SimpleAnnunciator:new("",drefNav2StandbyFreq,0)

-- ===== ADF =====
sysRadios.adf1StbyFine 		= MultiStateCmdSwitch:new("",drefAdf1StandbyFreq,0,
	cmdAdf1FineDown,cmdAdf1FineUp,190,1750,false)
sysRadios.adf1StbyCourse 	= MultiStateCmdSwitch:new("",drefAdf1StandbyFreq,0,
	cmdAdf1CoarseDown,cmdAdf1CoarseUp,190,1750,false)
sysRadios.adf1Flip 			= TwoStateToggleSwitch:new("",drefAdf1Flip,0,
	cmdAdf1Flip)

sysRadios.adf1ActiveFreq 	= SimpleAnnunciator:new("",drefAdf1ActiveFreq,0)
sysRadios.adf1StandbyFreq 	= SimpleAnnunciator:new("",drefAdf1StandbyFreq,0)

sysRadios.adf2StbyFine 		= MultiStateCmdSwitch:new("",drefAdf2StandbyFreq,0,
	cmdAdf2FineDown,cmdAdf2FineUp,190,1750,false)
sysRadios.adf2StbyCourse 	= MultiStateCmdSwitch:new("",drefAdf2StandbyFreq,0,
	cmdAdf2CoarseDown,cmdAdf2CoarseUp,190,1750,false)
sysRadios.adf2Flip 			= TwoStateToggleSwitch:new("",drefAdf2Flip,0,
	cmdAdf2Flip)

sysRadios.adf2ActiveFreq 	= SimpleAnnunciator:new("",drefAdf2ActiveFreq,0)
sysRadios.adf2StandbyFreq 	= SimpleAnnunciator:new("",drefAdf2StandbyFreq,0)

sysRadios.xpdrSwitch 		= TwoStateDrefSwitch:new ("xpdrmode",drefXpdrSwitch,0)
sysRadios.xpdrCode 			= TwoStateDrefSwitch:new ("xpdrcode",drefXpdrCode,0)

sysRadios.off				= 0
sysRadios.stby				= 1
sysRadios.alt				= 2
sysRadios.ta				= 2
sysRadios.tara				= 3

-- ===== UI related functions =====

function sysRadios:panel_render()
	imgui.BeginGroup()
		imgui.TextUnformatted("RADIOS  ")
		imgui.SameLine()		
		if imgui.Button("SAVE", 56*kb_font_scale, 19) then
			activeBriefings:save()
		end
		imgui.SameLine()
		if imgui.Button("LOAD", 56*kb_font_scale, 19*kb_font_scale) then
			activeBriefings:load()
		end
-- ATIS Store
		kc_imgui_stored_com("departure:atisFreq","ATISD",sysRadios.com1Direct,sysRadios.com1Direct,10,41)
		imgui.SameLine()
-- COM1 Radio
		kc_imgui_com_radio("COM1",sysRadios.com1StbyCourse,sysRadios.com1StbyFine,sysRadios.com1StandbyFreq,sysRadios.com1ActiveFreq,sysRadios.com1Flip,10,21)

-- ATIS Store
		kc_imgui_stored_com("departure:clearanceFreq","CLRNCE",sysRadios.com1Direct,sysRadios.com1Direct,10,42)
		imgui.SameLine()
-- COM2 Radio
		kc_imgui_com_radio("COM2",sysRadios.com2StbyCourse,sysRadios.com2StbyFine,sysRadios.com2StandbyFreq,sysRadios.com2ActiveFreq,sysRadios.com2Flip,45,31)

-- GRND Store
		kc_imgui_stored_com("departure:groundFreq","GROUNDD",sysRadios.com1Direct,sysRadios.com1Direct,10,43)
-- NAV1 Radio
		if kc_has_nav_radios then
			imgui.SameLine()
			kc_imgui_nav_radio("NAV1",sysRadios.nav1StbyCourse,sysRadios.nav1StbyFine,sysRadios.nav1StandbyFreq,sysRadios.nav1ActiveFreq,sysRadios.nav1Flip,10,22)
		end
-- TOWER Store
		kc_imgui_stored_com("departure:towerFreq","TOWERD",sysRadios.com1Direct,sysRadios.com1Direct,10,44)
-- NAV2 Radio
		if kc_has_nav_radios then
			imgui.SameLine()
			kc_imgui_nav_radio("NAV2",sysRadios.nav2StbyCourse,sysRadios.nav2StbyFine,sysRadios.nav2StandbyFreq,sysRadios.nav2ActiveFreq,sysRadios.nav2Flip,45,32)
		end
-- TOWER Store
		kc_imgui_stored_com("departure:departureFreq","DEPART",sysRadios.com1Direct,sysRadios.com1Direct,10,45)
-- ADF1 Radio
		if kc_has_adf_radios then
			imgui.SameLine()
			kc_imgui_adf_radio("ADF1",sysRadios.adf1StbyCourse,sysRadios.adf1StbyFine,sysRadios.adf1StandbyFreq,sysRadios.adf1ActiveFreq,sysRadios.adf1Flip,10,23)
		end
-- CENTER 1 Store
		kc_imgui_stored_com("departure:center1Freq","CTR1",sysRadios.com1Direct,sysRadios.com1Direct,10,46)
-- ADF2 Radio
		if kc_has_adf_radios then
			imgui.SameLine()
			kc_imgui_adf_radio("ADF2",sysRadios.adf2StbyCourse,sysRadios.adf2StbyFine,sysRadios.adf2StandbyFreq,sysRadios.adf2ActiveFreq,sysRadios.adf2Flip,45,33)
		end
-- CENTER 2 Store
		kc_imgui_stored_com("departure:center2Freq","CTR2",sysRadios.com1Direct,sysRadios.com1Direct,10,47)
-- ATIS Store
		kc_imgui_stored_com("arrival:atisFreq","ATISA",sysRadios.com1Direct,sysRadios.com1Direct,10,51)
		imgui.SameLine()
		if kc_has_transponder then
			imgui.SameLine()
			kc_imgui_number_mcp("XPDR",sysRadios.xpdrCode,60,38,5)
		end
-- APPROACH Store
		kc_imgui_stored_com("arrival:approachFreq","APPRCH",sysRadios.com1Direct,sysRadios.com1Direct,10,48)
		if kc_has_transponder then
			imgui.SameLine()
			kc_imgui_script_button("OFF","kc_macro_set_xpdrmode(sysRadios.off)",10,28,19)
			imgui.SameLine()
			kc_imgui_script_button("STB","kc_macro_set_xpdrmode(sysRadios.stby)",10,28,19)
			imgui.SameLine()
			kc_imgui_script_button("ALT","kc_macro_set_xpdrmode(sysRadios.alt)",10,28,19)
			imgui.SameLine()
			kc_imgui_script_button("TA","kc_macro_set_xpdrmode(sysRadios.ta)",10,28,19)
			imgui.SameLine()
			kc_imgui_script_button("ON","kc_macro_set_xpdrmode(sysRadios.tara)",10,28,19)
		end
-- TOWER 2 Store
		kc_imgui_stored_com("arrival:towerFreq","TOWERA",sysRadios.com1Direct,sysRadios.com1Direct,10,49)
-- GROUND 2 Store
		kc_imgui_stored_com("arrival:groundFreq","GROUNDA",sysRadios.com1Direct,sysRadios.com1Direct,10,50)

		imgui.Separator()
	imgui.EndGroup()
end

return sysRadios
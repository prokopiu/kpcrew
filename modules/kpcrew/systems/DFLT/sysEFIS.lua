-- DFLT airplane 
-- EFIS/BARO functionality

-- @classmod sysEFIS
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysEFIS.mapZoomPilot 
-- sysEFIS.mapZoomCopilot
-- sysEFIS.mapModePilot 
-- sysEFIS.mapModeCopilot
-- sysEFIS.ctrPilot 	
-- sysEFIS.ctrCopilot 	
-- sysEFIS.tfcPilot 	
-- sysEFIS.tfcCopilot 	
-- sysEFIS.wxrPilot 	
-- sysEFIS.wxrCopilot 	
-- sysEFIS.staPilot 	
-- sysEFIS.staCopilot 	
-- sysEFIS.wptPilot 	
-- sysEFIS.wptCopilot 	
-- sysEFIS.arptPilot 	
-- sysEFIS.arptCopilot 
-- sysEFIS.dataPilot 	
-- sysEFIS.dataCopilot 
-- sysEFIS.posPilot 	
-- sysEFIS.posCopilot 	
-- sysEFIS.terrPilot 	
-- sysEFIS.terrCopilot 
-- sysEFIS.fpvPilot 	
-- sysEFIS.fpvCopilot 	
-- sysEFIS.mtrsPilot 	
-- sysEFIS.mtrsCopilot 
-- sysEFIS.minsTypePilot 	
-- sysEFIS.minsTypeCopilot 
-- sysEFIS.minsResetPilot 	
-- sysEFIS.minsResetCopilot
-- sysEFIS.minsPilot 		
-- sysEFIS.minsCopilot 	
-- sysEFIS.voradf1Pilot 	
-- sysEFIS.voradf1Copilot 	
-- sysEFIS.voradf2Pilot 	
-- sysEFIS.voradf2Copilot 	
-- sysEFIS.baroMbar 		
-- sysEFIS.baroInhg 		
-- sysEFIS.barostdPilot 	
-- sysEFIS.barostdCopilot 	
-- sysEFIS.barostdStandby 	
-- sysEFIS.barostdGroup 	
-- sysEFIS.baroModePilot 	
-- sysEFIS.baroModeCoPilot 
-- sysEFIS.baroModeStandby 
-- sysEFIS.baroModeGroup 	
-- sysEFIS.baroPilot 		
-- sysEFIS.baroCoPilot 	
-- sysEFIS.baroStandby 	
-- sysEFIS.baroGroup 	
-- UI: panel_render	

local sysEFIS = {
	mapRange_5 		= 0,
	mapRange10 		= 1,
	mapRange20 		= 2,
	mapRange40 		= 3,
	mapRange80 		= 4,
	mapRange160 	= 5,
	mapRange320 	= 6,
	mapRange640 	= 6,
	
	mapModeAPP 		= 0,
	mapModeVOR 		= 1,
	mapModeMAP 		= 2,
	mapModePLAN 	= 4,
	
	voradfVOR 		= 1,
	voradfOFF 		= 0,
	voradfADF 		= -1,
	
	minsTypeRadio 	= 0,
	minsTypeBaro 	= 1
}

logMsg("DFLT sysEFIS")

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

--------- Switch datarefs common
local drefBaroLeft			= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"
local drefBaroRight 		= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot"
local drefBaroStby	 		= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby"
local drefCurrentBaro 		= "sim/weather/barometer_sealevel_inhg"
local drefEFISMapRangeL		= "sim/cockpit/switches/EFIS_map_range_selector"
local drefEFISMapRangeR		= "sim/cockpit/switches/EFIS_map_range_selector"
local drefWXRModeL			= "sim/cockpit2/EFIS/EFIS_weather_on"
local drefWXRModeR			= "sim/cockpit2/EFIS/EFIS_weather_on_copilot"
local drefEFISModeSTAVOR	= "sim/cockpit2/EFIS/EFIS_vor_on"
local drefEFISModeWPT		= "sim/cockpit2/EFIS/EFIS_fix_on"
local drefEFISModeARPT		= "sim/cockpit/switches/EFIS_shows_airports"
local drefEFISMinimums		= "sim/cockpit2/gauges/actuators/baro_altimeter_bug_ft_pilot"
local drefBaroStandard		= "sim/cockpit/misc/barometer_setting"

--------- Switch commands common
local cmdBaroLeftDown		= "sim/instruments/barometer_down"
local cmdBaroLeftUp			= "sim/instruments/barometer_up"
local cmdBaroRightDown		= "sim/instruments/barometer_copilot_down"
local cmdBaroRightUp		= "sim/instruments/barometer_copilot_up"
local cmdBaroStbyDown		= "sim/instruments/barometer_stby_down"
local cmdBaroStbyUp			= "sim/instruments/barometer_stby_up"
local cmdWXRTglL			= "sim/instruments/EFIS_wxr"
local cmdWXRTglR			= "sim/instruments/EFIS_copilot_wxr"
local cmdEFISMapZoomInL		= "sim/instruments/map_zoom_in"
local cmdEFISMapZoomOutL	= "sim/instruments/map_zoom_out"
local cmdEFISModeSTAVOR		= "sim/instruments/EFIS_vor"
local cmdEFISModeWPT		= "sim/instruments/EFIS_fix"
local cmdEFISModeARPT		= "sim/instruments/EFIS_apt"
local cmdBaroStandard		= "sim/instruments/barometer_std"

------------- Switches

-- MAP ZOOM G1000
sysEFIS.mapZoomPilot 		= TwoStateCustomSwitch:new("mapzoompilot",drefEFISMapRangeL,0,
	function ()
		command_once("sim/GPS/g1000n3_range_up")
		command_once("sim/GPS/g1000n1_range_up")
		command_once(cmdEFISMapZoomOutL)
	end,
	function ()
		command_once("sim/GPS/g1000n3_range_down")
		command_once("sim/GPS/g1000n1_range_down")
		command_once(cmdEFISMapZoomInL)
	end,
	function () end,
	function () return 1 end)
-- default only one ND display
sysEFIS.mapZoomCopilot 		= TwoStateCustomSwitch:new("mapzoomcopilot",drefEFISMapRangeR,0,
	function ()
		command_once("sim/GPS/g1000n3_range_up")
		command_once("sim/GPS/g1000n2_range_up")
		command_once(cmdEFISMapZoomOutL)
	end,
	function ()
		command_once("sim/GPS/g1000n3_range_down")
		command_once("sim/GPS/g1000n2_range_down")
		command_once(cmdEFISMapZoomInL)
	end,
	function () end,
	function () return 1 end)

-- MAP MODE
sysEFIS.mapModePilot 		= InopSwitch:new("mapmodepilot")
sysEFIS.mapModeCopilot 		= InopSwitch:new("mapmodecopilot")

-- CTR
sysEFIS.ctrPilot 			= InopSwitch:new("ctrpilot")
sysEFIS.ctrCopilot 			= InopSwitch:new("ctrcopilot")

-- TFC
sysEFIS.tfcPilot 			= InopSwitch:new("tfcpilot")
sysEFIS.tfcCopilot 			= InopSwitch:new("tfccopilot")

-- WX 
sysEFIS.wxrPilot 			= TwoStateToggleSwitch:new("wxrpilot",drefWXRModeL,0,cmdWXRTglL)
sysEFIS.wxrCopilot 			= TwoStateToggleSwitch:new("wxrcopilot",drefWXRModeR,0,cmdWXRTglR)

-- STA / VOR
sysEFIS.staPilot 			= TwoStateToggleSwitch:new("stapilot",drefEFISModeSTAVOR,0,cmdEFISModeSTAVOR)
sysEFIS.staCopilot 			= InopSwitch:new("stacopilot")

-- WPT
sysEFIS.wptPilot 			= TwoStateToggleSwitch:new("wptpilot",drefEFISModeWPT,0,cmdEFISModeWPT)
sysEFIS.wptCopilot 			= InopSwitch:new("wptcopilot")

-- ARPT
sysEFIS.arptPilot 			= TwoStateToggleSwitch:new("arptpilot",drefEFISModeARPT,0,cmdEFISModeARPT)
sysEFIS.arptCopilot 		= InopSwitch:new("arptcopilot")

-- DATA
sysEFIS.dataPilot 			= InopSwitch:new("datapilot")
sysEFIS.dataCopilot 		= InopSwitch:new("datacopilot")

-- NAV/POS
sysEFIS.posPilot 			= InopSwitch:new("pospilot")
sysEFIS.posCopilot 			= InopSwitch:new("poscopilot")

-- TERR
sysEFIS.terrPilot 			= InopSwitch:new("terrpilot")
sysEFIS.terrCopilot 		= InopSwitch:new("terrcopilot")

-- FPV
sysEFIS.fpvPilot 			= InopSwitch:new("fpvpilot")
sysEFIS.fpvCopilot 			= InopSwitch:new("fpvcopilot")

-- MTRS
sysEFIS.mtrsPilot 			= InopSwitch:new("mtrspilot")
sysEFIS.mtrsCopilot 		= InopSwitch:new("mtrscopilot")

-- MINS type
sysEFIS.minsTypePilot 		= InopSwitch:new("minstypepilot")
sysEFIS.minsTypeCopilot 	= InopSwitch:new("minstypecopilot")

-- MINS RESET
sysEFIS.minsResetPilot 		= InopSwitch:new("minsresetpilot")
sysEFIS.minsResetCopilot 	= InopSwitch:new("minsresetcopilot")

-- MINS SET
sysEFIS.minsPilot 			= TwoStateDrefSwitch:new("minspilot",drefEFISMinimums,0)
sysEFIS.minsCopilot 		= InopSwitch:new("minscopilot")

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= InopSwitch:new("voradf1pilot")
sysEFIS.voradf1Copilot 		= InopSwitch:new("voradf1copilot")

-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= InopSwitch:new("vorad2pilot")
sysEFIS.voradf2Copilot 		= InopSwitch:new("vorad2copilot")

-- Baro section

-- baro mbar/inhg
sysEFIS.baroMbar 			= TwoStateCustomSwitch:new("mbar",drefBaroLeft,0,
function () end, function () end, function () end,
function () return string.format("%04.0f",get(drefBaroLeft) * 33.8639) end,
function () end, function (value) return value / 33.87 end)

sysEFIS.baroInhg 			= TwoStateCustomSwitch:new("inhg",drefBaroLeft,0,
function () end, function () end, function () end, 
function () return string.format("%05.2f",get(drefBaroLeft)) end)

-- Baro standard toggle
sysEFIS.barostdPilot 	= TwoStateToggleSwitch:new("barostdpilot",drefBaroStandard,0,cmdBaroStandard)
sysEFIS.barostdCopilot 	= InopSwitch:new("barostdcopilot")
sysEFIS.barostdStandby 	= InopSwitch:new("barostdstandby")
sysEFIS.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdPilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdCopilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdStandby)

-- Baro mode
sysEFIS.baroModePilot 	= InopSwitch:new("baromodepilot")
sysEFIS.baroModeCoPilot = InopSwitch:new("baromodecopilot")
sysEFIS.baroModeStandby = InopSwitch:new("baromodecopilot")
sysEFIS.baroModeGroup 	= SwitchGroup:new("baromodegroup")
sysEFIS.baroModeGroup:addSwitch(sysEFIS.baroModePilot)
sysEFIS.baroModeGroup:addSwitch(sysEFIS.baroModeCoPilot)
sysEFIS.baroModeGroup:addSwitch(sysEFIS.baroModeStandby)

-- Baro value
sysEFIS.baroPilot 		= MultiStateCmdSwitch:new("baropilot",drefBaroLeft,0,cmdBaroLeftDown,cmdBaroLeftUp)
sysEFIS.baroCoPilot 	= MultiStateCmdSwitch:new("barocopilot",drefBaroRight,0,cmdBaroRightDown,cmdBaroRightUp)
sysEFIS.baroStandby 	= MultiStateCmdSwitch:new("barostandby",drefBaroStby,0,cmdBaroStbyDown,cmdBaroStbyUp)
sysEFIS.baroGroup 		= SwitchGroup:new("barogroup")
sysEFIS.baroGroup:addSwitch(sysEFIS.baroPilot)
sysEFIS.baroGroup:addSwitch(sysEFIS.baroCoPilot)
sysEFIS.baroGroup:addSwitch(sysEFIS.baroStandby)


-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("sim/cockpit/misc/barometer_setting",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit/misc/barometer_setting2",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end


----- UI releated functions
function sysEFIS.panel_render()
	imgui.BeginGroup()

		kc_imgui_script_button("MAP -","sysEFIS.mapZoomPilot:actuate(0)",-1,40,19)
		imgui.SameLine()
		kc_imgui_script_button("MAP +","sysEFIS.mapZoomPilot:actuate(1)",-1,40,19)
		imgui.SameLine()
		kc_imgui_script_button("MOD -","sysEFIS.mapModePilot:actuate(0)",-1,40,19)
		imgui.SameLine()
		kc_imgui_script_button("MOD +","sysEFIS.mapModePilot:actuate(1)",-1,40,19)
	
		imgui.Separator()
		-- imgui.TextUnformatted("BARO MIN:")
		kc_imgui_number_mcp("BARO MIN:",sysEFIS.minsPilot,31,40,5)

		imgui.Separator()
		
		kc_imgui_cmd_button("STD","sim/instruments/barometer_std",10,40,19)
		imgui.SameLine()
		kc_imgui_number_mcp("MB",sysEFIS.baroMbar,124,40,5)
		imgui.SameLine()
		kc_imgui_number_mcp("IN",sysEFIS.baroInhg,112,45,6)

		imgui.Separator()
		
	imgui.EndGroup()		
end

return sysEFIS
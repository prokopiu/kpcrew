-- DFLT airplane 
-- EFIS/BARO functionality

-- @classmod sysEFIS
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

local drefBaroLeft			= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"
local drefBaroRight 		= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot"
local drefBaroStby	 		= "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby"
local drefCurrentBaro 		= "sim/weather/barometer_sealevel_inhg"
local cmdBaroLeftDown		= "sim/instruments/barometer_down"
local cmdBaroLeftUp			= "sim/instruments/barometer_up"
local cmdBaroRightDown		= "sim/instruments/barometer_copilot_down"
local cmdBaroRightUp		= "sim/instruments/barometer_copilot_up"
local cmdBaroStbyDown		= "sim/instruments/barometer_stby_down"
local cmdBaroStbyUp			= "sim/instruments/barometer_stby_up"

------------- Switches

-- MAP ZOOM G1000
sysEFIS.mapZoomPilot 		= TwoStateCustomSwitch:new("mapzoompilot","sim/cockpit/switches/EFIS_map_range_selector",0,
	function ()
		command_once("sim/GPS/g1000n3_range_up")
		command_once("sim/GPS/g1000n1_range_up")
		command_once("sim/instruments/map_zoom_out")
	end,
	function ()
		command_once("sim/GPS/g1000n3_range_down")
		command_once("sim/GPS/g1000n1_range_down")
		command_once("sim/instruments/map_zoom_in")
	end,
	function ()
	end,
	function ()
		return 1
	end)
sysEFIS.mapZoomCopilot 		= TwoStateCustomSwitch:new("mapzoomcopilot","sim/cockpit/switches/EFIS_map_range_selector",0,
	function ()
		command_once("sim/GPS/g1000n3_range_up")
		command_once("sim/GPS/g1000n2_range_up")
		command_once("sim/instruments/map_zoom_out")
	end,
	function ()
		command_once("sim/GPS/g1000n3_range_down")
		command_once("sim/GPS/g1000n2_range_down")
		command_once("sim/instruments/map_zoom_in")
	end,
	function ()
	end,
	function ()
		return 1
	end)

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
sysEFIS.wxrPilot 			= TwoStateToggleSwitch:new("wxrpilot","sim/cockpit2/EFIS/EFIS_weather_on",0,
	"sim/instruments/EFIS_wxr")
sysEFIS.wxrCopilot 			= TwoStateToggleSwitch:new("wxrcopilot","sim/cockpit2/EFIS/EFIS_weather_on_copilot",0,
	"sim/instruments/EFIS_copilot_wxr")

-- STA / VOR
sysEFIS.staPilot 			= TwoStateToggleSwitch:new("stapilot","sim/cockpit2/EFIS/EFIS_vor_on",0,
	"sim/instruments/EFIS_vor")
sysEFIS.staCopilot 			= InopSwitch:new("stacopilot")

-- WPT
sysEFIS.wptPilot 			= TwoStateToggleSwitch:new("wptpilot","sim/cockpit2/EFIS/EFIS_fix_on",0,
	"sim/instruments/EFIS_fix")
sysEFIS.wptCopilot 			= InopSwitch:new("wptcopilot")

-- ARPT
sysEFIS.arptPilot 			= TwoStateToggleSwitch:new("arptpilot","sim/cockpit/switches/EFIS_shows_airports",0,
	"sim/instruments/EFIS_apt")
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
sysEFIS.minsPilot 			= TwoStateDrefSwitch:new("minspilot","sim/cockpit2/gauges/actuators/baro_altimeter_bug_ft_pilot",0)
sysEFIS.minsCopilot 		= InopSwitch:new("minscopilot")

-- VOR/ADF 1
sysEFIS.voradf1Pilot 		= InopSwitch:new("voradf1pilot")
sysEFIS.voradf1Copilot 		= InopSwitch:new("voradf1copilot")

-- VOR/ADF 2
sysEFIS.voradf2Pilot 		= InopSwitch:new("vorad2pilot")
sysEFIS.voradf2Copilot 		= InopSwitch:new("vorad2copilot")

-- Baro section

-- baro mbar/inhg
sysEFIS.baroMbar 		= TwoStateCustomSwitch:new("mbar",drefBaroLeft,0,
function () end,
function () end,
function () end,
function () 
	return string.format("%04.0f",get(drefBaroLeft) * 33.8639)
end,
function () end,
function (value) 
	return value / 33.87
end)

sysEFIS.baroInhg 		= TwoStateCustomSwitch:new("inhg",drefBaroLeft,0,
function () end,
function () end,
function () end,
function () 
	return string.format("%05.2f",get(drefBaroLeft))
end)

-- Baro standard toggle
sysEFIS.barostdPilot 	= TwoStateToggleSwitch:new("barostdpilot","sim/cockpit/misc/barometer_setting",0,
	"sim/instruments/barometer_std")
sysEFIS.barostdCopilot 	= InopSwitch:new("barostdcopilot")
sysEFIS.barostdStandby 	= InopSwitch:new("barostdstandby")
sysEFIS.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdPilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdCopilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdStandby)

-- Baro mode
sysEFIS.baroModePilot 	= InopSwitch:new("baromodepilot")
sysEFIS.baroModeCoPilot 	= InopSwitch:new("baromodecopilot")
sysEFIS.baroModeStandby 	= InopSwitch:new("baromodecopilot")
sysEFIS.baroModeGroup 	= SwitchGroup:new("baromodegroup")
sysEFIS.baroModeGroup:addSwitch(sysEFIS.baroModePilot)
sysEFIS.baroModeGroup:addSwitch(sysEFIS.baroModeCoPilot)
sysEFIS.baroModeGroup:addSwitch(sysEFIS.baroModeStandby)

-- Baro value
sysEFIS.baroPilot 		= MultiStateCmdSwitch:new("baropilot",drefBaroLeft,0,
	cmdBaroLeftDown,cmdBaroLeftUp)
sysEFIS.baroCoPilot 		= MultiStateCmdSwitch:new("barocopilot",drefBaroRight,0,
	cmdBaroRightDown,cmdBaroRightUp)
sysEFIS.baroStandby 		= MultiStateCmdSwitch:new("barostandby",drefBaroStby,0,
	cmdBaroStbyDown,cmdBaroStbyUp)
sysEFIS.baroGroup 		= SwitchGroup:new("barogroup")
sysEFIS.baroGroup:addSwitch(sysEFIS.baroPilot)
sysEFIS.baroGroup:addSwitch(sysEFIS.baroCoPilot)
sysEFIS.baroGroup:addSwitch(sysEFIS.baroStandby)


-- Baro standard toggle
sysGeneral.barostdPilot 	= sysEFIS.barostdPilot 
sysGeneral.barostdCopilot 	= sysEFIS.barostdCopilot
sysGeneral.barostdStandby 	= sysEFIS.barostdStandby
sysGeneral.barostdGroup 	= sysEFIS.barostdGroup 

-- Baro mode
sysGeneral.baroModePilot 	= sysEFIS.baroModePilot 
sysGeneral.baroModeCoPilot 	= sysEFIS.baroModeCoPilot
sysGeneral.baroModeStandby 	= sysEFIS.baroModeStandby
sysGeneral.baroModeGroup 	= sysEFIS.baroModeGroup 

-- Baro value
sysGeneral.baroPilot 		= sysEFIS.baroPilot 	
sysGeneral.baroCoPilot 		= sysEFIS.baroCoPilot 	
sysGeneral.baroStandby 		= sysEFIS.baroStandby 	
sysGeneral.baroGroup 		= sysEFIS.baroGroup 

-- baro mbar/inhg
sysGeneral.baroMbar 		= sysEFIS.baroMbar
sysGeneral.baroInhg 		= sysEFIS.baroInhg
------------- Annunciators

function sysEFIS.panel_render()
	imgui.BeginGroup()

		kc_imgui_script_button("MAP -","sysEFIS.mapZoomPilot:actuate(0)",-1,40,19)
		imgui.SameLine()
		kc_imgui_script_button("MAP +","sysEFIS.mapZoomPilot:actuate(1)",-1,40,19)
	
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
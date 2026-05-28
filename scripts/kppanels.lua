--[[
	*** KPPANELS 2.3-alpha11
	External panels window with basic functions
	Kosta Prokopiu, July 2025
--]]

require "kpcrew.genutils" -- generic imgui macros
require "kpcrew.basicmodules"

kc_VERSION = "2.3-alpha11"
kc_simversion = get("sim/version/xplane_internal_version") -- get XP version from sim

logMsg ( "FWL: ** Starting KPPanels version " .. kc_VERSION .. " on XP " .. kc_simversion .. " **" )

-- ====== Colors for UI elements ======
local color_white	= 0xFFCCCCCC
local color_orange	= 0xFF1b9af8
local color_yellow	= 0xFF00FFFF
local color_green	= 0xFF95C857

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)
kp_show_only_once = 0
kp_hide_only_once = 0

kc_acf_icao = kc_get_matching_icao_code()
logMsg("ICAO: "..kc_acf_icao)

-- ====== Get the preferences for the aircraft
if kc_file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\" .. kc_acf_icao .. ".preferences") then
	getActivePrefs():load()
end

-- ====== include aircraft specific system macros ======
sysLights 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysLights")
sysGeneral 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysGeneral")	
sysControls 	= require("kpcrew.systems." .. kc_acf_icao .. ".sysControls")	
sysEngines 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysEngines")	
sysElectric 	= require("kpcrew.systems." .. kc_acf_icao .. ".sysElectric")	
sysHydraulic 	= require("kpcrew.systems." .. kc_acf_icao .. ".sysHydraulic")	
sysFuel 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysFuel")	
sysAir 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysAir")	
sysAice 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysAice")	
sysMCP 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysMCP")	
sysEFIS 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysEFIS")	
sysRadios 		= require("kpcrew.systems." .. kc_acf_icao .. ".sysRadios")	

-- ------ function to initialize panels window
function kp_init_panels_window()
    local wndWidth =  1020
    local wndHeight = 380
    fontScale1 = 1
    angle=1
    fontScale = 1
	
    kp_panels_wnd = float_wnd_create(wndWidth, wndHeight, 1, true)
    float_wnd_set_title(kp_panels_wnd, "KP Panels " .. kc_VERSION .. " - " .. kc_acf_icao)
    float_wnd_set_imgui_builder(kp_panels_wnd, "kp_panels_builder")
    float_wnd_set_onclose(kp_panels_wnd, "kp_hide_panels_wnd")
end

-- ------ Hide the panels window, wnd=windowid
function kp_hide_panels_wnd(wnd)
    if kp_panels_wnd then
        float_wnd_destroy(kp_panels_wnd)
    end
end

-- ------ Toggle the panels window
function kp_panels_toggle_wnd()
    kp_show_panels = not kp_show_panels
    if kp_show_panels then
        if kp_show_only_once == 0 then
            kp_init_panels_window()
            kp_show_only_once = 1
            kp_show_only_once = 0
        end
    else
        if kp_hide_only_once == 0 then
            kp_hide_panels_wnd()
            kp_hide_only_once = 1
            kp_hide_only_once = 0
        end
    end
end

-- ------ builder function taking the windowid displaying the base layout
-- NOTES: [                                   ] ]C] 
-- ----------------------------------------------------------------------
-- MCP: 
-- ----------------------------------------------------------------------
-- EFIS/BARO       |Lights                        | Radios
-- ----------------------------------------------------------------------
function kp_panels_builder(kp_panels_wnd, x, y)

	imgui.SetWindowFontScale(1.0)

-- ------ Notes field and clear button
	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("NOTES:")
	imgui.PopStyleColor()
	imgui.SameLine()
	imgui.PushID("Notes:")
		imgui.PushItemWidth(900*kb_font_scale);
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				local changed, textin = imgui.InputText("", activeBriefings:get("flight:notes"), 255)
				if changed then
					activeBriefings:set("flight:notes",textin)
				end
			imgui.PopStyleColor()
		imgui.PopItemWidth()
	imgui.PopID()
	imgui.SameLine()
	imgui.PushID("clrnotes:")
		if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
			activeBriefings:set("flight:notes","") 
		end
	imgui.PopID()	

	imgui.Separator()

-- ------ MCP panel rendered in aircraft sysMCP module
	sysMCP:panel_render()

	imgui.Separator()
	
-- ------ 3 column setup
	imgui.Columns(3,"panelcolumns",true)
		imgui.SetColumnWidth(0,250)
		imgui.SetColumnWidth(1,450)
		imgui.SetColumnWidth(2,350)

-- ------ EFIS/BARO panel coming from sysEFIS module in DFLT or aircraft specific
		imgui.BeginChild("left1")
			sysEFIS.panel_render()
		imgui.EndChild()
		
	imgui.NextColumn()		

-- ------ Lights panel coming from DFLT or aircraft sysLights system module
		imgui.BeginChild("center1")
			sysLights:panel_render()
		imgui.EndChild()
		
	imgui.NextColumn()		

-- ------ Radio panel coming from DFLT sysRadios system module, valid for all
		imgui.BeginChild("right1")
			sysRadios:panel_render()
		imgui.EndChild()
		
	imgui.Columns()
end

-- command to toggle the panels window
create_command("kppanels/window/open", "KP Panels: Open/Close", "kp_panels_toggle_wnd()", "", "")
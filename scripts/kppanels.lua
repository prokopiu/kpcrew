--[[
	*** KPPANELS 1.0
	External panels
	Kosta Prokopiu, March 2025
--]]

require "kpcrew.genutils"

kc_VERSION = "2.3-alpha10"
kc_simversion = get("sim/version/xplane_internal_version")

logMsg ( "FWL: ** Starting KPPanels version " .. kc_VERSION .. " on XP " .. kc_simversion .. " **" )

local color_white = 0xFFCCCCCC
local color_orange = 0xFF1b9af8
local color_yellow = 0xFF00FFFF
local color_green = 0xFF95C857

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

-- ====== Select the addon modules based on ICAO code
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		kc_acf_icao = "B737" 
	else
		kc_acf_icao = "B738" -- Zibo Mod
	end

-- Epic Victory Aerobask
elseif PLANE_ICAO == "EVIC" then
	kc_acf_icao = "EVIC"

-- Epic E1000 Aerobask
elseif PLANE_ICAO == "EPIC" then
	kc_acf_icao = "EPIC"

-- Thranda PC12
elseif PLANE_ICAO == "PC12" then
	kc_acf_icao = "PC12"
		
-- FF A350
-- elseif PLANE_ICAO == "A359" then
	-- kc_acf_icao = "A359"

-- Laminar SF50
elseif PLANE_ICAO == "SF50" then
	kc_acf_icao = "SF50"
	
-- XP12 Citation X
elseif PLANE_ICAO == "C750" and PLANE_TAILNUMBER == "N750XP" then
	kc_acf_icao = "C750"
	
-- XP12 A330-300 Laminar
elseif PLANE_ICAO == "A333" then
	kc_acf_icao = "A33L"
	
-- Inibuilds A300
-- elseif PLANE_ICAO == "A306" then
	-- kc_acf_icao = "A306"

-- FF 7x7
-- elseif PLANE_ICAO == "B762" or PLANE_ICAO == "B763" or PLANE_ICAO == "B764" then
	-- kc_acf_icao = "B7x7"
	
-- Rotate MD-11
-- elseif PLANE_ICAO == "MD11" then
	-- kc_acf_icao = "MD11"
	
-- FJsim 737	
-- elseif PLANE_ICAO == "B732" then
	-- kc_acf_icao = "B732"

-- IXEG 737
-- elseif PLANE_ICAO == "B733" then
	-- kc_acf_icao = "B733"
	
-- X-CRAFTS E-JET FAMILIY XP12 (E1XX)
-- E-JET FAM 170  170/170
-- E-JET FAM 175  175/175
-- E-JET FAM 190  190/190
-- E-JET FAM 195  195/195
-- elseif PLANE_ICAO == "E170" and PLANE_TAILNUMBER == "E170" then
	-- kc_acf_icao = "E1XX"
-- elseif PLANE_ICAO == "E175" and PLANE_TAILNUMBER == "E175" then
	-- kc_acf_icao = "E1XX"
-- elseif PLANE_ICAO == "E190" and PLANE_TAILNUMBER == "E190" then
	-- kc_acf_icao = "E1XX"
-- elseif PLANE_ICAO == "E195" and PLANE_TAILNUMBER == "E195" then
	-- kc_acf_icao = "E1XX"
	
-- X-CRAFTS FREE E-JETS XP12 (E1FF)
-- Free 175       170/175
-- Free 195       190/195
elseif PLANE_ICAO == "E170" and PLANE_TAILNUMBER == "E175" then
	kc_acf_icao = "E1FF"
elseif PLANE_ICAO == "E190" and PLANE_TAILNUMBER == "E195" then
	kc_acf_icao = "E1FF"
	
-- ToLiss Airbusses
elseif PLANE_ICAO == "A319" and PLANE_TAILNUMBER == "C-GTLS" then
	kc_acf_icao = "A3TL"
elseif PLANE_ICAO == "A20N" and PLANE_TAILNUMBER == "C-GTLT" then
	kc_acf_icao = "A3TL"
elseif PLANE_ICAO == "A321" then
	kc_acf_icao = "A3TL"
elseif PLANE_ICAO == "A339" then
	kc_acf_icao = "A3TL"
elseif PLANE_ICAO == "A346" then
	kc_acf_icao = "A3TL"
	
-- Laminar MD-82
elseif PLANE_ICAO == "MD82" and PLANE_TAILNUMBER == "N552AA" then
	kc_acf_icao = "MD82"
	
-- RotateSim MD-88
elseif PLANE_ICAO == "MD88" then
	kc_acf_icao = "MD88"

-- MSparks B747
elseif PLANE_ICAO == "B744" or PLANE_ICAO == "B74F" then
	kc_acf_icao = "B744"
	
-- Aerobask Phenom 300
elseif PLANE_ICAO == "E55P" then
	kc_acf_icao = "E55P"
end

if kc_file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\" .. kc_acf_icao .. ".preferences") then
	getActivePrefs():load()
end

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

-- initialize briefing window
function kp_init_panels_window()
    local wndWidth =  1000
    local wndHeight = 400
    fontScale1 = 1
    angle=1
    fontScale = 1
	
    kp_panels_wnd = float_wnd_create(wndWidth, wndHeight, 1, true)
    float_wnd_set_title(kp_panels_wnd, "KP Panels " .. kc_VERSION .. " - " .. kc_acf_icao)
    float_wnd_set_imgui_builder(kp_panels_wnd, "kp_panels_builder")
    float_wnd_set_onclose(kp_panels_wnd, "kp_hide_panels_wnd")
end

-- Hide the briefing window
function kp_hide_panels_wnd(wnd)
    if kp_panels_wnd then
        float_wnd_destroy(kp_panels_wnd)
    end
end

-- Toggle the briefing window
kp_show_only_once = 0
kp_hide_only_once = 0
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

-- kp_init_panels_window()

-- builder
function kp_panels_builder(kp_panels_wnd, x, y)

    -- field_size = 130
    -- imgui.PushItemWidth(field_size);
    -- local win_width = imgui.GetWindowWidth()
    -- local win_height = imgui.GetWindowHeight()
	imgui.SetWindowFontScale(1.0)

	sysMCP:panel_render()
	
	imgui.Separator()
	
	imgui.Columns(3,"panelcolumns",true)
		imgui.SetColumnWidth(0,300)
		imgui.SetColumnWidth(1,400)
		imgui.SetColumnWidth(2,300)
	
		imgui.BeginChild("left1")
			sysEFIS.panel_render()
		imgui.EndChild()
		
	imgui.NextColumn()		

		imgui.BeginChild("center1")
			sysLights:panel_render()
		imgui.EndChild()
		
	imgui.NextColumn()		

		imgui.BeginChild("right1")
			sysRadios:panel_render()
		imgui.EndChild()
		

end

-- command to toggle the panels window
create_command("kppanels/window/open", "KP Panels: Open/Close", "kp_panels_toggle_wnd()", "", "")
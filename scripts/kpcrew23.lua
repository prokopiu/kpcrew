--[[
	*** KPCREW 2.3
	Virtual copilot for X-PLane 11
	Kosta Prokopiu, October 2021
--]]

require "kpcrew.genutils"
require "kpcrew.systems.activities"

kc_VERSION = "2.3-alpha1"

logMsg ( "FWL: ** Starting KPCrew version " .. kc_VERSION .." **" )

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

-- ====== Select the addon modules based on ICAO code
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		kc_acf_icao = "DFLT" 
	else
		kc_acf_icao = "B738" -- Zibo Mod
	end
end

-- Aircraft Specific SOP/Checklist/Procedure Definitions
kcPreferenceSet 		= require("kpcrew.preferences.PreferenceSet")
kcPreferenceGroup 		= require("kpcrew.preferences.PreferenceGroup")
kcPreference 			= require("kpcrew.preferences.Preference")

kcLoadedPrefs 			= require("kpcrew.preferences.defaultPrefs")
kcLoadedVars 			= require("kpcrew.preferences.backgroundVars")
kcLoadedSOP 			= require("kpcrew.sops.SOP_" .. kc_acf_icao)

-- stop if pre-reqs are not met
if not SUPPORTS_FLOATING_WINDOWS then
	logMsg("Upgrade your FlyWithLua! to NG 2.7.30+, need Floating Windows")
	return
end

-- get screen width from X-Plane
kc_scrn_width = get("sim/graphics/view/window_width")
kc_scrn_height = get("sim/graphics/view/window_height")

-- ============ UIs ==========

kc_ctrl_wnd = nil

-- ===== Standard Operating Procedure window =====
kc_sop_wnd = nil
kc_show_sop_once = 0
kc_hide_sop_once = 0

function kc_init_sop_window(sop)
	local height = sop:getWndHeight()
	local width = sop:getWndWidth()
	kc_sop_wnd = float_wnd_create(width, height, 1, true)
	float_wnd_set_title(kc_sop_wnd, sop:getName())
	float_wnd_set_position(kc_sop_wnd, sop:getWndXPos(), sop:getWndYPos())
	float_wnd_set_imgui_builder(kc_sop_wnd, "kc_sop_builder")
end

function kc_sop_builder(wnd)
	-- check if screen size has changed and if so calculate new
	if get("sim/graphics/view/window_width") ~= kc_scrn_width or get("sim/graphics/view/window_height") ~= kc_scrn_height then
		kc_scrn_width = get("sim/graphics/view/window_width")
		kc_scrn_height = get("sim/graphics/view/window_height")
		local xpos = getActiveSOP():getWndXPos()
		local ypos = kc_scrn_height - getActiveSOP():getWndYPos()
		float_wnd_set_geometry(kc_sop_wnd, xpos-100, ypos, xpos + getActiveSOP():getWndWidth(), ypos - getActiveSOP():getWndHeight())
	end
	-- render window with current SOP flows
	getActiveSOP():render()
end

function kc_hide_sop_wnd()
	if kc_sop_wnd then 
		float_wnd_destroy(kc_sop_wnd)
	end
end

function kc_toggle_sop_window()
	kc_show_sop = not kc_show_sop
	if kc_show_sop then
		if kc_show_sop_once == 0 then
			kc_init_sop_window(getActiveSOP())
			kc_show_sop_once = 1
			kc_hide_sop_once = 0
		end
	else
		if kc_hide_sop_once == 0 then
			kc_hide_sop_wnd()
			kc_show_sop_once = 0
			kc_hide_sop_once = 1
		end
	end
end

-- ===== Flow Window =====
kc_flow_wnd = nil
kc_show_flow_once = 0
kc_hide_flow_once = 0

function kc_init_flow_window(flow)
	local height = flow:getWndHeight()
	local width = flow:getWndWidth()
	kc_flow_wnd = float_wnd_create(width, height, 1, true)
	float_wnd_set_title(kc_flow_wnd, "FLOW")
	float_wnd_set_position(kc_flow_wnd, flow:getWndXPos(), flow:getWndYPos())
	float_wnd_set_imgui_builder(kc_flow_wnd, "kc_flow_builder")
end

-- resize the window when a new flow is shown
function kc_resize_flow_window(flow)
	if kc_flow_wnd == 0 or kc_flow_wnd == nil then 
		return 
	end
	float_wnd_set_title(kc_flow_wnd, flow:getName())
	local height = flow:getWndHeight()
	local width = flow:getWndWidth()
	local screenheight = get("sim/graphics/view/window_height")
	float_wnd_set_geometry(kc_flow_wnd, flow.getWndXPos(), screenheight - flow.getWndYPos(), flow.getWndXPos() + width, screenheight - (flow.getWndYPos() + height))
end

function kc_flow_builder()
	-- resize when needed
	local fheight = getActiveSOP():getActiveFlow():getWndHeight()
	local fwidth = getActiveSOP():getActiveFlow():getWndWidth()
	local fxpos = getActiveSOP():getActiveFlow().getWndXPos()
	local fypos = getActiveSOP():getActiveFlow().getWndYPos()
	local wwidth = imgui.GetWindowWidth()
    local wheight = imgui.GetWindowHeight()
	local screenheight = get("sim/graphics/view/window_height")
	if fwidth ~= wwidth or fheight ~= wheight then
		float_wnd_set_geometry(kc_flow_wnd, fxpos, screenheight - fypos, fxpos + fwidth, screenheight - (fypos + fheight))
	end
	getActiveSOP():getActiveFlow():render()
end

function kc_hide_flow_wnd()
	if kc_flow_wnd then 
		float_wnd_destroy(kc_flow_wnd)
	end
end

function kc_toggle_flow_window()
	kc_show_flow = not kc_show_flow
	if kc_show_flow then
		if kc_show_flow_once == 0 then
			kc_init_flow_window(getActiveSOP():getActiveFlow())
			kc_show_flow_once = 1
			kc_hide_flow_once = 0
		end
	else
		if kc_hide_flow_once == 0 then
			kc_hide_flow_wnd()
			kc_show_flow_once = 0
			kc_hide_flow_once = 1
		end
	end
end

-- ===== Control bar to open windows (preliminary)
kc_ctrl_wnd_state = 0

function kc_init_ctrl_window()
	if kc_ctrl_wnd == 0 or kc_ctrl_wnd == nil then	
		kc_ctrl_wnd = float_wnd_create(25, 45, 2, true)
		local xpos = kc_scrn_width - 680
		if kc_ctrl_wnd_state == 0 then
			xpos = kc_scrn_width - 25
		end
		float_wnd_set_title(kc_ctrl_wnd, "")
		float_wnd_set_position(kc_ctrl_wnd, xpos, kc_scrn_height - 46)
		float_wnd_set_imgui_builder(kc_ctrl_wnd, "kc_ctrl_builder")
		float_wnd_set_onclose(kc_ctrl_wnd, "kc_close_ctlr_window")
	end
end

function kc_ctrl_builder()
	-- reposition when screen size changes
	if get("sim/graphics/view/window_width") ~= kc_scrn_width or get("sim/graphics/view/window_height") ~= kc_scrn_height then
		kc_scrn_width = get("sim/graphics/view/window_width")
		kc_scrn_height = get("sim/graphics/view/window_height")
		local xpos = kc_scrn_width - 680
		if kc_ctrl_wnd_state == 0 then
			xpos = kc_scrn_width - 25
		end
		float_wnd_set_geometry(kc_ctrl_wnd, xpos, 46, kc_scrn_width, 1)
	end
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(7)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_grey)

	if kc_ctrl_wnd_state == 0 then
		imgui.Button("<", 15, 25)
		if imgui.IsItemActive() then
			kc_ctrl_wnd_state = 1
			local xpos = kc_scrn_width - 680
			float_wnd_set_geometry(kc_ctrl_wnd, xpos, 46, kc_scrn_width, 1)
		end
		imgui.SameLine()
	end
	if imgui.Button("MSTR", 35, 25) then
	end
    imgui.SameLine()
	if imgui.Button("SOP", 35, 25) then
		kc_wnd_sop_action = 1
	end
    imgui.SameLine()
	if imgui.Button("PREV", 35, 25) then
		if getActiveSOP():getActiveFlowIndex() > 1 then
			getActiveSOP():setActiveFlowIndex(getActiveSOP():getActiveFlowIndex() -1)
		end
	end
	-- MODE/AUXILIARY display
	imgui.SameLine()
	imgui.SetCursorPosY(12)
	imgui.PushStyleColor(imgui.constant.Col.Text, color_left_display)
		imgui.TextUnformatted(getActiveSOP():getActiveFlow():getHeadline())
	imgui.PopStyleColor()

    imgui.SameLine()
	imgui.SetCursorPosY(10)
	if imgui.Button("NEXT", 35, 25) then
		getActiveSOP():setNextFlowActive()
	end
    imgui.SameLine()
	if imgui.Button("FLOW", 35, 25) then
		kc_wnd_flow_action = 1
	end
    imgui.SameLine()
	if imgui.Button("PREF", 35, 25) then
		kc_wnd_pref_action = 1
	end
    imgui.SameLine()
	if kc_ctrl_wnd_state == 1 then
		if imgui.Button(">", 15, 25) then
			kc_ctrl_wnd_state = 0
			local xpos = kc_scrn_width - 25
			float_wnd_set_geometry(kc_ctrl_wnd, xpos, 46, kc_scrn_width, 1)
		end
	end

	imgui.PopStyleColor()
end

function kc_close_ctrl_window()
	kc_ctrl_wnd = nil
end

kc_init_ctrl_window()

-- ===== Preferences window =====
kc_show_pref_once = 0
kc_hide_pref_once = 0
kc_pref_wnd = nil

function kc_init_pref_window(prefset)
	local height = prefset:getWndHeight()
	local width = prefset:getWndWidth()
	kc_pref_wnd = float_wnd_create(width, height, 1, true)
	float_wnd_set_title(kc_pref_wnd, prefset:getName())
	float_wnd_set_position(kc_pref_wnd, prefset:getWndXPos(), prefset:getWndYPos())
	-- debug option for background vars
	float_wnd_set_imgui_builder(kc_pref_wnd, "kc_pref_builder")
	-- float_wnd_set_onclose(kc_pref_wnd, "kc_close_pref_window")
end

function kc_pref_builder()
				-- kc_resize_flow_window(getActiveSOP():getActiveFlow())

	getActivePrefs():render()
end

function kc_hide_pref_wnd()
	if kc_pref_wnd then 
		float_wnd_destroy(kc_pref_wnd)
	end
end

function kc_toggle_pref_window()
	kc_show_pref = not kc_show_pref
	if kc_show_pref then
		if kc_show_pref_once == 0 then
			kc_init_pref_window(getActivePrefs())
			kc_show_pref_once = 1
			kc_hide_pref_once = 0
		end
	else
		if kc_hide_pref_once == 0 then
			kc_hide_pref_wnd()
			kc_show_pref_once = 0
			kc_hide_pref_once = 1
		end
	end
end

-- ===== Background  Window control - direct window commands do not work as expected =====
kc_wnd_sop_action = 0
kc_wnd_flow_action = 0
kc_wnd_pref_action = 0

function bckWindowOpen()
	if kc_wnd_sop_action == 1 then
		kc_wnd_sop_action = 0
		kc_toggle_sop_window()
	end
	if kc_wnd_flow_action == 1 then
		kc_wnd_flow_action = 0
		kc_toggle_flow_window()
	end
	if kc_wnd_pref_action == 1 then
		kc_wnd_pref_action = 0
		kc_toggle_pref_window()
	end
end

-- needed for window control
do_every_frame("bckWindowOpen()")
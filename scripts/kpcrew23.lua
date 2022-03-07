--[[
	*** KPCREW 2.3
	Virtual copilot for X-PLane 11
	Kosta Prokopiu, October 2021
--]]

require "kpcrew.genutils"

local KC_VERSION = "2.3"

logMsg ( "FWL: ** Starting KPCrew version " .. KC_VERSION .." **" )

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

-- ====== Select the addon modules based on ICAO code
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		kc_acf_icao = "DFLT" -- add L738 module later
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

kc_sop_wnd = nil
kc_flow_wnd = nil
kc_ctrl_wnd = nil
kc_pref_wnd = nil

-- ===== Standard Operating Procedure window =====
function kc_init_sop_window(sop)
	if kc_sop_wnd == 0 or kc_sop_wnd == nil then	
		height = sop:getWndHeight()
		width = sop:getWndWidth()
		kc_sop_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(kc_sop_wnd, sop:getName())
		float_wnd_set_position(kc_sop_wnd, sop:getWndXPos(), sop:getWndYPos())
		float_wnd_set_imgui_builder(kc_sop_wnd, "kc_sop_builder")
		float_wnd_set_onclose(kc_sop_wnd, "kc_close_sop_window")
	end
end

function kc_sop_builder(wnd)
	-- check if screen size has changed and if so calculate new
	if get("sim/graphics/view/window_width") ~= kc_scrn_width or get("sim/graphics/view/window_height") ~= kc_scrn_height then
		kc_scrn_width = get("sim/graphics/view/window_width")
		kc_scrn_height = get("sim/graphics/view/window_height")
		xpos = getActiveSOP():getWndXPos()
		ypos = kc_scrn_height - getActiveSOP():getWndYPos()
		float_wnd_set_geometry(kc_sop_wnd, xpos-100, ypos, xpos + getActiveSOP():getWndWidth(), ypos - getActiveSOP():getWndHeight())
	end
	-- render window with current SOP flows
	getActiveSOP():render()
end

function kc_close_sop_window()
	kc_sop_wnd = nil
end

-- ===== Flow Window =====
function kc_init_flow_window(flow)
	if kc_flow_wnd == 0 or kc_flow_wnd == nil then	
		height = flow:getWndHeight()
		width = flow:getWndWidth()
		kc_flow_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(kc_flow_wnd, flow:getName())
		float_wnd_set_position(kc_flow_wnd, flow:getWndXPos(), flow:getWndYPos())
		float_wnd_set_imgui_builder(kc_flow_wnd, "kc_flow_builder")
		float_wnd_set_onclose(kc_flow_wnd, "kc_close_flow_window")
	end
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

function kc_close_flow_window()
	kc_flow_wnd = 0
end

-- ===== Control bar to open windows (preliminary)
function kc_init_ctrl_window()
	if kc_ctrl_wnd == 0 or kc_ctrl_wnd == nil then	
		kc_ctrl_wnd = float_wnd_create(680, 45, 2, true)
		xpos = kc_scrn_width - 680
		float_wnd_set_title(kc_ctrl_wnd, "")
		float_wnd_set_position(kc_ctrl_wnd, xpos, kc_scrn_height - 46)
		float_wnd_set_imgui_builder(kc_ctrl_wnd, "kc_ctrl_builder")
		float_wnd_set_onclose(kc_ctrl_wnd, "kc_close_ctlr_window")
	end
end

kc_ctrl_wnd_state = 1

function kc_ctrl_builder()
	-- reposition when screen size changes
	if get("sim/graphics/view/window_width") ~= kc_scrn_width or get("sim/graphics/view/window_height") ~= kc_scrn_height then
		kc_scrn_width = get("sim/graphics/view/window_width")
		kc_scrn_height = get("sim/graphics/view/window_height")
		xpos = kc_scrn_width - 680
		float_wnd_set_geometry(kc_ctrl_wnd, xpos, 46, kc_scrn_width, 1)
	end
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(7)
	
	if kc_ctrl_wnd_state == 0 then
		if imgui.Button("<", 15, 25) then
			kc_ctrl_wnd_state = 1
			xpos = kc_scrn_width - 680
			float_wnd_set_geometry(kc_ctrl_wnd, xpos, 46, kc_scrn_width, 1)
		end
		imgui.SameLine()
	end
	if imgui.Button("MSTR", 35, 25) then
	end
    imgui.SameLine()
	if imgui.Button("SOP", 35, 25) then
		if kcLoadedSOP ~= nil then
			if kc_sop_wnd == nil or kc_sop_wnd == 0 then
				kc_wnd_sop_action = 1
			end
		end
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
		if kcLoadedSOP ~= nil then
			if kc_flow_wnd == nil or kc_flow_wnd == 0 then
				kc_wnd_flow_action = 1
			end
		end
	end
    imgui.SameLine()
	if imgui.Button("PREF", 35, 25) then
		if kcLoadedPrefs ~= nil then
			if kc_pref_wnd == nil or kc_pref_wnd == 0 then
				kc_wnd_pref_action = 1
			end
		end
	end
    imgui.SameLine()
	if kc_ctrl_wnd_state == 1 then
		if imgui.Button(">", 15, 25) then
			kc_ctrl_wnd_state = 0
			xpos = kc_scrn_width - 25
			float_wnd_set_geometry(kc_ctrl_wnd, xpos, 46, kc_scrn_width, 1)
		end
	end
	
end

function kc_close_ctrl_window()
	kc_ctrl_wnd = nil
end

kc_init_ctrl_window()

-- ===== Preferences window =====
function kc_init_pref_window(prefset)
	if kc_pref_wnd == 0 or kc_pref_wnd == nil then	
		height = prefset:getWndHeight()
		width = prefset:getWndWidth()
		kc_pref_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(kc_pref_wnd, prefset:getName())
		float_wnd_set_position(kc_pref_wnd, prefset:getWndXPos(), prefset:getWndYPos())
		-- debug option for background vars
		if prefset:getName() == "BackgroundVars" then
			float_wnd_set_imgui_builder(kc_pref_wnd, "kc_vars_builder")
		else
			float_wnd_set_imgui_builder(kc_pref_wnd, "kc_pref_builder")
		end
		float_wnd_set_onclose(kc_pref_wnd, "kc_close_pref_window")
	end
end

function kc_pref_builder()
	getActivePrefs():render()
end

function kc_vars_builder()
	getBckVars():render()
end

function kc_close_pref_window()
	kc_pref_wnd = nil
end

-- kc_init_pref_window(getActivePrefs())
-- kc_init_pref_window(getBckVars())

kc_wnd_sop_action = 0
kc_wnd_flow_action = 0
kc_wnd_pref_action = 0

function bckWindowOpen()
	if kc_wnd_sop_action == 1 then
		kc_wnd_sop_action = 0
		if kcLoadedSOP ~= nil then
			kc_init_sop_window(getActiveSOP())
		end
	end
	if kc_wnd_flow_action == 1 then
		if kcLoadedSOP ~= nil then
			if kc_flow_wnd == nil or kc_flow_wnd == 0 then 
				kc_init_flow_window(getActiveSOP():getActiveFlow())
			else
				kc_resize_flow_window(getActiveSOP():getActiveFlow())
			end
		end
		kc_wnd_flow_action = 0
	end
	if kc_wnd_pref_action == 1 then
		kc_wnd_pref_action = 0
		if kcLoadedPrefs ~= nil then
			kc_init_pref_window(getActivePrefs())
		end
	end
end

-- needed for window control
do_every_frame("bckWindowOpen()")
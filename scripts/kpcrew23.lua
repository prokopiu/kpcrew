--[[
	*** KPCREW 2.3
	Kosta Prokopiu, October 2021
--]]

ZC_VERSION = "2.3"

require "kpcrew.genutils"

-- stop if pre-reqs are not met
if not SUPPORTS_FLOATING_WINDOWS then
	logMsg("Upgrade your FlyWithLua! to NG 2.7.30+, need Floating Windows")
	return
end

acf_icao = "DFLT"

-- Zibo B738 - use different module for default Laminar B738
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		acf_icao = "DFLT" -- add L738 module later
	else
		acf_icao = "B738" -- Zibo Mod
	end
end

-- Aircraft Specific SOP/Checklist/Procedure Definitions
loadedSOP = require("kpcrew.sops.SOP_" .. acf_icao)
loadedPrefs = require("kpcrew.preferences.defaultPrefs")
loadedVars = require("kpcrew.preferences.backgroundVars")

local svar = activeBckVars:findPreference("general:flight_state")
local sstate = split(svar:getTitle(),"|")[svar:getValue()+1]
logMsg("> " .. sstate)
-- ,"|")[activeBckVars:getPreference("general.flight_state")+1])

-- ============ UIs ==========

sop_wnd = nil
flow_wnd = nil
ctrl_wnd = nil
pref_wnd = nil

scrnwidth = get("sim/graphics/view/window_width")
scrnheight = get("sim/graphics/view/window_height")

-- ===== Standard Operating Procedure window =====
function init_sop_window(sop)
	if sop_wnd == 0 or sop_wnd == nil then	
		height = sop:getWndHeight()
		width = sop:getWndWidth()
		sop_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(sop_wnd, sop:getName())
		float_wnd_set_position(sop_wnd, sop:getWndXPos(), sop:getWndYPos())
		float_wnd_set_imgui_builder(sop_wnd, "sop_builder")
		float_wnd_set_onclose(sop_wnd, "close_sop_window")
	end
end

function sop_builder(wnd)
	if get("sim/graphics/view/window_width") ~= scrnwidth or get("sim/graphics/view/window_height") ~= scrnheight then
		scrnwidth = get("sim/graphics/view/window_width")
		scrnheight = get("sim/graphics/view/window_height")
		xpos = getActiveSOP():getWndXPos()
		ypos = scrnheight - getActiveSOP():getWndYPos()
		float_wnd_set_geometry(sop_wnd, xpos-100, ypos, xpos + getActiveSOP():getWndWidth(), ypos - getActiveSOP():getWndHeight())
	end
	getActiveSOP():render()
end

function close_sop_window(wnd)
	sop_wnd = nil
end

-- ===== Flow Window =====
function init_flow_window(flow)
	if flow_wnd == 0 or flow_wnd == nil then	
		height = flow:getWndHeight()
		width = flow:getWndWidth()
		flow_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(flow_wnd, flow:getName())
		float_wnd_set_position(flow_wnd, flow:getWndXPos(), flow:getWndYPos())
		float_wnd_set_imgui_builder(flow_wnd, "flow_builder")
		float_wnd_set_onclose(flow_wnd, "close_flow_window")
	end
end

function resize_flow_window(flow)
	if flow_wnd == 0 or flow_wnd == nil then 
		return 
	end
	float_wnd_set_title(flow_wnd, flow:getName())
	height = flow:getWndHeight()
	width = flow:getWndWidth()
	screenheight = get("sim/graphics/view/window_height")
	float_wnd_set_geometry(flow_wnd, flow.getWndXPos(), screenheight - flow.getWndYPos(), flow.getWndXPos() + width, screenheight - (flow.getWndYPos() + height))
end

function flow_builder(wnd)
	getActiveSOP():getActiveFlow():render()
end

function close_flow_window()
	flow_wnd = 0
end

-- ===== Small button bar to open windows (preliminary)
function init_ctrl_window()
	if ctrl_wnd == 0 or ctrl_wnd == nil then	
		ctrl_wnd = float_wnd_create(140, 45, 2, true)
		xpos = scrnwidth - 140
		float_wnd_set_title(ctrl_wnd, "")
		float_wnd_set_position(ctrl_wnd, xpos, scrnheight - 46)
		float_wnd_set_imgui_builder(ctrl_wnd, "ctrl_builder")
		float_wnd_set_onclose(ctrl_wnd, "close_ctlr_window")
	end
end

function ctrl_builder(wnd)
	if get("sim/graphics/view/window_width") ~= scrnwidth or get("sim/graphics/view/window_height") ~= scrnheight then
		scrnwidth = get("sim/graphics/view/window_width")
		scrnheight = get("sim/graphics/view/window_height")
		xpos = scrnwidth - 150
		float_wnd_set_geometry(ctrl_wnd, xpos, 46, scrnwidth, 1)
	end
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(10)
	
	if imgui.Button("PRF", 35, 25) then
		if loadedPrefs ~= nil then
			if pref_wnd == nil or pref_wnd == 0 then
				wnd_pref_action = 1
			end
		end
	end
    imgui.SameLine()
	if imgui.Button("SOP", 35, 25) then
		if loadedSOP ~= nil then
			if sop_wnd == nil or sop_wnd == 0 then
				wnd_sop_action = 1
			end
		end
	end
    imgui.SameLine()
	if imgui.Button("FLOW", 35, 25) then
		if loadedSOP ~= nil then
			if flow_wnd == nil or flow_wnd == 0 then
				wnd_flow_action = 1
			end
		end
	end
end

function close_ctrl_window()
	ctrl_wnd = nil
end

init_ctrl_window()

-- ===== Preferences window =====
function init_pref_window(prefset)
	if pref_wnd == 0 or pref_wnd == nil then	
		height = prefset:getWndHeight()
		width = prefset:getWndWidth()
		pref_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(pref_wnd, prefset:getName())
		float_wnd_set_position(pref_wnd, prefset:getWndXPos(), prefset:getWndYPos())
		if prefset:getName() == "BackgroundVars" then
			float_wnd_set_imgui_builder(pref_wnd, "vars_builder")
		else
			float_wnd_set_imgui_builder(pref_wnd, "pref_builder")
		end
		float_wnd_set_onclose(pref_wnd, "close_pref_window")
	end
end

function pref_builder()
	getActivePrefs():render()
end

function vars_builder()
	getBckVars():render()
end

function close_pref_window()
	pref_wnd = nil
end

-- init_pref_window(getActivePrefs())
init_pref_window(getBckVars())

wnd_sop_action = 0
wnd_flow_action = 0
wnd_pref_action = 0

function bckWindowOpen()
	if wnd_sop_action == 1 then
		wnd_sop_action = 0
		if loadedSOP ~= nil then
			init_sop_window(getActiveSOP())
		end
	end
	if wnd_flow_action == 1 then
		if loadedSOP ~= nil then
			if flow_wnd == nil or flow_wnd == 0 then 
				init_flow_window(getActiveSOP():getActiveFlow())
			else
				resize_flow_window(getActiveSOP():getActiveFlow())
			end
		end
		wnd_flow_action = 0
	end
	if wnd_pref_action == 1 then
		wnd_pref_action = 0
		if loadedPrefs ~= nil then
			init_pref_window(getActivePrefs())
		end
	end
end

do_often("bckWindowOpen()")
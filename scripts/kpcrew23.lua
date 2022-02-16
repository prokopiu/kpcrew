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

local acf_icao = "DFLT"

-- Zibo B738 - use different module for default Laminar B738
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		acf_icao = "DFLT" -- add L738 module later
	else
		acf_icao = "B738" -- Zibo Mod
	end
end

ChecklistItem = require "kpcrew.checklists.ChecklistItem"
SimpleChecklistItem = require "kpcrew.checklists.SimpleChecklistItem"
Checklist = require "kpcrew.checklists.Checklist"
ProcedureItem = require "kpcrew.procedures.ProcedureItem"
Procedure = require "kpcrew.procedures.Procedure"
SOP = require "kpcrew.sops.SOP"

-- Define the variables used for displaying the checklist window
local checklist_wnd = nil

local lineLength = 55

function init_checklist_window (height, width, name)
	if checklist_wnd == 0 or checklist_wnd == nil then	
		checklist_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(checklist_wnd, name)
		float_wnd_set_position(checklist_wnd, 30, 80)
		float_wnd_set_imgui_builder(checklist_wnd, "checklist_build")
		float_wnd_set_onclose(checklist_wnd, "close_checklist_window")
	end
end

function checklist_build()
	renderChecklist(preflightChkl)
end

function close_checklist_window()
	checklist_wnd = 0
end

local testSOP = SOP:new("B738 SOP")

local preflightChkl = Checklist:new("PREFLIGHT (PM)")
preflightChkl:addItem(ChecklistItem:new(		"OXYGEN",						"Tested, 100%","ALL",1))
preflightChkl:addItem(ChecklistItem:new(		"NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",ChecklistItem.actorPF,1))
preflightChkl:addItem(ChecklistItem:new(		"WINDOW HEAT",					"ON",ChecklistItem.actorPF,1))
preflightChkl:addItem(ChecklistItem:new(		"PRESSURIZATION MODE SELECTOR",	"AUTO",ChecklistItem.actorPF,1))
preflightChkl:addItem(ChecklistItem:new(		"FLIGHT INSTRUMENTS", 			"Heading 360,Altimeter 1750",ChecklistItem.actorBOTH,1))
preflightChkl:addItem(ChecklistItem:new(		"PARKING BRAKE",				"SET",ChecklistItem.actorPF,1))
preflightChkl:addItem(ChecklistItem:new(		"ENGINE START LEVERS",			"CUTOFF",ChecklistItem.actorPF,1))
preflightChkl:addItem(ChecklistItem:new(		"GEAR PINS",					"REMOVED",ChecklistItem.actorPF,1))

local secureChkl = Checklist:new("SECURE (F/O)")
secureChkl:addItem(ChecklistItem:new(		"EFBs (if installed)",			"SHUT DOWN",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"IRSs",							"OFF",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"EMERGENCY EXIT LIGHTS",		"OFF",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"WINDOW HEAT",					"OFF",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"PACKS",						"OFF",ChecklistItem.actorCPT,1))
secureChkl:addItem(SimpleChecklistItem:new(	"If the aircraft is not handed over to succeeding flight"))
secureChkl:addItem(SimpleChecklistItem:new(	"crew or maintenance personnel:"))
secureChkl:addItem(ChecklistItem:new(		"  EFB switches (if installed)","OFF",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"  APU/GRD PWR",				"OFF",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"  GROUND SERVICE SWITCH",		"ON",ChecklistItem.actorCPT,1))
secureChkl:addItem(ChecklistItem:new(		"  BAT SWITCH",					"OFF",ChecklistItem.actorCPT,1))

testSOP:addChecklist(preflightChkl)
testSOP:addChecklist(secureChkl)

activeChecklist = testSOP:getActiveChecklist()

function checklist_build()
	renderChecklist(activeChecklist,lineLength)
end

function close_checklist_window()
	checklist_wnd = 0
end

function renderChecklist(activeChecklist,lineLength)
	imgui.SetCursorPosX(10)
	imgui.SetCursorPosY(10)

	if imgui.Button("Stop", 70, 25) then
	end
	
	imgui.SameLine()
	imgui.SetCursorPosX(130)
	
	local checklistPaused = false
	if checklistPaused then
		-- The current checklist execution is paused, so show a button to resume the execution
		if imgui.Button("Resume", 70, 25) then
		end
	else
		-- The current checklist execution is not paused, so show a button to pause the execution
		if imgui.Button("Pause", 70, 25) then
		end
	end

	imgui.SetCursorPosY(50)

	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted(activeChecklist:getHeadline(lineLength))
	imgui.PopStyleColor()

	imgui.SetCursorPosY(65)
	
	local items = activeChecklist:getAllItems()
	for _, item in ipairs(items) do
		imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
		imgui.PushStyleColor(imgui.constant.Col.Text,item:getColor()) 
			imgui.TextUnformatted(item:getLine(lineLength))
		imgui.PopStyleColor()		
	end

	imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
	local line = {}
	for i=0,lineLength,1 do
		line[#line + 1] = "="
	end
	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted(table.concat(line))
	imgui.PopStyleColor()


end

init_checklist_window((preflightChkl:getNumberOfItems()+2)*22+50,410,"CHECKLIST")

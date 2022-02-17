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
local procedure_wnd = nil

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

function init_procedure_window (height, width, name)
	if procedure_wnd == 0 or procedure_wnd == nil then	
		procedure_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(procedure_wnd, name)
		float_wnd_set_position(procedure_wnd, 30, 80)
		float_wnd_set_imgui_builder(procedure_wnd, "procedure_build")
		float_wnd_set_onclose(procedure_wnd, "close_procedure_window")
	end
end

local testSOP = SOP:new("B738 SOP")

-- ======= Preflight checklist =======

local preflightChkl = Checklist:new("PREFLIGHT (PM)")

preflightChkl:addItem(ChecklistItem:new("OXYGEN","Tested, 100%","ALL"))
preflightChkl:addItem(ChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",ChecklistItem.actorPF,function (self) return get("laminar/B738/toggle_switch/vhf_nav_source") == 0 and get("laminar/B738/toggle_switch/irs_source") == 0 and get("laminar/B738/toggle_switch/fmc_source") == 0 and get("laminar/B738/toggle_switch/dspl_source") == 0 and get("laminar/B738/toggle_switch/dspl_ctrl_pnl") == 0 end ))
preflightChkl:addItem(ChecklistItem:new("WINDOW HEAT","ON",ChecklistItem.actorPF,function (self) return get("laminar/B738/ice/window_heat_l_side_pos") == 1 and get("laminar/B738/ice/window_heat_l_fwd_pos") == 1 and get("laminar/B738/ice/window_heat_r_fwd_pos") == 1 and get("laminar/B738/ice/window_heat_r_side_pos") == 1 end ))
preflightChkl:addItem(ChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",ChecklistItem.actorPF,function (self) return get("laminar/B738/toggle_switch/air_valve_ctrl") == 0 end ))
preflightChkl:addItem(ChecklistItem:new("FLIGHT INSTRUMENTS","Heading___,Altimeter____",ChecklistItem.actorBOTH,nil,function (self) return string.format("HEADING %i, ALTIMETER %i",math.floor(get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot")),math.floor(get("laminar/B738/autopilot/altitude"))) end ))
preflightChkl:addItem(ChecklistItem:new("PARKING BRAKE","SET",ChecklistItem.actorPF,function (self) return get("laminar/B738/parking_brake_pos") == 1 end ))
preflightChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",ChecklistItem.actorPF,function (self) return get("laminar/B738/engine/mixture_ratio1") == 0 and get("laminar/B738/engine/mixture_ratio2") == 0 end ))
preflightChkl:addItem(ChecklistItem:new("GEAR PINS","REMOVED",ChecklistItem.actorPF))

-- ======= Secure checklist =======

local secureChkl = Checklist:new("SECURE (F/O)")
secureChkl:addItem(ChecklistItem:new(		"EFBs (if installed)",			"SHUT DOWN",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"IRSs",							"OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"EMERGENCY EXIT LIGHTS",		"OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"WINDOW HEAT",					"OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"PACKS",						"OFF",ChecklistItem.actorCPT))
secureChkl:addItem(SimpleChecklistItem:new(	"If the aircraft is not handed over to succeeding flight"))
secureChkl:addItem(SimpleChecklistItem:new(	"crew or maintenance personnel:"))
secureChkl:addItem(ChecklistItem:new(		"  EFB switches (if installed)","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"  APU/GRD PWR",				"OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"  GROUND SERVICE SWITCH",		"ON",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new(		"  BAT SWITCH",					"OFF",ChecklistItem.actorCPT))


-- ============ Procedures =============
local prelPreflightProc = Procedure:new("PRELIMINARY PREFLIGHT PROCEDURE")
prelPreflightProc:addItem(ProcedureItem:new("XPDR","SET 2000","F/O",1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","SET AS NEEDED","F/O",1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("BATTERIES","ON","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("POWER","ON","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("STANDBY POWER","ON","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("FIRE TESTS","PERFORM","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("WING & WHEEL WELL LIGHTS","AS REQUIRED","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMP FOR APU","AS REQUIRED","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("ELEC HYD PUMPS","ON","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("IRSs","OFF","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("MCP","INITIALIZE","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("IFE & GALLEY POWER","ON","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("MACH OVERSPEED TEST","PERFORM","F/O",1,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("STALL WARNING TEST","PERFORM","F/O",1,nil,nil))

-- add the checklists and procedures to the sop
testSOP:addProcedure(prelPreflightProc)
testSOP:addChecklist(secureChkl)
testSOP:addChecklist(preflightChkl)

activeChecklist = testSOP:getActiveChecklist()
activeProcedure = testSOP:getActiveProcedure()

function checklist_build()
	renderChecklist(activeChecklist,lineLength)
end

function procedure_build()
	renderProcedure(activeProcedure,lineLength)
end

function close_checklist_window()
	checklist_wnd = 0
end

function close_procedure_window()
	procedure_wnd = 0
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
		-- item:validate()
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

function renderProcedure(activeProcedure,lineLength)
	imgui.SetCursorPosX(10)
	imgui.SetCursorPosY(10)

	if imgui.Button("Stop", 70, 25) then
	end
	
	imgui.SameLine()
	imgui.SetCursorPosX(130)
	
	local procedurePaused = false
	if procedurePaused then
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
		imgui.TextUnformatted(activeProcedure:getHeadline(lineLength))
	imgui.PopStyleColor()

	imgui.SetCursorPosY(65)
	
	local items = activeProcedure:getAllItems()
	for _, item in ipairs(items) do
		-- item:validate()
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

-- init_checklist_window((activeProcedure:getNumberOfItems()+2)*22+50,410,"CHECKLIST")
init_procedure_window((activeProcedure:getNumberOfItems()+2)*22+50,410,"PROCEDURE")

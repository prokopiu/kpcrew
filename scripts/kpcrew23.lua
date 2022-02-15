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
AutomaticChecklistItem = require "kpcrew.checklists.AutomaticChecklistItem"
Checklist = require "kpcrew.checklists.Checklist"
ProcedureItem = require "kpcrew.procedures.ProcedureItem"
Procedure = require "kpcrew.procedures.Procedure"
SOP = require "kpcrew.sops.SOP"



local testSOP = SOP:new("SOP TITLE")

local testProc = Procedure:new("PROCEDURE 1")

testProc:addItem(ProcedureItem:new("ITEM 1","CHALLENGE","RESPONSE"))
testProc:addItem(ProcedureItem:new("ITEM 2","CHALLENGE2","RESPONSE2"))

local testChkl = Checklist:new("SECURE (F/O)")
testChkl:addItem(ChecklistItem:new("EFBs (if installed)",			"SHUT DOWN",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("IRSs",							"OFF",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS",			"OFF",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("WINDOW HEAT",					"OFF",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("PACKS",							"OFF",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("If the aircraft is not handed over to succeeding flight","","",1))
testChkl:addItem(ChecklistItem:new("crew or maintenance personnel:","","",1))
testChkl:addItem(ChecklistItem:new("  EFB switches (if installed)",	"OFF",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("  APU/GRD PWR",					"OFF",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("  GROUND SERVICE SWITCH",		"ON",ChecklistItem.actorCPT,1))
testChkl:addItem(ChecklistItem:new("  BAT SWITCH",					"OFF",ChecklistItem.actorCPT,1))

testSOP:addChecklist(testChkl)
testSOP:addProcedure(testProc)
testSOP:addChecklist(testChkl)
testSOP:addProcedure(testProc)

local flows = testSOP:getAllFlows()
for _, flow in ipairs(flows) do
	logMsg(flow:getHeadline(70))
	local items = flow:getAllItems()
	for _, item in ipairs(items) do
		logMsg(item:getLine(70))
	end
end



-- Aircraft specific preferences - Default aircraft
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local DFLTGroup = kcPreferenceGroup:new("aircraft","DFLT AIRCRAFT PREFERENCES")
DFLTGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
DFLTGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
DFLTGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

-- DFLTGroup:add(kcPreference:new("powerup_ext",	false,	kcPreference.typeToggle,"Power Up|With EXT PWR|Without EXT PWR"))
-- DFLTGroup:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|With APU|With GPU/BATT")) 

activePrefSet:addGroup(DFLTGroup)

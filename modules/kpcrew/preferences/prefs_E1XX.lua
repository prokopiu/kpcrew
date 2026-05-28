-- Aircraft specific preferences - E1XX
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local E1XXGroup = kcPreferenceGroup:new("aircraft","TMPL AIRCRAFT PREFERENCES")
E1XXGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
E1XXGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
E1XXGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(E1XXGroup)

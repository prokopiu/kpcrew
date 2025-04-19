-- Aircraft specific preferences - E55P
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local E55PGroup = kcPreferenceGroup:new("aircraft","TMPL AIRCRAFT PREFERENCES")
E55PGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
E55PGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
E55PGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(E55PGroup)

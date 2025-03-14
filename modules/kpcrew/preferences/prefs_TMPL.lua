-- Aircraft specific preferences - TMPL
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local TMPLGroup = kcPreferenceGroup:new("aircraft","TMPL AIRCRAFT PREFERENCES")
TMPLGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
TMPLGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
TMPLGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(TMPLGroup)

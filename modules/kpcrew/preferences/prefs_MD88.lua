-- Aircraft specific preferences - Rotate MD88
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local MD88Group = kcPreferenceGroup:new("aircraft","MD88 AIRCRAFT PREFERENCES")
MD88Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
MD88Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
MD88Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(MD88Group)

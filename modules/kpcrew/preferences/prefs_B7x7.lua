-- Aircraft specific preferences - FF B767...
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local B7x7Group = kcPreferenceGroup:new("aircraft","B7x7 PREFERENCES")
B7x7Group:setInitialOpen(false)
B7x7Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,		"MCP Initial Speed|5")) 
B7x7Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,		"MCP Initial Heading|1")) 
B7x7Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,		"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B7x7Group)

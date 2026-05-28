-- Aircraft specific preferences - mSparks B744
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local B744Group = kcPreferenceGroup:new("aircraft","B744 PREFERENCES")
B744Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,		"MCP Initial Speed|5")) 
B744Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,		"MCP Initial Heading|1")) 
B744Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,		"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B744Group)

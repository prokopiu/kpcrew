-- Aircraft specific preferences - B737
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local B737Group = kcPreferenceGroup:new("aircraft","B737 AIRCRAFT PREFERENCES")
B737Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
B737Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
B737Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B737Group)

-- Aircraft specific preferences - B748
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local B748Group = kcPreferenceGroup:new("aircraft","B748 AIRCRAFT PREFERENCES")
B748Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
B748Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
B748Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B748Group)

-- Aircraft specific preferences - B742
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local B742Group = kcPreferenceGroup:new("aircraft","B742 AIRCRAFT PREFERENCES")
B742Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
B742Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
B742Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B742Group)

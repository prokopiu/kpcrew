-- Aircraft specific preferences - B46X
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local B46XGroup = kcPreferenceGroup:new("aircraft","B46X AIRCRAFT PREFERENCES")
B46XGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
B46XGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
B46XGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B46XGroup)

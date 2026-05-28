-- Aircraft specific preferences - ER1X
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local ER1XGroup = kcPreferenceGroup:new("aircraft","ER1X AIRCRAFT PREFERENCES")
ER1XGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
ER1XGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
ER1XGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(ER1XGroup)

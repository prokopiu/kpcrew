-- Aircraft specific preferences - X-Crafts Free E-Jets
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local E1FFGroup = kcPreferenceGroup:new("aircraft","FREE E175/E195 PREFERENCES")
E1FFGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
E1FFGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
E1FFGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(E1FFGroup)

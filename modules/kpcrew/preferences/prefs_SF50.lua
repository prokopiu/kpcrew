-- Aircraft specific preferences - Laminar SF50
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local SF50Group = kcPreferenceGroup:new("aircraft","DFLT AIRCRAFT PREFERENCES")
SF50Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
SF50Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
SF50Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(SF50Group)

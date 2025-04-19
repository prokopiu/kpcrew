-- Aircraft specific preferences - PC12
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local PC12Group = kcPreferenceGroup:new("aircraft","PC12 AIRCRAFT PREFERENCES")
PC12Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
PC12Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
PC12Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(PC12Group)

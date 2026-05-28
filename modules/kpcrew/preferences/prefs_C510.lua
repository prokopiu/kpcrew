-- Aircraft specific preferences - C510
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local C510Group = kcPreferenceGroup:new("aircraft","C510 AIRCRAFT PREFERENCES")
C510Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
C510Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
C510Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(C510Group)

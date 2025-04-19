-- Aircraft specific preferences - A33L
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local A33LGroup = kcPreferenceGroup:new("aircraft","A33L AIRCRAFT PREFERENCES")
A33LGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
A33LGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
A33LGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(A33LGroup)

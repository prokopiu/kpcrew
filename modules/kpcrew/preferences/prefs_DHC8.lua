-- Aircraft specific preferences - TMPL
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local DHC8Group = kcPreferenceGroup:new("aircraft","DHC8 AIRCRAFT PREFERENCES")
DHC8Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
DHC8Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
DHC8Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(DHC8Group)

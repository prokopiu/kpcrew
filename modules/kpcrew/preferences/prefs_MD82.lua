-- Aircraft specific preferences - Laminar MD82
--
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local MD82Group = kcPreferenceGroup:new("aircraft","MD82 AIRCRAFT PREFERENCES")
MD82Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
MD82Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
MD82Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 
MD82Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|APU|GPU")) 

activePrefSet:addGroup(MD82Group)

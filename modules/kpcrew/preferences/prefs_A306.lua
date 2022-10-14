-- Aircraft specific preferences - iniBuilds A306
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local A306Group = kcPreferenceGroup:new("aircraft","DFLT AIRCRAFT PREFERENCES")
A306Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
A306Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
A306Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 
A306Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|APU|GPU")) 

activePrefSet:addGroup(A306Group)

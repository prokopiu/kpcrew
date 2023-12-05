-- Aircraft specific preferences - IXEG B733
--
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local B733Group = kcPreferenceGroup:new("aircraft","B733 PREFERENCES")
B733Group:setInitialOpen(false)
B733Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
B733Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
B733Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 
B733Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|APU|GPU")) 
B733Group:add(kcPreference:new("takeoff_cmda",	false,	kcPreference.typeToggle,"On TO turn on A/P|ON|OFF")) 

activePrefSet:addGroup(B733Group)

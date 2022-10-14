-- Aircraft specific preferences - Rotate MD-11
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local MD11Group = kcPreferenceGroup:new("aircraft","MD11 PREFERENCES")
MD11Group:setInitialOpen(false)
MD11Group:add(kcPreference:new("efis_mins_dh",	true,	kcPreference.typeToggle,	"EFIS MINS Mode|RADIO (DH)|BARO (DA)")) 
MD11Group:add(kcPreference:new("mcp_def_spd",	250,	kcPreference.typeInt,		"MCP Initial Speed|5")) 
MD11Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,		"MCP Initial Heading|1")) 
MD11Group:add(kcPreference:new("mcp_def_alt",	10000,	kcPreference.typeInt,		"MCP Initial Altitude|100")) 
MD11Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,	"Initial Power-Up|APU|GPU")) 
MD11Group:add(kcPreference:new("efis_mtr",		false,	kcPreference.typeToggle,	"EFIS Meters|MTRS|FEET")) 
MD11Group:add(kcPreference:new("efis_fpv",		false,	kcPreference.typeToggle,	"EFIS Flight Path Vector|ON|OFF")) 

activePrefSet:addGroup(MD11Group)

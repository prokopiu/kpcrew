-- Aircraft specific preferences - Zibo Mod B738
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local B738Group = kcPreferenceGroup:new("aircraft","B738 PREFERENCES")
B738Group:setInitialOpen(false)
B738Group:add(kcPreference:new("efis_mins_dh",	true,	kcPreference.typeToggle,	"EFIS MINS Mode|RADIO (DH)|BARO (DA)")) 
B738Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,		"MCP Initial Speed|5")) 
B738Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,		"MCP Initial Heading|1")) 
B738Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,		"MCP Initial Altitude|100")) 
B738Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,	"Initial Power-Up|APU|GPU")) 
B738Group:add(kcPreference:new("efis_mtr",		false,	kcPreference.typeToggle,	"EFIS Meters|MTRS|FEET")) 
B738Group:add(kcPreference:new("efis_fpv",		false,	kcPreference.typeToggle,	"EFIS Flight Path Vector|ON|OFF")) 
B738Group:add(kcPreference:new("takeoff_cmda",	true,	kcPreference.typeToggle,	"On T/O turn|CMDA ON|leave CMDA OFF")) 

activePrefSet:addGroup(B738Group)

-- Aircraft specific preferences - FF B767...
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local B7x7Group = kcPreferenceGroup:new("aircraft","B7x7 PREFERENCES")
B7x7Group:setInitialOpen(false)
B7x7Group:add(kcPreference:new("efis_mins_dh",	true,	kcPreference.typeToggle,	"EFIS MINS Mode|RADIO (DH)|BARO (DA)")) 
B7x7Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,		"MCP Initial Speed|5")) 
B7x7Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,		"MCP Initial Heading|1")) 
B7x7Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,		"MCP Initial Altitude|100")) 
B7x7Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,	"Initial Power-Up|APU|GPU")) 
B7x7Group:add(kcPreference:new("efis_mtr",		false,	kcPreference.typeToggle,	"EFIS Meters|MTRS|FEET")) 
B7x7Group:add(kcPreference:new("efis_fpv",		false,	kcPreference.typeToggle,	"EFIS Flight Path Vector|ON|OFF")) 
B7x7Group:add(kcPreference:new("takeoff_cmda",	true,	kcPreference.typeToggle,	"On T/O turn|CMDA ON|leave CMDA OFF")) 

activePrefSet:addGroup(B7x7Group)

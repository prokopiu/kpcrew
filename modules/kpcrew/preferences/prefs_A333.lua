-- Aircraft specific preferences - Laminar A330
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local A333Group = kcPreferenceGroup:new("aircraft","A333 AIRCRAFT PREFERENCES")
A333Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
A333Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
A333Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

A333Group:add(kcPreference:new("powerup_ext",	false,	kcPreference.typeToggle,"Power Up|With EXT PWR|Without EXT PWR"))

A333Group:add(kcPreference:new("has_apu",		false,	kcPreference.typeToggle,"Airplane APU|Has APU|Has no APU")) 
A333Group:add(kcPreference:new("has_gpu",		false,	kcPreference.typeToggle,"Airplane GPU|Has GPU|Has no GPU")) 
A333Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|With APU|With GPU/BATT")) 

A333Group:add(kcPreference:new("has_retgear",	true,	kcPreference.typeToggle,"Airplane Gear|Is retractable|is fixed gear")) 

A333Group:add(kcPreference:new("nrofbatts",			2,	kcPreference.typeInt,	"Number of Batteries|1"))
A333Group:add(kcPreference:new("nrofengines",		2,	kcPreference.typeInt,	"Number of Engines|1"))
A333Group:add(kcPreference:new("nroftanks",			3,	kcPreference.typeInt,	"Number of Tanks|1"))

activePrefSet:addGroup(A333Group)

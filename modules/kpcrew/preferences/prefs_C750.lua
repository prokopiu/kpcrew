-- Aircraft specific preferences - Default aircraft
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local C750Group = kcPreferenceGroup:new("aircraft","C750 AIRCRAFT PREFERENCES")
C750Group:add(kcPreference:new("mcp_def_spd",	  0,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
C750Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
C750Group:add(kcPreference:new("mcp_def_alt",	0100,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

C750Group:add(kcPreference:new("powerup_ext",	false,	kcPreference.typeToggle,"Power Up|With EXT PWR|Without EXT PWR")) 

C750Group:add(kcPreference:new("has_apu",		true,	kcPreference.typeToggle,"Airplane APU|Has APU|Has no APU")) 
C750Group:add(kcPreference:new("has_gpu",		true,	kcPreference.typeToggle,"Airplane GPU|Has GPU|Has no GPU")) 
C750Group:add(kcPreference:new("powerup_apu",	true,	kcPreference.typeToggle,"Initial Power-Up|With APU|With GPU")) 

activePrefSet:addGroup(C750Group)

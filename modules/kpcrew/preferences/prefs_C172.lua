-- Aircraft specific preferences - C172
--
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local C172Group = kcPreferenceGroup:new("aircraft","C172 AIRCRAFT PREFERENCES")
C172Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
C172Group:add(kcPreference:new("mcp_def_alt",	4500,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

C172Group:add(kcPreference:new("has_apu",		false,	kcPreference.typeToggle,"Airplane APU|Has APU|Has no APU")) 
C172Group:add(kcPreference:new("has_gpu",		false,	kcPreference.typeToggle,"Airplane GPU|Has GPU|Has no GPU")) 
C172Group:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|With APU|With GPU/BATT")) 

C172Group:add(kcPreference:new("has_retgear",	true,	kcPreference.typeToggle,"Airplane Gear|Is retractable|is fixed gear")) 
C172Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 


activePrefSet:addGroup(C172Group)

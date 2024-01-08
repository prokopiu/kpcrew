-- Aircraft specific preferences - Default aircraft
--
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local DFLTGroup = kcPreferenceGroup:new("aircraft","DFLT AIRCRAFT PREFERENCES")
DFLTGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
DFLTGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
DFLTGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

DFLTGroup:add(kcPreference:new("has_apu",		false,	kcPreference.typeToggle,"Airplane APU|Has APU|Has no APU")) 
DFLTGroup:add(kcPreference:new("has_gpu",		false,	kcPreference.typeToggle,"Airplane GPU|Has GPU|Has no GPU")) 
DFLTGroup:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|With APU|With GPU/BATT")) 

DFLTGroup:add(kcPreference:new("has_retgear",	true,	kcPreference.typeToggle,"Airplane Gear|Is retractable|is fixed gear")) 
DFLTGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 


activePrefSet:addGroup(DFLTGroup)

-- Aircraft specific preferences - EVIC
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local EVICGroup = kcPreferenceGroup:new("aircraft","EVIC AIRCRAFT PREFERENCES")
EVICGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
EVICGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
EVICGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 
EVICGroup:add(kcPreference:new("powerup_apu",	false,	kcPreference.typeToggle,"Initial Power-Up|APU|GPU")) 

activePrefSet:addGroup(EVICGroup)

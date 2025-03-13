-- Aircraft specific preferences - EPIC Aerobask
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local EPICGroup = kcPreferenceGroup:new("aircraft","EPIC AIRCRAFT PREFERENCES")
EPICGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
EPICGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
EPICGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(EPICGroup)

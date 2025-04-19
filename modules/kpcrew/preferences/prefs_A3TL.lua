-- Aircraft specific preferences - A3TL ToLiss Airbusses
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local A3TLGroup = kcPreferenceGroup:new("aircraft","TMPL AIRCRAFT PREFERENCES")
A3TLGroup:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
A3TLGroup:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
A3TLGroup:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 


activePrefSet:addGroup(A3TLGroup)

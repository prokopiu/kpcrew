-- Aircraft specific preferences - ADC3
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local ADC3Group = kcPreferenceGroup:new("aircraft","ADC3 AIRCRAFT PREFERENCES")
ADC3Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
ADC3Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
ADC3Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(ADC3Group)

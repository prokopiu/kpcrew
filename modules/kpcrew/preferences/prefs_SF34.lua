-- Aircraft specific preferences - SF34
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local SF34Group = kcPreferenceGroup:new("aircraft","SF34 AIRCRAFT PREFERENCES")
SF34Group:add(kcPreference:new("mcp_def_spd",	100,	kcPreference.typeInt,	"MCP Initial Speed|5")) 
SF34Group:add(kcPreference:new("mcp_def_hdg",	001,	kcPreference.typeInt,	"MCP Initial Heading|1")) 
SF34Group:add(kcPreference:new("mcp_def_alt",	4900,	kcPreference.typeInt,	"MCP Initial Altitude|100")) 

activePrefSet:addGroup(SF34Group)

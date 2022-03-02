require "kpcrew.genutils"

local PreferenceGroup = require("kpcrew.preferences.PreferenceGroup")
local Preference = require("kpcrew.preferences.Preference")

local B738Group = PreferenceGroup:new("B738","B738 PREFERENCES")
B738Group:add(Preference:new("baro_hpa",true,Preference.typeToggle,"EFIS Default Baro Mode (Both)|HPA|IN")) -- true = HPA (mb), false = inhg
B738Group:add(Preference:new("mins_dh",true,Preference.typeToggle,"EFIS MINS Mode|RADIO (DH)|BARO (DA)")) -- true = Radio DH, false = DA BARO
B738Group:add(Preference:new("powerup",false,Preference.typeToggle,"Initial Power-Up|APU|GPU")) -- true=APU
B738Group:add(Preference:new("mcp_def_spd",100,Preference.typeInt,"MCP Initial Speed|5")) 
B738Group:add(Preference:new("mcp_def_hdg",001,Preference.typeInt,"MCP Initial Heading|1")) 
B738Group:add(Preference:new("mcp_def_alt",4900,Preference.typeInt,"MCP Initial Altitude|100")) 

activePrefSet:addGroup(B738Group)

local B738Group = kcPreferenceGroup:new("aircraft","B738 PREFERENCES")
B738Group:add(kcPreference:new("efis_mins_dh",true,kcPreference.typeToggle,"EFIS MINS Mode|RADIO (DH)|BARO (DA)")) 
B738Group:add(kcPreference:new("mcp_def_spd",100,kcPreference.typeInt,"MCP Initial Speed|5")) 
B738Group:add(kcPreference:new("mcp_def_hdg",001,kcPreference.typeInt,"MCP Initial Heading|1")) 
B738Group:add(kcPreference:new("mcp_def_alt",4900,kcPreference.typeInt,"MCP Initial Altitude|100")) 
B738Group:add(kcPreference:new("powerup_apu",false,kcPreference.typeToggle,"Initial Power-Up|APU|GPU")) 

activePrefSet:addGroup(B738Group)

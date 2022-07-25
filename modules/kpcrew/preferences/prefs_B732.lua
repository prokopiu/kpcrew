local B732Group = kcPreferenceGroup:new("aircraft","B732 PREFERENCES")
B732Group:setInitialOpen(false)
B732Group:add(kcPreference:new("mcp_def_spd",100,kcPreference.typeInt,"MCP Initial Speed|5")) 
B732Group:add(kcPreference:new("mcp_def_hdg",001,kcPreference.typeInt,"MCP Initial Heading|1")) 
B732Group:add(kcPreference:new("mcp_def_alt",4900,kcPreference.typeInt,"MCP Initial Altitude|100")) 
B732Group:add(kcPreference:new("powerup_apu",false,kcPreference.typeToggle,"Initial Power-Up|APU|GPU")) 
B732Group:add(kcPreference:new("takeoff_cmda",false,kcPreference.typeToggle,"On TO turn on A/P|ON|OFF")) 

activePrefSet:addGroup(B732Group)

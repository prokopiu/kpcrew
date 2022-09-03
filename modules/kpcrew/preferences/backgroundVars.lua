activeBckVars = kcPreferenceSet:new("BackgroundVars")

local group1 = kcPreferenceGroup:new("general","General Variables")
group1:add(kcPreference:new("flight_state",1,kcPreference.typeInt,"Flight State|1"))
group1:add(kcPreference:new("timesOUT",	"==:==",kcPreference.typeText,"Actual Time out|00:00"))
group1:add(kcPreference:new("timesOFF",	"==:==",kcPreference.typeText,"Actual Time off block|00:00"))
group1:add(kcPreference:new("timesIN",	"==:==",kcPreference.typeText,"Actual Time in|00:00"))
group1:add(kcPreference:new("timesON",	"==:==",kcPreference.typeText,"Actual Time on blocks|00:00"))

local group2 = kcPreferenceGroup:new("ui","UI Settings")
group2:add(kcPreference:new("sop_wnd_ypos",70,kcPreference.typeInt,"SOP Window Y Pos|"))
group2:add(kcPreference:new("sop_wnd_xoffset",50,kcPreference.typeInt,"SOP Window x offset from right|"))
group2:add(kcPreference:new("flow_wnd_xpos",30,kcPreference.typeInt,"Flow Window x position|"))
group2:add(kcPreference:new("flow_wnd_ypos",70,kcPreference.typeInt,"Flow Window y position|"))
group2:add(kcPreference:new("flow_line_length",55,kcPreference.typeInt,"Flow text line length|"))

activeBckVars:addGroup(group1)
activeBckVars:addGroup(group2)
activeBckVars:addGroup(kc_global_procvars)

function getBckVars()
	return activeBckVars
end

return backgroundVars
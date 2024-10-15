-- backgrond variables for use by KPCrew internally
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
activeBckVars = kcPreferenceSet:new("BackgroundVars")

local group1 = kcPreferenceGroup:new("general","General Variables")
group1:add(kcPreference:new("simversion",		" ",		kcPreference.typeText,	"Simversion|"))
group1:add(kcPreference:new("flight_state",		1,			kcPreference.typeInt,	"Flight State|1"))
group1:add(kcPreference:new("timesOUT",			"==:==",	kcPreference.typeText,	"Actual Time out|00:00"))
group1:add(kcPreference:new("timesOFF",			"==:==",	kcPreference.typeText,	"Actual Time off block|00:00"))
group1:add(kcPreference:new("timesIN",			"==:==",	kcPreference.typeText,	"Actual Time in|00:00"))
group1:add(kcPreference:new("timesON",			"==:==",	kcPreference.typeText,	"Actual Time on blocks|00:00"))
group1:add(kcPreference:new("vatsimUrl","http://metar.vatsim.net/",kcPreference.typeText,"VATSIM METAR|"))


local group2 = kcPreferenceGroup:new("ui","UI Settings")
group2:add(kcPreference:new("sop_wnd_ypos",		 70,		kcPreference.typeInt,	"SOP Window Y Pos|"))
group2:add(kcPreference:new("sop_wnd_xoffset",	 50,		kcPreference.typeInt,	"SOP Window x offset from right|"))
group2:add(kcPreference:new("flow_wnd_xpos",	 30,		kcPreference.typeInt,	"Flow Window x position|"))
group2:add(kcPreference:new("flow_wnd_ypos",	 70,		kcPreference.typeInt,	"Flow Window y position|"))
group2:add(kcPreference:new("flow_line_length",	 55,		kcPreference.typeInt,	"Flow text line length|"))

local group3 = kcPreferenceGroup:new("BRIEFINGS","BRIEFINGS Settings")
group3:add(kcPreference:new("win_width",		350,		kcPreference.typeInt,	"Briefing win width|"))
group3:add(kcPreference:new("win_height",		650,		kcPreference.typeInt,	"Briefing win height|"))
group3:add(kcPreference:new("win_pos_x",		690,		kcPreference.typeInt,	"Briefing win xoffset|"))
group3:add(kcPreference:new("win_pos_y",		 70,		kcPreference.typeInt,	"Briefing win yoffset|"))

local group4 = kcPreferenceGroup:new("PREFERENCES","PREFERENCES Settings")
group4:add(kcPreference:new("win_width",		350,		kcPreference.typeInt,	"Preferences win width|"))
group4:add(kcPreference:new("win_height",		600,		kcPreference.typeInt,	"Preferences win height|"))
group4:add(kcPreference:new("win_pos_x",		330,		kcPreference.typeInt,	"Preferences win xoffset|"))
group4:add(kcPreference:new("win_pos_y",		 70,		kcPreference.typeInt,	"Preferences win yoffset|"))

activeBckVars:addGroup(group1)
activeBckVars:addGroup(group2)
activeBckVars:addGroup(group3)
activeBckVars:addGroup(group4)
activeBckVars:addGroup(kc_global_procvars)

function getBckVars()
	return activeBckVars
end

return backgroundVars
require "kpcrew.genutils"

local backgroundVars = {
}

kc_flight_states = "COLD&DARK|PREL PRE-FLIGHT|PRE-FLIGHT"

activeBckVars = PreferenceSet:new("BackgroundVars")

local group1 = PreferenceGroup:new("general","General Variables")
group1:add(Preference:new("flight_state",1,Preference.typeList,"Flight States|" .. kc_flight_states))

activeBckVars:addGroup(group1)

function getBckVars()
	return activeBckVars
end

return backgroundVars
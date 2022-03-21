activePrefSet = kcPreferenceSet:new("PREFERENCES")

local generalGroup = kcPreferenceGroup:new("general","GENERAL PREFERENCES")
generalGroup:setInitialOpen(true)
generalGroup:add(kcPreference:new("weight_kgs",true,kcPreference.typeToggle,"Weight Units|KGS|LBS"))
generalGroup:add(kcPreference:new("baro_mode_hpa",true,kcPreference.typeToggle,"EFIS Default Baro Mode (Both)|HPA|IN"))
generalGroup:add(kcPreference:new("def_trans_alt",5000,kcPreference.typeInt,"Default Transition Level (ft)|100"))
generalGroup:add(kcPreference:new("def_trans_lvl",50,kcPreference.typeInt,"Default Transition Level (FL)|10"))

activePrefSet:addGroup(generalGroup)

-- load aircraft specific preferences
require("kpcrew.preferences.prefs_" .. kc_acf_icao)

function getActivePrefs()
	return activePrefSet
end

return defaultPrefs
activePrefSet = kcPreferenceSet:new("PREFERENCES")

kc_assistance_levels = "No assistance|Guided|Some automation|Fully automatic"

local generalGroup = kcPreferenceGroup:new("general","GENERAL PREFERENCES")
generalGroup:setInitialOpen(true)
generalGroup:add(kcPreference:new("assistance",1,kcPreference.typeList,"Assistance Level|" .. kc_assistance_levels))
generalGroup:add(kcPreference:new("weight_kgs",true,kcPreference.typeToggle,"Weight Units|KGS|LBS"))
generalGroup:add(kcPreference:new("baro_mode_hpa",true,kcPreference.typeToggle,"EFIS Default Baro Mode (Both)|HPA|IN"))
generalGroup:add(kcPreference:new("def_trans_alt",5000,kcPreference.typeInt,"Default Transition Altitude (ft)|100"))
generalGroup:add(kcPreference:new("def_trans_lvl",50,kcPreference.typeInt,"Default Transition Level (FL)|10"))
generalGroup:add(kcPreference:new("speakProcedure",false,kcPreference.typeToggle,"Speak Procedures|Talk|Quiet"))
generalGroup:add(kcPreference:new("speakChecklist",false,kcPreference.typeToggle,"Speak Checklists|All|Only Challenge"))


activePrefSet:addGroup(generalGroup)

-- load aircraft specific preferences
require("kpcrew.preferences.prefs_" .. kc_acf_icao)

function getActivePrefs()
	return activePrefSet
end

return defaultPrefs
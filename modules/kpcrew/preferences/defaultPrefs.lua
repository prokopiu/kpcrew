require "kpcrew.genutils"

local defaultPrefs = {
}

PreferenceSet = require("kpcrew.preferences.PreferenceSet")
PreferenceGroup = require("kpcrew.preferences.PreferenceGroup")
Preference = require("kpcrew.preferences.Preference")

activePrefSet = PreferenceSet:new("DEFAULT PREFERENCES")

local generalGroup = PreferenceGroup:new("general","GENERAL PREFERENCES")
generalGroup:add(Preference:new("weight_units",true,Preference.typeToggle,"Weight Units|KGS|LBS")) -- true=KGS
generalGroup:add(Preference:new("baro_hpa",true,Preference.typeToggle,"EFIS Default Baro Mode (Both)|HPA|IN")) -- true = HPA (mb), false = inhg
generalGroup:add(Preference:new("defTransAlt",5000,Preference.typeInt,"Default Transition Level (ft)|100"))
generalGroup:add(Preference:new("defTransLvl",50,Preference.typeInt,"Default Transition Level (FL)|10"))

activePrefSet:addGroup(generalGroup)

require("kpcrew.preferences.prefs_" .. acf_icao)

function getActivePrefs()
	return activePrefSet
end

return defaultPrefs
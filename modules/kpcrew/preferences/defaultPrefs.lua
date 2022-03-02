require "kpcrew.genutils"

local defaultPrefs = {
	icao = "DFLT"
}

local PreferenceSet = require("kpcrew.preferences.PreferenceSet")
local PreferenceGroup = require("kpcrew.preferences.PreferenceGroup")
local Preference = require("kpcrew.preferences.Preference")

activePrefSet = PreferenceSet:new("DEFAULT PREFERENCES")

local generalGroup = PreferenceGroup:new("general","GENERAL PREFERENCES")
generalGroup:add(Preference:new("weight_units",true,Preference.typeToggle,"Weight Units|KGS|LBS")) -- true=KGS
generalGroup:add(Preference:new("defTransAlt",5000,Preference.typeInt,"Default Transition Level (ft)|100"))
generalGroup:add(Preference:new("defTransLvl",50,Preference.typeInt,"Default Transition Level (FL)|10"))

activePrefSet:addGroup(generalGroup)

require("kpcrew.preferences.prefs_" .. acf_icao)

function getActivePrefs()
	return activePrefSet
end

return defaultPrefs
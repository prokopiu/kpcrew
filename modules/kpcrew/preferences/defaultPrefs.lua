activePrefSet = kcPreferenceSet:new("PREFERENCES")

kc_assistance_levels = "No assistance|Guided|Some automation|Fully automatic"
kc_weight_units = "KGS|LBS"
kc_baro_units = "HPA|IN"

local generalGroup = kcPreferenceGroup:new("general","GENERAL PREFERENCES")
generalGroup:setInitialOpen(true)
-- generalGroup:add(kcPreference:new("test",1,kcPreference.typeInfo,"TEST|"))
generalGroup:add(kcPreference:new("assistance",1,kcPreference.typeList,"Assistance Level|" .. kc_assistance_levels))
generalGroup:add(kcPreference:new("weight_kgs",true,kcPreference.typeToggle,"Weight Units|" .. kc_weight_units))
generalGroup:add(kcPreference:new("baro_mode_hpa",true,kcPreference.typeToggle,"EFIS Default Baro Mode (Both)|" .. kc_baro_units))

generalGroup:add(kcPreference:new("def_trans_alt",5000,kcPreference.typeInt,"Default Transition Altitude (ft)|100"))
generalGroup:add(kcPreference:new("def_trans_lvl",60,kcPreference.typeInt,"Default Transition Level (FL)|10"))

generalGroup:add(kcPreference:new("flowAutoOpen",false,kcPreference.typeToggle,"Flow window on start|Open flows|Do not open flows"))
generalGroup:add(kcPreference:new("flowAutoClose",false,kcPreference.typeToggle,"Flow window at end|Close flows|Do not close flows"))
generalGroup:add(kcPreference:new("flowAutoJump",false,kcPreference.typeToggle,"On end of flow|Jump to next flow|Do not not jump"))

generalGroup:add(kcPreference:new("xpdrusa",false,kcPreference.typeToggle,"Transponder|USA XPDR mode|EUR XPDR mode"))

generalGroup:add(kcPreference:new("simbriefuser"," ",kcPreference.typeText,"SIMBRIEF Username|"))
generalGroup:add(kcPreference:new("vatsimMetar",false,kcPreference.typeToggle,"VATSIM METAR|Load ON|Load OFF"))

generalGroup:add(kcPreference:new("betterPushback",false,kcPreference.typeToggle,"BetterPushback|Use BP|Don't use BP"))
generalGroup:add(kcPreference:new("sges",false,kcPreference.typeToggle,"Simple Ground Services|Use GSES|Don't use SGES"))


activePrefSet:addGroup(generalGroup)

-- load aircraft specific preferences
require("kpcrew.preferences.prefs_" .. kc_acf_icao)

function getActivePrefs()
	return activePrefSet
end

return defaultPrefs
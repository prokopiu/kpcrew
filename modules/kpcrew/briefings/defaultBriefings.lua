activeBriefings = kcPreferenceSet:new("BRIEFINGS")
activeBriefings:setFilename("briefings")

-- load aircraft specific briefing values
require("kpcrew.briefings.briefings_" .. kc_acf_icao)

-- departure procedure types
local DEP_proctype_list = "SID|VECTORS|TRACKING"
-- Noise Abatement departure Procedure
local DEP_nadp_list = "NOT REQUIRED|SEE SID"
-- runway states
local DEP_rwystate_list = "DRY|WET|CONTAMINATED"

-- ============== Information =============

local information = kcPreferenceGroup:new("information","INFORMATION")
-- information:setInitialOpen(true)
information:add(kcPreference:new("aircraftType",function () return kc_acf_name .. " - " .. kc_acf_icao end,kcPreference.typeInfo,"Aircraft Type|"))

information:add(kcPreference:new("totalFuel",
function () return string.format("%6.6i %s",kc_get_total_fuel(),activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") end,
kcPreference.typeInfo,"Total Fuel|"))

information:add(kcPreference:new("grosszfw",
function () 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	return string.format("%6.6i %s",kc_get_gross_weight(),wunit) .. " / " .. string.format("%6.6i %s",kc_get_zfw(),wunit)
end,
kcPreference.typeInfo,"Gross Weight / ZFW|"))

information:add(kcPreference:new("currPosition",
function () 
	return kc_convertDMS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude"))
end,
kcPreference.typeInfo,"Current Position|"))

information:add(kcPreference:new("currElevation",
function () 
	return string.format("%6.0f ft\n",get("sim/cockpit2/autopilot/altitude_readout_preselector"))
end,
kcPreference.typeInfo,"Current Elevation|"))

information:add(kcPreference:new("currElevation",
function () 
	return kc_dispTimeFull(get("sim/time/local_time_sec")) .. " / " .. kc_dispTimeFull(get("sim/time/zulu_time_sec"))
end,
kcPreference.typeInfo,"Local/Zulu Time|"))

information:add(kcPreference:new("localMetar",
function () 
	return kc_buildAtisString()
end,
kcPreference.typeInfo,"Local METAR|"))

-- =================== FLIGHT DATA ==================
local flight = kcPreferenceGroup:new("flight","FLIGHT")
-- flight:setInitialOpen(true)
flight:add(kcPreference:new("callsign","",kcPreference.typeText,"Callsign|"))
flight:add(kcPreference:new("originIcao","",kcPreference.typeText,"Origin ICAO|"))
flight:add(kcPreference:new("destinationIcao","",kcPreference.typeText,"Destination ICAO|"))
flight:add(kcPreference:new("cruiseLevel",0,kcPreference.typeInt,"Cruise Level (FL)|10"))
flight:add(kcPreference:new("takeoffFuel",0,kcPreference.typeInt,
function ()
	return "Takeoff Fuel " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))

-- =================== DEPARTURE ==================
local departure = kcPreferenceGroup:new("departure","DEPARTURE")
departure:setInitialOpen(true)
departure:add(kcPreference:new("atisFrequency","",kcPreference.typeText,"ATIS Frequency|"))
departure:add(kcPreference:new("atisInfo","",kcPreference.typeText,"ATIS Information|"))
departure:add(kcPreference:new("clrFrequency","",kcPreference.typeText,"Clearance Frequency|"))
departure:add(kcPreference:new("type",1,kcPreference.typeList,"Departure Type|" .. DEP_proctype_list))
departure:add(kcPreference:new("route","",kcPreference.typeText,"Departure Route|"))
departure:add(kcPreference:new("transition","",kcPreference.typeText,"Departure Transition|"))
departure:add(kcPreference:new("NADP",1,kcPreference.typeList,"NADP|" .. DEP_nadp_list))
departure:add(kcPreference:new("initAlt",4900,kcPreference.typeInt,"Initial Altitude (ft)|100"))
departure:add(kcPreference:new("rwy","",kcPreference.typeText,"Departure Runway|"))
departure:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. DEP_rwystate_list))
departure:add(kcPreference:new("squawk","",kcPreference.typeText,"XPDR SQUAWK|"))
departure:add(kcPreference:new("depFrequency","",kcPreference.typeText,"Departure Frequency|"))
departure:add(kcPreference:new("initHeading",0,kcPreference.typeInt,"Initial Heading|1"))


-- Briefing setup
activeBriefings:addGroup(information)
activeBriefings:addGroup(flight)
activeBriefings:addGroup(departure)

function getActiveBriefings()
	return activeBriefings
end

return defaultBriefings
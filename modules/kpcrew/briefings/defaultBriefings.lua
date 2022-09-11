activeBriefings = kcPreferenceSet:new("BRIEFINGS")
activeBriefings:setFilename("briefings")

-- departure procedure types
kc_DEP_proctype_list = "SID|VECTORS|TRACKING"
-- Noise Abatement departure Procedure
kc_DEP_nadp_list = "NOT REQUIRED|SEE SID"
-- runway states
kc_DEP_rwystate_list = "DRY|WET|CONTAMINATED"
-- parking positin options
kc_DEP_gatestand_list = "GATE (PUSH)|STAND (PUSH)|STAND (NO PUSH)"
-- push direction
kc_DEP_push_direction = "NO PUSH|NOSE LEFT|NOSE RIGHT|NOSE STRAIGHT|FACING NORTH|FACING SOUTH|FACING EAST|FACING WEST"
-- forced return overweight or underweight
kc_DEP_forced_return = "UNDERWEIGHT|OVERWEIGHT"

-- runway state arrival
kc_APP_rwystate_list = "DRY|WET|CONTAMINATED"
-- arrival procedure type list 
kc_APP_proctype_list = "STAR|VECTORS"
-- Noise Abatement on arrival
kc_APP_na_list = "NOT REQUIRED|SEE STAR"
-- parking position options
kc_APP_gatestand_list = "GATE|STAND|STAND PUSH-IN REQUIRED"
-- power at gate
kc_APP_power_at_stand = "EXTERNAL POWER|NO POWER"

kc_WX_Precipitation_list = "NONE|DRIZZLE|LIGHT RAIN|RAIN|HEAVY RAIN|SNOW"
kc_WX_Cloud_list = "NO|FEW|SCATTERED|BROKEN|OVERCAST"

-- load aircraft specific briefing values
require("kpcrew.briefings.briefings_" .. kc_acf_icao)

-- ============== Information =============

local information = kcPreferenceGroup:new("information","INFORMATION")
information:setInitialOpen(true)
information:add(kcPreference:new("flightState",
function () 
	return kcSopFlightPhase[activeBckVars:get("general:flight_state")]
end,
kcPreference.typeInfo,"Flight State|0xFF0000FF"))

information:add(kcPreference:new("aircraftType",function () return kc_acf_name .. " - " .. kc_acf_icao end,kcPreference.typeInfo,"Aircraft Type|"))

information:add(kcPreference:new("totalFuel",
function () 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	return string.format("%6.6i %s (MFUEL: %6.6i %s)",kc_get_total_fuel(),wunit,kc_get_MaxFuel(),wunit) 
end,
kcPreference.typeInfo,"Total Fuel|"))

information:add(kcPreference:new("grosszfw",
function () 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	return string.format("%6.6i %s",kc_get_gross_weight(),wunit) .. " / " .. string.format("%6.6i %s",kc_get_zfw(),wunit) .. " / " .. string.format("%6.6i %s",kc_get_MZFW(),wunit)
end,
kcPreference.typeInfo,"Gross Weight / ZFW / MZFW|"))

information:add(kcPreference:new("grosszfw",
function () 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	return string.format("%6.6i %s",kc_get_MTOW(),wunit) .. " / " .. string.format("%6.6i %s",kc_get_MLW(),wunit)
end,
kcPreference.typeInfo,"MTOW / MLW|"))
information:add(kcPreference:new("melIssues",1,kcPreference.typeList,"Minimum Equipment List issues|" .. kc_MELIssues))

information:add(kcPreference:new("currPosition",
function () 
	return kc_convertDMS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")) .. "\n" ..
	kc_convertINS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude"))
end,
kcPreference.typeInfo,"Current Position|"))

information:add(kcPreference:new("currElevation",
function () 
	return string.format("%6.0f ft\n",get("sim/cockpit2/autopilot/altitude_readout_preselector"))
end,
kcPreference.typeInfo,"Current Elevation|"))

information:add(kcPreference:new("localZulutime",
function () 
	return kc_dispTimeFull(get("sim/time/local_time_sec")) .. " / " .. kc_dispTimeFull(get("sim/time/zulu_time_sec"))
end,
kcPreference.typeInfo,"Local/Zulu Time|"))

information:add(kcPreference:new("localMetar",
function () 
	return kc_buildAtisString()
end,
kcPreference.typeInfo,"Local METAR|"))
information:add(kcPreference:new("FlightTimes",
function () 
	return "OFF: " .. activeBckVars:get("general:timesOFF") .. "Z OUT: " .. activeBckVars:get("general:timesOUT") 
	.. "Z\nIN : " .. activeBckVars:get("general:timesIN") .. "Z  ON: " .. activeBckVars:get("general:timesON") .. "Z"
end,
kcPreference.typeInfo,"Flight Times|0xFF0000FF"))


-- =================== FLIGHT DATA ==================
local flight = kcPreferenceGroup:new("flight","FLIGHT")
-- flight:setInitialOpen(true)
flight:add(kcPreference:new("callsign","",kcPreference.typeText,"ATC Callsign|"))
flight:add(kcPreference:new("originIcao","",kcPreference.typeText,"Origin ICAO|"))
flight:add(kcPreference:new("destinationIcao","",kcPreference.typeText,"Destination ICAO|"))
flight:add(kcPreference:new("alternateIcao","",kcPreference.typeText,"Alternate ICAO|"))
flight:add(kcPreference:new("distance",0,kcPreference.typeInt,"Air Distance from OFP (nm)|10"))
flight:add(kcPreference:new("cruiseLevel",0,kcPreference.typeInt,"Cruise Level (FL)|10"))
flight:add(kcPreference:new("criticalMORA",0,kcPreference.typeInt,"Critical MORA (FT)|100"))
flight:add(kcPreference:new("averageWind","",kcPreference.typeText,"Average Wind (999/99)|"))
flight:add(kcPreference:new("averageWC",0,kcPreference.typeInt,"Average Wind Component|1"))
flight:add(kcPreference:new("averageISA",0,kcPreference.typeInt,"Average ISA|1"))
if kc_show_cost_index then 
	flight:add(kcPreference:new("costIndex",0,kcPreference.typeInt,"Cost Index|1"))
end
flight:add(kcPreference:new("payload",0,kcPreference.typeInt,
function ()
	return "Total payload " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))
flight:add(kcPreference:new("takeoffFuel",0,kcPreference.typeInt,
function ()
	return "Takeoff Fuel " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))
flight:add(kcPreference:new("Finres",0,kcPreference.typeInt,
function ()
	return "Final Reserve + Alternate " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))
if kc_show_load_button then
	flight:add(kcPreference:new("loadbutton",0,kcPreference.typeExecButton,"Payload & Fuel|Load |kc_set_payload()"))
end

-- =================== DEPARTURE ==================
local departure = kcPreferenceGroup:new("departure","DEPARTURE")
-- departure:setInitialOpen(true)
departure:add(kcPreference:new("AtisFrequency1",122.800,kcPreference.typeCOMFreq,"ATIS Frequency|"))
departure:add(kcPreference:new("atisInfo","",kcPreference.typeText,"ATIS Information|"))
departure:add(kcPreference:new("clrFrequency",122.800,kcPreference.typeCOMFreq,"Clearance Frequency|"))
departure:add(kcPreference:new("type",1,kcPreference.typeList,"Departure Type|" .. kc_DEP_proctype_list))
departure:add(kcPreference:new("route","",kcPreference.typeText,"Departure Route|"))
departure:add(kcPreference:new("transition","",kcPreference.typeText,"Departure Transition|"))
departure:add(kcPreference:new("depNADP",1,kcPreference.typeList,"NADP|" .. kc_DEP_nadp_list))
departure:add(kcPreference:new("initAlt",4900,kcPreference.typeInt,"Initial Altitude (ft)|100"))
departure:add(kcPreference:new("transalt",activePrefSet:get("general:def_trans_alt"),kcPreference.typeInt,"Transition Altitude (ft)|100"))
departure:add(kcPreference:new("rwy","",kcPreference.typeText,"Departure Runway|"))
departure:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. kc_DEP_rwystate_list))
departure:add(kcPreference:new("squawk","",kcPreference.typeText,"XPDR SQUAWK|"))
departure:add(kcPreference:new("depFrequency",122.800,kcPreference.typeCOMFreq,"Departure Frequency|"))
departure:add(kcPreference:new("initHeading",0,kcPreference.typeInt,"Initial Heading|1"))
departure:add(kcPreference:new("nav1Frequency",109.000,kcPreference.typeNAVFreq,"NAV1/ILS Frequency|1"))
departure:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"NAV1 CRS|10"))
departure:add(kcPreference:new("nav2Frequency",109.000,kcPreference.typeNAVFreq,"NAV2 Frequency|2"))
departure:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))

-- =================== TAXIING BRIEFING ==================
local taxi = kcPreferenceGroup:new("taxi","TAXI DETAILS")
-- taxi:setInitialOpen(true)
taxi:add(kcPreference:new("gndFrequency1",122.800,kcPreference.typeCOMFreq,"Ground Frequency|"))
taxi:add(kcPreference:new("towerFrequency1",122.800,kcPreference.typeCOMFreq,"Tower Frequency|"))
taxi:add(kcPreference:new("parkingStand","",kcPreference.typeText,"Parking Stand|"))
taxi:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. kc_DEP_gatestand_list))
taxi:add(kcPreference:new("pushDirection",1,kcPreference.typeList,"Push Direction|" .. kc_DEP_push_direction))
taxi:add(kcPreference:new("startSequence",1,kcPreference.typeList,"Start Sequence|" .. kc_StartSequence))
taxi:add(kcPreference:new("taxiRoute","",kcPreference.typeText,"Taxi Route|"))

-- TRIBETS?
-- Threats, Rain, Weatjer, Traffic, Languag difficult, MEL issues? Minimum Equipment List
-- Route checke


-- =================== DEPARTURE BRIEFING ==================
-- W eather highlites
-- A ircraft - Type of aircraft and engines
-- N otams - highlite 
-- N oise abatement proc
-- T axi Taxiroute
-- R outing  SID brief alt constraints, speeds, msa ... frequencies
-- A utomation AFDS LNAV/VNAV or other
-- M iscellaneous - any specialities and other non mentioned items of intereset	

local depBriefing = kcPreferenceGroup:new("depBriefing","DEPARTURE BRIEFING")
-- depBriefing:setInitialOpen(true)
depBriefing:add(kcPreference:new("flightbriefing",
function () 
	return kc_dep_brief_flight()
end,
kcPreference.typeInfo,"Ready for the departure briefing?|"))

depBriefing:add(kcPreference:new("taxibriefing",
function () 
	return kc_dep_brief_taxi()
end,
kcPreference.typeInfo,"Taxi Briefing|"))

depBriefing:add(kcPreference:new("deproute",
function () 
	return kc_dep_brief_departure()
end,
kcPreference.typeInfo,"Departure|"))

depBriefing:add(kcPreference:new("safety brief",
function () 
	return kc_dep_brief_safety()
end,
kcPreference.typeInfo,"Safety Briefing|"))

-- =================== TAKEOFF ==================
local takeoff = kcPreferenceGroup:new("takeoff","TAKEOFF")
-- takeoff:setInitialOpen(true)
takeoff:add(kcPreference:new("thrust",1,kcPreference.typeList,"T/O Thrust|" .. kc_TakeoffThrust))
takeoff:add(kcPreference:new("flaps",1,kcPreference.typeList,"T/O Flaps|" .. kc_TakeoffFlaps))
takeoff:add(kcPreference:new("antiice",1,kcPreference.typeList,"T/O Anti Ice|" .. kc_TakeoffAntiice))
takeoff:add(kcPreference:new("packs",1,kcPreference.typeList,"T/O Packs|" .. kc_TakeoffPacks))
takeoff:add(kcPreference:new("bleeds",1,kcPreference.typeList,"T/O Bleed Settings|" .. kc_TakeoffBleeds))
takeoff:add(kcPreference:new("msa",0,kcPreference.typeInt,"Departure MSA (ft)|100"))
takeoff:add(kcPreference:new("forcedReturn",1,kcPreference.typeList,"Forced Return|" .. kc_DEP_forced_return))
takeoff:add(kcPreference:new("elevatorTrim",0,kcPreference.typeFloat,"Elevator Trim|0.1|%4.2f"))
takeoff:add(kcPreference:new("rudderTrim",0,kcPreference.typeFloat,"Rudder Trim|0.1|%4.2f"))
takeoff:add(kcPreference:new("aileronTrim",0,kcPreference.typeFloat,"Aileron Trim|0.1|%4.2f"))
takeoff:add(kcPreference:new("v1",0,kcPreference.typeInt,"V1|1"))
takeoff:add(kcPreference:new("vr",0,kcPreference.typeInt,"VR|1"))
takeoff:add(kcPreference:new("v2",0,kcPreference.typeInt,"V2|1"))
takeoff:add(kcPreference:new("crs1",0,kcPreference.typeInt,"CRS 1|1"))
takeoff:add(kcPreference:new("crs2",0,kcPreference.typeInt,"CRS 2|1"))
takeoff:add(kcPreference:new("apMode",1,kcPreference.typeList,"Autopilot Modes|" .. kc_TakeoffApModes))

-- =================== ARRIVAL ==================
local arrival = kcPreferenceGroup:new("arrival","ARRIVAL")
-- arrival:setInitialOpen(true)
arrival:add(kcPreference:new("atisFrequency2",122.800,kcPreference.typeCOMFreq,"ATIS Frequency|"))
arrival:add(kcPreference:new("atisInfo","",kcPreference.typeText,"ATIS Information|"))
arrival:add(kcPreference:new("translvl",activePrefSet:get("general:def_trans_lvl"),kcPreference.typeInt,"Transition Level|10"))
arrival:add(kcPreference:new("atisWind","",kcPreference.typeText,"ATIS Wind HDG/SPD|"))
arrival:add(kcPreference:new("atisVisibility","",kcPreference.typeText,"ATIS Visibility km|"))
arrival:add(kcPreference:new("atisPrecipit",1,kcPreference.typeList,"ATIS Precipitation|" .. kc_WX_Precipitation_list))
arrival:add(kcPreference:new("atisClouds",1,kcPreference.typeList,"ATIS Clouds|" .. kc_WX_Cloud_list))
arrival:add(kcPreference:new("atisTemps","",kcPreference.typeText,"ATIS Temp/Dewpoint|"))
arrival:add(kcPreference:new("atisQNH","",kcPreference.typeText,"ATIS QNH|"))
arrival:add(kcPreference:new("arrType",1,kcPreference.typeList,"Arrival Type|" .. kc_APP_proctype_list))
arrival:add(kcPreference:new("appFrequency",122.800,kcPreference.typeCOMFreq,"Approach Frequency|"))
arrival:add(kcPreference:new("route","",kcPreference.typeText,"Arrival Route|"))
arrival:add(kcPreference:new("transition","",kcPreference.typeText,"Arrival Transition|"))
arrival:add(kcPreference:new("msa",0,kcPreference.typeInt,"Arrival MSA (ft)|100"))
arrival:add(kcPreference:new("aptElevation",0,kcPreference.typeInt,"Airport Elevation (ft)|100"))
arrival:add(kcPreference:new("arrNADP",1,kcPreference.typeList,"NADP|" .. kc_APP_na_list))

-- =================== APPROACH ==================
local approach = kcPreferenceGroup:new("approach","APPROACH")
-- approach:setInitialOpen(true)
approach:add(kcPreference:new("twrFrequency2",122.800,kcPreference.typeCOMFreq,"Tower Frequency|"))
approach:add(kcPreference:new("gndFrequency2",122.800,kcPreference.typeCOMFreq,"Ground Frequency|"))
approach:add(kcPreference:new("nav1Frequency",109.000,kcPreference.typeNAVFreq,"NAV1/ILS Frequency|1"))
approach:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"NAV1 CRS|10"))
approach:add(kcPreference:new("nav2Frequency",109.000,kcPreference.typeNAVFreq,"NAV2 Frequency|2"))
approach:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))
approach:add(kcPreference:new("appType",1,kcPreference.typeList,"Expect Approach|" .. kc_apptypes))
approach:add(kcPreference:new("rwy","",kcPreference.typeText,"Arrival Runway|"))
approach:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. kc_APP_rwystate_list))
approach:add(kcPreference:new("fafAltitude",0,kcPreference.typeInt,"FAF Altitude (ft)|100"))
approach:add(kcPreference:new("decision",0,kcPreference.typeInt,"Decision Height/Altitude|10"))
approach:add(kcPreference:new("gaheading",0,kcPreference.typeInt,"Go-Around Heading|10"))
approach:add(kcPreference:new("gaaltitude",0,kcPreference.typeInt,"Go-Around Altitude|100"))
approach:add(kcPreference:new("flaps",1,kcPreference.typeList,"Landing Flaps|" .. kc_LandingFlaps))
approach:add(kcPreference:new("vapp",0,kcPreference.typeInt,"Vapp|1"))
approach:add(kcPreference:new("vref",0,kcPreference.typeInt,"Vref|1"))
approach:add(kcPreference:new("autobrake",1,kcPreference.typeList,"Autobrake|" .. kc_LandingAutoBrake))
approach:add(kcPreference:new("packs",1,kcPreference.typeList,"Packs|" .. kc_LandingPacks))
approach:add(kcPreference:new("antiice",1,kcPreference.typeList,"Anti Ice|" .. kc_LandingAntiice))
approach:add(kcPreference:new("reversethrust",1,kcPreference.typeList,"Reverse Thrust|" .. APP_rev_thrust_list))
approach:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. kc_APP_gatestand_list))
approach:add(kcPreference:new("parkingPosition","",kcPreference.typeText,"Parking Position|"))
approach:add(kcPreference:new("powerAtGate",1,kcPreference.typeList,"Power at Stand|" .. kc_APP_power_at_stand))
approach:add(kcPreference:new("taxiIn","",kcPreference.typeText,"Taxi to Position via|"))

-- =================== APPROACH BRIEFING ==================
-- W eather highlites
-- A ircraft - Type of aircraft and engines
-- N otams - highlite 
-- N oise abatement proc
-- R outing  STAR brief alt constraints, speeds, msa ... frequencies
-- T axi Taxiroute
-- A utomation AFDS LNAV/VNAV or other
-- M iscellaneous - any specialities and other non mentioned items of intereset	

local appbrief = kcPreferenceGroup:new("appbrief","APPROACH BRIEFING")
-- appbrief:setInitialOpen(true)
appbrief:add(kcPreference:new("appbrief_general",
function () 
	return kc_arr_brief_general()
end,
kcPreference.typeInfo,"For the approach brief...|"))

appbrief:add(kcPreference:new("appbrief_route",
function () 
	return kc_arr_brief_route()
end,
kcPreference.typeInfo,"Approach Route|"))

appbrief:add(kcPreference:new("appbrief_ground",
function () 
	return kc_arr_brief_ground()
end,
kcPreference.typeInfo,"Taxi|"))

-- Briefing setup
activeBriefings:addGroup(information)
activeBriefings:addGroup(flight)
activeBriefings:addGroup(taxi)
activeBriefings:addGroup(departure)
activeBriefings:addGroup(takeoff)
activeBriefings:addGroup(depBriefing)
activeBriefings:addGroup(arrival)
activeBriefings:addGroup(approach)
activeBriefings:addGroup(appbrief)

function getActiveBriefings()
	return activeBriefings
end

return defaultBriefings
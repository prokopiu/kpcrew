-- Definitions, functions and UI for the KPCrew Briefing window.
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

activeBriefings = kcPreferenceSet:new("BRIEFINGS")
activeBriefings:setFilename("briefings")

if kc_show_cost_index == nil then
	kc_show_cost_index 	= true
end
if kc_show_load_button == nil then
	kc_show_load_button = true
end
if kc_show_fmc_buttons == nil then
	kc_show_fmc_buttons = true
end
if kc_show_arr_atis_button == nil then
	kc_show_arr_atis_button = true
end
if kc_type_airbus == nil then
	kc_type_airbus = false
end
if kc_type_boeing == nil then
	kc_type_boeing = false
end

-- departure procedure types
kc_DEP_proctype_list 	= "SID|VECTORS|TRACKING"
-- Noise Abatement departure Procedure
kc_DEP_nadp_list 		= "NOT REQUIRED|SEE SID"
-- runway states
kc_DEP_rwystate_list 	= "DRY|WET|CONTAMINATED"
-- parking position options
kc_DEP_gatestand_list	= "GATE (PUSH)|STAND (PUSH)|STAND (NO PUSH)"
-- push direction
kc_DEP_push_direction 	= "NO PUSH|NOSE LEFT|NOSE RIGHT|NOSE STRAIGHT|FACING NORTH|FACING SOUTH|FACING EAST|FACING WEST"
-- forced return overweight or underweight
kc_DEP_forced_return 	= "UNDERWEIGHT|OVERWEIGHT"

-- runway state arrival
kc_APP_rwystate_list 	= "DRY|WET|CONT"
-- arrival procedure type list 
kc_APP_proctype_list 	= "STAR|VECTORS"
-- Noise Abatement on arrival
kc_APP_na_list 			= "NOT REQUIRED|SEE STAR"
-- parking position options
kc_APP_gatestand_list 	= "GATE|STAND|STAND PUSH-IN"
-- power at gate
kc_APP_power_at_stand 	= "CONNECT|NO POWER"

kc_WX_Precipitation_list = "NONE|DRIZZLE|LIGHT RAIN|RAIN|HEAVY RAIN|SNOW"
kc_WX_Cloud_list 		= "NO|FEW|SCATTERED|BROKEN|OVERCAST"

-- load aircraft specific briefing values and functions
require("kpcrew.briefings.briefings_" .. kc_acf_icao)
if kc_simversion > 120000 then
require("kpcrew.metargen")
end

local http 				= require("socket.http")
local metar 			= require("kpcrew.metar")
local xml2lua 			= require("kpcrew.xml2lua")
local handler 			= require("kpcrew.xmlhandler.tree")

local DataOfp = {}

-- =================== FLIGHT DATA ==================
local flight = kcPreferenceGroup:new("flight","FLIGHT")
flight:add(kcPreference:new("firstFlightDay",1,kcPreference.typeList,"First Flight of the Day|First Flight|Not First Flight"))
flight:add(kcPreference:new("simbrief",0,kcPreference.typeExecButton,"Simbrief Data Load|Fetch SIMBRIEF|kc_download_simbrief()"))
flight:add(kcPreference:new("callsign","",kcPreference.typeText,"ATC Callsign|"))
flight:add(kcPreference:new("flightnumber","",kcPreference.typeText,"Flight Number|"))
flight:add(kcPreference:new("airline"," ",kcPreference.typeText,"Airline|"))
flight:add(kcPreference:new("originIcao","",kcPreference.typeText,"*Origin ICAO|"))
flight:add(kcPreference:new("originIata","",kcPreference.typeText,"*Origin IATA|"))
flight:add(kcPreference:new("originName","",kcPreference.typeText,"*Origin Name|"))
flight:add(kcPreference:new("destinationIcao","",kcPreference.typeText,"*Destination ICAO|"))
flight:add(kcPreference:new("destinationIata","",kcPreference.typeText,"*Destination IATA|"))
flight:add(kcPreference:new("destinationName","",kcPreference.typeText,"*Destination Name|"))
flight:add(kcPreference:new("alternateIcao","",kcPreference.typeText,"Alternate ICAO|"))
flight:add(kcPreference:new("alternateIata","",kcPreference.typeText,"Alternate IATA|"))
flight:add(kcPreference:new("alternateName","",kcPreference.typeText,"Alternate Name|"))
flight:add(kcPreference:new("route","",kcPreference.typeText,"Route|"))
flight:add(kcPreference:new("planrwy","",kcPreference.typeText,"Plan RWY|"))
flight:add(kcPreference:new("destrwy","",kcPreference.typeText,"Destination RWY|"))
flight:add(kcPreference:new("altnrwy","",kcPreference.typeText,"Alternate RWY|"))
flight:add(kcPreference:new("costIndex",0,kcPreference.typeInt,"Cost Index|1"))
flight:add(kcPreference:new("airdistance",0,kcPreference.typeInt,"Air Distance from OFP (nm)|10"))
flight:add(kcPreference:new("routedistance",0,kcPreference.typeInt,"Route Distance from OFP (nm)|10"))
flight:add(kcPreference:new("cruiseLevel",0,kcPreference.typeInt,"*Cruise Level (FL)|10"))
flight:add(kcPreference:new("tropopause",0,kcPreference.typeInt,"Tropopause|10"))
flight:add(kcPreference:new("averageWind","",kcPreference.typeText,"Average Wind (999/99)|"))
flight:add(kcPreference:new("averageWC",0,kcPreference.typeInt,"Average Wind Component|1"))
flight:add(kcPreference:new("averageISA",0,kcPreference.typeInt,"Average ISA|1"))
flight:add(kcPreference:new("tripFuel",0,kcPreference.typeInt,"TripFuel|1"))
flight:add(kcPreference:new("minimumTakeoff",0,kcPreference.typeInt,"Minimum Takeoff Fuel|1"))
flight:add(kcPreference:new("reserve",0,kcPreference.typeInt,"Reserve Fuel|1"))
flight:add(kcPreference:new("reserveTime",0,kcPreference.typeInfo,"Reserve Time|"))
flight:add(kcPreference:new("alternateBurn",0,kcPreference.typeInt,"Alternate Burn|1"))
flight:add(kcPreference:new("averageFF",0,kcPreference.typeInt,"Average Fuel Flow|1"))
flight:add(kcPreference:new("cargoWeight",0,kcPreference.typeInt,"Cargo Weight|1"))
flight:add(kcPreference:new("payload",0,kcPreference.typeInt,"Payload|1"))
flight:add(kcPreference:new("zfw",0,kcPreference.typeInt,"ZFW|1"))
flight:add(kcPreference:new("tow",0,kcPreference.typeInt,"TOW|1"))
flight:add(kcPreference:new("ldw",0,kcPreference.typeInt,"LDW|1"))
flight:add(kcPreference:new("maxzfw",0,kcPreference.typeInt,"maxZFW|1"))
flight:add(kcPreference:new("maxtow",0,kcPreference.typeInt,"maxTOW|1"))
flight:add(kcPreference:new("maxldw",0,kcPreference.typeInt,"MaxLDW|1"))
flight:add(kcPreference:new("takeoffFuel",0,kcPreference.typeInt,"TAKEOFFFUEL|1"))
flight:add(kcPreference:new("fuelplanldg",0,kcPreference.typeInt,"Fuel Plan Ldg|1"))
flight:add(kcPreference:new("depdate","",kcPreference.typeInfo,"Departure Date|"))
flight:add(kcPreference:new("deptime","",kcPreference.typeInfo,"Departure Time|"))
flight:add(kcPreference:new("arrtime","",kcPreference.typeInfo,"Arrival Time|"))
flight:add(kcPreference:new("airtime","",kcPreference.typeInfo,"Air Time|"))
flight:add(kcPreference:new("taxiouttime","",kcPreference.typeInfo,"Taxi out|"))
flight:add(kcPreference:new("taxiintime","",kcPreference.typeInfo,"Taxi in|"))
flight:add(kcPreference:new("estairtime","",kcPreference.typeInfo,"Air Time|"))
flight:add(kcPreference:new("estdeptime","",kcPreference.typeInfo,"Est Departure Time|"))
flight:add(kcPreference:new("estarrtime","",kcPreference.typeInfo,"Est Arrival Time|"))
flight:add(kcPreference:new("blocktime","",kcPreference.typeInfo,"Block Time|"))
flight:add(kcPreference:new("estblocktime","",kcPreference.typeInfo,"Est Block Time|"))
flight:add(kcPreference:new("deptimezone","",kcPreference.typeInt,"Timezone Dep|"))
flight:add(kcPreference:new("arrtimezone","",kcPreference.typeInt,"Timezone Arr|"))
flight:add(kcPreference:new("cruiseprofile","",kcPreference.typeInfo,"Cruise profile|"))
flight:add(kcPreference:new("cruisemach","",kcPreference.typeInfo,"Cruise mach|"))
flight:add(kcPreference:new("cruisetas","",kcPreference.typeInfo,"Cruise tas|"))
flight:add(kcPreference:new("climbprofile","",kcPreference.typeInfo,"Climb profile|"))
flight:add(kcPreference:new("descentprofile","",kcPreference.typeInfo,"Descent profile|"))
flight:add(kcPreference:new("stepclimb","",kcPreference.typeInfo,"Stepclimb|"))
flight:add(kcPreference:new("paxcount","",kcPreference.typeInfo,"PAX Count|"))
flight:add(kcPreference:new("paxweight","",kcPreference.typeInfo,"PAX Weight|"))
flight:add(kcPreference:new("rampweight","",kcPreference.typeInfo,"est ramp weight|"))
flight:add(kcPreference:new("mindiversion","",kcPreference.typeInfo,"min div fuel|"))
flight:add(kcPreference:new("conttime","",kcPreference.typeInfo,"cont time|"))
flight:add(kcPreference:new("altnete","",kcPreference.typeInfo,"Alternate ETE|"))
flight:add(kcPreference:new("taxifuel","",kcPreference.typeInfo,"Taxi Fuel|"))
flight:add(kcPreference:new("endurance","",kcPreference.typeInfo,"Endurance|"))
flight:add(kcPreference:new("extrafuel","",kcPreference.typeInfo,"Extrafuel|"))
flight:add(kcPreference:new("extratime","",kcPreference.typeInfo,"Extra Time|"))
flight:add(kcPreference:new("planblockfuel","",kcPreference.typeInfo,"Plan block Fuel|"))
flight:add(kcPreference:new("planblocktime","",kcPreference.typeInfo,"Plan block time|"))
flight:add(kcPreference:new("pilotextra","",kcPreference.typeInt,"Pilot extra|10"))
flight:add(kcPreference:new("notes","",kcPreference.typeText,"Notes|"))

-- =================== DEPARTURE ==================
local departure = kcPreferenceGroup:new("departure","DEPARTURE ATIS")
departure:add(kcPreference:new("atisORIG","",kcPreference.typeInfo,"ATIS|"))
departure:add(kcPreference:new("atisQNH",1013,kcPreference.typeInt,"*ATIS QNH|"))
departure:add(kcPreference:new("atisQNHA",2992,kcPreference.typeInt,"*ATIS QNH HG|"))
departure:add(kcPreference:new("squawk",2000,kcPreference.typeInt,"XPDR SQUAWK|1"))
departure:add(kcPreference:new("transalt",0,kcPreference.typeInt,"*Transition Altitude (ft)|100"))
departure:add(kcPreference:new("rwy","",kcPreference.typeText,"Departure Runway|"))
departure:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. kc_DEP_rwystate_list))
departure:add(kcPreference:new("initAlt",4900,kcPreference.typeInt,"*Initial Altitude (ft)|100"))
departure:add(kcPreference:new("initHeading",0,kcPreference.typeInt,"*Initial Heading|1"))
departure:add(kcPreference:new("deptype",1,kcPreference.typeList,"Departure Type|" .. kc_DEP_proctype_list))
departure:add(kcPreference:new("deproute","",kcPreference.typeText,"Departure Route|"))
departure:add(kcPreference:new("deptransition","",kcPreference.typeText,"Departure Transition|"))
departure:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"NAV1 CRS|10"))
departure:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))
departure:add(kcPreference:new("decision",200,kcPreference.typeInt,"Decision Height/Altitude|10"))
departure:add(kcPreference:new("aptElevation",0,kcPreference.typeInt,"depAirport Elevation|100"))
departure:add(kcPreference:new("activateAPUPowerUp",2,kcPreference.typeList,"Power Up with APU|Start APU|APU remains off"))
-- ATC Frequencies stored
departure:add(kcPreference:new("atisFreq","122.800",kcPreference.typeText,"ATIS"))
departure:add(kcPreference:new("clearanceFreq","122.800",kcPreference.typeText,"DEL"))
departure:add(kcPreference:new("groundFreq","122.800",kcPreference.typeText,"GROUND"))
departure:add(kcPreference:new("towerFreq","122.800",kcPreference.typeText,"TOWER"))
departure:add(kcPreference:new("departureFreq","122.800",kcPreference.typeText,"DEPARTURE"))
departure:add(kcPreference:new("center1Freq","122.800",kcPreference.typeText,"Center1"))
departure:add(kcPreference:new("center2Freq","122.800",kcPreference.typeText,"Center2"))


-- =================== TAXI BRIEFING ==================
local taxi = kcPreferenceGroup:new("taxi","TAXI DETAILS")
taxi:add(kcPreference:new("parkingStand","",kcPreference.typeText,"Parking Stand|"))
taxi:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. kc_DEP_gatestand_list))
taxi:add(kcPreference:new("pushDirection",1,kcPreference.typeList,"Push Direction|" .. kc_DEP_push_direction))
taxi:add(kcPreference:new("startSequence",2,kcPreference.typeList,"*Start Sequence|" .. kc_StartSequence))
taxi:add(kcPreference:new("taxiRoute","",kcPreference.typeText,"Taxi Route|"))

-- =================== TAKEOFF ==================
local takeoff = kcPreferenceGroup:new("takeoff","DEPARTURE TAKEOFF")
takeoff:add(kcPreference:new("thrust",1,kcPreference.typeList,"T/O Thrust|" .. kc_TakeoffThrust))
takeoff:add(kcPreference:new("flextemp",0,kcPreference.typeInt,"*Flextemp"))
takeoff:add(kcPreference:new("antiice",1,kcPreference.typeList,"*T/O Anti Ice|" .. kc_TakeoffAntiice))
takeoff:add(kcPreference:new("packs",1,kcPreference.typeList,"*T/O Packs|" .. kc_TakeoffPacks))
takeoff:add(kcPreference:new("bleeds",1,kcPreference.typeList,"*T/O Bleed Settings|" .. kc_TakeoffBleeds))
takeoff:add(kcPreference:new("elevatorTrim",0,kcPreference.typeFloat,"*Elevator Trim|0.1|%4.2f"))
takeoff:add(kcPreference:new("rudderTrim",0,kcPreference.typeFloat,"*Rudder Trim|0.1|%4.2f"))
takeoff:add(kcPreference:new("aileronTrim",0,kcPreference.typeFloat,"*Aileron Trim|0.1|%4.2f"))
takeoff:add(kcPreference:new("flaps",1,kcPreference.typeList,"*T/O Flaps|" .. kc_TakeoffFlaps))
takeoff:add(kcPreference:new("forcedReturn",1,kcPreference.typeList,"Forced Return|" .. kc_DEP_forced_return))
takeoff:add(kcPreference:new("msa",0,kcPreference.typeInt,"Departure MSA (ft)|100"))
takeoff:add(kcPreference:new("v1",0,kcPreference.typeInt,"*V1|1"))
takeoff:add(kcPreference:new("vr",0,kcPreference.typeInt,"*VR|1"))
takeoff:add(kcPreference:new("v2",250,kcPreference.typeInt,"*V2|1"))
takeoff:add(kcPreference:new("hw",0,kcPreference.typeInt,"*Headwind"))
takeoff:add(kcPreference:new("cw",0,kcPreference.typeInt,"*Crosswind"))
takeoff:add(kcPreference:new("tora",0,kcPreference.typeInt,"*TORA"))
takeoff:add(kcPreference:new("rwylength",0,kcPreference.typeInt,"*RWYLENGTH"))
takeoff:add(kcPreference:new("apMode",1,kcPreference.typeList,"*Autopilot Modes|" .. kc_TakeoffApModes))

-- =================== ARRIVAL ==================
local arrival = kcPreferenceGroup:new("arrival","ARRIVAL")
arrival:add(kcPreference:new("atisQNH",1013,kcPreference.typeInt,"*ATIS QNH|"))
arrival:add(kcPreference:new("atisQNHA",2992,kcPreference.typeInt,"*ATIS QNHA|"))
arrival:add(kcPreference:new("altnatisQNH",1013,kcPreference.typeInt,"*Alternate ATIS QNH|"))
arrival:add(kcPreference:new("altnatisQNHA",2992,kcPreference.typeInt,"*Alternate ATIS QNHA|"))
arrival:add(kcPreference:new("atisDEST","",kcPreference.typeInfo,"ATIS|"))
arrival:add(kcPreference:new("atisALTN","",kcPreference.typeInfo,"ATIS|"))
arrival:add(kcPreference:new("translvl",activePrefSet:get("general:def_trans_lvl"),kcPreference.typeInt,"arrTransition Level(FL)|100"))
arrival:add(kcPreference:new("transalt",activePrefSet:get("general:def_trans_alt"),kcPreference.typeInt,"arrTransition Altitude (ft)|100"))
arrival:add(kcPreference:new("alttranslvl",activePrefSet:get("general:def_trans_lvl"),kcPreference.typeInt,"Transition Level(FL)|100"))
arrival:add(kcPreference:new("arrType",1,kcPreference.typeList,"Arrival Type|" .. kc_APP_proctype_list))
arrival:add(kcPreference:new("altnarrType",1,kcPreference.typeList,"Alternate Arrival Type|" .. kc_APP_proctype_list))
arrival:add(kcPreference:new("arrroute","",kcPreference.typeText,"Arrival Route|"))
arrival:add(kcPreference:new("altnarrroute","",kcPreference.typeText,"Alternate Arrival Route|"))
arrival:add(kcPreference:new("arrtransition","",kcPreference.typeText,"Arrival Transition|"))
arrival:add(kcPreference:new("altnarrtransition","",kcPreference.typeText,"Alternate Arrival Transition|"))
arrival:add(kcPreference:new("msa",0,kcPreference.typeInt,"Arrival MSA (ft)|100"))
arrival:add(kcPreference:new("aptElevation",0,kcPreference.typeInt,"*Airport Elevation (ft)|100"))
arrival:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. kc_APP_rwystate_list))
arrival:add(kcPreference:new("altnrwyCond",1,kcPreference.typeList,"Alternate Runway Condition|" .. kc_APP_rwystate_list))
arrival:add(kcPreference:new("altnElevation",0,kcPreference.typeInt,"alternate Elevation|100"))
-- Arrival ATC Frequencies store
arrival:add(kcPreference:new("atisFreq","122.800",kcPreference.typeText,"ATIS"))
arrival:add(kcPreference:new("approachFreq","122.800",kcPreference.typeText,"APPROACH"))
arrival:add(kcPreference:new("towerFreq","122.800",kcPreference.typeText,"Tower"))
arrival:add(kcPreference:new("groundFreq","122.800",kcPreference.typeText,"GROUND"))

-- =================== APPROACH ==================
local approach = kcPreferenceGroup:new("approach","APPROACH DATA")
approach:add(kcPreference:new("appType",1,kcPreference.typeList,"Expect Approach|" .. kc_apptypes))
approach:add(kcPreference:new("altnappType",1,kcPreference.typeList,"alternate Expect Approach|" .. kc_apptypes))
approach:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"*NAV1 CRS|10"))
approach:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))
approach:add(kcPreference:new("nav1Freq","",kcPreference.typeText,"ILS Frequency"))
approach:add(kcPreference:new("altnnav1Course",0,kcPreference.typeInt,"Altn NAV1 CRS|10"))
approach:add(kcPreference:new("altnnav2Course",0,kcPreference.typeInt,"Altn NAV2 CRS|10"))
approach:add(kcPreference:new("altnnav1Freq","---.--",kcPreference.typeText,"ILS Frequency"))
approach:add(kcPreference:new("fafAltitude",0,kcPreference.typeInt,"FAF Altitude (ft)|100"))
approach:add(kcPreference:new("altnfafAltitude",0,kcPreference.typeInt,"Altn FAF Altitude (ft)|100"))
approach:add(kcPreference:new("decision",0,kcPreference.typeInt,"*Decision Height|10"))
approach:add(kcPreference:new("minimums",0,kcPreference.typeInt,"*Decision Altitude|10"))
approach:add(kcPreference:new("altndecision",0,kcPreference.typeInt,"*altn Decision Height|10"))
approach:add(kcPreference:new("altnminimums",0,kcPreference.typeInt,"*altn Decision Altitude|10"))
approach:add(kcPreference:new("gaheading",0,kcPreference.typeInt,"Go-Around Heading|10"))
approach:add(kcPreference:new("gaaltitude",0,kcPreference.typeInt,"Go-Around Altitude|100"))
approach:add(kcPreference:new("altngaheading",0,kcPreference.typeInt,"altn Go-Around Heading|10"))
approach:add(kcPreference:new("altngaaltitude",0,kcPreference.typeInt,"altn Go-Around Altitude|100"))
approach:add(kcPreference:new("flaps",0,kcPreference.typeList,"*Landing Flaps|" .. kc_LandingFlaps))
approach:add(kcPreference:new("altnflaps",1,kcPreference.typeList,"*Landing Flaps|" .. kc_LandingFlaps))
approach:add(kcPreference:new("vref",0,kcPreference.typeInt,"*Vref|1"))
approach:add(kcPreference:new("altnvref",0,kcPreference.typeInt,"*altn Vref|1"))
approach:add(kcPreference:new("vapp",0,kcPreference.typeInt,"*altnVapp|1"))
approach:add(kcPreference:new("altnvapp",0,kcPreference.typeInt,"*Vapp|1"))
approach:add(kcPreference:new("autobrake",1,kcPreference.typeList,"*Autobrake|" .. kc_LandingAutoBrake))
approach:add(kcPreference:new("altnautobrake",1,kcPreference.typeList,"Altn Autobrake|" .. kc_LandingAutoBrake))
approach:add(kcPreference:new("packs",1,kcPreference.typeList,"*Packs|" .. kc_LandingPacks))
approach:add(kcPreference:new("altnpacks",1,kcPreference.typeList,"Altn Packs|" .. kc_LandingPacks))
approach:add(kcPreference:new("antiice",1,kcPreference.typeList,"*Anti Ice|" .. kc_LandingAntiice))
approach:add(kcPreference:new("altnantiice",1,kcPreference.typeList,"Altn Anti Ice|" .. kc_LandingAntiice))
approach:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. kc_APP_gatestand_list))
approach:add(kcPreference:new("parkingPosition","",kcPreference.typeText,"Parking Position|"))
approach:add(kcPreference:new("altngateStand",1,kcPreference.typeList,"Altn Gate/Stand|" .. kc_APP_gatestand_list))
approach:add(kcPreference:new("altnparkingPosition","",kcPreference.typeText,"AltnParking Position|"))
approach:add(kcPreference:new("powerAtGate",2,kcPreference.typeList,"External Power at Stand|" .. kc_APP_power_at_stand))
approach:add(kcPreference:new("activateAPUafterLand",1,kcPreference.typeList,"*Start APU after Landing|Start APU|APU remains off"))
approach:add(kcPreference:new("taxiIn","",kcPreference.typeText,"Taxi to Position via|"))
approach:add(kcPreference:new("altntaxiIn","",kcPreference.typeText,"Altn Taxi to Position via|"))
approach:add(kcPreference:new("lda",0,kcPreference.typeInt,"*LDA"))
approach:add(kcPreference:new("rwylength",0,kcPreference.typeInt,"*RWYLENGTH LAND"))
approach:add(kcPreference:new("hw",0,kcPreference.typeInt,"*HeadwindA"))
approach:add(kcPreference:new("cw",0,kcPreference.typeInt,"*CrosswindA"))

-- Briefing setup
activeBriefings:addGroup(information)
activeBriefings:addGroup(flight)
activeBriefings:addGroup(taxi)
activeBriefings:addGroup(departure)
activeBriefings:addGroup(takeoff)
activeBriefings:addGroup(arrival)
activeBriefings:addGroup(approach)

function getActiveBriefings()
	return activeBriefings
end

return defaultBriefings
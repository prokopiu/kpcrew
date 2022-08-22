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
-- parking positin options
local DEP_gatestand_list = "GATE (PUSH)|STAND (PUSH)|STAND (NO PUSH)"
-- push direction
local DEP_push_direction = "NO PUSH|NOSE LEFT|NOSE RIGHT|NOSE STRAIGHT|FACING NORTH|FACING SOUTH|FACING EAST|FACING WEST"
-- forced return overweight or underweight
local DEP_forced_return = "UNDERWEIGHT|OVERWEIGHT"

-- runway state arrival
local APP_rwystate_list = "DRY|WET|CONTAMINATED"
-- arrival procedure type list 
local APP_proctype_list = "STAR|VECTORS"
-- Noise Abatement on arrival
local APP_na_list = "NOT REQUIRED|SEE STAR"
-- parking position options
local APP_gatestand_list = "GATE|STAND|STAND PUSH-IN REQUIRED"
-- power at gate
local APP_power_at_stand = "EXTERNAL POWER|NO POWER"

local WX_Precipitation_list = "NONE|DRIZZLE|LIGHT RAIN|RAIN|HEAVY RAIN|SNOW"
local WX_Cloud_list = "NO|FEW|SCATTERED|BROKEN|OVERCAST"

-- ============== Information =============

local information = kcPreferenceGroup:new("information","INFORMATION")
information:setInitialOpen(true)
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
flight:add(kcPreference:new("melIssues",1,kcPreference.typeList,"Minimum Equipment List issues|" .. kc_MELIssues))

-- =================== DEPARTURE ==================
local departure = kcPreferenceGroup:new("departure","DEPARTURE")
-- departure:setInitialOpen(true)
departure:add(kcPreference:new("AtisFrequency1",122.800,kcPreference.typeCOMFreq,"ATIS Frequency|"))
departure:add(kcPreference:new("atisInfo","",kcPreference.typeText,"ATIS Information|"))
departure:add(kcPreference:new("clrFrequency",122.800,kcPreference.typeCOMFreq,"Clearance Frequency|"))
departure:add(kcPreference:new("type",1,kcPreference.typeList,"Departure Type|" .. DEP_proctype_list))
departure:add(kcPreference:new("route","",kcPreference.typeText,"Departure Route|"))
departure:add(kcPreference:new("transition","",kcPreference.typeText,"Departure Transition|"))
departure:add(kcPreference:new("depNADP",1,kcPreference.typeList,"NADP|" .. DEP_nadp_list))
departure:add(kcPreference:new("initAlt",4900,kcPreference.typeInt,"Initial Altitude (ft)|100"))
departure:add(kcPreference:new("transalt",activePrefSet:get("general:def_trans_alt"),kcPreference.typeInt,"Transition Altitude (ft)|100"))
departure:add(kcPreference:new("rwy","",kcPreference.typeText,"Departure Runway|"))
departure:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. DEP_rwystate_list))
departure:add(kcPreference:new("squawk","",kcPreference.typeText,"XPDR SQUAWK|"))
departure:add(kcPreference:new("depFrequency",122.800,kcPreference.typeCOMFreq,"Departure Frequency|"))
departure:add(kcPreference:new("initHeading",0,kcPreference.typeInt,"Initial Heading|1"))

-- =================== TAXIING BRIEFING ==================
local taxi = kcPreferenceGroup:new("taxi","TAXI BRIEFING")
-- taxi:setInitialOpen(true)
taxi:add(kcPreference:new("gndFrequency1",122.800,kcPreference.typeCOMFreq,"Ground Frequency|"))
taxi:add(kcPreference:new("towerFrequency1",122.800,kcPreference.typeCOMFreq,"Tower Frequency|"))
taxi:add(kcPreference:new("parkingStand","",kcPreference.typeText,"Parking Stand|"))
taxi:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. DEP_gatestand_list))
taxi:add(kcPreference:new("pushDirection",1,kcPreference.typeList,"Push Direction|" .. DEP_push_direction))
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
	local briefing = "OK, I will be the pilot flying\n"
-- [W] eather highlites
	briefing = briefing .. "We are located at " .. activeBriefings:get("flight:originIcao") .. " parking stand " .. activeBriefings:get("taxi:parkingStand") .. "\n"
    briefing = briefing .. "We have ATIS information " .. activeBriefings:get("departure:atisInfo") .. " The weather is " .. kc_buildAtisString() .. "\n\n"

-- [A] ircraft
    briefing = briefing .. "Today we are flying in a " .. kc_acf_name .. " with <engine and aircraft details from CDU>, we have " .. kc_split(kc_MELIssues,"|")[activeBriefings:get("flight:melIssues")] .. " today" .. "\n\n"

-- [N] otams - highlite 
    briefing = briefing .. "NOTAMs highlites if there are any <may also include VATSIM/IVAO details etc>" .. "\n\n"

-- [N] oise abatement proc
	briefing = briefing .. "This will be a standard takeoff, noise abatement procedure " .. kc_split(DEP_nadp_list,"|")[activeBriefings:get("departure:depNADP")] .. "\n\n"

-- [A] utomation AFDS LNAV/VNAV or other
	
	return briefing
end,
kcPreference.typeInfo,"Ready for the departure briefing?|"))

depBriefing:add(kcPreference:new("taxibriefing",
function () 
-- [T] axi Taxiroute
	local xtaxiroute = ""
	if activeBriefings:get("taxi:gateStand") == 1 then
		xtaxiroute = "This is a gate position, pushback required " .. kc_split(DEP_push_direction,"|")[activeBriefings:get("taxi:pushDirection")] .. "\n"
	end
	if activeBriefings:get("taxi:gateStand") == 2 then
		xtaxiroute = "This is an outer position, pushback required " .. kc_split(DEP_push_direction,"|")[activeBriefings:get("taxi:pushDirection")] .. "\n"
	end
	if activeBriefings:get("taxi:gateStand") == 3 or activeBriefings:get("taxi:pushDirection") == 1 then
		xtaxiroute = "We require no pushback at this position, start clearance only\n"
	end
	-- briefing = briefing .. xtaxiroute
	xtaxiroute = xtaxiroute .. "We will be taxiing to holding point runway " .. activeBriefings:get("departure:rwy") .. " via "
	xtaxiroute = xtaxiroute .. activeBriefings:get("taxi:taxiRoute") .. "\n\n"

	return xtaxiroute
end,
kcPreference.typeInfo,"Taxi Briefing|"))

depBriefing:add(kcPreference:new("deproute",
function () 
-- [R] outing 
	local briefing = ""
	local xdep = ""
	if activeBriefings:get("departure:type") == 1 then
		xdep = "This will be a standard instrument departure via " .. activeBriefings:get("departure:route") .. " transition " .. activeBriefings:get("departure:transition") .. "\n"
	end
	if activeBriefings:get("departure:type") == 2 then
		xdep = "The departure will be ATC vectors\n"
	end
	if activeBriefings:get("departure:type") == 3 then
		xdep = "The departure will be via tracking\n"
	end
	briefing = briefing .. xdep 
	briefing = briefing .. "We will take off from runway " .. activeBriefings:get("departure:rwy")  .. ". Runway conditions are " .. kc_split(DEP_rwystate_list,"|")[activeBriefings:get("departure:rwyCond")] .. "\n"
	briefing = briefing .. "Initial altitude will be " .. activeBriefings:get("departure:initAlt") .. " ft. Today's cruise altitude will be FL " .. activeBriefings:get("flight:cruiseLevel") .. "\n" 
	briefing = briefing .. "Transition altitude is " .. activeBriefings:get("departure:transalt") .. " the initial heading is " .. activeBriefings:get("departure:initHeading") .. "\n"
	briefing = briefing .. "We will use Flaps " .. kc_split(kc_TakeoffFlaps,"|")[activeBriefings:get("takeoff:flaps")] .. " for takeoff\n"
	briefing = briefing .. "Our take off thrust is " .. kc_split(kc_TakeoffThrust,"|")[activeBriefings:get("takeoff:thrust")] .. " Anti Ice is " .. kc_split(kc_TakeoffAntiice,"|")[activeBriefings:get("takeoff:antiice")] .. ",bleeds will be " .. kc_split(kc_TakeoffBleeds,"|")[activeBriefings:get("takeoff:bleeds")] .. "\n"
	briefing = briefing .. "Minimum Safe Altitude along our initial route is ".. activeBriefings:get("takeoff:msa") .. "ft\n"
	briefing = briefing .. "In case of forced return we are ".. kc_split(DEP_forced_return,"|")[activeBriefings:get("takeoff:forcedReturn")] .. "\n"
	briefing = briefing .. "The takeoff speeds are set. V1 is ".. activeBriefings:get("takeoff:v1") .. ", Vr is " .. activeBriefings:get("takeoff:vr") .. " and V2 today " .. activeBriefings:get("takeoff:v2") .. "\n"
	briefing = briefing .. "<Brief the departure procedure from CDU and charts>" .. "\n\n"

	return briefing
end,
kcPreference.typeInfo,"Departure Route|"))

depBriefing:add(kcPreference:new("security brief",
function () 
	local briefing = ""
-- [M] iscellaneous
	briefing = briefing .. "For the security brief:\n"
	briefing = briefing .. "From 0 to 100 knots for any malfunction I will call reject and we will confirm the autobrakes are operating\n\n"
	briefing = briefing .. "If not operating I will apply maximum manual breaking and maximum symmetric reverse thrust and come to a full stop on the runway\n\n"
	briefing = briefing .. "After full stop on the runway we decide on course of further actions\n\n"
	briefing = briefing .. "From 100 knots to V1 I will reject only for one of the following reasons, engine fire, engine failure or takeoff configuration warning horn\n\n"
	briefing = briefing .. "At and above V1 we will continue into the air and the only actions for you below 400 feet are to silence any alarm bells and confirm any failures\n\n"
	briefing = briefing .. "Above 400 feet I will call for failure action drills as required and you'll perform memory items\n\n"
	briefing = briefing .. "At 800 feet above field elevation I will call for altitude hold and we will retract the flaps on schedule\n\n"
	briefing = briefing .. "At 1500 feet I will call for the checklist\n\n"
	briefing = briefing .. "If we are above maximum landing weight we will make decision on whether to perform an overweight landing if the situation requires\n\n"
	briefing = briefing .. "If we have a wheel well, engine or wing fire, I will turn the aircraft in such a way the flames will be downwind and we will evacuate through the upwind side\n\n"
	briefing = briefing .. "If we have a cargo fire you need to ensure emergency services do not open the cargo doors until evac is completed\n\n"
	briefing = briefing .. "Any questions or concerns?\n\n"
	
	return briefing
end,
kcPreference.typeInfo,"Security Briefing|"))

-- =================== TAKEOFF ==================
local takeoff = kcPreferenceGroup:new("takeoff","TAKEOFF")
-- takeoff:setInitialOpen(true)
takeoff:add(kcPreference:new("thrust",1,kcPreference.typeList,"T/O Thrust|" .. kc_TakeoffThrust))
takeoff:add(kcPreference:new("flaps",1,kcPreference.typeList,"T/O Flaps|" .. kc_TakeoffFlaps))
takeoff:add(kcPreference:new("antiice",1,kcPreference.typeList,"T/O Anti Ice|" .. kc_TakeoffAntiice))
takeoff:add(kcPreference:new("packs",1,kcPreference.typeList,"T/O Packs|" .. kc_TakeoffPacks))
takeoff:add(kcPreference:new("bleeds",1,kcPreference.typeList,"T/O Bleed Settings|" .. kc_TakeoffBleeds))
takeoff:add(kcPreference:new("msa",0,kcPreference.typeInt,"Departure MSA (ft)|100"))
takeoff:add(kcPreference:new("forcedReturn",1,kcPreference.typeList,"Forced Return|" .. DEP_forced_return))
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
arrival:add(kcPreference:new("appType",1,kcPreference.typeList,"Expect Approach|" .. kc_apptypes))
arrival:add(kcPreference:new("rwy","",kcPreference.typeText,"Arrival Runway|"))
arrival:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. APP_rwystate_list))
arrival:add(kcPreference:new("translvl",activePrefSet:get("general:def_trans_lvl"),kcPreference.typeInt,"Transition Level|100"))
arrival:add(kcPreference:new("atisWind","",kcPreference.typeText,"ATIS Wind HDG/SPD|"))
arrival:add(kcPreference:new("atisVisibility","",kcPreference.typeText,"ATIS Visibility km|"))
arrival:add(kcPreference:new("atisPrecipit",1,kcPreference.typeList,"ATIS Precipitation|" .. WX_Precipitation_list))
arrival:add(kcPreference:new("atisClouds",1,kcPreference.typeList,"ATIS Clouds|" .. WX_Cloud_list))
arrival:add(kcPreference:new("atisTemps","",kcPreference.typeText,"ATIS Temp/Dewpoint|"))
arrival:add(kcPreference:new("atisQNH","",kcPreference.typeText,"ATIS QNH|"))
arrival:add(kcPreference:new("arrType",1,kcPreference.typeList,"Arrival Type|" .. APP_proctype_list))
arrival:add(kcPreference:new("appFrequency",122.800,kcPreference.typeCOMFreq,"Approach Frequency|"))
arrival:add(kcPreference:new("route","",kcPreference.typeText,"Arrival Route|"))
arrival:add(kcPreference:new("transition","",kcPreference.typeText,"Arrival Transition|"))
arrival:add(kcPreference:new("arrNADP",1,kcPreference.typeList,"NADP|" .. APP_na_list))
arrival:add(kcPreference:new("msa",0,kcPreference.typeInt,"Arrival MSA (ft)|100"))
arrival:add(kcPreference:new("fafAltitude",0,kcPreference.typeInt,"FAF Altitude (ft)|100"))
arrival:add(kcPreference:new("decision",0,kcPreference.typeInt,"Decision Height/Altitude|10"))
arrival:add(kcPreference:new("aptElevation",0,kcPreference.typeInt,"Airport Elevation (ft)|100"))
arrival:add(kcPreference:new("gaHeading",0,kcPreference.typeInt,"Go-Around Heading|10"))
arrival:add(kcPreference:new("gaAltitude",0,kcPreference.typeInt,"Go-Around altitutde (ft)|100"))

-- =================== APPROACH ==================
local approach = kcPreferenceGroup:new("approach","APPROACH")
-- approach:setInitialOpen(true)
approach:add(kcPreference:new("twrFrequency2",122.800,kcPreference.typeCOMFreq,"Tower Frequency|"))
approach:add(kcPreference:new("gndFrequency2",122.800,kcPreference.typeCOMFreq,"Ground Frequency|"))
approach:add(kcPreference:new("nav1Frequency",109.000,kcPreference.typeNAVFreq,"NAV1/ILS Frequency|1"))
approach:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"NAV1 CRS|10"))
approach:add(kcPreference:new("nav2Frequency",109.000,kcPreference.typeNAVFreq,"NAV2 Frequency|2"))
approach:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))
approach:add(kcPreference:new("flaps",1,kcPreference.typeList,"Landing Flaps|" .. kc_LandingFlaps))
approach:add(kcPreference:new("vapp",0,kcPreference.typeInt,"Vapp|1"))
approach:add(kcPreference:new("vref",0,kcPreference.typeInt,"Vref|1"))
approach:add(kcPreference:new("autobrake",1,kcPreference.typeList,"Autobrake|" .. kc_LandingAutoBrake))
approach:add(kcPreference:new("packs",1,kcPreference.typeList,"Packs|" .. kc_LandingPacks))
approach:add(kcPreference:new("antiice",1,kcPreference.typeList,"Anti Ice|" .. kc_LandingAntiice))
approach:add(kcPreference:new("reversethrust",1,kcPreference.typeList,"Reverse Thrust|" .. APP_rev_thrust_list))
approach:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. APP_gatestand_list))
approach:add(kcPreference:new("parkingPosition","",kcPreference.typeText,"Parking Position|"))
approach:add(kcPreference:new("powerAtGate",1,kcPreference.typeList,"Power at Stand|" .. APP_power_at_stand))
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
appbrief:add(kcPreference:new("appbrief",
function () 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	local briefing = "OK, for the approach brief: \n"
-- [W] eather highlites
	briefing = briefing .. "Our destination today is " .. activeBriefings:get("flight:destinationIcao") .. "\n"
	briefing = briefing .. "The weather report is winds " .. activeBriefings:get("arrival:atisWind") .. "; visibility " .. activeBriefings:get("arrival:atisVisibility") .. 
		" km; precipitation " .. kc_split(WX_Precipitation_list,"|")[activeBriefings:get("arrival:atisPrecipit")] .. 
		"; clouds " .. kc_split(WX_Cloud_list,"|")[activeBriefings:get("arrival:atisClouds")] .. 
		"; the temperatures are " .. activeBriefings:get("arrival:atisTemps") .. "; QNH " .. activeBriefings:get("arrival:atisQNH").."\n\n" 

-- [A] ircraft
    briefing = briefing .. "Our current weight is " .. string.format("%6.6i %s",kc_get_gross_weight(),wunit) .. 
		" and fuel remaining " .. string.format("%6.6i %s",kc_get_total_fuel(),wunit) .. "\n"
    briefing = briefing .. "Vref for our approach is " .. activeBriefings:get("approach:vref") .. " kts and Vapp " .. activeBriefings:get("approach:vapp") ..  " kts\n\n"

-- [N] otams - highlite 
    briefing = briefing .. "NOTAMs highlites if there are any <may also include VATSIM/IVAO details etc" .. "\n\n"

-- [N] oise abatement proc
	briefing = briefing .. "Special noise abatement considerations: " .. kc_split(APP_na_list,"|")[activeBriefings:get("arrival:arrNADP")] .. "\n\n"

-- [A] utomation AFDS LNAV/VNAV or other
	
-- [R] outing 
	briefing = briefing .. "we will arrive at " .. activeBriefings:get("flight:destinationIcao") .. " via "
		if activeBriefings:get("arrival:arrType") == 1 then
			briefing = briefing .. "STAR " .. activeBriefings:get("arrival:route") .. " with transition " .. activeBriefings:get("arrival:transition") .."\n"
		else
			briefing = briefing .. "ATC vectors".."\n"
		end
	briefing = briefing .. "The MSA in our arrival sector is " .. activeBriefings:get("arrival:msa") .. " and the transition level today FL " .. activeBriefings:get("arrival:translvl").."\n"
	briefing = briefing .. "After the arrival we can expect an " .. kc_split(APP_apptype_list,"|")[activeBriefings:get("arrival:appType")] .. " approach".."\n"
	briefing = briefing .. "Runway assigned is " .. activeBriefings:get("arrival:rwy") .. " and the condition is " .. kc_split(APP_rwystate_list,"|")[activeBriefings:get("arrival:rwyCond")].."\n"
	briefing = briefing .. "Altitude at the FAF is " .. activeBriefings:get("arrival:fafAltitude") .. ", " .. (activePrefSet:get("aircraft:efis_mins_dh")==true and "DH" or "DA") .." will be " .. activeBriefings:get("arrival:decision").."\n"
	briefing = briefing .. "Airport elevation is " .. activeBriefings:get("arrival:aptElevation").."ft \n"
	briefing = briefing .. "We are going to use landing flaps " .. kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:flaps")] .. " and Autobrake " .. kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:autobrake")].."\n"
	briefing = briefing .. "Packs are set " .. kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:packs")] .. " and Anti Ice " .. kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:antiice")].."\n"
	briefing = briefing .. kc_split(APP_rev_thrust_list,"|")[activeBriefings:get("approach:reversethrust")] .. " reverse thrust applied" .. "\n"
	briefing = briefing .. "<Brief the arrival procedure from CDU and charts" .. "\n\n"

-- [T] axi Taxiroute
    briefing = briefing .. "As to our taxi route after arrival: \n" 	
	briefing = briefing .. "We will be taxiing to our position " .. activeBriefings:get("approach:parkingPosition") .. " via "
	briefing = briefing .. activeBriefings:get("approach:taxiIn") .. "\n"
	local xtaxiroute = ""
	if activeBriefings:get("approach:gateStand") == 1 then
		xtaxiroute = "This is a gate position " .. "\n"
	end
	if activeBriefings:get("approach:gateStand") == 2 then
		xtaxiroute = "This is an outer position" .. "\n"
	end
	if activeBriefings:get("approach:gateStand") == 3 then
		xtaxiroute = "The position requires a push-in\n"
	end
	briefing = briefing .. xtaxiroute
	briefing = briefing .. "At the stand " .. kc_split(APP_power_at_stand,"|")[activeBriefings:get("approach:powerAtGate")] .. " available.\n"
	briefing = briefing .. "Any questions or concerns?"
	
-- [M] iscellaneous
	
	return briefing
end,
kcPreference.typeInfo,"For the approach brief...|"))


-- Briefing setup
activeBriefings:addGroup(information)
activeBriefings:addGroup(flight)
activeBriefings:addGroup(departure)
activeBriefings:addGroup(taxi)
activeBriefings:addGroup(takeoff)
activeBriefings:addGroup(depBriefing)
-- activeBriefings:addGroup(tobrief)
activeBriefings:addGroup(arrival)
activeBriefings:addGroup(approach)
activeBriefings:addGroup(appbrief)

function getActiveBriefings()
	return activeBriefings
end

return defaultBriefings
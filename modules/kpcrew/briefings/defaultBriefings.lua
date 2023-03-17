-- Definitions, functions and UI for the KPCrew Briefing window.
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
activeBriefings = kcPreferenceSet:new("BRIEFINGS")
activeBriefings:setFilename("briefings")

-- departure procedure types
kc_DEP_proctype_list 	= "SID|VECTORS|TRACKING"
-- Noise Abatement departure Procedure
kc_DEP_nadp_list 		= "NOT REQUIRED|SEE SID"
-- runway states
kc_DEP_rwystate_list 	= "DRY|WET|CONTAMINATED"
-- parking positin options
kc_DEP_gatestand_list	= "GATE (PUSH)|STAND (PUSH)|STAND (NO PUSH)"
-- push direction
kc_DEP_push_direction 	= "NO PUSH|NOSE LEFT|NOSE RIGHT|NOSE STRAIGHT|FACING NORTH|FACING SOUTH|FACING EAST|FACING WEST"
-- forced return overweight or underweight
kc_DEP_forced_return 	= "UNDERWEIGHT|OVERWEIGHT"

-- runway state arrival
kc_APP_rwystate_list 	= "DRY|WET|CONTAMINATED"
-- arrival procedure type list 
kc_APP_proctype_list 	= "STAR|VECTORS"
-- Noise Abatement on arrival
kc_APP_na_list 			= "NOT REQUIRED|SEE STAR"
-- parking position options
kc_APP_gatestand_list 	= "GATE|STAND|STAND PUSH-IN REQUIRED"
-- power at gate
kc_APP_power_at_stand 	= "EXTERNAL POWER|NO POWER"

kc_WX_Precipitation_list = "NONE|DRIZZLE|LIGHT RAIN|RAIN|HEAVY RAIN|SNOW"
kc_WX_Cloud_list 		= "NO|FEW|SCATTERED|BROKEN|OVERCAST"

-- load aircraft specific briefing values and functions
require("kpcrew.briefings.briefings_" .. kc_acf_icao)
local http 				= require("socket.http")
local metar 			= require("kpcrew.metar")
local xml2lua 			= require("kpcrew.xml2lua")
local handler 			= require("kpcrew.xmlhandler.tree")

local DataOfp = {}

kc_metar_read 			= 0
kc_metar_local 			= ""
kc_metar_dest 			= ""
kc_metar_altn			= ""
kc_metardata_local 		= nil
kc_metardata_dest 		= nil

-- Send request via HTTP to Simbrief server and fill in briefing values
function kc_download_simbrief()
	-- user must have set his simbrief userid/name in preferences
	if activePrefSet:get("general:simbriefuser") ~= nil and activePrefSet:get("general:simbriefuser") ~= " " then
		local webResponse, webStatus = http.request("http://www.simbrief.com/api/xml.fetcher.php?username=" .. activePrefSet:get("general:simbriefuser"))
		logMsg(webResponse)
		if webStatus == 200 then
			local f = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\simbrief.xml", "w+")
			f:write(webResponse)
			f:close()
		end
		-- latest OFP gets stored in kpcrew_prefs folder as simbrief.xml
		local xmlfile = xml2lua.loadFile(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\simbrief.xml")
		local parser = xml2lua.parser(handler)
		parser:parse(xmlfile)

		-- initialize OFP record and scan the downloaded XML file
		DataOfp["Status"] = handler.root.OFP.fetch.status

		if DataOfp["Status"] == "Success" then
			activeBriefings:set("flight:callsign",handler.root.OFP.atc.callsign)
			activeBriefings:set("flight:originIcao",handler.root.OFP.origin.icao_code)
			activeBriefings:set("flight:destinationIcao",handler.root.OFP.destination.icao_code)
			activeBriefings:set("flight:alternateIcao",handler.root.OFP.alternate.icao_code)
			activeBriefings:set("flight:costIndex",handler.root.OFP.general.costindex)
			activeBriefings:set("flight:distance",handler.root.OFP.general.air_distance)
			activeBriefings:set("flight:cruiseLevel",handler.root.OFP.general.initial_altitude / 100)
			activeBriefings:set("flight:averageWind",handler.root.OFP.general.avg_wind_dir .. "/" .. handler.root.OFP.general.avg_wind_spd)
			activeBriefings:set("flight:averageWC",handler.root.OFP.general.avg_wind_comp)
			activeBriefings:set("flight:averageISA",handler.root.OFP.general.avg_temp_dev)
			activeBriefings:set("flight:takeoffFuel",handler.root.OFP.fuel.plan_ramp)
			activeBriefings:set("flight:Finres",handler.root.OFP.fuel.alternate_burn+handler.root.OFP.fuel.reserve)
			activeBriefings:set("flight:toweight",handler.root.OFP.weights.payload)
			activeBriefings:set("flight:route",handler.root.OFP.general.route)

			activeBriefings:set("departure:transalt",handler.root.OFP.origin.trans_alt)
			activeBriefings:set("departure:rwy",handler.root.OFP.origin.plan_rwy)
			activeBriefings:set("departure:initAlt",handler.root.OFP.general.initial_altitude)

			activeBriefings:set("arrival:translvl",handler.root.OFP.destination.trans_level/100)
			activeBriefings:set("arrival:aptElevation",handler.root.OFP.destination.elevation)
			activeBriefings:set("approach:rwy",handler.root.OFP.destination.plan_rwy)
		end
	else
		kc_speakNoText(1,"no simbrief user set")
	end
end

-- ------------------------ Briefing Preference Set & UI -----------------------------------
-- ============== Information =============

local information = kcPreferenceGroup:new("information","INFORMATION")
information:setInitialOpen(true)

information:add(kcPreference:new("simversion",
function () 
	return activeBckVars:get("general:simversion")
end,
kcPreference.typeInfo,"X-Plane Version|0xFF00FFFF"))

information:add(kcPreference:new("flightState",
function () 
	return kcSopFlightPhase[activeBckVars:get("general:flight_state")]
end,
kcPreference.typeInfo,"Flight State|0xFF00FFFF"))

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
kcPreference.typeInfo,"Gross Weight / ZFW / MZFW|" .. (kc_get_gross_weight() > kc_get_MTOW() and "0xFF0000FF" or "0xFF95C857")))

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
	if kc_metar_read > 0 then 
		kc_metar_read = kc_metar_read - 1
		return kc_metar_local
	else
		if activePrefSet:get("general:vatsimMetar") == true then
			local response, status = http.request(activeBckVars:get("general:vatsimUrl") .. activeBriefings:get("flight:originIcao"))
			kc_metar_read = 1800 * 5
			kc_metar_local = response
			local m = metar.new(activeBriefings:get("flight:originIcao"))
			kc_metardata_local = m:get_metar_data(kc_metar_local)
			local response, status = http.request(activeBckVars:get("general:vatsimUrl") .. activeBriefings:get("flight:destinationIcao"))
			kc_metar_dest = response
			local m = metar.new(activeBriefings:get("flight:destinationIcao"))
			kc_metardata_dest = m:get_metar_data(kc_metar_dest)
			local response, status = http.request(activeBckVars:get("general:vatsimUrl") .. activeBriefings:get("flight:alternateIcao"))
			kc_metar_altn = response
			return kc_metar_local
		else
			kc_metar_local = kc_buildAtisString(activeBriefings:get("flight:originIcao"))
			-- local m = metar.new(activeBriefings:get("flight:originIcao"))
			-- kc_metardata_local = m:get_metar_data(kc_metar_local)
			-- kc_metar_local = "EDDM 990520Z AUTO 32001KT CAVOK 12/11 Q1018 NOSIG"
			-- local m = metar.new(activeBriefings:get("flight:originIcao"))
			local m = metar.new(activeBriefings:get("flight:originIcao"))
			kc_metardata_local = m:get_metar_data(kc_metar_local)
			if get("sim/weather/has_real_weather_bool") == 1 then 
				kc_metar_dest = "--NO METAR--"
			else
				kc_metar_dest = kc_buildAtisString(activeBriefings:get("flight:destinationIcao"))
			end
			local m = metar.new(activeBriefings:get("flight:destinationIcao"))
			kc_metardata_dest = m:get_metar_data(kc_metar_dest)
			if get("sim/weather/has_real_weather_bool") == 1 then 
				kc_metar_altn = "--NO METAR--"
			else
				kc_metar_altn = kc_buildAtisString(activeBriefings:get("flight:alternateIcao"))
			end
			return kc_metar_local
		end
	end
end,
kcPreference.typeInfo,"Local METAR|"))
information:add(kcPreference:new("destMetar",
function () 
	return kc_metar_dest
end,
kcPreference.typeInfo,"Destination METAR|"))
information:add(kcPreference:new("altnMetar",
function () 
	return kc_metar_altn
end,
kcPreference.typeInfo,"Alternate METAR|"))
information:add(kcPreference:new("metarbutton",0,kcPreference.typeExecButton,"Reload METAR|Load METAR|kc_metar_read = 0"))

information:add(kcPreference:new("FlightTimes",
function () 
	return "OFF: " .. activeBckVars:get("general:timesOFF") .. "Z OUT: " .. activeBckVars:get("general:timesOUT") 
	.. "Z\nIN : " .. activeBckVars:get("general:timesIN") .. "Z  ON: " .. activeBckVars:get("general:timesON") .. "Z"
end,
kcPreference.typeInfo,"Flight Times|0xFF00FFFF"))

-- copy the return to aircraft setting to the approach section
function kc_copy_return_approach()
	activeBriefings:set("approach:nav1Frequency",activeBriefings:get("departure:nav1Frequency"))
	activeBriefings:set("approach:nav1Course",activeBriefings:get("departure:nav1Course"))
	activeBriefings:set("approach:nav2Frequency",activeBriefings:get("departure:nav2Frequency"))
	activeBriefings:set("approach:nav2Course",activeBriefings:get("departure:nav2Course"))
	activeBriefings:set("approach:appType",activeBriefings:get("departure:appType"))
	activeBriefings:set("approach:fafAltitude",activeBriefings:get("departure:fafAltitude"))
	activeBriefings:set("approach:decision",activeBriefings:get("departure:decision"))
	activeBriefings:set("approach:gaheading",activeBriefings:get("departure:gaheading"))
	activeBriefings:set("approach:gaaltitude",activeBriefings:get("departure:gaaltitude"))
	activeBriefings:set("approach:rwy",activeBriefings:get("departure:rwy"))
	activeBriefings:set("approach:rwyCond",activeBriefings:get("departure:rwyCond"))
end

-- =================== FLIGHT DATA ==================
local flight = kcPreferenceGroup:new("flight","FLIGHT")
-- flight:setInitialOpen(true)
flight:add(kcPreference:new("firstFlightDay",true,kcPreference.typeToggle,"First Flight of the Day|First Flight|Not First Flight"))

flight:add(kcPreference:new("simbrief",0,kcPreference.typeExecButton,"Simbrief Data Load|Fetch SIMBRIEF|kc_download_simbrief()"))

flight:add(kcPreference:new("callsign","",kcPreference.typeText,"ATC Callsign|"))
flight:add(kcPreference:new("originIcao","",kcPreference.typeText,"*Origin ICAO|"))
flight:add(kcPreference:new("destinationIcao","",kcPreference.typeText,"*Destination ICAO|"))
flight:add(kcPreference:new("alternateIcao","",kcPreference.typeText,"Alternate ICAO|"))
flight:add(kcPreference:new("route","",kcPreference.typeInfo,"Route|"))

local flight1 = kcPreferenceGroup:new("flight","FLIGHT CRUISE")
if kc_show_cost_index then 
	flight:add(kcPreference:new("costIndex",0,kcPreference.typeInt,"Cost Index|1"))
end
flight1:add(kcPreference:new("distance",0,kcPreference.typeInt,"Air Distance from OFP (nm)|10"))
flight1:add(kcPreference:new("cruiseLevel",0,kcPreference.typeInt,"*Cruise Level (FL)|10"))
flight1:add(kcPreference:new("averageWind","",kcPreference.typeText,"Average Wind (999/99)|"))
flight1:add(kcPreference:new("averageWC",0,kcPreference.typeInt,"Average Wind Component|1"))
flight1:add(kcPreference:new("averageISA",0,kcPreference.typeInt,"Average ISA|1"))
flight1:add(kcPreference:new("criticalMORA",0,kcPreference.typeInt,"Critical MORA (FT)|100"))

local flight2 = kcPreferenceGroup:new("flight","FLIGHT FUEL & LOAD")
flight2:add(kcPreference:new("takeoffFuel",0,kcPreference.typeInt,
function ()
	return "*Takeoff Fuel " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))
flight2:add(kcPreference:new("Finres",0,kcPreference.typeInt,
function ()
	return "Final Reserve + Alternate " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))
flight2:add(kcPreference:new("usablefuel",
function () 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	return string.format("%6.6i %s",activeBriefings:get("flight:takeoffFuel")-activeBriefings:get("flight:Finres"),wunit) 
end,
kcPreference.typeInfo,"Usable Fuel|0xFF00FFFF"))

flight2:add(kcPreference:new("toweight",0,kcPreference.typeInt,
function ()
	return "*Payload " .. (activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS") .. "|100"
end))
if kc_show_load_button then
	flight2:add(kcPreference:new("loadbutton",0,kcPreference.typeExecButton,"Payload & Fuel|Load Airplane|kc_set_payload()"))
end

-- =================== DEPARTURE ==================
local departure = kcPreferenceGroup:new("departure","DEPARTURE ATIS")
departure:add(kcPreference:new("AtisFrequency1",122.800,kcPreference.typeCOMFreq,"ATIS Frequency|"))
departure:add(kcPreference:new("atisInfo","",kcPreference.typeText,"ATIS Information|"))
departure:add(kcPreference:new("atisWind","",kcPreference.typeText,"ATIS Wind HDG/SPD|"))
departure:add(kcPreference:new("atisVisibility","",kcPreference.typeText,"ATIS Visibility m|"))
departure:add(kcPreference:new("atisPrecipit","",kcPreference.typeText,"ATIS Weather Phenomena|"))
departure:add(kcPreference:new("atisClouds","",kcPreference.typeText,"ATIS Clouds|"))
departure:add(kcPreference:new("atisTemps","",kcPreference.typeText,"ATIS Temp/Dewpoint|"))
departure:add(kcPreference:new("atisQNH","",kcPreference.typeText,"*ATIS QNH|"))
departure:add(kcPreference:new("atisVcond","",kcPreference.typeText,"ATIS Trends|"))
departure:add(kcPreference:new("metarto",0,kcPreference.typeExecButton,"METAR|Reload METAR|kc_fill_to_metar()"))

local departure1 = kcPreferenceGroup:new("departure","DEPARTURE CLEARANCE")
departure1:add(kcPreference:new("clrFrequency",122.800,kcPreference.typeCOMFreq,"Clearance Frequency|"))
departure1:add(kcPreference:new("squawk","",kcPreference.typeText,"*XPDR SQUAWK|"))
departure1:add(kcPreference:new("transalt",activePrefSet:get("general:def_trans_alt"),kcPreference.typeInt,"*Transition Altitude (ft)|100"))
departure1:add(kcPreference:new("rwy","",kcPreference.typeText,"Departure Runway|"))
departure1:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. kc_DEP_rwystate_list))
departure1:add(kcPreference:new("initHeading",0,kcPreference.typeInt,"*Initial Heading|1"))
departure1:add(kcPreference:new("initAlt",4900,kcPreference.typeInt,"*Initial Altitude (ft)|100"))
departure1:add(kcPreference:new("crs1",0,kcPreference.typeInt,"*Initial CRS 1|1"))
departure1:add(kcPreference:new("crs2",0,kcPreference.typeInt,"*Initial CRS 2|1"))

local departure2 = kcPreferenceGroup:new("departure","DEPARTURE ROUTING")
departure2:add(kcPreference:new("type",1,kcPreference.typeList,"Departure Type|" .. kc_DEP_proctype_list))
departure2:add(kcPreference:new("route","",kcPreference.typeText,"Departure Route|"))
departure2:add(kcPreference:new("transition","",kcPreference.typeText,"Departure Transition|"))
departure2:add(kcPreference:new("depNADP",1,kcPreference.typeList,"NADP|" .. kc_DEP_nadp_list))
departure2:add(kcPreference:new("depFrequency",122.800,kcPreference.typeCOMFreq,"Departure Frequency|"))

local departure3 = kcPreferenceGroup:new("departure","DEPARTURE RETURN TO AIRPORT")
departure3:add(kcPreference:new("appType",1,kcPreference.typeList,"Expect Approach|" .. kc_apptypes))
departure3:add(kcPreference:new("nav1Frequency",109.00,kcPreference.typeNAVFreq,"NAV1/ILS Frequency|1"))
departure3:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"NAV1 CRS|10"))
departure3:add(kcPreference:new("nav2Frequency",109.00,kcPreference.typeNAVFreq,"NAV2 Frequency|2"))
departure3:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))
departure3:add(kcPreference:new("fafAltitude",0,kcPreference.typeInt,"FAF Altitude (ft)|100"))
departure3:add(kcPreference:new("decision",0,kcPreference.typeInt,"Decision Height/Altitude|10"))
departure3:add(kcPreference:new("gaheading",0,kcPreference.typeInt,"Go-Around Heading|10"))
departure3:add(kcPreference:new("gaaltitude",0,kcPreference.typeInt,"Go-Around Altitude|100"))
departure3:add(kcPreference:new("copybutton",0,kcPreference.typeExecButton,"Set approach section|Copy Data|kc_copy_return_approach()"))

-- =================== TAXI BRIEFING ==================
local taxi = kcPreferenceGroup:new("taxi","TAXI DETAILS")
-- taxi:setInitialOpen(true)
taxi:add(kcPreference:new("gndFrequency1",122.800,kcPreference.typeCOMFreq,"Ground Frequency|"))
taxi:add(kcPreference:new("towerFrequency1",122.800,kcPreference.typeCOMFreq,"Tower Frequency|"))
taxi:add(kcPreference:new("parkingStand","",kcPreference.typeText,"Parking Stand|"))
taxi:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. kc_DEP_gatestand_list))
taxi:add(kcPreference:new("pushDirection",1,kcPreference.typeList,"Push Direction|" .. kc_DEP_push_direction))
taxi:add(kcPreference:new("startSequence",1,kcPreference.typeList,"*Start Sequence|" .. kc_StartSequence))
taxi:add(kcPreference:new("taxiRoute","",kcPreference.typeText,"Taxi Route|"))

-- TRIBETS?
-- Threats, Rain, Weather, Traffic, Language difficulties, MEL issues? Minimum Equipment List
-- Route checked

-- =================== DEPARTURE BRIEFING ==================
-- W eather highlites
-- A ircraft - Type of aircraft and engines
-- N otams - highlite 
-- N oise abatement proc
-- T axi Taxiroute
-- R outing  SID brief alt constraints, speeds, msa ... frequencies
-- A utomation AFDS LNAV/VNAV or other
-- M iscellaneous - any specialities and other non mentioned items of intereset	

-- take departure briefing text and speak (crashes in XP12)
function kc_speakDepBrief()
	kc_speakNoText(0,kc_dep_brief_flight() .. ". For the taxi briefing: " .. kc_dep_brief_taxi() .. kc_dep_brief_departure() .. ".the safety brief" .. kc_dep_brief_safety())
end

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
-- depBriefing:add(kcPreference:new("depbriefspeak",0,kcPreference.typeExecButton,"Departure Briefing|Speak |kc_speakDepBrief()"))

-- =================== TAKEOFF ==================
local takeoff = kcPreferenceGroup:new("takeoff","DEPARTURE TAKEOFF")
-- takeoff:setInitialOpen(true)
takeoff:add(kcPreference:new("thrust",1,kcPreference.typeList,"T/O Thrust|" .. kc_TakeoffThrust))
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
takeoff:add(kcPreference:new("v2",0,kcPreference.typeInt,"*V2|1"))
takeoff:add(kcPreference:new("apMode",1,kcPreference.typeList,"*Autopilot Modes|" .. kc_TakeoffApModes))
takeoff:add(kcPreference:new("fmctobutton",0,kcPreference.typeExecButton,"Load FMS Takeoff Data|Load FMC Data|kc_set_takeoff_details()"))

-- =================== ARRIVAL ==================
local arrival = kcPreferenceGroup:new("arrival","ARRIVAL ATIS")
-- arrival:setInitialOpen(true)
arrival:add(kcPreference:new("atisFrequency2",122.800,kcPreference.typeCOMFreq,"ATIS Frequency|"))
arrival:add(kcPreference:new("atisInfo","",kcPreference.typeText,"ATIS Information|"))
arrival:add(kcPreference:new("atisWind","",kcPreference.typeText,"ATIS Wind HDG/SPD|"))
arrival:add(kcPreference:new("atisVisibility","",kcPreference.typeText,"ATIS Visibility m|"))
arrival:add(kcPreference:new("atisPrecipit","",kcPreference.typeText,"ATIS Weather Phenomena|"))
arrival:add(kcPreference:new("atisClouds","",kcPreference.typeText,"ATIS Clouds|"))
arrival:add(kcPreference:new("atisTemps","",kcPreference.typeText,"ATIS Temp/Dewpoint|"))
arrival:add(kcPreference:new("atisQNH","",kcPreference.typeText,"*ATIS QNH|"))
arrival:add(kcPreference:new("atisVcond","",kcPreference.typeText,"ATIS Trends|"))
arrival:add(kcPreference:new("metarldg",0,kcPreference.typeExecButton,"METAR|Load Arrival METAR|kc_fill_ldg_metar()"))

local arrival1 = kcPreferenceGroup:new("arrival","ARRIVAL DATA")
arrival1:add(kcPreference:new("appFrequency",122.800,kcPreference.typeCOMFreq,"Approach Frequency|"))
arrival1:add(kcPreference:new("translvl",activePrefSet:get("general:def_trans_lvl"),kcPreference.typeInt,"*Transition Level(FL)|100"))
arrival1:add(kcPreference:new("arrType",1,kcPreference.typeList,"Arrival Type|" .. kc_APP_proctype_list))
arrival1:add(kcPreference:new("route","",kcPreference.typeText,"Arrival Route|"))
arrival1:add(kcPreference:new("transition","",kcPreference.typeText,"Arrival Transition|"))
arrival1:add(kcPreference:new("msa",0,kcPreference.typeInt,"Arrival MSA (ft)|100"))
arrival1:add(kcPreference:new("aptElevation",0,kcPreference.typeInt,"*Airport Elevation (ft)|100"))
arrival1:add(kcPreference:new("arrNADP",1,kcPreference.typeList,"NADP|" .. kc_APP_na_list))

-- =================== APPROACH ==================
local approach = kcPreferenceGroup:new("approach","APPROACH DATA")
-- approach:setInitialOpen(true)
approach:add(kcPreference:new("appType",1,kcPreference.typeList,"Expect Approach|" .. kc_apptypes))
approach:add(kcPreference:new("twrFrequency2",122.800,kcPreference.typeCOMFreq,"Tower Frequency|"))
approach:add(kcPreference:new("nav1Frequency",109.00,kcPreference.typeNAVFreq,"NAV1/ILS Frequency|1"))
approach:add(kcPreference:new("nav1Course",0,kcPreference.typeInt,"*NAV1 CRS|10"))
approach:add(kcPreference:new("nav2Frequency",109.00,kcPreference.typeNAVFreq,"NAV2 Frequency|2"))
approach:add(kcPreference:new("nav2Course",0,kcPreference.typeInt,"NAV2 CRS|10"))
approach:add(kcPreference:new("rwy","",kcPreference.typeText,"Arrival Runway|"))
approach:add(kcPreference:new("rwyCond",1,kcPreference.typeList,"Runway Condition|" .. kc_APP_rwystate_list))
approach:add(kcPreference:new("fafAltitude",0,kcPreference.typeInt,"FAF Altitude (ft)|100"))
approach:add(kcPreference:new("decision",0,kcPreference.typeInt,"*Decision Height/Altitude|10"))
approach:add(kcPreference:new("gaheading",0,kcPreference.typeInt,"Go-Around Heading|10"))
approach:add(kcPreference:new("gaaltitude",0,kcPreference.typeInt,"Go-Around Altitude|100"))

local approach1 = kcPreferenceGroup:new("approach","APPROACH AIRCRAFT")
approach1:add(kcPreference:new("flaps",1,kcPreference.typeList,"*Landing Flaps|" .. kc_LandingFlaps))
approach1:add(kcPreference:new("vref",0,kcPreference.typeInt,"*Vref|1"))
approach1:add(kcPreference:new("vapp",0,kcPreference.typeInt,"*Vapp|1"))
approach1:add(kcPreference:new("autobrake",1,kcPreference.typeList,"*Autobrake|" .. kc_LandingAutoBrake))
approach1:add(kcPreference:new("packs",1,kcPreference.typeList,"*Packs|" .. kc_LandingPacks))
approach1:add(kcPreference:new("antiice",1,kcPreference.typeList,"*Anti Ice|" .. kc_LandingAntiice))
approach1:add(kcPreference:new("reversethrust",1,kcPreference.typeList,"Reverse Thrust|" .. APP_rev_thrust_list))
approach1:add(kcPreference:new("fmcldgbutton",0,kcPreference.typeExecButton,"Load FMS Landing Data|Load FMC Landing Data|kc_set_landing_details()"))

local approach2 = kcPreferenceGroup:new("approach","APPROACH GROUND")
approach2:add(kcPreference:new("gndFrequency2",122.800,kcPreference.typeCOMFreq,"Ground Frequency|"))
approach2:add(kcPreference:new("gateStand",1,kcPreference.typeList,"Gate/Stand|" .. kc_APP_gatestand_list))
approach2:add(kcPreference:new("parkingPosition","",kcPreference.typeText,"Parking Position|"))
approach2:add(kcPreference:new("powerAtGate",1,kcPreference.typeList,"External Power at Stand|" .. kc_APP_power_at_stand))
approach2:add(kcPreference:new("activateAPUafterLand",1,kcPreference.typeToggle,"*Start APU after Landing|Start APU|APU remains off"))
approach2:add(kcPreference:new("taxiIn","",kcPreference.typeText,"Taxi to Position via|"))

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
activeBriefings:addGroup(flight1)
activeBriefings:addGroup(flight2)
activeBriefings:addGroup(taxi)
activeBriefings:addGroup(departure)
activeBriefings:addGroup(departure1)
activeBriefings:addGroup(departure2)
activeBriefings:addGroup(departure3)
activeBriefings:addGroup(takeoff)
activeBriefings:addGroup(depBriefing)
activeBriefings:addGroup(arrival)
activeBriefings:addGroup(arrival1)
activeBriefings:addGroup(approach)
activeBriefings:addGroup(approach1)
activeBriefings:addGroup(approach2)
activeBriefings:addGroup(appbrief)

function getActiveBriefings()
	return activeBriefings
end

return defaultBriefings
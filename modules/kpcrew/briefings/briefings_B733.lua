-- Aircraft specific briefing values and functions - Zibo Mod B738
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
kc_acf_name 		= "IXEG Boeing 737-300 Plus"

kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_TakeoffFlaps 	= "1|2|5|10|15|25"
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON|UNDER PRESSURIZED"
kc_TakeoffApModes 	= "LNAV/VNAV|HDG/FLCH"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps 	= "30|40"
kc_LandingAutoBrake = "OFF|1|2|3|MAX"
kc_LandingPacks 	= "OFF|ON|UNDER PRESSURIZED"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_MELIssues 		= "no M E L issues|M E L issues"

-- aircraft specs, weights in KG
-- MAX ZERO FUEL WEIGHT:   62732 KG - 138300 LBS
-- MAX TAKEOFF WEIGHT:     79016 KG - 174200 LBS
-- MAX LANDING WEIGHT:     66361 KG - 146300 LBS
-- MAX FUEL CAPACITY:      20900 KG -  46077 LBS
-- FUEL FLOW PER HOUR:      2187 KG -   4825 LBS

kc_DOW 				= 41510  -- Dry Operating Weight (aka OEW)
kc_MZFW  			= 62732  -- Maximum Zero Fuel Weight
kc_MaxFuel 			= 21611  -- Maximum Fuel Capacity
kc_MaxPayld 		= 22000  -- Maximum Payload to be set     *********************************************
kc_MTOW 			= 79016  -- Maximum Takeoff Weight
kc_MLW  			= 66361  -- Maximum Landing Weight
kc_FFPH 			=  2187  -- Average Fuel Flow per hour
kc_MFL1				=  4112  -- max fuel in tank left
kc_MFL2				= 13385  -- max fuel in tank center
kc_MFL3				=  4112  -- max fuel in tank right

-- Operating speeds
kc_speeds_vs0		= 115		-- Stall Speed, Landing Configuration Vso 115 KIAS
kc_speeds_vs1		= 136		-- Stall Speed, Clean Vs1 136 KIAS
kc_speeds_vs		= 140		-- Minimum Controllable Speed Vs 140 KIAS
kc_speeds_vx		= 270		-- Best Angle of Climb Vx 270 KIAS
kc_speeds_vy		= 300		-- Best Rate of Climb Vy 300 KIAS
kc_speeds_vfe		= 180		-- Maximum flaps Extended Speed Vfe 180 KIAS
kc_speeds_vmo1		= 270		-- Maximum Operating Speed (Sea Level to 8,000 ft) Vmo 270 KIAS
kc_speeds_vmo2		= 350		-- Maximum Operating Speed (Above 8,000 ft) Vmo 350 KIAS
kc_speeds_vmo3		= 0.935		-- Maximum Mach Number Vmo 0.935 Mach
kc_speeds_vle		= 210		-- Maximum Gear Operating Speed Vle 210 KIAS
kc_speeds_vlo		= 210		-- Maximum Gear Extended Speed Vlo 210 KIAS
kc_speeds_vfl1		= 230		-- Maximum extension speed for flaps 
kc_speeds_vfl5		= 230
kc_speeds_vfl10		= 210	
kc_speeds_vfl15		= 190	
kc_speeds_vfl20		= 170	
-- kc_speeds_vfl30		= vref+5
-- kc_speeds_vfl40		= vref+5	

-- http://www.b737.org.uk/vspeedcalc2.htm
-- VSpeed calculation B737-800
-- V2 is approximately take-off weight - 20. (very rough)
-- To get V1 we can remember a certain table.
-- Starting with 65t the diff between V1 and V2 is 10kts,
--               60t                           11kts,
--               55t                           12kts,
--               50t                           13kts,
--               45t                           15kts,
--               40t                           17kts.
-- The diff between V1 and Vr is just 2 kts up to landing weight of 55t. 
-- Above landing weight this diff is 4kts
-- rough calculation: V1 is about 10 kts less than V2 and Vr is about 2 kts more than V1 generally.
-- VRef: 
-- Ref. Weight. is 40t. and a standard correction of minus 1 up to max landing weight. Above max landing weight it is 3kts.
-- 
-- Vref for 40t for flaps 30 is 40 x 3 = 120 -1 = 119kts.
--   "   "   "   "    "   40 is Vref 30 - 3 = 116kts.
-- 
-- Next just half the difference between Actual and ref weight. and then add back to ref weight. x 3 = V - 1 = Vref for that weight.
-- 
-- Example: Actual weight. 50t which is 10t more than ref weight.
-- 10/2 = 5 + 40 = 45 x 3 = 135 -1 = 134. Same as QRH/FMC.
-- 
-- Vref for flaps 40 for 50t is Vref 30 - 4 = 130kts.
-- (Diff between Vref 30 and 40 is 3kts below 50t. 50t and above, it is 4kts.)
-- (Diff between Vref 30 and Vref 15 is about 15 kts.)
-- 
-- The above rule of thumb has no error and it is as good as your QRH speeds for flaps 30 and 40 up to landing weight of 55t. Above this weight standard correction of 1 kts is increased to 3kts)
-- 
-- To make the above calculation easy, like John's method we need to remember only ref speed of 120 kts. Just half the difference of weight between actual and the ref and multiply by 3. Add this to 120 and we have Vref + 1 kts for flaps 30.
-- 
-- Example: Actual landing weight is 50t. so difference is 10t. Half of that is 5. 5x3 = 15. 120+15 = 135 - 1 = 134kts. I leave to the pilot whether he would like to remember 119 or 120 as the reference speed for the convenience.
-- 
-- Another example: Act land weight is 49.4t diff is 9.4. Half of that is 4.7. It is then multiplied by 3. (4x3=12)+(.7x3=2.1) = 14.1 + 119 = 133kts.


kc_show_load_button = true
kc_show_cost_index 	= true

-- full list of approach types can be overwritten by aircraft
APP_apptype_list 	= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"

-- APU/GPU startup after landing
APP_apu_list 		= "APU delayed start|APU|GPU"

-- Reverse Thrust
APP_rev_thrust_list = "NONE|MINIMUM|FULL"

-- get Dry Operating Weight
function kc_get_DOW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_DOW
	else
		return kc_DOW * 2.20462262
	end
end

-- get Max Zero Fuel Weight
function kc_get_MZFW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MZFW
	else
		return kc_MZFW * 2.20462262
	end
end

-- get MaxFuel
function kc_get_MaxFuel()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MaxFuel
	else
		return kc_MaxFuel * 2.20462262
	end
end

-- get Max Take Off Weight
function kc_get_MTOW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MTOW
	else
		return kc_MTOW * 2.20462262
	end
end

-- get Max Landing Weight
function kc_get_MLW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MLW
	else
		return kc_MLW * 2.20462262
	end
end

-- get average Fuel Flow per Hour
function kc_get_FFPH()
	if activePrefSet:get("general:weight_kgs") then
		return kc_FFPH
	else
		return kc_FFPH * 2.20462262
	end
end

-- get total fuel weight from all tanks
function kc_get_total_fuel()
	if activePrefSet:get("general:weight_kgs") then
		return get("laminar/B738/fuel/total_tank_kgs")
	else
		return get("laminar/B738/fuel/total_tank_lbs")
	end
end

-- get Gross Weight
function kc_get_gross_weight()
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/flightmodel/weight/m_total")
	else
		return get("sim/flightmodel/weight/m_total")*2.20462262
	end	
end

-- get Zero Fuel Weight
function kc_get_zfw()
	return kc_get_gross_weight()-kc_get_total_fuel()
end

-- set payload (does not work in all addons and sim versions)
function kc_set_payload()
	-- only XP11
	-- if activeBckVars:get("general:simversion") < 12000 then
		local payload = activeBriefings:get("flight:toweight")
		set("sim/flightmodel/weight/m_fixed", payload)
	-- end
	set("sim/aircraft/weight/acf_m_fuel_tot",20000)
	local fgoal = activeBriefings:get("flight:takeoffFuel")
	set("sim/flightmodel/weight/m_fuel1",math.min(kc_MFL1,fgoal/2))
	set("sim/flightmodel/weight/m_fuel3",math.min(kc_MFL3,fgoal/2))
	local fdiff = fgoal - (kc_MFL1 + kc_MFL3)
	if fdiff > 0 then
		set("sim/flightmodel/weight/m_fuel2",math.min(kc_MFL2,fdiff))
	else
		set("sim/flightmodel/weight/m_fuel2",0)
	end
end

-- set the takeoff details v-speeds, trim
function kc_set_takeoff_details()
	activeBriefings:set("takeoff:v1",get("laminar/B738/FMS/v1_set"))
	activeBriefings:set("takeoff:vr",get("laminar/B738/FMS/vr"))
	activeBriefings:set("takeoff:v2",get("laminar/B738/FMS/v2_set"))
	activeBriefings:set("takeoff:elevatorTrim",get("laminar/B738/FMS/trim_calc"))
end

-- set the landing details v-speeds, trim
function kc_set_landing_details()
	activeBriefings:set("approach:vref",get("laminar/B738/FMS/vref"))
	activeBriefings:set("approach:vapp",get("laminar/B738/FMS/vref")+get("laminar/B738/FMS/approach_wind_corr"))
	local ldgflaps = get("laminar/B738/FMS/approach_flaps")
	if ldgflaps == 30 then
		activeBriefings:set("approach:flaps",1)
	elseif ldgflaps == 40 then
		activeBriefings:set("approach:flaps",2)
	end
end

-- briefings to be more aircraft specific
function kc_dep_brief_flight() 
	local briefing = "OK, I will be the pilot flying\n"
-- [W] eather highlites
	briefing = briefing .. "We are located at " .. activeBriefings:get("flight:originIcao") .. " parking stand " .. activeBriefings:get("taxi:parkingStand") .. "\n"
    briefing = briefing .. "We have ATIS information " .. activeBriefings:get("departure:atisInfo") .. ". <The weather is " .. activeBriefings:get("information:localMetar") .. ">.\n\n"

-- [A] ircraft
    briefing = briefing .. "Today we are flying in a " .. kc_acf_name .. ". <Engine and aircraft details from CDU>. We have " .. kc_split(kc_MELIssues,"|")[activeBriefings:get("information:melIssues")] .. " today." .. "\n\n"

-- [N] otams - highlite 
    briefing = briefing .. "<NOTAMs highlites if there are any may also include VATSIM/IVAO details etc>" .. "\n\n"

-- [N] oise abatement proc
	briefing = briefing .. "This will be a standard takeoff, noise abatement procedure " .. kc_split(kc_DEP_nadp_list,"|")[activeBriefings:get("departure:depNADP")] .. ".\n\n"

-- [A] utomation AFDS LNAV/VNAV or other
	
	return briefing
end

function kc_dep_brief_taxi() 
-- [T] axi Taxiroute
	local xtaxiroute = ""
	if activeBriefings:get("taxi:gateStand") == 1 then
		xtaxiroute = "This is a gate position, pushback required " .. kc_split(kc_DEP_push_direction,"|")[activeBriefings:get("taxi:pushDirection")] .. ".\n"
	end
	if activeBriefings:get("taxi:gateStand") == 2 then
		xtaxiroute = "This is an outer position, pushback required " .. kc_split(kc_DEP_push_direction,"|")[activeBriefings:get("taxi:pushDirection")] .. ".\n"
	end
	if activeBriefings:get("taxi:gateStand") == 3 or activeBriefings:get("taxi:pushDirection") == 1 then
		xtaxiroute = "We require no pushback at this position, start clearance only.\n"
	end
	-- briefing = briefing .. xtaxiroute
	xtaxiroute = xtaxiroute .. "We will be taxiing to holding point runway " .. activeBriefings:get("departure:rwy") .. " via "
	xtaxiroute = xtaxiroute .. activeBriefings:get("taxi:taxiRoute") .. ".\n\n"

	return xtaxiroute
end

function kc_dep_brief_departure() 
-- [R] outing 
	local briefing = ""
	local xdep = ""
	if activeBriefings:get("departure:type") == 1 then
		xdep = "This will be a standard instrument departure via " .. activeBriefings:get("departure:route") .. " transition " .. activeBriefings:get("departure:transition") .. ".\n"
	end
	if activeBriefings:get("departure:type") == 2 then
		xdep = "The departure will be ATC vectors.\n"
	end
	if activeBriefings:get("departure:type") == 3 then
		xdep = "The departure will be via tracking.\n"
	end
	briefing = briefing .. xdep 
	briefing = briefing .. "We will take off from runway " .. activeBriefings:get("departure:rwy")  .. ". Runway conditions are " .. kc_split(kc_DEP_rwystate_list,"|")[activeBriefings:get("departure:rwyCond")] .. ".\n"
	briefing = briefing .. "Initial altitude will be " .. activeBriefings:get("departure:initAlt") .. " ft. Today's cruise altitude will be FL " .. activeBriefings:get("flight:cruiseLevel") .. ".\n" 
	briefing = briefing .. "Transition altitude is " .. activeBriefings:get("departure:transalt") .. " the initial heading is " .. activeBriefings:get("departure:initHeading") .. ".\n"
	briefing = briefing .. "We will use Flaps " .. kc_split(kc_TakeoffFlaps,"|")[activeBriefings:get("takeoff:flaps")] .. " for takeoff.\n"
	briefing = briefing .. "Our take off thrust is " .. kc_split(kc_TakeoffThrust,"|")[activeBriefings:get("takeoff:thrust")] .. " Anti Ice is " .. kc_split(kc_TakeoffAntiice,"|")[activeBriefings:get("takeoff:antiice")] .. ",bleeds will be " .. kc_split(kc_TakeoffBleeds,"|")[activeBriefings:get("takeoff:bleeds")] .. ".\n"
	briefing = briefing .. "Minimum Safe Altitude along our initial route is ".. activeBriefings:get("takeoff:msa") .. "ft.\n"
	briefing = briefing .. "In case of forced return we are ".. kc_split(kc_DEP_forced_return,"|")[activeBriefings:get("takeoff:forcedReturn")] .. ".\n"
	briefing = briefing .. "The takeoff speeds are set. V1 is ".. activeBriefings:get("takeoff:v1") .. ", Vr is " .. activeBriefings:get("takeoff:vr") .. " and V2 today " .. activeBriefings:get("takeoff:v2") .. ".\n"
	briefing = briefing .. "<Brief the departure procedure from CDU and charts>" .. "\n\n"

	return briefing
end

function kc_dep_brief_safety() 
	local briefing = ""
-- [M] iscellaneous
	briefing = briefing .. "For the safety brief:\n"
	briefing = briefing .. "From 0 to 100 knots for any malfunction I will call reject and we will confirm the autobrakes are operating.\n\n"
	briefing = briefing .. "If not operating I will apply maximum manual breaking and maximum symmetric reverse thrust and come to a full stop on the runway.\n\n"
	briefing = briefing .. "After full stop on the runway we decide on course of further actions.\n\n"
	briefing = briefing .. "From 100 knots to V1 I will reject only for one of the following reasons, engine fire, engine failure or takeoff configuration warning horn.\n\n"
	briefing = briefing .. "At and above V1 we will continue into the air and the only actions for you below 400 feet are to silence any alarm bells and confirm any failures.\n\n"
	briefing = briefing .. "Above 400 feet I will call for failure action drills as required and you'll perform memory items.\n\n"
	briefing = briefing .. "At 800 feet above field elevation I will call for altitude hold and we will retract the flaps on schedule.\n\n"
	briefing = briefing .. "At 1500 feet I will call for the checklist.\n\n"
	briefing = briefing .. "If we are above maximum landing weight we will make decision on whether to perform an overweight landing if the situation requires.\n\n"
	briefing = briefing .. "If we have a wheel well, engine or wing fire, I will turn the aircraft in such a way the flames will be downwind and we will evacuate through the upwind side.\n\n"
	briefing = briefing .. "If we have a cargo fire you need to ensure emergency services do not open the cargo doors until evac is completed.\n\n"
	briefing = briefing .. "Any questions or concerns?\n\n"
	
	return briefing
end

function kc_arr_brief_general() 
	local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
	local briefing = ""
-- [W] eather highlites
	briefing = briefing .. "Our destination today is " .. activeBriefings:get("flight:destinationIcao") .. "\n"
	briefing = briefing .. "The weather report is  " .. activeBriefings:get("information:destMetar") .."\n\n" 

-- [A] ircraft
    briefing = briefing .. "Our current weight is " .. string.format("%6.6i %s",kc_get_gross_weight(),wunit) .. 
		" and fuel remaining " .. string.format("%6.6i %s",kc_get_total_fuel(),wunit) .. "\n"
    briefing = briefing .. "Vref for our approach is " .. activeBriefings:get("approach:vref") .. " kts and Vapp " .. activeBriefings:get("approach:vapp") ..  " kts\n\n"

-- [N] otams - highlite 
    briefing = briefing .. "NOTAMs highlites if there are any <may also include VATSIM/IVAO details etc" .. "\n\n"

-- [N] oise abatement proc
	briefing = briefing .. "Special noise abatement considerations: " .. kc_split(kc_APP_na_list,"|")[activeBriefings:get("arrival:arrNADP")] .. "\n\n"

-- [A] utomation AFDS LNAV/VNAV or other

	return briefing
end

function kc_arr_brief_route() 
	local briefing = ""
-- [R] outing 
	briefing = briefing .. "we will arrive at " .. activeBriefings:get("flight:destinationIcao") .. " via "
		if activeBriefings:get("arrival:arrType") == 1 then
			briefing = briefing .. "STAR " .. activeBriefings:get("arrival:route") .. " with transition " .. activeBriefings:get("arrival:transition") .."\n"
		else
			briefing = briefing .. "ATC vectors".."\n"
		end
	briefing = briefing .. "The MSA in our arrival sector is " .. activeBriefings:get("arrival:msa") .. " and the transition level today FL " .. activeBriefings:get("arrival:translvl").."\n"
	briefing = briefing .. "After the arrival we can expect an " .. kc_split(kc_apptypes,"|")[activeBriefings:get("approach:appType")] .. " approach".."\n"
	briefing = briefing .. "Runway assigned is " .. activeBriefings:get("approach:rwy") .. " and the condition is " .. kc_split(kc_APP_rwystate_list,"|")[activeBriefings:get("approach:rwyCond")].."\n"
	briefing = briefing .. "Altitude at the FAF is " .. activeBriefings:get("approach:fafAltitude") .. ", " .. (activePrefSet:get("aircraft:efis_mins_dh")==true and "DH" or "DA") .." will be " .. activeBriefings:get("approach:decision").."\n"
	briefing = briefing .. "Airport elevation is " .. activeBriefings:get("arrival:aptElevation").." ft \n"
	briefing = briefing .. "We are going to use landing flaps " .. kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:flaps")] .. " and Autobrake " .. kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:autobrake")].."\n"
	briefing = briefing .. "Packs are set " .. kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:packs")] .. " and Anti Ice " .. kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:antiice")].."\n"
	briefing = briefing .. kc_split(APP_rev_thrust_list,"|")[activeBriefings:get("approach:reversethrust")] .. " reverse thrust applied" .. "\n"
	briefing = briefing .. "<Brief the arrival procedure from CDU and charts" .. "\n\n"

	return briefing
end

function kc_arr_brief_ground() 
	local briefing = ""

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
	briefing = briefing .. "At the stand " .. kc_split(kc_APP_power_at_stand,"|")[activeBriefings:get("approach:powerAtGate")] .. " is available.\n"
	briefing = briefing .. "Any questions or concerns?"
	
-- [M] iscellaneous
	
	return briefing
end
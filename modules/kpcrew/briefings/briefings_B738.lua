-- Aircraft specific briefing values and functions - Zibo Mod B738
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Zibo Boeing 737-800"

kc_NumFlapsTO		= 5
kc_TakeoffFlaps 	= "UP|1|5|10|15"
kc_TakeoffFlapsInd 	= "0|1|3|4|5"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "25|30|40"
kc_LandingFlapsInd 	= "6|7|8"
kc_LandingAutoBrake = "RTO|OFF|1|2|3|MAX"
kc_LandingAutoBrInd = "0|1|2|3|4|5"
kc_LandingPacks 	= "OFF|ON|UNDER PRESSURIZED"
kc_Numflap_detents	=  8 		-- Number of flap detents

-- aircraft specs, weights in KG
-- MAX ZERO FUEL WEIGHT:   62732 KG - 138300 LBS
-- MAX TAKEOFF WEIGHT:     79016 KG - 174200 LBS
-- MAX LANDING WEIGHT:     66361 KG - 146300 LBS
-- MAX FUEL CAPACITY:      20900 KG -  46077 LBS
-- FUEL FLOW PER HOUR:      2187 KG -   4825 LBS

kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief	
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	

-- kc_DOW 				= 41510  -- Dry Operating Weight (aka OEW)
-- kc_MZFW  			= 62732  -- Maximum Zero Fuel Weight
-- kc_MaxFuel 			= 21611  -- Maximum Fuel Capacity
-- kc_MaxPayld 		= 22000  -- Maximum Payload to be set     *********************************************
-- kc_MTOW 			= 79016  -- Maximum Takeoff Weight
-- kc_MLW  			= 66361  -- Maximum Landing Weight
-- kc_FFPH 			=  2187  -- Average Fuel Flow per hour
-- kc_NumEngines		=     2	 -- Number of engines
-- kc_NumTanks			=     4	 -- Number of tanks
-- kc_MFL1				=  4112  -- max fuel in tank left
-- kc_MFL2				= 13385  -- max fuel in tank center
-- kc_MFL3				=  4112  -- max fuel in tank right

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

-- kc_speeds_vfl1		= 230		-- Maximum extension speed for flaps 
-- kc_speeds_vfl5		= 230
-- kc_speeds_vfl10		= 210	
-- kc_speeds_vfl15		= 190	
-- kc_speeds_vfl20		= 170	

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

-- full list of approach types can be overwritten by aircraft
-- APP_apptype_list 	= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"

-- APU/GPU startup after landing
-- APP_apu_list 		= "APU delayed start|APU|GPU"

-- Reverse Thrust
-- APP_rev_thrust_list = "NONE|MINIMUM|FULL"

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
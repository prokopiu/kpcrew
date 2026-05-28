--[[
	*** KPCREW 2.3
	collection of functions to be used by more than one kptool
	Kosta Prokopiu, July 2023
	Changed November 2025
--]]

-- ------ find the right icao code 
function kc_get_matching_icao_code()

	local icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

	-- ====== Select the addon modules based on ICAO code
	if PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738" then
		icao = "B737" -- Zibo B738
	elseif PLANE_ICAO == "B739" then
		icao = "B737" -- LevelUp B739
	elseif PLANE_ICAO == "B736" then
		icao = "B737" -- LevelUp B736
	elseif PLANE_ICAO == "B737" then
		icao = "B737" -- LevelUp B737
	elseif PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "B738" then
		icao = "B737" -- LevelUp B738

	-- Epic Victory Aerobask
	elseif PLANE_ICAO == "EVIC" then
		icao = "EVIC"

	-- Epic E1000 Aerobask
	elseif PLANE_ICAO == "EPIC" then
		icao = "EPIC"

	-- Vskylabs C510
	elseif PLANE_ICAO == "C510" then
		icao = "C510"

	-- Aeroworx DC-3 Freeware
	elseif PLANE_ICAO == "DC3" then
		icao = "ADC3"
		
	-- Thranda PC12
	-- elseif PLANE_ICAO == "PC12" then
		-- icao = "PC12"
		
	-- FF A350
	-- elseif PLANE_ICAO == "A359" then
		-- icao = "A359"	
	
	-- SSG B748
	elseif PLANE_ICAO == "B748" then
		icao = "B748"

	-- Laminar SF50
	elseif PLANE_ICAO == "SF50" then
		icao = "SF50"
		
	-- XP12 Citation X
	elseif PLANE_ICAO == "C750" and PLANE_TAILNUMBER == "N750XP" then
		icao = "C750"
		
	-- XP12 A330-300 Laminar
	elseif PLANE_ICAO == "A333" then
		icao = "A33L"
		
	-- Inibuilds A300
	elseif PLANE_ICAO == "A306" then
		icao = "A306"

	-- FF 7x7
	elseif PLANE_ICAO == "B762" or PLANE_ICAO == "B763" or PLANE_ICAO == "B764" or PLANE_ICAO == "B752" or PLANE_ICAO == "B753" then
		icao = "B7x7"
		
	-- Rotate MD-11
	-- elseif PLANE_ICAO == "MD11" then
		-- icao = "MD11"
		
	-- FJsim 737	
	-- elseif PLANE_ICAO == "B732" then
		-- icao = "B732"

	-- IXEG 737
	-- elseif PLANE_ICAO == "B733" then
		-- icao = "B733"

	-- Felis 747-200
	elseif PLANE_ICAO == "B742" then
		icao = "B742"
			
	-- X-CRAFTS E-JET FAMILIY XP12 (E1XX)
	-- E-JET FAM 170  170/170
	-- E-JET FAM 175  175/175
	-- E-JET FAM 190  190/190
	-- E-JET FAM 195  195/195
	-- LINEAGE 1000
	elseif PLANE_ICAO == "E170" and PLANE_TAILNUMBER == "E170" then
		icao = "E1XX"
	elseif PLANE_ICAO == "E175" and PLANE_TAILNUMBER == "E175" then
		icao = "E1XX"
	elseif PLANE_ICAO == "E190" and PLANE_TAILNUMBER == "E190" then
		icao = "E1XX"
	elseif PLANE_ICAO == "E195" and PLANE_TAILNUMBER == "E195" then
		icao = "E1XX"
	elseif PLANE_ICAO == "E19L" then
		icao = "E1XX"
		
	-- X-CRAFTS FREE E-JETS XP12 (E1FF)
	-- Free 175       170/175
	-- Free 195       190/195
	elseif PLANE_ICAO == "E170" and PLANE_TAILNUMBER == "E175" then
		icao = "E1FF"
	elseif PLANE_ICAO == "E190" and PLANE_TAILNUMBER == "E195" then
		icao = "E1FF"

	-- X-CRAFTS ERJ FAMILIY XP12 (ER1X)
	-- ERJ 135
	-- ERJ 140
	-- ERJ 145
	-- ERJ 145XR
	-- LEGACY Business jet
	elseif PLANE_ICAO == "E135" then
		icao = "ER1X"
	elseif PLANE_ICAO == "E140" then
		icao = "ER1X"
	elseif PLANE_ICAO == "E145" then
		icao = "ER1X"
	elseif PLANE_ICAO == "E45X" then
		icao = "ER1X"
	elseif PLANE_ICAO == "E35L" then
		icao = "ER1X"

	-- JUSTFLIGHT BAE SERIES
	-- B463
	-- B462
	-- B461
	elseif PLANE_ICAO == "B461" then
		icao = "B46X"
	elseif PLANE_ICAO == "B462" then
		icao = "B46X"
	elseif PLANE_ICAO == "B463" then
		icao = "B46X"
		
	-- ToLiss Airbusses
	elseif PLANE_ICAO == "A319" and PLANE_TAILNUMBER == "C-GTLS" then
		icao = "A3TL"
	elseif PLANE_ICAO == "A20N" and PLANE_TAILNUMBER == "C-GTLT" then
		icao = "A3TL"
	elseif PLANE_ICAO == "A321" then
		icao = "A3TL"
	elseif PLANE_ICAO == "A21N" then
		icao = "A3TL"
	elseif PLANE_ICAO == "A339" then
		icao = "A3TL"
	elseif PLANE_ICAO == "A346" then
		icao = "A3TL"
		
	-- Laminar MD-82
	elseif PLANE_ICAO == "MD82" and PLANE_TAILNUMBER == "N552AA" then
		icao = "MD82"
		
	-- RotateSim MD-88
	elseif PLANE_ICAO == "MD88" then
		icao = "MD88"
		
	-- LES Saab SF34
	elseif PLANE_ICAO == "SF34" then
		icao = "SF34"
		
	-- MSparks B747
	elseif PLANE_ICAO == "B744" or PLANE_ICAO == "B744F" then
		icao = "B744"
		
	-- Aerobask Phenom 300
	elseif PLANE_ICAO == "E55P" then
		icao = "E55P"
	
	-- Riviere Dash-8
	-- DHC8A Dash 8-Q100
	elseif PLANE_ICAO == "DH8AA" then
		icao = "DHC8"
		
	end
	

	return icao
end


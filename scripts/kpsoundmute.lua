--[[
	*** KPSOUNDMUTE 2.3
	Simulate noise cancelling headsets to be turned on and off
	Kosta Prokopiu, July 2023
--]]

-- ====== Global variables =======
ks_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)
ks_mode_auto = false -- switches between manual mode (use the toggle command) and outside detection

-- ====== Select the addon modules based on ICAO code
if PLANE_ICAO == "PC12" then
	ks_acf_icao = "PC12" 
-- elseif PLANE_ICAO == "xxx" then
	-- ks_acf_icao = "xxx"
end

-- mute state is off at start
ks_mute_state = true

function ks_switch_mute()
	if ks_acf_icao == "DFLT" then
		if ks_mute_state == false then
			set("sim/operation/sound/interior_volume_ratio",0.1)
			set("sim/operation/sound/weather_volume_ratio",0.1)
			set("sim/operation/sound/exterior_volume_ratio",0.1)
			ks_mute_state = true
		else
			set("sim/operation/sound/interior_volume_ratio",0.7)
			set("sim/operation/sound/weather_volume_ratio",0.7)
			set("sim/operation/sound/exterior_volume_ratio",0.5)
			ks_mute_state = false
		end
	end
	if ks_acf_icao == "PC12" then
		if ks_mute_state == false then
			set("thranda/sound/mastervolknob",0.1)
			set("sim/operation/sound/interior_volume_ratio",0.1)
			set("sim/operation/sound/weather_volume_ratio",0.1)
			ks_mute_state = true
		else
			set("thranda/sound/mastervolknob",0.5)
			set("sim/operation/sound/interior_volume_ratio",0.7)
			set("sim/operation/sound/weather_volume_ratio",0.7)
			ks_mute_state = false
		end
	end
end

function ks_auto_switch()
-- ==== intern
-- 1000 = forward with 2D
-- 1023 = forward with HUD
-- 1024 = forward with no 
-- 1026 = forward with 3D (default)
-- ==== extern
-- 1014 = tower (shift+5)	
-- 1015 = runway (shift+3)
-- 1017 = chase (shift+8) 
-- 1018 = circle (shift+4)
-- 1020 = still spot (shift+2)
-- 1021 = linear spot (shift+1)
-- 1028 = free camera (shift+0)
-- 1031 = ride along (shift+6)

	if ks_mode_auto == true then
		if get("sim/graphics/view/view_type") == 1000 then ks_mute_state = true end
		if get("sim/graphics/view/view_type") == 1023 then ks_mute_state = true end
		if get("sim/graphics/view/view_type") == 1024 then ks_mute_state = true end
		if get("sim/graphics/view/view_type") == 1026 then ks_mute_state = true end
		if get("sim/graphics/view/view_type") == 1014 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1015 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1017 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1018 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1020 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1021 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1028 then ks_mute_state = false end
		if get("sim/graphics/view/view_type") == 1031 then ks_mute_state = false end
		ks_switch_mute()
	end
	
end

ks_switch_mute()

do_often("ks_auto_switch()")
add_macro("KPSoundMute Toggle Mute", "ks_switch_mute() ks_mode_auto=false")
add_macro("KPSoundMute Toggle Auto", "ks_mode_auto=not ks_mode_auto")
create_command("kp/soundmute/toggle", "KPSoundMute Toggle Mute","ks_switch_mute() ks_mode_auto=false","","")
create_command("kp/soundmute/auto", "KPSoundMute Toggle Auto","ks_mode_auto=not ks_mode_auto","","")

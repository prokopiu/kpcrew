--[[
	*** KPSOUNDMUTE 2.3
	Simulate noise cancelling headsets to be turned on and off
	Kosta Prokopiu, October 2022
--]]

-- ====== Global variables =======
ks_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

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

ks_switch_mute()

add_macro("KPSoundMute Toggle Mute", "ks_switch_mute()")
create_command("kp/soundmute/toggle", "KPSoundMute Toggle Mute","ks_switch_mute()","","")

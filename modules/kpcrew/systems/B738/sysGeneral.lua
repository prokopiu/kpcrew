-- B738 airplane 
-- aircraft general systems
local sysGeneral = {
	modeOff = 0,
	modeOn = 1,
	modeToggle = 2,
	modeGearUp = 0,
	modeGearDown = 1,
	modeGearOff = 3,
    GearLightGreenLeft = "greenLeft", 
	GearLightGreenRight = "greenRight", 
	GearLightGreenNose = "greenNose", 
	GearLightRedLeft = "redLeft", 
	GearLightRedRight = "redRight", 
	GearLightRedNose = "redNose",
	BaroLeft = "Left",
	BaroRight = "Right",
	BaroStandby = "Standby",
	BaroAll = "All",
	BaroModeNormal = 0,
	BaroModeStandard = 1,
	BaroUp = 1,
	BaroDown = 0,
	BaroInHg = 0,
	BaroMbar = 1
}

local drefParkBrake = "sim/cockpit2/controls/parking_brake_ratio"

local drefGearHandle = "laminar/B738/controls/gear_handle_down"
local cmdGearUp = "sim/flight_controls/landing_gear_up"
local cmdGearDown = "sim/flight_controls/landing_gear_down"
local cmdGearOff = "laminar/B738/push_button/gear_off"

local drefGearLights = { 
	["greenLeft"] = "laminar/B738/annunciator/left_gear_safe", 
	["greenRight"] = "laminar/B738/annunciator/right_gear_safe", 
	["greenNose"] = "laminar/B738/annunciator/nose_gear_safe",
	["redLeft"] = "laminar/B738/annunciator/left_gear_transit", 
	["redRight"] = "laminar/B738/annunciator/right_gear_transit", 
	["redNose"] = "laminar/B738/annunciator/nose_gear_transit"
}

local cmdBaroStd = {
	["Left"] 	= "laminar/B738/EFIS_control/capt/push_button/std_press",
	["Right"] 	= "laminar/B738/EFIS_control/fo/push_button/std_press",
	["Standby"] = "laminar/B738/toggle_switch/standby_alt_baro_std"
}

local drefBaroStdNorm = {
	["Left"] 	= "laminar/B738/EFIS/baro_set_std_pilot",
	["Right"] 	= "laminar/B738/EFIS/baro_set_std_copilot",
	["Standby"] = "laminar/B738/gauges/standby_alt_std_mode"
}

local cmdBaroDown = {
	["Left"] 	= "laminar/B738/pilot/barometer_down",
	["Right"] 	= "laminar/B738/copilot/barometer_down",
	["Standby"] = "laminar/B738/knob/standby_alt_baro_dn"
}

local cmdBaroUp = {
	["Left"] 	= "laminar/B738/pilot/barometer_up",
	["Right"] 	= "laminar/B738/copilot/barometer_up",
	["Standby"] = "laminar/B738/knob/standby_alt_baro_up"
}

local cmdBaroModeDown = {
	["Left"] 	= "laminar/B738/EFIS_control/capt/baro_in_hpa_dn",
	["Right"] 	= "laminar/B738/EFIS_control/fo/baro_in_hpa_dn",
	["Standby"] = "laminar/B738/toggle_switch/standby_alt_hpin"
}

local cmdBaroModeUp = {
	["Left"] 	= "laminar/B738/EFIS_control/capt/baro_in_hpa_up",
	["Right"] 	= "laminar/B738/EFIS_control/fo/baro_in_hpa_up",
	["Standby"] = "laminar/B738/toggle_switch/standby_alt_hpin"
}

local drefBaroMode = {
	["Left"] 	= "laminar/B738/EFIS_control/capt/baro_in_hpa",
	["Right"] 	= "laminar/B738/EFIS_control/fo/baro_in_hpa",
	["Standby"] = "laminar/B738/gauges/standby_alt_mode"
}

local drefBaro = {
	["Left"] 	= "laminar/B738/EFIS/baro_sel_in_hg_pilot",
	["Right"] 	= "laminar/B738/EFIS/baro_sel_in_hg_copilot",
	["Standby"] = "laminar/B738/knobs/standby_alt_baro"
}

local drefCurrentBaro = "sim/weather/barometer_sealevel_inhg"

-- Baro
-- Set STD baro side "All","Left"=CAPT,"Right"=FO,"Standby"=STB mode 0=NORM, 1=STD 2=Toggle
function sysGeneral.actBaroStd(side, mode)
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroLeft then
		if mode == sysGeneral.BaroModeNormal and get(drefBaroStdNorm[sysGeneral.BaroLeft]) == 1 then
			command_once(cmdBaroStd[sysGeneral.BaroLeft])
		end
		if mode == sysGeneral.BaroModeStandard and get(drefBaroStdNorm[sysGeneral.BaroLeft]) == 0 then
			command_once(cmdBaroStd[sysGeneral.BaroLeft])
		end
		if mode == sysGeneral.modeToggle then
			command_once(cmdBaroStd[sysGeneral.BaroLeft])
		end
	end
	
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroRight then
		if mode == sysGeneral.BaroModeNormal and get(drefBaroStdNorm[sysGeneral.BaroRight]) == 1 then
			command_once(cmdBaroStd[sysGeneral.BaroRight])
		end
		if mode == sysGeneral.BaroModeStandard and get(drefBaroStdNorm[sysGeneral.BaroRight]) == 0 then
			command_once(cmdBaroStd[sysGeneral.BaroRight])
		end
		if mode == sysGeneral.modeToggle then
			command_once(cmdBaroStd[sysGeneral.BaroRight])
		end
	end
	
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroStandby then
		if mode == sysGeneral.BaroModeNormal and get(drefBaroStdNorm[sysGeneral.BaroStandby]) == 1 then
			command_once(cmdBaroStd[sysGeneral.BaroStandby])
		end
		if mode == sysGeneral.BaroModeStandard and get(drefBaroStdNorm[sysGeneral.BaroStandby]) == 0 then
			command_once(cmdBaroStd[sysGeneral.BaroStandby])
		end
		if mode == sysGeneral.modeToggle then
			command_once(cmdBaroStd[sysGeneral.BaroStandby])
		end
	end
end

-- baro up/down 1 unit "All","Left"=CAPT,"Right"=FO,"Standby"=STB, mode 0=dn,1=up
function sysGeneral.actBaroUpDown(side, mode)
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroLeft then
		if mode == sysGeneral.BaroDown then
			command_once(cmdBaroDown[sysGeneral.BaroLeft])
		end
		if mode == sysGeneral.BaroUp then
			command_once(cmdBaroUp[sysGeneral.BaroLeft])
		end
	end

	if side == sysGeneral.BaroAll or side == sysGeneral.BaroRight then
		if mode == sysGeneral.BaroDown then
			command_once(cmdBaroDown[sysGeneral.BaroRight])
		end
		if mode == sysGeneral.BaroUp then
			command_once(cmdBaroUp[sysGeneral.BaroRight])
		end
	end

	if side == sysGeneral.BaroAll or side == sysGeneral.BaroStandby then
		if mode == sysGeneral.BaroDown then
			command_once(cmdBaroDown[sysGeneral.BaroStandby])
		end
		if mode == sysGeneral.BaroUp then
			command_once(cmdBaroUp[sysGeneral.BaroStandby])
		end
	end
end

-- set baro with direct value side "All","Left"=CAPT,"Right"=FO,"Standby"=STB value inhg or mb 
function sysGeneral.setBaroValue(side, value)
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroLeft then
		set(drefBaro[sysGeneral.BaroLeft],value)
	end
	
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroRight then
		set(drefBaro[sysGeneral.BaroRight],value)
	end

	if side == sysGeneral.BaroAll or side == sysGeneral.BaroStandby then
		set(drefBaro[sysGeneral.BaroStandby],value)
	end
end

-- synchronize all baro with outside pressure
function sysGeneral.syncAllBaro()
	set(drefBaro[sysGeneral.BaroLeft],get(drefCurrentBaro))
	set(drefBaro[sysGeneral.BaroRight],get(drefCurrentBaro))
	set(drefBaro[sysGeneral.BaroStandby],get(drefCurrentBaro))
end

-- switch between mb and in side 0=ALL,1=CAPT,2=FO,3=STBY mode 0=in,1=mb,2=toggle
function sysGeneral.setBaroMode(side,mode)
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroLeft then
		if mode == sysGeneral.BaroInHg and get(drefBaroMode[sysGeneral.BaroLeft]) == 1 then
			command_once(cmdBaroModeDown[sysGeneral.BaroLeft])
		end
		if mode == sysGeneral.BaroMbar and get(drefBaroMode[sysGeneral.BaroLeft]) == 0 then
			command_once(cmdBaroModeUp[sysGeneral.BaroLeft])
		end
		if mode == sysGeneral.modeToggle then
			if get(drefBaroMode[sysGeneral.BaroLeft]) == 1 then
				command_once(cmdBaroModeDown[sysGeneral.BaroLeft])
			else
				command_once(cmdBaroModeUp[sysGeneral.BaroLeft])
			end
		end
	end

	if side == sysGeneral.BaroAll or side == sysGeneral.BaroRight then
		if mode == sysGeneral.BaroInHg and get(drefBaroMode[sysGeneral.BaroRight]) == 1 then
			command_once(cmdBaroModeDown[sysGeneral.BaroRight])
		end
		if mode == sysGeneral.BaroMbar and get(drefBaroMode[sysGeneral.BaroRight]) == 0 then
			command_once(cmdBaroModeUp[sysGeneral.BaroRight])
		end
		if mode == sysGeneral.modeToggle then
			if get(drefBaroMode[sysGeneral.BaroRight]) == 1 then
				command_once(cmdBaroModeDown[sysGeneral.BaroRight])
			else
				command_once(cmdBaroModeUp[sysGeneral.BaroRight])
			end
		end
	end

	if side == sysGeneral.BaroAll or side == sysGeneral.BaroStandby then
		if mode == sysGeneral.BaroInHg and get(drefBaroMode[sysGeneral.BaroStandby]) == 1 then
			command_once(cmdBaroModeDown[sysGeneral.BaroStandby])
		end
		if mode == sysGeneral.BaroMbar and get(drefBaroMode[sysGeneral.BaroStandby]) == 0 then
			command_once(cmdBaroModeUp[sysGeneral.BaroStandby])
		end
		if mode == sysGeneral.modeToggle then
			if get(drefBaroMode[sysGeneral.BaroStandby]) == 1 then
				command_once(cmdBaroModeDown[sysGeneral.BaroStandby])
			else
				command_once(cmdBaroModeUp[sysGeneral.BaroStandby])
			end
		end
	end
end


-- Gears
-- mode 0=UP 1=DOWN 2=TOGGLE 3=OFF
function sysGeneral.setGearMode(mode)
	if mode == sysGeneral.modeGearUp then
		command_once(cmdGearUp)
	end
	if mode == sysGeneral.modeGearDown then
		command_once(cmdGearDown)
	end
	if mode == sysGeneral.modeToggle then
		if get(drefGearHandle) == 0 then
			command_once(cmdGearDown)
		else
			command_once(cmdGearUp)
		end
	end
	if mode == sysGeneral.modeGearOff then
		command_once(cmdGearOff)
	end
end

function sysGeneral.getGearMode()
	return get(drefGearHandle)
end

-- light = "greenLeft", "greenRight", "greenNose", "redLeft", "redRight", "redNose"
function sysGeneral.getGearLight(light)
	return get(drefGearLights[light])
end

-- Park Brake
function sysGeneral.setParkBrakeMode(mode)
	if mode == sysGeneral.modeOff then
		set(drefParkBrake,0)
	end
	if mode == sysGeneral.modeOn then
		set(drefParkBrake,1)
	end
	if mode == sysGeneral.modeToggle then
		if get(drefParkBrake) == 0 then
			set(drefParkBrake,1) 
		else	
			set(drefParkBrake,0)
		end
	end
end

function sysGeneral.getParkBrakeMode()
	return get(drefParkBrake)
end

return sysGeneral
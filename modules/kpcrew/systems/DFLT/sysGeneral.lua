-- DFLT airplane 
-- aircraft general systems
local sysGeneral = {
	Off = 0,
	On = 1,
	Toggle = 2,
 	Up = 1,
	Down = 0,
	GearOff = 3,
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
	BaroInHg = 0,
	BaroMbar = 1
}

local drefParkBrake = "sim/cockpit2/controls/parking_brake_ratio"

local drefGearHandle = "sim/cockpit2/controls/gear_handle_down"
local cmdGearUp = "sim/flight_controls/landing_gear_up"
local cmdGearDown = "sim/flight_controls/landing_gear_down"

local drefGearLights = { 
	["greenLeft"] = "sim/flightmodel/movingparts/gear1def", 
	["greenRight"] = "sim/flightmodel/movingparts/gear2def", 
	["greenNose"] = "sim/flightmodel/movingparts/gear3def", 
}

local cmdBaroStd = {
	["Left"] 	= "sim/instruments/barometer_2992",
	["Right"] 	= "sim/instruments/barometer_2992",
	["Standby"] = "sim/instruments/barometer_2992"
}

local drefBaroStdNorm = {
	["Left"] 	= "laminar/B738/EFIS/baro_set_std_pilot",
	["Right"] 	= "laminar/B738/EFIS/baro_set_std_copilot",
	["Standby"] = "laminar/B738/gauges/standby_alt_std_mode"
}

local cmdDown = {
	["Left"] 	= "sim/instruments/barometer_down",
	["Right"] 	= "sim/instruments/barometer_copilot_down",
	["Standby"] = "sim/instruments/barometer_stby_down"
}

local cmdUp = {
	["Left"] 	= "sim/instruments/barometer_up",
	["Right"] 	= "sim/instruments/barometer_copilot_up",
	["Standby"] = "sim/instruments/barometer_stby_up"
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
	["Left"] 	= "sim/cockpit/misc/barometer_setting",
	["Right"] 	= "sim/cockpit/misc/barometer_setting2",
	["Standby"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby"
}

local drefCurrentBaro = "sim/weather/barometer_sealevel_inhg"

local drefMasterCaution = "sim/cockpit2/annunciators/master_caution"
local drefMasterWarning = "sim/cockpit2/annunciators/master_warning"

local drefDoorStatus = "sim/cockpit2/switches/door_open"

local drefDoors = {
	["LeftForward"] 	= 0,
	["RightForward"] 	= 4,
	["LeftAft"] 		= 3,
	["RightAft"] 		= 7,
	["CargoForward"]	= 8,
	["CargoAft"]		= 9
}

-- Honeycomb doors light
function sysGeneral.getDoorsLight()
	local sumit = get(drefDoorStatus,drefDoors["LeftForward"]) + 
		get(drefDoorStatus,drefDoors["RightForward"]) +
		get(drefDoorStatus,drefDoors["LeftAft"]) +
		get(drefDoorStatus,drefDoors["RightAft"]) + 	
		get(drefDoorStatus,drefDoors["CargoForward"]) +
		get(drefDoorStatus,drefDoors["CargoAft"])
	
	if sumit > 0 then 
		return 1
	else
		return 0
	end
end

-- Master warning
function sysGeneral.getMasterWarningLight()
	return get(drefMasterWarning)
end

-- Master caution
function sysGeneral.getMasterCautionLight()
	return get(drefMasterCaution)
end

-- Baro
-- Set STD baro side "All","Left"=CAPT,"Right"=FO,"Standby"=STB mode 0=NORM, 1=STD 2=Toggle
function sysGeneral.actBaroStd(side, mode)
	if mode == sysGeneral.BaroModeStandard then
		command_once(cmdBaroStd["Left"])
	end
	if mode == sysGeneral.BaroModeNormal then
		sysGeneral.syncAllBaro()	
	end
	if mode == sysGeneral.Toggle then
		if math.floor(get(drefBaro[sysGeneral.BaroLeft])*100) ~= 2992 then
			command_once(cmdBaroStd["Left"])
		else
			sysGeneral.syncAllBaro()	
		end
	end
end

-- baro up/down 1 unit "All","Left"=CAPT,"Right"=FO,"Standby"=STB, mode 0=dn,1=up
function sysGeneral.actBaroUpDown(side, mode)
	if side == sysGeneral.BaroAll or side == sysGeneral.BaroLeft then
		if mode == sysGeneral.Down then
			command_once(cmdDown[sysGeneral.BaroLeft])
		end
		if mode == sysGeneral.Up then
			command_once(cmdUp[sysGeneral.BaroLeft])
		end
	end

	if side == sysGeneral.BaroAll or side == sysGeneral.BaroRight then
		if mode == sysGeneral.Down then
			command_once(cmdDown[sysGeneral.BaroRight])
		end
		if mode == sysGeneral.Up then
			command_once(cmdUp[sysGeneral.BaroRight])
		end
	end

	if side == sysGeneral.BaroStandby then -- stby == left
		if mode == sysGeneral.Down then
			command_once(cmdDown[sysGeneral.BaroStandby])
		end
		if mode == sysGeneral.Up then
			command_once(cmdUp[sysGeneral.BaroStandby])
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
		if mode == sysGeneral.Toggle then
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
		if mode == sysGeneral.Toggle then
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
		if mode == sysGeneral.Toggle then
			if get(drefBaroMode[sysGeneral.BaroStandby]) == 1 then
				command_once(cmdBaroModeDown[sysGeneral.BaroStandby])
			else
				command_once(cmdBaroModeUp[sysGeneral.BaroStandby])
			end
		end
	end
end


-- Gears
-- mode 0=UP 1=DOWN 2=TOGGLE
function sysGeneral.setGearMode(mode)
	if mode == sysGeneral.Up then
		command_once(cmdGearUp)
	end
	if mode == sysGeneral.Down then
		command_once(cmdGearDown)
	end
	if mode == sysGeneral.Toggle then
		if get(drefGearHandle) == 0 then
			command_once(cmdGearDown)
		else
			command_once(cmdGearUp)
		end
	end
end

function sysGeneral.getGearMode()
	return get(drefGearHandle)
end

-- light = "greenLeft", "greenRight", "greenNose", "redLeft", "redRight", "redNose"
function sysGeneral.getGearLight(light)
	if light == GearLightGreenLeft then
		if get(drefGearLights[GearLightGreenLeft]) == 1 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightGreenRight then
		if get(drefGearLights[GearLightGreenRight]) == 1 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightGreenNose then
		if get(drefGearLights[GearLightGreenNose]) == 1 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightRedLeft then
		if get(drefGearLights[GearLightGreenLeft]) < 1 and get(drefGearLights[GearLightGreenLeft]) > 0 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightRedRight then
		if get(drefGearLights[GearLightGreenRight]) < 1 and get(drefGearLights[GearLightGreenRight]) > 0 then
			return 1
		else
			return 0
		end
	end
	if light == GearLightRedNose then
		if get(drefGearLights[GearLightGreenNose]) < 1 and get(drefGearLights[GearLightGreenNose]) > 0 then
			return 1
		else
			return 0
		end
	end
end

-- Park Brake
function sysGeneral.setParkBrakeMode(mode)
	if mode == sysGeneral.Off then
		set(drefParkBrake,0)
	end
	if mode == sysGeneral.On then
		set(drefParkBrake,1)
	end
	if mode == sysGeneral.Toggle then
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
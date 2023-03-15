-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

function kc_macro_state_cold_and_dark()
	sysGeneral.doorGroup:actuate(0)
	sysGeneral.doorL1:actuate(1)
	if get("sim/flightmodel2/misc/custom_slider_ratio[2]") == 0 then
		command_once("sim/operation/slider_03")
	end
	-- cockpit door open
	if get("sim/flightmodel2/misc/custom_slider_ratio[10]") == 0 then
		command_once("sim/operation/slider_11")
	end
	sysElectric.gpuSwitch:actuate(0)
	if get("laminar/md82/safeguard[2]") > 0 then
		command_once("laminar/md82cmd/safeguard02")
	end
	-- antiskid off
	if get("sim/cockpit2/switches/generic_lights_switch[35]") > 0 then
		command_once("sim/lights/generic_36_light_tog")
	end
	sysControls.yawDamper:actuate(0)
end

function kc_macro_state_turnaround()
end

-- external lights all off
function kc_macro_ext_lights_off()
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
end

-- function kc_bck_()
-- end

return sysMacros
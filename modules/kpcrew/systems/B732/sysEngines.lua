-- B732 airplane 
-- Engine related functionality

local sysEngines = {
}

-- Autothrottle logic for FJS 732 adapted from olejorga's otto_throttle
dataref("fjs732_speed", "sim/flightmodel/position/indicated_airspeed", "readonly")
dataref("fjs732_target_speed", "sim/cockpit2/autopilot/airspeed_dial_kts_mach", "readonly")
dataref("fjs732_throttle_setting", "sim/cockpit2/engine/actuators/throttle_ratio_all", "writable")
dataref("fjs732_sim_rate", "sim/time/sim_speed", "readonly")
local fjs732_last_speed = fjs732_speed

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

--------- Switches

local drefEngine1Fire 	 = "FJS/732/FireProtect/Eng1FireLight"
local drefEngine2Fire 	 = "FJS/732/FireProtect/Eng2FireLight"
local drefAPUFire 		 = "FJS/732/FireProtect/APU_FireLight"
local drefEngine1Starter = "FJS/732/Eng/Engine1StartKnob"
local drefEngine2Starter = "FJS/732/Eng/Engine2StartKnob"
local drefEngine1Oil 	 = "FJS/732/Eng/OilPress1Needle"
local drefEngine2Oil 	 = "FJS/732/Eng/OilPress2Needle"

-- Ottothrottle functionality
kh_otto_throttle_on = true
function fjs732_adjust_thrust()
	-- Adjusts the throttle setting either up or down, 
	-- based on the current speed & the target speed.

	-- Increases the throttle setting by
	-- a factor of x on every call
	function fjs732_increase_thrust(factor)
	-- Makes sure throttle is not set above the highest setting
		if (fjs732_throttle_setting + factor) == 1 then
			fjs732_throttle_setting = 1
		elseif fjs732_throttle_setting < 1 then
			fjs732_throttle_setting = fjs732_throttle_setting + factor
		end
	end

    -- Decreases the throttle setting by
    -- a factor of x on every call
	function fjs732_decrease_thrust(factor)
		-- Makes sure throttle is not set below the lowest setting
		if (fjs732_throttle_setting - factor) == 1 then
			fjs732_throttle_setting = 0
		elseif fjs732_throttle_setting > 0 then
			fjs732_throttle_setting = fjs732_throttle_setting - factor
		end
	end

	-- If "otto-throttle" is enabled & the sim is not paused, do this
	if kh_otto_throttle_on == true and sim_rate ~= 0 then
		-- Calculate the diff between current & target speed
		local difference = math.abs((fjs732_speed - fjs732_target_speed))

		-- If the speed is lower than the target and last speed, increase
		if fjs732_speed < fjs732_target_speed and fjs732_speed < fjs732_last_speed then
			-- If diff is less than 5 increase gently, if not, fast
			if difference < 5 then
				fjs732_increase_thrust(0.0001)
			else
				fjs732_increase_thrust(0.001)
			end
		end

		-- If the speed is higher than the target and last speed, decrease
		if fjs732_speed > fjs732_target_speed and fjs732_speed > fjs732_last_speed then
			-- If diff is less than 5 decrease gently, if not, fast
			if difference < 5 then
				fjs732_decrease_thrust(0.0001)
			else
				fjs732_decrease_thrust(0.001)
			end
		end

		-- Updates the last recorded speed
		fjs732_last_speed = fjs732_speed
	end
end

do_every_frame("fjs732_adjust_thrust()")

-- ------------------------
sysEngines.ottoThrottle = TwoStateCustomSwitch:new("atsimul","",0,
	function () kh_otto_throttle_on = true end,
	function () kh_otto_throttle_on = false end,
	function () if kh_otto_throttle_on then kh_otto_throttle_on = false else kh_otto_throttle_on = true end end,
	function () if kh_otto_throttle_on then return 1 else return 0 end end)

-- Reverse Toggle
sysEngines.reverseToggle = TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,"sim/engines/thrust_reverse_toggle") 

-- engine start levers (fuel)
sysEngines.startLever1 = TwoStateDrefSwitch:new("","FJS/732/fuel/FuelMixtureLever1",0)
sysEngines.startLever2 = TwoStateDrefSwitch:new("","FJS/732/fuel/FuelMixtureLever2",0)

sysEngines.startLeverGroup = SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- OVHT Test
sysEngines.ovhtFireTestSwitch = TwoStateDrefSwitch:new("","FJS/732/FireProtect/FireTestSwitch",0)

-- IGN select
sysEngines.ignSelectSwitch = InopSwitch:new("ignSelect")

-- STARTER Switches
sysEngines.engStart1Switch = TwoStateDrefSwitch:new("","FJS/732/Eng/Engine1StartKnob",0)
sysEngines.engStart2Switch = TwoStateDrefSwitch:new("","FJS/732/Eng/Engine2StartKnob",0)

sysEngines.engStarterGroup = SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

----------- Annunciators

-- ENGINE FIRE annunciator
sysEngines.engineFireAnc = CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 or get(drefAPUFire) == 1 then
		return 1
	else
		return 0
	end
end)

-- OIL PRESSURE annunciator
sysEngines.OilPressureAnc = CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngine1Oil) == 0 or get(drefEngine2Oil) == 0 then
		return 1
	else
		return 0
	end
end)

-- ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get(drefEngine1Starter) == 0 and get(drefEngine2Starter) == 0 then
		return 0
	else
		return 1
	end
end)

-- Reverse Thrust
sysEngines.reverseAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get("sim/cockpit/warnings/annunciators/reverse",0) > 0 then
		return 1
	else
		return 0
	end
end)

sysEngines.reverseLever1 = InopSwitch:new("") --,"laminar/B738/flt_ctrls/reverse_lever1",0)
sysEngines.reverseLever2 = InopSwitch:new("") --,"laminar/B738/flt_ctrls/reverse_lever2",0)

sysEngines.thrustLever1 = InopSwitch:new ("") --,"laminar/B738/engine/thrust1_leveler",0)
sysEngines.thrustLever2 = InopSwitch:new ("") --,"laminar/B738/engine/thrust2_leveler",0)

-- Autothrottle simulation (Ottothrottle)



return sysEngines
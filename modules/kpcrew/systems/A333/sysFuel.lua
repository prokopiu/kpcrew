-- A333 airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysFuel = {
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

require "kpcrew.systems.DFLT.sysFuel"

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = CustomAnnunciator:new("fuellow",
function ()
	if get("laminar/A333/annun/fuel/ctr_tank_L_fault",0) > 0 or get("laminar/A333/annun/fuel/ctr_tank_R_fault",0) > 0 or get("laminar/A333/annun/fuel/L1_fault",0) > 0 or get("laminar/A333/annun/fuel/L2_fault",0) > 0 or get("laminar/A333/annun/fuel/R1_fault",0) > 0 or get("laminar/A333/annun/fuel/R2_fault",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- AUX FUEL PUMP ANC
sysFuel.auxFuelPumpsAnc = CustomAnnunciator:new("auxfuel",
function ()
	-- if sysFuel.allFuelPumpGroup:getStatus() > 0 then 
		-- return 1
	-- else
		return 0
	-- end
end)

return sysFuel
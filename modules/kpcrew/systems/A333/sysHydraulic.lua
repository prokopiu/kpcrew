-- A333 airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysHydraulic = {
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

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if 	get("laminar/A333/annun/hyd/elec_blue_fault",0) == 1 or 
		get("laminar/A333/annun/hyd/elec_green_fault",0) == 1 or 
		get("laminar/A333/annun/hyd/elec_yellow_fault",0) == 1 or 
		get("laminar/A333/annun/hyd/eng1_blue_fault",0) == 1 or 
		get("laminar/A333/annun/hyd/eng2_green_fault",0) == 1 or 
		get("laminar/A333/annun/hyd/eng2_yellow_fault",0) == 1 or 
		get("laminar/A333/annun/hyd/eng1_green_fault",0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic
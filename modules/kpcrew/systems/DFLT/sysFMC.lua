-- DFLT airplane 
-- FMC related functionality

-- @classmod sysFMC
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysFMC = {
}

logMsg("DFLT sysFMC")

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"


-- Intertial reference System
sysFMC.irs1		= InopSwitch:new("irs1")
sysFMC.irs2		= InopSwitch:new("irs1")
sysFMC.irs3		= InopSwitch:new("irs1")
sysFMC.irsGroup = SwitchGroup:new("irsgroup")
sysFMC.irsGroup:addSwitch(sysFMC.irs1)
sysFMC.irsGroup:addSwitch(sysFMC.irs2)
sysFMC.irsGroup:addSwitch(sysFMC.irs3)


return sysFMC
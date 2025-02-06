-- Laminar A330 variants airplane 
-- FMC related functionality

-- @classmod sysFMC
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

sysFMC = require("kpcrew.systems.DFLT.sysFMC")

logMsg("A33L sysFMC")

-- Intertial reference System
sysFMC.irs1		= TwoStateToggleSwitch:new("irs1","laminar/A333/buttons/adirs/ir1_knob_pos",0,
	"laminar/A333/buttons/adirs/ir1_toggle")
sysFMC.irs2		= TwoStateToggleSwitch:new("irs1","laminar/A333/buttons/adirs/ir2_knob_pos",0,
	"laminar/A333/buttons/adirs/ir2_toggle")
sysFMC.irs3		= TwoStateToggleSwitch:new("irs1","laminar/A333/buttons/adirs/ir3_knob_pos",0,
	"laminar/A333/buttons/adirs/ir3_toggle")
sysFMC.irsGroup = SwitchGroup:new("irsgroup")
sysFMC.irsGroup:addSwitch(sysFMC.irs1)
sysFMC.irsGroup:addSwitch(sysFMC.irs2)
sysFMC.irsGroup:addSwitch(sysFMC.irs3)

return sysFMC

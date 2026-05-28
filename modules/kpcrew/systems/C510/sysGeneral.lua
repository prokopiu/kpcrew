-- C510 airplane 
-- aircraft general systems

-- @classmod sysGeneral
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("C510 sysGeneral")

sysGeneral.doorGroup 		= SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)

sysGeneral.doorsAnc 		= CustomAnnunciator:new("doors", 
function () 
	local sum = get("sim/cockpit2/switches/door_open",0)
	if sum > 0 then return 1 else return 0 end end)
	
--------- Macros

-- ====================================== General settings like doors and external objects
function kc_macro_doors_ext(flightphase)
	-- Cold & dark
	if flightphase == kc_phase_colddark then
		sysGeneral.doorL1:actuate(1)
	elseif flightphase == kc_phase_turnaround then
		sysGeneral.doorL1:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysGeneral.doorL1:actuate(0)
	elseif flightphase == kc_phase_shutdown then
		sysGeneral.doorL1:actuate(1)
	else
		logMsg("Invalid flightphase")
	end
end

return sysGeneral
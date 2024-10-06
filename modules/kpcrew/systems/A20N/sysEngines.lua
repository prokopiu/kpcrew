-- DFLT airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysEngines = {
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

local drefReverserState		= "sim/cockpit2/annunciators/reverser_on"
local drefEngine1Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter 	= "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire 		= "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire 		= "sim/cockpit2/annunciators/engine_fires"

logMsg ("Engine A20N")

----------- Switches

-- Starter Switches
sysEngines.engStart1Switch	= InopSwitch:new("starter1")
sysEngines.engStart2Switch	= InopSwitch:new("starter2")
sysEngines.engStart3Switch	= InopSwitch:new("starter3")
sysEngines.engStart4Switch	= InopSwitch:new("starter4")
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	-- if get(drefEngine1Starter,0) > 0 and get(drefEngine2Starter,1) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)


-- Reversers
sysEngines.reverser1 		= TwoStateCustomSwitch:new("reverse1",drefReverserState,-1,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_1")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_1")
	end,
	function () 
	end	
)
sysEngines.reverser2 		= TwoStateCustomSwitch:new("reverse2",drefReverserState,1,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_2")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_2")
	end,
	function () 
	end	
)
sysEngines.reverser3 		= TwoStateCustomSwitch:new("reverse3",drefReverserState,2,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_3")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_3")
	end,
	function () 
	end	
)
sysEngines.reverser4 		= TwoStateCustomSwitch:new("reverse4",drefReverserState,3,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_4")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_4")
	end,
	function () 
	end	
)
sysEngines.reverserGroup 	= SwitchGroup:new("reversers")
sysEngines.reverserGroup:addSwitch(sysEngines.reverser1)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser2)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser3)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser4)

-- ** Magnetos
sysEngines.magnetoOff		= TwoStateCustomSwitch:new("magnetoOff","",0,
	function () 
		command_once("sim/magnetos/magnetos_off_1")
	end,
	function () 
	end,
	function () 
	end	
)
sysEngines.magnetoL		= TwoStateCustomSwitch:new("magnetoL","",0,
	function () 
		command_once("sim/magnetos/magnetos_left_1")
	end,
	function () 
	end,
	function () 
	end	
)
sysEngines.magnetoR		= TwoStateCustomSwitch:new("magnetoR","",0,
	function () 
		command_once("sim/magnetos/magnetos_right_1")
	end,
	function () 
	end,
	function () 
	end	
)
sysEngines.magnetoBoth		= TwoStateCustomSwitch:new("magnetoBoth","",0,
	function () 
		command_once("sim/magnetos/magnetos_both_1")
	end,
	function () 
	end,
	function () 
	end	
)
sysEngines.magnetoStartOn		= TwoStateCustomSwitch:new("magnetoStart","",0,
	function () 
		command_begin("sim/starters/engage_start_run_1")
	end,
	function () 
	end,
	function () 
	end	
)
sysEngines.magnetoStartStop		= TwoStateCustomSwitch:new("magnetoStart","",0,
	function () 
		command_end("sim/starters/engage_start_run_1")
	end,
	function () 
	end,
	function () 
	end	
)


----------- Annunciators

-- ** ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire,0) > 0 or get(drefEngine2Fire,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- Oil Quantity
sysEngines.oilqty1 = SimpleAnnunciator:new("oilqty1","sim/cockpit2/engine/indicators/oil_quantity_ratio",-1)
sysEngines.oilqty2 = SimpleAnnunciator:new("oilqty2","sim/cockpit2/engine/indicators/oil_quantity_ratio",1)
sysEngines.oilqty3 = SimpleAnnunciator:new("oilqty3","sim/cockpit2/engine/indicators/oil_quantity_ratio",2)
sysEngines.oilqty4 = SimpleAnnunciator:new("oilqty4","sim/cockpit2/engine/indicators/oil_quantity_ratio",3)


-- ** Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("enginestarter",
function ()
	if get("sim/cockpit/warnings/annunciators/reverse") > 0 then
		return 1
	else
		return 0
	end
end)

return sysEngines
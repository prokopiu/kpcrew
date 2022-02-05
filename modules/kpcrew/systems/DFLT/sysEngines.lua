-- DFLT airplane 
-- Engine related functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysEngines = {
}

local drefEngine1Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine1Oil = "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine2Oil = "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngine1Fire = "sim/cockpit2/annunciators/engine_fires"
local drefEngine2Fire = "sim/cockpit2/annunciators/engine_fires"

sysEngines.Switches = {
	-- Reverse Thrust
	["reversethrust"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit/warnings/annunciators/reverse", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOn] = "sim/engines/thrust_reverse_hold"
				}
			}
		}
	}
}

sysEngines.Annunciators = {
	-- ENGINE FIRE annunciator
	["enginefire"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefEngine1Fire,0) > 0 or get(drefEngine2Fire,1) > 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- OIL PRSSURE annunciator
	["oilpressure"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefEngine1Oil,0) > 0 or get(drefEngine2Oil,1) > 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- ENGINE STARTER annunciator
	["starter"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefEngine1Starter,0) > 0 and get(drefEngine2Starter,1) > 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- Reverse Thrust
	["reversethrust"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get("sim/cockpit/warnings/annunciators/reverse",0) > 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	}
}

function sysEngines.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysEngines.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysEngines.Switches,element,iloop,mode)	
		end
	else
		act(sysEngines.Switches,element,instance,mode)
	end
end

function sysEngines.getMode(element,instance)
	return status(sysEngines.Switches,element,instance)
end

function sysEngines.getAnnunciator(element,instance)
	return status(sysEngines.Annunciators,element,instance)
end

return sysEngines
-- B738 airplane 
-- Engine related functionality

local sysEngines = {
}

local drefEngine1Fire 	 = "laminar/B738/annunciator/engine1_fire"
local drefEngine2Fire 	 = "laminar/B738/annunciator/engine2_fire"
local drefAPUFire 		 = "laminar/B738/annunciator/apu_fire"
local drefEngine1Starter = "laminar/B738/air/engine1/starter_valve"
local drefEngine2Starter = "laminar/B738/air/engine2/starter_valve"
local drefEngine1Oil 	 = "laminar/B738/engine/eng1_oil_press"
local drefEngine2Oil 	 = "laminar/B738/engine/eng2_oil_press"

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
						if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 or get(drefAPUFire) == 1 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { ["name"] = "", ["index"] = 0 },
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
						if get(drefEngine1Oil) == 0 or get(drefEngine2Oil) == 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { ["name"] = "", ["index"] = 0 },
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
						if get(drefEngine1Starter) == 0 and get(drefEngine2Starter) == 0 then
							return 0
						else
							return 1
						end
					end,
				["dataref"] = { ["name"] = "", ["index"] = 0 },
				["commands"] = { "" }
			}		
		}
	},
	-- Reverse Thrust
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
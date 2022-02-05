-- DFLT airplane 
-- Fuel related functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysFuel = {
}

local drefFuelPressLow = "sim/cockpit2/annunciators/fuel_pressure_low"

sysFuel.Switches = {
}

sysFuel.Annunciators = {
	-- FUEL PRESSURE LOW annunciator
	["fuelprslow"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefFuelPressLow,0) == 1 or get(drefFuelPressLow,1) == 1 or get(drefFuelPressLow,2) == 1 or get(drefFuelPressLow,3) == 1 then
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

function sysFuel.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysFuel.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysFuel.Switches,element,iloop,mode)	
		end
	else
		act(sysFuel.Switches,element,instance,mode)
	end
end

function sysFuel.getMode(element,instance)
	return status(sysFuel.Switches,element,instance)
end

function sysFuel.getAnnunciator(element,instance)
	return status(sysFuel.Annunciators,element,instance)
end

return sysFuel
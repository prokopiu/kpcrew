-- B738 airplane 
-- Fuel related functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysFuel = {
}

local drefFuelPressC1 = "laminar/B738/annunciator/low_fuel_press_c1"
local drefFuelPressC2 = "laminar/B738/annunciator/low_fuel_press_c2"
local drefFuelPressL1 = "laminar/B738/annunciator/low_fuel_press_l1"
local drefFuelPressL2 = "laminar/B738/annunciator/low_fuel_press_l2"
local drefFuelPressR1 = "laminar/B738/annunciator/low_fuel_press_r1"
local drefFuelPressR2 = "laminar/B738/annunciator/low_fuel_press_r2"

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
						if get(drefFuelPressC1,0) == 1 or get(drefFuelPressC2,0) == 1 or get(drefFuelPressL1,0) == 1 or get(drefFuelPressL2,0) == 1 or get(drefFuelPressR1,0) == 1 or get(drefFuelPressR2,0) == 1 then
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
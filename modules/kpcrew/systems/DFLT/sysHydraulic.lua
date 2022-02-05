-- DFLT airplane 
-- Hydraulic system functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysHydraulic = {
}

local drefHydPressure1 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

sysHydraulic.Switches = {
}

sysHydraulic.Annunciators = {
	-- LOW HYDRAULIC annunciator
	["lowhydraulic"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 then
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

function sysHydraulic.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysHydraulic.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysHydraulic.Switches,element,iloop,mode)	
		end
	else
		act(sysHydraulic.Switches,element,instance,mode)
	end
end

function sysHydraulic.getMode(element,instance)
	return status(sysHydraulic.Switches,element,instance)
end

function sysHydraulic.getAnnunciator(element,instance)
	return status(sysHydraulic.Annunciators,element,instance)
end

return sysHydraulic
-- B738 airplane 
-- Hydraulic system functionality
local sysHydraulic = {
}

local drefElHydPressure1 = "laminar/B738/annunciator/hyd_el_press_a"
local drefElHydPressure2 = "laminar/B738/annunciator/hyd_el_press_b"
local drefHydPressure1 = "laminar/B738/annunciator/hyd_press_a"
local drefHydPressure2 = "laminar/B738/annunciator/hyd_press_b"

sysHydraulic.hydraulic = {
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
						if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 or get(drefElHydPressure1,0) == 1 or get(drefElHydPressure2,0) == 1 then
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
		local item = sysHydraulic.hydraulic[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysHydraulic.hydraulic,element,iloop,mode)	
		end
	else
		act(sysHydraulic.hydraulic,element,instance,mode)
	end
end

function sysHydraulic.getMode(element,instance)
		return status(sysHydraulic.hydraulic,element,instance)
end

return sysHydraulic
-- DFLT airplane 
-- Anti Ice functionality
local sysAice = {
}

local drefAiceWing = "sim/cockpit/switches/anti_ice_surf_heat"
local drefAiceEng = "sim/cockpit/switches/anti_ice_inlet_heat"

sysAice.ice = {
	-- ANTI ICE annunciator
	["antiice"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefAiceWing) > 0 or get(drefAiceEng) > 0  then
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

function sysAice.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysAice.ice[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysAice.ice,element,iloop,mode)	
		end
	else
		act(sysAice.ice,element,instance,mode)
	end
end

function sysAice.getMode(element,instance)
		return status(sysAice.ice,element,instance)
end

return sysAice
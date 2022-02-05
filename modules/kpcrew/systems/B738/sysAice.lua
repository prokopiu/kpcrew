-- B738 airplane 
-- Anti Ice functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysAice = {
}

local drefAiceWingLeft = "laminar/B738/annunciator/wing_ice_on_L"
local drefAiceWingRight = "laminar/B738/annunciator/wing_ice_on_R"
local drefAiceEng1 = "laminar/B738/annunciator/cowl_ice_on_0"
local drefAiceEng2 = "laminar/B738/annunciator/cowl_ice_on_1"

sysAice.Switches = {
}

sysAice.Annunciators = {
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
						if get(drefAiceWingLeft) > 0 or get(drefAiceWingRight) > 0 or get(drefAiceEng1) > 0 or get(drefAiceEng2) > 0 then
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
		local item = sysAice.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysAice.Switches,element,iloop,mode)	
		end
	else
		act(sysAice.Switches,element,instance,mode)
	end
end

function sysAice.getMode(element,instance)
	return status(sysAice.Switches,element,instance)
end

function sysAice.getAnnunciator(element,instance)
	return status(sysAice.Annunciators,element,instance)
end

return sysAice
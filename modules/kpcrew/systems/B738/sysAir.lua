-- B738 airplane 
-- Air and Pneumatics functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysAir = {
}

local drefPackLeftANC = "laminar/B738/annunciator/pack_left"
local drefPackRightANC = "laminar/B738/annunciator/pack_right"

sysAir.Switches = {
}

sysAir.Annunciators = {
	-- VACUUM annunciator
	["vacuum"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefPackLeftANC,0) == 1 or get(drefPackRightANC,0) == 1 then
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

function sysAir.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysAir.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysAir.Switches,element,iloop,mode)	
		end
	else
		act(sysAir.Switches,element,instance,mode)
	end
end

function sysAir.getMode(element,instance)
	return status(sysAir.Switches,element,instance)
end

function sysAir.getAnnunciator(element,instance)
	return status(sysAir.Annunciators,element,instance)
end

return sysAir
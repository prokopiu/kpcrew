-- B738 airplane 
-- Air and Pneumatics functionality
local sysAir = {
}

local drefPackLeftANC = "laminar/B738/annunciator/pack_left"
local drefPackRightANC = "laminar/B738/annunciator/pack_right"

sysAir.air = {
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
		local item = sysAir.air[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysAir.air,element,iloop,mode)	
		end
	else
		act(sysAir.air,element,instance,mode)
	end
end

function sysAir.getMode(element,instance)
		return status(sysAir.air,element,instance)
end

return sysAir
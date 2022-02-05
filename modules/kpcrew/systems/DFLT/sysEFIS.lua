-- B738 airplane 
-- EFIS functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysEFIS = {
}

function sysLights.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysLights.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysLights.Switches,element,iloop,mode)	
		end
	else
		act(sysLights.Switches,element,instance,mode)
	end
end

function sysLights.getMode(element,instance)
	return status(sysLights.Switches,element,instance)
end

function sysLights.getAnnunciator(element,instance)
	return status(sysLights.Annunciators,element,instance)
end

return sysEFIS
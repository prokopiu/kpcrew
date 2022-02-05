-- DFLT  airplane 
-- Electric system functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysElectric = {
}

sysElectric.Switches = {
}

sysElectric.Annunciators = {
	-- LOW VOLTAGE annunciator
	["lowvoltage"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/annunciators/low_voltage", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- APU RUNNING annunciator
	["apurunning"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/electrical/APU_running", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	}
}

function sysElectric.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysElectric.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysElectric.Switches,element,iloop,mode)	
		end
	else
		act(sysElectric.Switches,element,instance,mode)
	end
end

function sysElectric.getMode(element,instance)
	return status(sysElectric.Switches,element,instance)
end

function sysElectric.getAnnunciator(element,instance)
	return status(sysElectric.Annunciators,element,instance)
end

return sysElectric
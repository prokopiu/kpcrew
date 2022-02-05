-- DFLT airplane 
-- MCP functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysMCP = {
}

local drefVORLocLight = "sim/cockpit2/autopilot/nav_status"
local drefLNAVLight = "sim/cockpit2/radios/actuators/HSI_source_select_pilot"
local drefSPDLight = "sim/cockpit2/autopilot/autothrottle_on"
local drefVSLight = "sim/cockpit2/autopilot/vvi_status"
local drefVNAVLight = "sim/cockpit2/autopilot/fms_vnav"

sysMCP.Switches = {
}

sysMCP.Annunciators = {
	-- HDG Select/mode annunciator
	["hdganc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/autopilot/heading_mode", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- NAV mode annunciator
	["navanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefVORLocLight) > 0 or get(drefLNAVLight) > 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- APR Select/mode annunciator
	["apranc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/autopilot/approach_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- SPD mode annunciator
	["spdanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/autopilot/autothrottle_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- Vertical mode annunciator
	["vspanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefVSLight) > 0 or get(drefVNAVLight) > 0 then
							return 1
						else
							return 0
						end
					end,
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- ALT mode annunciator
	["altanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/autopilot/altitude_hold_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- A/P mode annunciator
	["autopilotanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/autopilot/autopilot_on_or_cws", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- BC mode annunciator
	["bcanc"] = {
		["type"] = typeInop,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	}
}

function sysMCP.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysMCP.Switches[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysMCP.Switches,element,iloop,mode)	
		end
	else
		act(sysMCP.Switches,element,instance,mode)
	end
end

function sysMCP.getMode(element,instance)
	return status(sysMCP.Switches,element,instance)
end

function sysMCP.getAnnunciator(element,instance)
	return status(sysMCP.Annunciators,element,instance)
end

return sysMCP
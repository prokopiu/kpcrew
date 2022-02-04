-- DFLT airplane (X-Plane 11 default)
-- aircraft lights specific functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysLights = {
}

local drefLandingLights = "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights = "sim/cockpit2/switches/generic_lights_switch"

sysLights.Switches = {
	-- Beacons or Anticollision Lights, single, onoff, command driven
	["beacon"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit/electrical/beacon_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] = "sim/lights/beacon_lights_off",
					[modeOn] = "sim/lights/beacon_lights_on",
					[modeToggle] = "sim/lights/beacon_lights_toggle"
				}
			}
		}
	},
	-- Position Lights, single onoff command driven
	["position"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/navigation_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"sim/lights/nav_lights_off",
					[modeOn] = "sim/lights/nav_lights_on",
					[modeToggle] = "sim/lights/nav_lights_toggle"
				}
			}
		}
	},
	-- Strobe Lights, single onoff command driven
	["strobes"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/strobe_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"sim/lights/strobe_lights_off",
					[modeOn] = "sim/lights/strobe_lights_on",
					[modeToggle] = "sim/lights/strobe_lights_toggle"
				}
			}
		}
	},
	-- Taxi/Nose Lights, single onoff command driven
	["taxi"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/taxi_light_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"sim/lights/taxi_lights_off",
					[modeOn] = "sim/lights/taxi_lights_on",
					[modeToggle] = "sim/lights/taxi_lights_toggle"
				}
			}
		}
	},
	-- Landing Lights, single onoff command driven
	["landing"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 4,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefLandingLights, ["index"] = 0 },
				["dataref"] = { ["name"] = drefLandingLights, ["index"] = 0 },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = drefLandingLights, ["index"] = 1 },
				["dataref"] = { ["name"] = drefLandingLights, ["index"] = 1 },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = drefLandingLights, ["index"] = 2 },
				["dataref"] = { ["name"] = drefLandingLights, ["index"] = 2 },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = drefLandingLights, ["index"] = 3 },
				["dataref"] = { ["name"] = drefLandingLights, ["index"] = 3 },
				["commands"] = { "" }
			}
		}
	},
	-- Logo Light
	["logo"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 0 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 0 },
				["commands"] = { "" }
			}
		}
	},
	-- RWY Turnoff
	["runway"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 2,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 1 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 1 },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 2 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 2 },
				["commands"] = { "" }
			}
		}
	},
	-- Wing Lights
	["wing"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 3 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 3 },
				["commands"] = { "" }
			}
		}
	},
	-- Wheel well Lights
	["wheel"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 5 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 5 },
				["commands"] = { "" }
			}
		}
	},
	-- Dome Light
	["dome"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit/electrical/cockpit_lights", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit/electrical/cockpit_lights", ["index"] = 0 },
				["commands"] = { "" }
			}
		}
	},
	-- Instrument Lights
	["instruments"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/instrument_brightness_ratio", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/instrument_brightness_ratio", ["index"] = 0 },
				["commands"] = { "" }
			}
		}
	}
}	

sysLights.Annunciators = {
	-- annunciator to mark any landing lights on
	["landinglights"] = { 
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefLandingLights,0) > 0 or get(drefLandingLights,1) > 0  or get(drefLandingLights,2) > 0 or get(drefLandingLights,3) > 0 then
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
	-- Beacons or Anticollision Light(s) status
	["beacon"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit/electrical/beacon_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Position Light(s) status
	["position"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/navigation_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Strobe Light(s) status
	["strobes"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/strobe_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Taxi Light(s) status
	["taxi"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/taxi_light_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Logo Light(s) status
	["logo"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- runway turnoff lights
	["runway"] = { 
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefGenericLights,1) > 0 or get(drefGenericLights,2) > 0 then
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
	-- Wing Light(s) status
	["wing"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 3 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Wheel well Light(s) status
	["wheel"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 5 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Dome Light(s) status
	["dome"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get( "sim/cockpit/electrical/cockpit_lights",0) ~= 0 then
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
	-- Instrument Light(s) status
	["instruments"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/instrument_brightness_ratio", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	}
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

return sysLights
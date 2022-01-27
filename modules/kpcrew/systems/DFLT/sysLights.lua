-- DFLT airplane (X-Plane 11 default)
-- aircraft lights specific functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysLights = {
}
	
sysLights.Lights = {
	-- Beacons or Anticollision Lights, single, onoff, command driven
	["beacons"] = {
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 0 },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 1 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 1 },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 2 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 2 },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 3 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/landing_lights_switch", ["index"] = 3 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 1 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 1 },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 2 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 2 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 3 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 3 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 5 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 5 },
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

function sysLights.setSwitch(lights, instance, mode)
	if lights == "runway" then
		if instance == -1 then
			act(sysLights.Lights,lights,0,mode)
			act(sysLights.Lights,lights,1,mode)
		else
			act(sysLights.Lights,lights,instance,mode)
		end
	elseif lights == "landing" then
		if instance == -1 then
			act(sysLights.Lights,lights,0,mode)
			act(sysLights.Lights,lights,1,mode)
			act(sysLights.Lights,lights,2,mode)
			act(sysLights.Lights,lights,3,mode)
		else
			act(sysLights.Lights,lights,instance,mode)
		end
	else
		act(sysLights.Lights,lights,instance,mode)
	end
end

function sysLights.getMode(lights,instance)
	return status(sysLights.Lights,lights,instance)
end


return sysLights
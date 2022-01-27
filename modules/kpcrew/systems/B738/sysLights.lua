-- B738 airplane (X-Plane 11 default)
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
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/navigation_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/toggle_switch/position_light_strobe",
					[modeOn] = "laminar/B738/toggle_switch/position_light_steady"
				}
			}
		}
	},
	-- Strobe Lights, single onoff command driven
	["strobes"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/navigation_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/toggle_switch/position_light_off",
					[modeOn] = "laminar/B738/toggle_switch/position_light_strobe"
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
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/taxi_light_brightness_pos", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/toggle_switch/taxi_light_brightness_off",
					[modeOn] = "laminar/B738/toggle_switch/taxi_light_brightness_on",
					[modeToggle] = "laminar/B738/toggle_switch/taxi_light_brigh_toggle"
				}
			}
		}
	},
	-- Landing Lights, single onoff command driven
	["landing"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 4,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/lights/land_ret_left_pos", ["index"] = 0 },
				["dataref"] = { ["name"] = "laminar/B738/lights/land_ret_left_pos", ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_ret_left_off",
					[modeOn] = "laminar/B738/switch/land_lights_ret_left_on"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/lights/land_ret_right_pos", ["index"] = 0 },
				["dataref"] = { ["name"] = "laminar/B738/lights/land_ret_right_pos", ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_ret_right_off",
					[modeOn] = "laminar/B738/switch/land_lights_ret_right_on"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "laminar/B738/switch/land_lights_left_pos", ["index"] = 0 },
				["dataref"] = { ["name"] = "laminar/B738/switch/land_lights_left_pos", ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_left_off",
					[modeOn] = "laminar/B738/switch/land_lights_left_on"
				}
			},
			[3] = {
				["drefStatus"] = { ["name"] = "laminar/B738/switch/land_lights_right_pos", ["index"] = 0 },
				["dataref"] = { ["name"] = "laminar/B738/switch/land_lights_right_pos", ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_right_off",
					[modeOn] = "laminar/B738/switch/land_lights_right_on"
				}
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
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/logo_light", ["index"] = 0 },
				["dataref"] = { ["name"] = "laminar/B738/toggle_switch/logo_light", ["index"] = 0 },
				["commands"] = { "" }
			}
		}
	},
	-- RWY Turnoff
	["runway"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/rwy_light_left", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/rwy_light_left_off",
					[modeOn] = "laminar/B738/switch/rwy_light_left_on",
					[modeToggle] = "laminar/B738/switch/rwy_light_left_toggle"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/rwy_light_right", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/rwy_light_right_off",
					[modeOn] = "laminar/B738/switch/rwy_light_right_on",
					[modeToggle] = "laminar/B738/switch/rwy_light_right_toggle"
				}
			}
		}
	},
	-- Wing Lights
	["wing"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] 	 = "laminar/B738/switch/wing_light_off",
					[modeOn] 	 = "laminar/B738/switch/wing_light_on",
					[modeToggle] = "laminar/B738/switch/wing_light_toggle"
				}
			}
		}
	},	-- Wheel well Lights
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
		["cmddref"] = actCustom,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/cockpit_dome_pos", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdUp] = "laminar/B738/toggle_switch/cockpit_dome_up",
					[cmdDown] = "laminar/B738/toggle_switch/cockpit_dome_dn"
				},
				["custom"] = {
					[modeOff] =	function ()
						local cmdup = sysLights.Lights["dome"]["instances"][0]["commands"][cmdUp]
						local cmddwn = sysLights.Lights["dome"]["instances"][0]["commands"][cmdDown]
						command_once(cmdup)
						command_once(cmdup)
						command_once(cmddwn)
					end,
					[modeOn] = function () 
						local cmdup = sysLights.Lights["dome"]["instances"][0]["commands"][cmdUp]
						local cmddwn = sysLights.Lights["dome"]["instances"][0]["commands"][cmdDown]
						logMsg(cmdUp)
						command_once(cmddwn)
						command_once(cmddwn)
					end
				}
			}
		}
	},
	-- Instrument Lights
	["instruments"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 4,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 0 },
				["dataref"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 0 },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 1 },
				["dataref"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 1 },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 2 },
				["dataref"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 2 },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 3 },
				["dataref"] = { ["name"] = "laminar/B738/electric/panel_brightness", ["index"] = 3 },
				["commands"] = { "" }
			},
			[4] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 6 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 6 },
				["commands"] = { "" }
			},
			[5] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 7 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 7 },
				["commands"] = { "" }
			},
			[6] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 8 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 8 },
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
	elseif lights == "instruments" then
		if instance == -1 then
			act(sysLights.Lights,lights,0,mode)
			act(sysLights.Lights,lights,1,mode)
			act(sysLights.Lights,lights,2,mode)
			act(sysLights.Lights,lights,3,mode)
			act(sysLights.Lights,lights,4,mode)
			act(sysLights.Lights,lights,5,mode)
			act(sysLights.Lights,lights,6,mode)
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
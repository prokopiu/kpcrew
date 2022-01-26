-- B738 airplane (X-Plane 11 default)
-- aircraft lights specific functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysLights = {
}
	
sysLights.Lights = {
	-- Beacons or Anticollision Lights, single, onoff, command driven
	["beacons"] = {
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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



-- local drefInstrumentLights = "laminar/B738/electric/panel_brightness"
-- local function setInstrumentLight(index,mode)
	-- set_array(drefInstrumentLights,index,mode)
-- end
-- local function getInstrumentLight(index)
	-- return get(drefInstrumentLights,index)
-- end

-- local drefCockpitLights = "laminar/B738/toggle_switch/cockpit_dome_pos"
-- local cmdCockpitLightsUp = "laminar/B738/toggle_switch/cockpit_dome_up"
-- local cmdCockpitLightsDn = "laminar/B738/toggle_switch/cockpit_dome_dn"




-- function sysLights.getLandingLightMode()
	-- return get(drefLandingLights)
-- end

----------- GENERIC LIGHTS might nit work the same way on all default planes -------------


-- Instrument Lights - switch them all on or off
-- light: 
-- function sysLights.isetInstrumentLightsMode(light, mode)
	-- if mode == sysLights.Off then
		-- set_array(drefInstrumentLights,light,0)
	-- end
	-- if mode == sysLights.On then
		-- set_array(drefInstrumentLights,light,1)
	-- end
	-- if mode == sysLights.Toggle then
		-- if get(drefInstrumentLights,light) == 0 then 
			-- set_array(drefInstrumentLights,light,1)
		-- else
			-- set_array(drefInstrumentLights,light,0)
		-- end
	-- end
-- end

-- function sysLights.setInstrumentLightsMode(mode)
	-- sysLights.isetInstrumentLightsMode(0,mode)
	-- sysLights.isetInstrumentLightsMode(1,mode)
	-- sysLights.isetInstrumentLightsMode(2,mode)
	-- sysLights.isetInstrumentLightsMode(3,mode)
-- end

-- function sysLights.getInstrumentLightsMode()
	-- return get(drefInstrumentLights)
-- end

-- Cockpit Lights - switch them all on or off
-- function sysLights.setCockpitLightsMode(mode)
	-- if mode == sysLights.Off then
		-- command_once(cmdCockpitLightsUp)
		-- command_once(cmdCockpitLightsUp)
		-- command_once(cmdCockpitLightsDn)
	-- end
	-- if mode == sysLights.On then
		-- command_once(cmdCockpitLightsDn)
		-- command_once(cmdCockpitLightsDn)
	-- end
	-- if mode == sysLights.Toggle then
		-- if get(drefCockpitLights) == 0 then 
			-- command_once(cmdCockpitLightsDn)
			-- command_once(cmdCockpitLightsDn)
		-- else
			-- command_once(cmdCockpitLightsUp)
			-- command_once(cmdCockpitLightsUp)
			-- command_once(cmdCockpitLightsDn)
		-- end
	-- end
-- end

-- function sysLights.getCockpitLightsMode()
	-- return get(drefCockpitLights)
-- end

return sysLights
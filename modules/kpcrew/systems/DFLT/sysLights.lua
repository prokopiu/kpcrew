-- DFLT airplane (X-Plane 11 default)
-- aircraft lights specific functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysLights = {
}

-- internal lights
	-- instrument lights (array generic) per aircraft
	-- map lights optional left and right
	
sysLights.externalLights = {
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
	["landingall"] = {
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/landing_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] 	 = "sim/lights/landing_lights_off",
					[modeOn] 	 = "sim/lights/landing_lights_on",
					[modeToggle] = "sim/lights/landing_lights_toggle"
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
				["commands"] = { "" }
			}
		}
	},
	-- RWY Turnoff
	["runway"] = {
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
		["type"] = typeModes,
		["modes"] = { modeOff, modeOn, modeToggle },
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
	}
}	

sysLights.internalLights = {
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
	}
}	

-- Beacon/Anticollision light
function sysLights.setSwitchBeacon(mode)
	act(sysLights.externalLights,"beacons",0,mode)
end

function sysLights.getModeBeacon()
	return status(sysLights.externalLights,"beacons",0)
end

-- Position/Navigation Lights
function sysLights.setSwitchPosition(mode)
	act(sysLights.externalLights,"position",0,mode)
end

function sysLights.getModePosition()
	return status(sysLights.externalLights,"position",0)
end

-- Strobe Lights
function sysLights.setSwitchStrobes(mode)
	act(sysLights.externalLights,"strobes",0,mode)
end

function sysLights.getModeStrobes()
	return status(sysLights.externalLights,"strobes",0)
end

-- Taxi Lights
function sysLights.setSwitchTaxi(mode)
	act(sysLights.externalLights,"taxi",0,mode)
end

function sysLights.getModeTaxi()
	return status(sysLights.externalLights,"taxi",0)
end

-- Landing Lights
function sysLights.setSwitchLandingAll(mode)
	act(sysLights.externalLights,"landingall",0,mode)
end

function sysLights.getModeLandingAll()
	return status(sysLights.externalLights,"landingall",0)
end

-- Logo Lights
function sysLights.setSwitchLogo(mode)
	act(sysLights.externalLights,"logo",0,mode)
end

function sysLights.getModeLogo()
	return status(sysLights.externalLights,"logo",0)
end

-- Runway Turnoff Lights instance 0=Left, 1=right
function sysLights.setSwitchRunway(mode,instance)
	if instance == -1 then
		act(sysLights.externalLights,"runway",0,mode)
		act(sysLights.externalLights,"runway",1,mode)
	else
		act(sysLights.externalLights,"runway",instance,mode)
	end
end

function sysLights.getModeRunway(instance)
	return status(sysLights.externalLights,"runway",instance)
end

-- Wing Lights
function sysLights.setSwitchWing(mode)
	act(sysLights.externalLights,"wing",0,mode)
end

function sysLights.getModeWing()
	return status(sysLights.externalLights,"wing",0)
end

-- Wheel well Lights
function sysLights.setSwitchWheel(mode)
	act(sysLights.externalLights,"wheel",0,mode)
end

function sysLights.getModeWheel()
	return status(sysLights.externalLights,"wheel",0)
end

------------- internal lights

-- Dome/Cockpit Light Lights
function sysLights.setSwitchDome(mode)
	act(sysLights.internalLights,"dome",0,mode)
end

function sysLights.getModeDome()
	return status(sysLights.internalLights,"dome",0)
end

----------- GENERIC LIGHTS might nit work the same way on all default planes -------------

-- local drefInstrumentLights = "sim/cockpit/electrical/instrument_brightness"
-- local drefCockpitLights = "sim/cockpit/electrical/cockpit_lights"


-- allocations of generic lights (differs from aircraft to aircraft)
-- local GenLights = { ["Logo"] = 0, ["Wing"] = 3, ["Wheel"] = 5, ["RwyLeft"] = 1, ["RwyRight"] = 2 }

-- a cluster of instrument lights in this array
-- local drefInstrumentLight = "sim/cockpit2/switches/instrument_brightness_ratio"
-- local function setInstrumentLight(index,mode)
	-- set_array(drefInstrumentLight,index,mode)
-- end
-- local function getInstrumentLight(index)
	-- return get(drefInstrumentLight,index)
-- end

-- Instrument Lights - switch them all on or off
-- function sysLights.setInstrumentLightsMode(mode)
	-- if mode == sysLights.Off then
		-- set(drefInstrumentLights,0)
	-- end
	-- if mode == sysLights.On then
		-- set(drefInstrumentLights,1)
	-- end
	-- if mode == sysLights.Toggle then
		-- if get(drefInstrumentLights) == 0 then 
			-- set(drefInstrumentLights,1)
		-- else
			-- set(drefInstrumentLights,0)
		-- end
	-- end
-- end

-- function sysLights.getInstrumentLightsMode()
	-- return get(drefInstrumentLights)
-- end

return sysLights
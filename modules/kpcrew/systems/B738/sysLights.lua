-- B738 airplane (X-Plane 11 default)
-- aircraft lights specific functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysLights = {
}

local drefLLRetLeft = "laminar/B738/lights/land_ret_left_pos"
local drefLLRetRight = "laminar/B738/lights/land_ret_right_pos"
local drefLLLeft = "laminar/B738/switch/land_lights_left_pos"
local drefLLRight = "laminar/B738/switch/land_lights_right_pos"
local drefRWYLeft = "laminar/B738/toggle_switch/rwy_light_left"
local drefRWYRight = "laminar/B738/toggle_switch/rwy_light_right"
local drefPanelBright = "laminar/B738/electric/panel_brightness"
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
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/navigation_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/toggle_switch/position_light_off",
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
				["drefStatus"] = { ["name"] = drefLLRetLeft, ["index"] = 0 },
				["dataref"] = { ["name"] = drefLLRetLeft, ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_ret_left_off",
					[modeOn] = "laminar/B738/switch/land_lights_ret_left_on"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = drefLLRetRight, ["index"] = 0 },
				["dataref"] = { ["name"] = drefLLRetRight, ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_ret_right_off",
					[modeOn] = "laminar/B738/switch/land_lights_ret_right_on"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = drefLLLeft, ["index"] = 0 },
				["dataref"] = { ["name"] = drefLLLeft, ["index"] = 0 },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/land_lights_left_off",
					[modeOn] = "laminar/B738/switch/land_lights_left_on"
				}
			},
			[3] = {
				["drefStatus"] = { ["name"] = drefLLRight, ["index"] = 0 },
				["dataref"] = { ["name"] = drefLLRight, ["index"] = 0 },
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
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/logo_light", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/logo_light_off",
					[modeOn] = "laminar/B738/switch/logo_light_on",
					[modeToggle] = "laminar/B738/switch/logo_light_toggle"
				}
			}
		}
	},
	-- RWY Turnoff
	["runway"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 2,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = drefRWYLeft, ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOff] =	"laminar/B738/switch/rwy_light_left_off",
					[modeOn] = "laminar/B738/switch/rwy_light_left_on",
					[modeToggle] = "laminar/B738/switch/rwy_light_left_toggle"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = drefRWYRight, ["index"] = 0 },
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
				["customcmd"] = {
					[modeOff] =	function ()
						local cmdup = sysLights.Switches["dome"]["instances"][0]["commands"][cmdUp]
						local cmddwn = sysLights.Switches["dome"]["instances"][0]["commands"][cmdDown]
						command_once(cmdup)
						command_once(cmdup)
						command_once(cmddwn)
					end,
					[modeOn] = function () 
						local cmdup = sysLights.Switches["dome"]["instances"][0]["commands"][cmdUp]
						local cmddwn = sysLights.Switches["dome"]["instances"][0]["commands"][cmdDown]
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
				["drefStatus"] = { ["name"] = drefPanelBright, ["index"] = 0 },
				["dataref"] = { ["name"] = drefPanelBright, ["index"] = 0 },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = drefPanelBright, ["index"] = 1 },
				["dataref"] = { ["name"] = drefPanelBright, ["index"] = 1 },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = drefPanelBright, ["index"] = 2 },
				["dataref"] = { ["name"] = drefPanelBright, ["index"] = 2 },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = drefPanelBright, ["index"] = 3 },
				["dataref"] = { ["name"] = drefPanelBright, ["index"] = 3 },
				["commands"] = { "" }
			},
			[4] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 6 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 6 },
				["commands"] = { "" }
			},
			[5] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 7 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 7 },
				["commands"] = { "" }
			},
			[6] = {
				["drefStatus"] = { ["name"] = drefGenericLights, ["index"] = 8 },
				["dataref"] = { ["name"] = drefGenericLights, ["index"] = 8 },
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
						if get(drefLLLeft) > 0 or get(drefLLRight) > 0  or get(drefLLRetRight) > 0 or get(drefLLRetRight) > 0 then
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/navigation_lights_on", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Taxi Light(s) status
	["taxi"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get("laminar/B738/toggle_switch/taxi_light_brightness_pos") > 0 then
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
	-- Logo Light(s) status
	["logo"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/toggle_switch/logo_light", ["index"] = 0 },
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
						if get(drefRWYLeft) > 0 or get(drefRWYRight) > 0 then
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 0 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/generic_lights_switch", ["index"] = 5 },
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
						if get( "laminar/B738/toggle_switch/cockpit_dome_pos",0) ~= 0 then
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
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefPanelBright,0) > 0 or get(drefPanelBright,1) > 0  or get(drefPanelBright,2) > 0  or get(drefPanelBright,3) > 0 or get(drefGenericLights,6) > 0  or get(drefGenericLights,7) > 0  or get(drefGenericLights,8) > 0 then
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
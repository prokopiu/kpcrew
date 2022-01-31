-- B738 airplane 
-- aircraft general systems

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysGeneral = {
	GearLightLeftGreen 	= 0,
	GearLightRightGreen = 1,
	GearLightNoseGreen 	= 2,
	GearLightLeftRed 	= 3,
	GearLightRightRed 	= 4,
	GearLightNoseRed 	= 5,
	
	GearUp				= 10,
	GearDown			= 11,
	GearOff				= 12,

	DoorLeftForward 	= 0,
	DoorRightForward 	= 1,
	DoorLeftAft 		= 2,
	DoorRightAft 		= 3,
	DoorCargoForward 	= 4,
	DoorCargoAft 		= 5,

	BaroLeft 			= 0,
	BaroRight 			= 1,
	BaroStandby 		= 2

}

sysGeneral.GenSystems = {
	-- Parking Brake
	["parkbrake"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/controls/parking_brake_ratio", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/push_button/park_brake_on_off"
				}
			}
		}
	},
	-- Gear Lights for annunciators
	["gearlights"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 6,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/left_gear_safe", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/right_gear_safe", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/nose_gear_safe", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/left_gear_transit", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[4] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/right_gear_transit", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[5] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/nose_gear_transit", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Master Caution
	["mastercaution"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/annunciator/master_caution_light", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- Master Warning
	["masterwarning"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/annunciators/master_warning", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- Door annunciators
	["doorstatus"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 6,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "737u/doors/L1", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "737u/doors/L2", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = "737u/doors/R1", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = "737u/doors/R2", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[4] = {
				["drefStatus"] = { ["name"] = "737u/doors/Fwd_Cargo", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[5] = {
				["drefStatus"] = { ["name"] = "737u/doors/aft_Cargo", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}
		}
	},
	-- Landing Gear
	["landinggear"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/controls/gear_handle_down", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[sysGeneral.GearDown] = "sim/flight_controls/landing_gear_down",
					[sysGeneral.GearUp] = "sim/flight_controls/landing_gear_up",
					[sysGeneral.GearOff] = "laminar/B738/push_button/gear_off"
				}
			}
		}
	},
	-- Doors
	["doors"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 6,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "737u/doors/L1", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/door/fwd_L_toggle" 
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "737u/doors/L2", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/door/fwd_R_toggle"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "737u/doors/R1", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/door/aft_L_toggle"
				}
			},
			[3] = {
				["drefStatus"] = { ["name"] = "737u/doors/R2", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/door/aft_R_toggle"
				}
			},
			[4] = {
				["drefStatus"] = { ["name"] = "737u/doors/Fwd_Cargo", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/door/fwd_cargo_toggle"
				}
			},
			[5] = {
				["drefStatus"] = { ["name"] = "737u/doors/aft_Cargo", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/door/aft_cargo_toggle"
				}
			}
		}
	},
	-- Baro standard toggle
	["barostd"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 3,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS/baro_set_std_pilot", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/EFIS_control/capt/push_button/std_press"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS/baro_set_std_copilot", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/EFIS_control/fo/push_button/std_press"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "laminar/B738/gauges/standby_alt_std_mode", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] = "laminar/B738/toggle_switch/standby_alt_baro_std"
				}
			}
		}
	},
	-- Baro mode
	["baromode"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 3,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS_control/capt/baro_in_hpa", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/EFIS_control/capt/baro_in_hpa_dn",
					[cmdUp] 	 = "laminar/B738/EFIS_control/capt/baro_in_hpa_up"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS_control/fo/baro_in_hpa", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/EFIS_control/fo/baro_in_hpa_dn",
					[cmdUp] 	 = "laminar/B738/EFIS_control/fo/baro_in_hpa_up"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS_control/fo/baro_in_hpa", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/toggle_switch/standby_alt_hpin",
					[cmdUp] 	 = "laminar/B738/toggle_switch/standby_alt_hpin"
				}
			}
		}
	},
	-- Baro value
	["barovalue"] = {
		["type"] = typeActuator,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 3,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS/baro_sel_in_hg_pilot", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/pilot/barometer_down",
					[cmdUp] 	 = "laminar/B738/pilot/barometer_up"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/EFIS/baro_sel_in_hg_copilot", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/copilot/barometer_down",
					[cmdUp] 	 = "laminar/B738/copilot/barometer_up"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "laminar/B738/knobs/standby_alt_baro", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/knob/standby_alt_baro_dn",
					[cmdUp] 	 = "laminar/B738/knob/standby_alt_baro_up"
				}
			}
		}
	}
}	

function sysGeneral.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysGeneral.GenSystems[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysGeneral.GenSystems,element,iloop,mode)	
		end
	else
		act(sysGeneral.GenSystems,element,instance,mode)
	end
end

function sysGeneral.getMode(element,instance)
	if element == "doorstatus" then
		local sumit = status(sysGeneral.GenSystems,element,0) +
			status(sysGeneral.GenSystems,element,1) +
			status(sysGeneral.GenSystems,element,2) +
			status(sysGeneral.GenSystems,element,3) +
			status(sysGeneral.GenSystems,element,4) +
			status(sysGeneral.GenSystems,element,5)
		if sumit > 0 then 
			return 1
		else
			return 0
		end
	else
		return status(sysGeneral.GenSystems,element,instance)
	end
end

-- local drefCurrentBaro = "sim/weather/barometer_sealevel_inhg"

return sysGeneral
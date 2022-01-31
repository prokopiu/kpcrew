-- DFLT airplane 
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

local drefCurrentBaro = "sim/weather/barometer_sealevel_inhg"

sysGeneral.GenSystems = {
	-- Parking Brake
	["parkbrake"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithDref,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/controls/parking_brake_ratio", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/controls/parking_brake_ratio", ["index"] = 0 },
				["commands"] = { ""	}
			}
		}
	},
	-- Gear Lights for annunciators
	["gearlights"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 6,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel/movingparts/gear1def", ["index"] = 0 },
				["dataref"] = { "" },
				["customdref"] = function () 
						local statusdref = sysGeneral.GenSystems["gearlights"]["instances"][0]["drefStatus"]
						return get(statusdref["name"],statusdref["index"])
					end,
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel/movingparts/gear2def", ["index"] = 0 },
				["dataref"] = { "" },
				["customdref"] = function ()
						local statusdref = sysGeneral.GenSystems["gearlights"]["instances"][1]["drefStatus"]["name"]
						return get(statusdref,0)
					end,
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel/movingparts/gear3def", ["index"] = 0 },
				["dataref"] = { "" },
				["customdref"] = function ()
						local statusdref = sysGeneral.GenSystems["gearlights"]["instances"][2]["drefStatus"]["name"]
						return get(statusdref,0)
					end,
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel/movingparts/gear1def", ["index"] = 0 },
				["dataref"] = { "" },
				["customdref"] = function ()
						local statusdref = sysGeneral.GenSystems["gearlights"]["instances"][3]["drefStatus"]["name"]
						if get(statusdref,0) < 1.0 and get(statusdref,0) > 0.01 then
							return 1
						else
							return 0
						end
					end,
				["commands"] = { "" }
			},
			[4] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel/movingparts/gear2def", ["index"] = 0 },
				["dataref"] = { "" },
				["customdref"] = function ()
						local statusdref = sysGeneral.GenSystems["gearlights"]["instances"][4]["drefStatus"]["name"]
						if get(statusdref,0) < 1.0 and get(statusdref,0) > 0.01 then
							return 1
						else
							return 0
						end
					end,
				["commands"] = { "" }
			},
			[5] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel/movingparts/gear3def", ["index"] = 0 },
				["dataref"] = { "" },
				["customdref"] = function ()
						local statusdref = sysGeneral.GenSystems["gearlights"]["instances"][5]["drefStatus"]["name"]
						if get(statusdref,0) < 1.0 and get(statusdref,0) > 0.01 then
							return 1
						else
							return 0
						end
					end,
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/annunciators/master_caution", ["index"] = 0 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 4 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 3 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[3] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open2", ["index"] = 7 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[4] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 8 },
				["dataref"] = { "" },
				["commands"] = { "" }
			},
			[5] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 9 },
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/controls/gear_handle_down", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[sysGeneral.GearDown] = "sim/flight_controls/landing_gear_down",
					[sysGeneral.GearUp] = "sim/flight_controls/landing_gear_up",
					[sysGeneral.GearOff] = ""
				}
			}
		}
	},
	-- Doors
	["doorscmd"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 6,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeOn] 	= "sim/flight_controls/door_open_1",
					[modeOff]	= "sim/flight_controls/door_close_1"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 1 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOn] 	= "sim/flight_controls/door_open_2",
					[modeOff]	= "sim/flight_controls/door_close_2"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 2 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOn] 	= "sim/flight_controls/door_open_3",
					[modeOff]	= "sim/flight_controls/door_close_3"
				}
			},
			[3] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 3 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOn] 	= "sim/flight_controls/door_open_4",
					[modeOff]	= "sim/flight_controls/door_close_4"
				}
			},
			[4] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 4 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOn] 	= "sim/flight_controls/door_open_5",
					[modeOff]	= "sim/flight_controls/door_close_5"
				}
			},
			[5] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/switches/door_open", ["index"] = 5 },
				["dataref"] = { "" },
				["commands"] = {
					[modeOn] 	= "sim/flight_controls/door_open_6",
					[modeOff]	= "sim/flight_controls/door_close_6"
				}
			}
		}
	},
	-- doors based on sliders
	["doors"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 6,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/misc/custom_slider_ratio", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] 	= "sim/operation/slider_01"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/misc/custom_slider_ratio", ["index"] = 1 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] 	= "sim/operation/slider_02"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/misc/custom_slider_ratio", ["index"] = 2 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] 	= "sim/operation/slider_03"
				}
			},
			[3] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/misc/custom_slider_ratio", ["index"] = 3 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] 	= "sim/operation/slider_04"
				}
			},
			[4] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/misc/custom_slider_ratio", ["index"] = 4 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] 	= "sim/operation/slider_05"
				}
			},
			[5] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/misc/custom_slider_ratio", ["index"] = 5 },
				["dataref"] = { "" },
				["commands"] = {
					[modeToggle] 	= "sim/operation/slider_06"
				}
			}
		}
	},
	-- Baro standard toggle
	["barostd"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actCustom,
		["status"] = statusDref,
		["toggle"] = toggleCmd,
		["instancecnt"] = 3,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", ["index"] = 0 },
				["customcmd"] = {
					[modeOn] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][0]["dataref"]["name"] 
						set(dref,29.92)
					end,
					[modeOff] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][0]["dataref"]["name"] 
						set(dref,get(drefCurrentBaro))
					end,
					[modeToggle] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][0]["dataref"]["name"] 
						if get(dref,0) < 29.921 and get(dref,0) > 29.919 then
							set(dref,get(drefCurrentBaro))
						else
							set(dref,29.92)
						end
					end
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", ["index"] = 0 },
				["customcmd"] = {
					[modeOn] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][1]["dataref"]["name"] 
						set(dref,29.92)
					end,
					[modeOff] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][1]["dataref"]["name"] 
						set(dref,getdrefCurrentBaro)
					end,
					[modeToggle] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][1]["dataref"]["name"] 
						if get(dref,0) < 29.921 and get(dref,0) > 29.919 then
							set(dref,get(drefCurrentBaro))
						else
							set(dref,29.92)
						end
					end
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby", ["index"] = 0 },
				["dataref"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby", ["index"] = 0 },
				["customcmd"] = {
					[modeOn] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][2]["dataref"]["name"] 
						set(dref,29.92)
					end,
					[modeOff] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][2]["dataref"]["name"] 
						set(dref,getdrefCurrentBaro)
					end,
					[modeToggle] = function ()
						local dref = sysGeneral.GenSystems["barostd"]["instances"][2]["dataref"]["name"] 
						if get(dref,0) < 29.921 and get(dref,0) > 29.919 then
							set(dref,get(drefCurrentBaro))
						else
							set(dref,29.92)
						end
					end
				}
			}
		}
	},
	-- Baro mode
	["baromode"] = {
		["type"] = typeInop,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleDref,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "",
					[cmdUp] 	 = ""
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
				["drefStatus"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "sim/instruments/barometer_down",
					[cmdUp] 	 = "sim/instruments/barometer_up"
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "sim/instruments/barometer_copilot_down",
					[cmdUp] 	 = "sim/instruments/barometer_copilot_up"
				}
			},
			[2] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/gauges/actuators/barometer_setting_in_hg_stby", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "sim/instruments/barometer_stby_down",
					[cmdUp] 	 = "sim/instruments/barometer_stby_up"
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
		return status(sysGeneral.GenSystems,element,instance)
end

return sysGeneral
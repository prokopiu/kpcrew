-- B738 airplane 
-- Flight Controls functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"
 
local sysControls = {
	trimCenter = 2
}

sysControls.Switches = {
	-- Flaps 
	["flaps"] = {
		["type"] = typeActuator,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/flightmodel2/controls/flap_ratio", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "sim/flight_controls/flaps_down",
					[cmdUp] 	 = "sim/flight_controls/flaps_up"
				}
			}
		}
	},
	-- Pitch Trim
	["pitchtrim"] = {
		["type"] = typeActuator,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/controls/elevator_trim", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdDown]	 = "laminar/B738/flight_controls/pitch_trim_down",
					[cmdUp] 	 = "laminar/B738/flight_controls/pitch_trim_up"
				}
			}
		}
	},
	-- Aileron Trim
	["ailerontrim"] = {
		["type"] = typeActuator,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/controls/aileron_trim", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdLeft]	 = "sim/flight_controls/aileron_trim_left",
					[cmdRight] 	 = "sim/flight_controls/aileron_trim_right",
					[sysControls.trimCenter] = "sim/flight_controls/rudder_trim_center"
				}
			}
		}
	},
	-- Rudder Trim
	["ruddertrim"] = {
		["type"] = typeActuator,
		["cmddref"] = actWithCmd,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "sim/cockpit2/controls/rudder_trim", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = {
					[cmdLeft]	 = "sim/flight_controls/rudder_trim_left",
					[cmdRight] 	 = "sim/flight_controls/rudder_trim_right",
					[sysControls.trimCenter] = "sim/flight_controls/aileron_trim_center"
				}
			}
		}
	}
}

function sysControls.setSwitch(element, instance, mode)
	if instance == -1 then
		local item = sysControls.FlightControls[element]
		instances = item["instancecnt"]
		for iloop = 0,instances-1 do
			act(sysControls.FlightControls,element,iloop,mode)	
		end
	else
		act(sysControls.FlightControls,element,instance,mode)
	end
end

function sysControls.getMode(element,instance)
		return status(sysControls.FlightControls,element,instance)
end

return sysControls
-- B738 airplane 
-- MCP functionality

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local sysMCP = {
}

local drefVORLocLight = "laminar/B738/autopilot/vorloc_status"
local drefLNAVLight = "laminar/B738/autopilot/lnav_status"
local drefSPDLight = "laminar/B738/autopilot/speed_mode"
local drefN1Light = "laminar/B738/autopilot/n1_status"
local drefVSLight = "laminar/B738/autopilot/vs_status"
local drefLVLCHGLight = "laminar/B738/autopilot/lvl_chg_status"
local drefVNAVLight = "laminar/B738/autopilot/vnav_status1"
local drefAPStatusLight = "laminar/B738/autopilot/cmd_a_status"
local drefCMDBLight = "laminar/B738/autopilot/cmd_b_status"

sysMCP.Switches = {
	["fdir"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 2,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/flight_director_pos", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/flight_director_toggle" 
				}
			},
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/flight_director_fo_pos", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/flight_director_fo_toggle" 
				}
			}		
		}
	},
	["hdgsel"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/hdg_sel_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/hdg_sel_press" 
				}
			}		
		}
	},
	["vorloc"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/vorloc_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/vorloc_press" 
				}
			}		
		}
	},
	["althold"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/alt_hld_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/alt_hld_press" 
				}
			}		
		}
	},
	["approach"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/app_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/app_press" 
				}
			}		
		}
	},
	["vs"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/vs_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/vs_press" 
				}
			}		
		}
	},
	["speed"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/speed_status1", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/speed_press" 
				}
			}		
		}
	},
	["autopilot"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 2,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/cmd_a_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/cmd_a_press" 
				}
			},		
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/cmd_b_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/cmd_b_press" 
				}
			}		
		}
	},
	["backcourse"] = {
		["type"] = typeInop,
		["cmddref"] = actNone,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { "" },
				["dataref"] = { "" },
				["commands"] = { ""	}
			}		
		}
	},
	["togapress"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 2,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/ap_takeoff", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/left_toga_press" 
				}
			},		
			[1] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/ap_takeoff", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/right_toga_press" 
				}
			}		
		}
	},
	["autothrottle"] = {
		["type"] = typeOnOffTgl,
		["cmddref"] = actTglCmd,
		["status"] = statusNone,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/autothrottle_status1", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { 
					[modeToggle] = "laminar/B738/autopilot/autothrottle_arm_toggle" 
				}
			}		
		}
	}
}

sysMCP.Annunciators = {
	-- Flight Directors annunciator
	["fdiranc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get("laminar/B738/autopilot/flight_director_pos") > 0 or get("laminar/B738/autopilot/flight_director_fo_pos") > 0 then
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
	-- HDG Select/mode annunciator
	["hdganc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusDref,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/hdg_sel_status", ["index"] = 0 },
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
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/app_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- SPD mode annunciator
	["spdanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
						if get(drefSPDLight) > 0 or get(drefN1Light) > 0 then
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
					if get(drefVSLight) > 0 or get(drefLVLCHGLight) > 0 or get(drefVNAVLight) > 0 then
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
				["drefStatus"] = { ["name"] = "laminar/B738/autopilot/alt_hld_status", ["index"] = 0 },
				["dataref"] = { "" },
				["commands"] = { "" }
			}		
		}
	},
	-- A/P mode annunciator
	["autopilotanc"] = {
		["type"] = typeAnnunciator,
		["cmddref"] = actNone,
		["status"] = statusCustom,
		["toggle"] = toggleNone,
		["instancecnt"] = 1,
		["instances"] = {
			[0] = {
				["drefStatus"] = { ["name"] = "", ["index"] = 0 },
				["customdref"] = function () 
					if get(drefAPStatusLight) > 0 or get(drefCMDBLight) > 0 then
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
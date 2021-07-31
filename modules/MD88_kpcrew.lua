--[[
	*** KPCREW for Rotate MD-88
	Kosta Prokopiu, 2021
	Changelog:
		* v0.1 - Initial version only control 
--]]

-- Briefing / Aircraft specific details
MD88 = Class_ACF:Create()
MD88:setDEP_Flaps({"0","1","2","5","10","15","25"})
MD88:setDEP_Flaps_val({0,0.125,0.25,0.375,0.5,0.625,0.75})
MD88:setAPP_Flaps({"15","30","40"})
MD88:setAPP_Flaps_val({0.625,0.875,1})
MD88:setAutoBrake({"OFF","MN","MED","MAX",""})
MD88:setAutoBrake_val({0,1,2,3,3})
MD88:setTakeoffThrust({"Normal","Reduced","",""})
MD88:setTakeoffThrust_Val({0,1,2,3})
MD88:setBleeds({"OFF","ON","UNDER PRESSURIZED"})
MD88:setBleeds_val({0,1,2})
MD88:setAIce({"Not Required","Engine Only","Engine and Wing"})
MD88:setAIce_val({0,1,2})
MD88:setDepApMode({"HDG/IAS","VORLOC/IAS"})
MD88:setDepApMode_val({0,1})

set_zc_config("acfname","McDonnell Douglas MD-88")
set_zc_config("acficao","MD88")

DEP_takeofthrust_list = MD88:getTakeoffThrust()
DEP_aice_list = MD88:getAIce()
DEP_bleeds_list = MD88:getBleeds()

local curralt_1000 = 0
local curralt_10 = 0 
local elapsed_time_visible = 0

-- Procedure definitions
ZC_INIT_PROC = {
	[0] = {["lefttext"] = "ZIBOCREW ".. ZC_VERSION .. " STARTED",["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "KPCREW ".. ZC_VERSION .. " Rotate MD-80"
			command_once("bgood/xchecklist/reload_checklist")
		end
	}
}

ZC_COLD_AND_DARK = {
	[0] = {["lefttext"] = "GROUND SERVICE ELEC", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/electrical/GPU_gs_bus_switch",0)
			set("Rotate/md80/electrical/APU_gs_bus_switch",0)
			set("Rotate/md80/systems/maintenance_interphone_switch",0)
		end
	}, 
	[1] = {["lefttext"] = "OVERHEAD RADIO", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit2/radios/actuators/audio_volume_com1",0.5)
			set("sim/cockpit2/radios/actuators/audio_volume_com2",0.5)
			set("sim/cockpit2/radios/actuators/audio_volume_nav1",0.5)
			set("sim/cockpit2/radios/actuators/audio_volume_nav2",0.5)
			set("sim/cockpit2/radios/actuators/audio_volume_mark",0.5)
			set("sim/cockpit2/radios/actuators/audio_volume_adf1",0.5)
			set("sim/cockpit2/radios/actuators/audio_volume_adf2",0.5)
			set("Rotate/md80/instruments/audio_volume_hf1",0.5)
			set("Rotate/md80/instruments/audio_volume_hf2",0.5)
			set("Rotate/md80/instruments/audio_volume_int",0.5)
			set("Rotate/md80/instruments/audio_volume_pa",0.5)
			set("Rotate/md80/instruments/audio_volume_com3",0.5)
		end
	}, 
	[2] = {["lefttext"] = "OVERHEAD FIRE DETECTION", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/systems/fire_det_loop_selector_r",1)
			set("Rotate/md80/systems/fire_det_loop_selector_l",1)
			set("Rotate/md80/systems/fire_det_loop_selector_apu",1)
		end
	}, 
	[3] = {["lefttext"] = "OVERHEAD NAVIGATION", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/autopilot/fd_select",1)
			set("Rotate/md80/autopilot/cadc_select",1)
			set("Rotate/md80/autopilot/ahrs_select",1)
			set("Rotate/md80/autopilot/efis_select",1)
			set("Rotate/md80/systems/eng_sync_switch",1)
			set("Rotate/md80/test/gpws_test",0)
			set("Rotate/md80/test/windshr_test_switch_active",0)
			set("Rotate/md80/instruments/irs_mode_switch",0)
			set("Rotate/md80/instruments/irs2_mode_switch",0)
		end
	}, 		
	[4] = {["lefttext"] = "OVERHEAD LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/lights/cockpit_ovhd_instr_lt_dimm",0)
			set("Rotate/md80/lights/cockpit_ovhd_flood_lt_dimm",0)
			set("Rotate/md80/lights/cockpit_thndstrm_lights_switch",0)
			set("Rotate/md80/lights/cockpit_ceiling_lights_switch",0)
			set("Rotate/md80/lights/cockpit_cktbkr_lights_switch",0)
			set("Rotate/md80/lights/cockpit_stbycomp_lights_switch",0)
			set("Rotate/md80/lights/logo_light_switch",0)
		end
	},     
	[5] = {["lefttext"] = "OVERHEAD MIXED", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/hydraulic/anti_skid_arm",0)
			set("Rotate/md80/test/anti_skid_test",0)
			set("Rotate/md80/test/stall_test_switch",0)
			set("Rotate/md80/systems/yaw_damper_switch",0)
			set("Rotate/md80/systems/mach_trim_comp_override",0)
			set("Rotate/md80/alerts/pull_to_dim_switch",0)
		end
	}, 
	[6] = {["lefttext"] = "OVERHEAD TEMP", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/air/cabin_temp_selector_switch",0)
			set("Rotate/md80/air/temp_control_cockpit_setting",0)
			set("Rotate/md80/air/air_pack_left_switch",0)
			set("Rotate/md80/air/air_pack_right_switch",0)
			set("Rotate/md80/air/temp_control_cabin_setting",0)
			set("Rotate/md80/air/cabin_pres_system",0)
			set("Rotate/md80/misc/wiper_left_switch",1)
			set("Rotate/md80/misc/wiper_right_switch",1)
			set("Rotate/md80/alerts/pull_to_dim_switch",0)
		end
	},                                                  
	[7] = {["lefttext"] = "OVERHEAD ELECTRIC", ["timerincr"] = 1,
		["actions"] = function ()
			set("Rotate/md80/electrical/csd_switch_0",0)
			set("Rotate/md80/electrical/csd_switch_1",0)
			set("Rotate/md80/electrical/generator_switch_0",0)
			set("Rotate/md80/electrical/generator_switch_1",0)
			set("Rotate/md80/electrical/APU_gen_switch",0)
			set("Rotate/md80/electrical/power_indicator_switch",4)
			set("Rotate/md80/electrical/galley_switch",0)
			set("Rotate/md80/electrical/dc_bus_tie_switch",0)
			set("Rotate/md80/electrical/ac_bus_tie_switch",1)
			set("Rotate/md80/electrical/GPU_l_bus_switch",0)
			set("Rotate/md80/electrical/GPU_r_bus_switch",0)
			set("Rotate/md80/electrical/APU_l_bus_switch",0)
			set("Rotate/md80/electrical/APU_r_bus_switch",0)
			set("",0)
			set("",0)
			set("",0)
			set("",0)
		end
	},                                                  
	[8] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/GndPwrSwitch",-1)
		end
	},                                                  
	[9] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_07",1)
			set("FJS/732/Elec/StbyPowerSwitch",0)
		end
	},                                                  
	[10] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WiperKnob",-1)
			set("FJS/732/AntiIce/WiperKnob",0)
		end
	},                                                  
	[11] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_10",1)
			set("FJS/732/lights/EmerExitSwitch",0)
			set("FJS/732/Pneumatic/EquipCoolingSwitch",0)
		end
	},                                                  
	[12] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/NoSmokingSwitch",0)
			set("FJS/732/lights/FastenBeltsSwitch",0)
		end
	},                                                  
	[13] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatL1Switch",0)
			set("FJS/732/AntiIce/WindowHeatL2Switch",0)
			set("FJS/732/AntiIce/WindowHeatR1Switch",0)
			set("FJS/732/AntiIce/WindowHeatR2Switch",0)
			set("FJS/732/AntiIce/PitotStaticSwitchA",0)
			set("FJS/732/AntiIce/PitotStaticSwitchB",0)
		end
	},                                                  
	[14] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WingAntiIceSwitch",0)
			set("FJS/732/AntiIce/EngAntiIce1Switch",0)
			set("FJS/732/AntiIce/EngAntiIce2Switch",0)
		end
	},                                                  
	[15] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Eng1HydPumpSwitch",1)
			set("FJS/732/FltControls/Eng2HydPumpSwitch",1)
			set("FJS/732/FltControls/Elec1HydPumpSwitch",0)
			set("FJS/732/FltControls/Elec2HydPumpSwitch",0)
		end
	},                                                  	
	[16] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/ContCabinTempSelector",21)
			set("FJS/732/Pneumatic/PassCabinTempSelector",21)
		end
	},                     
	[17] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/GasperFanSwitch",0)
			set("FJS/732/Pneumatic/LPackSwitch",0)
			set("FJS/732/Pneumatic/RPackSwitch",0)
		end
	},                     
	[18] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/IsoValveSwitch",0)
			set("FJS/732/Pneumatic/EngBleed1Switch",0)
			set("FJS/732/Pneumatic/EngBleed2Switch",0)
			set("FJS/732/Pneumatic/APUBleedSwitch",0)
			set("FJS/732/Pneumatic/FlightAltSelector",0)
			set("FJS/732/Pneumatic/LandingAltSelector10",0)
			set("FJS/732/Pneumatic/LandingAltSelector1000",0)
			set("FJS/732/Pneumatic/FltGndSwitch",0)
		end
	},     
	[19] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",0)
			set("FJS/732/lights/InBoundLLightSwitch2",0)
			set("FJS/732/lights/InBoundLLightSwitch1",0)
			set("FJS/732/lights/OutBoundLLightSwitch2",0)
			set("FJS/732/lights/OutBoundLLightSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch2",0)
		end
	},                     
	[20] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/StrobeLightSwitch",0)
			set("FJS/732/lights/AntiColLightSwitch",0)
			set("FJS/732/lights/WingLightSwitch",0)
			set("FJS/732/lights/LogoLightSwitch",0)
			set("FJS/732/lights/PositionLightSwitch",0)
		end
	},                     
	[21] = {["lefttext"] = "OTHER", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/flightmodel/controls/flaprqst",0)
			set("FJS/732/FltControls/SpeedBreakHandleMo",0)
			set("sim/flightmodel/controls/parkbrake",0)
			set("FJS/732/fuel/FuelMixtureLever1",0)
			set("FJS/732/fuel/FuelMixtureLever2",0)
			set("FJS/732/Eng/Engine1StartKnob",0)
			set("FJS/732/Eng/Engine2StartKnob",0)
			set("FJS/732/Radios/TransponderModeKnob",1)
			set("FJS/732/FltControls/AutoBrakeKnob",0)
		end
	},
	[22] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gRightText = "COLD & DARK STATE SET"
			command_once("bgood/xchecklist/check_item")
		end
	}
}

ZC_POWER_UP_PROC = {
	[0] = {["lefttext"] = "POWER UP",["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"POWERING UP THE AIRCRAFT")
		end
	},
	-- Prepare aircraft
	[1] = {["lefttext"] = "FO: PARKING BRAKE -- SET",["timerincr"] = 1,
		["actions"] = function ()
			if get("sim/cockpit2/controls/parking_brake_ratio", 0) then
				command_once("sim/flight_controls/brakes_toggle_max")
			end
		end
	},
	[2] = {["lefttext"] = "CAPT: FUEL CONTROLS -- CUTOFF",["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/fuel/FuelMixtureLever2",0)
			set("FJS/732/fuel/FuelMixtureLever1",0)
		end
	},
	-- BATTERY ON
	[3] = {["lefttext"] = "CAPT: BATTERY -- ON",["timerincr"] = 2,
		["actions"] = function ()
			set("sim/cockpit/electrical/battery_on",1)
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/732/lights/DomeWhiteSwitch",1)
			else
				set("FJS/732/lights/DomeWhiteSwitch",0)
			end
		end
	},
	-- GROUND POWER ON
	[4] = {["lefttext"] = "CONNECT GPU IN MENU", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_01",0)
			if get_zc_config("apuinit") == false then
				gLeftText = "CONNECT GPU IN MENU"
				speakNoText(0,"CONNECT GPU IN MENU")
			end
		end
	},
	[5] = {["lefttext"] = "CONNECT GPU IN MENU", ["timerincr"] = (get_zc_config("apuinit") and 1 or 997),
		["actions"] = function ()
			if get_zc_config("apuinit") == false then
				gLeftText = "GPU CONNECTED"
				set("FJS/732/Elec/GndPwrSwitch",1)
			else
				set("FJS/732/Elec/GndPwrSwitch",-1)
			end
		end
	},
	-- APU ON
	[6] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 6,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/732/Elec/APUStartSwitch",2)
				set("FJS/732/Elec/GndPwrSwitch",0)
			else
				set("FJS/732/Elec/APUStartSwitch",0)
			end
		end
	}, 
	[7] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/732/Elec/APUStartSwitch",1)
				-- background wait for APU generator
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
			else
				set("FJS/732/Elec/APUStartSwitch",0)
			end
			set("FJS/732/Elec/StbyPowerSwitch",1)
			set("FJS/732/num/FlipPo_07",0)
		end
	},
	-- FIRE TESTS
	[8] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/FireTestSwitch",1)
			set("FJS/732/lights/WingLightSwitch",1)
		end
	},
	[9] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/FireTestSwitch",0)
			set("FJS/732/FireProtect/CargoFireTestButton",1)
		end
	},
	[10] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/CargoFireTestButton",0)
			set("FJS/732/FireProtect/ExtinguisherTestSwitch",1)
		end
	},
	[11] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/ExtinguisherTestSwitch",0)
		end
	},
	-- CONFIGURE FUEL PUMPS
	[12] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpC1Switch",0)
		end
	}, 
	[13] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpC2Switch",0)
		end
	}, 
	[14] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpL1Switch",1)
		end
	}, 
	[15] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpL2Switch",0)
		end
	}, 
	[16] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpR1Switch",0)
		end
	}, 
	[17] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpR2Switch",0)
		end
	}, 
	[18] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelCrossFeedSelector",0)
		end
	}, 
	-- OTHER SETTINGS
	[19] = {["lefttext"] = "FO: CONFIGURE ELEC HYD PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Elec1HydPumpSwitch",1)
			set("FJS/732/FltControls/Elec2HydPumpSwitch",1)
		end
	}, 
	[20] = {["lefttext"] = "FO: POSITION & WING LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/PositionLightSwitch",1)
			set("FJS/732/lights/WingLightSwitch",1)
		end
	}, 
	[21] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/autopilot/airspeed",get_zc_config("apspd"))
			set("sim/cockpit/autopilot/heading_mag",get_zc_config("aphdg"))
			set("sim/cockpit/autopilot/altitude",get_zc_config("apalt"))
			ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status=1
		end
	}, 
	[22] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "POWER UP FINISHED"
			speakNoText(0,"POWER UP FINISHED")
		end
	}
}

ZC_TURN_AROUND_STATE = {
	[0] = {["lefttext"] = "OVERHEAD TOP", ["timerincr"] = 1,
		["actions"] = function ()
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/732/lights/DomeWhiteSwitch",1)
			else
				set("FJS/732/lights/DomeWhiteSwitch",0)
			end
			set("FJS/732/DoorSta/ForStairSwitch",-1)
			if get("FJS/732/DoorSta/Door1") == 0 then
				command_once("FJS/732/Doors/Door1")
			end
		end
	}, 
	-- GROUND POWER ON
	[1] = {["lefttext"] = "CONNECT GPU IN MENU", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_01",0)
			if get_zc_config("apuinit") == false then
				gLeftText = "CONNECT GPU IN MENU"
				speakNoText(0,"CONNECT GPU IN MENU")
			end
		end
	},
	[2] = {["lefttext"] = "CONNECT GPU IN MENU", ["timerincr"] = (get_zc_config("apuinit") and 1 or 997),
		["actions"] = function ()
			if get_zc_config("apuinit") == false then
				gLeftText = "GPU CONNECTED"
				set("FJS/732/Elec/GndPwrSwitch",1)
			else
				set("FJS/732/Elec/GndPwrSwitch",-1)
			end
		end
	},
	-- APU ON
	[3] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 6,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/732/Elec/APUStartSwitch",2)
				set("FJS/732/Elec/GndPwrSwitch",0)
			else
				set("FJS/732/Elec/APUStartSwitch",0)
			end
		end
	}, 
	[4] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/732/Elec/APUStartSwitch",1)
				-- background wait for APU generator
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
			else
				set("FJS/732/Elec/APUStartSwitch",0)
			end
			set("FJS/732/Elec/StbyPowerSwitch",1)
			set("FJS/732/num/FlipPo_07",0)
		end
	},
	[5] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/YawDamperSwitch",0)
			set("FJS/732/num/FlipPo_06",0)
			set("FJS/732/FltControls/AlternatFlapsMasterSwitch",0)
		end
	}, 
	[6] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Inst/VHFNAV_Switch",0)
			set("FJS/732/Inst/CompassTransfer_Switch",0)
			set("FJS/732/Inst/VertGyro_Switch",0)
		end
	}, 
	[7] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpC1Switch",0)
			set("FJS/732/Fuel/FuelPumpC2Switch",0)
			set("FJS/732/Fuel/FuelPumpL1Switch",(get_zc_config("apuinit") and 1 or 0))
			set("FJS/732/Fuel/FuelPumpL2Switch",0)
			set("FJS/732/Fuel/FuelPumpR1Switch",0)
			set("FJS/732/Fuel/FuelPumpR2Switch",0)
			set("FJS/732/Fuel/FuelCrossFeedSelector",0)
			set("FJS/732/Fuel/FuelHeat1Switch",0)
			set("FJS/732/Fuel/FuelHeat2Switch",0)
		end
	}, 		
	[8] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/GndPwrSwitch",0)
		end
	},                                                  
	[9] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_07",0)
			set("FJS/732/Elec/StbyPowerSwitch",0)
		end
	},                                                  
	[10] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WiperKnob",-1)
			set("FJS/732/AntiIce/WiperKnob",0)
		end
	},                                                  
	[11] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_10",0)
			set("FJS/732/lights/EmerExitSwitch",1)
			set("FJS/732/Pneumatic/EquipCoolingSwitch",1)
		end
	},                                                  
	[12] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/NoSmokingSwitch",1)
			set("FJS/732/lights/FastenBeltsSwitch",1)
		end
	},                                                  
	[13] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatL1Switch",0)
			set("FJS/732/AntiIce/WindowHeatL2Switch",0)
			set("FJS/732/AntiIce/WindowHeatR1Switch",0)
			set("FJS/732/AntiIce/WindowHeatR2Switch",0)
			set("FJS/732/AntiIce/PitotStaticSwitchA",0)
			set("FJS/732/AntiIce/PitotStaticSwitchB",0)
		end
	},                                                  
	[14] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WingAntiIceSwitch",0)
			set("FJS/732/AntiIce/EngAntiIce1Switch",0)
			set("FJS/732/AntiIce/EngAntiIce2Switch",0)
		end
	},                                                  
	[15] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Eng1HydPumpSwitch",1)
			set("FJS/732/FltControls/Eng2HydPumpSwitch",1)
			set("FJS/732/FltControls/Elec1HydPumpSwitch",0)
			set("FJS/732/FltControls/Elec2HydPumpSwitch",0)
		end
	},                                                  	
	[16] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/ContCabinTempSelector",21)
			set("FJS/732/Pneumatic/PassCabinTempSelector",21)
		end
	},                     
	[17] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/GasperFanSwitch",1)
			set("FJS/732/Pneumatic/LPackSwitch",1)
			set("FJS/732/Pneumatic/RPackSwitch",0)
		end
	},                     
	[18] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/IsoValveSwitch",0)
			set("FJS/732/Pneumatic/EngBleed1Switch",0)
			set("FJS/732/Pneumatic/EngBleed2Switch",0)
			set("FJS/732/Pneumatic/APUBleedSwitch",1)
			set("FJS/732/Pneumatic/FltGndSwitch",0)
		end
	},     
	[19] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",0)
			set("FJS/732/lights/InBoundLLightSwitch2",0)
			set("FJS/732/lights/InBoundLLightSwitch1",0)
			set("FJS/732/lights/OutBoundLLightSwitch2",0)
			set("FJS/732/lights/OutBoundLLightSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch2",0)
		end
	},                     
	[20] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/StrobeLightSwitch",0)
			set("FJS/732/lights/StrobeLightSwitch",0)
			set("FJS/732/lights/AntiColLightSwitch",0)
			set("FJS/732/lights/WingLightSwitch",0)
			set("FJS/732/lights/LogoLightSwitch",0)
			set("FJS/732/lights/PositionLightSwitch",1)
		end
	},                     
	[21] = {["lefttext"] = "OTHER", ["timerincr"] = (get_zc_config("apuinit") and 48 or 1),
		["actions"] = function ()
			set("sim/flightmodel/controls/flaprqst",0)
			set("FJS/732/FltControls/SpeedBreakHandleMo",0)
			set("sim/flightmodel/controls/parkbrake",1)
			set("FJS/732/fuel/FuelMixtureLever1",0)
			set("FJS/732/fuel/FuelMixtureLever2",0)
			set("FJS/732/Eng/Engine1StartKnob",0)
			set("FJS/732/Eng/Engine2StartKnob",0)
			set("FJS/732/Radios/TransponderModeKnob",1)
			set("FJS/732/FltControls/AutoBrakeKnob",0)
		end
	},
	[22] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/GalleySwitch",0)
			set("FJS/732/DoorSta/AftStairSwitch",-1)
		end
	}, 
	[23] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/DCmeterKnob",0)
		end
	},                                                  
	[24] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/ACmeterKnob",0)
		end
	},                                                  
	[25] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "TURN AROUND STATE SET"
		end
	}
}

ZC_PRE_FLIGHT_PROC = {
	[0] = {["lefttext"] = "PRE FLIGHT PROCEDURE",["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PRE FLIGHT PROCEDURE")
		end
	},
	[1] = {["lefttext"] = "CAPT: SET UP COCKPIT LIGHTING AS REQD", ["timerincr"] = 1,
		["actions"] = function ()
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/732/lights/DomeWhiteSwitch",1)
			end
		end
	}, 
	[2] = {["lefttext"] = "CAPT: STALL WARNING TEST", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/Annun/StallWarningSwitch",1)
		end
	}, 
	[3] = {["lefttext"] = "CAPT: SET PARKING BRAKE", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Annun/StallWarningSwitch",0)
			set("sim/flightmodel/controls/parkbrake",1)
		end
	}, 
	[4] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "CAPT: CDU PREFLIGHT PROCEDURE"
			command_once("sim/FMS/CDU_popup")
			command_once("sim/FMS/fpln")
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status = 1
		end
	}, 
	[5] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "CDU PREFLIGHT PROCEDURE DONE"
		end
	}, 
	[6] = {["lefttext"] = "CAPT: MASTER LIGHTS TEST", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Annun/AnnunLightsSwitch",-1)
		end
	}, 
	[7] = {["lefttext"] = "CAPT: MASTER LIGHTS TEST", ["timerincr"] = 997,
		["actions"] = function ()
			set("FJS/732/Annun/AnnunLightsSwitch",0)
		end
	}, 
	[8] = {["lefttext"] = "CAPT: MCP - FLIGHT DIRECTORS ON", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/Autopilot/FDModeSelector",0)
			set("FJS/732/Annun/MachWarningTestButton",1)
		end
	}, 
	[9] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/autopilot/airspeed",zc_acf_getV2())
			set("sim/cockpit/autopilot/heading_mag",get_zc_brief_gen("glarehdg"))
			set("sim/cockpit/radios/nav1_obs_degm",get_zc_brief_gen("glarecrs1"))
			set("sim/cockpit/radios/nav2_obs_degm2",get_zc_brief_gen("glarecrs2"))
			set("FJS/732/Annun/MachWarningTestButton",0)
			set("FJS/732/num/FlipPo_15",0)
		end
	}, 
	[10] = {["lefttext"] = "CAPT: SET INITIAL ALTITUDE", ["timerincr"] = 3,
		["actions"] = function ()
			set("sim/cockpit/autopilot/altitude",get_zc_brief_gen("glarealt"))
		end
	}, 
	[11] = {["lefttext"] = "CAPT: SET STANDBY RMI", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit2/radios/actuators/RMI_left_use_adf_pilot",0)
			set("sim/cockpit2/radios/actuators/RMI_right_use_adf_pilot",0)
		end
	}, 
	[12] = {["lefttext"] = "CAPT: SPD BRAKE LEVER DOWN DETENT", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FltControls/SpeedBreakHandleMo",0)
		end
	}, 
	[13] = {["lefttext"] = "CAPT: RADIO TUNING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText= "SET RADIOS"
		end
	}, 
	[14] = {["lefttext"] = "CAPT: RADIO TUNING PANEL SET", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "RADIOS CHECKED AND SET"
		end
	}, 
	[15] = {["lefttext"] = "FO: YAW DAMPER ON", ["timerincr"] = 1,
		["actions"] = function ()
			 set("FJS/732/FltControls/YawDamperSwitch",1)
		end
	}, 
	[16] = {["lefttext"] = "FO: IFE & GALLEY POWER", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/Elec/GalleySwitch",1)
			if get("FJS/732/Elec/APUGenAmpsNeedle") == 0 then
				set("FJS/732/Elec/APUStartSwitch",2)
			end
		end
	}, 
	[17] = {["lefttext"] = "FO: EMERGENCY EXIT LIGHTS ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			set("FJS/732/num/FlipPo_10",0)
		end
	}, 
	[18] = {["lefttext"] = "FO: CABIN SIGNS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/NoSmokingSwitch",2)
			set("FJS/732/lights/FastenBeltsSwitch",2)
		end
	},                                                  
	[19] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatL1Switch",1)
		end
	}, 
	[20] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatL2Switch",1)
		end
	}, 
	[21] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatR1Switch",1)
		end
	}, 
	[22] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatR2Switch",1)
		end
	}, 
	[23] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Eng1HydPumpSwitch",1)
		end
	}, 
	[24] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Eng2HydPumpSwitch",1)
		end
	}, 
	[25] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Elec1HydPumpSwitch",0)
		end
	}, 
	[26] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Elec2HydPumpSwitch",0)
		end
	},	
	[27] = {["lefttext"] = "FO: GASPER FANS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/GasperFanSwitch",1)
		end
	}, 
	[28] = {["lefttext"] = "FO: PACKS SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/LPackSwitch",0)
			set("FJS/732/Pneumatic/RPackSwitch",1)
		end
	}, 
	[29] = {["lefttext"] = "FO: ISOLATION VLV OPEN", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/IsoValveSwitch",1)
		end
	}, 
	[30] = {["lefttext"] = "FO: BLEEDS ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/EngBleed1Switch",1)
			set("FJS/732/Pneumatic/EngBleed2Switch",1)
			set("FJS/732/Pneumatic/APUBleedSwitch",1)
		end
	}, 
	[31] = {["lefttext"] = "FO: FLT ALT & LAND ALT SET", ["timerincr"] = 1,
		["actions"] = function ()
			-- speakNoText(0,"SET LANDING AND FLIGHT ALTITUDE")
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status = 1
		end
	}, 
	[32] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/FlightAltSelector",ZC_BRIEF_GEN["cruisealt"]/1000)
		end
	}, 
	[33] = {["lefttext"] = "FO: FLT ALT & LAND ALT SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/LandingAltSelector1000",curralt_1000)
			set("FJS/732/Pneumatic/LandingAltSelector10",curralt_10)
		end
	}, 
	[34] = {["lefttext"] = "FO: WHEEL & LOGO LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/732/lights/WingLightSwitch",1)
				set("FJS/732/lights/LogoLightSwitch",1)
			end
		end
	}, 
	[35] = {["lefttext"] = "FO: WEATHER RADAR AND TERRAIN SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/wx/WXBRiteKnob",1)
			set("FJS/732/wx/WXSysKnob",2)
			set("FJS/732/wx/TCASButton",1)
		end
	}, 
	[36] = {["lefttext"] = "FO: TRANSPONDER CONTROL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/radios/transponder_code", 2000)
			set("FJS/732/wx/WXSysKnob",1)
			set("FJS/732/Annun/GPWS_SysTestButton",1)
		end
	}, 
	[37] = {["lefttext"] = "CAPT: NAVIGATION PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Inst/VHFNAV_Switch",0)
			set("FJS/732/Inst/CompassTransfer_Switch",0)
			set("FJS/732/Inst/VertGyro_Switch",0)
			set("FJS/732/Annun/GPWS_SysTestButton",0)
		end
	}, 
	[38] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			if get("FJS/732/Fuel/FuelQtyCNeedle") >  400 then
				set("FJS/732/Fuel/FuelPumpC1Switch",1)
			else
				set("FJS/732/Fuel/FuelPumpC1Switch",0)			
			end
		end
	}, 
	[39] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			if get("FJS/732/Fuel/FuelQtyCNeedle") >  400 then
				set("FJS/732/Fuel/FuelPumpC2Switch",1)
			else
				set("FJS/732/Fuel/FuelPumpC2Switch",0)
			end
		end
	}, 
	[40] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpL1Switch",1)
		end
	}, 
	[41] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpL2Switch",1)
		end
	}, 
	[42] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpR1Switch",1)
		end
	}, 
	[43] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpR2Switch",1)
		end
	}, 
	[44] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelCrossFeedSelector",0)
		end
	}, 
	[45] = {["lefttext"] = "FO: AUTOBRAKE OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/AutoBrakeKnob",0)
		end
	}, 
	[46] = {["lefttext"] = "FO: FUEL FLOW RESET", ["timerincr"] = 2,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelQtyTestButton",1)
		end
	}, 		
	[47] = {["lefttext"] = "FO: LOWER DU SYS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelQtyTestButton",0)
		end
	}, 		
	[48] = {["lefttext"] = "FO: PROBE HEAT OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/PitotStaticSwitchA",0)
			set("FJS/732/AntiIce/PitotStaticSwitchB",0)
		end
	}, 
	[49] = {["lefttext"] = "FO: AIR CONDITIONING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/ContCabinTempSelector",21)
			set("FJS/732/Pneumatic/PassCabinTempSelector",21)
		end
	}, 
	[50] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",0)
			set("FJS/732/lights/InBoundLLightSwitch2",0)
			set("FJS/732/lights/InBoundLLightSwitch1",0)
			set("FJS/732/lights/OutBoundLLightSwitch2",0)
			set("FJS/732/lights/OutBoundLLightSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch2",0)
		end
	},                     
	[51] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/StrobeLightSwitch",0)
			set("FJS/732/lights/StrobeLightSwitch",0)
			set("FJS/732/lights/AntiColLightSwitch",0)
			set("FJS/732/lights/PositionLightSwitch",1)
		end
	}, 
	[52] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/FireTestSwitch",1)
			set("FJS/732/lights/WingLightSwitch",1)
		end
	},
	[53] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/FireTestSwitch",0)
			set("FJS/732/FireProtect/CargoFireTestButton",1)
		end
	},
	[54] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/CargoFireTestButton",0)
			set("FJS/732/FireProtect/ExtinguisherTestSwitch",1)
		end
	},
	[55] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/FireProtect/ExtinguisherTestSwitch",0)
		end
	},
	[56] = {["lefttext"] = "CAPT: SET STAB TRIM ", ["timerincr"] = 5,
		["actions"] = function ()
			command_once("sim/flight_controls/pitch_trim_takeoff")
		end
	}, 
	[57] = {["lefttext"] = "CAPT: RUDDER & AILERON TRIM SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit2/controls/rudder_trim",0)
			set("sim/cockpit2/controls/aileron_trim",0)
		end
	},
	[58] = {["lefttext"] = "PREFLIGHT PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PREFLIGHT PROCEDURE FINISHED"
			speakNoText(0,"READY FOR BEFORE START CHECKLIST")
		end
	}
}

-- BEFORE START
-- FLIGHT DECK PREPARATION	 . . . . . 	COMPLETED
-- LIGHT TEST 				 . . . . . 	CHECKED
-- OXYGEN & INTERPHONE		 . . . . . 	CHECKED
-- YAW DAMPER				 . . . . . 	ON
-- NAVIGATION TRANSFER		 . . . . . 	AUTO
-- FUEL						 . . . . . 	_____KGS & PUMPS ON
-- GALLEY POWER				 . . . . . 	ON
-- EMERGENCY EXIT LIGHTS	 . . . . . 	ARMED
-- PASSENGER SIGNS			 . . . . . 	SET
-- WINDOW HEAT				 . . . . . 	ON
-- HYDRAULICS				 . . . . . 	NORMAL
-- AIR COND & PRESS			 . . . . .	___ PACK(S), BLEEDS ON, SET
-- AUTOPILOTS				 . . . . .	DISENGAGED
-- INSTRUMENTS				 . . . . .	X-CHECKED
-- SPEED BRAKE				 . . . . .	DOWN DETENT
-- PARKING BRAKE			 . . . . .	SET
-- STABILIZER TRIM CUTOUT SWITCHES . .	NORMAL
-- WHEEL WELL FIRE WARNING	 . . . . .	CHECKED
-- RADIOS, RADAR, TRANSPONDER  . . . .	SET
-- RUDDER & AILERON TRIM	 . . . . .	FREE & ZERO
-- PAPERS					 . . . . .	ON BOARD
-- FMC/CDU					 . . . . .	SET
-- N1 & IAS BUGS			 . . . . .	SET

ZC_BEFORE_START_CHECKLIST = {
	[0] = {["lefttext"] = "BEFORE START CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE START CHECKLIST")
			setchecklist(2)
		end
	},
	[1] = {["lefttext"] = "FLIGHT DECK PREPARATION -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FLIGHT DECK PREPARATION")
		end
	},
	[2] = {["lefttext"] = "FLIGHT DECK PREPARATION -- COMPLETED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"COMPLETED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "LIGHT TEST -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"LIGHT TEST")
		end
	},
	[4] = {["lefttext"] = "LIGHT TEST -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "OXYGEN & INTERPHONE -- CHECKED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"OXYGEN AND INTERPHONE")
		end
	},
	[6] = {["lefttext"] = "OXYGEN & INTERPHONE -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "YAW DAMPER -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"YAW DAMPER")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/YawDamperSwitch",1)
			end
		end
	},
	[8] = {["lefttext"] = "YAW DAMPER -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "NAVIGATION TRANSFER -- NORMAL", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"NAVIGATION TRANSFER")
			if get_zc_config("easy") then
				set("FJS/732/Inst/VHFNAV_Switch",0)
				set("FJS/732/Inst/CompassTransfer_Switch",0)
				set("FJS/732/Inst/VertGyro_Switch",0)
			end
		end
	},
	[10] = {["lefttext"] = "NAVIGATION TRANSFER -- AUTO", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"NORMAL")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "FUEL -- ___ KGS/LBS PUMPS ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FUEL")
				if get_zc_config("easy") then
				set("FJS/732/Fuel/FuelPumpL1Switch",1)
				set("FJS/732/Fuel/FuelPumpL2Switch",1)
				set("FJS/732/Fuel/FuelPumpR1Switch",1)
				set("FJS/732/Fuel/FuelPumpR2Switch",1)
				if get("FJS/732/Fuel/FuelQtyCNeedle") > 400 then
					set("FJS/732/Fuel/FuelPumpC1Switch",1)
					set("FJS/732/Fuel/FuelPumpC2Switch",1)
				end
			end
		end
	},
	[12] = {["lefttext"] = "FUEL -- ____ KGS/LBS PUMPS ON", ["timerincr"] = 999,
		["actions"] = function ()
			if get_zc_config("kglbs") then
				speakNoText(0,string.format("%i kilograms and pumps are on",zc_get_total_fuel()))
				gLeftText = string.format("FUEL -- %i KGS & PUMPS ON",zc_get_total_fuel())
			else
				speakNoText(0,string.format("%i pounds and pumps are on",zc_get_total_fuel()))
				gLeftText = string.format("FUEL -- %i LBS & PUMPS ON",zc_get_total_fuel())
			end
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "GALLEY POWER -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"GALLEY POWER")
			if get_zc_config("easy") then
				set("FJS/732/Elec/GalleySwitch",1)
			end
		end
	},
	[14] = {["lefttext"] = "GALLEY POWER -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[15] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"EMERGENCY EXIT LIGHTS")
			if get_zc_config("easy") then
				set("FJS/732/num/FlipPo_10",0)
			end
		end
	},
	[16] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- ARMED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ARMED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[17] = {["lefttext"] = "PASSENGER SIGNS -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PASSENGER SIGNS")
			if get_zc_config("easy") then
				set("FJS/732/lights/NoSmokingSwitch",2)
				set("FJS/732/lights/FastenBeltsSwitch",2)
			end
		end
	},
	[18] = {["lefttext"] = "PASSENGER SIGNS -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[19] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"WINDOW HEAT")
			if get_zc_config("easy") then
				set("FJS/732/AntiIce/WindowHeatL1Switch",1)
				set("FJS/732/AntiIce/WindowHeatL2Switch",1)
				set("FJS/732/AntiIce/WindowHeatR1Switch",1)
				set("FJS/732/AntiIce/WindowHeatR2Switch",1)
			end
		end
	},
	[20] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[21] = {["lefttext"] = "HYDRAULICS -- NORMAL", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"HYDRAULICS")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/Eng1HydPumpSwitch",1)
				set("FJS/732/FltControls/Eng2HydPumpSwitch",1)
				set("FJS/732/FltControls/Elec1HydPumpSwitch",0)
				set("FJS/732/FltControls/Elec2HydPumpSwitch",0)
			end
		end
	},
	[22] = {["lefttext"] = "HYDRAULICS -- NORMAL", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"NORMAL")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[23] = {["lefttext"] = "AIR COND & PRESS -- PACK(S) SET, BLEEDS ON, SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AIR CONDITIONING AND PRESSURIZATION")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/LPackSwitch",0)
				set("FJS/732/Pneumatic/RPackSwitch",1)
				set("FJS/732/Pneumatic/IsoValveSwitch",1)
				set("FJS/732/Pneumatic/EngBleed1Switch",1)
				set("FJS/732/Pneumatic/EngBleed2Switch",1)
				set("FJS/732/Pneumatic/APUBleedSwitch",1)
			end
		end
	},
	[24] = {["lefttext"] = "AIR COND & PRESS -- PACK(S) SET, BLEEDS ON, SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[25] = {["lefttext"] = "AUTOPILOTS -- DISENGAGED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AUTOPILOTS")
			if get_zc_config("easy") then
				if get("FJS/732/Autopilot/APPitchEngageSwitch") > 0 then
					command_once("FJS/732/Autopilot/AP_PitchSelect")
				end
				if get("FJS/732/Autopilot/APRollEngageSwitch") > 0 then
					command_once("FJS/732/Autopilot/AP_RollSelect")
				end
			end
		end
	},
	[26] = {["lefttext"] = "AUTOPILOTS -- DISENGAGED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"DISENGAGED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[27] = {["lefttext"] = "INSTRUMENTS -- X-CHECKED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"INSTRUMENTS")
		end
	},
	[28] = {["lefttext"] = "INSTRUMENTS -- X-CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CROSS CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[29] = {["lefttext"] = "SPEED BRAKE -- DOWN DETENT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SPEED BRAKE")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/SpeedBreakHandleMo",0)
			end
		end
	},
	[30] = {["lefttext"] = "SPEED BRAKE -- DOWN DETENT", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"DOWN DETENT")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[31] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PARKING BRAKE")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/ParkBrakeHandle",1)
			end
		end
	},
	[32] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[33] = {["lefttext"] = "STABILIZER TRIM CUTOUT SWITCHES -- NORMAL", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"STABILIZER TRIM CUTOUT SWITCHES")
		end
	},
	[34] = {["lefttext"] = "STABILIZER TRIM CUTOUT SWITCHES -- NORMAL", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"NORMAL")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[35] = {["lefttext"] = "WHEEL WELL FIRE WARNING -- CHECKED", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"WHEEL WELL FIRE WARNING")
		end
	},
	[36] = {["lefttext"] = "WHEEL WELL FIRE WARNING -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[37] = {["lefttext"] = "RADIOS, RADAR, TRANSPONDER -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"RADIOS, RADAR, TRANSPONDER")
			if get_zc_config("easy") then
				set("FJS/732/Radios/TransponderModeKnob",1)
				set("FJS/732/wx/WXSysKnob",0)
				set("FJS/732/wx/WXModeMapKnob",3)
				set("FJS/732/wx/TiltKnob",0)
				set("FJS/732/wx/TCASButton",1)
			end
		end
	},
	[38] = {["lefttext"] = "RADIOS, RADAR, TRANSPONDER -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[39] = {["lefttext"] = "RUDDER & AILERON TRIM -- FREE & ZERO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"RUDDER and AILERON TRIM")
			if get_zc_config("easy") then
				set("sim/cockpit2/controls/rudder_trim",0)
				set("sim/cockpit2/controls/aileron_trim",0)
				command_once("sim/flight_controls/pitch_trim_takeoff")
			end
		end
	},
	[40] = {["lefttext"] = "RUDDER & AILERON TRIM -- FREE & ZERO", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FREE and Zero")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[41] = {["lefttext"] = "PAPERS -- ON BOARD", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Papers")
		end
	},
	[42] = {["lefttext"] = "PAPERS -- ON BOARD", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"on board")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[43] = {["lefttext"] = "FMC/CDU -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"f m c and c d u")
		end
	},
	[44] = {["lefttext"] = "FMC/CDU -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"set")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[45] = {["lefttext"] = "N1 & IAS BUGS -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"N 1 and I A S BUGS")
		end
	},
	[46] = {["lefttext"] = "N1 & IAS BUGS -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"set")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[47] = {["lefttext"] = "BEFORE START CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE START CHECKLIST COMPLETED")
		end
	},
	[48] = {["lefttext"] = "BEFORE START CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE START CHECKLIST COMPLETED"
		end
	}
}

ZC_DEPARTURE_BRIEFING = {
	[0] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ARE YOU READY FOR THE TAKEOFF BRIEF?"
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status=1
		end
	},
	[1] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ARE YOU READY FOR THE TAKEOFF BRIEF ?")
		end
	},
	[2] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 998,
		["actions"] = function ()
			speakNoText(0,"YES")
		end
	},
	[3] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"OK, I will be the pilot flying")
		end
	},
	[4] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"We have no M E L issues today")
		end
	},
	[5] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"This will be a standard takeoff, noise abatement departure procedure "..DEP_nadp_list[get_zc_brief_dep("depnadp")])
		end
	},
	[6] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"The departure will be via ".. DEP_proctype_list[get_zc_brief_dep("deptype")].." "..convertNato(get_zc_brief_dep("sid")))
		end
	},
	[7] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Our take off thrust is "..DEP_takeofthrust_list[get_zc_brief_dep("tothrust")])
		end
	},
	[8] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"We will use Flaps "..MD88:getDEP_Flaps()[get_zc_brief_dep("toflaps")].." for takeoff")
		end
	},
	[9] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Runway condition is "..DEP_rwystate_list[get_zc_brief_dep("rwycond")])
		end
	},
	[10] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Anti Ice is "..DEP_aice_list[get_zc_brief_dep("depaice")])
		end
	},
	[11] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Bleeds will be "..DEP_bleeds_list[get_zc_brief_dep("depbleeds")])
		end
	},
	[12] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"In case of forced return we are "..DEP_forced_return[get_zc_brief_dep("forcedReturn")])
		end
	},
	[13] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"For the takeoff safety brief")
		end
	},
	[14] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"From 0 to 100 knots for any malfunction I will call reject and we will confirm the autobrakes are operating")
		end
	},
	[15] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"If not operating I will apply maximum manual breaking and maximum symmetric reverse thrust and come to a full stop on the runway")
		end
	},
	[16] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"After full stop on the runway we decide on course of further actions")
		end
	},
	[17] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 10,
		["actions"] = function ()
			speakNoText(0,"From 100 knots to V 1 I will reject only for one of the following reasons,   engine fire, engine failure or takeoff configuration warning horn")
		end
	},
	[18] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 10,
		["actions"] = function ()
			speakNoText(0,"At and above V 1 we will continue into the air and the only actions for you below 400 feet are to silence any alarm bells and confirm any failures")
		end
	},
	[19] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"Above 400 feet I will call for failure action drills as required and you'll perform memory items")
		end
	},
	[20] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"at 800 feet above field elevation I will call for altitude hold and we will retract the flaps on schedule")
		end
	},
	[21] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"At 1500 feet I will call for the checklist")
		end
	},
	[22] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"If we are above maximum landing weight we will make decision on whether to perform an overweight landing if the situation requires")
		end
	},
	[23] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 9,
		["actions"] = function ()
			speakNoText(0,"If we have a wheel well,   engine or wing fire,   I will turn the aircraft in such a way the flames will be downwind and we will evacuate through the upwind side")
		end
	},
	[24] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 9,
		["actions"] = function ()
			speakNoText(0,"If we have a cargo fire you need to ensure emergency services do not open the cargo doors until evac is completed")
		end
	},
	[25] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"Any questions or concerns?")
		end
	},
	[26] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"no")
		end
	},	
	[27] = {["lefttext"] = "DEPARTURE BRIEFING COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"DEPARTURE BRIEFING COMPLETED")	
		end
	},
	[28] = {["lefttext"] = "DEPARTURE BRIEFING COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			speakNoText(0,"DEPARTURE BRIEFING COMPLETED")
		end
	}
}

ZC_BEFORE_START_PROC = {
	[0] = {["lefttext"] = "CLEARED FOR START PROCEDURE",["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PERFORMING BEFORE START ITEMS")
			gRightText = "CLEARED FOR START PROCEDURE"
		end
	},  
	[1] = {["lefttext"] = "FO: ISOLATION VLV OPEN", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/IsoValveSwitch",1)
		end
	}, 
	[2] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Elec1HydPumpSwitch",1)
		end
	}, 
	[3] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Elec2HydPumpSwitch",1)
		end
	},
	[4] = {["lefttext"] = "FO: BEACON ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/AntiColLightSwitch",1)
		end
	}, 
	[5] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("V 1 %i",zc_acf_getV1()))
			gLeftText = string.format("V 1 %i",zc_acf_getV1())
		end
	}, 
	[6] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("V Rotate %i",zc_acf_getVr()))
			gLeftText = string.format("V Rotate %i",zc_acf_getVr())
		end
	}, 
	[7] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("V 2 %i",zc_acf_getV2()))
			gLeftText = string.format("V 2 %i",zc_acf_getV2())
		end
	}, 
	[8] = {["lefttext"] = "CLEARED FOR START PROCEDURE COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CLEARED FOR START PROCEDURE COMPLETED")
		end
	},
	[9] = {["lefttext"] = "CLEARED FOR START PROCEDURE COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "CLEARED FOR START PROCEDURE COMPLETED"
			speakNoText(0,"READY CLEARED FOR START CHECKLIST")
			ZC_BACKGROUND_PROCS["APUBUSON"].status = 0
		end
	}
}
 
-- – – – – – – – – – – CLEARED FOR START – – – – – – – – –
-- MOBILE PHONES			. . . . .	OFF
-- DOORS					. . . . .	CLOSED
-- AIR CONDITIONING PACKS	. . . . .	OFF
-- ANTICOLLISION LIGHT		. . . . .	ON

ZC_CLEARED_FOR_START_CHECKLIST = {
	[0] = {["lefttext"] = "CLEARED FOR START CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"CLEARED FOR START CHECKLIST")
			setchecklist(3)
		end
	},
	[1] = {["lefttext"] = "MOBILE PHONES -- OFF", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"MOBILE PHONES")
		end
	},
	[2] = {["lefttext"] = "MOBILE PHONES -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "DOORS -- CLOSED", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"DOORS")
		if get_zc_config("easy") then
				set("FJS/732/cabin/CockpitDoorTrig",0)
			end
		end
	},
	[4] = {["lefttext"] = "DOORS -- CLOSED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CLOSED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "AIR CONDITIONING PACKS -- OFF", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"AIR CONDITIONING PACKS")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/LPackSwitch",0)
				set("FJS/732/Pneumatic/RPackSwitch",0)
				set("FJS/732/Pneumatic/IsoValveSwitch",1)
				set("FJS/732/Pneumatic/EngBleed1Switch",1)
				set("FJS/732/Pneumatic/EngBleed2Switch",1)
				set("FJS/732/Pneumatic/APUBleedSwitch",1)
			end
		end
	},
	[6] = {["lefttext"] = "AIR CONDITIONING PACKS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "ANTICOLLISION LIGHT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ANTICOLLISION LIGHT")
			if get_zc_config("easy") then
				set("FJS/732/lights/AntiColLightSwitch",1)
			end
		end
	},
	[8] = {["lefttext"] = "ANTICOLLISION LIGHT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "CLEARED FOR START CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CLEARED FOR START CHECKLIST COMPLETED")	
		end
	},
	[10] = {["lefttext"] = "CLEARED FOR START CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "CLEARED FOR START CHECKLIST COMPLETED"
		end
	}
}

ZC_PREPARE_PUSH = {
	[0] = {["lefttext"] = "PUSHBACK",["timerincr"] = 1,
		["actions"] = function ()
			gRightText = "PREPARE PUSHBACK"
		end
	},  
	[1] = {["lefttext"] = "CALL PUSHBACK TRUCK",["timerincr"] = 1,
		["actions"] = function ()
		gLeftText = "CALL PUSHBACK TRUCK"
		end
	},
	[2] = {["lefttext"] = "CALL PUSHBACK TRUCK",["timerincr"] = 998,
		["actions"] = function ()
			command_once("BetterPushback/start")
		end
	},
	[3] = {["lefttext"] = "PROCEDURE ONGOING", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PUSHBACK ONGOING"
		end
	} 
}

ZC_STARTENGINE_PROC = {
	[0] = {["lefttext"] = "START SEQUENCE IS TWO THEN ONE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"START SEQUENCE IS TWO THEN ONE")
		end
	},
	[1] = {["lefttext"] = "AIR - BLEEDS - PACKS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/LPackSwitch",0)
			set("FJS/732/Pneumatic/RPackSwitch",0)
			set("FJS/732/Pneumatic/IsoValveSwitch",1)
			set("FJS/732/Pneumatic/APUBleedSwitch",1)
			set("FJS/732/Pneumatic/EngBleed1Switch",1)
			set("FJS/732/Pneumatic/EngBleed2Switch",1)
		end
	},
	[2] = {["lefttext"] = "START ENGINE TWO", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "START ENGINE TWO"
			speakNoText(0,"start engine 2")
		end
	},
	[3] = {["lefttext"] = "START ENGINE TWO", ["timerincr"] = 997,
		["actions"] = function ()
			set("FJS/732/Eng/Engine2StartKnob",-1)
		end
	},
	[4] = {["lefttext"] = "WAIT FOR N2 25", ["timerincr"] = 1,
		["actions"] = function ()
		ZC_BACKGROUND_PROCS["FUEL2IDLE"].status=1
		ZC_BACKGROUND_PROCS["STARTERCUT2"].status=1
		end
	},
	[5] = {["lefttext"] = "STARTER CUTOUT?", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "STARTER CUTOUT?"
		end
	},
	[6] = {["lefttext"] = "STARTER CUTOUT?", ["timerincr"] = 997,
		["actions"] = function ()
		end
	},
	[7] = {["lefttext"] = "START ENGINE ONE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "START ENGINE ONE"
			speakNoText(0,"START ENGINE ONE")
		end
	},
	[8] = {["lefttext"] = "START ENGINE ONE", ["timerincr"] = 997,
		["actions"] = function ()
			set("FJS/732/Eng/Engine1StartKnob",-1)
		end
	},
	[9] = {["lefttext"] = "WAIT FOR N2 25", ["timerincr"] = 1,
		["actions"] = function ()
		ZC_BACKGROUND_PROCS["FUEL1IDLE"].status=1
		ZC_BACKGROUND_PROCS["STARTERCUT1"].status=1
		end
	},
	[10] = {["lefttext"] = "STARTER CUTOUT?", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "STARTER CUTOUT?"
		end
	},
	[11] = {["lefttext"] = "STARTER CUTOUT?", ["timerincr"] = 997,
		["actions"] = function ()
		end
	},
	[12] = {["lefttext"] = "TWO GOOD STARTS", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "TWO GOOD STARTS"
		end
	},
	[13] = {["lefttext"] = "TWO GOOD STARTS", ["timerincr"] = -1,
		["actions"] = function ()
			speakNoText(0,"we have two good starts")
		end
	}
}

ZC_FLIGHT_CONTROLS_CHECK = {
	[0] = {["lefttext"] = "FLIGHT CONTROLS CHECK", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"FLIGHT CONTROLS CHECK")
		end
	},
	[1] = {["lefttext"] = "FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 997,
		["actions"] = function ()
		end
	},
	[2] = {["lefttext"] = "FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL LEFT")
		end
	},
	[3] = {["lefttext"] = "FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[4] = {["lefttext"] = "FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL RIGHT")
		end
	},
	[5] = {["lefttext"] = "FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[6] = {["lefttext"] = "FULL UP - FULL DOWN - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL UP")
		end
	},
	[7] = {["lefttext"] = "FULL UP - FULL DOWN - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL DOWN")
		end
	},
	[8] = {["lefttext"] = "FULL UP - FULL DOWN - CENTER", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[9] = {["lefttext"] = "RUDDER FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL LEFT")
		end
	},
	[10] = {["lefttext"] = "RUDDER FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[11] = {["lefttext"] = "RUDDER FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL RIGHT")
		end
	},
	[12] = {["lefttext"] = "RUDDER FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[13] = {["lefttext"] = "FLIGHT CONTROLS CHECKED", ["timerincr"] = -1,
		["actions"] = function ()
			speakNoText(0,"after start procedure please")
		end
	}
}

ZC_BEFORE_TAXI_PROC = {
	[0] = {["lefttext"] = "AFTER START PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"AFTER START PROCEDURE")
			ZC_BACKGROUND_PROCS["FUEL1IDLE"].status = 0
			ZC_BACKGROUND_PROCS["FUEL2IDLE"].status = 0
			ZC_BACKGROUND_PROCS["STARTERCUT1"].status = 0
			ZC_BACKGROUND_PROCS["STARTERCUT2"].status = 0
		end
	},
	[1] = {["lefttext"] = "FO: GENERATORS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/Gen1Switch",1)
			set("FJS/732/Elec/Gen2Switch",1)
		end
	},
	[2] = {["lefttext"] = "FO: PROBE HEAT -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/Gen1Switch",0)
			set("FJS/732/Elec/Gen2Switch",0)
			set("FJS/732/AntiIce/PitotStaticSwitchA",1)
			set("FJS/732/AntiIce/PitotStaticSwitchB",1)
		end
	},
	[3] = {["lefttext"] = "FO: ISOLATION VALVES/PACKS -- AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/LPackSwitch",1)
			set("FJS/732/Pneumatic/RPackSwitch",1)
			set("FJS/732/Pneumatic/IsoValveSwitch",1)
			set("FJS/732/Pneumatic/APUBleedSwitch",0)
		end
	},
	[4] = {["lefttext"] = "FO: HYDRAULICS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Eng1HydPumpSwitch",1)
			set("FJS/732/FltControls/Eng2HydPumpSwitch",1)
			set("FJS/732/FltControls/Elec1HydPumpSwitch",1)
			set("FJS/732/FltControls/Elec2HydPumpSwitch",1)
		end
	},
	[5] = {["lefttext"] = "FO: APU -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/APUStartSwitch",0)
		end
	},
	[6] = {["lefttext"] = "FO: TAKEOFF FLAPS -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"SET TAKEOFF FLAPS")
			set("sim/cockpit2/controls/flap_ratio",MD88:getDEP_Flaps_val()[get_zc_brief_dep("toflaps")])
		end
	},
	[7] = {["lefttext"] = "AFTER START PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "AFTER START PROCEDURE FINISHED"
			speakNoText(0,"AFTER START CHECKLIST")
		end
	} 	
}

-- AFTER START
-- ELECTRICAL			. . . . . .	GENERATORS ON
-- PROBE HEAT			. . . . . .	ON
-- ANTI–ICE				. . . . . .	AS REQUIRED
-- AIR COND & PRESS		. . . . . .	PACKS ON
-- ISOLATION VALVE		. . . . . .	AUTO
-- APU					. . . . . .	AS REQUIRED
-- START LEVERS			. . . . . .	IDLE DETENT

ZC_BEFORE_TAXI_CHECKLIST = {
	[0] = {["lefttext"] = "AFTER START CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"AFTER START CHECKLIST")
			setchecklist(4)
		end
	},
	[1] = {["lefttext"] = "ELECTRICAL GENERATORS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ELECTRICAL GENERATORS")
			if get_zc_config("easy") then
				set("FJS/732/Elec/Gen1Switch",1)
				set("FJS/732/Elec/Gen2Switch",1)
			end
		end
	},
	[2] = {["lefttext"] = "ELECTRICAL GENERATORS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "PROBE HEAT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PROBE HEAT")
			if get_zc_config("easy") then
				set("FJS/732/AntiIce/PitotStaticSwitchA",1)
				set("FJS/732/AntiIce/PitotStaticSwitchB",1)
			end
		end
	},
	[4] = {["lefttext"] = "PROBE HEAT -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "ANTI-ICE -- AS REQUIRED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ANTI-ICE")
		end
	},
	[6] = {["lefttext"] = "ANTI-ICE -- AS REQUIRED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"AS REQUIRED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "AIR COND & PRESS -- PACKS ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AIR CONDITIONING and PRESSURIZATION")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/LPackSwitch",1)
				set("FJS/732/Pneumatic/RPackSwitch",1)
			end
		end
	},
	[8] = {["lefttext"] = "AIR COND & PRESS -- PACKS ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"PACKS ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "ISOLATION VALVE -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ISOLATION VALVE")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/IsoValveSwitch",1)
			end
		end
	},
	[10] = {["lefttext"] = "ISOLATION VALVE -- AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AUTO")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "APU -- AS REQUIRED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"A P U")
		end
	},
	[12] = {["lefttext"] = "APU -- AS REQUIRED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AS REQUIRED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "ENGINE START LEVERS -- IDLE DETENT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ENGINE START LEVERS")
		end
	},
	[14] = {["lefttext"] = "ENGINE START LEVERS -- IDLE DETENT", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"IDLE DETENT")
			command_once("bgood/xchecklist/check_item")
		end
	},	
	[15] = {["lefttext"] = "CLEAR LEFT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CLEAR LEFT")
		end
	},
	[16] = {["lefttext"] = "CLEAR RIGHT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CLEAR RIGHT")
		end
	},
	[17] = {["lefttext"] = "AFTER START CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AFTER START CHECKLIST COMPLETED")	
		end
	},
	[18] = {["lefttext"] = "AFTER START CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "AFTER START CHECKLIST COMPLETED"
		end
	}
}

-- BEFORE TAKEOFF
-- RECALL				. . . . . .	CHECKED
-- FLIGHT CONTROLS		. . . . . .	CHECKED
-- FLAPS				. . . . . .	_____, GREEN LIGHT
-- STABILIZER TRIM		. . . . . .	_____UNITS
-- CABIN DOOR			. . . . . .	LOCKED
-- TAKEOFF BRIEFING		. . . . . .	REVIEWED

ZC_BEFORE_TAKEOFF_CHECKLIST = {
	[0] = {["lefttext"] = "BEFORE TAKEOFF CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAKE OFF CHECKLIST")
			setchecklist(5)
		end
	},
	[1] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"RECALL")
		end
	},
	[2] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "FLIGHT CONTROLS -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLIGHT CONTROLS")
		end
	},
	[4] = {["lefttext"] = "FLIGHT CONTROLS -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "FLAPS -- FLAPS __ GREEN LIGHT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
		end
	},
	[6] = {["lefttext"] = "FLAPS -- FLAPS __ GREEN LIGHT", ["timerincr"] = 3,
		["actions"] = function ()
			local flaps = MD88:getDEP_Flaps()[math.floor(get("sim/flightmodel/controls/flaprqst")/0.125)+1]
			speakNoText(0,string.format("FLAPS %i GREEN LIGHT",flaps))
			gLeftText = string.format("FLAPS %i GREEN LIGHT",flaps)
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "STABILIZER TRIM -- __ UNITS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"STABILIZER TRIM")
			zc_acf_setTOTrim()
			gLeftText = string.format("STABILIZER TRIM -- %.2f UNITS",zc_acf_getTrim())
		end
	},
	[8] = {["lefttext"] = "STABILIZER TRIM -- __ UNITS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("%.2f units",zc_acf_getTrim()))
			gLeftText = string.format("STABILIZER TRIM -- %.2f UNITS",zc_acf_getTrim())
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "CABIN DOOR -- LOCKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CABIN DOOR")
		end
	},
	[10] = {["lefttext"] = "CABIN DOOR -- LOCKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"LOCKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "TAKEOFF BRIEFING -- REVIEWED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"TAKE OFF BRIEFING")
		end
	},
	[12] = {["lefttext"] = "TAKEOFF BRIEFING -- REVIEWED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"REVIEWED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "BEFORE TAKE OFF CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAKE OFF CHECKLIST COMPLETED")		
		end
	},
	[14] = {["lefttext"] = "BEFORE TAKE OFF CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE TAKE OFF CHECKLIST COMPLETED"
		end
	}
}

-- – – – – – – – – – CLEARED FOR TAKEOFF – – – – – – – –
-- TRANSPONDER 			. . . . . .	ON

ZC_BEFORE_TAKEOFF_PROC = {
	[0] = {["lefttext"] = "BEFORE TAKEOFF PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAKEOFF PROCEDURE")
		end
	},
	[1] = {["lefttext"] = "LANDING LIGHTS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/InBoundLLightSwitch2",1)
			set("FJS/732/lights/InBoundLLightSwitch1",1)
			set("FJS/732/lights/OutBoundLLightSwitch2",2)
			set("FJS/732/lights/OutBoundLLightSwitch1",2)
		end
	},
	[2] = {["lefttext"] = "STROBES -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/StrobeLightSwitch",1)
		end
	},
	[3] = {["lefttext"] = "TAXI LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",0)
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/732/lights/RunwayTurnoffSwitch1",1)
				set("FJS/732/lights/RunwayTurnoffSwitch2",1)
			end
		end
	},
	[4] = {["lefttext"] = "TRANSPONDER -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/radios/transponder_code",get_zc_brief_gen("squawk"))
			set("FJS/732/Radios/TransponderModeKnob",5)
			set("FJS/732/wx/WXSysKnob",2)
			set("FJS/732/lights/NoSmokingSwitch",0)
			command_once("sim/instruments/timer_reset")
			elapsed_time_visible = 1
			speakNoText(0,"transponder    t a r a")
		end
	},
	[5] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE TAKEOFF PROCEDURE FINISHED"
			if get("sim/cockpit2/clock_timer/timer_running") == 0 then
				command_once("sim/instruments/timer_start_stop")
			end
			set("FJS/732/lights/NoSmokingSwitch",1)
		end
	}
}

ZC_CLIMB_PROC = {
	[0] = {["lefttext"] = "TAKEOFF AND CLIMB PROCEDURE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET TAKEOFF THRUST"
			if get_zc_config("easy") then
				ZC_BACKGROUND_PROCS["V1"].status = 1
				ZC_BACKGROUND_PROCS["ROTATE"].status = 1
			end
		end
	},
	[1] = {["lefttext"] = "SET TAKEOFF THRUST", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				ZC_BACKGROUND_PROCS["FLAPSUPSCHED"].status = 1
				ZC_BACKGROUND_PROCS["GEARUP"].status = 1
				ZC_BACKGROUND_PROCS["80KTS"].status = 1
			end
		end
	},
	[2] = {["lefttext"] = "GEAR UP", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "GEAR UP"
		end
	},
	[3] = {["lefttext"] = "GEAR UP", ["timerincr"] = get_zc_config("easy") and 1 or 997,
		["actions"] = function ()
			if get_zc_config("easy") == false then
				speakNoText(0,"POSITIV RATE    GEAR UP")
				command_once("sim/flight_controls/landing_gear_up")
			end
		end
	},
	[4] = {["lefttext"] = "SET AUTOPILOT MODES",["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET AUTOPILOT"
		end
	},
	[5] = {["lefttext"] = "SET AUTOPILOT MODES",["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"Autopilot modes")
			if get("FJS/732/Autopilot/APPitchEngageSwitch") == 0 then
				command_once("FJS/732/Autopilot/AP_PitchSelect")
			end
			if get("FJS/732/Autopilot/APRollEngageSwitch") == 0 then
				command_once("FJS/732/Autopilot/AP_RollSelect")
			end
		end
	},
	[6] = {["lefttext"] = "SET AUTOPILOT MODES",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_brief_dep("lnavvnav") == 1 then
				if get("FJS/732/Autopilot/FDModeSelector") == 0 then
					command_once("FJS/732/Autopilot/FD_SelectRight")
				end
				if get("FJS/732/Autopilot/APPitchSelector") == 0 then
					command_once("FJS/732/Autopilot/PitchSelectLeft")
				end
				if get("FJS/732/Autopilot/APHeadingSwitch") < 0 then
					command_once("FJS/732/Autopilot/AP_HDG_DOWN")
					command_once("FJS/732/Autopilot/AP_HDG_DOWN")
				end
			else
				if get("FJS/732/Autopilot/FDModeSelector") == 0 then
					command_once("FJS/732/Autopilot/FD_SelectRight")
					command_once("FJS/732/Autopilot/FD_SelectRight")
				end
				if get("FJS/732/Autopilot/APModeSelector") == 0 then
					command_once("FJS/732/Autopilot/NavSelectRight")
				end
				if get("FJS/732/Autopilot/APPitchSelector") == 0 then
					command_once("FJS/732/Autopilot/PitchSelectLeft")
				end
			end
		end
	},
	[7] = {["lefttext"] = "FLAPS 10",["timerincr"] = 0.125==5 and 1 or 996,
		["actions"] = function ()
			gLeftText = "FLAPS 10"
		end
	},
	[8] = {["lefttext"] = "FLAPS 10",["timerincr"] = (get_zc_config("easy") == false and get("sim/flightmodel/controls/flaprqst")/0.125==5) and 997 or 996,
		["actions"] = function ()
			if get_zc_config("easy") == false then
				speakNoText(0,"SPEED CHECK   FLAPS 10")
				set("sim/flightmodel/controls/flaprqst",0.5)
			end
		end
	},
	[9] = {["lefttext"] = "FLAPS 5",["timerincr"] = (get_zc_config("easy") == false and get("sim/flightmodel/controls/flaprqst")/0.125>3) and 1 or 996,
		["actions"] = function ()
			gLeftText = "FLAPS 5"
		end
	},
	[10] = {["lefttext"] = "FLAPS 5",["timerincr"] = (get_zc_config("easy") == false and get("sim/flightmodel/controls/flaprqst")/0.125>3) and 997 or 996,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 5")
			set("sim/flightmodel/controls/flaprqst",0.375)
		end
	},
	[11] = {["lefttext"] = "FLAPS 1",["timerincr"] = (get_zc_config("easy") == false and get("sim/flightmodel/controls/flaprqst")/0.125>=2) and 1 or 996,
		["actions"] = function ()
			gLeftText = "FLAPS 1"
		end
	},
	[12] = {["lefttext"] = "FLAPS 1",["timerincr"] = (get_zc_config("easy") == false and get("sim/flightmodel/controls/flaprqst")/0.125>=2) and 997 or 996,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 1")
			set("sim/flightmodel/controls/flaprqst",0.125)
		end
	},
	[13] = {["lefttext"] = "FLAPS UP",["timerincr"] = get_zc_config("easy") == false and 1 or 996,
		["actions"] = function ()
			speakNoText(0,"FLAPS UP")
		end
	},
	[14] = {["lefttext"] = "FLAPS UP",["timerincr"] = get_zc_config("easy") == false and 997 or 996,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS UP")
			set("sim/flightmodel/controls/flaprqst",0)
		end
	},
	[15] = {["lefttext"] = "GEAR OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("FJS/727/Hyd/Com/GearHandleTuggle")
		end
	}, 
	[16] = {["lefttext"] = "AFTER TAKEOFF ITEMS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/InBoundLLightSwitch2",1)
			set("FJS/732/lights/InBoundLLightSwitch1",1)
			set("FJS/732/lights/OutBoundLLightSwitch2",0)
			set("FJS/732/lights/OutBoundLLightSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch2",0)
		end
	},
	[17] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			ZC_BACKGROUND_PROCS["TRANSALT"].status = 1
			ZC_BACKGROUND_PROCS["TENTHOUSANDUP"].status = 1
			gLeftText = "CLIMB PROCEDURE FINISHED"
		end
	} 	
}

-- AFTER TAKEOFF
-- AIR COND & PRESS			. . . . . .	SET
-- ENGINE START SWITCHES	. . . . . .	OFF
-- LANDING GEAR				. . . . . .	UP & OFF
-- FLAPS					. . . . . .	UP, NO LIGHTS

ZC_AFTER_TAKEOFF_CHECKLIST = {
	[0] = {["lefttext"] = "AFTER TAKEOFF CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"AFTER TAKE OFF CHECKLIST")
			setchecklist(6)
			ZC_BACKGROUND_PROCS["80KTS"].status = 0
			ZC_BACKGROUND_PROCS["GEARUP"].status = 0
		end
	},
	[1] = {["lefttext"] = "ENGINE BLEEDS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ENGINE BLEEDS")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/EngBleed1Switch",1)
				set("FJS/732/Pneumatic/EngBleed2Switch",1)
			end
		end
	},
	[2] = {["lefttext"] = "ENGINE BLEEDS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "PACKS -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PACKS")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/LPackSwitch",1)
				set("FJS/732/Pneumatic/RPackSwitch",1)
			end
		end
	},
	[4] = {["lefttext"] = "PACKS -- AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AUTO")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "LANDING GEAR -- UP AND OFF", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"LANDING GEAR")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/GearHandleMo",1)
			end
		end
	},
	[6] = {["lefttext"] = "LANDING GEAR -- UP AND OFF", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"UP AND OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "FLAPS -- UP NO LIGHTS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
			if get_zc_config("easy") then
				set("sim/flightmodel/controls/flaprqst",0)
			end
		end
	},
	[8] = {["lefttext"] = "FLAPS -- UP NO LIGHTS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"UP NO LIGHTS")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "ALTIMETERS -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ALTIMETERS")
		end
	},
	[10] = {["lefttext"] = "ALTIMETERS -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "AFTER TAKEOFF CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AFTER TAKEOFF CHECKLIST COMPLETED")
		end
	},
	[12] = {["lefttext"] = "AFTER TAKEOFF CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "AFTER TAKEOFF CHECKLIST COMPLETED"
		end
	}
}

ZC_APPROACH_BRIEFING = {
	[0] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ARE YOU READY FOR THE APPROACH BRIEF?"
			ZC_BACKGROUND_PROCS["OPENAPPWINDOW"].status=1
		end
	},
	[1] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ARE YOU READY FOR THE APPROACH BRIEF ?")
		end
	},
	[2] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"YES")
		end
	},
	[3] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"ok, we will be arriving via "..APP_proctype_list[get_zc_brief_app("arrtype")].." "..convertNato(get_zc_brief_app("star")))
		end
	},
	[4] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"after the arrival we can expect an "..APP_apptype_list[get_zc_brief_app("apptype")].." approach into our destination")
		end
	},
	[5] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"Runway assigned is "..convertRwy(get_zc_brief_app("apprwy")).."    and the condition is "..APP_rwystate_list[get_zc_brief_app("rwycond")])
		end
	},	
	[6] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Anti Ice is "..APP_aice_list[get_zc_brief_app("appaice")])
		end
	},
	[7] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Landing flaps will be "..GENERAL_Acf:getAPP_Flaps()[get_zc_brief_app("ldgflaps")])
		end
	},
	[8] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"for auto brake we will use level "..GENERAL_Acf:getAutobrake()[get_zc_brief_app("autobrake")])
		end
	},
	[9] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Packs will be "..GENERAL_Acf:getBleeds()[get_zc_brief_app("apppacks")])
		end
	},
	[10] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Decision "..(get_zc_config("dhda")==true and "height" or "altitude").." will be "..(get_zc_config("dhda")==true and get_zc_brief_app("dh") or get_zc_brief_app("da")))
		end
	},
	[11] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Anti ice is "..GENERAL_Acf:getAIce()[get_zc_brief_app("appaice")])
		end
	},
	[12] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Approach speed "..get_zc_brief_app("vapp"))
		end
	},
	[13] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Reference speed "..get_zc_brief_app("vref"))
		end
	},
	[14] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Missed approach altitude "..get_zc_brief_app("gaalt"))
		end
	},
	[15] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Any questions or concerns?")
		end
	},
	[16] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"no")
		end
	},	
	[17] = {["lefttext"] = "APPROACH BRIEFING COMPLETED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"APPROACH BRIEFING COMPLETED")		
		end
	},
	[18] = {["lefttext"] = "APPROACH BRIEFING COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "APPROACH BRIEFING COMPLETED"	
		end
	}
}

-- DESCENT – APPROACH
-- ANTI–ICE					. . . . . .	AS REQUIRED
-- AIR COND & PRESS			. . . . . .	SET
-- PRESSURIZATION			. . . . . . LAND ALT ____
-- ALTIMETER & INSTRUMENTS	. . . . . .	SET & X–CHECKED
-- N1 & IAS BUGS			. . . . . .	CHECKED & SET
-- APPROACH BRIEFING		. . . . . . COMPLETED

ZC_DESCENT_CHECKLIST = {
	[0] = {["lefttext"] = "DESCENT APPROACH CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"DESCENT APPROACH CHECKLIST")
			setchecklist(7)
			ZC_BACKGROUND_PROCS["TRANSALT"].status = 0
			ZC_BACKGROUND_PROCS["TENTHOUSANDUP"].status = 0
			ZC_BACKGROUND_PROCS["TENTHOUSANDDN"].status = 1
			ZC_BACKGROUND_PROCS["TRANSLVL"].status = 1
		end
	},
	[1] = {["lefttext"] = "ANTI–ICE -- AS REQUIRED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ANTI ICE")
		end
	},
	[2] = {["lefttext"] = "ANTI–ICE -- AS REQUIRED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"AS REQUIRED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "AIR COND & PRESS -- SET", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"AIR CONDITIONING and PRESSURIZATION")
		end
	},
	[4] = {["lefttext"] = "AIR COND & PRESS -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "PRESSURIZATION -- LAND ALT___", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PRESSURIZATION")
		end
	},
	[6] = {["lefttext"] = "PRESSURIZATION -- LAND ALT___", ["timerincr"] = 999,
		["actions"] = function ()
			speakNoText(0,string.format("landing altitude %i",get("FJS/732/Pneumatic/LandingAltSelector1000")*1000 + get("FJS/732/Pneumatic/LandingAltSelector10")*10))
			gLeftText = string.format("Landing altitude %i",get("FJS/732/Pneumatic/LandingAltSelector1000")*1000 + get("FJS/732/Pneumatic/LandingAltSelector10")*10)
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "ALTIMETER & INSTRUMENTS -- SET & X–CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ALTIMETER AND INSTRUMENTS")
		end
	},
	[8] = {["lefttext"] = "ALTIMETER & INSTRUMENTS -- SET & X–CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"set and cross checked")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "N1 & IAS BUGS -- CHECKED & SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"N 1 and I A S BUGS")
		end
	},
	[10] = {["lefttext"] = "N1 & IAS BUGS -- CHECKED & SET", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"CHECKED and SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "APPROACH BRIEFING -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"APPROACH BRIEFING")
		end
	},
	[12] = {["lefttext"] = "APPROACH BRIEFING -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"COMPLETED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "DESCENT APPROACH CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "DESCENT APPROACH CHECKLIST COMPLETED"
			ZC_BACKGROUND_PROCS["TRANSALT"].status = 1
			ZC_BACKGROUND_PROCS["TENTHOUSANDDN"].status = 0
		end
	}
}

ZC_LANDING_PROC = {
	[0] = {["lefttext"] = "LANDING PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",0)
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/732/lights/RunwayTurnoffSwitch1",1)
				set("FJS/732/lights/RunwayTurnoffSwitch2",1)
			end
			set("FJS/732/lights/NoSmokingSwitch",1)
			set("FJS/732/lights/FastenBeltsSwitch",1)
			set("FJS/732/lights/InBoundLLightSwitch2",1)
			set("FJS/732/lights/InBoundLLightSwitch1",1)
			set("FJS/732/lights/OutBoundLLightSwitch2",2)
			set("FJS/732/lights/OutBoundLLightSwitch1",2)
		end
	},
	[1] = {["lefttext"] = "AT 210 KTS - FLAPS 1", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AT 210 KTS - FLAPS 1"
		end
	},
	[2] = {["lefttext"] = "AT 210 KTS - FLAPS 1", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 1")
		end
	},
	[3] = {["lefttext"] = "AT 210 KTS - FLAPS 1", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK FLAPS 1")
			set("sim/flightmodel/controls/flaprqst",0.125)
		end
	},
	[4] = {["lefttext"] = "AT 180 KTS - FLAPS 5", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AT 180 KTS - FLAPS 5"
		end
	},
	[5] = {["lefttext"] = "AT 180 KTS - FLAPS 5", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 5")
		end
	},
	[6] = {["lefttext"] = "AT 180 KTS - FLAPS 5", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK FLAPS 5")
			set("sim/flightmodel/controls/flaprqst",0.375)
		end
	},
	[7] = {["lefttext"] = "AT 160 KTS -- FLAPS 15 GEAR DOWN", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AT 160 KTS -- FLAPS 15 GEAR DOWN"
		end
	},
	[8] = {["lefttext"] = "AT 160 KTS -- FLAPS 15 GEAR DOWN", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 15  GEAR DOWN")
		end
	},
	[9] = {["lefttext"] = "AT 160 KTS -- FLAPS 15 GEAR DOWN", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 15")
			set("sim/flightmodel/controls/flaprqst",0.625)
			command_once("sim/flight_controls/landing_gear_down")
		end
	},
	[10] = {["lefttext"] = "SPEEDBRAKE -- ARMED", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ARM SPEEDBRAKE"
		end
	},
	[11] = {["lefttext"] = "SPEEDBRAKE -- ARMED", ["timerincr"] = 997,
		["actions"] = function ()
			-- set("laminar/B738/annunciator/speedbrake_armed",1)
		end
	},
	[12] = {["lefttext"] = "AT 155 KTS - FLAPS 30", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "FLAPS 30"
		end
	},
	[13] = {["lefttext"] = "AT 155 KTS - FLAPS 30", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 30")
		end
	},
	[14] = {["lefttext"] = "AT 155 KTS - FLAPS 30", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 30")
			set("sim/flightmodel/controls/flaprqst",0.875)
		end
	},
	[15] = {["lefttext"] = "SET MISSED APPROACH ALTITUDE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET MISSED APPROACH ALTITUDE"
		end
	},
	[16] = {["lefttext"] = "SET MISSED APPROACH ALTITUDE", ["timerincr"] = 997,
		["actions"] = function ()
			set("sim/cockpit/autopilot/heading_mag",get_zc_brief_app("gahdg"))
			set("sim/cockpit/autopilot/altitude",get_zc_brief_app("gaalt"))
			otto_throttle_on = 0
		end
	},
	[17] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "LANDING PROCEDURE FINISHED - HAPPY LANDING"
		end
	}, 	
	[18] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "LANDING PROCEDURE FINISHED - HAPPY LANDING"
		end
	}
}

-- LANDING
-- CABIN			. . . . .	SECURE
-- RECALL			. . . . .	CHECKED
-- SPEED BRAKE		. . . . .	ARMED, GREEN LIGHT
-- LANDING GEAR		. . . . .	DOWN, 3 GREEN
-- FLAPS			. . . . .	_____, GREEN LIGHT

ZC_LANDING_CHECKLIST = {
	[0] = {["lefttext"] = "LANDING CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"LANDING CHECKLIST")
			setchecklist(8)
		end
	},
	[1] = {["lefttext"] = "CABIN -- SECURE", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CABIN")
		end
	},
	[2] = {["lefttext"] = "CABIN -- SECURE", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SECURE")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"RECALL")
		end
	},
	[4] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "SPEED BRAKE -- ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SPEED BRAKE")
		end
	},
	[6] = {["lefttext"] = "SPEED BRAKE -- ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ARMED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "LANDING GEAR -- DOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"LANDING GEAR")
			command_once("sim/flight_controls/landing_gear_down")
		end
	},
	[8] = {["lefttext"] = "LANDING GEAR -- DOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"DOWN")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "FLAPS -- FLAPS 15/30/40 GREEN LIGHT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
		end
	},
	[10] = {["lefttext"] = "FLAPS -- FLAPS 15/30/40 GREEN LIGHT", ["timerincr"] = 3,
		["actions"] = function ()
			local flaps = MD88:getAPP_Flaps()[math.floor(get("sim/flightmodel/controls/flaprqst")/0.125)+1]
--			speakNoText(0,string.format("FLAPS %i GREEN LIGHT",flaps))
--			gLeftText = string.format("FLAPS %i GREEN LIGHT",flaps)
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "LANDING CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"LANDING CHECKLIST COMPLETED")		
		end
	},
	[12] = {["lefttext"] = "LANDING CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "LANDING CHECKLIST COMPLETED"
		end
	}
}

ZC_AFTER_LANDING_PROC = {
	[0] = {["lefttext"] = "CLEANUP", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"it is OK TO CLEAN UP")
		end
	},
	[1] = {["lefttext"] = "CAPT: SPEED BRAKES -- UP", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/SpeedBreakHandleMo",0)
		end
	},
	[2] = {["lefttext"] = "CAPT: CHRONO -- STOP", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("sim/instruments/timer_start_stop")
		end
	},
	[3] = {["lefttext"] = "CAPT: WX RADAR -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/wx/WXSysKnob",0)
		end
	},
	[4] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 6,
		["actions"] = function ()
			set("FJS/732/Elec/APUStartSwitch",2)
		end
	}, 
	[5] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Elec/APUStartSwitch",1)
			ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
			ZC_BACKGROUND_PROCS["APUGEN0"].status = 1
		end
	},
	[6] = {["lefttext"] = "FO: FLAPS -- UP", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/flightmodel/controls/flaprqst",0)
		end
	},
	[7] = {["lefttext"] = "FO: PROBE HEAT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/PitotStaticSwitchA",0)
			set("FJS/732/AntiIce/PitotStaticSwitchB",0)
		end
	},
	[8] = {["lefttext"] = "FO: STROBES -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/StrobeLightSwitch",0)
		end
	},
	[9] = {["lefttext"] = "FO: LANDING LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/InBoundLLightSwitch2",0)
			set("FJS/732/lights/InBoundLLightSwitch1",0)
			set("FJS/732/lights/OutBoundLLightSwitch2",0)
			set("FJS/732/lights/OutBoundLLightSwitch1",0)
		end
	},
	[10] = {["lefttext"] = "FO: TAXI LIGHTS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",1)
		end
	},
	[11] = {["lefttext"] = "FO: RWY TURNOFF LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/RunwayTurnoffSwitch1",0)
			set("FJS/732/lights/RunwayTurnoffSwitch2",0)
		end
	},
	[12] = {["lefttext"] = "FO: AUTOBRAKE -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/AutoBrakeKnob",0)
		end
	},
	[13] = {["lefttext"] = "FO: TRANSPONDER -- STBY", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"transponder off")
			set("FJS/732/Radios/TransponderModeKnob",1)
		end
	},
	[14] = {["lefttext"] = "CLEANUP FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "CLEANUP FINISHED"
		end
	}
}

ZC_SHUTDOWN_PROC = {
	[0] = {["lefttext"] = "SHUTDOWN PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"CABIN CREW DISARM SLIDES")
		end
	},
	[1] = {["lefttext"] = "CAPT: TAXI LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/TaxiLightSwitch",1)
		end
	},
	[2] = {["lefttext"] = "FO: READY FOR SHUTDOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"READY FOR SHUTDOWN")
		end
	},
	[3] = {["lefttext"] = "CAPT: SHUTDOWN ENGINES!", ["timerincr"] = 997,
		["actions"] = function ()
			set("FJS/732/fuel/FuelMixtureLever1",1)
			set("FJS/732/fuel/FuelMixtureLever2",1)
		end
	},
	[4] = {["lefttext"] = "FO: SEATBELT SIGNS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/FastenBeltsSwitch",0)
		end
	},
	[5] = {["lefttext"] = "FO: BEACON -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/lights/AntiColLightSwitch",0)
		end
	},
	[6] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Fuel/FuelPumpC1Switch",0)
			set("FJS/732/Fuel/FuelPumpC2Switch",0)
			set("FJS/732/Fuel/FuelPumpL1Switch",1)
			set("FJS/732/Fuel/FuelPumpL2Switch",0)
			set("laminar/B738/fuel/fuel_tank_pos_ctr2",0)
			set("laminar/B738/fuel/fuel_tank_pos_lft1",1)
		end
	}, 
	[7] = {["lefttext"] = "FO: WING & ENGINE ANTIICE -- OFF", ["timerincr"] = 2,
		["actions"] = function ()
			set("FJS/732/AntiIce/WingAntiIceSwitch",0)
			set("FJS/732/AntiIce/EngAntiIce1Switch",0)
			set("FJS/732/AntiIce/EngAntiIce2Switch",0)
		end
	}, 
	[8] = {["lefttext"] = "WINDOW HEAT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/AntiIce/WindowHeatL1Switch",0)
			set("FJS/732/AntiIce/WindowHeatL2Switch",0)
			set("FJS/732/AntiIce/WindowHeatR1Switch",0)
			set("FJS/732/AntiIce/WindowHeatR2Switch",0)
		end
	},                                                  
	[9] = {["lefttext"] = "FO: ELECTRICAL HYDRAULIC PUMPS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/FltControls/Eng1HydPumpSwitch",1)
			set("FJS/732/FltControls/Eng2HydPumpSwitch",1)
			set("FJS/732/FltControls/Elec1HydPumpSwitch",0)
			set("FJS/732/FltControls/Elec2HydPumpSwitch",0)
		end
	}, 
	[10] = {["lefttext"] = "FO: ISOLATION VALVE -- OPEN", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/IsoValveSwitch",1)
		end
	},
	[11] = {["lefttext"] = "FO: APU BLEED -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/732/Pneumatic/APUBleedSwitch",0)
		end
	},
	[12] = {["lefttext"] = "FO: RESET MCP", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/autopilot/airspeed",get_zc_config("apspd"))
			set("sim/cockpit/autopilot/heading_mag",get_zc_config("aphdg"))
			set("sim/cockpit/autopilot/altitude",get_zc_config("apalt"))
		end
	},
	[13] = {["lefttext"] = "FO: RESET TRANSPONDER", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/radios/transponder_code", 2000)
		end
	},
	[14] = {["lefttext"] = "FO: RESET ELAPSED TIME", ["timerincr"] = 4,
		["actions"] = function ()
			if get("sim/cockpit2/clock_timer/timer_running") == 1 then
				command_once("sim/instruments/timer_start_stop")
			end
			speakNoText(0,"Flight time %i hours  %i minutes",get("sim/cockpit2/clock_timer/elapsed_time_hours"),get("sim/cockpit2/clock_timer/elapsed_time_minutes"))

		end
	},
	[15] = {["lefttext"] = "SHUTDOWN FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SHUTDOWN FINISHED"
			speakNoText(0,"SHUTDOWN CHECKLIST")
		end
	}
}

-- SHUTDOWN
-- FUEL PUMPS					. . . . .	OFF
-- GALLEY POWER					. . . . .	AS REQUIRED
-- ELECTRICAL					. . . . .	ON_____
-- FASTEN BELTS					. . . . .	OFF
-- WINDOW HEAT					. . . . .	OFF
-- PROBE HEAT					. . . . .	OFF
-- ANTI–ICE						. . . . .	OFF
-- ELECTRIC HYDRAULIC PUMPS		. . . . .	OFF
-- AIR COND						. . . . .	___ PACK(S), BLEEDS ON
-- EXTERIOR LIGHTS				. . . . .	AS REQUIRED
-- ANTICOLLISION LIGHT			. . . . .	OFF
-- ENGINE START SWITCHES		. . . . .	OFF
-- AUTOBRAKE					. . . . .	OFF
-- SPEED BRAKE					. . . . .	DOWN DETENT
-- FLAPS						. . . . .	UP, NO LIGHTS
-- PARKING BRAKE				. . . . .	AS REQUIRED
-- START LEVERS					. . . . .	CUTOFF
-- WEATHER RADAR				. . . . .	OFF
-- TRANSPONDER					. . . . .	STANDBY

ZC_SHUTDOWN_CHECKLIST = {
	[0] = {["lefttext"] = "SHUTDOWN CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"SHUTDOWN CHECKLIST")
			setchecklist(10)
		end
	},
	[1] = {["lefttext"] = "FUEL PUMPS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FUEL PUMPS")
		end
	},
	[2] = {["lefttext"] = "FUEL PUMPS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "GALLEY POWER -- AS REQUIRED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"GALLEY POWER")
		end
	},
	[4] = {["lefttext"] = "GALLEY POWER -- AS REQUIRED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"GALLEY POWER")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "ELECTRICAL -- ON GPU/APU", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ELECTRICAL")
		end
	},
	[6] = {["lefttext"] = "ELECTRICAL -- ON GPU/APU", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "FASTEN BELTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FASTEN BELTS")
		end
	},
	[8] = {["lefttext"] = "FASTEN BELTS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "WINDOW HEAT	-- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"WINDOW HEAT")
		end
	},
	[10] = {["lefttext"] = "WINDOW HEAT	-- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "PROBE HEAT -- OFF/AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PROBE HEAT")
		end
	},
	[12] = {["lefttext"] = "PROBE HEAT -- OFF/AUTO", ["timerincr"] = 999,
		["actions"] = function ()
			speakNoText(0,"OFF OR AUTOMATIC")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "ANTI–ICE -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ANTI ICE")
		end
	},
	[12] = {["lefttext"] = "ANTI–ICE -- OFF", ["timerincr"] = 999,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "ELECTRIC HYDRAULIC PUMPS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ELECTRIC HYDRAULIC PUMPS")
		end
	},
	[14] = {["lefttext"] = "ELECTRIC HYDRAULIC PUMPS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[15] = {["lefttext"] = "AIR COND -- ___ PACK(S), BLEEDS ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AIR CONDITIONING")
		end
	},
	[16] = {["lefttext"] = "AIR COND -- ___ PACK(S), BLEEDS ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[17] = {["lefttext"] = "EXTERIOR LIGHTS -- AS REQUIRED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"EXTERIOR LIGHTS")
		end
	},
	[18] = {["lefttext"] = "EXTERIOR LIGHTS -- AS REQUIRED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"AS REQUIRED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[19] = {["lefttext"] = "ANTICOLLISION LIGHT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ANTICOLLISION LIGHT")
		end
	},
	[20] = {["lefttext"] = "ANTICOLLISION LIGHT -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[21] = {["lefttext"] = "ENGINE START SWITCHES -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ENGINE START SWITCHES")
		end
	},
	[22] = {["lefttext"] = "ENGINE START SWITCHES -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[23] = {["lefttext"] = "AUTOBRAKE -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AUTO BRAKE")
		end
	},
	[24] = {["lefttext"] = "AUTOBRAKE -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[25] = {["lefttext"] = "SPEED BRAKE -- DOWN DETENT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"SPEED BRAKE")
		end
	},
	[26] = {["lefttext"] = "SPEED BRAKE -- DOWN DETENT", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"DOWN DETENT")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[27] = {["lefttext"] = "FLAPS -- UP, NO LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
		end
	},
	[28] = {["lefttext"] = "FLAPS -- UP, NO LIGHTS", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"UP, NO LIGHTS")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[29] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PARKING BRAKE")
		end
	},
	[30] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[31] = {["lefttext"] = "START LEVERS -- CUTOFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"START LEVERS")
		end
	},
	[32] = {["lefttext"] = "START LEVERS -- CUTOFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CUTOFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[33] = {["lefttext"] = "WEATHER RADAR -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"WEATHER RADAR")
		end
	},
	[34] = {["lefttext"] = "WEATHER RADAR -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[33] = {["lefttext"] = "TRANSPONDER -- STANDBY", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"TRANSPONDER")
		end
	},
	[34] = {["lefttext"] = "TRANSPONDER -- STANDBY", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"STANDBY")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[35] = {["lefttext"] = "SHUTDOWN CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SHUTDOWN CHECKLIST COMPLETED")	
		end
	},
	[36] = {["lefttext"] = "SHUTDOWN CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SHUTDOWN CHECKLIST COMPLETED"
		end
	}
}

ZC_SECURING_AIRCRAFT_PROC = {
	[0] = {["lefttext"] = "SECURING AIRCRAFT PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"SECURE THE AIRCRAFT PLEASE")
		end
	},
	[1] = {["lefttext"] = "CAPT: CAB/UTIL & IFE GALLEY POWER -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/ife_pass_seat_pos",0)
			set("laminar/B738/toggle_switch/cab_util_pos",0)
		end
	},
	[2] = {["lefttext"] = "CAPT: TRIM AIR SWITCH -- OFF", ["timerincr"] = 2,
		["actions"] = function ()
			set("laminar/B738/air/trim_air_pos",0)
		end
	},
	[3] = {["lefttext"] = "FO: IRS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/irs_left",0)
			set("laminar/B738/toggle_switch/irs_right",0)
		end
	},
	[4] = {["lefttext"] = "FO: EMERGENCY EXIT LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/push_button/emer_exit_full_off")
			command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
			command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		end
	},
	[5] = {["lefttext"] = "FO: WINDOW HEAT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/ice/window_heat_l_side_pos",0)
			set("laminar/B738/ice/window_heat_l_fwd_pos",0)
			set("laminar/B738/ice/window_heat_r_fwd_pos",0)
			set("laminar/B738/ice/window_heat_r_side_pos",0)
		end
	},
	[6] = {["lefttext"] = "FO: PACKS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/air/l_pack_pos",0)
			set("laminar/B738/air/r_pack_pos",0)
		end
	}, 
	[7] = {["lefttext"] = "CAPT: APU -- OFF", ["timerincr"] = 15,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/bleed_air_apu_pos",0)
			command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
		end
	}, 
	[8] = {["lefttext"] = "CAPT: BATTERY -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("sim/electrical/APU_off")
			command_once("sim/electrical/GPU_off")
			command_once("sim/electrical/battery_1_off")
			command_once("laminar/B738/push_button/batt_full_off")
		end
	}, 
	[9] = {["lefttext"] = "CAPT: POSITION LIGHT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/position_light_pos") == 1 then
				command_once("laminar/B738/toggle_switch/position_light_down")
			end
			if get("laminar/B738/toggle_switch/position_light_pos") == 0 then
				command_once("laminar/B738/toggle_switch/position_light_down")
			end
		end
	}, 
	[10] = {["lefttext"] = "SECURING FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SECURING FINISHED"
			speakNoText(0,"SECURE THE AIRCRAFT CHECKLIST")
		end
	}
}

-- SECURE
-- IRS MODE SELECTORS		. . . . .	OFF
-- EMERGENCY EXIT LIGHTS	. . . . .	OFF
-- AIR CONDITIONING PACKS	. . . . .	OFF
-- APU/GROUND POWER			. . . . .	OFF
-- BATTERY					. . . . .	OFF

ZC_SECURE_CHECKLIST = {
	[0] = {["lefttext"] = "SECURE CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"SECURE CHECKLIST")
			setchecklist(11)
		end
	},
	[1] = {["lefttext"] = "IRS MODE SELECTORS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"I R S Mode Selectors")
		end
	},
	[2] = {["lefttext"] = "IRS MODE SELECTORS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"EMERGENCY EXIT LIGHTS")
		end
	},
	[4] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "AIR CONDITIONING PACKS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AIR CONDITIONING PACKS")
		end
	},
	[6] = {["lefttext"] = "AIR CONDITIONING PACKS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},	
	[7] = {["lefttext"] = "APU/GROUND POWER -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"A P U or GROUND POWER")
		end
	},
	[8] = {["lefttext"] = "APU/GROUND POWER -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "BATTERIES -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"BATTERIES")
		end
	},
	[10] = {["lefttext"] = "BATTERIES -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "SECURE CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SECURE CHECKLIST COMPLETED")	
		end
	},
	[12] = {["lefttext"] = "SECURE CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SECURE CHECKLIST COMPLETED"
		end
	}
}

-- Background procedures
ZC_BACKGROUND_PROCS = {
	-- Switches generators to APU when the blue APU light comes on
	["APUBUSON"] = {["status"] = 0,
		["actions"] = function ()
			if get("FJS/732/Annun/SysAnnunLIT_13") > 0.9 then
				set("FJS/732/Elec/APUgen1Switch",1)
				set("FJS/732/Elec/APUgen2Switch",1)
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 0
				ZC_BACKGROUND_PROCS["APUGEN0"].status = 1 -- generator switches up
			end
		end
	},
	-- The FJS B732 needs to get the Generator switches brought back up
	["APUGEN0"] = {["status"] = 0,
		["actions"] = function ()
			if get("FJS/732/Elec/APUgen1Switch") == 1 then
				set("FJS/732/Elec/APUgen1Switch",0)
			end
			if get("FJS/732/Elec/APUgen2Switch") == 1 then
				set("FJS/732/Elec/APUgen2Switch",0)
				set("FJS/732/Pneumatic/APUBleedSwitch",1)
				ZC_BACKGROUND_PROCS["APUGEN0"].status = 0
			end
		end
	},
	-- During startup wait for N2 to reach 25 and turn on fuel
	["FUEL1IDLE"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/engine/ENGN_N2_",0) > 22.0 then
				set("FJS/732/fuel/FuelMixtureLever1",1)
				ZC_BACKGROUND_PROCS["FUEL1IDLE"].status = 0
			end
		end
	},
	["STARTERCUT1"] = {["status"] = 0,
		["actions"] = function ()
			if get("FJS/732/Eng/Engine1StartKnob",0) == 0 then
				speakNoText(0,"Starter cutout")
				ZC_BACKGROUND_PROCS["STARTERCUT1"].status = 0
			end
		end
	},
	["FUEL2IDLE"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/engine/ENGN_N2_",1) > 22.0 then
				set("FJS/732/fuel/FuelMixtureLever2",1)
				ZC_BACKGROUND_PROCS["FUEL2IDLE"].status = 0
			end
		end
	},
	["STARTERCUT2"] = {["status"] = 0,
		["actions"] = function ()
			if get("FJS/732/Eng/Engine2StartKnob",0) == 0 then
				speakNoText(0,"Starter cutout")
				ZC_BACKGROUND_PROCS["STARTERCUT2"].status = 0
			end
		end
	},
	-- during takeoff run call out 80 kts
	["80KTS"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/indicated_airspeed") > 80.0 then
				speakNoText(0,"80 knots")
				ZC_BACKGROUND_PROCS["80KTS"].status = 0
			end
		end
	},
	-- during takeoff run call V speeds
	["V1"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/indicated_airspeed") > zc_acf_getV1() then
				speakNoText(0,"V one")
				ZC_BACKGROUND_PROCS["V1"].status = 0
			end
		end
	},
	["ROTATE"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/indicated_airspeed") > zc_acf_getVr() then
				speakNoText(0,"rotate")
				ZC_BACKGROUND_PROCS["ROTATE"].status = 0
			end
		end
	},
	-- On reaching Transition altitude switch to STD
	["TRANSALT"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > get_zc_brief_dep("transalt") then
				speakNoText(0,"Transition altitude")
				all_baro_std()
				ZC_BACKGROUND_PROCS["TRANSALT"].status = 0
			end
		end
	},
	-- On reaching transition level during descend switch away from STD
	["TRANSLVL"] = {["status"] = 0,
		["actions"] = function ()
			speakNoText(0,"Transition level")
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < get_zc_brief_app("translvl") then
				ZC_BACKGROUND_PROCS["TRANSLVL"].status = 0
			end
		end
	},
	-- during climb reach 10.000 ft
	["TENTHOUSANDUP"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000.0 then
				speakNoText(0,"ten thousand")
				set("FJS/732/lights/InBoundLLightSwitch2",0)
				set("FJS/732/lights/InBoundLLightSwitch1",0)
				set("FJS/732/lights/OutBoundLLightSwitch2",0)
				set("FJS/732/lights/OutBoundLLightSwitch1",0)
				ZC_BACKGROUND_PROCS["TENTHOUSANDUP"].status = 0
			end
		end
	},
	-- during descent reach 10.000 ft
	["TENTHOUSANDDN"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") <= 10000.0 then
				speakNoText(0,"ten thousand")
				set("FJS/732/lights/InBoundLLightSwitch2",1)
				set("FJS/732/lights/InBoundLLightSwitch1",1)
				ZC_BACKGROUND_PROCS["TENTHOUSANDDN"].status = 0
			end
		end
	},
	-- easy mode call for gear up at 200ft AGL
	["GEARUP"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/y_agl") > 50 then
				speakNoText(0,"POSITIV RATE    GEAR UP")
				command_once("sim/flight_controls/landing_gear_up")
				ZC_BACKGROUND_PROCS["GEARUP"].status = 0
			end
		end
	},
	-- Flapsup schedule
	["FLAPSUPSCHED"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/y_agl") > 50 then
				if get("sim/flightmodel/position/indicated_airspeed") > 160.0 and get("sim/flightmodel/controls/flaprqst")/0.125 == 5 then
					speakNoText(0,"SPEED CHECK   FLAPS 10")
					set("sim/flightmodel/controls/flaprqst",0.5)
				end
				if get("sim/flightmodel/position/indicated_airspeed") > 180.0 and get("sim/flightmodel/controls/flaprqst")/0.125 > 3 then
					speakNoText(0,"SPEED CHECK   FLAPS 5")
					set("sim/flightmodel/controls/flaprqst",0.375)
				end
				if get("sim/flightmodel/position/indicated_airspeed") > 200.0 and get("sim/flightmodel/controls/flaprqst")/0.125 >= 2 then
					speakNoText(0,"SPEED CHECK   FLAPS 1")
					set("sim/flightmodel/controls/flaprqst",0.125)
				end
				if get("sim/flightmodel/position/indicated_airspeed") > 210.0 and get("sim/flightmodel/controls/flaprqst")/0.125 >= 1 then
					speakNoText(0,"SPEED CHECK   FLAPS UP")
					set("sim/flightmodel/controls/flaprqst",0)
					ZC_BACKGROUND_PROCS["FLAPSUPSCHED"].status = 0
				end
			end
		end
	},
	
	-- Open Briefing Windows & not aircraft specific functions
	["OPENINFOWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			zc_init_flightinfo_window()
			ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status = 0
		end
	},
	["OPENDEPWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			zc_init_depbrf_window()
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status = 0
		end
	},
	["OPENAPPWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			zc_init_appbrf_window()
			ZC_BACKGROUND_PROCS["OPENAPPWINDOW"].status = 0
		end
	}
}

-- defines the available procedures/checklists and in which sequence they appear in the menu
lNoProcs = 26
function zc_get_procedure()

	curralt_1000 = math.floor(get("sim/cockpit/autopilot/current_altitude")/1000)
	curralt_10 = (get("sim/cockpit/autopilot/current_altitude")-(curralt_1000*1000))/10

	lChecklistMode = 1
	incnt=1
	if lProcIndex == incnt then
		lActiveProc = ZC_COLD_AND_DARK
		lNameActiveProc = incnt.." COLD & DARK - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_TURN_AROUND_STATE
		lNameActiveProc = incnt.." TURN AROUND STATE - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_POWER_UP_PROC
		lNameActiveProc = incnt.." POWER UP PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_PRE_FLIGHT_PROC
		lNameActiveProc = incnt.." PREFLIGHT PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_START_CHECKLIST
		lNameActiveProc = incnt.." BEFORE START CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_DEPARTURE_BRIEFING
		lNameActiveProc = incnt.." DEPARTURE BRIEFING - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_START_PROC
		lNameActiveProc = incnt.." CLEARED FOR START PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_CLEARED_FOR_START_CHECKLIST
		lNameActiveProc = incnt.." CLEARED FOR START CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_PREPARE_PUSH
		lNameActiveProc = incnt.." PUSHBACK - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_STARTENGINE_PROC
		lNameActiveProc = incnt.." START ENGINES"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_FLIGHT_CONTROLS_CHECK
		lNameActiveProc = incnt.." FLIGHT CONTROLS CHECK"
	end	
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAXI_PROC
		lNameActiveProc = incnt.." AFTER START PROCEDURE"
	end	
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAXI_CHECKLIST
		lNameActiveProc = incnt.." AFTER START CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAKEOFF_CHECKLIST
		lNameActiveProc = incnt.." BEFORE TAKEOFF CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAKEOFF_PROC
		lNameActiveProc = incnt.." BEFORE TAKEOFF PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_CLIMB_PROC
		lNameActiveProc = incnt.." TAKEOFF AND CLIMB PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_AFTER_TAKEOFF_CHECKLIST
		lNameActiveProc = incnt.." AFTER TAKEOFF CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_APPROACH_BRIEFING
		lNameActiveProc = incnt.." APPROACH BRIEFING - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_DESCENT_CHECKLIST
		lNameActiveProc = incnt.." DESCENT APPROACH CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_LANDING_PROC
		lNameActiveProc = incnt.." LANDING PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_LANDING_CHECKLIST
		lNameActiveProc = incnt.." LANDING CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_AFTER_LANDING_PROC
		lNameActiveProc = incnt.." AFTER LANDING - CLEANUP"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SHUTDOWN_PROC
		lNameActiveProc = incnt.." SHUTDOWN PROCEDURE"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SHUTDOWN_CHECKLIST
		lNameActiveProc = incnt.." SHUTDOWN CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SECURING_AIRCRAFT_PROC
		lNameActiveProc = incnt.." SECURING AIRCRAFT PROCEDURE - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SECURE_CHECKLIST
		lNameActiveProc = incnt.." SECURING AIRCRAFT - OPTIONAL"
	end
	lNoProcs=incnt
end

-- aircraft specific functions

-- Determines V1 for this aircraft (this one reads the speed bug after you set it)
function zc_acf_getV1()
	return (get("FJS/732/Vcard/SpeedBug2Drag")-60)/30*20+100
end

-- Determine Vr (V1 + 1 in 732s speed card)
function zc_acf_getVr()
	return zc_acf_getV1()+1
end

-- Determine V2 (in 732 always around V1+7)
function zc_acf_getV2()
	return zc_acf_getVr()+7
end

-- Get T/O trim (732: click on the trim scale green and that is taken)
function zc_acf_getTrim()
	local trimwheel = get("sim/aircraft/controls/acf_takeoff_trim") + 1.0
	return trimwheel / 0.11770212
end

-- Set T/O trim on trim wheel
function zc_acf_setTOTrim()
	set("sim/cockpit2/controls/elevator_trim",get("sim/aircraft/controls/acf_takeoff_trim"))
end

-- Return T/O Flap (732: no value to read, usually 2)
function zc_acf_getToFlap()
	return get_zc_brief_dep("toflaps")
end

-- Return Landing Flap (732: usually 30, no value to read from)
function zc_acf_getLdgFlap()
	return get_zc_brief_app("ldgflaps")
end

-- Return parking stand (732: no value to read)
function zc_get_parking_stand()
	return "-----"
end

-- Determine Vref (732: from Speedbug after speed card set bugs)
function zc_acf_getVref()
	return (get("FJS/732/Vcard/SpeedBug2Drag")-60)/30*20+100
end

-- Determine Vapp (732: Vref + 10), no value to read)
function zc_acf_getVapp()
	return zc_acf_getVref() + 10
end

-- Get total fuel in tanks
function zc_get_total_fuel()
	if get_zc_config("kglbs") then
		return get("sim/flightmodel/weight/m_fuel_total")
	else
		return get("sim/flightmodel/weight/m_fuel_total")*2.2045
	end
end

-- Get gross weight
function zc_get_gross_weight()
	if get_zc_config("kglbs") then
		return get("sim/flightmodel/weight/m_total")
	else
		return get("sim/flightmodel/weight/m_total")*2.2045
	end	
end

-- Get zero fuel weight
function zc_get_zfw()
	return zc_get_gross_weight()-zc_get_total_fuel()
end

-- Return T/O rwy crs (732: n.a.)
function zc_acf_getrwycrs()
	return get_zc_config("aphdg")
end

-- Return selected runway from FMC (732: n.a.)
function zc_acf_getilsrwy()
	return "---" 
end

-- Get destination ICAO code (732: need to run this twice as it is only available 2nd time)
function zc_get_dest_icao()
	command_once("sim/FMS/fpln")
	local dest = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2")
	return string.sub(dest,21,24)
end

-- Return destination rwy altitude (732: n.a.)
function zc_get_dest_runway_alt()
	return get("sim/cockpit2/autopilot/altitude_readout_preselector")
end

-- Return destination rwy course (732: n.a.)
function zc_get_dest_runway_crs()
	return get_zc_config("aphdg")
end

-- Return destination rwy length (732: n.a.)
function zc_get_dest_runway_len()
	return 0
end

-- Return FMS route (732: n.a.)
function zc_get_route()
	return "" 
end

-- Checklist functions
function setchecklist(number)
		set("sim/operation/failures/rel_fadec_7",number)
		command_once("bgood/xchecklist/toggle_checklist")
end

function clearchecklist()
	varlandalt = get("sim/operation/failures/rel_fadec_7")
	if (varlandalt > 1) then
	   set("sim/operation/failures/rel_fadec_7",0)
	end
end

-- hardware functions and command definitions

function all_baro_up()
	set("FJS/732/Inst/StbyBaroKnob",get("FJS/732/Inst/StbyBaroKnob") + 1)
	set("sim/cockpit/misc/barometer_setting",get("sim/cockpit/misc/barometer_setting") + 0.01)
	set("sim/cockpit/misc/barometer_setting2",get("sim/cockpit/misc/barometer_setting2") + 0.01)
end

function all_baro_dn()
	set("FJS/732/Inst/StbyBaroKnob",get("FJS/732/Inst/StbyBaroKnob") - 1)
	set("sim/cockpit/misc/barometer_setting",get("sim/cockpit/misc/barometer_setting") - 0.01)
	set("sim/cockpit/misc/barometer_setting2",get("sim/cockpit/misc/barometer_setting2") - 0.01)
end

function all_baro_std()
	set("FJS/732/Inst/StbyBaroKnob",2992)
	set("sim/cockpit/misc/barometer_setting",29.92)
	set("sim/cockpit/misc/barometer_setting2",29.92)
end

-- Aircraft specific Joystick functions
function xsp_beaconlights_off()
	set("FJS/732/lights/AntiColLightSwitch",0)
end
function xsp_beaconlights_on()
	set("FJS/732/lights/AntiColLightSwitch",1)
end
function xsp_domelight_on()
	set("FJS/732/lights/DomeWhiteSwitch",1)
end
function xsp_domelight_off()
	set("FJS/732/lights/DomeWhiteSwitch",0)
end
function xsp_navlight_on()
	set("FJS/732/lights/PositionLightSwitch",1)
end
function xsp_navlight_off()
	set("FJS/732/lights/PositionLightSwitch",0)
end
function xsp_strobelight_on()
	set("FJS/732/lights/StrobeLightSwitch",1)
end
function xsp_strobelight_off()
	set("FJS/732/lights/StrobeLightSwitch",0)
end
function xsp_taxilights_off()
	set("FJS/732/lights/TaxiLightSwitch",0)
end
function xsp_taxilights_on()
	set("FJS/732/lights/TaxiLightSwitch",1)
end
function xsp_landinglights_off()
	set("FJS/732/lights/InBoundLLightSwitch2",0)
	set("FJS/732/lights/InBoundLLightSwitch1",0)
	set("FJS/732/lights/OutBoundLLightSwitch2",0)
	set("FJS/732/lights/OutBoundLLightSwitch1",0)
end
function xsp_landinglights_on()
	set("FJS/732/lights/InBoundLLightSwitch2",1)
	set("FJS/732/lights/InBoundLLightSwitch1",1)
	set("FJS/732/lights/OutBoundLLightSwitch2",2)
	set("FJS/732/lights/OutBoundLLightSwitch1",2)
end
function xsp_winglights_off()
	set("FJS/732/lights/WingLightSwitch",0)
end
function xsp_winglights_on()
	set("FJS/732/lights/WingLightSwitch",1)
end
function xsp_logolights_off()
	set("FJS/732/lights/LogoLightSwitch",0)
end
function xsp_logolights_on()
	set("FJS/732/lights/LogoLightSwitch",1)
end
function xsp_toggle_fd_both()
end
function xsp_toggle_std_both()
end

-- Elapsed timer display
function draw_elapsed_timer()
    if get("sim/graphics/view/view_is_external") == 1 then
        return
    end
    if elapsed_time_visible == 0 then
        return
    end
    infostring = string.format("ET: %02i:%02i:%02i",
                                         get("sim/cockpit2/clock_timer/elapsed_time_hours"),
                                         get("sim/cockpit2/clock_timer/elapsed_time_minutes"),
                                         get("sim/cockpit2/clock_timer/elapsed_time_seconds"))
    draw_string(get("sim/graphics/view/window_width")-90, 20, infostring, "white")
end

-- aircraft specific joystick/key commands
create_command("kp/xsp/beacon_lights_switch_on",	"MD88 Beacon Lights On",	"xsp_beaconlights_on()", "", "")
create_command("kp/xsp/beacon_lights_switch_off",	"MD88 Beacon Lights Off",	"xsp_beaconlights_off()", "", "")
create_command("kp/xsp/dome_lights_switch_on",		"MD88 Dome Lights On",		"xsp_domelight_on()", "", "")
create_command("kp/xsp/dome_lights_switch_off",		"MD88 Dome Lights Off",		"xsp_domelight_off()", "", "")
create_command("kp/xsp/nav_lights_switch_on",		"MD88 Position Lights On",	"xsp_navlight_on()", "", "")
create_command("kp/xsp/nav_lights_switch_off",		"MD88 Position Lights Off",	"xsp_navlight_off()", "", "")
create_command("kp/xsp/strobe_lights_switch_on",	"MD88 Strobe Lights On",	"xsp_strobelight_on()", "", "")
create_command("kp/xsp/strobe_lights_switch_off",	"MD88 Strobe Lights Off",	"xsp_strobelight_off()", "", "")
create_command("kp/xsp/taxi_lights_switch_on",		"MD88 Taxi Lights On",		"xsp_taxilights_on()", "", "")
create_command("kp/xsp/taxi_lights_switch_off",		"MD88 Taxi Lights Off",		"xsp_taxilights_off()", "", "")
create_command("kp/xsp/landing_lights_switch_on",	"MD88 Landing Lights On",	"xsp_landinglights_on()", "", "")
create_command("kp/xsp/landing_lights_switch_off",	"MD88 Landing Lights Off",	"xsp_landinglights_off()", "", "")
create_command("kp/xsp/wing_lights_switch_on",		"MD88 Wing Lights On",		"xsp_winglights_on()", "", "")
create_command("kp/xsp/wing_lights_switch_off",		"MD88 Wing Lights Off",		"xsp_winglights_off()", "", "")
create_command("kp/xsp/logo_lights_switch_on",		"MD88 Logo Lights On",		"xsp_logolights_on()", "", "")
create_command("kp/xsp/logo_lights_switch_off",		"MD88 Logo Lights Off",		"xsp_logolights_off()", "", "")
create_command("kp/xsp/toggle_both_fd",				"MD88 Toggle Both FD",		"xsp_toggle_fd_both()", "", "")
create_command("kp/xsp/toggle_both_std",			"MD88 Toggle Both STD",		"xsp_toggle_std_both()", "", "")

create_command("kp/rotmd88/all_baro_up", 			"MD88 all baro up", 		"all_baro_up()", "", "")
create_command("kp/rotmd88/all_baro_dn", 			"MD88 all baro down", 		"all_baro_dn()", "", "")
create_command("kp/rotmd88/all_baro_std", 			"MD88 all baro STD", 		"all_baro_std()", "", "")

do_every_draw("draw_elapsed_timer()")
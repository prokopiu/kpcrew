--[[
	*** KPCREW for FlyJsim Boeing 727-200
	Kosta Prokopiu, 2021
	Changelog:
		* v0.1 - Initial version only control 
		* v2.0 - new concept
		* V2.1 - B722 initial setup
--]]

-- Briefing / Aircraft specific details
B722 = Class_ACF:Create()
B722:setDEP_Flaps({"0","2","5","15","20"})
B722:setDEP_Flaps_val({0,0.142857,0.285714,0.428571,0.571429,0.714286,0.857143,1})
B722:setAPP_Flaps({"5","15","30","40"})
B722:setAPP_Flaps_val({0.285714,0.428571,0.857143,1})
B722:setAutoBrake({"OFF","MN","MED","MAX"})
B722:setAutoBrake_val({0,1,2,3})
B722:setTakeoffThrust({"Normal","Reduced","",""})
B722:setTakeoffThrust_Val({0,1,2,3})
B722:setBleeds({"OFF","ON","UNDER PRESSURIZED"})
B722:setBleeds_val({0,1,2})
B722:setAIce({"Not Required","Engine Only","Engine and Wing"})
B722:setAIce_val({0,1,2})
B722:setDepApMode({"HDG/IAS","VORLOC/IAS"})
B722:setDepApMode_val({0,1})

set_zc_config("acfname","Boeing 727-200")
set_zc_config("acficao","B722")

DEP_takeofthrust_list = B722:getTakeoffThrust()
DEP_aice_list = B722:getAIce()
DEP_bleeds_list = B722:getBleeds()

local curralt_1000 = 0
local curralt_10 = 0 
local elapsed_time_visible = 0

-- Procedure definitions
ZC_INIT_PROC = {
	[0] = {["lefttext"] = "KPCREW ".. ZC_VERSION .. " STARTED",["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "KPCREW ".. ZC_VERSION .. " FJS B727-200"
			command_once("bgood/xchecklist/reload_checklist")
		end
	}
}

ZC_COLD_AND_DARK = {
	[0] = {["lefttext"] = "OVERHEAD TOP", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/num/FlipPo_01",1)
			command_once("sim/electrical/battery_1_off")
			set("FJS/727/lights/DomeLightSwitch",0)
		end
	}, 
	[1] = {["lefttext"] = "HYDRAULIC POWER OVHD LEFT", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727Hyd/HydPowAilSysA",0)
			set("FJS/727Hyd/HydPowAilSysB",0)
			set("FJS/727Hyd/HydPowSpoSysAINBD",0)
			set("FJS/727Hyd/HydPowSpoSysBOUTBD",0)
			set("FJS/727Hyd/HydPowElvSysA",0)
			set("FJS/727Hyd/HydPowElvSysB",0)
			set("FJS/727Hyd/HydPowRudSysA",0)
			set("FJS/727Hyd/HydPowRudSysA2",0)
			set("FJS/727Hyd/HydPowRudSysB",0)
			set("FJS/727/num/FlipPo_09",0)
			set("FJS/727/num/FlipPo_10",0)
			set("FJS/727/num/FlipPo_11",0)
			set("FJS/727/num/FlipPo_12",0)
			set("FJS/727/num/FlipPo_13",0)
			set("FJS/727/num/FlipPo_14",0)
			set("FJS/727/num/FlipPo_15",0)
			set("FJS/727/num/FlipPo_16",0)
			set("FJS/727/num/FlipPo_17",0)
		end
	}, 
	[2] = {["lefttext"] = "ANTI SKID & STALL WARNING & COMPASS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/FltCntlWarnTestSwitch",0)
			set("FJS/727/Hyd/GearAntiSkidSwitch",0)
			set("FJS/727/num/FlipPo_18",1)
			set("FJS/727/Annun/StallWarningSwitch",0)
			set("FJS/727/Inst/CompassSys1_Switch",0)
		end
	}, 
	[3] = {["lefttext"] = "NAV SWITCHES & CARGO FIRE & AUTOBRAKE", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Inst/CompassTransfer_Switch",0)
			set("FJS/727/Inst/VHFNAV_Switch",0)
			set("FJS/727/Inst/VertGyro_Switch",0)
			set("FJS/727/FirePro/CargoDectAFTKnob",0)
			set("FJS/727/FirePro/CargoDectFWDKnob",0)
			set("FJS/727/Hyd/AutoBrakeKnob",0)
		end
	}, 		
	[4] = {["lefttext"] = "MID OVERHEAD", ["timerincr"] = 1,
		["actions"] = function ()
		
			set("FJS/727/AntiIce/AirRepellentLButton",0)
			set("FJS/727/AntiIce/AirRepellentRButton",0)
			set("FJS/727/AntiIce/WiperKnob",0)
			set("FJS/727/lights/EmerLightSwitch",0)
			set("FJS/727/num/FlipPo_23",0)
		end
	},     
	[5] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Eng/Engine1StartSwitch",0)
			set("FJS/727/Eng/Engine2StartSwitch",0)
			set("FJS/727/Eng/Engine3StartSwitch",0)
			set("FJS/727/num/FlipPo_19",0)
			set("FJS/727/num/FlipPo_20",0)
			set("FJS/727/num/FlipPo_21",0)
		end
	}, 
	[6] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/AlterFlapsSwitch",0)
			set("FJS/727/Hyd/AlterFlaps_Inbd_Switch",0)
			set("FJS/727/Hyd/AlterFlaps_Outbd_Switch",0)
			set("FJS/727/num/FlipPo_22",0)
			set("FJS/727/Inst/CompassSys2_Switch",0)
			set("FJS/727/Inst/CompassHDG2_Knob",0)
		end
	},                                                  
	[7] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/NoSmokingSwitch",0)
			set("FJS/727/lights/FastenBeltsSwitch",0)
			set("FJS/727/Radios/PAMontSpeakSwitch",0)
			set("FJS/727/Radios/Transponder_ModeKnob",0)
			set("FJS/727/Radios/TransponderABKnob",0)
			set("sim/cockpit/radios/transponder_code",2000)
		end
	},                                                  
	[8] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/windowHeatOHTestSwitch",0)
			set("FJS/727/bleed/WindowHeatL1Switch",0)
			set("FJS/727/bleed/WindowHeatL2Switch",0)
			set("FJS/727/bleed/WindowHeatR1Switch",0)
			set("FJS/727/bleed/WindowHeatR2Switch",0)
		end
	},                                                  
	[9] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/DuctTempKnob",0)
			set("FJS/727/bleed/WingAntiIceSwitchL",0)
			set("FJS/727/bleed/WingAntiIceSwitchR",0)
			set("FJS/727/bleed/EngAntiIceValveKnob",0)
			set("FJS/727/bleed/Eng1inletSwitch",0)
			set("FJS/727/bleed/Eng2inletSwitch",0)
			set("FJS/727/bleed/Eng3inletSwitch",0)
		end
	},                                                  
	[10] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/ProbHeaterSwitchL",0)
			set("FJS/727/bleed/ProbHeaterSwitchR",0)
		end
	},                                                  
	[11] = {["lefttext"] = "INTERNAL LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/MapLiteL_Knob",0)
			set("FJS/727/lights/Panel_LeftFwd_Knob",0.586)
			set("FJS/727/lights/Panel_CtrFwd_Knob",0.887162)
			set("FJS/727/lights/Fwd_Panel_storm_Knob",0)
			set("FJS/727/lights/FwdPanelFlourSwitch",0)
			set("FJS/727/lights/overhead",0.894132)
			set("FJS/727/lights/CtrStnd_Red_Knob",0)
			set("FJS/727/lights/WhiteCtrlStndKnob",0)
			set("FJS/727/lights/LightOverride",0)
			set("FJS/727/lights/Right_Fwd",0.854025)
			set("FJS/727/lights/MapLiteR_Knob",0)
			set("FJS/727/lights/DomeLightSwitch",0)
			set("FJS/727/lights/Panel_Compass_Knob",0.633655)
			set("FJS/727/lights/Panel_Circuit_Knob",0.902286)
			set("FJS/727/lights/FE_Wth_Knob",0)
			set("FJS/727/lights/FEPanel",0.542043)
			set("FJS/727/lights/FE_Red_Knob",0)
			set("FJS/727/lights/FE_PanelFlourSwitch",0)
			set("FJS/727/lights/RadioPanel",0.59)
		end
	},                                                  
	[12] = {["lefttext"] = "EXTERIOR LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/InboundLLSwitch_L",0)
			set("FJS/727/lights/InboundLLSwitch_R",0)
			set("FJS/727/lights/OutboundLLSwitch_L",0)
			set("FJS/727/lights/OutboundLLSwitch_R",0)
			set("FJS/727/lights/RunwayTurnoffLightSwitch_L",0)
			set("FJS/727/lights/RunwayTurnoffLightSwitch_R",0)
			set("FJS/727/lights/TaxiLightSwitch",0)
			set("FJS/727/lights/StrobeLightSwitch",0)
			set("FJS/727/lights/NavLightSwitch",0)
			set("FJS/727/lights/BeaconLightSwitch",0)
			set("FJS/727/lights/LogoLightSwitch",0)
			set("FJS/727/lights/WingLightSwitch",0)
		end
	},                                                  
	[13] = {["lefttext"] = "ENGINER PANELS ELECTRIC", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/DCmeterKnob",1)
			set("FJS/727/Elec/GalleyPow13",0)
			set("FJS/727/Elec/GalleyPow24",0)
			set("FJS/727/Elec/GroundPowSwitch",0)
			set("FJS/727/Elec/EssPowSelect",0)
			set("FJS/727/Elec/ACvoltMeterKnob",0)
			set("FJS/727/Elec/GenFreqKnob1",0)
			set("FJS/727/Elec/GenFreqKnob2",0)
			set("FJS/727/Elec/GenFreqKnob3",0)
			set("FJS/727/Elec/TieSwitch1",0)
			set("FJS/727/Elec/TieSwitch2",0)
			set("FJS/727/Elec/TieSwitch3",0)
			set("FJS/727/Elec/GenSwitch1",0)
			set("FJS/727/Elec/GenSwitch2",0)
			set("FJS/727/Elec/GenSwitch3",0)
			set("FJS/727/Elec/fieldSwitch1",0)
			set("FJS/727/Elec/fieldSwitch2",0)
			set("FJS/727/Elec/fieldSwitch3",0)
			set("FJS/727/Elec/GenDriveDiscon1",0)
			set("FJS/727/Elec/GenDriveDiscon2",0)
			set("FJS/727/Elec/GenDriveDiscon3",0)
			set("FJS/727/num/FlipPo_02",0)
			set("FJS/727/num/FlipPo_03",0)
			set("FJS/727/num/FlipPo_04",0)
			set("FJS/727/Elec/RiseInSwitch1",0)
			set("FJS/727/Elec/RiseInSwitch2",0)
			set("FJS/727/Elec/RiseInSwitch3",0)
		end
	},                                                  
	[14] = {["lefttext"] = "ENGINEER FUEL SYSTEM", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/fuel/fuelXfeedKnob1",0)
			set("FJS/727/fuel/fuelXfeedKnob2",1)
			set("FJS/727/fuel/fuelXfeedKnob3",0)
			set("FJS/727/fuel/fuelcutoutSwitch1",0)
			set("FJS/727/fuel/fuelcutoutSwitch2",0)
			set("FJS/727/fuel/fuelcutoutSwitch3",0)
			set("FJS/727/fuel/pumpSwitch1Fwd",0)
			set("FJS/727/fuel/pumpSwitch2FwdL",0)
			set("FJS/727/fuel/pumpSwitch2FwdR",0)
			set("FJS/727/fuel/pumpSwitch3Fwd",0)
			set("FJS/727/fuel/pumpSwitch1Aft",0)
			set("FJS/727/fuel/pumpSwitch2AftL",0)
			set("FJS/727/fuel/pumpSwitch2AftR",0)
			set("FJS/727/fuel/pumpSwitch3Aft",0)
			set("FJS/727/fuel/tank1HeatSwitch",0)
			set("FJS/727/fuel/tank2HeatSwitch",0)
			set("FJS/727/fuel/tank3HeatSwitch",0)
		end
	},                                                  
	[15] = {["lefttext"] = "RADIO PANEL AT ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Radios/VHF1AudioSwitch_A3",1)
			set("FJS/727/Radios/VHF2AudioSwitch_A3",1)
			set("FJS/727/Radios/VHF3AudioSwitch_A3",0)
			set("FJS/727/Radios/ServIntAudioSwitch_A3",0)
			set("FJS/727/Radios/IntAudioSwitch_A3",0)
			set("FJS/727/Radios/PA_AudioSwitch_A3",0)
			set("FJS/727/Radios/NAV1AudioSwitch_A3",0)
			set("FJS/727/Radios/DME1AudioSwitch_A3",0)
			set("FJS/727/Radios/ADF1AudioSwitch_A3",0)
			set("FJS/727/Radios/ADF2AudioSwitch_A3",0)
			set("FJS/727/Radios/DME2AudioSwitch_A3",0)
			set("FJS/727/Radios/AudioFilterKnob3",0)
			set("FJS/727/Radios/AudioTransSelectorKnob3",1)
		end
	},                                                  	
	[16] = {["lefttext"] = "HYDRAULIC SYSTEMS ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/HydSysAEng1Switch",0)
			set("FJS/727/Hyd/HydSysAEng2Switch",0)
			set("FJS/727/Hyd/GrdInterSwitch",0)
			set("FJS/727/Hyd/HydSysAEng1ShutoffSwitch",0)
			set("FJS/727/Hyd/HydSysAEng2ShutoffSwitch",0)
			set("FJS/727/num/FlipPo_06",0)
			set("FJS/727/num/FlipPo_07",0)
			set("FJS/727/Hyd/HydSysBpum1Switch",0)
			set("FJS/727/Hyd/HydSysBpum2Switch",0)
			set("FJS/727/Hyd/HydBrakeInterSwitch",0)
			set("FJS/727/num/FlipPo_05",0)
			set("FJS/727/Elec/OilCoolerSwitch",0)
		end
	},                     
	[17] = {["lefttext"] = "PACKS & BLEED AIR ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/Eng1BleedSwitch",0)
			set("FJS/727/bleed/Eng2BleedSwitchL",0)
			set("FJS/727/bleed/Eng2BleedSwitchR",0)
			set("FJS/727/bleed/Eng3BleedSwitch",0)
			set("FJS/727/bleed/PACK_LSwitch",0)
			set("FJS/727/bleed/PACK_RSwitch",0)
			set("FJS/727/bleed/CoolingDoorRSwitch",0)
			set("FJS/727/bleed/CoolingDoorLSwitch",0)
			set("FJS/727/bleed/CargoHeatOutflowSwitch",0)
			set("FJS/727/bleed/GasperFanSwitch",0)
		end
	},                     
	[18] = {["lefttext"] = "PRESSURIZATION & A/C ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/CabinTempKnob",50)
			set("FJS/727/bleed/PassengerTempKnob",50)
			set("FJS/727/bleed/AirTempKnob",0)
			set("FJS/727/bleed/AutoFlightAltKnob",0)
			set("FJS/727/bleed/AutoLandAltKnob1000",0)
			set("FJS/727/bleed/AutoLandAltKnob10",0)
			set("FJS/727/bleed/StybyCabinRateKnob",6)
			set("FJS/727/bleed/StbyCabinAltKnob10",0)
			set("FJS/727/bleed/StbyCabinAltKnob1000",6)
			set("FJS/727/bleed/OutflowValveSwitch",0)
			set("FJS/727/bleed/PressModeKnob",0)
			set("FJS/727/bleed/FltGndSwitch",0)
			set("FJS/727/num/PassOxySwitch",0)
			set("FJS/727/bleed/AutoPackSwitch",0)
			set("FJS/727/bleed/AftCabinMixValveSwitch",0)
		end
	},     
	[19] = {["lefttext"] = "TANKS ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Fuel/FDTank1Switch",0)
			set("FJS/727/Fuel/FDTank2SwitchA",0)
			set("FJS/727/Fuel/FDTank2SwitchB",0)
			set("FJS/727/Fuel/FDTank3Switch",0)
			set("FJS/727/Fuel/FDNozzleLSwitch",0)
			set("FJS/727/Fuel/FDNozzleRSwitch",0)
		end
	},                     
	[20] = {["lefttext"] = "APU ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/APU_StarSwitch",0)
			set("FJS/727/Elec/APU_FieldSwitch",0)
			set("FJS/727/Elec/APU_GenSwitch",0)
			set("FJS/727/Fail/APU_autoFireShutdownSwitch",0)
			set("FJS/727/num/FlipPo_08",0)
			set("FJS/727/Fail/APU_FireHandle",0)
			set("FJS/727/Fail/APU_FireTestSwitch",0)
			set("FJS/727/Annun/LESlatSysSwitch",0)
		end
	},                     
	[21] = {["lefttext"] = "MAIN PANEL", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Inst/MachWarningTestSwitch",0)
			set("FJS/727/Inst/MachWarningModeABSwitch",0)
			set("FJS/727/AntiIce/WindshieldAirKnobL",0)
			set("FJS/727/AntiIce/FootAirKnobL",0)
			set("FJS/727/Hyd/YawDamTestSwitch",0)
			set("FJS/727/Hyd/PneumaticHandle",0)
			set("FJS/727/MarkerVolumeSwitch",0)
			set("FJS/727/autopilot/altDialHunThouSwitch",0)
			set("FJS/727/Hyd/LowerYawSwitch",1)
			set("FJS/727/Hyd/UpperYawSwitch",1)
			set("FJS/727/num/FlipPo_24",0)
			set("FJS/727/num/FlipPo_25",0)
			set("FJS/727/Annun/AnnunLightsSwitch",0)
			set("FJS/727/Annun/GPWS_InhibitSwitch",0)
			set("FJS/727/num/FlipPo_26",0)
			set("FJS/727/AntiIce/WindshieldAirKnobR",0)
			set("FJS/727/AntiIce/FootAirKnobR",0)
		end
	},
	[22] = {["lefttext"] = "GLARESHIELD", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Autopilot/PitchComKnob",0)
			set("FJS/727/autopilot/FDModeSelector",0)
			set("FJS/727/Autopilot/FDAltHoldSwitch",0)
			set("FJS/727/FirePro/BottleTransferSwitch",0)
			set("FJS/727/FirePro/FireTestSwitch",0)
		end
	},
	[23] = {["lefttext"] = "PEDESTAL", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/wx/WXSysSwitch",0)
			set("FJS/727/wx/WX_MapRange",0)
			set("FJS/727/wx/BrtKnob",0.95)
			set("FJS/727/wx/WXGainKnob",0)
			set("FJS/727/wx/WX_or_MAP",0)
			set("FJS/727/wx/TiltKnob",0)
			set("FJS/727/autopilot/PitchSelectKnob",0)
			set("FJS/727/autopilot/AP_Lever",0)
			set("FJS/727/autopilot/NavSelectKnob",0)
			set("FJS/727/fuel/FuelMixtureLever1",0)
			set("FJS/727/fuel/FuelMixtureLever2",0)
			set("FJS/727/fuel/FuelMixtureLever3",0)
		end
	},
	[24] = {["lefttext"] = "RADIO PANEL AT ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Radios/VHF1AudioSwitch_A1",1)
			set("FJS/727/Radios/VHF2AudioSwitch_A1",1)
			set("FJS/727/Radios/VHF3AudioSwitch_A1",0)
			set("FJS/727/Radios/ServIntAudioSwitch_A1",0)
			set("FJS/727/Radios/IntAudioSwitch_A1",0)
			set("FJS/727/Radios/PA_AudioSwitch_A1",0)
			set("FJS/727/Radios/NAV1AudioSwitch_A1",0)
			set("FJS/727/Radios/DME1AudioSwitch_A1",0)
			set("FJS/727/Radios/ADF1AudioSwitch_A1",0)
			set("FJS/727/Radios/ADF2AudioSwitch_A1",0)
			set("FJS/727/Radios/DME2AudioSwitch_A1",0)
			set("FJS/727/Radios/AudioFilterKnob1",0)
			set("FJS/727/Radios/AudioTransSelectorKnob1",1)
		end
	},                                                  	
	[25] = {["lefttext"] = "RADIO PANEL AT ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Radios/VHF1AudioSwitch_A2",1)
			set("FJS/727/Radios/VHF2AudioSwitch_A2",1)
			set("FJS/727/Radios/VHF3AudioSwitch_A2",0)
			set("FJS/727/Radios/ServIntAudioSwitch_A2",0)
			set("FJS/727/Radios/IntAudioSwitch_A2",0)
			set("FJS/727/Radios/PA_AudioSwitch_A2",0)
			set("FJS/727/Radios/NAV1AudioSwitch_A2",0)
			set("FJS/727/Radios/DME1AudioSwitch_A2",0)
			set("FJS/727/Radios/ADF1AudioSwitch_A2",0)
			set("FJS/727/Radios/ADF2AudioSwitch_A2",0)
			set("FJS/727/Radios/DME2AudioSwitch_A2",0)
			set("FJS/727/Radios/AudioFilterKnob2",0)
			set("FJS/727/Radios/AudioTransSelectorKnob2",1)
		end
	},                                                  	
	[26] = {["lefttext"] = "ELECTRIC MASTER SWITCH", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/Radio1MasterSwitch",1)
			set("FJS/727/Elec/Radio2MasterSwitch",1)
		end
	}, 
	[27] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gRightText = "COLD & DARK STATE SET"
			command_once("bgood/xchecklist/check_item")
		end
	}
}

ZC_POWER_UP_PROC = {
	[0] = {["lefttext"] = "PRELIMINARY COCKPIT PREP - POWER UP",["timerincr"] = 2,
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
			set("FJS/727/fuel/FuelMixtureLever1",0)
			set("FJS/727/fuel/FuelMixtureLever2",0)
			set("FJS/727/fuel/FuelMixtureLever3",0)
			set("FJS/727/bleed/AftCabinMixValveSwitch",-1)
		end
	},
	-- BATTERY ON
	[3] = {["lefttext"] = "ENG: BATTERY -- ON",["timerincr"] = 2,
		["actions"] = function ()
			command_once("sim/electrical/battery_1_on")
			set("FJS/727/Elec/EssPowSelect",-1)
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/727/lights/DomeLightSwitch",1)
			else
				set("FJS/727/lights/DomeLightSwitch",0)
			end
		end
	},
	-- GROUND POWER ON
	[4] = {["lefttext"] = "CAPT: CONNECT GPU IN MENU", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/num/FlipPo_01",0)
			if get_zc_config("apuinit") == false then
				gLeftText = "CONNECT GPU IN MENU"
				speakNoText(0,"CONNECT GPU IN MENU")
			end
		end
	},
	[5] = {["lefttext"] = "CAPT: CONNECT GPU IN MENU", ["timerincr"] = (get_zc_config("apuinit") and 3 or 997),
		["actions"] = function ()
			if get_zc_config("apuinit") == false then
				gLeftText = "GPU CONNECTED"
				set("FJS/727/Elec/GroundPowSwitch",1)
			else
				set("FJS/727/Elec/GroundPowSwitch",-1)
				set("FJS/727/Fail/APU_FireTestSwitch",1)
			end
		end
	},
	-- APU ON
	[6] = {["lefttext"] = "ENG: APU START - OPTIONAL", ["timerincr"] = 3,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/727/Fail/APU_FireTestSwitch",-1)
				set("FJS/727/Elec/APU_StarSwitch",2)
				set("FJS/727/Elec/GroundPowSwitch",0)
			else
				set("FJS/727/Elec/APU_StarSwitch",0)
			end
		end
	}, 
	[7] = {["lefttext"] = "ENG: APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/727/Elec/APU_StarSwitch",1)
				-- background wait for APU generator
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
				set("FJS/727/Elec/EssPowSelect",0)
			else
				set("FJS/727/Elec/APU_StarSwitch",0)
				set("FJS/727/Elec/EssPowSelect",4)
			end
		end
	},
	[8] = {["lefttext"] = "HYDRAULIC POWER OVHD LEFT", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727Hyd/HydPowAilSysA",0)
			set("FJS/727Hyd/HydPowAilSysB",0)
			set("FJS/727Hyd/HydPowSpoSysAINBD",0)
			set("FJS/727Hyd/HydPowSpoSysBOUTBD",0)
			set("FJS/727Hyd/HydPowElvSysA",0)
			set("FJS/727Hyd/HydPowElvSysB",0)
			set("FJS/727Hyd/HydPowRudSysA",0)
			set("FJS/727Hyd/HydPowRudSysA2",0)
			set("FJS/727Hyd/HydPowRudSysB",0)
			set("FJS/727/num/FlipPo_09",0)
			set("FJS/727/num/FlipPo_10",0)
			set("FJS/727/num/FlipPo_11",0)
			set("FJS/727/num/FlipPo_12",0)
			set("FJS/727/num/FlipPo_13",0)
			set("FJS/727/num/FlipPo_14",0)
			set("FJS/727/num/FlipPo_15",0)
			set("FJS/727/num/FlipPo_16",0)
			set("FJS/727/num/FlipPo_17",0)
		end
	}, 
	[9] = {["lefttext"] = "ELECTRIC MASTER SWITCH", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/Radio1MasterSwitch",1)
			set("FJS/727/Elec/Radio2MasterSwitch",1)
			set("FJS/727/Radios/Transponder_ModeKnob",0)
			set("FJS/727/Radios/TransponderABKnob",0)
			set("sim/cockpit/radios/transponder_code",2000)
		end
	}, 
	-- OTHER SETTINGS
	[10] = {["lefttext"] = "OTHER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/PACK_LSwitch",0)
			set("FJS/727/bleed/PACK_RSwitch",0)
			set("FJS/727/bleed/PressModeKnob",0)
			set("FJS/727/bleed/FltGndSwitch",0)
			set("FJS/727/bleed/CabinTempKnob",50)
			set("FJS/727/bleed/PassengerTempKnob",50)
			set("FJS/727/bleed/AirTempKnob",0)
			set("FJS/727/bleed/Eng1inletSwitch",0)
			set("FJS/727/bleed/Eng2inletSwitch",0)
			set("FJS/727/bleed/Eng3inletSwitch",0)
			set("FJS/727/bleed/CargoHeatOutflowSwitch",1)
		end
	}, 
	[11] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/AftCabinMixValveSwitch",0)
			set("sim/cockpit/autopilot/airspeed",get_zc_config("apspd"))
			set("sim/cockpit/autopilot/heading_mag",get_zc_config("aphdg"))
			set("sim/cockpit/autopilot/altitude",get_zc_config("apalt"))
			ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status=1
		end
	}, 
	[12] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "POWER UP FINISHED"
			speakNoText(0,"POWER UP FINISHED")
		end
	}
}

ZC_TURN_AROUND_STATE = {
	[0] = {["lefttext"] = "OVERHEAD TOP", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("sim/electrical/battery_1_on")
			set("FJS/727/num/FlipPo_01",0)
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/727/lights/DomeLightSwitch",1)
			else
				set("FJS/727/lights/DomeLightSwitch",0)
			end
		end
	}, 
	-- GROUND POWER ON
	[1] = {["lefttext"] = "CAPT: CONNECT GPU IN MENU", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/num/FlipPo_01",0)
			if get_zc_config("apuinit") == false then
				gLeftText = "CONNECT GPU IN MENU"
				speakNoText(0,"CONNECT GPU IN MENU")
			end
		end
	},
	[2] = {["lefttext"] = "CAPT: CONNECT GPU IN MENU", ["timerincr"] = (get_zc_config("apuinit") and 3 or 997),
		["actions"] = function ()
			if get_zc_config("apuinit") == false then
				gLeftText = "GPU CONNECTED"
				set("FJS/727/Elec/GroundPowSwitch",1)
			else
				set("FJS/727/Elec/GroundPowSwitch",-1)
				set("FJS/727/Fail/APU_FireTestSwitch",1)
			end
		end
	},
	-- APU ON
	[3] = {["lefttext"] = "ENG: APU START - OPTIONAL", ["timerincr"] = 3,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/727/Fail/APU_FireTestSwitch",-1)
				set("FJS/727/Elec/APU_StarSwitch",2)
				set("FJS/727/Elec/GroundPowSwitch",0)
			else
				set("FJS/727/Elec/APU_StarSwitch",0)
			end
		end
	}, 
	[4] = {["lefttext"] = "ENG: APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				set("FJS/727/Elec/APU_StarSwitch",1)
				-- background wait for APU generator
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
				set("FJS/727/Elec/EssPowSelect",0)
			else
				set("FJS/727/Elec/APU_StarSwitch",0)
				set("FJS/727/Elec/EssPowSelect",4)
			end
		end
	},
	[5] = {["lefttext"] = "HYDRAULIC POWER OVHD LEFT", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727Hyd/HydPowAilSysA",0)
			set("FJS/727Hyd/HydPowAilSysB",0)
			set("FJS/727Hyd/HydPowSpoSysAINBD",0)
			set("FJS/727Hyd/HydPowSpoSysBOUTBD",0)
			set("FJS/727Hyd/HydPowElvSysA",0)
			set("FJS/727Hyd/HydPowElvSysB",0)
			set("FJS/727Hyd/HydPowRudSysA",0)
			set("FJS/727Hyd/HydPowRudSysA2",0)
			set("FJS/727Hyd/HydPowRudSysB",0)
			set("FJS/727/num/FlipPo_09",0)
			set("FJS/727/num/FlipPo_10",0)
			set("FJS/727/num/FlipPo_11",0)
			set("FJS/727/num/FlipPo_12",0)
			set("FJS/727/num/FlipPo_13",0)
			set("FJS/727/num/FlipPo_14",0)
			set("FJS/727/num/FlipPo_15",0)
			set("FJS/727/num/FlipPo_16",0)
			set("FJS/727/num/FlipPo_17",0)
		end
	}, 
	[6] = {["lefttext"] = "ELECTRIC MASTER SWITCH", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/Radio1MasterSwitch",1)
			set("FJS/727/Elec/Radio2MasterSwitch",1)
			set("FJS/727/Radios/Transponder_ModeKnob",0)
			set("FJS/727/Radios/TransponderABKnob",0)
			set("sim/cockpit/radios/transponder_code",2000)
		end
	}, 
	-- OTHER SETTINGS
	[7] = {["lefttext"] = "OTHER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/PACK_LSwitch",0)
			set("FJS/727/bleed/PACK_RSwitch",0)
			set("FJS/727/bleed/PressModeKnob",0)
			set("FJS/727/bleed/FltGndSwitch",0)
			set("FJS/727/bleed/CabinTempKnob",50)
			set("FJS/727/bleed/PassengerTempKnob",50)
			set("FJS/727/bleed/AirTempKnob",0)
			set("FJS/727/bleed/Eng1inletSwitch",0)
			set("FJS/727/bleed/Eng2inletSwitch",0)
			set("FJS/727/bleed/Eng3inletSwitch",0)
			set("FJS/727/bleed/CargoHeatOutflowSwitch",1)
		end
	}, 
	[8] = {["lefttext"] = "ANTI SKID & STALL WARNING & COMPASS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/FltCntlWarnTestSwitch",0)
			set("FJS/727/Hyd/GearAntiSkidSwitch",1)
			set("FJS/727/num/FlipPo_18",0)
			set("FJS/727/Annun/StallWarningSwitch",0)
			set("FJS/727/Inst/CompassSys1_Switch",0)
		end
	}, 
	[9] = {["lefttext"] = "NAV SWITCHES & CARGO FIRE & AUTOBRAKE", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Inst/CompassTransfer_Switch",0)
			set("FJS/727/Inst/VHFNAV_Switch",0)
			set("FJS/727/Inst/VertGyro_Switch",0)
			set("FJS/727/FirePro/CargoDectAFTKnob",0)
			set("FJS/727/FirePro/CargoDectFWDKnob",0)
			set("FJS/727/Hyd/AutoBrakeKnob",0)
		end
	}, 		
	[10] = {["lefttext"] = "MID OVERHEAD", ["timerincr"] = 1,
		["actions"] = function ()
		
			set("FJS/727/AntiIce/AirRepellentLButton",0)
			set("FJS/727/AntiIce/AirRepellentRButton",0)
			set("FJS/727/AntiIce/WiperKnob",0)
			set("FJS/727/lights/EmerLightSwitch",-1)
			set("FJS/727/num/FlipPo_23",1)
		end
	},     
	[11] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Eng/Engine1StartSwitch",0)
			set("FJS/727/Eng/Engine2StartSwitch",0)
			set("FJS/727/Eng/Engine3StartSwitch",0)
			set("FJS/727/num/FlipPo_19",0)
			set("FJS/727/num/FlipPo_20",0)
			set("FJS/727/num/FlipPo_21",0)
		end
	}, 
	[12] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/AlterFlapsSwitch",0)
			set("FJS/727/Hyd/AlterFlaps_Inbd_Switch",0)
			set("FJS/727/Hyd/AlterFlaps_Outbd_Switch",0)
			set("FJS/727/num/FlipPo_22",0)
			set("FJS/727/Inst/CompassSys2_Switch",0)
			set("FJS/727/Inst/CompassHDG2_Knob",0)
		end
	},                                                  
	[13] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/NoSmokingSwitch",1)
			set("FJS/727/lights/FastenBeltsSwitch",1)
			set("FJS/727/Radios/PAMontSpeakSwitch",0)
			set("FJS/727/Radios/Transponder_ModeKnob",0)
			set("FJS/727/Radios/TransponderABKnob",0)
			set("sim/cockpit/radios/transponder_code",2000)
		end
	},                                                  
	[14] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/windowHeatOHTestSwitch",0)
			set("FJS/727/bleed/WindowHeatL1Switch",1)
			set("FJS/727/bleed/WindowHeatL2Switch",1)
			set("FJS/727/bleed/WindowHeatR1Switch",1)
			set("FJS/727/bleed/WindowHeatR2Switch",1)
		end
	},                                                  
	[15] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/DuctTempKnob",1)
			set("FJS/727/bleed/WingAntiIceSwitchL",0)
			set("FJS/727/bleed/WingAntiIceSwitchR",0)
			set("FJS/727/bleed/EngAntiIceValveKnob",0)
			set("FJS/727/bleed/Eng1inletSwitch",0)
			set("FJS/727/bleed/Eng2inletSwitch",0)
			set("FJS/727/bleed/Eng3inletSwitch",0)
		end
	},                                                  
	[16] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/ProbHeaterSwitchL",0)
			set("FJS/727/bleed/ProbHeaterSwitchR",0)
		end
	},                                                  
	[17] = {["lefttext"] = "INTERNAL LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/MapLiteL_Knob",0)
			set("FJS/727/lights/Panel_LeftFwd_Knob",0.586)
			set("FJS/727/lights/Panel_CtrFwd_Knob",0.887162)
			set("FJS/727/lights/Fwd_Panel_storm_Knob",0)
			set("FJS/727/lights/FwdPanelFlourSwitch",0)
			set("FJS/727/lights/overhead",0.894132)
			set("FJS/727/lights/CtrStnd_Red_Knob",0)
			set("FJS/727/lights/WhiteCtrlStndKnob",0)
			set("FJS/727/lights/LightOverride",0)
			set("FJS/727/lights/Right_Fwd",0.854025)
			set("FJS/727/lights/MapLiteR_Knob",0)
			set("FJS/727/lights/DomeLightSwitch",0)
			set("FJS/727/lights/Panel_Compass_Knob",0.633655)
			set("FJS/727/lights/Panel_Circuit_Knob",0.902286)
			set("FJS/727/lights/FE_Wth_Knob",0)
			set("FJS/727/lights/FEPanel",0.542043)
			set("FJS/727/lights/FE_Red_Knob",0)
			set("FJS/727/lights/FE_PanelFlourSwitch",0)
			set("FJS/727/lights/RadioPanel",0.59)
		end
	},                                                  
	[18] = {["lefttext"] = "EXTERIOR LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/InboundLLSwitch_L",0)
			set("FJS/727/lights/InboundLLSwitch_R",0)
			set("FJS/727/lights/OutboundLLSwitch_L",0)
			set("FJS/727/lights/OutboundLLSwitch_R",0)
			set("FJS/727/lights/RunwayTurnoffLightSwitch_L",0)
			set("FJS/727/lights/RunwayTurnoffLightSwitch_R",0)
			set("FJS/727/lights/TaxiLightSwitch",0)
			set("FJS/727/lights/StrobeLightSwitch",0)
			set("FJS/727/lights/NavLightSwitch",0)
			set("FJS/727/lights/BeaconLightSwitch",0)
			set("FJS/727/lights/LogoLightSwitch",0)
			set("FJS/727/lights/WingLightSwitch",0)
		end
	},                                                  
	[19] = {["lefttext"] = "ENGINER PANELS ELECTRIC", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/DCmeterKnob",1)
			set("FJS/727/Elec/GalleyPow13",1)
			set("FJS/727/Elec/GalleyPow24",1)
			set("FJS/727/Elec/ACvoltMeterKnob",0)
			set("FJS/727/Elec/GenFreqKnob1",0)
			set("FJS/727/Elec/GenFreqKnob2",0)
			set("FJS/727/Elec/GenFreqKnob3",0)
			set("FJS/727/Elec/TieSwitch1",0)
			set("FJS/727/Elec/TieSwitch2",0)
			set("FJS/727/Elec/TieSwitch3",0)
			set("FJS/727/Elec/GenSwitch1",0)
			set("FJS/727/Elec/GenSwitch2",0)
			set("FJS/727/Elec/GenSwitch3",0)
			set("FJS/727/Elec/fieldSwitch1",0)
			set("FJS/727/Elec/fieldSwitch2",0)
			set("FJS/727/Elec/fieldSwitch3",0)
			set("FJS/727/Elec/GenDriveDiscon1",0)
			set("FJS/727/Elec/GenDriveDiscon2",0)
			set("FJS/727/Elec/GenDriveDiscon3",0)
			set("FJS/727/num/FlipPo_02",0)
			set("FJS/727/num/FlipPo_03",0)
			set("FJS/727/num/FlipPo_04",0)
			set("FJS/727/Elec/RiseInSwitch1",0)
			set("FJS/727/Elec/RiseInSwitch2",0)
			set("FJS/727/Elec/RiseInSwitch3",0)
		end
	},                                                  
	[20] = {["lefttext"] = "ENGINEER FUEL SYSTEM", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/fuel/fuelXfeedKnob1",0)
			set("FJS/727/fuel/fuelXfeedKnob2",1)
			set("FJS/727/fuel/fuelXfeedKnob3",0)
			set("FJS/727/fuel/fuelcutoutSwitch1",1)
			set("FJS/727/fuel/fuelcutoutSwitch2",1)
			set("FJS/727/fuel/fuelcutoutSwitch3",1)
			set("FJS/727/fuel/pumpSwitch1Fwd",0)
			set("FJS/727/fuel/pumpSwitch2FwdL",0)
			set("FJS/727/fuel/pumpSwitch2FwdR",0)
			set("FJS/727/fuel/pumpSwitch3Fwd",0)
			set("FJS/727/fuel/pumpSwitch1Aft",0)
			set("FJS/727/fuel/pumpSwitch2AftL",0)
			set("FJS/727/fuel/pumpSwitch2AftR",0)
			set("FJS/727/fuel/pumpSwitch3Aft",0)
			set("FJS/727/fuel/tank1HeatSwitch",0)
			set("FJS/727/fuel/tank2HeatSwitch",0)
			set("FJS/727/fuel/tank3HeatSwitch",0)
		end
	},                                                  
	[21] = {["lefttext"] = "RADIO PANEL AT ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Radios/VHF1AudioSwitch_A3",1)
			set("FJS/727/Radios/VHF2AudioSwitch_A3",1)
			set("FJS/727/Radios/VHF3AudioSwitch_A3",0)
			set("FJS/727/Radios/ServIntAudioSwitch_A3",0)
			set("FJS/727/Radios/IntAudioSwitch_A3",0)
			set("FJS/727/Radios/PA_AudioSwitch_A3",0)
			set("FJS/727/Radios/NAV1AudioSwitch_A3",0)
			set("FJS/727/Radios/DME1AudioSwitch_A3",0)
			set("FJS/727/Radios/ADF1AudioSwitch_A3",0)
			set("FJS/727/Radios/ADF2AudioSwitch_A3",0)
			set("FJS/727/Radios/DME2AudioSwitch_A3",0)
			set("FJS/727/Radios/AudioFilterKnob3",0)
			set("FJS/727/Radios/AudioTransSelectorKnob3",1)
		end
	},                                                  	
	[22] = {["lefttext"] = "HYDRAULIC SYSTEMS ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/HydSysAEng1Switch",1)
			set("FJS/727/Hyd/HydSysAEng1Switch",1)
			set("FJS/727/Hyd/GrdInterSwitch",0)
			set("FJS/727/Hyd/HydSysAEng1ShutoffSwitch",0)
			set("FJS/727/Hyd/HydSysAEng2ShutoffSwitch",0)
			set("FJS/727/num/FlipPo_06",0)
			set("FJS/727/num/FlipPo_07",0)
			set("FJS/727/Hyd/HydSysBpum1Switch",0)
			set("FJS/727/Hyd/HydSysBpum2Switch",0)
			set("FJS/727/Hyd/HydBrakeInterSwitch",0)
			set("FJS/727/num/FlipPo_05",0)
			set("FJS/727/Elec/OilCoolerSwitch",0)
		end
	},                     
	[23] = {["lefttext"] = "PACKS & BLEED AIR ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/Eng1BleedSwitch",1)
			set("FJS/727/bleed/Eng2BleedSwitchL",1)
			set("FJS/727/bleed/Eng2BleedSwitchR",1)
			set("FJS/727/bleed/Eng3BleedSwitch",1)
			set("FJS/727/bleed/PACK_LSwitch",1)
			set("FJS/727/bleed/PACK_RSwitch",0)
			set("FJS/727/bleed/CoolingDoorRSwitch",0)
			set("FJS/727/bleed/CoolingDoorLSwitch",0)
			set("FJS/727/bleed/CargoHeatOutflowSwitch",1)
			set("FJS/727/bleed/GasperFanSwitch",1)
		end
	},                     
	[24] = {["lefttext"] = "PRESSURIZATION & A/C ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/CabinTempKnob",50)
			set("FJS/727/bleed/PassengerTempKnob",50)
			set("FJS/727/bleed/AirTempKnob",0)
			set("FJS/727/bleed/AutoFlightAltKnob",0)
			set("FJS/727/bleed/AutoLandAltKnob1000",0)
			set("FJS/727/bleed/AutoLandAltKnob10",0)
			set("FJS/727/bleed/StybyCabinRateKnob",6)
			set("FJS/727/bleed/StbyCabinAltKnob10",0)
			set("FJS/727/bleed/StbyCabinAltKnob1000",6)
			set("FJS/727/bleed/OutflowValveSwitch",0)
			set("FJS/727/bleed/PressModeKnob",0)
			set("FJS/727/bleed/FltGndSwitch",0)
			set("FJS/727/num/PassOxySwitch",0)
			set("FJS/727/bleed/AutoPackSwitch",0)
			set("FJS/727/bleed/AftCabinMixValveSwitch",0)
		end
	},     
	[25] = {["lefttext"] = "TANKS ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Fuel/FDTank1Switch",0)
			set("FJS/727/Fuel/FDTank2SwitchA",0)
			set("FJS/727/Fuel/FDTank2SwitchB",0)
			set("FJS/727/Fuel/FDTank3Switch",0)
			set("FJS/727/Fuel/FDNozzleLSwitch",0)
			set("FJS/727/Fuel/FDNozzleRSwitch",0)
		end
	},                     
	[26] = {["lefttext"] = "MAIN PANEL", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Inst/MachWarningTestSwitch",0)
			set("FJS/727/Inst/MachWarningModeABSwitch",0)
			set("FJS/727/AntiIce/WindshieldAirKnobL",0)
			set("FJS/727/AntiIce/FootAirKnobL",0)
			set("FJS/727/Hyd/YawDamTestSwitch",0)
			set("FJS/727/Hyd/PneumaticHandle",0)
			set("FJS/727/MarkerVolumeSwitch",0)
			set("FJS/727/autopilot/altDialHunThouSwitch",0)
			set("FJS/727/Hyd/LowerYawSwitch",1)
			set("FJS/727/Hyd/UpperYawSwitch",1)
			set("FJS/727/num/FlipPo_24",0)
			set("FJS/727/num/FlipPo_25",0)
			set("FJS/727/Annun/AnnunLightsSwitch",0)
			set("FJS/727/Annun/GPWS_InhibitSwitch",0)
			set("FJS/727/num/FlipPo_26",0)
			set("FJS/727/AntiIce/WindshieldAirKnobR",0)
			set("FJS/727/AntiIce/FootAirKnobR",0)
		end
	},
	[27] = {["lefttext"] = "GLARESHIELD", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Autopilot/PitchComKnob",0)
			set("FJS/727/autopilot/FDModeSelector",0)
			set("FJS/727/Autopilot/FDAltHoldSwitch",0)
			set("FJS/727/FirePro/BottleTransferSwitch",0)
			set("FJS/727/FirePro/FireTestSwitch",0)
		end
	},
	[28] = {["lefttext"] = "PEDESTAL", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/wx/WXSysSwitch",0)
			set("FJS/727/wx/WX_MapRange",0)
			set("FJS/727/wx/BrtKnob",0.95)
			set("FJS/727/wx/WXGainKnob",0)
			set("FJS/727/wx/WX_or_MAP",0)
			set("FJS/727/wx/TiltKnob",0)
			set("FJS/727/autopilot/PitchSelectKnob",0)
			set("FJS/727/autopilot/AP_Lever",0)
			set("FJS/727/autopilot/NavSelectKnob",0)
		end
	},
	[29] = {["lefttext"] = "RADIO PANEL AT ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Radios/VHF1AudioSwitch_A1",1)
			set("FJS/727/Radios/VHF2AudioSwitch_A1",1)
			set("FJS/727/Radios/VHF3AudioSwitch_A1",0)
			set("FJS/727/Radios/ServIntAudioSwitch_A1",0)
			set("FJS/727/Radios/IntAudioSwitch_A1",0)
			set("FJS/727/Radios/PA_AudioSwitch_A1",0)
			set("FJS/727/Radios/NAV1AudioSwitch_A1",0)
			set("FJS/727/Radios/DME1AudioSwitch_A1",0)
			set("FJS/727/Radios/ADF1AudioSwitch_A1",0)
			set("FJS/727/Radios/ADF2AudioSwitch_A1",0)
			set("FJS/727/Radios/DME2AudioSwitch_A1",0)
			set("FJS/727/Radios/AudioFilterKnob1",0)
			set("FJS/727/Radios/AudioTransSelectorKnob1",1)
		end
	},                                                  	
	[30] = {["lefttext"] = "RADIO PANEL AT ENGINEER", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Radios/VHF1AudioSwitch_A2",1)
			set("FJS/727/Radios/VHF2AudioSwitch_A2",1)
			set("FJS/727/Radios/VHF3AudioSwitch_A2",0)
			set("FJS/727/Radios/ServIntAudioSwitch_A2",0)
			set("FJS/727/Radios/IntAudioSwitch_A2",0)
			set("FJS/727/Radios/PA_AudioSwitch_A2",0)
			set("FJS/727/Radios/NAV1AudioSwitch_A2",0)
			set("FJS/727/Radios/DME1AudioSwitch_A2",0)
			set("FJS/727/Radios/ADF1AudioSwitch_A2",0)
			set("FJS/727/Radios/ADF2AudioSwitch_A2",0)
			set("FJS/727/Radios/DME2AudioSwitch_A2",0)
			set("FJS/727/Radios/AudioFilterKnob2",0)
			set("FJS/727/Radios/AudioTransSelectorKnob2",1)
		end
	},                                                  	
	[31] = {["lefttext"] = "ELECTRIC MASTER SWITCH", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/Radio1MasterSwitch",1)
			set("FJS/727/Elec/Radio2MasterSwitch",1)
		end
	}, 
	[32] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gRightText = "COLD & DARK STATE SET"
			command_once("bgood/xchecklist/check_item")
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
				set("FJS/727/lights/DomeLightSwitch",1)
			end
		end
	}, 
	[2] = {["lefttext"] = "CAPT: FIRE TEST", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/727/FirePro/FireTestSwitch",1)
		end
	}, 
	[3] = {["lefttext"] = "CAPT: SET PARKING BRAKE", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/FirePro/FireTestSwitch",0)
			set("sim/flightmodel/controls/parkbrake",1)
		end
	}, 
	[4] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE, LOADING & FUEL", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "CAPT: CDU PREFLIGHT PROCEDURE, LOADING & FUEL"
			command_once("sim/FMS/CDU_popup")
			command_once("sim/FMS/fpln")
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status = 1
		end
	}, 
	[5] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE, LOADING & FUEL", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "CDU PREFLIGHT PROCEDURE DONE"
		end
	}, 
	[6] = {["lefttext"] = "ENG: FUEL SYSTEM SET FOR START", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/fuel/fuelXfeedKnob1",0)
			set("FJS/727/fuel/fuelXfeedKnob2",1)
			set("FJS/727/fuel/fuelXfeedKnob3",0)
			set("FJS/727/fuel/fuelcutoutSwitch1",1)
			set("FJS/727/fuel/fuelcutoutSwitch2",1)
			set("FJS/727/fuel/fuelcutoutSwitch3",1)
			set("FJS/727/fuel/pumpSwitch1Fwd",1)
			set("FJS/727/fuel/pumpSwitch2FwdL",1)
			set("FJS/727/fuel/pumpSwitch2FwdR",1)
			set("FJS/727/fuel/pumpSwitch3Fwd",1)
			set("FJS/727/fuel/pumpSwitch1Aft",1)
			set("FJS/727/fuel/pumpSwitch2AftL",1)
			set("FJS/727/fuel/pumpSwitch2AftR",1)
			set("FJS/727/fuel/pumpSwitch3Aft",1)
			if get("FJS/727/fuel/tank1tempNeedle") < 0 then
				set("FJS/727/fuel/tank1HeatSwitch",1)
				set("FJS/727/fuel/tank2HeatSwitch",1)
				set("FJS/727/fuel/tank3HeatSwitch",1)
			end
			if (get("FJS/727/fuel/tank2Needle") > get("FJS/727/fuel/tank1Needle")) and (get("FJS/727/fuel/tank2Needle") > get("FJS/727/fuel/tank3Needle")) then
				set("FJS/727/fuel/fuelXfeedKnob1",1)
				set("FJS/727/fuel/fuelXfeedKnob2",1)
				set("FJS/727/fuel/fuelXfeedKnob3",1)
			end
		end
	},                                                  
	[7] = {["lefttext"] = "ENG: HYDRAULIC SYSTEMS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/HydSysAEng1Switch",1)
			set("FJS/727/Hyd/HydSysAEng1Switch",1)
			set("FJS/727/Hyd/GrdInterSwitch",0)
			set("FJS/727/Hyd/HydSysBpum1Switch",1)
			set("FJS/727/Hyd/HydSysBpum2Switch",0)
		end
	},                     
	[8] = {["lefttext"] = "CAPT: ANTI SKID -- CHECK ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Hyd/GearAntiSkidSwitch",1)
			set("FJS/727/num/FlipPo_18",0)
		end
	}, 
	[9] = {["lefttext"] = "CAPT: STALL WARNING TEST", ["timerincr"] = 3,
		["actions"] = function ()
			set("FJS/727/Annun/StallWarningSwitch",1)
		end
	}, 
	[10] = {["lefttext"] = "CAPT: INTERNAL & EXTERNAL LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Annun/StallWarningSwitch",0)
			set("FJS/727/lights/EmerLightSwitch",0)
			set("FJS/727/num/FlipPo_23",0)
			set("FJS/727/lights/NavLightSwitch",1)
			if get("sim/private/stats/skyc/sun_amb_r") == 0 then
				set("FJS/727/lights/LogoLightSwitch",1)
				set("FJS/727/lights/WingLightSwitch",1)
			end
		end
	},                                                  
	[11] = {["lefttext"] = "CAPT: YAW DUMPERS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/num/FlipPo_25",0)
			set("FJS/727/num/FlipPo_24",0)
		end
	},                                                  
	[12] = {["lefttext"] = "CAPT: PASSENGER SIGNS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/lights/NoSmokingSwitch",1)
			set("FJS/727/lights/FastenBeltsSwitch",1)
		end
	},                                                  
	[13] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/bleed/WindowHeatL1Switch",1)
			set("FJS/727/bleed/WindowHeatL2Switch",1)
			set("FJS/727/bleed/WindowHeatR1Switch",1)
			set("FJS/727/bleed/WindowHeatR2Switch",1)
		end
	},                                                  
	[14] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/autopilot/airspeed",zc_acf_getV2())
			set("sim/cockpit/autopilot/heading_mag",get_zc_brief_gen("glarehdg"))
			set("sim/cockpit/radios/nav1_obs_degm",get_zc_brief_gen("glarecrs1"))
			set("sim/cockpit/radios/nav2_obs_degm2",get_zc_brief_gen("glarecrs2"))
		end
	}, 
	[15] = {["lefttext"] = "CAPT: SET INITIAL ALTITUDE", ["timerincr"] = 3,
		["actions"] = function ()
			set("sim/cockpit/autopilot/altitude",get_zc_brief_gen("glarealt"))
		end
	}, 
	[16] = {["lefttext"] = "FO: TRANSPONDER CONTROL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/radios/transponder_code", 2000)
			set("FJS/727/wx/WX_MapRange",0)
			set("FJS/727/Annun/GPWS_SysTestButton",1)
			set("FJS/727/Radios/Transponder_ModeKnob",0)
		end
	}, 
	[17] = {["lefttext"] = "CAPT: SET STAB TRIM ", ["timerincr"] = 5,
		["actions"] = function ()
			command_once("sim/flight_controls/pitch_trim_takeoff")
		end
	}, 
	[18] = {["lefttext"] = "ENG: GALLEY POWER & PACKS OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/Elec/GalleyPow13",0)
			set("FJS/727/Elec/GalleyPow24",0)
			set("FJS/727/bleed/PACK_LSwitch",0)
			set("FJS/727/bleed/PACK_RSwitch",0)
		end
	}, 
	[19] = {["lefttext"] = "FO: AIR CONDITIONING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("FJS/727/fuel/tank1HeatSwitch",0)
			set("FJS/727/fuel/tank2HeatSwitch",0)
			set("FJS/727/fuel/tank3HeatSwitch",0)
			set("FJS/727/fuel/fuelXfeedKnob1",0)
			set("FJS/727/fuel/fuelXfeedKnob2",1)
			set("FJS/727/fuel/fuelXfeedKnob3",0)
		end
	}, 
	[20] = {["lefttext"] = "CAPT: RUDDER & AILERON TRIM SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit2/controls/rudder_trim",0)
			set("sim/cockpit2/controls/aileron_trim",0)
		end
	},
	[21] = {["lefttext"] = "PREFLIGHT PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PREFLIGHT PROCEDURE FINISHED"
			speakNoText(0,"READY FOR BEFORE START CHECKLIST")
		end
	}
}

-- CLEARED FOR START CHECKLIST
-- COCKPIT PREPARATION PROCEDURES	.. COMPLETE 
-- ANTI-SKID						.. ON 
-- STALL WARNING					.. CHECKED 
-- EMERGENCY EXIT LIGHTS			.. ARMED 
-- PASSENGER SIGNS(IF APPLICABLE)	.. ON
-- WINDOW HEAT						.. ON
-- ANTI-ICE							.. CLOSED
-- FLIGHT INSTRUMENTS				.. SET AND X CHECKED
-- ALTIMETERS						.. SET AND X CHECKED
-- FLIGHT DIRECTORS					.. SET AND X CHECKED
-- COMPASSES						.. SYNC AND X CHECKED
-- RADIOS, RADAR, TRANSPONDER		.. SET AND STANDBY
-- START LEVERS						.. CUTOFF
-- PARKING BRAKES					.. SET
-- RUDDER AND AILERON TRIM			.. FREE AND ZERO 
-- FUEL								.. ___ KGS, SET FOR START 
-- HYDRAULICS						.. INTER CLOSED, PRESS AND QTY NORMAL 
-- PAPERS							.. ON BOARD

ZC_PREL_FLIGHT_COMP_CHECKLIST = {
	[0] = {["lefttext"] = "CLEARED FOR START CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"CLEARED FOR START CHECKLIST")
			setchecklist(1)
		end
	},
	[1] = {["lefttext"] = "COCKPIT PREPARATION PROCEDURES -- COMPLETE", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"COCKPIT PREPARATION PROCEDURES")
		end
	},
	[2] = {["lefttext"] = "COCKPIT PREPARATION PROCEDURES -- COMPLETE", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"COMPLETE")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "ANTI-SKID -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("easy") then
				set("FJS/727/Hyd/GearAntiSkidSwitch",1)
				set("FJS/727/num/FlipPo_18",0)
			end
			speakNoText(0,"ANTI-SKID")
		end
	},
	[4] = {["lefttext"] = "ANTI-SKID -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "STALL WARNING -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"STALL WARNING")
		end
	},
	[6] = {["lefttext"] = "STALL WARNING -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- ARMED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"EMERGENCY EXIT LIGHTS")
		end
	},
	[8] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- ARMED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ARMED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "PASSENGER SIGNS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("easy") then
				set("FJS/727/lights/NoSmokingSwitch",1)
				set("FJS/727/lights/FastenBeltsSwitch",1)
			end
			speakNoText(0,"PASSENGER SIGNS")
		end
	},
	[10] = {["lefttext"] = "PASSENGER SIGNS -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("easy") then
				set("FJS/727/bleed/WindowHeatL1Switch",1)
				set("FJS/727/bleed/WindowHeatL2Switch",1)
				set("FJS/727/bleed/WindowHeatR1Switch",1)
				set("FJS/727/bleed/WindowHeatR2Switch",1)
			end
			speakNoText(0,"WINDOW HEAT")
		end
	},
	[12] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "ANTI-ICE -- CLOSED", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("easy") then
				set("FJS/727/bleed/WingAntiIceSwitchL",0)
				set("FJS/727/bleed/WingAntiIceSwitchR",0)
				set("FJS/727/bleed/EngAntiIceValveKnob",0)
				set("FJS/727/bleed/Eng1inletSwitch",0)
				set("FJS/727/bleed/Eng2inletSwitch",0)
				set("FJS/727/bleed/Eng3inletSwitch",0)
			end
			speakNoText(0,"ANTI ICE")
		end
	},
	[14] = {["lefttext"] = "ANTI-ICE -- CLOSED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CLOSED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[15] = {["lefttext"] = "FLIGHT INSTRUMENTS -- SET AND X CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLIGHT INSTRUMENTS")
		end
	},
	[16] = {["lefttext"] = "FLIGHT INSTRUMENTS -- SET AND X CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET AND CROSS CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[17] = {["lefttext"] = "ALTIMETERS -- SET AND CROSS CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ALTIMETERS")
		end
	},
	[18] = {["lefttext"] = "ALTIMETERS -- SET AND CROSS CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET AND CROSS CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[19] = {["lefttext"] = "FLIGHT DIRECTORS -- SET AND CROSS CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLIGHT DIRECTORS")
		end
	},
	[20] = {["lefttext"] = "FLIGHT DIRECTORS -- SET AND CROSS CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET AND CROSS CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[21] = {["lefttext"] = "COMPASSES -- SYNC AND X CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"COMPASSES")
		end
	},
	[22] = {["lefttext"] = "COMPASSES -- SYNC AND X CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SYNC AND X CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[23] = {["lefttext"] = "RADIOS, RADAR, TRANSPONDER -- SET AND STANDBY", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"RADIOS, RADAR, TRANSPONDER")
		end
	},
	[24] = {["lefttext"] = "RADIOS, RADAR, TRANSPONDER -- SET AND STANDBY", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET AND STANDBY")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[25] = {["lefttext"] = "START LEVERS -- CUTOFF", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"START LEVERS")
			if get_zc_config("easy") then
				set("FJS/727/fuel/FuelMixtureLever3",0)
				set("FJS/727/fuel/FuelMixtureLever2",0)
				set("FJS/727/fuel/FuelMixtureLever1",0)
			end
		end
	},
	[26] = {["lefttext"] = "START LEVERS -- CUTOFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CUTOFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[25] = {["lefttext"] = "PARKING BRAKES -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PARKING BRAKES")
			if get_zc_config("easy") then
				if get("sim/cockpit2/controls/parking_brake_ratio", 0) then
					command_once("sim/flight_controls/brakes_toggle_max")
				end
			end
		end
	},
	[26] = {["lefttext"] = "PARKING BRAKES -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[27] = {["lefttext"] = "RUDDER AND AILERON TRIM -- FREE AND ZERO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"RUDDER AND AILERON TRIM")
			if get_zc_config("easy") then
				set("sim/cockpit2/controls/rudder_trim",0)
				set("sim/cockpit2/controls/aileron_trim",0)
			end
		end
	},
	[28] = {["lefttext"] = "RUDDER AND AILERON TRIM -- FREE AND ZERO", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FREE AND ZERO")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[29] = {["lefttext"] = "FUEL -- ___ KGS, SET FOR START", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FUEL")
		end
	},
	[30] = {["lefttext"] = "FUEL -- ___ KGS, SET FOR START", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[31] = {["lefttext"] = "HYDRAULICS -- INTER CLOSED, PRESS AND QTY NORMAL", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"HYDRAULICS")
		end
	},
	[32] = {["lefttext"] = "HYDRAULICS -- INTER CLOSED, PRESS AND QTY NORMAL", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[33] = {["lefttext"] = "PAPERS -- ON BOARD", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PAPERS")
		end
	},
	[34] = {["lefttext"] = "PAPERS -- ON BOARD", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON BOARD")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[35] = {["lefttext"] = "PRELIMINARY FLIGHT COMPARTMENT CHECKLIST", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"PRELIMINARY FLIGHT COMPARTMENT CHECKLIST COMPLETED")
		end
	},
	[36] = {["lefttext"] = "PRELIMINARY FLIGHT COMPARTMENT CHECKLIST", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PRELIMINARY FLIGHT COMPARTMENT CHECKLIST"
		end
	}
}

-- BEFORE START
-- OXYGEN & INTERPHONE		 . . . . . 	CHECKED
-- FUEL						 . . . . . 	_____KGS & PUMPS ON
-- SEAT BELTS			 	 . . . . . 	ON
-- WINDOW HEAT				 . . . . . 	ON
-- HYDRAULICS				 . . . . . 	NORMAL
-- AIR COND & PRESS			 . . . . .	___ PACK(S), BLEEDS ON, SET
-- INSTRUMENTS				 . . . . .	X-CHECKED
-- SPEED BRAKE				 . . . . .	DOWN DETENT
-- PARKING BRAKE			 . . . . .	SET
-- RADIOS, RADAR, TRANSPONDER  . . . .	SET
-- N1 & IAS BUGS			 . . . . .	SET

ZC_BEFORE_START_CHECKLIST = {
	[0] = {["lefttext"] = "BEFORE START CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE START CHECKLIST")
			setchecklist(2)
		end
	},
	[1] = {["lefttext"] = "FUEL -- ___ KGS/LBS PUMPS ON", ["timerincr"] = 1,
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
	[2] = {["lefttext"] = "FUEL -- ____ KGS/LBS PUMPS ON", ["timerincr"] = 999,
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
	[3] = {["lefttext"] = "SEAT BELTS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SEAT BELTS")
			if get_zc_config("easy") then
				set("FJS/732/lights/FastenBeltsSwitch",2)
			end
		end
	},
	[4] = {["lefttext"] = "SEAT BELTS -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "HYDRAULICS -- NORMAL", ["timerincr"] = 2,
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
	[6] = {["lefttext"] = "HYDRAULICS -- NORMAL", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"NORMAL")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "AIR COND & PRESS -- PACK(S) SET, BLEEDS ON, SET", ["timerincr"] = 2,
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
	[8] = {["lefttext"] = "AIR COND & PRESS -- PACK(S) SET, BLEEDS ON, SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "INSTRUMENTS -- X-CHECKED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"INSTRUMENTS")
		end
	},
	[10] = {["lefttext"] = "INSTRUMENTS -- X-CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CROSS CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "AUTOBRAKE -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AUTO BRAKE")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/AutoBrakeKnob",0)
			end
		end
	},
	[12] = {["lefttext"] = "AUTOBRAKE -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "SPEEDBRAKE -- DOWN DETENT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SPEED BRAKE")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/SpeedBreakHandleMo",0)
			end
		end
	},
	[14] = {["lefttext"] = "SPEEDBRAKE -- DOWN DETENT", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"DOWN DETENT")
			command_once("bgood/xchecklist/check_item")
		end
	},	
	[15] = {["lefttext"] = "RADIOS, RADAR, TRANSPONDER -- SET", ["timerincr"] = 2,
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
	[16] = {["lefttext"] = "RADIOS, RADAR, TRANSPONDER -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[17] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PARKING BRAKE")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/ParkBrakeHandle",1)
			end
		end
	},
	[18] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[19] = {["lefttext"] = "OXYGEN & INTERPHONE -- CHECKED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"OXYGEN AND INTERPHONE")
		end
	},
	[20] = {["lefttext"] = "OXYGEN & INTERPHONE -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[21] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 2,
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
	[22] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[23] = {["lefttext"] = "N1 & IAS BUGS -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"N 1 and I A S BUGS")
		end
	},
	[24] = {["lefttext"] = "N1 & IAS BUGS -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"set")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[25] = {["lefttext"] = "BEFORE START CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE START CHECKLIST COMPLETED")
		end
	},
	[26] = {["lefttext"] = "BEFORE START CHECKLIST COMPLETED", ["timerincr"] = -1,
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
			speakNoText(0,"We will use Flaps "..B732:getDEP_Flaps()[get_zc_brief_dep("toflaps")].." for takeoff")
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
	[3] = {["lefttext"] = "START PRESSURE -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"START PRESSURE")
		end
	},
	[4] = {["lefttext"] = "START PRESSURE -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "ANTICOLLISION LIGHT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ANTICOLLISION LIGHT")
			if get_zc_config("easy") then
				set("FJS/732/lights/AntiColLightSwitch",1)
			end
		end
	},
	[6] = {["lefttext"] = "ANTICOLLISION LIGHT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ON")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[7] = {["lefttext"] = "DOORS -- CLOSED", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"DOORS")
		if get_zc_config("easy") then
				set("FJS/732/cabin/CockpitDoorTrig",0)
			end
		end
	},
	[8] = {["lefttext"] = "DOORS -- CLOSED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"CLOSED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[9] = {["lefttext"] = "AIR CONDITIONING PACKS -- OFF", ["timerincr"] = 3,
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
	[10] = {["lefttext"] = "AIR CONDITIONING PACKS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"OFF")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[11] = {["lefttext"] = "CLEARED FOR START CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CLEARED FOR START CHECKLIST COMPLETED")	
		end
	},
	[12] = {["lefttext"] = "CLEARED FOR START CHECKLIST COMPLETED", ["timerincr"] = -1,
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
			set("sim/cockpit2/controls/flap_ratio",B732:getDEP_Flaps_val()[get_zc_brief_dep("toflaps")])
			set("sim/cockpit/radios/transponder_code",get_zc_brief_gen("squawk"))
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
-- ELECTRICAL GENERATORS. . . . . .	ON
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
			local flaps = B732:getDEP_Flaps()[math.floor(get("sim/flightmodel/controls/flaprqst")/0.125)+1]
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
	[3] = {["lefttext"] = "PACKS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PACKS")
			if get_zc_config("easy") then
				set("FJS/732/Pneumatic/LPackSwitch",1)
				set("FJS/732/Pneumatic/RPackSwitch",1)
			end
		end
	},
	[4] = {["lefttext"] = "PACKS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ON")
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
			if get_zc_config("easy") and zc_get_dest_runway_alt() > 0 then
				set("FJS/732/Pneumatic/LandingAltSelector1000",math.floor(zc_get_dest_runway_alt()/1000))
				set("FJS/732/Pneumatic/LandingAltSelector10",math.floor((zc_get_dest_runway_alt()-get("FJS/732/Pneumatic/LandingAltSelector1000")*1000)/10))
			end
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
	[11] = {["lefttext"] = "AUTOBRAKE -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AUTO BRAKE")
			if get_zc_config("easy") then
				set("FJS/732/FltControls/AutoBrakeKnob",get_zc_brief_app("autobrake"))
			end
		end
	},
	[12] = {["lefttext"] = "AUTOBRAKE -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"SET TO " .. GENERAL_Acf:getAutobrake()[get_zc_brief_app("autobrake")])
			gLeftText = "AUTOBRAKE -- SET TO " .. GENERAL_Acf:getAutobrake()[get_zc_brief_app("autobrake")]
			command_once("bgood/xchecklist/check_item")
		end
	},
	[13] = {["lefttext"] = "APPROACH BRIEFING -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"APPROACH BRIEFING")
		end
	},
	[14] = {["lefttext"] = "APPROACH BRIEFING -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"COMPLETED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[15] = {["lefttext"] = "DESCENT APPROACH CHECKLIST COMPLETED", ["timerincr"] = -1,
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
			-- set("",1)
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
			local flaps = B732:getDEP_Flaps()[math.floor((get("sim/flightmodel/controls/flaprqst")-0.625)/0.125)+1]
			speakNoText(0,string.format("FLAPS %i GREEN LIGHT",flaps))
			gLeftText = string.format("FLAPS %i GREEN LIGHT",flaps)
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
			set("FJS/732/lights/TaxiLightSwitch",0)
		end
	},
	[2] = {["lefttext"] = "FO: READY FOR SHUTDOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"READY FOR SHUTDOWN")
		end
	},
	[3] = {["lefttext"] = "CAPT: SHUTDOWN ENGINES!", ["timerincr"] = 997,
		["actions"] = function ()
			set("FJS/732/fuel/FuelMixtureLever1",0)
			set("FJS/732/fuel/FuelMixtureLever2",0)
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
			set("FJS/732/Fuel/FuelPumpL1Switch",0)
			set("FJS/732/Fuel/FuelPumpL2Switch",1)
			set("FJS/732/Fuel/FuelPumpR1Switch",0)
			set("FJS/732/Fuel/FuelPumpR2Switch",0)
		end
	}, 
	[7] = {["lefttext"] = "FO: WING & ENGINE ANTI-ICE -- OFF", ["timerincr"] = 2,
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
			set("FJS/732/Pneumatic/APUBleedSwitch",1)
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
			setchecklist(9)
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
			setchecklist(10)
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
			if get("FJS/727/Elec/APU_EGTNeelde") > 500 then
				set("FJS/727/Elec/APU_GenSwitch",1)
				set("FJS/727/Elec/APU_FieldSwitch",0)
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 0
				ZC_BACKGROUND_PROCS["APUGEN0"].status = 1 -- generator switches up
			end
		end
	},
	-- The FJS B732 needs to get the Generator switches brought back up
	["APUGEN0"] = {["status"] = 0,
		["actions"] = function ()
			if get("FJS/727/Elec/APU_GenSwitch") == 1 then
				set("FJS/727/Elec/APU_GenSwitch",0)
				set("FJS/727/bleed/Eng2BleedSwitchR",1)
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
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < get_zc_brief_app("translvl") then
				speakNoText(0,"Transition level")
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
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < 10000.0 then
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
lNoProcs = 27
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
		lActiveProc = ZC_PREL_FLIGHT_COMP_CHECKLIST
		lNameActiveProc = incnt.." BEFORE START CHECKLIST"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_DEPARTURE_BRIEFING
		lNameActiveProc = incnt.." DEPARTURE BRIEFING - OPTIONAL"
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_START_CHECKLIST
		lNameActiveProc = incnt.." CLEARED FOR ENGINE START CHECKLIST"
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
	return (get("FJS/727/Vcard/SpeedBug1Drag")-60)/30*20+90
end

-- Determine Vr (V1 + 1 in 722s speed card)
function zc_acf_getVr()
	return zc_acf_getV1()
end

-- Determine V2 (in 722 always around V1+7)
function zc_acf_getV2()
	return zc_acf_getVr()+12
end

-- Get T/O trim (722: click on the trim scale green and that is taken)
function zc_acf_getTrim()
	local trimwheel = get("sim/aircraft/controls/acf_takeoff_trim") + 1.0
	return trimwheel / 0.11770212
end

-- Set T/O trim on trim wheel
function zc_acf_setTOTrim()
	set("sim/cockpit2/controls/elevator_trim",get("sim/aircraft/controls/acf_takeoff_trim"))
end

-- Return T/O Flap (722: no value to read, usually 2)
function zc_acf_getToFlap()
	return get_zc_brief_dep("toflaps")
end

-- Return Landing Flap (722: usually 30, no value to read from)
function zc_acf_getLdgFlap()
	return get_zc_brief_app("ldgflaps")
end

-- Return parking stand (732: no value to read)
function zc_get_parking_stand()
	return "-----"
end

-- Determine Vref (722: from Speedbug after speed card set bugs)
function zc_acf_getVref()
	return (get("FJS/727/Vcard/SpeedBug1Drag")-60)/30*20+90
end

-- Determine Vapp (722: Vref + 10), no value to read)
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

-- Return T/O rwy crs (722: n.a.)
function zc_acf_getrwycrs()
	return get_zc_config("aphdg")
end

-- Return selected runway from FMC (722: n.a.)
function zc_acf_getilsrwy()
	return "---" 
end

-- Get destination ICAO code (722: need to run this twice as it is only available 2nd time)
function zc_get_dest_icao()
	command_once("sim/FMS/fpln")
	local dest = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2")
	return string.sub(dest,21,24)
end

-- Return destination rwy altitude (722: n.a.)
function zc_get_dest_runway_alt()
	return get("sim/cockpit2/autopilot/altitude_readout_preselector")
end

-- Return destination rwy course (722: n.a.)
function zc_get_dest_runway_crs()
	return get_zc_config("aphdg")
end

-- Return destination rwy length (722: n.a.)
function zc_get_dest_runway_len()
	return 0
end

-- Return FMS route (722: n.a.)
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
	set("FJS/727/Inst/StbyBaroKnob",get("FJS/727/Inst/StbyBaroKnob") + 1)
	set("sim/cockpit/misc/barometer_setting",get("FJS/732/Inst/StbyBaroKnob")/100)
	set("sim/cockpit/misc/barometer_setting2",get("FJS/732/Inst/StbyBaroKnob")/100)
end

function all_baro_dn()
	set("FJS/727/Inst/StbyBaroKnob",get("FJS/727/Inst/StbyBaroKnob") - 1)
	set("sim/cockpit/misc/barometer_setting",get("FJS/732/Inst/StbyBaroKnob")/100)
	set("sim/cockpit/misc/barometer_setting2",get("FJS/732/Inst/StbyBaroKnob")/100)
end

function all_baro_std()
	set("FJS/727/Inst/StbyBaroKnob",2992)
	set("sim/cockpit/misc/barometer_setting",29.92)
	set("sim/cockpit/misc/barometer_setting2",29.92)
end

-- Aircraft specific Joystick functions
function xsp_beaconlights_off()
	set("FJS/727/lights/BeaconLightSwitch",0)
end
function xsp_beaconlights_on()
	set("FJS/727/lights/BeaconLightSwitch",1)
end
function xsp_domelight_on()
	set("FJS/727/lights/DomeLightSwitch",1)
end
function xsp_domelight_off()
	set("FJS/727/lights/DomeLightSwitch",0)
end
function xsp_navlight_on()
	set("FJS/727/lights/NavLightSwitch",1)
end
function xsp_navlight_off()
	set("FJS/727/lights/NavLightSwitch",0)
end
function xsp_strobelight_on()
	set("FJS/727/lights/StrobeLightSwitch",1)
end
function xsp_strobelight_off()
	set("FJS/727/lights/StrobeLightSwitch",0)
end
function xsp_taxilights_off()
	set("FJS/727/lights/TaxiLightSwitch",0)
end
function xsp_taxilights_on()
	set("FJS/727/lights/TaxiLightSwitch",1)
end
function xsp_landinglights_off()
	set("FJS/727/lights/InboundLLSwitch_L",0)
	set("FJS/727/lights/InboundLLSwitch_R",0)
	set("FJS/727/lights/OutboundLLSwitch_L",0)
	set("FJS/727/lights/OutboundLLSwitch_R",0)
end
function xsp_landinglights_on()
	set("FJS/727/lights/InboundLLSwitch_L",1)
	set("FJS/727/lights/InboundLLSwitch_R",1)
	set("FJS/727/lights/OutboundLLSwitch_L",1)
	set("FJS/727/lights/OutboundLLSwitch_R",1)
end
function xsp_winglights_off()
	set("FJS/727/lights/WingLightSwitch",0)
end
function xsp_winglights_on()
	set("FJS/727/lights/WingLightSwitch",1)
end
function xsp_logolights_off()
	set("FJS/727/lights/LogoLightSwitch",0)
end
function xsp_logolights_on()
	set("FJS/727/lights/LogoLightSwitch",1)
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


-- Autothrottle logic for FJS 732 adapted from olejorga's otto_throttle
dataref("speed", "sim/flightmodel/position/indicated_airspeed", "readonly")
dataref("target_speed", "sim/cockpit2/autopilot/airspeed_dial_kts_mach", "readonly")
dataref("throttle_setting", "sim/cockpit2/engine/actuators/throttle_ratio_all", "writable")
dataref("sim_rate", "sim/time/sim_speed", "readonly")

local last_speed = speed

function fjs_athr_on()
	otto_throttle_on = true
	speakNoText(0,"Otto Throttle engaged")
end
function fjs_athr_off()
	otto_throttle_on = false
	speakNoText(0,"Otto Throttle disengaged")
end
function fjs_athr_tgl()
	if otto_throttle_on then
		otto_throttle_on = false
		speakNoText(0,"Otto Throttle disengaged")
	else
		otto_throttle_on = true
		speakNoText(0,"Otto Throttle engaged")
	end
end

function fjs_adjust_thrust()
	-- Adjusts the throttle setting either up or down, 
	-- based on the current speed & the target speed.

	-- Increases the throttle setting by
	-- a factor of x on every call
	function fjs_increase_thrust(factor)
	-- Makes sure throttle is not set above the highest setting
		if (throttle_setting + factor) == 1 then
			throttle_setting = 1
		elseif throttle_setting < 1 then
			throttle_setting = throttle_setting + factor
		end
	end

    -- Decreases the throttle setting by
    -- a factor of x on every call
	function fjs_decrease_thrust(factor)
		-- Makes sure throttle is not set below the lowest setting
		if (throttle_setting - factor) == 1 then
			throttle_setting = 0
		elseif throttle_setting > 0 then
			throttle_setting = throttle_setting - factor
		end
	end

	-- If "otto-throttle" is enabled & the sim is not paused, do this
	if otto_throttle_on == true and sim_rate ~= 0 then
		-- Calculate the diff between current & target speed
		local difference = math.abs((speed - target_speed))

		-- If the speed is lower than the target and last speed, increase
		if speed < target_speed and speed < last_speed then
			-- If diff is less than 5 increase gently, if not, fast
			if difference < 5 then
				fjs_increase_thrust(0.0001)
			else
				fjs_increase_thrust(0.001)
			end
		end

		-- If the speed is higher than the target and last speed, decrease
		if speed > target_speed and speed > last_speed then
			-- If diff is less than 5 decrease gently, if not, fast
			if difference < 5 then
				fjs_decrease_thrust(0.0001)
			else
				fjs_decrease_thrust(0.001)
			end
		end

		-- Updates the last recorded speed
		last_speed = speed
	end
end

-- aircraft specific joystick/key commands
create_command("kp/xsp/beacon_lights_switch_on",	"B722 Beacon Lights On",	"xsp_beaconlights_on()", "", "")
create_command("kp/xsp/beacon_lights_switch_off",	"B722 Beacon Lights Off",	"xsp_beaconlights_off()", "", "")
create_command("kp/xsp/dome_lights_switch_on",		"B722 Dome Lights On",		"xsp_domelight_on()", "", "")
create_command("kp/xsp/dome_lights_switch_off",		"B722 Dome Lights Off",		"xsp_domelight_off()", "", "")
create_command("kp/xsp/nav_lights_switch_on",		"B722 Position Lights On",	"xsp_navlight_on()", "", "")
create_command("kp/xsp/nav_lights_switch_off",		"B722 Position Lights Off",	"xsp_navlight_off()", "", "")
create_command("kp/xsp/strobe_lights_switch_on",	"B722 Strobe Lights On",	"xsp_strobelight_on()", "", "")
create_command("kp/xsp/strobe_lights_switch_off",	"B722 Strobe Lights Off",	"xsp_strobelight_off()", "", "")
create_command("kp/xsp/taxi_lights_switch_on",		"B722 Taxi Lights On",		"xsp_taxilights_on()", "", "")
create_command("kp/xsp/taxi_lights_switch_off",		"B722 Taxi Lights Off",		"xsp_taxilights_off()", "", "")
create_command("kp/xsp/landing_lights_switch_on",	"B722 Landing Lights On",	"xsp_landinglights_on()", "", "")
create_command("kp/xsp/landing_lights_switch_off",	"B722 Landing Lights Off",	"xsp_landinglights_off()", "", "")
create_command("kp/xsp/wing_lights_switch_on",		"B722 Wing Lights On",		"xsp_winglights_on()", "", "")
create_command("kp/xsp/wing_lights_switch_off",		"B722 Wing Lights Off",		"xsp_winglights_off()", "", "")
create_command("kp/xsp/logo_lights_switch_on",		"B722 Logo Lights On",		"xsp_logolights_on()", "", "")
create_command("kp/xsp/logo_lights_switch_off",		"B722 Logo Lights Off",		"xsp_logolights_off()", "", "")
create_command("kp/xsp/toggle_both_fd",				"B722 Toggle Both FD",		"xsp_toggle_fd_both()", "", "")
create_command("kp/xsp/toggle_both_std",			"B722 Toggle Both STD",		"xsp_toggle_std_both()", "", "")

create_command("kp/fjs732/all_baro_up", 			"FJS all baro up", 			"all_baro_up()", "", "")
create_command("kp/fjs732/all_baro_dn", 			"FJS all baro down", 		"all_baro_dn()", "", "")
create_command("kp/fjs732/all_baro_std", 			"FJS all baro STD", 		"all_baro_std()", "", "")

create_command("kp/xsp/otto_thrust_on", 			"KP Auto Thrust On", 		"fjs_athr_on()", "", "")
create_command("kp/xsp/otto_thrust_off", 			"KP Auto Thrust Off", 		"fjs_athr_off()", "", "")
create_command("kp/xsp/otto_thrust_tgl", 			"KP Auto Thrust Toggle", 	"fjs_athr_tgl()", "", "")
add_macro("Engage OTTO THROTTLE", "otto_throttle_on = true", "otto_throttle_on = false")
do_every_frame("fjs_adjust_thrust()")

do_every_draw("draw_elapsed_timer()")
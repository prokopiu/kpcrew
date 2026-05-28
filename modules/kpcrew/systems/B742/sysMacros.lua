-- B742 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B742 sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set("B742/OVHD/anti_skid_on_off_sw",0)
	set("B742/OVHD/anti_skid_on_off_cap",1)
	set("B742/OVHD/body_gear_steer_sw",0)
	set("B742/OVHD/body_gear_steer_cap",0)
	
	set("B742/OVHD/emerg_lights_cap",1)
	
	set_array("B742/FE/galley_pwr_sw",0,0)
	set_array("B742/FE/galley_pwr_sw",1,0)
	set_array("B742/FE/galley_pwr_sw",2,0)
	set_array("B742/FE/galley_pwr_sw",3,0)
	
	set_array("B742/HYD/air_pump_sw",0,0)
	set_array("B742/HYD/air_pump_sw",1,0)
	set_array("B742/HYD/air_pump_sw",2,0)
	set_array("B742/HYD/air_pump_sw",3,0)

	set_array("B742/FE/galley_chiller_sw",0,0)
	set_array("B742/FE/galley_chiller_sw",1,0)
	set_array("B742/FE/galley_chiller_sw",2,0)	
	
	set("B742/FE/galley_control_lav_fan_sw",0)
	set("B742/cockpit_light/storm_on_off",0)
	set("B742/OVHD/radio_master_bus_ESS_on",0)
	set("B742/OVHD/radio_master_bus_NO2_on",0)
	
	set("B742/controls/fuel_cut_off_pos_1",0)
	set("B742/controls/fuel_cut_off_pos_2",0)
	set("B742/controls/fuel_cut_off_pos_3",0)
	set("B742/controls/fuel_cut_off_pos_4",0)
	
	set("B742/AIR_COND/trim_air_sw",0)
	sysEFIS.wxrPilot:actuate(0)
	set("B742/ELEC/ESS_bus_sel",0)
	
	sysEngines.engStarterGroup:actuate(0)

	set_array("B742/OVHD/alt_flaps_LE_sw",0,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",1,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",2,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",3,0)	

	set("B742/OVHD/alt_flaps_TE_sw_inbd",0)
	set("B742/OVHD/alt_flaps_TE_sw_outbd",0)
	
	set("B742/OVHD/stby_ignition_sel",0)
	
	kc_macro_set_autobrake(kc_AutoBrakeOff)
	
	set_array("B742/AP_panel/pitch_rotary",0,0)
	set_array("B742/AP_panel/pitch_rotary",1,0)
	
	set("B742/FUEL/scavenge_pump_sw",0)
	
	set("B742/AIR_COND/mode_sel_rotary",1)
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set("B742/OVHD/anti_skid_on_off_sw",1)
	set("B742/OVHD/anti_skid_on_off_cap",0)
	
	set("B742/OVHD/emerg_lights_sw",1)
	set("B742/OVHD/emerg_lights_cap",0)
	
	set_array("B742/FE/galley_chiller_sw",0,1)
	set_array("B742/FE/galley_chiller_sw",1,1)
	set_array("B742/FE/galley_chiller_sw",2,1)	
	
	set("B742/FE/galley_control_lav_fan_sw",1)

	sysFuel.fuelCrossFeed:actuate(0)
	sysFuel.fuelCrossFeed1:actuate(1)
	sysFuel.fuelCrossFeed2:actuate(1)

	set("B742/OVHD/radio_master_bus_ESS_on",1)
	set("B742/OVHD/radio_master_bus_NO2_on",1)
	
	set_array("B742/HYD/air_pump_sw",0,0)
	set_array("B742/HYD/air_pump_sw",1,0)
	set_array("B742/HYD/air_pump_sw",2,0)
	set_array("B742/HYD/air_pump_sw",3,0)

	set("B742/controls/fuel_cut_off_pos_1",0)
	set("B742/controls/fuel_cut_off_pos_2",0)
	set("B742/controls/fuel_cut_off_pos_3",0)
	set("B742/controls/fuel_cut_off_pos_4",0)
	
	set("B742/AIR_COND/trim_air_sw",1)
	sysEFIS.wxrPilot:setValue(1)
	
	set("B742/FE/DC_bus_isolation_2_sw",1)
	set("B742/FE/DC_bus_isolation_3_sw",1)
	set("B742/FE/DC_bus_isolation_4_sw",1)

	set("B742/ELEC/ESS_bus_sel",1)
	
	set("B742/OVHD/body_gear_steer_sw",0)
	set("B742/OVHD/body_gear_steer_cap",1)
	
	sysEngines.engStarterGroup:actuate(0)
	
	set_array("B742/OVHD/alt_flaps_LE_sw",0,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",1,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",2,0)
	set_array("B742/OVHD/alt_flaps_LE_sw",3,0)	

	set("B742/OVHD/alt_flaps_TE_sw_inbd",0)
	set("B742/OVHD/alt_flaps_TE_sw_outbd",0)
	
	set("B742/OVHD/stby_ignition_sel",0)
	
	kc_macro_set_autobrake(kc_AutoBrakeOff)
	
	set_array("B742/AP_panel/pitch_rotary",0,0)
	set_array("B742/AP_panel/pitch_rotary",1,0)
	
	set("B742/FUEL/scavenge_pump_sw",0)
	
	set("B742/AIR_COND/mode_sel_rotary",1)

end

return sysMacros
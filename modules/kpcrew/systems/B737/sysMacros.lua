-- B737 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B737 sysMacros")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

function kc_macro_custom_cold_dark()
	if kc_is_zibo then
		if get("laminar/B738/air/l_recirc_fan_pos") ~= 0 then
			command_once("laminar/B738/toggle_switch/l_recirc_fan")
		end
		if get("laminar/B738/air/r_recirc_fan_pos") ~= 0 then
			command_once("laminar/B738/toggle_switch/r_recirc_fan")
		end
	else
		if get("laminar/B738/pressurization/l_recirc_pos") ~= 0 then
			command_once("laminar/B738/switch/Lrecirc_off")
		end
		if get("laminar/B738/pressurization/r_recirc_pos") ~= 0 then
			command_once("laminar/B738/switch/Rrecirc_off")
		end	
	end
	
	command_once("sim/electrical/battery_1_off")
	
	sysMCP.vhfNavSwitch:actuate(0)
	
	if kc_is_zibo then
		command_once("laminar/B738/toggle_switch/irs_source_left")
		command_once("laminar/B738/toggle_switch/irs_source_left")
		command_once("laminar/B738/toggle_switch/irs_source_right")
		
		command_once("laminar/B738/toggle_switch/fmc_source_left")
		command_once("laminar/B738/toggle_switch/fmc_source_left")
		command_once("laminar/B738/toggle_switch/fmc_source_right")
		
		command_once("laminar/B738/toggle_switch/dspl_source_left")
		command_once("laminar/B738/toggle_switch/dspl_source_left")
		command_once("laminar/B738/toggle_switch/dspl_source_right")

		command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
		command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
		command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
		
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	end
	
	sysElectric.cabUtilPwr:actuate(0)
	sysElectric.ifePwr:actuate(0)
	
	sysAir.contCabTemp:setValue(0.5)
	sysAir.fwdCabTemp:setValue(0.5)
	sysAir.aftCabTemp:setValue(0.5)
	
	if kc_is_zibo == false then
		command_once("laminar/B738/knob/starter1_up")
		command_once("laminar/B738/knob/starter1_up")
		command_once("laminar/B738/knob/starter1_up")
		command_once("laminar/B738/knob/starter1_dn")
		command_once("laminar/B738/knob/starter1_dn")

		command_once("laminar/B738/knob/starter2_up")
		command_once("laminar/B738/knob/starter2_up")
		command_once("laminar/B738/knob/starter2_up")
		command_once("laminar/B738/knob/starter2_dn")
		command_once("laminar/B738/knob/starter2_dn")
	end
	
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
end

function kc_macro_custom_turnaround()
	if kc_is_zibo then
		if get("laminar/B738/air/l_recirc_fan_pos") == 0 then
			command_once("laminar/B738/toggle_switch/l_recirc_fan")
		end
		if get("laminar/B738/air/r_recirc_fan_pos") == 0 then
			command_once("laminar/B738/toggle_switch/r_recirc_fan")
		end
	else
		if get("laminar/B738/pressurization/l_recirc_pos") == 0 then
			command_once("laminar/B738/switch/Lrecirc_off")
		end
		if get("laminar/B738/pressurization/r_recirc_pos") == 0 then
			command_once("laminar/B738/switch/Rrecirc_off")
		end	
	end
	
	sysMCP.vhfNavSwitch:actuate(0)
	
	if kc_is_zibo then
		command_once("laminar/B738/toggle_switch/irs_source_left")
		command_once("laminar/B738/toggle_switch/irs_source_left")
		command_once("laminar/B738/toggle_switch/irs_source_right")
		
		command_once("laminar/B738/toggle_switch/fmc_source_left")
		command_once("laminar/B738/toggle_switch/fmc_source_left")
		command_once("laminar/B738/toggle_switch/fmc_source_right")
		
		command_once("laminar/B738/toggle_switch/dspl_source_left")
		command_once("laminar/B738/toggle_switch/dspl_source_left")
		command_once("laminar/B738/toggle_switch/dspl_source_right")

		command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
		command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
		command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
		
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
	end
	
	sysElectric.cabUtilPwr:actuate(1)
	sysElectric.ifePwr:actuate(1)	
	
	sysAir.contCabTemp:setValue(0.5)
	sysAir.fwdCabTemp:setValue(0.5)
	sysAir.aftCabTemp:setValue(0.5)
	
	if kc_is_zibo == false then
		command_once("laminar/B738/knob/starter1_up")
		command_once("laminar/B738/knob/starter1_up")
		command_once("laminar/B738/knob/starter1_up")
		command_once("laminar/B738/knob/starter1_dn")
		command_once("laminar/B738/knob/starter1_dn")

		command_once("laminar/B738/knob/starter2_up")
		command_once("laminar/B738/knob/starter2_up")
		command_once("laminar/B738/knob/starter2_up")
		command_once("laminar/B738/knob/starter2_dn")
		command_once("laminar/B738/knob/starter2_dn")
	end
end

function kc_macro_set_xpdrmode(mode)
	sysRadios.xpdrSwitch:actuate(mode)
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,5)
		if trigger == "engstart1" then
			command_once("laminar/B738/engines/condition_lever_1_idle")
			command_begin("sim/starters/engage_start_run_1")
		end
		if trigger == "engstart2" then
			command_once("laminar/B738/engines/condition_lever_2_idle")
			command_begin("sim/starters/engage_start_run_2")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("sim/starters/engage_start_run_1")
			end
			if trigger == "engstart2" then
				command_end("sim/starters/engage_start_run_2")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- IRS off 0=OFF, 1=ALIGN, 2=NAV, 3=ATT
function kc_macro_set_irs(mode)
	command_once("laminar/B738/toggle_switch/irs_L_left")
	command_once("laminar/B738/toggle_switch/irs_L_left")
	command_once("laminar/B738/toggle_switch/irs_L_left")
	command_once("laminar/B738/toggle_switch/irs_R_left")
	command_once("laminar/B738/toggle_switch/irs_R_left")
	command_once("laminar/B738/toggle_switch/irs_R_left")
	if mode == 0 then -- off
	elseif mode == 1 then -- ALIGN
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
	elseif mode == 2 then -- NAV 
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
	elseif mode == 3 then -- ATT 
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_L_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
		command_once("laminar/B738/toggle_switch/irs_R_right")
	end
end

-- APU start background
if kc_is_zibo then
	function kc_bck_apustart(trigger)
		local delayvar = trigger .. "delay"
		if kc_procvar_exists(delayvar) == false then
			kc_procvar_initialize_count(delayvar,-1)
		end
		if kc_procvar_get(delayvar) == -1 then
			kc_procvar_set(delayvar,20)
			sysElectric.gpuConnect:actuate(1)
			sysElectric.gpuGenBusGroup:actuate(1)
			command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
		else
			if kc_procvar_get(delayvar) <= 0 then
				command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
				kc_procvar_set(trigger,false)
				kc_procvar_set(delayvar,-1)
			else
				kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
			end
		end
	end

	-- bring apu gen & bleed online
	function kc_bck_apuonline(trigger)
		-- if get("laminar/B738/annunciator/apu_gen_off_bus") > 0 then
			command_once("laminar/B738/toggle_switch/apu_gen1_dn")
			command_once("laminar/B738/toggle_switch/apu_gen1_dn")
			command_once("laminar/B738/toggle_switch/apu_gen2_dn")
			command_once("laminar/B738/toggle_switch/apu_gen2_dn")
			-- sysElectric.apuGenBusGroup:actuate(1)
			sysAir.apuBleedSwitch:actuate(1)
			kc_procvar_set(trigger,false)
		-- end
	end
else
	function kc_bck_apustart(trigger)
		local delayvar = trigger .. "delay"
		if kc_procvar_exists(delayvar) == false then
			kc_procvar_initialize_count(delayvar,-1)
		end
		if kc_procvar_get(delayvar) == -1 then
			kc_procvar_set(delayvar,3)
			command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
		else
			if kc_procvar_get(delayvar) <= 0 then
				command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
				kc_procvar_set(trigger,false)
				kc_procvar_set(delayvar,-1)
			else
				kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
			end
		end
	end

	-- bring apu gen & bleed online
	function kc_bck_apuonline(trigger)
		if get("sim/cockpit2/electrical/APU_N1_percent") == 100 then
			sysElectric.apuGenBusGroup:actuate(1)
			sysAir.apuBleedSwitch:actuate(1)
			kc_procvar_set(trigger,false)
		end
	end
end
return sysMacros
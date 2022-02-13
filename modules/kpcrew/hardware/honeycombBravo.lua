-- Hardware specific modules - Honeycomb Bravo Throttle

xsp_bravo_mode = 1
xsp_bravo_layer = 0
xsp_fine_coarse = 1

bravo_mode_alt = 1
bravo_mode_vs = 2
bravo_mode_hdg = 3
bravo_mode_crs = 4
bravo_mode_ias = 5


-- generic up function depending on mode and layer
function xsp_bravo_knob_up()

	-- normal A/P mode
	if xsp_bravo_layer == 0 then
		if xsp_bravo_mode == 1 then
			sysMCP.altSelector:actuate(Switch.increase)
		end
		if xsp_bravo_mode == 2 then
			sysMCP.vspSelector:actuate(Switch.increase)
		end
		if xsp_bravo_mode == 3 then
			sysMCP.hdgSelector:actuate(Switch.increase)
		end
		if xsp_bravo_mode == 4 then
			sysMCP.crs1Selector:actuate(Switch.increase)
		end
		if xsp_bravo_mode == 5 then
			sysMCP.iasSelector:actuate(Switch.increase)
		end
	end
	
end

-- generic down function depending on mode and layer
function xsp_bravo_knob_dn()

	-- normal A/P mode
	if xsp_bravo_layer == 0 then
		if xsp_bravo_mode == 1 then
			sysMCP.altSelector:actuate(Switch.decrease)
		end
		if xsp_bravo_mode == 2 then
			sysMCP.vspSelector:actuate(Switch.decrease)
		end
		if xsp_bravo_mode == 3 then
			sysMCP.hdgSelector:actuate(Switch.decrease)
		end
		if xsp_bravo_mode == 4 then
			sysMCP.crs1Selector:actuate(Switch.decrease)
		end
		if xsp_bravo_mode == 5 then
			sysMCP.iasSelector:actuate(Switch.decrease)
		end
	end

end

-- Honeycomb specific functionality

-- mode rotary ALT-VS-HDG-CRS-IAS
create_command("kp/xsp/bravo/mode_alt",	"Bravo AP Mode ALT",	"xsp_bravo_mode=1", "", "")
create_command("kp/xsp/bravo/mode_vs",	"Bravo AP Mode VS",		"xsp_bravo_mode=2", "", "")
create_command("kp/xsp/bravo/mode_hdg",	"Bravo AP Mode HDG",	"xsp_bravo_mode=3", "", "")
create_command("kp/xsp/bravo/mode_crs",	"Bravo AP Mode CRS",	"xsp_bravo_mode=4", "", "")
create_command("kp/xsp/bravo/mode_ias",	"Bravo AP Mode IAS",	"xsp_bravo_mode=5", "", "")

-- DECR-INCR Rotary
create_command("kp/xsp/bravo/knob_up",	"Bravo AP Knob Up",		"xsp_bravo_knob_up()", "", "")
create_command("kp/xsp/bravo/knob_dn",	"Bravo AP Knob Down",	"xsp_bravo_knob_dn()", "", "")

-- AP MODE switches
create_command("kp/xsp/bravo/button_hdg","Bravo HDG Button","sysMCP.hdgselSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo/button_nav","Bravo NAV Button","sysMCP.vorlocSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo/button_apr","Bravo APR Button","sysMCP.approachSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo/button_rev","Bravo REV Button","sysMCP.backcourse:actuate(2)", "", "")
create_command("kp/xsp/bravo/button_alt","Bravo ALT Button","sysMCP.altholdSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo/button_vsp","Bravo VSP Button","sysMCP.vsSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo/button_ias","Bravo IAS Button","sysMCP.speedSwitch:actuate(2)", "", "")

-- larger AUTO PILOT switch
create_command("kp/xsp/bravo/button_ap", "Bravo Autopilot Button",	"sysMCP.ap1Switch:actuate(2)", "", "")

create_command("kp/xsp/bravo/toga_press", "Bravo Press Left TOGA", "sysMCP.togaPilotSwitch:actuate(modeToggle)","","")

-- prepare for other switches
create_command("kp/xsp/bravo/switch1_on","Bravo Switch 1 On","","","")
create_command("kp/xsp/bravo/switch2_on","Bravo Switch 2 On","","","")
create_command("kp/xsp/bravo/switch3_on","Bravo Switch 3 On","","","")
create_command("kp/xsp/bravo/switch4_on","Bravo Switch 4 On","","","")
create_command("kp/xsp/bravo/switch5_on","Bravo Switch 5 On","","","")
create_command("kp/xsp/bravo/switch6_on","Bravo Switch 6 On","","","")
create_command("kp/xsp/bravo/switch7_on","Bravo Switch 7 On","","","")

create_command("kp/xsp/bravo/switch1_off","Bravo Switch 1 Off","","","")
create_command("kp/xsp/bravo/switch2_off","Bravo Switch 2 Off","","","")
create_command("kp/xsp/bravo/switch3_off","Bravo Switch 3 Off","","","")
create_command("kp/xsp/bravo/switch4_off","Bravo Switch 4 Off","","","")
create_command("kp/xsp/bravo/switch5_off","Bravo Switch 5 Off","","","")
create_command("kp/xsp/bravo/switch6_off","Bravo Switch 6 Off","","","")
create_command("kp/xsp/bravo/switch7_off","Bravo Switch 7 Off","","","")

-- Honeycomb Bravo Lights

xsp_parking_brake = create_dataref_table("kp/xsp/bravo/parking_brake", "Int")
xsp_parking_brake[0] = 0

xsp_gear_light_on_n	= create_dataref_table("kp/xsp/bravo/gear_light_on_n", "Int")
xsp_gear_light_on_n[0] = 0
xsp_gear_light_on_l	= create_dataref_table("kp/xsp/bravo/gear_light_on_l", "Int")
xsp_gear_light_on_l[0] = 0
xsp_gear_light_on_r	= create_dataref_table("kp/xsp/bravo/gear_light_on_r", "Int")
xsp_gear_light_on_r[0] = 0
xsp_gear_light_trans_n = create_dataref_table("kp/xsp/bravo/gear_light_trans_n", "Int")
xsp_gear_light_trans_n[0] = 0
xsp_gear_light_trans_l = create_dataref_table("kp/xsp/bravo/gear_light_trans_l", "Int")
xsp_gear_light_trans_l[0] = 0
xsp_gear_light_trans_r = create_dataref_table("kp/xsp/bravo/gear_light_trans_r", "Int")
xsp_gear_light_trans_r[0] = 0

xsp_engine_fire = create_dataref_table("kp/xsp/bravo/engine_fire", "Int")
xsp_engine_fire[0] = 0

xsp_anc_starter = create_dataref_table("kp/xsp/bravo/anc_starter", "Int")
xsp_anc_starter[0] = 0

xsp_anc_reverse = create_dataref_table("kp/xsp/bravo/anc_reverse", "Int")
xsp_anc_reverse[0] = 0

xsp_anc_oil = create_dataref_table("kp/xsp/bravo/anc_oil", "Int")
xsp_anc_oil[0] = 0

xsp_master_caution = create_dataref_table("kp/xsp/bravo/master_caution", "Int")
xsp_master_caution[0] = 0

xsp_master_warning = create_dataref_table("kp/xsp/bravo/master_warning", "Int")
xsp_master_warning[0] = 0

xsp_doors = create_dataref_table("kp/xsp/bravo/doors", "Int")
xsp_doors[0] = 0

xsp_apu_running	= create_dataref_table("kp/xsp/bravo/apu_running", "Int")
xsp_apu_running[0] = 0

xsp_low_volts = create_dataref_table("kp/xsp/bravo/low_volts", "Int")
xsp_low_volts[0] = 0

xsp_anc_hyd = create_dataref_table("kp/xsp/bravo/anc_hyd", "Int")
xsp_anc_hyd[0] = 0

xsp_fuel_pumps = create_dataref_table("kp/xsp/bravo/anc_fuel", "Int")
xsp_fuel_pumps[0] = 0

xsp_vacuum = create_dataref_table("kp/xsp/bravo/vacuum", "Int")
xsp_vacuum[0] = 0

xsp_anc_aice = create_dataref_table("kp/xsp/bravo/anc_aice", "Int")
xsp_anc_aice[0] = 0

xsp_mcp_hdg = create_dataref_table("kp/xsp/bravo/mcp_hdg", "Int")
xsp_mcp_hdg[0] = 0

xsp_mcp_nav = create_dataref_table("kp/xsp/bravo/mcp_nav", "Int")
xsp_mcp_nav[0] = 0

xsp_mcp_app = create_dataref_table("kp/xsp/bravo/mcp_app", "Int")
xsp_mcp_app[0] = 0

xsp_mcp_ias = create_dataref_table("kp/xsp/bravo/mcp_ias", "Int")
xsp_mcp_ias[0] = 0

xsp_mcp_vsp = create_dataref_table("kp/xsp/bravo/mcp_vsp", "Int")
xsp_mcp_vsp[0] = 0

xsp_mcp_alt = create_dataref_table("kp/xsp/bravo/mcp_alt", "Int")
xsp_mcp_alt[0] = 0

xsp_mcp_ap1 = create_dataref_table("kp/xsp/bravo/mcp_ap1", "Int")
xsp_mcp_ap1[0] = 0

xsp_mcp_rev = create_dataref_table("kp/xsp/bravo/mcp_rev", "Int")
xsp_mcp_rev[0] = 0

-- background function every 1 sec to set lights/annunciators for hardware (honeycomb bravo)
function xsp_set_bravo_lights()

	-- PARKING BRAKE 0=off 1=set
	xsp_parking_brake[0] = sysGeneral.parkbrakeAnc:getStatus()

	-- GEAR LIGHTS
	xsp_gear_light_on_l[0] 		= sysGeneral.gearLeftGreenAnc:getStatus()
	xsp_gear_light_on_r[0] 		= sysGeneral.gearRightGreenAnc:getStatus()
	xsp_gear_light_on_n[0] 		= sysGeneral.gearNodeGreenAnc:getStatus()
	xsp_gear_light_trans_l[0] 	= sysGeneral.gearLeftRedAnc:getStatus()
	xsp_gear_light_trans_r[0] 	= sysGeneral.gearRightRedAnc:getStatus()
	xsp_gear_light_trans_n[0] 	= sysGeneral.gearNodeRedAnc:getStatus()

	-- STARTER annunciator
	xsp_anc_starter[0] = sysEngines.engineStarterAnc:getStatus()

	-- OIL PRESSURE annunciator
	xsp_anc_oil[0] = sysEngines.OilPressureAnc:getStatus()
	
	-- ENGINE FIRE annunciator
	xsp_engine_fire[0] = sysEngines.engineFireAnc:getStatus()
	
	-- ENGINE REVERSE on
	xsp_anc_reverse[0] = sysEngines.reverseAnc:getStatus()
	
	-- MASTER CAUTION annunciator
	xsp_master_caution[0] = sysGeneral.masterCautionAnc:getStatus()

	-- MASTER WARNING annunciator
	xsp_master_warning[0] = sysGeneral.masterWarningAnc:getStatus()

	-- DOORS annunciator
	xsp_doors[0] = sysGeneral.doorsAnc:getStatus()
	
	-- APU annunciator
	xsp_apu_running[0] = sysElectric.apuRunningAnc:getStatus()
	
	-- LOW VOLTAGE annunciator
	xsp_low_volts[0] = sysElectric.lowVoltageAnc:getStatus()
	
	-- LOW HYD PRESSURE annunciator
	xsp_anc_hyd[0] = sysHydraulic.hydraulicLowAnc:getStatus()
	
	-- LOW FUEL PRESSURE annunciator
	xsp_fuel_pumps[0] = sysFuel.fuelLowAnc:getStatus()
	
	-- VACUUM annunciator
	xsp_vacuum[0] = sysAir.vacuumAnc:getStatus()
	
	-- ANTI ICE annunciator
	xsp_anc_aice[0] = sysAice.antiiceAnc:getStatus()

	-- HDG annunciator
	xsp_mcp_hdg[0] = sysMCP.hdgAnc:getStatus()

	-- NAV annunciator
	xsp_mcp_nav[0] = sysMCP.navAnc:getStatus()

	-- APR annunciator
	xsp_mcp_app[0] = sysMCP.aprAnc:getStatus()

	-- ALT annunciator
	xsp_mcp_alt[0] = sysMCP.altAnc:getStatus()

	-- VS annunciator
	xsp_mcp_vsp[0] = sysMCP.vspAnc:getStatus()

	-- IAS annunciator
	xsp_mcp_ias[0] = sysMCP.spdAnc:getStatus()

	-- AUTO PILOT annunciator
	xsp_mcp_ap1[0] = sysMCP.apAnc:getStatus()

	-- REV annunciator
	xsp_mcp_rev[0] = sysMCP.bcAnc:getStatus()

end

do_often("xsp_set_bravo_lights()")

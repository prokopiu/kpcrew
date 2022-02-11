-- Hardware specific modules - Honeycomb Bravo Throttle
-- Anti Ice functionality

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
	
	-- MULTI mode 
	-- if xsp_bravo_layer == 1 then
		-- if xsp_bravo_mode == 1 then -- COM1 Freq
			-- if xsp_fine_coarse == 0 then
				-- command_once("sim/radios/stby_com1_coarse_up")
			-- else
				-- command_once("sim/radios/stby_com1_fine_up_833")
			-- end
		-- end
		-- if xsp_bravo_mode == 2 then -- COM2 Freq
			-- if xsp_fine_coarse == 0 then
				-- command_once("sim/radios/stby_com2_coarse_up")
			-- else
				-- command_once("sim/radios/stby_com2_fine_up_833")
			-- end
		-- end
		-- if xsp_bravo_mode == 3 then -- ALL BARO UP/DOWN
			-- kc_acf_efis_baro_up_down(0,1)
		-- end
		-- if xsp_bravo_mode == 4 then -- ND ZOOM OUT
			-- kc_acf_efis_nd_zoom(1,1)
		-- end
		-- if xsp_bravo_mode == 5 then -- ND MODE UP
			-- kc_acf_efis_nd_mode(1,1)
		-- end
	-- end
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

	-- MULTI mode 
	-- if xsp_bravo_layer == 1 then
		-- if xsp_bravo_mode == 1 then
			-- if xsp_fine_coarse == 0 then
				-- command_once("sim/radios/stby_com1_coarse_down")
			-- else
				-- command_once("sim/radios/stby_com1_fine_down_833")
			-- end
		-- end
	-- end
	-- if xsp_bravo_layer == 1 then
		-- if xsp_bravo_mode == 2 then
			-- if xsp_fine_coarse == 0 then
				-- command_once("sim/radios/stby_com2_coarse_down")
			-- else
				-- command_once("sim/radios/stby_com2_fine_down_833")
			-- end
		-- end
		-- if xsp_bravo_mode == 3 then -- ALL BARO UP/DOWN
			-- kc_acf_efis_baro_up_down(0,0)
		-- end
		-- if xsp_bravo_mode == 4 then -- ND ZOOM IN
			-- kc_acf_efis_nd_zoom(1,0)
		-- end
		-- if xsp_bravo_mode == 5 then -- ND MODE DN
			-- kc_acf_efis_nd_mode(1,0)
		-- end
	-- end
end

create_command("kp/xsp/bravo_mode_alt",	"Bravo AP Mode ALT",	"xsp_bravo_mode=1", "", "")
create_command("kp/xsp/bravo_mode_vs",	"Bravo AP Mode VS",		"xsp_bravo_mode=2", "", "")
create_command("kp/xsp/bravo_mode_hdg",	"Bravo AP Mode HDG",	"xsp_bravo_mode=3", "", "")
create_command("kp/xsp/bravo_mode_crs",	"Bravo AP Mode CRS",	"xsp_bravo_mode=4", "", "")
create_command("kp/xsp/bravo_mode_ias",	"Bravo AP Mode IAS",	"xsp_bravo_mode=5", "", "")

create_command("kp/xsp/bravo_knob_up",	"Bravo AP Knob Up",		"xsp_bravo_knob_up()", "", "")
create_command("kp/xsp/bravo_knob_dn",	"Bravo AP Knob Down",	"xsp_bravo_knob_dn()", "", "")

create_command("kp/xsp/bravo_button_hdg","Bravo HDG Button",		"sysMCP.hdgselSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_nav","Bravo NAV Button",		"sysMCP.vorlocSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_apr","Bravo APR Button",		"sysMCP.approachSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_rev","Bravo REV Button",		"sysMCP.backcourse:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_alt","Bravo ALT Button",		"sysMCP.altholdSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_vsp","Bravo VSP Button",		"sysMCP.vsSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_ias","Bravo IAS Button",		"sysMCP.speedSwitch:actuate(2)", "", "")
create_command("kp/xsp/bravo_button_ap", "Bravo Autopilot Button",	"sysMCP.ap1Switch:actuate(2)", "", "")

-- create_command("kp/xsp/bravo_layer_multi",			"Bravo Layer MULTI",	"xsp_bravo_layer=1", "", "")
-- create_command("kp/xsp/bravo_layer_ap",				"Bravo Layer A/P",		"xsp_bravo_layer=0", "", "")
-- create_command("kp/xsp/bravo_fine",					"Bravo Fine",			"xsp_fine_coarse = 1", "", "")
-- create_command("kp/xsp/bravo_coarse",				"Bravo Coarse",			"xsp_fine_coarse = 0", "", "")




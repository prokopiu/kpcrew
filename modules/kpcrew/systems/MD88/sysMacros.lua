-- MD88 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("MD88 sysMacros")

-- custom cold & dark activities
function kc_macro_custom_cold_dark()

end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()

end

-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- OFF
		set("Rotate/md80/instruments/irs_mode_switch",kc_irs_off)
		set("Rotate/md80/instruments/irs2_mode_switch",kc_irs_off)
	elseif mode == 1 then -- ALIGN
		set("Rotate/md80/instruments/irs_mode_switch",kc_irs_align)
		set("Rotate/md80/instruments/irs2_mode_switch",kc_irs_align)
	elseif mode == 2 then -- NAV 
		set("Rotate/md80/instruments/irs_mode_switch",kc_irs_nav)
		set("Rotate/md80/instruments/irs2_mode_switch",kc_irs_nav)
	end
end

-- Autobrake 
function kc_macro_set_autobrake(index)
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	command_once("laminar/B747/gear/autobrakes/sel_dial_dn")
	if mode == 0 then -- RTO
	elseif mode == 1 then -- OFF
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 2 then -- 1 
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 3 then -- 2
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 4 then -- 3
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 4 then -- 4
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	elseif mode == 4 then -- MAX
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
		command_once("laminar/B747/gear/autobrakes/sel_dial_up")
	end
end

return sysMacros
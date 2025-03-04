-- E1FF X-Crafts Freeware airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("E1FF sysMacros")

function kc_macro_mcp_takeoff()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.iasSelector:setValue(250)
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	sysMCP.hdgselSwitch:actuate(1)
	sysMCP.vspSelector:setValue(2300)
	sysMCP.vsSwitch:actuate(1)
	sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
	sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
end

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,30)
		sysElectric.apuStartSwitch:setValue(2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysElectric.apuStartSwitch:setValue(1)
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

return sysMacros
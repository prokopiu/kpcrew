-- DFLT airplane 
-- MCP functionality
local sysMCP = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local drefHDGSelLight = "sim/cockpit2/autopilot/heading_mode"
local drefVORLocLight = "sim/cockpit2/autopilot/nav_status"
local drefAPRLight = "sim/cockpit2/autopilot/approach_status"
local drefSPDLight = "sim/cockpit2/autopilot/autothrottle_on"
local drefN1Light = ""
local drefVSLight = "sim/cockpit2/autopilot/vvi_status"
local drefALTLight = "sim/cockpit2/autopilot/altitude_hold_status"
local drefAPStatusLight = "sim/cockpit2/autopilot/autopilot_on_or_cws"
local drefCMDBLight = ""
local drefLVLCHGLight = ""
local drefLNAVLight = "sim/cockpit2/radios/actuators/HSI_source_select_pilot"
local drefVNAVLight = "sim/cockpit2/autopilot/fms_vnav"
local drefBCLight = ""


-- BC light not applicable in B738
function sysMCP.getBCLight()
	return 0
end

-- HDG Light
function sysMCP.getHDGLight()
	if get(drefHDGSelLight) > 0  then
		return 1
	else
		return 0
	end
	return 
end

-- NAV light includes VORLOC and LNAV
function sysMCP.getNAVLight()
	if get(drefVORLocLight) > 0 or get(drefLNAVLight) > 0 then
		return 1
	else
		return 0
	end
end
	
-- APR light
function  sysMCP.getAPRLight()
	return get(drefAPRLight)
end

-- SPD Light includes N1 mode
function sysMCP.getSPDLight()
	if get(drefSPDLight) == 1 or get(drefN1Light) == 1 then
		return 1
	else
		return 0
	end
end

-- VS Light includes VS, LVLCHG and VNAV
function sysMCP.getVSLight()
	if get(drefVSLight) == 1 or get(drefLVLCHGLight) == 1 or get(drefVNAVLight) == 1 then
		return 1
	else
		return 0
	end
end


-- ALT light
function sysMCP.getALTLight()
	return get(drefALTLight)
end

-- AUTO PILOT light (shows CMD-A or B)
function sysMCP.getAPLight()
	if get(drefAPStatusLight) == 1 or get(drefCMDBLight) == 1 then
		return 1
	else
		return 0
	end
end

return sysMCP
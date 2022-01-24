-- DFLT airplane 
-- MCP functionality
local sysMCP = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local drefHDGSelLight = "laminar/B738/autopilot/hdg_sel_status"
local drefVORLocLight = "laminar/B738/autopilot/vorloc_status"
local drefAPRLight = "laminar/B738/autopilot/app_status"
local drefSPDLight = "laminar/B738/autopilot/speed_mode"
local drefN1Light = "laminar/B738/autopilot/n1_status"
local drefVSLight = "laminar/B738/autopilot/vs_status"
local drefALTLight = "laminar/B738/autopilot/alt_hld_status"
local drefAPStatusLight = "laminar/B738/autopilot/cmd_a_status"
local drefCMDBLight = "laminar/B738/autopilot/cmd_b_status"
local drefLVLCHGLight = "laminar/B738/autopilot/lvl_chg_status"
local drefLNAVLight = "laminar/B738/autopilot/lnav_status"
local drefVNAVLight = "laminar/B738/autopilot/vnav_status1"
local drefBCLight = ""


-- BC light not applicable in B738
function sysMCP.getBCLight()
	return 0
end

-- HDG Light
function sysMCP.getHDGLight()
	return get(drefHDGSelLight)
end

-- NAV light includes VORLOC and LNAV
function sysMCP.getNAVLight()
	if get(drefVORLocLight) == 1 or get(drefLNAVLight) == 1 then
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
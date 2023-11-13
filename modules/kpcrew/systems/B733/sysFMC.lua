-- B738 airplane 
-- FMC related functionality

-- @classmod sysFMC
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysFMC = {
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

sysFMC.initref 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_init_ref")
sysFMC.rte 					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_rte")
sysFMC.clb 					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_clb")
sysFMC.crz 					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_crz")
sysFMC.des 					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_des")
sysFMC.menu 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_menu")
sysFMC.legs 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_legs")
sysFMC.depapp 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_dep_app")
sysFMC.hold 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_hold")
sysFMC.prog 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_prog")
sysFMC.exec 				= TwoStateToggleSwitch:new("","laminar/B738/indicators/fmc_exec_lights",0,"laminar/B738/button/fmc1_exec")
sysFMC.n1lim 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_n1_lim")
sysFMC.fix 					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_fix")
sysFMC.prev 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_prev_page")
sysFMC.next 				= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_next_page")

sysFMC.ls1L					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_1L")
sysFMC.ls2L					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_2L")
sysFMC.ls3L					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_3L")
sysFMC.ls4L					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_4L")
sysFMC.ls5L					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_5L")
sysFMC.ls6L					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_6L")
sysFMC.ls1R					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_1R")
sysFMC.ls2R					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_2R")
sysFMC.ls3R					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_3R")
sysFMC.ls4R					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_4R")
sysFMC.ls5R					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_5R")
sysFMC.ls6R					= TwoStateToggleSwitch:new("","laminar/B738/fmod/fms_key",0,"laminar/B738/button/fmc1_6R")

sysFMC.fmcPageTitle 		= CustomAnnunciator:new("",
function() 
	local pgTitle = get("laminar/B738/fmc1/Line00_L")
	return string.sub(pgTitle,6,24)
end)

sysFMC.fmcRefAirportSet 	= CustomAnnunciator:new("",
function() 
	local refTitle = get("laminar/B738/fmc1/Line02_X")
	local refAirport = get("laminar/B738/fmc1/Line02_L")
	if string.find(refTitle,"REF AIRPORT") then
		if string.sub(refAirport,1,4) == "----" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcOrigin 			= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.find(title,"ORIGIN") then
		if string.sub(origin,1,4) == "----" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcDestination 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.find(title,"DEST") then
		if string.sub(origin,21,24) == "****" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcFltNo 			= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line02_X")
	local origin = get("laminar/B738/fmc1/Line02_L")
	if string.find(title,"FLT NO") then
		if string.sub(origin,17,24) == "--------" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcRouteEntered 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.sub(title,2,4) == "VIA" then
		if string.sub(origin,1,8) == "--------" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcRouteActivated 	= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line06_L")
	if string.sub(title,16,23) == "ACTIVATE" then
		return false
	else
		return true
	end
end)

sysFMC.fmcRouteExecuted 	= CustomAnnunciator:new("",
function() 
	if get("laminar/B738/indicators/fmc_exec_lights") == 1 then
		return false
	else
		return true
	end
end)

sysFMC.fmcGWEntered 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.find(title,"GW/CRZ CG") then
		if string.sub(origin,1,5) == "***.*" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcZFWEntered 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line03_X")
	local origin = get("laminar/B738/fmc1/Line03_L")
	if string.find(title,"ZFW") then
		if string.sub(origin,1,5) == "***.*" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcReservesEntered 	= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line04_X")
	local origin = get("laminar/B738/fmc1/Line04_L")
	if string.find(title,"RESERVES") then
		if string.sub(origin,1,4) == "**.*" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcCIEntered 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line05_X")
	local origin = get("laminar/B738/fmc1/Line05_L")
	if string.find(title,"COST INDEX") then
		if string.sub(origin,1,3) == "***" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcCrzAltEntered 	= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.find(title,"TRIP/CRZ ALT") then
		if string.sub(origin,20,24) == "*****" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcCGEntered 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line03_X")
	local origin = get("laminar/B738/fmc1/Line03_L")
	if string.find(title," CG") then
		if string.sub(origin,1,5) == "--.-%" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcFlapsEntered 		= CustomAnnunciator:new("",
function() 
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.find(title," FLAPS") then
		if string.sub(origin,1,2) == "**" then
			return false
		else
			return true
		end
	else
		return false
	end
end)

sysFMC.fmcVspeedsEntered 	= CustomAnnunciator:new("",
function() 
	local cnt = 0
	local title = get("laminar/B738/fmc1/Line01_X")
	local origin = get("laminar/B738/fmc1/Line01_L")
	if string.find(title," V1") then               
		if string.sub(origin,22,24) ~= "---" then
			cnt = cnt + 1
		end
	end
	title = get("laminar/B738/fmc1/Line02_X")
	origin = get("laminar/B738/fmc1/Line02_L")
	if string.find(title," VR") then
		if string.sub(origin,22,24) ~= "---" then
			cnt = cnt + 1
		end
	end
	title = get("laminar/B738/fmc1/Line03_X")
	origin = get("laminar/B738/fmc1/Line03_L")
	if string.find(title," V2") then
		if string.sub(origin,22,24) ~= "---" then
			cnt = cnt + 1
		end
	end
	if cnt == 3 then
		return true
	else
		return false
	end
end)

sysFMC.V2 = SimpleAnnunciator:new("","laminar/B738/FMS/v2",0)
sysFMC.V1 = SimpleAnnunciator:new("","laminar/B738/FMS/v1",0)
sysFMC.Vr = SimpleAnnunciator:new("","laminar/B738/FMS/vr",0)

sysFMC.noVSpeeds = SimpleAnnunciator:new("","laminar/B738/pfd/no_vspd",0)

return sysFMC
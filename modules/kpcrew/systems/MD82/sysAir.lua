-- MD82 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysAir = {
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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("MD82 sysAir")

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateCustomSwitch:new("apubleed","laminar/md82/bleedair/APU_on",0,
	function ()
		command_once("laminar/md82cmd/bleedair/APU_up")
		command_once("laminar/md82cmd/bleedair/APU_up")
		command_once("laminar/md82cmd/bleedair/APU_dwn")
	end,
	function ()
		command_once("laminar/md82cmd/bleedair/APU_up")
		command_once("laminar/md82cmd/bleedair/APU_up")
	end,
	function ()
	end,
	function ()
		return get("laminar/md82/bleedair/APU_on")
	end)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","laminar/md82/bleedair/engineL_xfeed_lever",0,
	"laminar/md82cmd/bleedair/L_xfeed_lever_toggle")
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","laminar/md82/bleedair/engineR_xfeed_lever",0, 	
	"laminar/md82cmd/bleedair/R_xfeed_lever_toggle")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
	
return sysAir



-- PACK switches
-- sysAir.packLeftSwitch 		= TwoStateCustomSwitch:new("pack1","laminar/md82/bleedair/bleedair_HVAC_L",0,
-- function ()
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
-- end,
-- function ()
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
-- end,nil,
-- function () 
	-- return get("laminar/md82/bleedair/bleedair_HVAC_L")
-- end)
-- sysAir.packRightSwitch 		= TwoStateCustomSwitch:new("pack2","laminar/md82/bleedair/bleedair_HVAC_R",0,
-- function ()
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
-- end,
-- function ()
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
	-- command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
-- end,nil,
-- function () 
	-- return get("laminar/md82/bleedair/bleedair_HVAC_R")
-- end)
-- sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
-- sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
-- sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)


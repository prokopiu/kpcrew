-- B7x7 airplane 
-- EFIS functionality

-- @classmod sysEFIS
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

sysEFIS = require("kpcrew.systems.DFLT.sysEFIS")

logMsg("B7x7 sysEFIS")

sysEFIS.wxrPilot  			= TwoStateCustomSwitch:new("wxrpilot","1-sim/WX/modeSwitcher",0,null,null,null,
	function () return get("1-sim/WX/modeSwitcher") end,null,
	function (value)
		set("1-sim/WX/modeSwitcher/anim",value)
		set("1-sim/WX/modeSwitcher",value)
	end)

-- MAP ZOOM
sysEFIS.mapZoomPilot 		= TwoStateCustomSwitch:new("mapzoompilot","1-sim/ndpanel/1/hsiRangeRotary",0,
	function ()
		local ndmod = get("1-sim/ndpanel/1/hsiRangeRotary")
		if ndmod < 6 then
			set("1-sim/ng/rangeL/anim",ndmod-4)
		end
	end,
	function ()
		local ndmod = get("1-sim/ndpanel/1/hsiRangeRotary")
		if ndmod > 0 then
			set("1-sim/ng/rangeL/anim",ndmod-2)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("1-sim/ndpanel/1/hsiRangeRotary") == 0 then
			displaystr = "5"
		elseif get("1-sim/ndpanel/1/hsiRangeRotary") == 1 then
			displaystr = "10"
		elseif get("1-sim/ndpanel/1/hsiRangeRotary") == 2 then
			displaystr = "20"
		elseif get("1-sim/ndpanel/1/hsiRangeRotary") == 3 then
			displaystr = "40"
		elseif get("1-sim/ndpanel/1/hsiRangeRotary") == 4 then
			displaystr = "80"
		elseif get("1-sim/ndpanel/1/hsiRangeRotary") == 5 then
			displaystr = "160"
		elseif get("1-sim/ndpanel/1/hsiRangeRotary") == 6 then
			displaystr = "320"
		end
		return displaystr
	end,null,
	function (value)
		set("1-sim/ng/rangeL/anim",value-3)
	end)

-- MAP MODE
sysEFIS.mapModePilot 		= TwoStateCustomSwitch:new("mapmodepilot","1-sim/ndpanel/1/hsiModeRotary",0,
	function ()
		local ndmod = get("1-sim/ndpanel/1/hsiModeRotary")
		if ndmod < 3 then
			set("1-sim/ndpanel/1/hsiModeRotary",ndmod+1)
		end
	end,
	function ()
		local ndmod = get("1-sim/ndpanel/1/hsiModeRotary")
		if ndmod > 0 then
			set("1-sim/ndpanel/1/hsiModeRotary",ndmod-1)
		end
	end,
	function ()
	end,
	function ()
		local displaystr = ""
		if get("1-sim/ndpanel/1/hsiModeRotary") == 0 then
			displaystr = "VOR"
		elseif get("1-sim/ndpanel/1/hsiModeRotary") == 1 then
			displaystr = "APP"
		elseif get("1-sim/ndpanel/1/hsiModeRotary") == 2 then
			displaystr = "MAP"
		elseif get("1-sim/ndpanel/1/hsiModeRotary") == 3 then
			displaystr = "PLN"
		end
		return displaystr
	end)

-- Baro standard toggle
sysEFIS.barostdPilot 	= TwoStateDrefSwitch:new("barostdpilot","1-sim/ng/baro/std/L",0)
sysEFIS.barostdCopilot 	= TwoStateDrefSwitch:new("barostdcopilot","1-sim/ng/baro/std/R",0)
sysEFIS.barostdGroup 	= SwitchGroup:new("barostdgroup")
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdPilot)
sysEFIS.barostdGroup:addSwitch(sysEFIS.barostdCopilot)

return sysEFIS

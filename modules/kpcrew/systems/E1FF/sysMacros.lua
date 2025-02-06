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

return sysMacros
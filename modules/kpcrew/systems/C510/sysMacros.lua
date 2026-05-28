-- TMPL airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("TMPL sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	sysAir.airCondSwitch:actuate(0)
	sysFuel.allFuelPumpGroup:actuate(0) 
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	sysAir.airCondSwitch:actuate(1)
end

return sysMacros
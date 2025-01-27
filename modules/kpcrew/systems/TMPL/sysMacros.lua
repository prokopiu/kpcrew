-- TMPL airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("TMPL sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()
	logMsg("MD82 kc_macro_state_cold_and_dark")
end

function kc_macro_state_turnaround()
	logMsg("MD82 kc_macro_state_turnaround")
end

return sysMacros
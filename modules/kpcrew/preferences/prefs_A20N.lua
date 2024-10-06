-- Aircraft specific preferences - Toliss A20N
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local A20NGroup = kcPreferenceGroup:new("aircraft","A20N AIRCRAFT PREFERENCES")
A20NGroup:add(kcPreference:new("powerup_apu",	true,	kcPreference.typeToggle,	"Initial Power-Up|APU|GPU")) 

activePrefSet:addGroup(A20NGroup)

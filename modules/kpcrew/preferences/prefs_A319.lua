-- Aircraft specific preferences - ToLiss A319
--
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local A319Group = kcPreferenceGroup:new("aircraft","A319 AIRCRAFT PREFERENCES")
A319Group:add(kcPreference:new("powerup_apu",	true,	kcPreference.typeToggle,	"Initial Power-Up|APU|GPU")) 

activePrefSet:addGroup(A319Group)

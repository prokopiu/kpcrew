-- Set of preferences 
-- The set combines one or more preference groups, each group containing one to many single preferences
-- Preferences can also be used for background variables to persist kpcrew specific states and values
--
-- @classmod PreferenceSet
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcPreferenceSet = {
}

-- Instantiate a new preference set
-- @tparam string name Name of the set (also used as title)
function kcPreferenceSet:new(name)
    kcPreferenceSet.__index = kcPreferenceSet
    local obj = {}
    setmetatable(obj, kcPreferenceSet)

    obj.name = name
	obj.preferenceGroups = {}
	obj.filename = kc_acf_icao
	
    return obj
end

-- Get name/title of preference set
-- @treturn string name of set
function kcPreferenceSet:getName()
    return self.name
end

function kcPreferenceSet:setName(name)
    self.name = name
end

function kcPreferenceSet:getFilename()
    return self.filename
end

function kcPreferenceSet:setFilename(name)
    self.filename = name
end

-- Add a preference group to the set
-- @tparam PreferenceGroup group to add
function kcPreferenceSet:addGroup(group)
    table.insert(self.preferenceGroups, group)
end

-- Return all registered groups from set
-- @treturn array PreferenceGroup
function kcPreferenceSet:getAllGroups()
	return self.preferenceGroups
end

-- Find a preference object in all groups
-- key contains the group and the key such as general:flight_state
-- @tparam string inkey Key of preference to find
-- @treturn Preference found preference or nil
function kcPreferenceSet:find(inkey)
	for _, group in ipairs(self.preferenceGroups) do
		if group ~= nil then
			local splits = kc_split(inkey,":")
			if splits[1] == group:getName() then
				local found = group:find(splits[2])
				return found
			end
		end
	end
	return nil
end

-- Get the value of a preference object
-- key contains the group and the key such as general:flight_state
-- @tparam string inkey Key of preference to find
-- @treturn object value of preference 
function kcPreferenceSet:get(inkey)
	local pref = self:find(inkey)
	if pref ~= nil then
		return pref:getValue()
	end
end

function kcPreferenceSet:set(inkey, value)
	local pref = self:find(inkey)
	if pref ~= nil then
		return pref:setValue(value)
	end
end

-- ===== UI related functionality =====
-- Get the required window height calculated on all preferences and groups
-- @treturn int height in pixel
function kcPreferenceSet:getWndHeight()
	local wndHeight = 700
	-- for _, group in ipairs(self.preferenceGroups) do
		-- wndHeight = wndHeight + group:getWndHeight()
	-- end
	return wndHeight
end

-- Get the required window width
-- @treturn int width in pixel
function kcPreferenceSet:getWndWidth()
	return 350
end

-- Get the x-position for the window
-- @treturn int position on left side of the screen
function kcPreferenceSet:getWndXPos()
	local win_width = get("sim/graphics/view/window_width")
	return win_width - self:getWndWidth() - 330
end

-- Get the y-position for the window
-- @treturn int position from top of screen
function kcPreferenceSet:getWndYPos()
	return 70
end

-- Render all preferences and groups in imgui window
function kcPreferenceSet:render()
	imgui.SetWindowFontScale(1.05)
	if self ~= nil then
		-- run through groups and preferences and 
		for _, group in ipairs(self.preferenceGroups) do
			group:render()
		end
		-- filename and load/save button
		imgui.Separator()
		local changed, textin = imgui.InputText("", self.filename, 20)
		if changed then
				self.filename = textin
		end
		imgui.SameLine()
		if imgui.Button("LOAD") then
			self:load()
		end
		imgui.SameLine()
		if imgui.Button("SAVE") then
			self:save()
		end		
		imgui.Separator()
	end
end

-- Save all preferences with group prefix to .preferences file
function kcPreferenceSet:save()
	filePrefs = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew\\preferences\\" .. self.filename .. ".preferences", "w+")
	for _, group in ipairs(self.preferenceGroups) do
		group:save(filePrefs)
	end
	filePrefs:close()
end

-- Read all preferences from file
function kcPreferenceSet:load()
	for _, group in ipairs(self.preferenceGroups) do
		filePrefs = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew\\preferences\\" .. self.filename .. ".preferences", "r")
		if filePrefs then
			group:load(filePrefs)
			filePrefs:close()
		end
	end
end	

return kcPreferenceSet
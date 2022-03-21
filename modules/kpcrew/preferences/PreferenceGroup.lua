-- Group of preferences 
-- The group combines one or more preferences thematically 
-- Preferences can also be used for background variables to persist kpcrew specific states and values
--
-- @classmod PreferenceGroup
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcPreferenceGroup = {
}

-- Instantiate a new preference group
-- @tparam string name Name of the set 
-- @tparam string title Title string to display in window
function kcPreferenceGroup:new(name,title)
    kcPreferenceGroup.__index = kcPreferenceGroup
    local obj = {}
    setmetatable(obj, kcPreferenceGroup)

    obj.name = name
	obj.title = title
	obj.preferences = {}
	obj.lineLength = 60
	obj.initialOpen = false

    return obj
end

-- Get name of preference set
-- @treturn string name of set
function kcPreferenceGroup:getName()
    return self.name
end

-- Get title of preference set
-- @treturn string title for display
function kcPreferenceGroup:getTitle()
    return self.title
end

-- set the flag to have that tree item open
function kcPreferenceGroup:setInitialOpen(flag)
	self.initialOpen = flag
end

function kcPreferenceGroup:getInitialOpen()
	return self.initialOpen
end

-- Add a preference to the group
-- @tparam Preference preference to add
function kcPreferenceGroup:add(preference)
	table.insert(self.preferences,preference)
end

-- remove preference from group
-- @tparam string key of preference to remove
function kcPreferenceGroup:remove(key)
    table.remove(self.preferences,self:getIndex(key))
end

-- Return all registered preferences from group
-- @treturn array Preference
function kcPreferenceGroup:getAllPreferences()
	return self.preferences
end

-- Find a preference object in group
-- @tparam string inkey Key of preference to find
-- @treturn Preference found preference or nil
function kcPreferenceGroup:find(inkey)
	for _, pref in ipairs(self.preferences) do
		if pref:getKey() == inkey then
			return pref
		end
	end
	return nil
end

-- Get a preference value
-- @tparam string inkey Key of preference to find
-- @treturn Preference found preference or nil
function kcPreferenceGroup:get(inkey)
	local pref = self:find(inkey)
	if pref ~= nil then
		return pref:getValue()
	end
	return nil
end

-- Get the index of a preferene in the group array
-- @tparam string inkey Key of preference to find
-- @treturn int index of pref or -1
function kcPreferenceGroup:getIndex(key)
	local cnt = 0
	for _, pref in ipairs(self.preferences) do
		if pref:getKey() == key then
			return cnt
		end
	end
	return -1
end

-- ===== UI related functionality =====
-- Get the required window height calculated on all preferences
-- @treturn int height in pixel
function kcPreferenceGroup:getWndHeight()
	local wndHeight = 50
	for _, pref in ipairs(self.preferences) do
		wndHeight = wndHeight + 40
	end
	return wndHeight
end

-- build the headline of the group
function kcPreferenceGroup:getHeadline()
	local eqsigns = self.lineLength - string.len(self.title) - 2
	local line = {}
	
	for i=0,math.floor((eqsigns / 2) + 0.5) - 1,1 do
		-- line[#line + 1] = " "
	end
	
	-- line[#line + 1] = " "
	line[#line + 1] = self.title
	-- line[#line + 1] = " "
	
	for i=0,(eqsigns / 2) - 1,1 do
		-- line[#line + 1] = " "
	end
	return table.concat(line)
end

-- Render all preferences in imgui window
function kcPreferenceGroup:render()
	if self ~= nil then
		if self.initialOpen then 
			imgui.SetNextItemOpen(true)
			self.initialOpen = false
		end
		if imgui.TreeNode(self:getHeadline()) then
			for _, pref in ipairs(self.preferences) do
				pref:render()
			end
			imgui.TreePop()
		end
	end
end

-- Save all preferences of group prefix to .preferences file
function kcPreferenceGroup:save(filePref)
	for _, pref in ipairs(self.preferences) do
		filePref:write(self.name .. ":" .. pref:getSaveLine())
	end
end	

-- Read all preferences from file
function kcPreferenceGroup:load(filePref)
   for line in filePref:lines() do
        local key = nil
        local value = nil
		local splits = kc_split(line,":")
		if splits[1] == self.name then
			local delim = string.find(splits[2], "=")
			if delim and delim > 1 and delim < string.len(line) then
				local key = string.sub(splits[2], 1, delim - 1)
				local value = string.sub(splits[2], delim + 1)
				local pref = self:find(key)
				if pref ~= nil then
					if pref:getType() == kcPreference.typeFlag or pref:getType() == kcPreference.typeToggle then
						if value == "true" then 
							pref:setValue(true)
						else
							pref:setValue(false)
						end
					else
						pref:setValue(value)
					end
				end
			end
        end
    end

end

return kcPreferenceGroup
require "kpcrew.genutils"

local PreferenceSet = {}

function PreferenceSet:new(name)

    PreferenceSet.__index = PreferenceSet

    local obj = {}
    setmetatable(obj, PreferenceSet)

    obj.name = name
	obj.preferenceGroups = {}
	obj.filename = acf_icao
	
    return obj
end

function PreferenceSet:getName()
    return self.name
end

function PreferenceSet:addGroup(group)
	-- self.preferenceGroups[group:getName()] = group
    table.insert(self.preferenceGroups, group)
end

function PreferenceSet:getAllGroups()
	return self.preferenceGroups
end

function PreferenceSet:findPreference(inkey)
	for _, group in ipairs(self.preferenceGroups) do
		if group ~= nil then
			local splits = split(inkey,":")
			if splits[1] == group:getName() then
				local found = group:findPreference(splits[2])
				return found
			end
		end
	end
	return nil
end

function PreferenceSet:getPreference(inkey)
	local pref = self:findPreference(inkey)
	if pref ~= nil then
		return pref:getValue()
	end
end

function PreferenceSet:getWndHeight()
	local wndHeight = 0
	for _, group in ipairs(self.preferenceGroups) do
		wndHeight = wndHeight + group:getWndHeight()
	end
	return wndHeight
end

function PreferenceSet:getWndWidth()
	return 350 --435
end

function PreferenceSet:getWndXPos()
	local win_width = get("sim/graphics/view/window_width")
	return win_width - self:getWndWidth() - 330
end

function PreferenceSet:getWndYPos()
	return 70
end

function PreferenceSet:render()
	if self ~= nil then
		for _, group in ipairs(self.preferenceGroups) do
			group:render()
		end
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
	end
end

function PreferenceSet:save()
	filePrefs = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew\\preferences\\" .. self.filename .. ".preferences", "w+")
	for _, group in ipairs(self.preferenceGroups) do
		group:save(filePrefs)
	end
	filePrefs:close()
end

function PreferenceSet:load()
	for _, group in ipairs(self.preferenceGroups) do
		filePrefs = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew\\preferences\\" .. self.filename .. ".preferences", "r")
		if filePrefs then
			group:load(filePrefs)
			filePrefs:close()
		end
	end
end	

return PreferenceSet
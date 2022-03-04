require "kpcrew.genutils"


local PreferenceGroup = {}

function PreferenceGroup:new(name,title)

    PreferenceGroup.__index = PreferenceGroup

    local obj = {}
    setmetatable(obj, PreferenceGroup)

    obj.name = name
	obj.title = title
	obj.preferences = {}
	obj.lineLength = 60

    return obj
end

function PreferenceGroup:getName()
    return self.name
end

function PreferenceGroup:getTitle()
    return self.title
end

function PreferenceGroup:add(preference)
	table.insert(self.preferences,preference)
end

function PreferenceGroup:remove(key)
    self.preferences[key] = nil
end

function PreferenceGroup:getAllPreferences()
	return self.preferences
end

function PreferenceGroup:render()
	if self ~= nil then
		imgui.Separator()
		imgui_center(self:getHeadline())
		imgui.Separator()
		for _, pref in ipairs(self.preferences) do
			pref:render()
		end
		imgui.Separator()
	end
end

function PreferenceGroup:findPreference(key)
	for _, pref in ipairs(self.preferences) do
		if pref:getKey() == key then
			return pref
		end
	end
	return nil
end

function PreferenceGroup:getWndHeight()
	local wndHeight = 50
	for _, pref in ipairs(self.preferences) do
		wndHeight = wndHeight + 40
	end
	return wndHeight
end

function PreferenceGroup:getHeadline()
	local eqsigns = self.lineLength - string.len(self.title) - 2
	local line = {}
	
	for i=0,math.floor((eqsigns / 2) + 0.5) - 1,1 do
		line[#line + 1] = " "
	end
	
	line[#line + 1] = " "
	line[#line + 1] = self.title
	line[#line + 1] = " "
	
	for i=0,(eqsigns / 2) - 1,1 do
		line[#line + 1] = " "
	end
	return table.concat(line)
end

function PreferenceGroup:save(filePref)
	for _, pref in ipairs(self.preferences) do
		filePref:write(self.name .. ":" .. pref:getSaveLine())
	end
end	

function PreferenceGroup:load(filePref)
   for line in filePref:lines() do
        local key = nil
        local value = nil
		local splits = split(line,":")
		if splits[1] == self.name then
			local delim = string.find(splits[2], "=")
			if delim and delim > 1 and delim < string.len(line) then
				local key = string.sub(splits[2], 1, delim - 1)
				local value = string.sub(splits[2], delim + 1)
				local pref = self:findPreference(key)
				if pref ~= nil then
					if pref:getType() == Preference.typeFlag or pref:getType() == Preference.typeToggle then
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

return PreferenceGroup
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
		imgui.TextUnformatted(self:getHeadline())
		imgui.Separator()
		for _, pref in ipairs(self.preferences) do
			pref:render()
		end
		imgui.Separator()
	end
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

return PreferenceGroup
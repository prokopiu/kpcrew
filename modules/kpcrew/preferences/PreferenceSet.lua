require "kpcrew.genutils"

local PreferenceSet = {}

function PreferenceSet:new(name)

    PreferenceSet.__index = PreferenceSet

    local obj = {}
    setmetatable(obj, PreferenceSet)

    obj.name = name
	obj.preferenceGroups = {}

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

function PreferenceSet:getWndHeight()
	local wndHeight = 0
	for _, group in ipairs(self.preferenceGroups) do
		wndHeight = wndHeight + group:getWndHeight()
	end
	return wndHeight
end

function PreferenceSet:getWndWidth()
	return 435
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
			imgui:SetNextItemOpen()
			group:render()
		end
		imgui.Separator()
	end
end

return PreferenceSet
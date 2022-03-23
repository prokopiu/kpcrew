-- A preferences 
-- Preferences can also be used for background variables to persist kpcrew specific states and values
--
-- @classmod Preference
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcPreference = {
	typeInt = 0,
	typeFlag = 1,
	typeFloat = 2,
	typeToggle = 3,
	typeText = 4,
	typeList = 5
}

-- Instantiate a new preference group
-- @tparam string key Key of preference
-- @tparam object value of preference
-- @tparam int datatype 
-- @tparam string title 
function kcPreference:new(key, value, datatype, title)
    kcPreference.__index = kcPreference
    local obj = {}
    setmetatable(obj, kcPreference)

	obj.key = key
	obj.value = value
	obj.datatype = datatype
	obj.title = title

    return obj
end

-- get key of preference
-- @treturn string key
function kcPreference:getKey()
    return self.key
end

-- get value of preference
-- @treturn object value
function kcPreference:getValue()
    return self.value
end

-- get data type of preference
-- @treturn int datatype
function kcPreference:getType()
    return self.datatype
end

-- get title of preference
-- @treturn string title
function kcPreference:getTitle()
    return self.title
end

-- set value of preference
-- @tparam object 
function kcPreference:setValue(value)
    self.value = value
end

-- set type of preference
-- @tparam int datatype 
function kcPreference:setType(datatype)
    self.datatype = datatype
end

-- set title of preference
-- @tparam string title 
function kcPreference:setTitle(title)
    self.title = title
end

-- ===== UI related functionality =====

-- Render preference in imgui window
function kcPreference:render()
	local splitTitle = kc_split(self.title,"|")
	imgui.TextUnformatted(splitTitle[1])
		
	if self.datatype == self.typeInt then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputInt("", self.value, tonumber(splitTitle[2]))
			if changed then
				self.value = textin
			end
		imgui.PopID()
	end
	
	if self.datatype == self.typeText then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputText("", self.value, 255)
			if changed then
				self.value = textin
			end
		imgui.PopID()
	end
	
	if self.datatype == self.typeToggle then
		local retval = self.value
		if imgui.RadioButton(splitTitle[2], self.value == true) then
			retval = true
		end
		imgui.SameLine()
		if imgui.RadioButton(splitTitle[3], self.value ~= true) then
			retval = false
		end
		self.value = retval
	end

	if self.datatype == self.typeList then
		imgui.PushID(splitTitle[1])
			if imgui.BeginCombo("", splitTitle[self.value + 1]) then
				for i = 2, #splitTitle do
					if imgui.Selectable(splitTitle[i], self.value + 1 == i) then
						self.value = i - 1
					end
				end
			imgui.EndCombo()
			end
		imgui.PopID()
	end
end

-- return the line to be written into the .preferences file
function kcPreference:getSaveLine()
	if self.datatype == self.typeInt or self.datatype == self.typeFloat or self.datatype == self.typeList then
		return self.key .. "=" .. self.value .. "\n"
	end
	if self.datatype == self.typeFlag or self.datatype == self.typeToggle then
		if self.value then
			return self.key .. "=true\n"
		else
			return self.key .. "=false\n"
		end
	end
	if self.datatype == self.typeText then
		return self.key .. "=\"" .. self.value .. "\"\n"
	end
	return self.key .. "=\"\"\n"
end

return kcPreference
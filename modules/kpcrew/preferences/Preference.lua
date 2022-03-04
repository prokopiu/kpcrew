require "kpcrew.genutils"

local Preference = {
	typeInt = 0,
	typeFlag = 1,
	typeFloat = 2,
	typeToggle = 3,
	typeText = 4,
	typeList = 5
}

function Preference:new(key, value, datatype, title)

    Preference.__index = Preference

    local obj = {}
    setmetatable(obj, Preference)

	obj.key = key
	obj.value = value
	obj.datatype = datatype
	obj.title = title

    return obj
end

function Preference:getKey()
    return self.key
end

function Preference:getValue()
    return self.value
end

function Preference:getType()
    return self.datatype
end

function Preference:getTitle()
    return self.title
end

function Preference:setValue(value)
    self.value = value
end

function Preference:setType(datatype)
    self.datatype = datatype
end

function Preference:setTitle(title)
    self.title = title
end

function Preference:render()
	local splitTitle = split(self.title,"|")
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

function Preference:getSaveLine()
	if self.datatype == self.typeInt or self.datatype == self.typeFloat then
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

return Preference
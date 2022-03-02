require "kpcrew.genutils"

local Preference = {
	typeInt = 0,
	typeFlag = 1,
	typeFloat = 2,
	typeToggle = 3
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
		local changed, textin = imgui.InputInt("                       " .. self.title , self.value, tonumber(splitTitle[2]))
		if changed then
			self.value = textin
		end
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
end


return Preference
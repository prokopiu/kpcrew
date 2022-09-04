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
	typeList = 5,
	typeCOMFreq = 6,
	typeNAVFreq = 7,
	typeExecButton = 8,
	colorGreen = 0xFF95C857,
	colorWhite = 0xffffffff
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
	if type(self.value) == 'function' then
		return self.value()
	else
		return self.value
	end
end

-- get data type of preference
-- @treturn int datatype
function kcPreference:getType()
    return self.datatype
end

-- get title of preference
-- @treturn string title
function kcPreference:getTitle()
	if type(self.title) == 'function' then
		return self.title()
	else
		return self.title
	end
end

-- set value of preference
-- @tparam object 
function kcPreference:setValue(value)
	if type(self.value) ~= 'function' then
		self.value = value
	end
end

-- set type of preference
-- @tparam int datatype 
function kcPreference:setType(datatype)
    self.datatype = datatype
end

-- set title of preference
-- @tparam string title 
function kcPreference:setTitle(title)
	if type(self.title) ~= 'function' then
		self.title = title
	end
end

-- ===== UI related functionality =====

-- Render preference in imgui window
function kcPreference:render()
	local splitTitle = kc_split(self:getTitle(),"|")
	imgui.TextUnformatted(splitTitle[1])
		
	if self.datatype == self.typeInt then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputInt("", self:getValue(), tonumber(splitTitle[2]))
			if changed then
				self:setValue(textin)
			end
		imgui.PopID()
	end
	
	if self.datatype == self.typeFloat then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputFloat("", self:getValue(), tonumber(splitTitle[2]), 1.0,splitTitle[3])
			if changed then
				self:setValue(textin)
			end
		imgui.PopID()
	end
	
	if self.datatype == self.typeText then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputText("", self:getValue(), 255)
			if changed then
				self:setValue(textin)
			end
		imgui.PopID()
	end
	
	if self.datatype == self.typeInfo then
		if splitTitle[2] == nil or splitTitle[2] == "" then
			splitTitle[2] = 0xFF95C857
		end
		imgui.PushStyleColor(imgui.constant.Col.Text, splitTitle[2])
		imgui.PushTextWrapPos(330)
		imgui.TextUnformatted(self:getValue())
		imgui.PopTextWrapPos()
		imgui.PopStyleColor()
	end
	
	if self.datatype == self.typeToggle then
		local retval = self:getValue()
		if imgui.RadioButton(splitTitle[2], self:getValue() == true) then
			retval = true
		end
		imgui.SameLine()
		if imgui.RadioButton(splitTitle[3], self:getValue() ~= true) then
			retval = false
		end
		self:setValue(retval)
	end

	if self.datatype == self.typeList then
		imgui.PushID(splitTitle[1])
			if imgui.BeginCombo("", splitTitle[self:getValue() + 1]) then
				for i = 2, #splitTitle do
					if imgui.Selectable(splitTitle[i], self:getValue() + 1 == i) then
						self:setValue(i - 1)
					end
				end
			imgui.EndCombo()
			end
		imgui.PopID()
	end

	if self.datatype == self.typeCOMFreq then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputInt("", self:getValue(), 5, 100)
			imgui.SameLine()
			if imgui.Button("<->") then
				set("sim/cockpit2/radios/actuators/com1_frequency_hz_833",self:getValue()) 
			end
			if changed then
				self:setValue(textin)
			end
		imgui.PopID()
	end

	if self.datatype == self.typeNAVFreq then
		imgui.PushID(splitTitle[1])
			local changed, textin = imgui.InputInt("", self:getValue(), 5, 100)
			imgui.SameLine()
			if imgui.Button("<->") then
				if splitTitle[2] ~= "2" then 
					set("sim/cockpit2/radios/actuators/nav1_frequency_hz",self:getValue()) 
				else
					set("sim/cockpit2/radios/actuators/nav2_frequency_hz",self:getValue()) 
				end
			end
			if changed then
				self:setValue(textin)
			end
		imgui.PopID()
	end

	if self.datatype == self.typeExecButton then
		imgui.PushID(splitTitle[1])
			if imgui.Button(splitTitle[2]) then
				local fnct = loadstring(splitTitle[3])
				fnct()
			end
		imgui.PopID()
	end

end

-- return the line to be written into the .preferences file
function kcPreference:getSaveLine()
	if self.datatype == self.typeInt or self.datatype == self.typeFloat or self.datatype == self.typeList or self.datatype == self.typeCOMFreq or self.datatype == self.typeNAVFreq then
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
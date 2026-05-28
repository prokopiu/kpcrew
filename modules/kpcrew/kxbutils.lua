local color_white = 0xFFCCCCCC
local color_orange = 0xFF1b9af8
local color_yellow = 0xFF00FFFF
local color_green = 0xFF95C857
local color_red = 0xFF0000FF

kb_font_scale = 1.0

function kxb_label(stext,color,code)
	imgui.PushStyleColor(imgui.constant.Col.Text, color)
		if type(code) == "function" then
			imgui.TextUnformatted(code())
		else
			imgui.TextUnformatted(stext)
		end
	imgui.PopStyleColor()
end

function kxb_label_white(stext)
	kxb_label(stext,color_white)
end

function kxb_label_yellow(stext)
	kxb_label(stext,color_yellow)
end

function kxb_label_green(stext)
	kxb_label(stext,color_green)
end

function kxb_label_green_code(stext)
	kxb_label(stext,color_green,stext)
end

function kxb_text_field_ro(itemwidth,color,stext,code)
	imgui.PushItemWidth(itemwidth*kb_font_scale)
		imgui.PushStyleColor(imgui.constant.Col.Text, color)
			if type(code) == "function" then 
				imgui.TextUnformatted(code())
			else
				imgui.TextUnformatted(stext)
			end
		imgui.PopStyleColor()
    imgui.PopItemWidth()
end

function kxb_orange_text_field_ro(itemwidth,stext)
	kxb_text_field_ro(itemwidth,color_orange,stext)
end

function kxb_green_text_field_ro(itemwidth,stext)
	kxb_text_field_ro(itemwidth,color_green,stext)
end

function kxb_red_text_field_ro(itemwidth,stext)
	kxb_text_field_ro(itemwidth,color_red,stext)
end

function kxb_orange_text_field_rocode(itemwidth,stext)
	kxb_text_field_ro(itemwidth,color_orange,stext,stext)
end

function kxb_field_rw(intype,itemwidth,color,id,variable,aux1,code)
	local changed
	imgui.PushItemWidth(itemwidth*kb_font_scale)
		imgui.PushID(id)
			imgui.PushStyleColor(imgui.constant.Col.Text, color)
				if intype == "text" then
					if type(code) == "function" then
						changed, textin = imgui.InputText("", code(), aux1)
					else
						changed, textin = imgui.InputText("", activeBriefings:get(variable), aux1)
					end
				end
				if intype == "int" then
					if type(code) == "function" then
						changed, textin = imgui.InputInt("", code(), aux1)
					else
						changed, textin = imgui.InputInt("", activeBriefings:get(variable), aux1)
					end
				end
				if intype == "float" then 
					if type(code) == "function" then
						changed, textin = imgui.InputFloat("", code(), 0, 0.1, aux1)
					else
						changed, textin = imgui.InputFloat("", activeBriefings:get(variable), 0, 0.1, aux1)
					end
				end				
				if changed then
					activeBriefings:set(variable,textin)
				end
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()
end

function kxb_orange_text_field_rw(itemwidth,id,variable,textlen)
	kxb_field_rw("text",itemwidth,color_orange,id,variable,textlen)
end

function kxb_orange_int_field_rw(itemwidth,id,variable,aux1)
	kxb_field_rw("int",itemwidth,color_orange,id,variable,aux1)
end

function kxb_orange_float_field_rw(itemwidth,id,variable,aux1)
	kxb_field_rw("float",itemwidth,color_orange,id,variable,aux1)
end

function kxb_green_text_field_rw(itemwidth,id,variable,textlen)
	kxb_field_rw("text",itemwidth,color_orange,id,variable,textlen)
end

function kxb_orange_text_field_rwcode(itemwidth,id,variable,textlen,code)
	kxb_field_rw("text",itemwidth,color_orange,id,variable,textlen,code)
end

function kxb_dropdown_orange(itemwidth,id,combopreset,combooptions,variable)
	imgui.PushItemWidth(itemwidth*kb_font_scale)
		imgui.PushID(id)
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				if imgui.BeginCombo("", combopreset) then
					local options = combooptions
					for i = 1, #combooptions do
						if imgui.Selectable(combooptions[i], activeBriefings:get(variable) == i) then
							activeBriefings:set(variable,i)
						end
					end
				imgui.EndCombo() end		
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()
end

function kxb_dropdown_runway(itemwidth,id,combopreset,combooptions,variable)
	imgui.PushItemWidth(itemwidth*kb_font_scale)
		imgui.PushID(id)
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				if imgui.BeginCombo("", combopreset) then
					local options = combooptions
					for i = 1, #options do
						if imgui.Selectable(options[i].identifier, activeBriefings:get(variable) == i) then
							activeBriefings:set(variable,options[i].identifier)
						end
					end
				imgui.EndCombo() end		
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()
end

function kxb_scaled_button(id,slable,xwidth,ywidth,code)
	imgui.PushID(id)
		if imgui.Button(slable, xwidth*kb_font_scale, ywidth*kb_font_scale) then
			if type(code) == "function" then code() end
		end
	imgui.PopID()
end
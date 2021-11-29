--[[
	*** KPCREW 2.2
	Kosta Prokopiu, October 2021
	Checklist related functionality
--]]

-- initialize checklist window
function kc_init_checklist_window (height, width, name)
	if kc_checklist_wnd == 0 or kc_checklist_wnd == nil then	
		kc_checklist_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(kc_checklist_wnd, name)
		float_wnd_set_position(kc_checklist_wnd, gScreenWidth-width+get_kpcrew_config("wnd_checklist_x_pos") , get_kpcrew_config("wnd_checklist_y_pos"))
		float_wnd_set_imgui_builder(kc_checklist_wnd, "kc_checklist_build")
		float_wnd_set_onclose(kc_checklist_wnd, "kc_close_checklist_window")
	end
end

function kc_init_procedure_window (height, width, name)
	if kc_checklist_wnd == 0 or kc_checklist_wnd == nil then
		kc_checklist_wnd = float_wnd_create(width, height, 1, true)
		float_wnd_set_title(kc_checklist_wnd, name)
		float_wnd_set_position(kc_checklist_wnd, gScreenWidth-width+get_kpcrew_config("wnd_checklist_x_pos") , get_kpcrew_config("wnd_checklist_y_pos"))
		float_wnd_set_imgui_builder(kc_checklist_wnd, "kc_procedure_build")
		float_wnd_set_onclose(kc_checklist_wnd, "kc_close_checklist_window")
	end
end

-- handler for closing checklist window
function kc_close_checklist_window()
	kc_checklist_wnd = 0
end

-- display a checklist item
function kc_checklist_item(actor, itemtext, itemcheck, state, color, width1, width2, count)
	imgui.BeginChild(itemtext, (width1+width2), 25)
		imgui.SetWindowFontScale(1.2);
		imgui.Columns(3,itemtext,false)
		imgui.SetColumnWidth(0, 30)
		imgui.SetColumnWidth(1, width1)
		imgui.SetColumnWidth(2, width1)
		local changed, newVal = imgui.Checkbox(itemtext .. count, state)
		if changed then
			state = newVal
		end
		imgui.PushStyleColor(imgui.constant.Col.Text, color)
		imgui.NextColumn()
		imgui.TextUnformatted(string.upper(actor) .. " " .. string.upper(itemtext))
		imgui.NextColumn()
		imgui.TextUnformatted(string.upper(itemcheck))
		imgui.PopStyleColor()
	imgui.EndChild()
	return state
end

-- display a procedure item
function kc_procedure_item(actor, activity, color, width, count)
	imgui.BeginChild(activity, width, 25)
		imgui.SetWindowFontScale(1.15);
		if color ~= nil then
		   imgui.PushStyleColor(imgui.constant.Col.Text, color)
		end
		imgui.TextUnformatted(string.upper(actor) .. " " .. string.upper(activity))
		if color ~= nil then
			imgui.PopStyleColor()
		end
	imgui.EndChild()
end

-- build checklist content
function kc_checklist_build()
	kc_checklist_area(gActiveChecklist)
end

function kc_procedure_build()
	kc_procedure_area(gActiveChecklist)
end

-- build checklist section
function kc_checklist_area(checklist)
	local loopitem = 1
	repeat
		curritem = checklist[loopitem]
		if curritem ~= nil then
			if curritem["display"] ~= nil and curritem["display"]() ~= "" then
				curritem["chkl_response"] = curritem["display"]()
			end
			curritem["chkl_state"] = kc_checklist_item(curritem["actor"],curritem["chkl_item"],curritem["chkl_response"],curritem["chkl_state"],curritem["chkl_color"],checklist["wnd_width1"],checklist["wnd_width2"],loopitem)
			if curritem["chkl_state"] == true then
				curritem["chkl_color"] = color_green
			else
				curritem["chkl_color"] = color_white
			end
			if curritem["checks"] ~= nil and curritem["checks"]() == false and curritem["chkl_state"] == false then
				curritem["chkl_color"] = color_red
			end
		end
		loopitem = loopitem + 1
	until (curritem["end"] == 1)
end

-- build checklist section
function kc_procedure_area(procedure)
	local loopitem = 1
	repeat
		curritem = procedure[loopitem]
		if curritem ~= nil then
			if curritem["display"] ~= nil and curritem["display"]() ~= "" then
				curritem["activity"] = curritem["display"]()
			end
			if curritem["checks"] ~= nil and curritem["checks"]() == false and curritem["chkl_color"] ~= color_green then
				curritem["chkl_color"] = color_red
			end
			kc_procedure_item(curritem["actor"],curritem["activity"],curritem["chkl_color"],procedure["wnd_width"],loopitem)
		end
		loopitem = loopitem + 1
	until (curritem["end"] == 1)
end

-- open checklist window from external
function kc_open_checklist(checklist, reset)
	if reset then 
		kc_checklist_reset(checklist)
	end
	if kc_checklist_wnd == nil or kc_checklist_wnd == 0 then
		kc_init_checklist_window(checklist["wnd_height"],(checklist["wnd_width1"]+checklist["wnd_width2"]), checklist["name"])
		gActiveChecklist = checklist
	end
end

function kc_open_procedure(procedure, reset)
	if reset then 
		kc_procedure_reset(procedure)
	end
	if kc_checklist_wnd == nil or kc_checklist_wnd == 0 then
		kc_init_procedure_window(procedure["wnd_height"],procedure["wnd_width"], procedure["name"])
		gActiveChecklist = procedure
	end
end

-- destroy the checklist window at end of checklist
function kc_destroy_checklist_wnd()
	if kc_checklist_wnd ~= 0 then 
		float_wnd_destroy(kc_checklist_wnd)
	end
	kc_checklist_wnd = 0
end


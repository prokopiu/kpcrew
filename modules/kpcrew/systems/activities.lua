-- activities related functionality
-- some new features and ideas thanks to patrickl92

require "kpcrew.genutils"

typeInop = -1
typeModes = 0
typeActuator = 1
typeCustom = 2

modeOff = 0
modeOn = 1
modeToggle = 2

actWithCmd = 0
actWithDref = 1
actCmdDref = 2
actCustom = 3

toggleCmd = 0
toggleDref = 1
toggleCustom = 2

statusDref = 0
statusCustom = 1

--------------------- command execution and status retrieval  ----------------------
-- act(name of component in system, name of element to act on, instance of element, activity like mode)
function act(component, name, instance, activity)
	local item = component[name]
	if item["type"] ~= typeInop then

		-- mode setting (on,off,toggle or custom)
		if item["type"] == typeModes then

			-- set modes with individual commands
			if item["cmddref"] == actWithCmd then
				if item["toggle"] == toggleCmd then
					--logMsg(item["instances"][instance]["commands"][activity])
					command_once(item["instances"][instance]["commands"][activity])
				end -- toggle
			end -- cmdref actWithCmd
			
			-- set modes with dataref
			if item["cmddref"] == actWithDref then
				if item["toggle"] == toggleDref then
					local ref = item["instances"][instance]["dataref"] 
					if activity ~= modeToggle then
						--logMsg(ref["name"] .. "[" .. ref["index"] .. "]")
						set_array(ref["name"],ref["index"],activity)
					else 
						if get(ref["name"],ref["index"]) == modeOn then
							set_array(ref["name"],ref["index"],modeOff)
						else
							set_array(ref["name"],ref["index"],modeOn)
						end
					end 
				end -- toggle
			end -- cmdref actWithDref

		end -- type modes
	end -- not inop
end

-- get status from dref or custim function
function status(component, name, instance)
	local item = component[name]
	if item["type"] ~= typeInop then
		if item["status"] == statusDref then
			local ref = item["instances"][instance]["drefStatus"] 
			--logMsg(ref["name"] .. "[" .. ref["index"] .. "]")
			return get(ref["name"],ref["index"])
		end --status dref
	else -- inop
		return typeInop
	end -- inop
end

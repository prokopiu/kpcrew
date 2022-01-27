-- activities related functionality
-- some new features and ideas thanks to patrickl92

require "kpcrew.genutils"

typeInop = -1
typeOnOffTgl = 0

modeOff = 0
modeOn = 1
modeToggle = 2

actWithCmd = 0
actWithDref = 1
actTglCmd = 2
actCustom = 3

toggleCmd = 0
toggleDref = 1
toggleCustom = 2

statusDref = 0
statusCustom = 1

cmdDown = 0
cmdUp = 1

--------------------- command execution and status retrieval  ----------------------
-- act(name of component in system, name of element to act on, instance of element, activity like mode)
function act(component, name, instance, activity)
	local item = component[name]
	if item["type"] ~= typeInop then
		-- mode setting (on,off,toggle or custom)
		if item["type"] == typeOnOffTgl then

			-- set modes with individual commands
			if item["cmddref"] == actWithCmd then
				if item["toggle"] == toggleCmd then
					--logMsg(item["instances"][instance]["commands"][activity])
					command_once(item["instances"][instance]["commands"][activity])
				end -- toggle
				if item["toggle"] == toggleDref then
					if activity ~= modeToggle then
						--logMsg(item["instances"][instance]["commands"][activity])
						command_once(item["instances"][instance]["commands"][activity])
					else
						local ref = item["instances"][instance]["drefStatus"] 
						if get(ref["name"],ref["index"]) ~= modeOff then
							command_once(item["instances"][instance]["commands"][modeOff])
						else
							command_once(item["instances"][instance]["commands"][modeOn])
						end
					end
				end -- toggle
			end -- cmdref actWithCmd
			
			-- only toggle command available
			if item["cmddref"] == actTglCmd then
				if activity ~= modeToggle then
					local ref = item["instances"][instance]["drefStatus"] 
					if get(ref["name"],ref["index"]) ~= activity then
						command_once(item["instances"][instance]["commands"][modeToggle])
					end
				else
					command_once(item["instances"][instance]["commands"][modeToggle])
				end -- toggle
			end -- cmdref actWithCmd
			
			-- set modes with dataref
			if item["cmddref"] == actWithDref then
				if item["toggle"] == toggleDref then
					local ref = item["instances"][instance]["dataref"] 
					local statusref = item["instances"][instance]["drefStatus"] 
					if activity ~= modeToggle then
						--logMsg("dref: " .. ref["name"] .. "[" .. ref["index"] .. "]")
						set_array(ref["name"],ref["index"],activity)
					else 
						--logMsg("st: " .. statusref["name"] .. "[" .. ref["index"] .. "]")
						if get(statusref["name"],ref["index"]) ~= modeOff then
							set_array(ref["name"],ref["index"],modeOff)
						else
							set_array(ref["name"],ref["index"],modeOn)
						end
					end 
				end -- toggle
			end -- cmdref actWithDref

			-- set modes with custom functions
			if item["cmddref"] == actCustom then
				if item["toggle"] == toggleDref then
					local ref = item["instances"][instance]["drefStatus"]
					local func = item["instances"][instance]["custom"]
					logMsg(ref["name"] .. "[" .. ref["index"] .. "]")
					if activity ~= modeToggle then
						func[activity]()
					else 
						if get(ref["name"],ref["index"]) ~= modeOff then
							func[modeOff]()
						else
							func[modeOn]()
						end
					end 
				end -- toggle
			end -- cmdref actCustom

		end -- type onofftgl
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

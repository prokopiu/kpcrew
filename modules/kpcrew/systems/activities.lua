-- activities related functionality
-- some new features and ideas thanks to patrickl92

require "kpcrew.genutils"

typeInop = -1
typeOnOffTgl = 0
typeAnnunciator = 1
typeActuator = 2

modeOff = 0
modeOn = 1
modeToggle = 2

actNone = -1
actWithCmd = 0
actWithDref = 1
actTglCmd = 2
actCustom = 3

toggleNone = -1
toggleCmd = 0
toggleDref = 1
toggleCustom = 2

statusNone = -1
statusDref = 0
statusCustom = 1

cmdDown = 0
cmdUp = 1
cmdLeft = 0
cmdRight = 1

--------------------- command execution and status retrieval  ----------------------
-- act(name of component in system, name of element to act on, instance of element, activity like mode)
function act(component, name, instance, activity)
	local item = component[name]
	if item["type"] ~= typeInop then
		-- mode setting (on,off,toggle or custom)
		if item["type"] == typeOnOffTgl then

			-- set modes with individual commands
			if item["cmddref"] == actWithCmd then

				-- there is a command for toggle beside the other modes (on, off and toggle)
				if item["toggle"] == toggleCmd then
					command_once(item["instances"][instance]["commands"][activity])
				end -- toggle

				-- toggle is based on the statud dref
				if item["toggle"] == toggleDref then
				
					if activity ~= modeToggle then
						command_once(item["instances"][instance]["commands"][activity])
					else
						local statusref = item["instances"][instance]["drefStatus"] 
						if get(statusref["name"],statusref["index"]) ~= modeOff then
							command_once(item["instances"][instance]["commands"][modeOff])
						else
							command_once(item["instances"][instance]["commands"][modeOn])
						end
					end
				
				end -- toggle

				-- no toggle required, only simple commands
				if item["toggle"] == toggleNone then
					command_once(item["instances"][instance]["commands"][activity])
				end -- toggle

			end -- cmdref actWithCmd
			
			-- only toggle command available
			if item["cmddref"] == actTglCmd then

				-- if mode not modeToggle
				if activity ~= modeToggle then
					local statusref = item["instances"][instance]["drefStatus"] 
					if math.floor(get(statusref["name"],statusref["index"])) ~= activity then
						command_once(item["instances"][instance]["commands"][modeToggle])
					end
				else
					command_once(item["instances"][instance]["commands"][modeToggle])
				end -- toggle
				
			end -- cmdref actWithCmd
			
			-- set modes with dataref
			if item["cmddref"] == actWithDref then
			
				-- toggle mode based on statusDref
				if item["toggle"] == toggleDref then
					local ref = item["instances"][instance]["dataref"] 
					local statusref = item["instances"][instance]["drefStatus"] 

					if activity ~= modeToggle then
						set_array(ref["name"],ref["index"],activity)
					else 
						if get(statusref["name"],statusref["index"]) ~= modeOff then
							set_array(ref["name"],ref["index"],modeOff)
						else
							set_array(ref["name"],ref["index"],modeOn)
						end
					end 

				end -- toggle

			end -- cmdref actWithDref

			-- set modes with custom functions
			if item["cmddref"] == actCustom then

				-- toggle based on status dref
				if item["toggle"] == toggleDref then
					local statusref = item["instances"][instance]["drefStatus"]
					local func = item["instances"][instance]["customcmd"]
					if activity ~= modeToggle then
						func[activity]()
					else 
						if get(statusref["name"],statusref["index"]) ~= modeOff then
							func[modeOff]()
						else
							func[modeOn]()
						end
					end 
				end -- toggle
				
				if item["toggle"] == toggleCmd then
					local func = item["instances"][instance]["customcmd"]
					func[activity]()
				end -- toggle

			end -- cmdref actCustom

		end -- type onofftgl
		
		if item["type"] == typeActuator then

			-- set modes with individual commands
			if item["cmddref"] == actWithCmd then
				command_once(item["instances"][instance]["commands"][activity])
			end -- cmdref actWithCmd

			-- set modes with dataref
			if item["cmddref"] == actWithDref then
				local ref = item["instances"][instance]["dataref"] 
				set_array(ref["name"],ref["index"],activity)
			end -- cmdref actWithDref

			if item["cmddref"] == actCustom then
				local statusref = item["instances"][instance]["drefStatus"]
				local ref = item["instances"][instance]["dataref"]
				local func = item["instances"][instance]["customcmd"]
				func[activity]()
			end -- cmdref actCustom

		end -- actuator

	end -- not inop
	
end

-- get status from dref or custim function
function status(component, name, instance)
	local item = component[name]
	if item["type"] ~= typeInop then
		if item["status"] == statusDref then
			local ref = item["instances"][instance]["drefStatus"] 
			return get(ref["name"],ref["index"])
		end --status dref
		if item["status"] == statusCustom then
			local func = item["instances"][instance]["customdref"] 
			return func()
		end --status dref
	else -- inop
		return typeInop
	end -- inop
end

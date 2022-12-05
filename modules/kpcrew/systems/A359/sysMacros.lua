-- A350 airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

function kc_macro_state_cold_and_dark()
	sysElectric.busTieSwitch:actuate(0)
	sysElectric.ELMU:actuate(0)
	sysElectric.PAXSYS:actuate(0)
	sysElectric.GALLEY:actuate(0)
	sysElectric.COMM1:actuate(0)
	sysElectric.COMM2:actuate(0)
	sysElectric.genSwitchGroup:actuate(0)

	sysElectric.gpu1Connect:actuate(0)
	sysElectric.gpu2Connect:actuate(0)
	sysElectric.gpuSwitch:actuate(0)
	sysElectric.gpu2Switch:actuate(0)

	sysElectric.apuGenBus:actuate(0)


	sysElectric.apuMasterSwitch:actuate(0)
	-- sysElectric.apuStartSwitch:actuate(0)

	sysElectric.batterySwitch:actuate(0)
	sysElectric.battery2Switch:actuate(0)
	sysElectric.batemerg1:actuate(0)
	sysElectric.batemerg2:actuate(0)
end

function kc_macro_state_turnaround()
	sysElectric.batterySwitch:actuate(1)
	sysElectric.battery2Switch:actuate(1)
	sysElectric.batemerg1:actuate(1)
	sysElectric.batemerg2:actuate(1)

	sysElectric.gpu1Connect:actuate(1)
	sysElectric.gpu2Connect:actuate(1)
	sysElectric.gpuSwitch:actuate(1)
	sysElectric.gpu2Switch:actuate(1)
	
	sysElectric.busTieSwitch:actuate(1)
	sysElectric.ELMU:actuate(1)
	sysElectric.PAXSYS:actuate(1)
	sysElectric.GALLEY:actuate(1)
	sysElectric.COMM1:actuate(1)
	sysElectric.COMM2:actuate(1)
	sysElectric.genSwitchGroup:actuate(1)

end


-- function kc_bck_()
-- end

return sysMacros
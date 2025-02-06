-- Laminar A330 variants airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("A33L sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()
	logMsg("A33L kc_macro_state_cold_and_dark")
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)

	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	if kc_has_irs then
		sysFMC.irsGroup:actuate(0)
	end
	
	-- kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	-- kc_macro_mcp_cold_dark()

	sysControls.Speedbrake:setValue(0)
	sysGeneral.wiperGroup:actuate(0)
	sysGeneral.GearSwitch:actuate(1)
	sysEngines.throttlePos:actuate(0)
	sysHydraulic.elecHydPumpGroup:actuate(0)
	sysHydraulic.engHydPumpGroup:actuate(0)
	sysFuel.allFuelPumpGroup:actuate(0)


	-- sysControls.aileronReset:actuate(1)
	-- sysControls.rudderReset:actuate(1)
	-- sysFuel.crossFeed:actuate(0)
	-- sysAir.packSwitchGroup:actuate(0)
	-- sysElectric.genSwitchGroup:actuate(0)
	-- sysElectric.inverterSwitchGroup:actuate(0)
	-- sysElectric.dcBusTie:actuate(0)
	-- sysAice.windowHeatGroup:actuate(0)

	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",0,0)
	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",1,0)
	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",2,0)
	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",3,0)
	-- set_array("sim/cockpit/engine/ignition_on",0,0)
	-- set_array("sim/cockpit/engine/ignition_on",1,0)
	-- set_array("sim/cockpit/engine/ignition_on",2,0)
	-- set_array("sim/cockpit/engine/ignition_on",3,0)
	
	-- sysGeneral.seatBeltSwitch:actuate(0)
	-- sysGeneral.noSmokingSwitch:actuate(0)
	-- sysControls.Autobrake:setValue(1)
	-- sysControls.flapsSwitch:setValue(0)

	-- sysElectric.avionicsSwitchGroup:actuate(0)
	-- sysElectric.apuStartSwitch:actuate(0)
	-- sysElectric.gpuConnect:actuate(0)
	-- sysElectric.batterySwitch:actuate(0) 
	-- sysElectric.battery2Switch:actuate(0) 

end

function kc_macro_state_turnaround()
	logMsg("A33L kc_macro_state_turnaround")
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	sysElectric.batterySwitch:actuate(1) 
	sysElectric.battery2Switch:actuate(1)

	-- kc_macro_lights_preflight()

	sysGeneral.wiperGroup:actuate(0)
	sysGeneral.GearSwitch:actuate(1)
	-- sysControls.Speedbrake:setValue(0)
	-- sysEngines.throttlePos:actuate(0)
	-- sysHydraulic.elecHydPumpGroup:actuate(1)
	-- sysHydraulic.engHydPumpGroup:actuate(0)
	-- sysElectric.gpuConnect:actuate(1)
	-- sysElectric.gpuGenBusGroup:actuate(1)
	-- sysElectric.avionicsSwitchGroup:actuate(1)
	-- sysControls.aileronReset:actuate(1)
	-- sysControls.rudderReset:actuate(1)
	-- sysFuel.crossFeed:actuate(0)
	-- sysAir.packSwitchGroup:actuate(1)
	-- sysElectric.genSwitchGroup:actuate(0)
	-- sysFuel.allFuelPumpGroup:actuate(1)
	-- sysGeneral.seatBeltSwitch:actuate(1)
	-- sysGeneral.noSmokingSwitch:actuate(1)
	-- sysElectric.inverterSwitchGroup:actuate(1)
	-- sysElectric.dcBusTie:actuate(1)
	-- sysAice.windowHeatGroup:actuate(1)
	-- sysRadios.xpdrCode:actuate(2000)

	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",0,0)
	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",1,0)
	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",2,0)
	-- set_array("sim/cockpit2/engine/actuators/auto_ignite_on",3,0)
	-- set_array("sim/cockpit/engine/ignition_on",0,0)
	-- set_array("sim/cockpit/engine/ignition_on",1,0)
	-- set_array("sim/cockpit/engine/ignition_on",2,0)
	-- set_array("sim/cockpit/engine/ignition_on",3,0)

	-- sysControls.Autobrake:setValue(1)
	-- sysControls.flapsSwitch:setValue(0)

	kc_macro_doors_preflight()
	-- kc_macro_mcp_preflight()

end

return sysMacros
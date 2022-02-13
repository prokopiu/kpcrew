-- Hardware specific modules - GoFlightInterfaceTool GF-RP48 

-- 
--create_command("kp/xsp/bravo/mode_alt",	"Bravo AP Mode ALT",	"xsp_bravo_mode=1", "", "")

-- Honeycomb Bravo Lights

--xsp_parking_brake = create_dataref_table("kp/xsp/bravo/parking_brake", "Int")
--xsp_parking_brake[0] = 0

-- background function every 1 sec to set lights/annunciators for hardware (honeycomb bravo)
function xsp_set_gfrp48_lights()

	-- PARKING BRAKE 0=off 1=set
	-- xsp_parking_brake[0] = sysGeneral.parkbrakeAnc:getStatus()


end

-- do_often("xsp_set_gfrp48_lights()")

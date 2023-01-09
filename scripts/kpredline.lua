--[[
	*** KPREDLINE 2.3
	FSX style Shift-Z line
	Kosta Prokopiu, January 2023
--]]

require "graphics"

redline_showit = false
 
function toDegMinSec(coordinate) 
    local absolute = math.abs(coordinate);
    local degrees  = math.floor(absolute);
    local minutesNotTruncated = (absolute - degrees) * 60;
    local minutes  = math.floor(minutesNotTruncated);
    local seconds  = math.floor((minutesNotTruncated - minutes) * 60);

    return degrees .. " " .. minutes .. "'" .. seconds .. "\"";
end

function convertDMS(lat, lng) 
    local latitude = toDegMinSec(lat);
    local latitudeCardinal = (lat >= 0) and "N" or "S";

    local longitude = toDegMinSec(lng);
    local longitudeCardinal = (lng >= 0) and "E" or "W";

    return "LAT: " .. latitudeCardinal .. latitude .. " LON: " .. longitudeCardinal .. longitude
end


function draw_redlines()  
  if redline_showit then 
	-- init the graphics system
	  XPLMSetGraphicsState(0,0,0,1,1,0,0)
	  
	  local line1 = ""
	  local line2 = ""
	  
	  local latitude = get("sim/flightmodel/position/latitude")
	  local longitude = get("sim/flightmodel/position/longitude")
	  local pressalt = get("sim/flightmodel2/position/pressure_altitude")
	  local hdg = get("sim/flightmodel/position/magpsi")
	  local ias = get("sim/flightmodel/position/indicated_airspeed")
	  local gs = get("sim/flightmodel/position/groundspeed")
	  local wspd = get("sim/cockpit2/gauges/indicators/wind_speed_kts")
	  local whdg = get("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
	  if ias < 0 then 
		ias = 0
	  end
	  
	  line1 = string.format("%s  ALT: %6.0f FT MSL  HDG: %3.0f MAG  IAS: %4i KTS  GS: %3i KTS  WIND: %3.0f/%3.0f",convertDMS(latitude,longitude),pressalt,hdg,ias,gs,whdg,wspd)

	  local fps = 1/get("sim/time/framerate_period")
	  local fueltotal = get("sim/flightmodel/weight/m_fuel_total")
	  local fuelmax = get("sim/aircraft/weight/acf_m_fuel_tot")
	  local gndspeedflt = get("sim/time/ground_speed_flt")
	  local simrate = get("sim/time/sim_speed_actual")
	  local atstate = get("sim/cockpit2/autopilot/autothrottle_on")
	  local atspd = get("sim/cockpit/autopilot/airspeed")
	  local aphdg = get("sim/cockpit/autopilot/heading_mag")
	  local apalt = get("sim/cockpit2/autopilot/altitude_dial_ft")

	  line2 = string.format("FRAMES/SEC: %4.1f  FUEL: %3.0f%%  SIMRATE: %3.1f  SIMSPEED: %2i  A/T: %s  A/T SPD: %3i  A/P HDG: %3i  A/P ALT: %5i",fps,(fueltotal/fuelmax)*100,simrate,gndspeedflt,atstate==1 and "ON" or "OFF",atspd,aphdg,apalt) 
	  -- set color and width
	  graphics.set_color(1, 0, 0, 1)
	  draw_string_Helvetica_12(10, SCREEN_HIGHT+(-15), line1)
	  draw_string_Helvetica_12(10, SCREEN_HIGHT+(-30), line2)

	end
end

add_macro("KPRedline Toggle Display", "redline_showit = not redline_showit")
create_command("kp/redline/toggle", "Toggle KP Redline","redline_showit = not redline_showit","","")

do_every_draw("draw_redlines()")


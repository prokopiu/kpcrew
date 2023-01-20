--DefaultDefinitions
dataref("sunAngle", "sim/graphics/scenery/sun_pitch_degrees", "readonly")
minSunAngle = -8 --Night time sun angle cutoff
evAtMin = 9.5 --Auto exposure value at night
maxSunAngle = 8 --Day time sun angle cutoff
evAtMax = 15 --Auto exposure value during day
--Reading Settings
local settingsFile = io.open("AutoExposureSettings.txt","r")
saved = true
if settingsFile then
  minSunAngle = tonumber(settingsFile:read("*line"))
  evAtMin = tonumber(settingsFile:read("*line"))
  maxSunAngle = tonumber(settingsFile:read("*line"))
  evAtMax = tonumber(settingsFile:read("*line"))
  settingsFile:close()
end
--Settings Window
function createSettingsWindow()
  settingsWindow = float_wnd_create(600,200,1,true)
  float_wnd_set_title(settingsWindow,"Auto Exposure Settings")
  float_wnd_set_imgui_builder(settingsWindow,"settingsWindowBuilder")
end
function settingsWindowBuilder(wnd,x,y)
  local minAngleSliderChanged, minAngleSliderNewVal = imgui.SliderFloat("Minimum Sun Angle Cuttoff",minSunAngle,-30,-1,"%.1f Degrees")
  if minAngleSliderChanged then
    minSunAngle = minAngleSliderNewVal
    saved = false
  end
  local maxAngleSliderChanged, maxAngleSliderNewVal = imgui.SliderFloat("Maximum Sun Angle Cuttoff",maxSunAngle,1,30,"%.1f Degrees")
  if maxAngleSliderChanged then
    maxSunAngle = maxAngleSliderNewVal
    saved = false
  end
  local minEvSliderChanged, minEvSliderNewVal = imgui.SliderFloat("Exposure Value at Minimum",evAtMin,3,12,"%.1f")
  if minEvSliderChanged then
    evAtMin = minEvSliderNewVal
    saved = false
  end
  local maxEvSliderChanged, maxEvSliderNewVal = imgui.SliderFloat("Exposure Value at Maximum",evAtMax,12,21,"%.1f")
  if maxEvSliderChanged then
    evAtMax = maxEvSliderNewVal
    saved = false
  end
  if saved == false then
    if imgui.Button("Save Settings") then
      local settingsFile = io.open("AutoExposureSettings.txt","w")
      if settingsFile then
        settingsFile:write(tostring(minSunAngle),"\n")
        settingsFile:write(tostring(evAtMin),"\n")
        settingsFile:write(tostring(maxSunAngle),"\n")
        settingsFile:write(tostring(evAtMax))
        imgui.TextUnformatted("Saved Successfully!")
        saved = true
      end
    end
  end
end
--Exposure Calculation
function calcExposure() -- All sun angles are degrees above the horizon
  if sunAngle < minSunAngle then return evAtMin end --Cool code function stuff
  if sunAngle > maxSunAngle then return evAtMax end
  local currentEv = (((sunAngle-minSunAngle)/(maxSunAngle - minSunAngle))*(evAtMax-evAtMin))+evAtMin --Value interpolation
  return currentEv
end
function setAutoExposure()
  local presentEv = calcExposure()
  set("sim/private/controls/photometric/ev100",presentEv)
end
--OpenSettingsWindow
function openCloseSettings()
  local isVisible
	if settingsWindow==nil then
		createSettingsWindow()
	else
		isVisible = float_wnd_get_visible(settingsWindow)
		if not isVisible then
			createSettingsWindow()
		end
	end
end
do_every_frame("setAutoExposure()")
add_macro("Auto Exposure Settings","openCloseSettings()")

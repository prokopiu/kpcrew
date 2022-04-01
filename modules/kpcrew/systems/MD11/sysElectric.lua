-- MD11  airplane 
-- Electric system functionality

local sysElectric = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

-- Emergency Power
sysElectric.emerPwrSelector = MultiStateCmdSwitch:new("","Rotate/aircraft/controls/emer_pwr","Rotate/aircraft/controls_c/emer_pwr_up","Rotate/aircraft/controls_c/emer_pwr_dn")

-- Battery switch and guard
sysElectric.batteryGuard = TwoStateToggleSwitch:new("","Rotate/aircraft/controls/battery_grd",0,"Rotate/aircraft/controls_c/battery_grd")

sysElectric.batterySwitch = TwoStateToggleSwitch:new("","sim/cockpit/electrical/battery_on",0,"Rotate/aircraft/controls_c/battery")

-- GPU
sysElectric.GPU = TwoStateToggleSwitch:new("","Rotate/aircraft/fx/show_gpu_truck",0,"Rotate/aircraft/operation_c/ext_pwr_request")

-- EXT PWR Switch
sysElectric.extPWRSwitch = TwoStateToggleSwitch:new("","Rotate/aircraft/systems/elec_ext_pwr_on_lt",0,"Rotate/aircraft/controls_c/ext_pwr")

--APU PWR 
sysElectric.apuPwrSwitch = TwoStateCustomSwitch:new("","Rotate/aircraft/systems/elec_apu_on_lt",0,
function () 
	if get("Rotate/aircraft/systems/elec_apu_on_lt") == 0 then
		command_once("Rotate/aircraft/controls_c/apu_pwr")
		set("Rotate/aircraft/controls/apu_pwr",1)
	end
end,
function () 
	if get("Rotate/aircraft/systems/elec_apu_on_lt") == 1 then
		command_once("Rotate/aircraft/controls_c/apu_pwr")
		set("Rotate/aircraft/controls/apu_pwr",1)
	end
end,
function () 
	command_once("Rotate/aircraft/controls_c/apu_pwr")
	set("Rotate/aircraft/controls/apu_pwr",1)
end)

sysElectric.eng1DriveGuard = TwoStateToggleSwitch:new("","Rotate/aircraft/controls/gen_drive_1_disc_grd",0,"Rotate/aircraft/controls_c/gen_drive_1_disc_grd")
sysElectric.eng2DriveGuard = TwoStateToggleSwitch:new("","Rotate/aircraft/controls/gen_drive_2_disc_grd",0,"Rotate/aircraft/controls_c/gen_drive_2_disc_grd")
sysElectric.eng3DriveGuard = TwoStateToggleSwitch:new("","Rotate/aircraft/controls/gen_drive_3_disc_grd",0,"Rotate/aircraft/controls_c/gen_drive_3_disc_grd")
sysElectric.engDriveGuards = SwitchGroup:new("engdriveguards")
sysElectric.engDriveGuards:addSwitch(sysElectric.eng1DriveGuard)
sysElectric.engDriveGuards:addSwitch(sysElectric.eng2DriveGuard)
sysElectric.engDriveGuards:addSwitch(sysElectric.eng3DriveGuard)

-----
-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- GPU avail
sysElectric.gpuAvailAnc = SimpleAnnunciator:new("gpuavail","Rotate/aircraft/systems/elec_ext_avail",0)

-- DC OFF lights
sysElectric.dcOff1Anc = SimpleAnnunciator:new("dcoff1","Rotate/aircraft/systems/elec_dc_1_off_lt",0)
sysElectric.dcOff2Anc = SimpleAnnunciator:new("dcoff1","Rotate/aircraft/systems/elec_dc_2_off_lt",0)
sysElectric.dcOff3Anc = SimpleAnnunciator:new("dcoff1","Rotate/aircraft/systems/elec_dc_3_off_lt",0)
sysElectric.emerDcOffLAnc = SimpleAnnunciator:new("dcgsl","Rotate/aircraft/systems/elec_emer_dc_l_off_lt",0)
sysElectric.emerDcOffRAnc = SimpleAnnunciator:new("dcgsr","Rotate/aircraft/systems/elec_emer_dc_r_off_lt",0)
sysElectric.elecDcGsOffAnc = SimpleAnnunciator:new("dcoff1","Rotate/aircraft/systems/elec_dc_gs_off_lt",0)
sysElectric.dcOffLights = CustomAnnunciator:new("dcoff",
function () 
	if sysElectric.dcOff1Anc:getStatus() == 1 or sysElectric.dcOff2Anc:getStatus() == 1 or sysElectric.dcOff3Anc:getStatus() == 1 or sysElectric.emerDcOffLAnc:getStatus() == 1 or sysElectric.emerDcOffRAnc:getStatus() == 1 or sysElectric.elecDcGsOffAnc:getStatus() == 1 then
		return 1
	else
		return 0
	end
end)

-- AC OFF lights
sysElectric.acOff1Anc = SimpleAnnunciator:new("acoff1","Rotate/aircraft/systems/elec_ac_1_off_lt",0)
sysElectric.acOff2Anc = SimpleAnnunciator:new("acoff2","Rotate/aircraft/systems/elec_ac_2_off_lt",0)
sysElectric.acOff3Anc = SimpleAnnunciator:new("acoff3","Rotate/aircraft/systems/elec_ac_3_off_lt",0)
sysElectric.emerAcOffLAnc = SimpleAnnunciator:new("acgsl","Rotate/aircraft/systems/elec_emer_ac_l_off_lt",0)
sysElectric.emerAcOffRAnc = SimpleAnnunciator:new("acgsr","Rotate/aircraft/systems/elec_emer_ac_r_off_lt",0)
sysElectric.elecAcGsOffAnc = SimpleAnnunciator:new("acoff1","Rotate/aircraft/systems/elec_ac_gs_off_lt",0)
sysElectric.acOffLights = CustomAnnunciator:new("acoff",
function () 
	if sysElectric.acOff1Anc:getStatus() == 1 or sysElectric.acOff2Anc:getStatus() == 1 or sysElectric.acOff3Anc:getStatus() == 1 or sysElectric.emerAcOffLAnc:getStatus() == 1 or sysElectric.emerAcOffRAnc:getStatus() == 1 or sysElectric.elecAcGsOffAnc:getStatus() == 1 then
		return 1
	else
		return 0
	end
end)

sysElectric.gen1ArmLight = SimpleAnnunciator:new("gen1arm","Rotate/aircraft/systems/elec_gen1_lt",0)
sysElectric.gen2ArmLight = SimpleAnnunciator:new("gen1arm","Rotate/aircraft/systems/elec_gen2_lt",0)
sysElectric.gen3ArmLight = SimpleAnnunciator:new("gen1arm","Rotate/aircraft/systems/elec_gen3_lt",0)
sysElectric.genArmLights = CustomAnnunciator:new("genarm",
function () 
	if sysElectric.gen1ArmLight:getStatus() == 1 or sysElectric.gen2ArmLight:getStatus() == 1 or sysElectric.gen3ArmLight:getStatus() == 1  then
		return 1
	else
		return 0
	end
end)

sysElectric.acTie1 = SimpleAnnunciator:new("actie1","Rotate/aircraft/systems/elec_ac_1_off_lt",0)
sysElectric.acTie2 = SimpleAnnunciator:new("actie2","Rotate/aircraft/systems/elec_ac_2_off_lt",0)
sysElectric.acTie3 = SimpleAnnunciator:new("actie3","Rotate/aircraft/systems/elec_ac_3_off_lt",0)
sysElectric.acTies = CustomAnnunciator:new("acties",
function () 
	if sysElectric.acTie1:getStatus() == 1 or sysElectric.acTie2:getStatus() == 1 or sysElectric.acTie3:getStatus() == 1  then
		return 1
	else
		return 0
	end
end)

sysElectric.dcTie1 = SimpleAnnunciator:new("dctie1","Rotate/aircraft/systems/elec_dc_1_off_lt",0)
sysElectric.dcTie2 = SimpleAnnunciator:new("dctie2","Rotate/aircraft/systems/elec_dc_2_off_lt",0)
sysElectric.dcTie3 = SimpleAnnunciator:new("dctie3","Rotate/aircraft/systems/elec_dc_3_off_lt",0)
sysElectric.dcTies = CustomAnnunciator:new("dcties",
function () 
	if sysElectric.dcTie1:getStatus() == 1 or sysElectric.dcTie2:getStatus() == 1 or sysElectric.dcTie3:getStatus() == 1  then
		return 1
	else
		return 0
	end
end)

sysElectric.emerPwrOnLight = SimpleAnnunciator:new("emerpwron","Rotate/aircraft/systems/elec_emer_pwr_on_lt",0)

return sysElectric
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_deployablebox_juicebox.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 184 ms
 * Timestamp: 10/27/2023 12:28:23 AM
*******************************************************************/

//Function Number: 1
init()
{
	var_00 = spawnstruct();
	var_00.var_39B = "deployable_vest_marker_mp";
	var_00.modelbase = "afr_mortar_ammo_01";
	var_00.pow = &"KILLSTREAKS_HINTS_DEPLOYABLE_JUICEBOX_PICKUP";
	var_00.var_3A41 = &"KILLSTREAKS_DEPLOYABLE_JUICEBOX_TAKING";
	var_00.var_67E5 = "deployable_juicebox_taken";
	var_00.streakname = "deployable_juicebox";
	var_00.var_10A38 = "used_deployable_juicebox";
	var_00.shadername = "compass_objpoint_deploy_juiced_friendly";
	var_00.headiconoffset = 25;
	var_00.lifespan = 90;
	var_00.usexp = 50;
	var_00.scorepopup = "destroyed_vest";
	var_00.vodestroyed = "ballistic_vest_destroyed";
	var_00.deployedsfx = "mp_vest_deployed_ui";
	var_00.onusesfx = "ammo_crate_use";
	var_00.onusecallback = ::onusedeployable;
	var_00.canusecallback = ::func_3937;
	var_00.usetime = 500;
	var_00.maxhealth = 300;
	var_00.damagefeedback = "deployable_bag";
	var_00.deathweaponinfo = "deployable_ammo_mp";
	var_00.deathvfx = loadfx("vfx/core/mp/killstreaks/vfx_ballistic_vest_death");
	var_00.allowmeleedamage = 1;
	var_00.allowhvtspawn = 0;
	var_00.maxuses = 4;
	level.boxsettings["deployable_juicebox"] = var_00;
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("deployable_juicebox",::func_128E0);
	level.deployable_box["deployable_juicebox"] = [];
}

//Function Number: 2
func_128E0(param_00,param_01)
{
	var_02 = scripts\mp\killstreaks\_deployablebox::begindeployableviamarker(param_00,"deployable_juicebox");
	if(!isdefined(var_02) || !var_02)
	{
		return 0;
	}

	scripts\mp\_matchdata::logkillstreakevent("deployable_juicebox",self.origin);
	return 1;
}

//Function Number: 3
onusedeployable(param_00)
{
	thread scripts\mp\perks\_perkfunctions::setjuiced(15);
}

//Function Number: 4
func_3937(param_00)
{
	return !scripts\mp\_utility::isjuggernaut() && !scripts\mp\perks\_perkfunctions::hasjuiced();
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_deployablebox_grenades.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 210 ms
 * Timestamp: 10/27/2023 12:28:22 AM
*******************************************************************/

//Function Number: 1
init()
{
	var_00 = spawnstruct();
	var_00.var_39B = "deployable_vest_marker_mp";
	var_00.modelbase = "afr_mortar_ammo_01";
	var_00.pow = &"KILLSTREAKS_HINTS_DEPLOYABLE_GRENADES_PICKUP";
	var_00.var_3A41 = &"KILLSTREAKS_DEPLOYABLE_GRENADES_TAKING";
	var_00.var_67E5 = "deployable_grenades_taken";
	var_00.streakname = "deployable_grenades";
	var_00.var_10A38 = "used_deployable_grenades";
	var_00.shadername = "compass_objpoint_deploy_grenades_friendly";
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
	var_00.maxhealth = 150;
	var_00.damagefeedback = "deployable_bag";
	var_00.deathweaponinfo = "deployable_grenades_mp";
	var_00.deathvfx = loadfx("vfx/core/expl/grenadeexp_default");
	var_00.deathdamageradius = 256;
	var_00.deathdamagemax = 150;
	var_00.deathdamagemin = 50;
	var_00.allowmeleedamage = 1;
	var_00.allowhvtspawn = 1;
	var_00.maxuses = 3;
	level.boxsettings["deployable_grenades"] = var_00;
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("deployable_grenades",::func_128DF);
	level.deployable_box["deployable_grenades"] = [];
}

//Function Number: 2
func_128DF(param_00,param_01)
{
	var_02 = scripts\mp\killstreaks\_deployablebox::begindeployableviamarker(param_00,"deployable_grenades");
	if(!isdefined(var_02) || !var_02)
	{
		return 0;
	}

	scripts\mp\_matchdata::logkillstreakevent("deployable_grenades",self.origin);
	return 1;
}

//Function Number: 3
onusedeployable(param_00)
{
	func_DE4E();
}

//Function Number: 4
func_DE4E()
{
	var_00 = self getweaponslistall();
	if(isdefined(var_00))
	{
		foreach(var_02 in var_00)
		{
			if(scripts\mp\_weapons::func_9E18(var_02) || scripts\mp\_weapons::func_9EC0(var_02))
			{
				self givestartammo(var_02);
			}
		}
	}
}

//Function Number: 5
func_3937(param_00)
{
	return !scripts\mp\_utility::isjuggernaut();
}
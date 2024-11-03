/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_deployablebox_vest.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 5
 * Decompile Time: 244 ms
 * Timestamp: 10/27/2023 12:28:24 AM
*******************************************************************/

//Function Number: 1
init()
{
	var_00 = spawnstruct();
	var_00.id = "deployable_vest";
	var_00.var_39B = "deployable_vest_marker_mp";
	var_00.modelbase = "prop_ballistic_vest_iw6";
	var_00.modelbombsquad = "prop_ballistic_vest_iw6_bombsquad";
	var_00.pow = &"KILLSTREAKS_HINTS_LIGHT_ARMOR_PICKUP";
	var_00.var_3A41 = &"KILLSTREAKS_BOX_GETTING_VEST";
	var_00.var_67E5 = "deployable_vest_taken";
	var_00.streakname = "deployable_vest";
	var_00.var_10A38 = "used_deployable_vest";
	var_00.shadername = "compass_objpoint_deploy_friendly";
	var_00.headiconoffset = 20;
	var_00.lifespan = 90;
	var_00.usexp = 50;
	var_00.scorepopup = "destroyed_vest";
	var_00.vodestroyed = "ballistic_vest_destroyed";
	var_00.deployedsfx = "mp_vest_deployed_ui";
	var_00.onusesfx = "ammo_crate_use";
	var_00.onusecallback = ::onusedeployable;
	var_00.canusecallback = ::func_3937;
	var_00.usetime = 1000;
	var_00.maxhealth = 220;
	var_00.damagefeedback = "deployable_bag";
	var_00.deathvfx = loadfx("vfx/core/mp/killstreaks/vfx_ballistic_vest_death");
	var_00.allowmeleedamage = 1;
	var_00.allowhvtspawn = 0;
	var_00.maxuses = 4;
	var_00.canuseotherboxes = 0;
	level.boxsettings["deployable_vest"] = var_00;
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("deployable_vest",::func_128E1);
	level.deployable_box["deployable_vest"] = [];
}

//Function Number: 2
func_128E1(param_00,param_01)
{
	var_02 = scripts\mp\killstreaks\_deployablebox::begindeployableviamarker(param_00,"deployable_vest");
	if(!isdefined(var_02) || !var_02)
	{
		return 0;
	}

	scripts\mp\_matchdata::logkillstreakevent("deployable_vest",self.origin);
	return 1;
}

//Function Number: 3
func_3937(param_00)
{
	return !scripts\mp\_lightarmor::haslightarmor(self) && !scripts\mp\_utility::isjuggernaut();
	if(isdefined(param_00) && param_00.triggerportableradarping == self && !isdefined(param_00.var_1A64))
	{
		return 0;
	}

	return !scripts\mp\_utility::isjuggernaut();
}

//Function Number: 4
onusedeployable(param_00)
{
	scripts\mp\perks\_perkfunctions::setlightarmor();
}

//Function Number: 5
get_adjusted_armor(param_00,param_01)
{
	if(param_00 + level.deployablebox_vest_rank[param_01] > level.deployablebox_vest_max)
	{
		return level.deployablebox_vest_max;
	}

	return param_00 + level.deployablebox_vest_rank[param_01];
}
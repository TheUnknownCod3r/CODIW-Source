/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_deployable_speed_strip.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 98 ms
 * Timestamp: 10/27/2023 12:28:19 AM
*******************************************************************/

//Function Number: 1
init()
{
	var_00 = spawnstruct();
	var_00.id = "deployable_speed_strip";
	var_00.var_39B = "deployable_speed_strip_marker_mp";
	var_00.streakname = "deployable_speed_strip";
	var_00.grenadeusefunc = ::scripts\mp\_speedboost::func_109C1;
	level.boxsettings["deployable_speed_strip"] = var_00;
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("deployable_speed_strip",::func_128DD);
}

//Function Number: 2
func_128DD(param_00,param_01)
{
	var_02 = scripts\mp\killstreaks\_deployablebox::begindeployableviamarker(param_00,"deployable_speed_strip");
	if(!isdefined(var_02) || !var_02)
	{
		return 0;
	}

	scripts\mp\_matchdata::logkillstreakevent("deployable_speed_strip",self.origin);
	return 1;
}
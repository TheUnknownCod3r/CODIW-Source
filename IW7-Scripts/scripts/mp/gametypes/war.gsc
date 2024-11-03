/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\war.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 8
 * Decompile Time: 414 ms
 * Timestamp: 10/27/2023 12:13:12 AM
*******************************************************************/

//Function Number: 1
main()
{
	if(getdvar("mapname") == "mp_background")
	{
		return;
	}

	scripts\mp\_globallogic::init();
	scripts\mp\_globallogic::setupcallbacks();
	if(function_011C())
	{
		level.initializematchrules = ::initializematchrules;
		[[ level.initializematchrules ]]();
		level thread scripts\mp\_utility::reinitializematchrulesonmigration();
	}
	else
	{
		scripts\mp\_utility::registerroundswitchdvar(level.gametype,0,0,9);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,10);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,75);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	updategametypedvars();
	level.teambased = 1;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onnormaldeath = ::onnormaldeath;
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "team_deathmatch";
	if(getdvarint("g_hardcore"))
	{
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	}
	else if(getdvarint("camera_thirdPerson"))
	{
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	}
	else if(getdvarint("scr_diehard"))
	{
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	}
	else if(getdvarint("scr_" + level.gametype + "_promode"))
	{
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	}

	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_war_halftime",0);
	scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
	setdynamicdvar("scr_war_promode",0);
}

//Function Number: 3
onstartgametype()
{
	setclientnamemode("auto_change");
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}

	if(game["switchedsides"])
	{
		var_00 = game["attackers"];
		var_01 = game["defenders"];
		game["attackers"] = var_01;
		game["defenders"] = var_00;
	}

	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_WAR");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_WAR");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_WAR");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_WAR");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_WAR_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_WAR_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_WAR_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_WAR_HINT");
	initspawns();
	var_02[0] = level.gametype;
	scripts\mp\_gameobjects::main(var_02);
}

//Function Number: 4
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
}

//Function Number: 5
initspawns()
{
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::setactivespawnlogic("TDM");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_tdm_spawn_allies_start");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_tdm_spawn_axis_start");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn_secondary",1,1);
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn_secondary",1,1);
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 6
getspawnpoint()
{
	var_00 = self.pers["team"];
	if(game["switchedsides"])
	{
		var_00 = scripts\mp\_utility::getotherteam(var_00);
	}

	if(scripts\mp\_spawnlogic::shoulduseteamstartspawn())
	{
		var_01 = scripts\mp\_spawnlogic::getspawnpointarray("mp_tdm_spawn_" + var_00 + "_start");
		var_02 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_01);
	}
	else
	{
		var_01 = scripts\mp\_spawnlogic::getteamspawnpoints(var_02);
		var_03 = scripts\mp\_spawnlogic::getteamfallbackspawnpoints(var_01);
		var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_01,var_03);
	}

	return var_02;
}

//Function Number: 7
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	scripts\mp\gametypes\common::onnormaldeath(param_00,param_01,param_02,param_03,param_04);
}

//Function Number: 8
ontimelimit()
{
	if(game["status"] == "overtime")
	{
		var_00 = "forfeit";
	}
	else if(game["teamScores"]["allies"] == game["teamScores"]["axis"])
	{
		var_00 = "overtime";
	}
	else if(game["teamScores"]["axis"] > game["teamScores"]["allies"])
	{
		var_00 = "axis";
	}
	else
	{
		var_00 = "allies";
	}

	thread scripts\mp\_gamelogic::endgame(var_00,game["end_reason"]["time_limit_reached"]);
}
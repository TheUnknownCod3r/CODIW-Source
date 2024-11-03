/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\dom.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 32
 * Decompile Time: 1597 ms
 * Timestamp: 10/27/2023 12:12:29 AM
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
		scripts\mp\_utility::registertimelimitdvar(level.gametype,30);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,200);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,2);
		scripts\mp\_utility::registerroundswitchdvar("dom",1,0,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,0);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	updategametypedvars();
	level.teambased = 1;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onplayerkilled = ::onplayerkilled;
	level.onspawnplayer = ::onspawnplayer;
	level.lastcaptime = gettime();
	level.onobjectivecomplete = ::onflagcapture;
	level.alliescapturing = [];
	level.axiscapturing = [];
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "domination";
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

	game["dialog"]["offense_obj"] = "capture_objs";
	game["dialog"]["defense_obj"] = "capture_objs";
	thread onplayerconnect();
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_dom_flagCaptureTime",getmatchrulesdata("domData","flagCaptureTime"));
	setdynamicdvar("scr_dom_flagsRequiredToScore",getmatchrulesdata("domData","flagsRequiredToScore"));
	setdynamicdvar("scr_dom_pointsPerFlag",getmatchrulesdata("domData","pointsPerFlag"));
	setdynamicdvar("scr_dom_flagNeutralization",getmatchrulesdata("domData","flagNeutralization"));
	setdynamicdvar("scr_dom_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("dom",0);
	setdynamicdvar("scr_dom_promode",0);
}

//Function Number: 3
seticonnames()
{
	level.iconneutral = "waypoint_captureneutral";
	level.iconcapture = "waypoint_capture";
	level.icondefend = "waypoint_defend";
	level.iconcontested = "waypoint_contested";
	level.icontaking = "waypoint_taking";
	level.iconlosing = "waypoint_losing";
}

//Function Number: 4
onstartgametype()
{
	seticonnames();
	scripts\mp\_utility::setobjectivetext("allies",&"OBJECTIVES_DOM");
	scripts\mp\_utility::setobjectivetext("axis",&"OBJECTIVES_DOM");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_DOM");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_DOM");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",&"OBJECTIVES_DOM_SCORE");
		scripts\mp\_utility::setobjectivescoretext("axis",&"OBJECTIVES_DOM_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext("allies",&"OBJECTIVES_DOM_HINT");
	scripts\mp\_utility::setobjectivehinttext("axis",&"OBJECTIVES_DOM_HINT");
	setclientnamemode("auto_change");
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}

	initspawns();
	var_00[0] = "dom";
	scripts\mp\_gameobjects::main(var_00);
	thread domflags();
	thread updatedomscores();
	thread removedompoint();
	thread placedompoint();
}

//Function Number: 5
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.flagcapturetime = scripts\mp\_utility::dvarfloatvalue("flagCaptureTime",10,0,30);
	level.var_6E7B = scripts\mp\_utility::dvarintvalue("flagsRequiredToScore",1,1,3);
	level.var_D649 = scripts\mp\_utility::dvarintvalue("pointsPerFlag",1,1,300);
	level.flagneutralization = scripts\mp\_utility::dvarintvalue("flagNeutralization",0,0,1);
}

//Function Number: 6
initspawns()
{
	scripts\mp\_spawnlogic::setactivespawnlogic("Domination");
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_dom_spawn_allies_start");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_dom_spawn_axis_start");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_dom_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("allies","mp_dom_spawn_secondary",1,1);
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_dom_spawn");
	scripts\mp\_spawnlogic::addspawnpoints("axis","mp_dom_spawn_secondary",1,1);
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 7
getspawnpoint()
{
	var_00 = self.pers["team"];
	var_01 = scripts\mp\_utility::getotherteam(var_00);
	if(level.usestartspawns)
	{
		if(game["switchedsides"])
		{
			var_02 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dom_spawn_" + var_01 + "_start");
			var_03 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_02);
		}
		else
		{
			var_02 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dom_spawn_" + var_02 + "_start");
			var_03 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_03);
		}
	}
	else
	{
		var_04 = getteamdompoints(var_02);
		var_05 = scripts\mp\_utility::getotherteam(var_00);
		var_06 = getteamdompoints(var_05);
		var_07 = getpreferreddompoints(var_04,var_06);
		var_02 = scripts\mp\_spawnlogic::getteamspawnpoints(var_00);
		var_08 = scripts\mp\_spawnlogic::getteamfallbackspawnpoints(var_00);
		var_09 = [];
		var_09["preferredDomPoints"] = var_07;
		var_03 = scripts\mp\_spawnscoring::getspawnpoint(var_02,var_08,var_09);
	}

	return var_03;
}

//Function Number: 8
getteamdompoints(param_00)
{
	var_01 = [];
	foreach(var_03 in level.domflags)
	{
		if(var_03.ownerteam == param_00)
		{
			var_01[var_01.size] = var_03;
		}
	}

	return var_01;
}

//Function Number: 9
getpreferreddompoints(param_00,param_01)
{
	var_02 = [];
	var_02[0] = 0;
	var_02[1] = 0;
	var_02[2] = 0;
	var_03 = self.pers["team"];
	if(param_00.size == level.domflags.size)
	{
		var_04 = var_03;
		var_05 = level.bestspawnflag[var_03];
		var_02[var_05.useobj.dompointnumber] = 1;
		return var_02;
	}

	if(var_02.size == 1 && var_03.size == 2 && !scripts\mp\_utility::isanymlgmatch())
	{
		var_06 = scripts\mp\_utility::getotherteam(self.team);
		var_07 = scripts\mp\_gamescore::_getteamscore(var_06) - scripts\mp\_gamescore::_getteamscore(self.team);
		if(var_07 > 15)
		{
			var_08 = gettimesincedompointcapture(var_02[0]);
			var_09 = gettimesincedompointcapture(var_03[0]);
			var_0A = gettimesincedompointcapture(var_03[1]);
			if(var_08 > -25536 && var_09 > -25536 && var_0A > -25536)
			{
				return var_04;
			}
		}
	}

	if(var_02.size > 0)
	{
		foreach(var_0C in var_02)
		{
			var_04[var_0C.dompointnumber] = 1;
		}

		return var_04;
	}

	if(var_05.size == 0)
	{
		var_04 = var_0D;
		var_05 = level.bestspawnflag[var_0D];
		if(var_04.size > 0 && var_04.size < level.domflags.size)
		{
			var_0D = _meth_81EF(var_0C);
			level.bestspawnflag[var_0C] = var_0D;
		}

		var_05[var_0D.useobj.dompointnumber] = 1;
		return var_05;
	}

	return var_0C;
}

//Function Number: 10
gettimesincedompointcapture(param_00)
{
	return gettime() - param_00.capturetime;
}

//Function Number: 11
domflags()
{
	scripts\mp\_utility::func_98D3();
	var_00 = getentarray("flag_primary","targetname");
	var_01 = getentarray("flag_secondary","targetname");
	if(var_00.size + var_01.size < 2)
	{
		return;
	}

	level.magicbullet = [];
	for(var_02 = 0;var_02 < var_00.size;var_02++)
	{
		level.magicbullet[level.magicbullet.size] = var_00[var_02];
	}

	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		level.magicbullet[level.magicbullet.size] = var_01[var_02];
	}

	level.domflags = [];
	level.objectives = level.magicbullet;
	if(level.mapname == "mp_afghan")
	{
		for(var_02 = 0;var_02 < level.objectives.size;var_02++)
		{
			if(level.objectives[var_02].script_label == "_c")
			{
				level.objectives[var_02].script_label = "_b";
				continue;
			}

			if(level.objectives[var_02].script_label == "_b")
			{
				level.objectives[var_02].script_label = "_c";
			}
		}
	}

	for(var_02 = 0;var_02 < level.magicbullet.size;var_02++)
	{
		var_03 = scripts\mp\gametypes\obj_dom::func_591D(var_02);
		level.magicbullet[var_02].useobj = var_03;
		var_03.levelflag = level.magicbullet[var_02];
		level.domflags[level.domflags.size] = var_03;
	}

	var_04 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dom_spawn_axis_start");
	var_05 = scripts\mp\_spawnlogic::getspawnpointarray("mp_dom_spawn_allies_start");
	level.areanynavvolumesloaded["allies"] = var_05[0].origin;
	level.areanynavvolumesloaded["axis"] = var_04[0].origin;
	level.bestspawnflag = [];
	level.bestspawnflag["allies"] = _meth_81EF("allies",undefined);
	level.bestspawnflag["axis"] = _meth_81EF("axis",level.bestspawnflag["allies"]);
	flagsetup();
	thread modifieddefendradiussetup();
}

//Function Number: 12
_meth_81EF(param_00,param_01)
{
	var_02 = undefined;
	var_03 = undefined;
	for(var_04 = 0;var_04 < level.magicbullet.size;var_04++)
	{
		var_05 = level.magicbullet[var_04];
		if(var_05 getflagteam() != "neutral")
		{
			continue;
		}

		var_06 = distancesquared(var_05.origin,level.areanynavvolumesloaded[param_00]);
		if((!isdefined(param_01) || var_05 != param_01) && !isdefined(var_02) || var_06 < var_03)
		{
			var_03 = var_06;
			var_02 = var_05;
		}
	}

	return var_02;
}

//Function Number: 13
updatedomscores()
{
	level endon("game_ended");
	var_00 = undefined;
	var_01 = undefined;
	while(!level.gameended)
	{
		var_02 = getowneddomflags();
		if(!isdefined(level.var_EC50))
		{
			level.var_EC50 = [];
		}

		level.var_EC50["allies"] = 0;
		level.var_EC50["axis"] = 0;
		if(var_02.size)
		{
			for(var_03 = 1;var_03 < var_02.size;var_03++)
			{
				var_04 = var_02[var_03];
				var_05 = gettime() - var_04.capturetime;
				for(var_06 = var_03 - 1;var_06 >= 0 && var_05 > gettime() - var_02[var_06].capturetime;var_06--)
				{
					var_02[var_06 + 1] = var_02[var_06];
				}

				var_02[var_06 + 1] = var_04;
			}

			foreach(var_04 in var_02)
			{
				var_08 = var_04 scripts\mp\_gameobjects::getownerteam();
				var_09 = scripts\mp\_utility::getotherteam(var_08);
				var_00 = getteamscore(var_08);
				var_01 = getteamscore(var_09);
				var_0A = getteamflagcount(var_08);
				if(var_0A >= level.var_6E7B)
				{
					level.var_EC50[var_08] = level.var_EC50[var_08] + level.var_D649;
				}
			}
		}

		updatescores();
		checkendgame(var_02.size);
		wait(5);
		scripts\mp\_hostmigration::waittillhostmigrationdone();
	}
}

//Function Number: 14
updatescores()
{
	var_00 = level.roundscorelimit;
	var_01 = game["teamScores"]["allies"] + level.var_EC50["allies"];
	var_02 = game["teamScores"]["axis"] + level.var_EC50["axis"];
	var_03 = var_01 >= var_00;
	var_04 = var_02 >= var_00;
	if(var_03 && !var_04)
	{
		level.var_EC50["allies"] = var_00 - game["teamScores"]["allies"];
	}
	else if(var_04 && !var_03)
	{
		level.var_EC50["axis"] = var_00 - game["teamScores"]["axis"];
	}

	if(level.var_EC50["allies"] > 0)
	{
		scripts\mp\_gamescore::giveteamscoreforobjective("allies",level.var_EC50["allies"],1);
	}

	if(level.var_EC50["axis"] > 0)
	{
		scripts\mp\_gamescore::giveteamscoreforobjective("axis",level.var_EC50["axis"],1);
	}
}

//Function Number: 15
checkendgame(param_00)
{
	var_01 = gettime() - level.lastcaptime;
	if(scripts\mp\_utility::matchmakinggame() && param_00 < 2 && var_01 > 120000)
	{
		level.var_72B3 = 1;
		thread scripts\mp\_gamelogic::endgame("none",game["end_reason"]["time_limit_reached"]);
	}
}

//Function Number: 16
onplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(!isplayer(param_01) || param_01.team == self.team)
	{
		return;
	}

	if(isdefined(param_04) && scripts\mp\_utility::iskillstreakweapon(param_04))
	{
		return;
	}

	var_0A = 0;
	var_0B = 0;
	var_0C = 0;
	var_0D = self;
	var_0E = var_0D.team;
	var_0F = var_0D.origin;
	var_10 = param_01.team;
	var_11 = param_01.origin;
	var_12 = 0;
	if(isdefined(param_00))
	{
		var_11 = param_00.origin;
		var_12 = param_00 == param_01;
	}

	foreach(var_14 in param_01.touchtriggers)
	{
		if(var_14 != level.magicbullet[0] && var_14 != level.magicbullet[1] && var_14 != level.magicbullet[2])
		{
			continue;
		}

		var_15 = var_14.useobj.ownerteam;
		if(var_10 != var_15)
		{
			if(!var_0A)
			{
				var_0A = 1;
			}

			continue;
		}
	}

	foreach(var_14 in level.magicbullet)
	{
		var_15 = var_14.useobj.ownerteam;
		if(var_15 == "neutral")
		{
			var_18 = param_01 istouching(var_14);
			var_19 = var_0D istouching(var_14);
			if(var_18 || var_19)
			{
				if(var_14.useobj.claimteam == var_0E)
				{
					if(!var_0B)
					{
						if(var_0A)
						{
							param_01 thread scripts\mp\_utility::giveunifiedpoints("capture_kill");
						}

						var_0B = 1;
						param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_assault");
						thread scripts\mp\_matchdata::loginitialstats(param_09,"assaulting");
						continue;
					}
				}
				else if(var_14.useobj.claimteam == var_10)
				{
					if(!var_0C)
					{
						if(var_0A)
						{
							param_01 thread scripts\mp\_utility::giveunifiedpoints("capture_kill");
						}

						var_0C = 1;
						param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_defend");
						param_01 scripts\mp\_utility::incperstat("defends",1);
						param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
						param_01 scripts\mp\_utility::setextrascore1(param_01.pers["defends"]);
						thread scripts\mp\_matchdata::loginitialstats(param_09,"defending");
						continue;
					}
				}
			}

			continue;
		}

		if(var_15 != var_10)
		{
			if(!var_0B)
			{
				var_1A = distsquaredcheck(var_14,var_11,var_0F);
				if(var_1A)
				{
					if(var_0A)
					{
						param_01 thread scripts\mp\_utility::giveunifiedpoints("capture_kill");
					}

					var_0B = 1;
					param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_assault");
					thread scripts\mp\_matchdata::loginitialstats(param_09,"assaulting");
					continue;
				}
			}

			continue;
		}

		if(!var_0C)
		{
			var_1B = distsquaredcheck(var_14,var_11,var_0F);
			if(var_1B)
			{
				if(var_0A)
				{
					param_01 thread scripts\mp\_utility::giveunifiedpoints("capture_kill");
				}

				var_0C = 1;
				param_01 thread scripts\mp\_awards::givemidmatchaward("mode_x_defend");
				param_01 scripts\mp\_utility::incperstat("defends",1);
				param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
				param_01 scripts\mp\_utility::setextrascore1(param_01.pers["defends"]);
				thread scripts\mp\_matchdata::loginitialstats(param_09,"defending");
				continue;
			}
		}
	}
}

//Function Number: 17
distsquaredcheck(param_00,param_01,param_02)
{
	var_03 = distancesquared(param_00.origin,param_01);
	var_04 = distancesquared(param_00.origin,param_02);
	if(var_03 < 105625 || var_04 < 105625)
	{
		if(!isdefined(param_00.modifieddefendcheck))
		{
			return 1;
		}

		if(param_01[2] - param_00.origin[2] < 100 || param_02[2] - param_00.origin[2] < 100)
		{
			return 1;
		}

		return 0;
	}

	return 0;
}

//Function Number: 18
getowneddomflags()
{
	var_00 = [];
	foreach(var_02 in level.domflags)
	{
		if(var_02 scripts\mp\_gameobjects::getownerteam() != "neutral" && isdefined(var_02.capturetime))
		{
			var_00[var_00.size] = var_02;
		}
	}

	return var_00;
}

//Function Number: 19
getteamflagcount(param_00)
{
	var_01 = 0;
	for(var_02 = 0;var_02 < level.magicbullet.size;var_02++)
	{
		if(level.domflags[var_02] scripts\mp\_gameobjects::getownerteam() == param_00)
		{
			var_01++;
		}
	}

	return var_01;
}

//Function Number: 20
getflagteam()
{
	return self.useobj scripts\mp\_gameobjects::getownerteam();
}

//Function Number: 21
flagsetup()
{
	foreach(var_01 in level.domflags)
	{
		switch(var_01.label)
		{
			case "_a":
				var_01.dompointnumber = 0;
				break;

			case "_b":
				var_01.dompointnumber = 1;
				break;

			case "_c":
				var_01.dompointnumber = 2;
				break;
		}
	}

	var_03 = level.spawnpoints;
	foreach(var_05 in var_03)
	{
		var_05.dompointa = 0;
		var_05.dompointb = 0;
		var_05.dompointc = 0;
		var_05.nearflagpoint = getnearestflagpoint(var_05);
		switch(var_05.nearflagpoint.useobj.dompointnumber)
		{
			case 0:
				var_05.dompointa = 1;
				break;

			case 1:
				var_05.dompointb = 1;
				break;

			case 2:
				var_05.dompointc = 1;
				break;
		}
	}
}

//Function Number: 22
getnearestflagpoint(param_00)
{
	var_01 = scripts\mp\_spawnlogic::ispathdataavailable();
	var_02 = undefined;
	var_03 = undefined;
	foreach(var_05 in level.domflags)
	{
		var_06 = undefined;
		if(var_01)
		{
			var_06 = function_00C0(param_00.origin,var_05.levelflag.origin,999999);
		}

		if(!isdefined(var_06) || var_06 == -1)
		{
			var_06 = distancesquared(var_05.levelflag.origin,param_00.origin);
		}

		if(!isdefined(var_02) || var_06 < var_03)
		{
			var_02 = var_05;
			var_03 = var_06;
		}
	}

	return var_02.levelflag;
}

//Function Number: 23
modifieddefendradiussetup()
{
	if(level.mapname == "mp_frontier")
	{
		foreach(var_01 in level.magicbullet)
		{
			if(var_01.script_label == "_b")
			{
				var_01.modifieddefendcheck = 1;
			}
		}
	}
}

//Function Number: 24
onspawnplayer()
{
}

//Function Number: 25
giveflagcapturexp(param_00)
{
	level endon("game_ended");
	var_01 = scripts\mp\_gameobjects::getearliestclaimplayer();
	if(isdefined(var_01.triggerportableradarping))
	{
		var_01 = var_01.triggerportableradarping;
	}

	level.lastcaptime = gettime();
	if(isplayer(var_01))
	{
		level thread scripts\mp\_utility::teamplayercardsplash("callout_securedposition" + self.label,var_01);
		var_01 thread scripts\mp\_matchdata::loggameevent("capture",var_01.origin);
	}

	if(self.firstcapture == 1)
	{
		var_02 = 1;
	}
	else
	{
		var_02 = 0;
	}

	var_03 = getarraykeys(param_00);
	for(var_04 = 0;var_04 < var_03.size;var_04++)
	{
		var_05 = param_00[var_03[var_04]].player;
		if(isdefined(var_05.triggerportableradarping))
		{
			var_05 = var_05.triggerportableradarping;
		}

		if(!isplayer(var_05))
		{
			continue;
		}

		var_05 thread updatecpm();
		var_05 scripts\mp\_utility::incperstat("captures",1);
		var_05 scripts\mp\_persistence::statsetchild("round","captures",var_05.pers["captures"]);
		var_05 scripts\mp\_missions::processchallenge("ch_domcap");
		var_05 scripts\mp\_utility::setextrascore0(var_05.pers["captures"]);
		if(var_02)
		{
			if(self.label == "_b")
			{
				var_05 thread scripts\mp\_awards::givemidmatchaward("mode_dom_secure_b");
			}
			else
			{
				var_05 thread scripts\mp\_awards::givemidmatchaward("mode_dom_secure_neutral");
			}
		}
		else if(level.flagneutralization)
		{
			var_05 thread scripts\mp\_awards::givemidmatchaward("mode_dom_neutralized_cap");
		}
		else
		{
			var_05 thread scripts\mp\_awards::givemidmatchaward("mode_dom_secure");
		}

		var_05 scripts\mp\gametypes\obj_dom::setcrankedtimerdomflag(var_05);
		wait(0.05);
	}
}

//Function Number: 26
updatecpm()
{
	if(!isdefined(self.cpm))
	{
		self.numcaps = 0;
		self.cpm = 0;
	}

	self.var_C21D++;
	if(scripts\mp\_utility::getminutespassed() < 1)
	{
		return;
	}

	self.cpm = self.numcaps / scripts\mp\_utility::getminutespassed();
}

//Function Number: 27
getcapxpscale()
{
	if(self.cpm < 4)
	{
		return 1;
	}

	return 0.25;
}

//Function Number: 28
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00.ui_dom_securing = undefined;
		var_00.ui_dom_stalemate = undefined;
		var_00 thread onplayerspawned();
	}
}

//Function Number: 29
onplayerspawned(param_00)
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned");
		scripts\mp\_utility::setextrascore0(0);
		if(isdefined(self.pers["captures"]))
		{
			scripts\mp\_utility::setextrascore0(self.pers["captures"]);
		}

		scripts\mp\_utility::setextrascore1(0);
		if(isdefined(self.pers["defends"]))
		{
			scripts\mp\_utility::setextrascore1(self.pers["defends"]);
		}
	}
}

//Function Number: 30
onflagcapture(param_00,param_01,param_02,param_03,param_04,param_05)
{
	level.usestartspawns = 0;
	var_06 = scripts\mp\_utility::getotherteam(param_03);
	thread scripts\mp\_utility::printandsoundoneveryone(param_03,var_06,undefined,undefined,"mp_dom_flag_captured","mp_dom_flag_lost",param_02);
	if(getteamflagcount(param_03) < level.magicbullet.size)
	{
		scripts\mp\_utility::statusdialog("secured" + self.label,param_03,1);
		scripts\mp\_utility::statusdialog("enemy_has" + self.label,var_06,1);
	}
	else
	{
		scripts\mp\_utility::statusdialog("secure_all",param_03);
		scripts\mp\_utility::statusdialog("lost_all",var_06);
		foreach(var_08 in level.players)
		{
			if(var_08.team == param_03)
			{
				var_08 scripts\mp\_missions::processchallenge("ch_domdom");
			}
		}
	}

	if(param_05.touchlist[param_03].size == 0)
	{
		param_05.touchlist = param_05.var_C405;
	}

	param_05 thread giveflagcapturexp(param_05.touchlist[param_03]);
}

//Function Number: 31
removedompoint()
{
	self endon("game_ended");
	for(;;)
	{
		if(getdvar("scr_devRemoveDomFlag","") != "")
		{
			var_00 = getdvar("scr_devRemoveDomFlag","");
			foreach(var_02 in level.domflags)
			{
				if(isdefined(var_02.label) && var_02.label == var_00)
				{
					var_02 scripts\mp\_gameobjects::allowuse("none");
					var_02.trigger = undefined;
					var_02 notify("deleted");
					var_02.visibleteam = "none";
					var_02 scripts\mp\_gameobjects::setzonestatusicons(undefined);
					var_03 = [];
					for(var_04 = 0;var_04 < level.magicbullet.size;var_04++)
					{
						if(level.magicbullet[var_04].script_label != var_00)
						{
							var_03[var_03.size] = level.magicbullet[var_04];
						}
					}

					level.magicbullet = var_03;
					level.objectives = level.magicbullet;
					var_03 = [];
					for(var_04 = 0;var_04 < level.domflags.size;var_04++)
					{
						if(level.domflags[var_04].label != var_00)
						{
							var_03[var_03.size] = level.domflags[var_04];
						}
					}

					level.domflags = var_03;
					break;
				}
			}

			setdynamicdvar("scr_devRemoveDomFlag","");
		}

		wait(1);
	}
}

//Function Number: 32
placedompoint()
{
	self endon("game_ended");
	for(;;)
	{
		if(getdvar("scr_devPlaceDomFlag","") != "")
		{
			var_00 = getdvar("scr_devPlaceDomFlag","");
			var_01 = spawnstruct();
			var_01.origin = level.players[0].origin;
			var_01.angles = level.players[0].angles;
			var_02 = spawn("trigger_radius",var_01.origin,0,120,128);
			var_01.trigger = var_02;
			var_01.trigger.script_label = var_00;
			var_01.ownerteam = "neutral";
			var_03 = var_01.origin + (0,0,32);
			var_04 = var_01.origin + (0,0,-32);
			var_05 = bullettrace(var_03,var_04,0,undefined);
			var_01.origin = var_05["position"];
			var_01.upangles = vectortoangles(var_05["normal"]);
			var_01.missionfailed = anglestoforward(var_01.upangles);
			var_01.setdebugorigin = anglestoright(var_01.upangles);
			var_01.visuals[0] = spawn("script_model",var_01.origin);
			var_01.visuals[0].angles = var_01.angles;
			level.magicbullet[level.magicbullet.size] = var_01;
			level.objectives = level.magicbullet;
			var_06 = scripts\mp\_gameobjects::createuseobject("neutral",var_01.trigger,var_01.visuals,(0,0,100));
			var_06 scripts\mp\_gameobjects::allowuse("enemy");
			var_06 scripts\mp\_gameobjects::setusetime(10);
			var_06 scripts\mp\_gameobjects::setusetext(&"MP_SECURING_POSITION");
			var_07 = var_00;
			var_06.label = var_07;
			var_06 scripts\mp\_gameobjects::setzonestatusicons(level.icondefend + var_07,level.iconneutral + var_07);
			var_06 scripts\mp\_gameobjects::setvisibleteam("any");
			var_06.onuse = ::scripts\mp\gametypes\obj_dom::dompoint_onuse;
			var_06.onbeginuse = ::scripts\mp\gametypes\obj_dom::dompoint_onusebegin;
			var_06.onuseupdate = ::scripts\mp\gametypes\obj_dom::dompoint_onuseupdate;
			var_06.onenduse = ::scripts\mp\gametypes\obj_dom::dompoint_onuseend;
			var_06.nousebar = 1;
			var_06.id = "domFlag";
			var_06.firstcapture = 1;
			var_06.claimgracetime = 10000;
			var_06.decayrate = 50;
			var_03 = var_01.visuals[0].origin + (0,0,32);
			var_04 = var_01.visuals[0].origin + (0,0,-32);
			var_08 = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
			var_09 = [];
			var_05 = scripts\common\trace::ray_trace(var_03,var_04,var_09,var_08);
			var_06.baseeffectpos = var_05["position"];
			var_0A = vectortoangles(var_05["normal"]);
			var_06.baseeffectforward = anglestoforward(var_0A);
			var_06 scripts\mp\gametypes\obj_dom::initializematchrecording();
			var_06 thread scripts\mp\gametypes\obj_dom::domflag_setneutral();
			for(var_0B = 0;var_0B < level.magicbullet.size;var_0B++)
			{
				level.magicbullet[var_0B].useobj = var_06;
				var_06.levelflag = level.magicbullet[var_0B];
			}

			level.domflags[level.domflags.size] = var_06;
			setdynamicdvar("scr_devPlaceDomFlag","");
		}

		wait(1);
	}
}
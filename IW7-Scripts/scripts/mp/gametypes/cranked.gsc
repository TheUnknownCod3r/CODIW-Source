/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\cranked.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 19
 * Decompile Time: 950 ms
 * Timestamp: 10/27/2023 12:12:21 AM
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
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,100);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,1);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,1);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,0);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	level.teambased = getdvarint("scr_cranked_teambased",1) == 1;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onnormaldeath = ::onnormaldeath;
	if(!level.teambased)
	{
		level.onplayerscore = ::onplayerscore;
		setdvar("scr_cranked_scorelimit",getdvarint("scr_cranked_scorelimit_ffa",60));
		function_01CC("ffa");
	}

	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "cranked";
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

	game["dialog"]["offense_obj"] = "crnk_hint";
	game["dialog"]["begin_cranked"] = "crnk_cranked";
	game["dialog"]["five_seconds_left"] = "crnk_det";
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
	level thread onplayerconnect();
}

//Function Number: 2
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread onplayerspawned();
	}
}

//Function Number: 3
onplayerspawned()
{
	self endon("disconnect");
	self waittill("spawned_player");
}

//Function Number: 4
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_cranked_roundswitch",0);
	scripts\mp\_utility::registerroundswitchdvar("cranked",0,0,9);
	setdynamicdvar("scr_cranked_roundlimit",1);
	scripts\mp\_utility::registerroundlimitdvar("cranked",1);
	setdynamicdvar("scr_cranked_winlimit",1);
	scripts\mp\_utility::registerwinlimitdvar("cranked",1);
	setdynamicdvar("scr_cranked_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("cranked",0);
	setdynamicdvar("scr_cranked_promode",0);
}

//Function Number: 5
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

	var_02 = &"OBJECTIVES_WAR";
	var_03 = &"OBJECTIVES_WAR_SCORE";
	var_04 = &"OBJECTIVES_WAR_HINT";
	if(!level.teambased)
	{
		var_02 = &"OBJECTIVES_DM";
		var_03 = &"OBJECTIVES_DM_SCORE";
		var_04 = &"OBJECTIVES_DM_HINT";
	}

	scripts\mp\_utility::setobjectivetext("allies",var_02);
	scripts\mp\_utility::setobjectivetext("axis",var_02);
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext("allies",var_02);
		scripts\mp\_utility::setobjectivescoretext("axis",var_02);
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext("allies",var_03);
		scripts\mp\_utility::setobjectivescoretext("axis",var_03);
	}

	scripts\mp\_utility::setobjectivehinttext("allies",var_04);
	scripts\mp\_utility::setobjectivehinttext("axis",var_04);
	initspawns();
	cranked();
	var_05[0] = level.gametype;
	scripts\mp\_gameobjects::main(var_05);
}

//Function Number: 6
initspawns()
{
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	if(level.teambased)
	{
		scripts\mp\_spawnlogic::setactivespawnlogic("TDM");
		scripts\mp\_spawnlogic::addstartspawnpoints("mp_tdm_spawn_allies_start");
		scripts\mp\_spawnlogic::addstartspawnpoints("mp_tdm_spawn_axis_start");
		scripts\mp\_spawnlogic::addspawnpoints("allies","mp_tdm_spawn");
		scripts\mp\_spawnlogic::addspawnpoints("axis","mp_tdm_spawn");
	}
	else
	{
		scripts\mp\_spawnlogic::setactivespawnlogic("FreeForAll");
		scripts\mp\_spawnlogic::addspawnpoints("allies","mp_dm_spawn");
		scripts\mp\_spawnlogic::addspawnpoints("axis","mp_dm_spawn");
	}

	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 7
getspawnpoint()
{
	if(level.teambased)
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
			var_01 = scripts\mp\_spawnlogic::getteamspawnpoints(var_00);
			var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_01);
		}
	}
	else
	{
		var_01 = scripts\mp\_spawnlogic::getteamspawnpoints(self.team);
		if(level.ingraceperiod)
		{
			var_02 = scripts\mp\_spawnlogic::getspawnpoint_random(var_02);
		}
		else
		{
			var_02 = scripts\mp\_spawnscoring::getspawnpoint(var_02);
		}
	}

	return var_02;
}

//Function Number: 8
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(param_00.cranked) && param_01 scripts\mp\_utility::isenemy(param_00))
	{
		param_01 scripts\mp\_missions::processchallenge("ch_cranky");
	}

	param_00 cleanupcrankedtimer();
	var_05 = scripts\mp\_rank::getscoreinfovalue("score_increment");
	if(isdefined(param_01.cranked))
	{
		if(param_01.cranked_end_time - gettime() <= 1000)
		{
			param_01 scripts\mp\_missions::processchallenge("ch_cranked_reset");
		}

		var_05 = var_05 * 2;
		var_06 = "kill_cranked";
		param_01 thread onkill(var_06);
		param_01.pers["killChains"]++;
		param_01 scripts\mp\_persistence::statsetchild("round","killChains",param_01.pers["killChains"]);
	}
	else if(scripts\mp\_utility::isreallyalive(param_01))
	{
		param_01 makecranked("begin_cranked");
	}

	if(isdefined(param_00.attackers) && !isdefined(level.assists_disabled))
	{
		foreach(var_08 in param_00.attackers)
		{
			if(!isdefined(scripts\mp\_utility::_validateattacker(var_08)))
			{
				continue;
			}

			if(var_08 == param_01)
			{
				continue;
			}

			if(param_00 == var_08)
			{
				continue;
			}

			if(!isdefined(var_08.cranked))
			{
				continue;
			}

			var_08 thread onassist("assist_cranked");
		}
	}

	if(level.teambased)
	{
		level scripts\mp\_gamescore::giveteamscoreforobjective(param_01.pers["team"],var_05,0);
		return;
	}

	var_0A = 0;
	foreach(var_08 in level.players)
	{
		if(isdefined(var_08.destroynavrepulsor) && var_08.destroynavrepulsor > var_0A)
		{
			var_0A = var_08.destroynavrepulsor;
		}
	}
}

//Function Number: 9
cleanupcrankedtimer()
{
	self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",0);
	self.cranked = undefined;
	self.cranked_end_time = undefined;
}

//Function Number: 10
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

//Function Number: 11
onplayerscore(param_00,param_01)
{
	if(param_00 != "super_kill" && issubstr(param_00,"kill"))
	{
		var_02 = scripts\mp\_rank::getscoreinfovalue("score_increment");
		if(isdefined(param_01.cranked))
		{
			var_02 = var_02 * 2;
		}

		return var_02;
	}

	return 0;
}

//Function Number: 12
cranked()
{
	level.crankedbombtimer = 30;
}

//Function Number: 13
makecranked(param_00)
{
	scripts\mp\_utility::leaderdialogonplayer(param_00);
	thread scripts\mp\_rank::scoreeventpopup(param_00);
	setcrankedbombtimer("kill");
	self.cranked = 1;
	scripts\mp\_utility::giveperk("specialty_fastreload");
	scripts\mp\_utility::giveperk("specialty_quickdraw");
	scripts\mp\_utility::giveperk("specialty_fastoffhand");
	scripts\mp\_utility::giveperk("specialty_fastsprintrecovery");
	scripts\mp\_utility::giveperk("specialty_marathon");
	scripts\mp\_utility::giveperk("specialty_quickswap");
	scripts\mp\_utility::giveperk("specialty_stalker");
	self.movespeedscaler = 1.2;
	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 14
onkill(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	while(!isdefined(self.pers))
	{
		wait(0.05);
	}

	thread scripts\mp\_utility::giveunifiedpoints(param_00);
	setcrankedbombtimer("kill");
}

//Function Number: 15
onassist(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	thread scripts\mp\_rank::scoreeventpopup(param_00);
	setcrankedbombtimer("assist");
}

//Function Number: 16
watchbombtimer(param_00)
{
	self notify("watchBombTimer");
	self endon("watchBombTimer");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	var_01 = 5;
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(param_00 - var_01 - 1);
	scripts\mp\_utility::leaderdialogonplayer("five_seconds_left");
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(1);
	self setclientomnvar("ui_cranked_bomb_timer_final_seconds",1);
	while(var_01 > 0)
	{
		self playsoundtoplayer("mp_cranked_countdown",self);
		scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(1);
		var_01--;
	}

	if(isdefined(self) && scripts\mp\_utility::isreallyalive(self))
	{
		self playsound("frag_grenade_explode");
		playfx(level.mine_explode,self.origin + (0,0,32));
		scripts\mp\_utility::_suicide();
		self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",0);
	}
}

//Function Number: 17
setcrankedbombtimer(param_00)
{
	var_01 = level.crankedbombtimer;
	if(param_00 == "assist")
	{
		var_01 = int(min(self.cranked_end_time - gettime() / 1000 + level.crankedbombtimer * 0.5,level.crankedbombtimer));
	}

	var_02 = var_01 * 1000 + gettime();
	self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",var_02);
	self.cranked_end_time = var_02;
	thread watchcrankedhostmigration();
	thread watchbombtimer(var_01);
	thread watchendgame();
}

//Function Number: 18
watchcrankedhostmigration()
{
	self notify("watchCrankedHostMigration");
	self endon("watchCrankedHostMigration");
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	level waittill("host_migration_begin");
	self setclientomnvar("ui_cranked_timer_stopped",1);
	var_00 = scripts\mp\_hostmigration::waittillhostmigrationdone();
	self setclientomnvar("ui_cranked_timer_stopped",0);
	if(self.cranked_end_time + var_00 < 5)
	{
		self setclientomnvar("ui_cranked_bomb_timer_final_seconds",1);
	}

	if(var_00 > 0)
	{
		self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",self.cranked_end_time + var_00);
		return;
	}

	self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",self.cranked_end_time);
}

//Function Number: 19
watchendgame()
{
	self notify("watchEndGame");
	self endon("watchEndGame");
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		if(game["state"] == "postgame" || level.gameended)
		{
			self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",0);
			break;
		}

		wait(0.1);
	}
}
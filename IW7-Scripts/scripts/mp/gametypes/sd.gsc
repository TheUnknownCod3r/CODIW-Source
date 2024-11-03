/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\gametypes\sd.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 26
 * Decompile Time: 1355 ms
 * Timestamp: 10/27/2023 12:13:01 AM
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
		scripts\mp\_utility::registerroundswitchdvar(level.gametype,3,0,9);
		scripts\mp\_utility::registertimelimitdvar(level.gametype,2.5);
		scripts\mp\_utility::registerscorelimitdvar(level.gametype,1);
		scripts\mp\_utility::registerroundlimitdvar(level.gametype,0);
		scripts\mp\_utility::registerwinlimitdvar(level.gametype,4);
		scripts\mp\_utility::registernumlivesdvar(level.gametype,1);
		scripts\mp\_utility::registerhalftimedvar(level.gametype,0);
		scripts\mp\_utility::registerwinbytwoenableddvar(level.gametype,1);
		scripts\mp\_utility::registerwinbytwomaxroundsdvar(level.gametype,4);
		level.matchrules_damagemultiplier = 0;
		level.matchrules_vampirism = 0;
	}

	updategametypedvars();
	level.objectivebased = 1;
	level.teambased = 1;
	level.nobuddyspawns = 1;
	level.onprecachegametype = ::onprecachegametype;
	level.onstartgametype = ::onstartgametype;
	level.getspawnpoint = ::getspawnpoint;
	level.onspawnplayer = ::onspawnplayer;
	level.onplayerkilled = ::onplayerkilled;
	level.ondeadevent = ::ondeadevent;
	level.ononeleftevent = ::ononeleftevent;
	level.ontimelimit = ::ontimelimit;
	level.onnormaldeath = ::onnormaldeath;
	level.gamemodemaydropweapon = ::scripts\mp\_utility::isplayeroutsideofanybombsite;
	level.onobjectivecomplete = ::onbombexploded;
	level.allowlatecomers = 0;
	level.bombsplanted = 0;
	level.aplanted = 0;
	level.bplanted = 0;
	if(level.matchrules_damagemultiplier || level.matchrules_vampirism)
	{
		level.modifyplayerdamage = ::scripts\mp\_damage::gamemodemodifyplayerdamage;
	}

	game["dialog"]["gametype"] = "searchdestroy";
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

	game["dialog"]["offense_obj"] = "obj_destroy";
	game["dialog"]["defense_obj"] = "obj_defend";
	game["dialog"]["lead_lost"] = "null";
	game["dialog"]["lead_tied"] = "null";
	game["dialog"]["lead_taken"] = "null";
	setomnvar("ui_bomb_timer_endtime_a",0);
	setomnvar("ui_bomb_timer_endtime_b",0);
	setomnvar("ui_bomb_planted_a",0);
	setomnvar("ui_bomb_planted_b",0);
	setomnvar("ui_allies_alive",0);
	setomnvar("ui_axis_alive",0);
}

//Function Number: 2
initializematchrules()
{
	scripts\mp\_utility::setcommonrulesfrommatchdata();
	setdynamicdvar("scr_sd_bombtimer",getmatchrulesdata("bombData","bombTimer"));
	setdynamicdvar("scr_sd_planttime",getmatchrulesdata("bombData","plantTime"));
	setdynamicdvar("scr_sd_defusetime",getmatchrulesdata("bombData","defuseTime"));
	setdynamicdvar("scr_sd_multibomb",getmatchrulesdata("bombData","multiBomb"));
	setdynamicdvar("scr_sd_silentPlant",getmatchrulesdata("bombData","silentPlant"));
	setdynamicdvar("scr_sd_halftime",0);
	scripts\mp\_utility::registerhalftimedvar("sd",0);
	setdynamicdvar("scr_sd_promode",0);
}

//Function Number: 3
onprecachegametype()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
}

//Function Number: 4
onstartgametype()
{
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

	setclientnamemode("manual_change");
	level._effect["bomb_explosion"] = loadfx("vfx/iw7/_requests/mp/vfx_bombardment_strike_explosion");
	level._effect["vehicle_explosion"] = loadfx("vfx/core/expl/small_vehicle_explosion_new.vfx");
	level._effect["building_explosion"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	scripts\mp\_utility::setobjectivetext(game["attackers"],&"OBJECTIVES_SD_ATTACKER");
	scripts\mp\_utility::setobjectivetext(game["defenders"],&"OBJECTIVES_SD_DEFENDER");
	if(level.splitscreen)
	{
		scripts\mp\_utility::setobjectivescoretext(game["attackers"],&"OBJECTIVES_SD_ATTACKER");
		scripts\mp\_utility::setobjectivescoretext(game["defenders"],&"OBJECTIVES_SD_DEFENDER");
	}
	else
	{
		scripts\mp\_utility::setobjectivescoretext(game["attackers"],&"OBJECTIVES_SD_ATTACKER_SCORE");
		scripts\mp\_utility::setobjectivescoretext(game["defenders"],&"OBJECTIVES_SD_DEFENDER_SCORE");
	}

	scripts\mp\_utility::setobjectivehinttext(game["attackers"],&"OBJECTIVES_SD_ATTACKER_HINT");
	scripts\mp\_utility::setobjectivehinttext(game["defenders"],&"OBJECTIVES_SD_DEFENDER_HINT");
	initspawns();
	var_02[0] = "sd";
	var_02[1] = "bombzone";
	var_02[2] = "blocker";
	scripts\mp\_gameobjects::main(var_02);
	setspecialloadout();
	thread bombs();
	scripts\mp\_utility::func_98D3();
	level thread onplayerconnect();
}

//Function Number: 5
initspawns()
{
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_sd_spawn_attacker");
	scripts\mp\_spawnlogic::addstartspawnpoints("mp_sd_spawn_defender");
	level.mapcenter = scripts\mp\_spawnlogic::findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 6
getspawnpoint()
{
	var_00 = "mp_sd_spawn_defender";
	if(self.pers["team"] == game["attackers"])
	{
		var_00 = "mp_sd_spawn_attacker";
	}

	var_01 = scripts\mp\_spawnlogic::getspawnpointarray(var_00);
	var_02 = scripts\mp\_spawnlogic::getspawnpoint_startspawn(var_01);
	return var_02;
}

//Function Number: 7
onspawnplayer()
{
	if(scripts\mp\_utility::isgameparticipant(self))
	{
		self.isplanting = 0;
		self.isdefusing = 0;
		self.isbombcarrier = 0;
		self.laststanding = 0;
	}

	if(level.multibomb && self.pers["team"] == game["attackers"])
	{
		self setclientomnvar("ui_carrying_bomb",1);
	}
	else
	{
		self setclientomnvar("ui_carrying_bomb",0);
		foreach(var_01 in level.bombzones)
		{
			var_01.trigger disableplayeruse(self);
		}
	}

	scripts\mp\_utility::setextrascore0(0);
	if(isdefined(self.pers["plants"]))
	{
		scripts\mp\_utility::setextrascore0(self.pers["plants"]);
	}

	scripts\mp\_utility::setextrascore1(0);
	if(isdefined(self.pers["defuses"]))
	{
		scripts\mp\_utility::setextrascore1(self.pers["defuses"]);
	}

	func_12E58();
	level notify("spawned_player");
}

//Function Number: 8
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread onplayerdisconnected();
	}
}

//Function Number: 9
onplayerdisconnected()
{
	for(;;)
	{
		self waittill("disconnect");
		level func_12E58();
	}
}

//Function Number: 10
func_12E58()
{
	if(isdefined(level.alive_players["allies"]))
	{
		setomnvar("ui_allies_alive",level.alive_players["allies"].size);
	}

	if(isdefined(level.alive_players["axis"]))
	{
		setomnvar("ui_axis_alive",level.alive_players["axis"].size);
	}
}

//Function Number: 11
onplayerkilled(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	self setclientomnvar("ui_carrying_bomb",0);
	func_12E58();
	thread checkallowspectating();
}

//Function Number: 12
checkallowspectating()
{
	wait(0.05);
	var_00 = 0;
	if(!level.alivecount[game["attackers"]])
	{
		level.spectateoverride[game["attackers"]].allowenemyspectate = 1;
		var_00 = 1;
	}

	if(!level.alivecount[game["defenders"]])
	{
		level.spectateoverride[game["defenders"]].allowenemyspectate = 1;
		var_00 = 1;
	}

	if(var_00)
	{
		scripts\mp\_spectating::updatespectatesettings();
	}
}

//Function Number: 13
sd_endgame(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(!isai(var_03))
		{
			var_03 setclientomnvar("ui_objective_state",0);
		}
	}

	thread scripts\mp\_gamelogic::endgame(param_00,param_01);
}

//Function Number: 14
ondeadevent(param_00)
{
	if(level.bombexploded > 0 || level.bombdefused)
	{
		return;
	}

	if(param_00 == "all")
	{
		if(level.bombplanted)
		{
			sd_endgame(game["attackers"],game["end_reason"][game["defenders"] + "_eliminated"]);
			return;
		}

		sd_endgame(game["defenders"],game["end_reason"][game["attackers"] + "_eliminated"]);
		return;
	}

	if(param_00 == game["attackers"])
	{
		if(level.bombplanted)
		{
			return;
		}

		level thread sd_endgame(game["defenders"],game["end_reason"][game["attackers"] + "_eliminated"]);
		return;
	}

	if(param_00 == game["defenders"])
	{
		level thread sd_endgame(game["attackers"],game["end_reason"][game["defenders"] + "_eliminated"]);
		return;
	}
}

//Function Number: 15
ononeleftevent(param_00)
{
	if(level.bombexploded > 0 || level.bombdefused)
	{
		return;
	}

	var_01 = scripts\mp\_utility::getlastlivingplayer(param_00);
	var_01.laststanding = 1;
	var_01 thread givelastonteamwarning();
}

//Function Number: 16
onnormaldeath(param_00,param_01,param_02,param_03,param_04)
{
	scripts\mp\gametypes\common::onnormaldeath(param_00,param_01,param_02,param_03,param_04);
	var_05 = scripts\mp\_rank::getscoreinfovalue("kill");
	var_06 = param_00.team;
	var_07 = 0;
	if(isdefined(param_01.laststanding) && param_01.laststanding)
	{
		param_01 thread scripts\mp\_utility::giveunifiedpoints("last_man_kill");
	}

	if(param_00.isplanting)
	{
		thread scripts\mp\_matchdata::loginitialstats(param_02,"planting");
		param_01 scripts\mp\_utility::incperstat("defends",1);
		param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
		param_01 thread scripts\mp\_awards::givemidmatchaward("mode_sd_plant_save");
		var_07 = 1;
	}
	else if(param_00.isbombcarrier)
	{
		thread scripts\mp\_matchdata::loginitialstats(param_02,"carrying");
	}
	else if(param_00.isdefusing)
	{
		thread scripts\mp\_matchdata::loginitialstats(param_02,"defusing");
		scripts\mp\_utility::setmlgannouncement(13,param_01.team,param_01 getentitynumber());
		param_01 scripts\mp\_utility::incperstat("defends",1);
		param_01 scripts\mp\_persistence::statsetchild("round","defends",param_01.pers["defends"]);
		param_01 thread scripts\mp\_awards::givemidmatchaward("mode_sd_defuse_save");
		var_07 = 1;
	}

	if(!var_07)
	{
		scripts\mp\gametypes\obj_bombzone::bombzone_awardgenericbombzonemedals(param_01,param_00);
	}
}

//Function Number: 17
givelastonteamwarning()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	scripts\mp\_utility::waittillrecoveredhealth(3);
	var_00 = scripts\mp\_utility::getotherteam(self.pers["team"]);
	level thread scripts\mp\_utility::teamplayercardsplash("callout_lastteammemberalive",self,self.pers["team"]);
	level thread scripts\mp\_utility::teamplayercardsplash("callout_lastenemyalive",self,var_00);
	scripts\mp\_music_and_dialog::func_C54B(self);
	scripts\mp\_utility::setmlgannouncement(16,self.team,self getentitynumber());
	scripts\mp\_missions::lastmansd();
}

//Function Number: 18
ontimelimit()
{
	sd_endgame(game["defenders"],game["end_reason"]["time_limit_reached"]);
	foreach(var_01 in level.players)
	{
		if(isdefined(var_01.bombplantweapon))
		{
			var_01 scripts\mp\_utility::_takeweapon(var_01.bombplantweapon);
			break;
		}
	}
}

//Function Number: 19
updategametypedvars()
{
	scripts\mp\gametypes\common::updategametypedvars();
	level.bombtimer = scripts\mp\_utility::dvarfloatvalue("bombtimer",45,1,300);
	level.planttime = scripts\mp\_utility::dvarfloatvalue("planttime",5,0,20);
	level.defusetime = scripts\mp\_utility::dvarfloatvalue("defusetime",5,0,20);
	level.multibomb = scripts\mp\_utility::dvarintvalue("multibomb",0,0,1);
	level.silentplant = scripts\mp\_utility::dvarintvalue("silentPlant",0,0,1);
}

//Function Number: 20
removebombzonec(param_00)
{
	var_01 = [];
	var_02 = getentarray("script_brushmodel","classname");
	foreach(var_04 in var_02)
	{
		if(isdefined(var_04.script_gameobjectname) && var_04.script_gameobjectname == "bombzone")
		{
			foreach(var_06 in param_00)
			{
				if(distance(var_04.origin,var_06.origin) < 100 && issubstr(tolower(var_06.script_label),"c"))
				{
					var_06.relatedbrushmodel = var_04;
					var_01[var_01.size] = var_06;
					break;
				}
			}
		}
	}

	foreach(var_0A in var_01)
	{
		var_0A.relatedbrushmodel delete();
		var_0B = getentarray(var_0A.target,"targetname");
		foreach(var_0D in var_0B)
		{
			var_0D delete();
		}

		var_0A delete();
	}

	return scripts\engine\utility::array_removeundefined(param_00);
}

//Function Number: 21
bombs()
{
	scripts\mp\gametypes\obj_bombzone::bombzone_setupbombcase("sd_bomb");
	level.bombzones = [];
	var_00 = getentarray("bombzone","targetname");
	var_00 = removebombzonec(var_00);
	level.objectives = var_00;
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_02 = scripts\mp\gametypes\obj_bombzone::bombzone_setupobjective(var_01);
		var_02.onbeginuse = ::onbeginuse;
		var_02.onenduse = ::onenduse;
		var_02.onuse = ::onuseplantobject;
		level.bombzones[level.bombzones.size] = var_02;
	}

	for(var_01 = 0;var_01 < level.bombzones.size;var_01++)
	{
		var_03 = [];
		for(var_04 = 0;var_04 < level.bombzones.size;var_04++)
		{
			if(var_04 != var_01)
			{
				var_03[var_03.size] = level.bombzones[var_04];
			}
		}

		level.bombzones[var_01].otherbombzones = var_03;
	}
}

//Function Number: 22
onbeginuse(param_00)
{
	scripts\mp\gametypes\obj_bombzone::bombzone_onbeginuse(param_00);
	if(!scripts\mp\_gameobjects::isfriendlyteam(param_00.pers["team"]))
	{
		if(level.multibomb)
		{
			for(var_01 = 0;var_01 < self.otherbombzones.size;var_01++)
			{
				self.otherbombzones[var_01] scripts\mp\_gameobjects::allowuse("none");
				self.otherbombzones[var_01] scripts\mp\_gameobjects::setvisibleteam("friendly");
			}
		}
	}
}

//Function Number: 23
onenduse(param_00,param_01,param_02)
{
	scripts\mp\gametypes\obj_bombzone::bombzone_onenduse(param_00,param_01,param_02);
	if(isdefined(param_01) && !scripts\mp\_gameobjects::isfriendlyteam(param_01.pers["team"]))
	{
		if(level.multibomb && !param_02)
		{
			for(var_03 = 0;var_03 < self.otherbombzones.size;var_03++)
			{
				self.otherbombzones[var_03] scripts\mp\_gameobjects::allowuse("enemy");
				self.otherbombzones[var_03] scripts\mp\_gameobjects::setvisibleteam("any");
			}
		}
	}
}

//Function Number: 24
onuseplantobject(param_00)
{
	if(!scripts\mp\_gameobjects::isfriendlyteam(param_00.pers["team"]))
	{
		for(var_01 = 0;var_01 < level.bombzones.size;var_01++)
		{
			if(level.bombzones[var_01] == self)
			{
				continue;
			}

			level.bombzones[var_01] scripts\mp\_gameobjects::disableobject();
		}
	}

	scripts\mp\gametypes\obj_bombzone::bombzone_onuseplantobject(param_00);
}

//Function Number: 25
setspecialloadout()
{
	if(function_011C() && scripts\mp\_utility::getmatchrulesdatawithteamandindex("defaultClasses",game["attackers"],5,"class","inUse"))
	{
		level.sd_loadout[game["attackers"]] = scripts\mp\_utility::getmatchrulesspecialclass(game["attackers"],5);
	}
}

//Function Number: 26
onbombexploded(param_00,param_01,param_02,param_03,param_04)
{
	if(param_03 == game["attackers"])
	{
		function_01AF(0);
		wait(3);
		sd_endgame(game["attackers"],game["end_reason"]["target_destroyed"]);
		return;
	}

	wait(1.5);
	function_01AF(0);
	sd_endgame(game["defenders"],game["end_reason"]["bomb_defused"]);
}
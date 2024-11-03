/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\cp\cp_globallogic.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 80
 * Decompile Time: 4032 ms
 * Timestamp: 10/27/2023 12:09:20 AM
*******************************************************************/

//Function Number: 1
init()
{
	scripts\engine\utility::struct_class_init();
	func_F6BD();
	func_F6BA();
	scripts\cp\utility::func_F305();
	setupcallbacks();
	scripts\cp\utility::initgameflags();
	scripts\cp\utility::initlevelflags();
	func_FAAB();
	func_F6BB();
	func_F6BF();
	func_F6BC();
	func_AE18();
	func_10958();
	func_97F7();
	setupexploders();
	func_9817();
	func_988B();
	scripts\common\fx::initfx();
	scripts\mp\_callbacksetup::setupdamageflags();
	scripts\cp\cp_movers::init();
	scripts\cp\cp_fx::main();
	scripts\cp\cp_merits::buildmeritinfo();
	scripts\cp\cp_endgame::init();
	scripts\cp\cp_laststand::init_laststand();
	if(func_100BC())
	{
		level thread func_132A3();
	}

	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	level.mapcenter = findboxcenter(level.spawnmins,level.spawnmaxs);
	function_01B4(level.mapcenter);
}

//Function Number: 2
findboxcenter(param_00,param_01)
{
	var_02 = (0,0,0);
	var_02 = param_01 - param_00;
	var_02 = (var_02[0] / 2,var_02[1] / 2,var_02[2] / 2) + param_00;
	return var_02;
}

//Function Number: 3
func_F6BD()
{
	level.var_1307 = 1;
	level.splitscreen = function_0114();
	level.onlinegame = getdvarint("onlinegame");
	level.rankedmatch = (level.onlinegame && !getdvarint("xblive_privatematch")) || getdvarint("force_ranking");
	level.script = tolower(getdvar("mapname"));
	level.gametype = tolower(getdvar("ui_gametype"));
	level.teamnamelist = ["axis","allies"];
	level.otherteam["allies"] = "axis";
	level.otherteam["axis"] = "allies";
	level.multiteambased = 0;
	level.teambased = 1;
	level.objectivebased = 0;
	level.func = [];
	level.createfx_enabled = getdvar("createfx") != "";
	level.spawnmins = (0,0,0);
	level.spawnmaxs = (0,0,0);
	level.hardcoremode = 0;
	level.var_C22E = 0;
	level.reclaimedreservedobjectives = [];
}

//Function Number: 4
func_F6BA()
{
	setdvar("ui_inhostmigration",0);
	setdvar("camera_thirdPerson",getdvarint("scr_thirdPerson"));
	setdvar("sm_sunShadowScale",1);
	setdvar("r_specularcolorscale",2.5);
	setdvar("r_diffusecolorscale",1);
	setdvar("r_lightGridEnableTweaks",0);
	setdvar("r_lightGridIntensity",1);
	setdvar("bg_compassShowEnemies",getdvar("scr_game_forceuav"));
	setdvar("isMatchMakingGame",scripts\cp\utility::matchmakinggame());
	setdvar("ui_overtime",0);
	setdvar("ui_allow_teamchange",1);
	setdvar("g_deadChat",1);
	setdvar("min_wait_for_players",5);
	setdvar("ui_friendlyfire",0);
	setdvar("cg_drawFriendlyHUDGrenades",0);
	setdvar("cg_drawCrosshair",scripts\engine\utility::ter_op(level.hardcoremode == 1,0,1));
	setdvar("cg_drawCrosshairNames",1);
	setdvar("cg_drawFriendlyNamesAlways",0);
}

//Function Number: 5
setupcallbacks()
{
	level.callbackstartgametype = ::func_4631;
	level.callbackplayerconnect = ::func_5043;
	level.callbackplayerdisconnect = ::func_5045;
	level.callbackplayerdamage = ::func_5044;
	level.callbackplayerkilled = ::func_5046;
	level.callbackplayermigrated = ::func_5049;
	level.callbackhostmigration = ::func_503E;
	level.getspawnpoint = ::defaultgetspawnpoint;
	level.onspawnplayer = ::blank;
	level.onprecachegametype = ::blank;
	level.onstartgametype = ::blank;
	level.var_D3D5 = ::func_5048;
	level.initagentscriptvariables = ::scripts\cp\cp_agent_utils::initagentscriptvariables;
	level.setagentteam = ::scripts\cp\cp_agent_utils::set_agent_team;
	level.agentvalidateattacker = ::scripts\cp\cp_agent_utils::validateattacker;
	level.agentfunc = ::scripts\cp\cp_agent_utils::agentfunc;
	level.getfreeagent = ::scripts\cp\cp_agent_utils::getfreeagent;
	level.addtocharactersarray = ::scripts\cp\cp_agent_utils::addtocharactersarray;
	level.callbackplayerlaststand = ::scripts\cp\cp_laststand::callback_defaultplayerlaststand;
	level.endgame = ::scripts\cp\cp_endgame::endgame;
	level.var_72BF = ::scripts\cp\cp_endgame::func_72BF;
}

//Function Number: 6
func_AE18()
{
	level._effect["slide_dust"] = loadfx("vfx/core/screen/vfx_scrnfx_tocam_slidedust_m");
}

//Function Number: 7
func_5044(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
}

//Function Number: 8
func_5046(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
}

//Function Number: 9
func_FAAB()
{
	var_00 = ["trigger_multiple","trigger_once","trigger_use","trigger_radius","trigger_lookat","trigger_damage"];
	foreach(var_02 in var_00)
	{
		var_03 = getentarray(var_02,"classname");
		for(var_04 = 0;var_04 < var_03.size;var_04++)
		{
			if(isdefined(var_03[var_04].script_prefab_exploder))
			{
				var_03[var_04].script_exploder = var_03[var_04].script_prefab_exploder;
			}

			if(isdefined(var_03[var_04].script_exploder))
			{
				level thread exploder_load(var_03[var_04]);
			}
		}
	}
}

//Function Number: 10
func_10958()
{
	level thread trackgrenades();
	level thread trackmissiles();
	level thread trackcarepackages();
}

//Function Number: 11
trackgrenades()
{
	for(;;)
	{
		level.grenades = getentarray("grenade","classname");
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 12
trackmissiles()
{
	for(;;)
	{
		level.missiles = getentarray("rocket","classname");
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 13
trackcarepackages()
{
	for(;;)
	{
		level.carepackages = getentarray("care_package","targetname");
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 14
func_5048()
{
	if(scripts\engine\utility::istrue(self.keep_perks))
	{
		if(scripts\cp\utility::has_zombie_perk("perk_machine_tough"))
		{
			return 200;
		}

		return 100;
	}

	return 100;
}

//Function Number: 15
func_F6BB()
{
	game["thermal_vision"] = "thermal_mp";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_outfit"] = "urban";
	game["axis_outfit"] = "woodland";
	game["clientid"] = 0;
	game["roundsPlayed"] = 0;
	game["state"] = "playing";
	game["status"] = "normal";
	game["roundsWon"] = [];
}

//Function Number: 16
func_F6BF()
{
	function_0237("",0);
	function_0238("default_night_mp");
	function_0236("missilecam");
	function_023A(game["thermal_vision"]);
	function_0239("",0);
}

//Function Number: 17
func_F6BC()
{
	function_01BC(0);
	function_01BD(0);
}

//Function Number: 18
defaultgetspawnpoint()
{
	return getassignedspawnpoint(scripts\engine\utility::getstructarray("default_player_start","targetname"));
}

//Function Number: 19
getassignedspawnpoint(param_00)
{
	var_01 = self getentitynumber();
	if(var_01 == 4)
	{
		var_01 = 1;
	}

	return param_00[var_01];
}

//Function Number: 20
func_5038()
{
	level.gameended = 1;
	setomnvar("allow_server_pause",0);
	level notify("game_ended","allies");
	scripts\engine\utility::waitframe();
	exitlevel(0);
}

//Function Number: 21
func_4631()
{
	[[ level.onprecachegametype ]]();
	func_E256();
	func_E255();
	scripts/cp/perks/perkmachines::func_98B1();
	scripts/cp/perks/prestige::initprestige();
	scripts\cp\cp_weaponrank::init();
	scripts\cp\cp_relics::init();
	thread scripts\cp\powers\coop_powers::init();
	scripts\cp\cp_merits::init();
	thread scripts\cp\contracts_coop::init();
	level thread func_E896();
	level thread _meth_8489();
	level thread func_10D9F();
	game["gamestarted"] = 1;
}

//Function Number: 22
func_E256()
{
	level.teamcount["allies"] = 0;
	level.teamcount["axis"] = 0;
	level.teamcount["spectator"] = 0;
	level.hasspawned["allies"] = 0;
	level.hasspawned["axis"] = 0;
	level.fauxvehiclecount = 0;
	level.gameended = 0;
	level.var_72B3 = 0;
	level.hostforcedend = 0;
	level._meth_8487 = 10;
	level.ingraceperiod = level._meth_8487;
	level.noragdollents = getentarray("noragdoll","targetname");
	level.friendlyfire = 0;
	level.starttime = gettime();
}

//Function Number: 23
func_E255()
{
	level.players = [];
	level.participants = [];
	level.characters = [];
	level.helis = [];
	level.turrets = [];
	level.var_935F = [];
	level.ugvs = [];
	level.balldrones = [];
}

//Function Number: 24
func_E896()
{
	level notify("coop_pre_match");
	level endon("game_ended");
	level endon("coop_pre_match");
	scripts\cp\utility::gameflaginit("prematch_done",0);
	setomnvar("ui_prematch_period",1);
	if(isdefined(level.prematchfunc))
	{
		[[ level.prematchfunc ]]();
	}

	scripts\cp\utility::gameflagset("prematch_done");
	setomnvar("ui_prematch_period",0);
}

//Function Number: 25
_meth_8489()
{
	level notify("coop_grace_period");
	level endon("game_ended");
	level endon("coop_grace_period");
	while(function_0071() == 0)
	{
		scripts\engine\utility::waitframe();
	}

	while(level.ingraceperiod > 0)
	{
		wait(1);
		level.ingraceperiod--;
	}

	level.ingraceperiod = 0;
}

//Function Number: 26
func_10D9F()
{
	[[ level.onstartgametype ]]();
}

//Function Number: 27
func_100BC()
{
	return !level.console && getdvar("dedicated") == "dedicated LAN server" || getdvar("dedicated") == "dedicated internet server";
}

//Function Number: 28
func_132A3()
{
	for(;;)
	{
		if(level.rankedmatch)
		{
			exitlevel(0);
		}

		if(!getdvarint("xblive_privatematch"))
		{
			exitlevel(0);
		}

		if(getdvar("dedicated") != "dedicated LAN server" && getdvar("dedicated") != "dedicated internet server")
		{
			exitlevel(0);
		}

		wait(5);
	}
}

//Function Number: 29
func_5043()
{
	self endon("disconnect");
	self.getgrenadefusetime = "hud_status_connecting";
	self waittill("begin");
	self.getgrenadefusetime = "";
	var_00 = gettime();
	level notify("connected",self);
	game["clientid"]++;
	func_98BC();
	func_F7F0();
	initclientdvars();
	setupsavedactionslots();
	func_98B9();
	func_988E();
	scripts/cp/perks/prestige::initplayerprestige();
	scripts/cp/perks/perk_utility::func_95C1();
	self.no_team_outlines = 0;
	self.no_outline = 0;
	if(scripts\cp\utility::coop_mode_has("outline"))
	{
		thread scripts\cp\cp_outline::playeroutlinemonitor();
	}

	thread scripts\cp\cp_vo::func_97CC();
	thread scripts\cp\cp_merits::updatemerits();
	if(self ishost())
	{
		level.player = self;
	}

	if(!level.teambased)
	{
		game["roundsWon"][self.guid] = 0;
	}

	waittillframeend;
	func_1810(self);
	if(game["state"] == "postgame")
	{
		self.connectedpostgame = 1;
		self setclientdvars("cg_drawSpectatorMessages",0);
		spawnintermission();
		return;
	}

	if(isai(self) && isdefined(level.bot_funcs) && isdefined(level.bot_funcs["think"]))
	{
		self thread [[ level.bot_funcs["think"] ]]();
	}

	level endon("game_ended");
	if(isdefined(level.hostmigrationtimer))
	{
		thread scripts\cp\cp_hostmigration::hostmigrationtimerthink();
	}

	if(isdefined(level.onplayerconnectaudioinit))
	{
		[[ level.onplayerconnectaudioinit ]]();
	}

	if(!isai(self))
	{
		func_D3D9();
	}

	spawnplayer();
}

//Function Number: 30
func_D3D9()
{
	thread func_102EC();
	thread func_72C1();
}

//Function Number: 31
func_F7F0()
{
	self.guid = scripts\cp\utility::getuniqueid();
	self.clientid = game["clientid"];
	self.usingonlinedataoffline = self isusingonlinedataoffline();
	self.connected = 1;
	self.hasspawned = 0;
	self.waitingtospawn = 0;
	self.wantsafespawn = 0;
	self.movespeedscaler = 1;
	self.objectivescaler = 1;
	self.inlaststand = 0;
}

//Function Number: 32
initclientdvars()
{
	initclientdvarssplitscreenspecific();
	self setclientdvars("cg_drawSpectatorMessages",1,"cg_deadChatWithDead",0,"cg_deadChatWithTeam",1,"cg_deadHearTeamLiving",1,"cg_deadHearAllLiving",0,"ui_altscene",0);
	if(level.teambased)
	{
		self setclientdvar("cg_everyonehearseveryone",0);
	}
}

//Function Number: 33
initclientdvarssplitscreenspecific()
{
	if(level.splitscreen || self issplitscreenplayer())
	{
		self setclientdvars("cg_fovscale","0.75");
		setdvar("r_materialBloomHQScriptMasterEnable",0);
		return;
	}

	self setclientdvars("cg_fovscale","1");
}

//Function Number: 34
setupsavedactionslots()
{
	self.saved_actionslotdata = [];
	for(var_00 = 1;var_00 <= 4;var_00++)
	{
		self.saved_actionslotdata[var_00] = spawnstruct();
		self.saved_actionslotdata[var_00].type = "";
		self.saved_actionslotdata[var_00].randomintrange = undefined;
	}

	if(!level.console)
	{
		for(var_00 = 5;var_00 <= 8;var_00++)
		{
			self.saved_actionslotdata[var_00] = spawnstruct();
			self.saved_actionslotdata[var_00].type = "";
			self.saved_actionslotdata[var_00].randomintrange = undefined;
		}
	}
}

//Function Number: 35
func_98B9()
{
	self.perks = [];
	self.perksperkname = [];
}

//Function Number: 36
func_102EC()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("sprint_slide_begin");
		self playfx(level._effect["slide_dust"],self geteye());
	}
}

//Function Number: 37
func_72C1()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "arcade_off")
		{
			self notify("adjustedStance");
		}

		if(var_00 == "end_game")
		{
			level thread [[ level.var_72BF ]]();
			self notify("disconnect");
		}
	}
}

//Function Number: 38
spawnintermission(param_00)
{
	func_F726();
	var_01 = self.forcespawnangles;
	spawnplayer();
	self setclientdvar("cg_everyoneHearsEveryone",1);
	self setdepthoffield(0,128,512,4000,6,1.8);
	if(level.console)
	{
		self setclientdvar("cg_fov","90");
	}

	scripts\cp\utility::updatesessionstate("intermission");
}

//Function Number: 39
func_F726()
{
	var_00 = func_7ED8();
	func_F717(var_00.origin,var_00.angles);
}

//Function Number: 40
func_F717(param_00,param_01)
{
	self.forcespawnorigin = param_00;
	self.forcespawnangles = param_01;
}

//Function Number: 41
func_7ED8()
{
	var_00 = getentarray("mp_global_intermission","classname");
	return var_00[0];
}

//Function Number: 42
spawnplayer(param_00)
{
	thread func_108F4(param_00);
}

//Function Number: 43
func_108F4(param_00)
{
	self endon("disconnect");
	self endon("joined_spectators");
	level endon("game_ended");
	if(self.waitingtospawn)
	{
		return;
	}

	func_136E9();
	func_108F3(param_00);
}

//Function Number: 44
func_136E9()
{
	self.waitingtospawn = 1;
	if(scripts\cp\utility::isusingremote())
	{
		self waittill("stopped_using_remote");
	}

	self.waitingtospawn = 0;
}

//Function Number: 45
func_108F3(param_00)
{
	self notify("spawned");
	self notify("started_spawnPlayer");
	if(level.gameended)
	{
		self spawn(getspawnorigin(self,1),_meth_8132(self));
	}
	else
	{
		self spawn(getspawnorigin(self),_meth_8132(self));
	}

	func_E262();
	func_E261();
	func_E263();
	resetplayerdamagemodifiers();
	param_00 = scripts\engine\utility::ter_op(isdefined(param_00),param_00,0);
	if(!param_00)
	{
		func_C07F();
	}

	if(isai(self))
	{
		func_10828(param_00);
	}

	[[ level.onspawnplayer ]]();
	if(!scripts\engine\utility::flag("introscreen_over"))
	{
		scripts\cp\utility::freezecontrolswrapper(1);
	}

	self [[ level.custom_giveloadout ]](param_00);
	if(getdvarint("camera_thirdPerson"))
	{
		scripts\cp\utility::setthirdpersondof(1);
	}

	if(func_1001B())
	{
		scripts\cp\utility::freezecontrolswrapper(1);
	}

	waittillframeend;
	self notify("spawned_player");
	level notify("player_spawned",self);
}

//Function Number: 46
func_E262()
{
	self setclientomnvar("ui_options_menu",0);
	self setclientomnvar("ui_hud_shake",0);
}

//Function Number: 47
func_E261()
{
	self stopshellshock();
	self stoprumble("damage_heavy");
	self setdepthoffield(0,0,512,512,4,0);
	if(level.console)
	{
		self setclientdvar("cg_fov","65");
	}
}

//Function Number: 48
resetplayerdamagemodifiers()
{
	if(isdefined(self.additivedamagemodifiers))
	{
		var_00 = getarraykeys(self.additivedamagemodifiers);
		foreach(var_02 in var_00)
		{
			scripts\cp\utility::removedamagemodifier(var_02,1);
		}
	}

	if(isdefined(self.multiplicativedamagemodifiers))
	{
		var_00 = getarraykeys(self.multiplicativedamagemodifiers);
		foreach(var_02 in var_00)
		{
			scripts\cp\utility::removedamagemodifier(var_02,0);
		}
	}
}

//Function Number: 49
func_E263()
{
	var_00 = getnearestnode();
	self.team = var_00;
	self.sessionteam = var_00;
	self.pers["team"] = var_00;
	self.fauxdeath = undefined;
	self.movespeedscaler = 1;
	self.disabledweapon = 0;
	self.disabledoffhandweapons = 0;
	self.hasriotshieldequipped = 0;
	self.hasriotshield = 0;
}

//Function Number: 50
getnearestnode()
{
	if(isdefined(level.var_D425))
	{
		return [[ level.var_D425 ]](self);
	}

	return "allies";
}

//Function Number: 51
func_C07F()
{
	func_E25B();
	scripts\cp\utility::updatesessionstate("playing");
}

//Function Number: 52
func_E25B()
{
	self.maxhealth = self [[ level.var_D3D5 ]]();
	self.health = self.maxhealth;
	self.avoidkillstreakonspawntimer = 5;
	self.friendlydamage = undefined;
	self.hasspawned = 1;
	self.spawntime = gettime();
	self.objectivescaler = 1;
}

//Function Number: 53
func_10828(param_00)
{
	scripts\cp\utility::freezecontrolswrapper(1);
	if(!param_00)
	{
		if(isdefined(level.bot_funcs) && isdefined(level.bot_funcs["player_spawned"]))
		{
			self [[ level.bot_funcs["player_spawned"] ]]();
		}
	}
}

//Function Number: 54
getspawnorigin(param_00,param_01)
{
	var_02 = undefined;
	if(isdefined(param_00.forcespawnorigin))
	{
		var_02 = param_00.forcespawnorigin;
		var_02 = getclosestpointonnavmesh(var_02);
		if(isdefined(param_01))
		{
			var_02 = param_00.forcespawnorigin;
		}

		param_00.forcespawnorigin = undefined;
	}
	else
	{
		var_03 = param_00 [[ level.getspawnpoint ]]();
		var_02 = scripts\engine\utility::ter_op(scripts\engine\utility::istrue(level.disable_start_spawn_on_navmesh),scripts\engine\utility::drop_to_ground(var_03.origin,0,-100),getclosestpointonnavmesh(var_03.origin));
		if(isdefined(param_01))
		{
			var_02 = var_03;
		}

		if(level.script == "cp_disco")
		{
			var_02 = var_03.origin;
		}
	}

	return var_02;
}

//Function Number: 55
_meth_8132(param_00)
{
	var_01 = undefined;
	if(isdefined(param_00.forcespawnangles))
	{
		var_01 = param_00.forcespawnangles;
		param_00.forcespawnangles = undefined;
	}
	else
	{
		var_02 = param_00 [[ level.getspawnpoint ]]();
		var_01 = scripts\engine\utility::ter_op(isdefined(var_02.angles),var_02.angles,(0,0,0));
	}

	return var_01;
}

//Function Number: 56
func_1001B()
{
	if(game["state"] == "postgame")
	{
		return 1;
	}

	return 0;
}

//Function Number: 57
enterspectator()
{
	var_00 = func_7ED8();
	self setspectatedefaults(var_00.origin,var_00.angles);
	func_F717(var_00.origin,var_00.angles);
	func_F858();
	scripts\cp\utility::updatesessionstate("spectator");
}

//Function Number: 58
func_F858()
{
	if(isdefined(level.var_10979))
	{
		[[ level.var_10979 ]](self);
		return;
	}

	func_504C(self);
}

//Function Number: 59
func_504C(param_00)
{
	param_00 allowspectateteam("allies",1);
	param_00 allowspectateteam("axis",1);
	param_00 allowspectateteam("freelook",0);
	param_00 allowspectateteam("none",1);
}

//Function Number: 60
func_5045(param_00)
{
	if(!isdefined(self.connected))
	{
		return;
	}

	scripts\cp\cp_analytics::on_player_disconnect(param_00);
	func_E15A(self);
	if(func_563B())
	{
		level thread [[ level.var_72BF ]]();
	}

	if(isdefined(level.onplayerdisconnected))
	{
		level thread [[ level.onplayerdisconnected ]](self,param_00);
	}
}

//Function Number: 61
func_563B()
{
	if(level.splitscreen)
	{
		return level.players.size <= 1;
	}

	var_00 = 0;
	foreach(var_02 in level.players)
	{
		if(scripts\cp\cp_laststand::player_in_laststand(var_02))
		{
			var_00 = scripts\cp\cp_laststand::gameshouldend(var_02);
		}
	}

	return var_00;
}

//Function Number: 62
func_1810(param_00)
{
	level.players[level.players.size] = param_00;
	level.participants[level.participants.size] = param_00;
	level.characters[level.characters.size] = param_00;
}

//Function Number: 63
func_E15A(param_00)
{
	level.players = scripts\engine\utility::array_remove(level.players,param_00);
	level.participants = scripts\engine\utility::array_remove(level.participants,param_00);
	level.characters = scripts\engine\utility::array_remove(level.characters,param_00);
}

//Function Number: 64
func_5049()
{
	if(self ishost())
	{
		initclientdvarssplitscreenspecific();
	}

	if(func_9E39(self))
	{
		var_00 = 0;
		foreach(var_02 in level.players)
		{
			if(func_9E39(var_02))
			{
				var_00++;
			}
		}

		level.var_90A8++;
		if(level.hostmigrationreturnedplayercount >= var_00 * 2 / 3)
		{
			level notify("hostmigration_enoughplayers");
		}
	}
}

//Function Number: 65
func_9E39(param_00)
{
	return !isdefined(param_00.pers["isBot"]) || param_00.pers["isBot"] == 0;
}

//Function Number: 66
func_503E()
{
	if(level.gameended)
	{
		return;
	}

	if(isdefined(level.var_C53D))
	{
		level thread [[ level.var_C53D ]]();
	}

	level.hostmigrationreturnedplayercount = 0;
	foreach(var_01 in level.characters)
	{
		var_01.hostmigrationcontrolsfrozen = 0;
	}

	level.hostmigrationtimer = 1;
	setdvar("ui_inhostmigration",1);
	level notify("host_migration_begin");
	foreach(var_01 in level.characters)
	{
		if(isdefined(var_01))
		{
			var_01 thread scripts\cp\cp_hostmigration::hostmigrationtimerthink();
		}

		if(isplayer(var_01))
		{
			var_01 setclientomnvar("ui_session_state",var_01.sessionstate);
		}
	}

	setdvar("ui_game_state",game["state"]);
	level endon("host_migration_begin");
	scripts\cp\cp_hostmigration::hostmigrationwait();
	level.hostmigrationtimer = undefined;
	setdvar("ui_inhostmigration",0);
	if(isdefined(level.hostmigrationend))
	{
		level thread [[ level.hostmigrationend ]]();
	}

	level notify("host_migration_end");
}

//Function Number: 67
func_97F7()
{
	var_00 = getentarray("destructable","targetname");
	if(getdvar("scr_destructables") == "0")
	{
		for(var_01 = 0;var_01 < var_00.size;var_01++)
		{
			var_00[var_01] delete();
		}

		return;
	}

	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_00[var_01] thread destructable_think();
	}
}

//Function Number: 68
destructable_think()
{
	var_00 = 40;
	var_01 = 0;
	if(isdefined(self.script_accumulate))
	{
		var_00 = self.script_accumulate;
	}

	if(isdefined(self.script_threshold))
	{
		var_01 = self.script_threshold;
	}

	if(isdefined(self.script_fxid))
	{
		self.fx = loadfx(self.script_fxid);
	}

	var_02 = 0;
	self setcandamage(1);
	for(;;)
	{
		self waittill("damage",var_03,var_04);
		if(var_03 >= var_01)
		{
			var_02 = var_02 + var_03;
			if(var_02 >= var_00)
			{
				thread destructable_destruct();
				return;
			}
		}
	}
}

//Function Number: 69
destructable_destruct()
{
	var_00 = self;
	if(isdefined(var_00.fx))
	{
		playfx(var_00.fx,var_00.origin + (0,0,6));
	}

	var_00 delete();
}

//Function Number: 70
setupexploders()
{
	var_00 = getentarray("script_brushmodel","classname");
	var_01 = getentarray("script_model","classname");
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		var_00[var_00.size] = var_01[var_02];
	}

	for(var_02 = 0;var_02 < var_00.size;var_02++)
	{
		if(isdefined(var_00[var_02].script_prefab_exploder))
		{
			var_00[var_02].script_exploder = var_00[var_02].script_prefab_exploder;
		}

		if(isdefined(var_00[var_02].script_exploder))
		{
			if(var_00[var_02].model == "fx" && !isdefined(var_00[var_02].var_336) || var_00[var_02].var_336 != "exploderchunk")
			{
				var_00[var_02] hide();
				continue;
			}

			if(isdefined(var_00[var_02].var_336) && var_00[var_02].var_336 == "exploder")
			{
				var_00[var_02] hide();
				var_00[var_02] notsolid();
				continue;
			}

			if(isdefined(var_00[var_02].var_336) && var_00[var_02].var_336 == "exploderchunk")
			{
				var_00[var_02] hide();
				var_00[var_02] notsolid();
			}
		}
	}

	var_03 = [];
	var_04 = getentarray("script_brushmodel","classname");
	for(var_02 = 0;var_02 < var_04.size;var_02++)
	{
		if(isdefined(var_04[var_02].script_prefab_exploder))
		{
			var_04[var_02].script_exploder = var_04[var_02].script_prefab_exploder;
		}

		if(isdefined(var_04[var_02].script_exploder))
		{
			var_03[var_03.size] = var_04[var_02];
		}
	}

	var_04 = getentarray("script_model","classname");
	for(var_02 = 0;var_02 < var_04.size;var_02++)
	{
		if(isdefined(var_04[var_02].script_prefab_exploder))
		{
			var_04[var_02].script_exploder = var_04[var_02].script_prefab_exploder;
		}

		if(isdefined(var_04[var_02].script_exploder))
		{
			var_03[var_03.size] = var_04[var_02];
		}
	}

	var_04 = getentarray("item_health","classname");
	for(var_02 = 0;var_02 < var_04.size;var_02++)
	{
		if(isdefined(var_04[var_02].script_prefab_exploder))
		{
			var_04[var_02].script_exploder = var_04[var_02].script_prefab_exploder;
		}

		if(isdefined(var_04[var_02].script_exploder))
		{
			var_03[var_03.size] = var_04[var_02];
		}
	}

	if(!isdefined(level.createfxent))
	{
		level.createfxent = [];
	}

	var_05 = [];
	var_05["exploderchunk visible"] = 1;
	var_05["exploderchunk"] = 1;
	var_05["exploder"] = 1;
	for(var_02 = 0;var_02 < var_03.size;var_02++)
	{
		var_06 = var_03[var_02];
		var_07 = scripts\engine\utility::createexploder(var_06.script_fxid);
		var_07.v = [];
		var_07.v["origin"] = var_06.origin;
		var_07.v["angles"] = var_06.angles;
		var_07.v["delay"] = var_06.script_delay;
		var_07.v["firefx"] = var_06.script_firefx;
		var_07.v["firefxdelay"] = var_06.script_firefxdelay;
		var_07.v["firefxsound"] = var_06.script_firefxsound;
		var_07.v["firefxtimeout"] = var_06.var_ED96;
		var_07.v["earthquake"] = var_06.script_earthquake;
		var_07.v["damage"] = var_06.script_damage;
		var_07.v["damage_radius"] = var_06.script_radius;
		var_07.v["soundalias"] = var_06.script_soundalias;
		var_07.v["repeat"] = var_06.script_repeat;
		var_07.v["delay_min"] = var_06.script_delay_min;
		var_07.v["delay_max"] = var_06.script_delay_max;
		var_07.v["target"] = var_06.target;
		var_07.v["ender"] = var_06.script_ender;
		var_07.v["type"] = "exploder";
		if(!isdefined(var_06.script_fxid))
		{
			var_07.v["fxid"] = "No FX";
		}
		else
		{
			var_07.v["fxid"] = var_06.script_fxid;
		}

		var_07.v["exploder"] = var_06.script_exploder;
		if(!isdefined(var_07.v["delay"]))
		{
			var_07.v["delay"] = 0;
		}

		if(isdefined(var_06.target))
		{
			var_08 = getent(var_07.v["target"],"targetname").origin;
			var_07.v["angles"] = vectortoangles(var_08 - var_07.v["origin"]);
		}

		if(var_06.classname == "script_brushmodel" || isdefined(var_06.model))
		{
			var_07.model = var_06;
			var_07.model.disconnect_paths = var_06.script_disconnectpaths;
		}

		if(isdefined(var_06.var_336) && isdefined(var_05[var_06.var_336]))
		{
			var_07.v["exploder_type"] = var_06.var_336;
		}
		else
		{
			var_07.v["exploder_type"] = "normal";
		}

		var_07 scripts\common\createfx::post_entity_creation_function();
	}
}

//Function Number: 71
func_9817()
{
	level.uiparent = spawnstruct();
	level.uiparent.horzalign = "left";
	level.uiparent.vertalign = "top";
	level.uiparent.alignx = "left";
	level.uiparent.aligny = "top";
	level.uiparent.x = 0;
	level.uiparent.y = 0;
	level.uiparent.width = 0;
	level.uiparent.height = 0;
	level.uiparent.children = [];
	level.fontheight = 12;
	level.var_912F["allies"] = spawnstruct();
	level.var_912F["axis"] = spawnstruct();
	level.primaryprogressbary = -61;
	level.primaryprogressbarx = 0;
	level.primaryprogressbarheight = 9;
	level.primaryprogressbarwidth = 120;
	level.primaryprogressbartexty = -75;
	level.primaryprogressbartextx = 0;
	level.primaryprogressbarfontsize = 1.2;
	level.teamprogressbary = 32;
	level.teamprogressbarheight = 14;
	level.teamprogressbarwidth = 192;
	level.teamprogressbartexty = 8;
	level.teamprogressbarfontsize = 1.65;
	level.lowertextyalign = "BOTTOM";
	level.lowertexty = -140;
	level.lowertextfontsize = 1.2;
}

//Function Number: 72
exploder_load(param_00)
{
	level endon("killexplodertridgers" + param_00.script_exploder);
	param_00 waittill("trigger");
	if(isdefined(param_00.script_chance) && randomfloat(1) > param_00.script_chance)
	{
		if(isdefined(param_00.script_delay))
		{
			wait(param_00.script_delay);
		}
		else
		{
			wait(4);
		}

		level thread exploder_load(param_00);
		return;
	}

	scripts\engine\utility::exploder(param_00.script_exploder);
	level notify("killexplodertridgers" + param_00.script_exploder);
}

//Function Number: 73
player_init_health_regen()
{
	self.regenspeed = 1;
}

//Function Number: 74
player_init_invulnerability()
{
	self.haveinvulnerabilityavailable = 1;
}

//Function Number: 75
player_init_damageshield()
{
	self.damageshieldexpiretime = gettime();
}

//Function Number: 76
blank(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
}

//Function Number: 77
func_98BC()
{
	self setplayerdata("cp","alienSession","team_shots",0);
	self setplayerdata("cp","alienSession","team_kills",0);
	self setplayerdata("cp","alienSession","team_hives",0);
	self setplayerdata("cp","alienSession","downed",0);
	self setplayerdata("cp","alienSession","hivesDestroyed",0);
	self setplayerdata("cp","alienSession","prestigenerfs",0);
	self setplayerdata("cp","alienSession","repairs",0);
	self setplayerdata("cp","alienSession","drillPlants",0);
	self setplayerdata("cp","alienSession","deployables",0);
	self setplayerdata("cp","alienSession","challengesCompleted",0);
	self setplayerdata("cp","alienSession","challengesAttempted",0);
	self setplayerdata("cp","alienSession","trapKills",0);
	self setplayerdata("cp","alienSession","currencyTotal",0);
	self setplayerdata("cp","alienSession","currencySpent",0);
	self setplayerdata("cp","alienSession","kills",0);
	self setplayerdata("cp","alienSession","revives",0);
	self setplayerdata("cp","alienSession","time",0);
	self setplayerdata("cp","alienSession","score",0);
	self setplayerdata("cp","alienSession","shots",0);
	self setplayerdata("cp","alienSession","last_stand_count",0);
	self setplayerdata("cp","alienSession","deaths",0);
	self setplayerdata("cp","alienSession","headShots",0);
	self setplayerdata("cp","alienSession","hits",0);
	self setplayerdata("cp","alienSession","resources",0);
	self setplayerdata("cp","alienSession","waveNum",0);
}

//Function Number: 78
func_988E()
{
	if(isdefined(level.var_D0FE))
	{
		[[ level.var_D0FE ]]();
		return;
	}

	scripts\cp\cp_laststand::default_player_init_laststand();
}

//Function Number: 79
func_988B()
{
	level.var_A6CB = scripts\engine\utility::getstructarray("respawn_edge","targetname");
}

//Function Number: 80
func_7F56()
{
	return scripts\engine\utility::getclosest(self.origin,level.var_A6CB);
}
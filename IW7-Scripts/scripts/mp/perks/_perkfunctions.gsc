/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\perks\_perkfunctions.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 465
 * Decompile Time: 21064 ms
 * Timestamp: 10/27/2023 12:30:26 AM
*******************************************************************/

//Function Number: 1
setoverridearchetype()
{
}

//Function Number: 2
unsetoverridearchetype()
{
}

//Function Number: 3
setempimmune()
{
}

//Function Number: 4
unsetempimmune()
{
}

//Function Number: 5
setautospot()
{
	if(!isplayer(self))
	{
		return;
	}

	autospotadswatcher();
	autospotdeathwatcher();
}

//Function Number: 6
autospotdeathwatcher()
{
	self waittill("death");
	self endon("disconnect");
	self endon("endAutoSpotAdsWatcher");
	level endon("game_ended");
	self getomnvarvalue();
}

//Function Number: 7
unsetautospot()
{
	if(!isplayer(self))
	{
		return;
	}

	self notify("endAutoSpotAdsWatcher");
	self getomnvarvalue();
}

//Function Number: 8
autospotadswatcher()
{
	self endon("death");
	self endon("disconnect");
	self endon("endAutoSpotAdsWatcher");
	level endon("game_ended");
	var_00 = 0;
	for(;;)
	{
		wait(0.05);
		if(self isusingturret())
		{
			self getomnvarvalue();
			continue;
		}

		var_01 = self getweaponrankinfominxp();
		if(var_01 < 1 && var_00)
		{
			var_00 = 0;
			self getomnvarvalue();
		}

		if(var_01 < 1 && !var_00)
		{
			continue;
		}

		if(var_01 == 1 && !var_00)
		{
			var_00 = 1;
			self getoneshoteffectdelaydefault();
		}
	}
}

//Function Number: 9
setregenfaster()
{
	self.trait = "specialty_regenfaster";
}

//Function Number: 10
unsetregenfaster()
{
	self.trait = undefined;
}

//Function Number: 11
timeoutregenfaster()
{
	self.hasregenfaster = undefined;
	scripts\mp\_utility::removeperk("specialty_regenfaster");
	self setclientdvar("ui_regen_faster_end_milliseconds",0);
	self notify("timeOutRegenFaster");
}

//Function Number: 12
sethardshell()
{
	self.shellshockreduction = 0.25;
}

//Function Number: 13
unsethardshell()
{
	self.shellshockreduction = 0;
}

//Function Number: 14
setsharpfocus()
{
	thread monitorsharpfocus();
}

//Function Number: 15
monitorsharpfocus()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("stop_monitorSharpFocus");
	for(;;)
	{
		updatesharpfocus();
		self waittill("weapon_change");
	}
}

//Function Number: 16
updatesharpfocus()
{
	var_00 = self getcurrentweapon();
	var_01 = undefined;
	if(level.tactical)
	{
		if(weaponclass(var_00) == "sniper")
		{
			var_01 = 0.85;
		}
		else
		{
			var_01 = 0.5;
		}
	}
	else if(weaponclass(var_00) == "sniper")
	{
		var_01 = 0.85;
	}
	else
	{
		var_01 = 0.25;
	}

	scripts\mp\_weapons::updateviewkickscale(var_01);
}

//Function Number: 17
unsetsharpfocus()
{
	self notify("stop_monitorSharpFocus");
	scripts\mp\_weapons::updateviewkickscale(1);
}

//Function Number: 18
setviewkickoverride()
{
	self.overrideviewkickscale = 0.2;
	self.overrideviewkickscalesniper = 0.425;
	scripts\mp\_weapons::updateviewkickscale();
}

//Function Number: 19
unsetviewkickoverride()
{
	self.overrideviewkickscale = undefined;
	self.overrideviewkickscalesniper = undefined;
	scripts\mp\_weapons::updateviewkickscale();
}

//Function Number: 20
setaffinityspeedboost()
{
	self.weaponaffinityspeedboost = 0.08;
	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 21
unsetaffinityspeedboost()
{
	self.weaponaffinityspeedboost = undefined;
	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 22
setaffinityextralauncher()
{
	self.weaponaffinityextralauncher = 1;
	var_00 = scripts\mp\_class::buildweaponname(self.loadoutprimary,self.loadoutprimaryattachments,self.loadoutprimarycamo,self.loadoutprimaryreticle,self.loadoutprimaryvariantid);
	var_01 = scripts\mp\_class::buildweaponname(self.loadoutsecondary,self.loadoutsecondaryattachments,self.loadoutsecondarycamo,self.loadoutsecondaryreticle,self.var_AEA5);
	if(scripts\mp\_utility::getweapongroup(var_00) == "weapon_projectile")
	{
		self setweaponammoclip(var_00,weaponclipsize(var_00));
	}

	if(scripts\mp\_utility::getweapongroup(var_01) == "weapon_projectile")
	{
		self setweaponammoclip(var_01,weaponclipsize(var_01));
	}
}

//Function Number: 23
unsetaffinityextralauncher()
{
	self.weaponaffinityextralauncher = undefined;
}

//Function Number: 24
setdoubleload()
{
	self endon("death");
	self endon("disconnect");
	self endon("endDoubleLoad");
	level endon("game_ended");
	for(;;)
	{
		self waittill("reload");
		var_00 = self getweaponslist("primary");
		foreach(var_02 in var_00)
		{
			var_03 = self getweaponammoclip(var_02);
			var_04 = weaponclipsize(var_02);
			var_05 = var_04 - var_03;
			var_06 = self getweaponammostock(var_02);
			if(var_03 != var_04 && var_06 > 0)
			{
				if(var_03 + var_06 >= var_04)
				{
					self setweaponammoclip(var_02,var_04);
					self setweaponammostock(var_02,var_06 - var_05);
					continue;
				}

				self setweaponammoclip(var_02,var_03 + var_06);
				if(var_06 - var_05 > 0)
				{
					self setweaponammostock(var_02,var_06 - var_05);
					continue;
				}

				self setweaponammostock(var_02,0);
			}
		}
	}
}

//Function Number: 25
unsetdoubleload()
{
	self notify("endDoubleLoad");
}

//Function Number: 26
setmarksman(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 10;
	}
	else
	{
		param_00 = int(param_00) * 2;
	}

	scripts\mp\_utility::setrecoilscale(param_00);
	self.recoilscale = param_00;
}

//Function Number: 27
unsetmarksman()
{
	scripts\mp\_utility::setrecoilscale(0);
	self.recoilscale = 0;
}

//Function Number: 28
setfastcrouch()
{
	thread watchfastcrouch();
}

//Function Number: 29
watchfastcrouch()
{
	self endon("death");
	self endon("disconnect");
	self endon("fastcrouch_unset");
	for(;;)
	{
		var_00 = self getstance() == "crouch" && !self issprintsliding();
		if(!isdefined(self.fastcrouchspeedmod))
		{
			if(var_00)
			{
				self.fastcrouchspeedmod = 0.3;
				scripts\mp\_weapons::updatemovespeedscale();
			}
		}
		else if(!var_00)
		{
			self.fastcrouchspeedmod = undefined;
			scripts\mp\_weapons::updatemovespeedscale();
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 30
unsetfastcrouch()
{
	self notify("fastcrouch_unset");
	if(isdefined(self.fastcrouchspeedmod))
	{
		self.fastcrouchspeedmod = undefined;
		scripts\mp\_weapons::updatemovespeedscale();
	}
}

//Function Number: 31
setrshieldradar()
{
	self endon("unsetRShieldRadar");
	wait(0.75);
	self makeportableradar();
	thread setrshieldradar_cleanup();
}

//Function Number: 32
setrshieldradar_cleanup()
{
	self endon("unsetRShieldRadar");
	scripts\engine\utility::waittill_any_3("disconnect","death");
	if(isdefined(self))
	{
		func_12D1D();
	}
}

//Function Number: 33
func_12D1D()
{
	self getplayermodelname();
	self notify("unsetRShieldRadar");
}

//Function Number: 34
setrshieldscrambler()
{
	self makescrambler();
	thread setrshieldscrambler_cleanup();
}

//Function Number: 35
setrshieldscrambler_cleanup()
{
	self endon("unsetRShieldScrambler");
	scripts\engine\utility::waittill_any_3("disconnect","death");
	if(isdefined(self))
	{
		unsetrshieldscrambler();
	}
}

//Function Number: 36
unsetrshieldscrambler()
{
	self clearscrambler();
	self notify("unsetRShieldScrambler");
}

//Function Number: 37
setstunresistance(param_00)
{
	scripts\mp\_utility::giveperk("specialty_hard_shell");
	if(!isdefined(param_00))
	{
		param_00 = 10;
	}

	param_00 = int(param_00);
	if(param_00 == 10)
	{
		self.stunscalar = 0;
		return;
	}

	self.stunscalar = param_00 / 10;
}

//Function Number: 38
unsetstunresistance()
{
	self.stunscalar = 1;
}

//Function Number: 39
applystunresistence(param_00,param_01,param_02)
{
	if(param_01 scripts\mp\_utility::_hasperk("specialty_stun_resistance"))
	{
		if(isdefined(param_01.stunscalar) && isdefined(param_02))
		{
			param_02 = param_02 * param_01.stunscalar;
		}

		var_03 = scripts\engine\utility::ter_op(isdefined(param_00.triggerportableradarping),param_00.triggerportableradarping,param_00);
		var_04 = scripts\engine\utility::ter_op(isdefined(param_01.triggerportableradarping),param_01.triggerportableradarping,param_01);
		if(isplayer(var_03) && var_03 != param_01)
		{
			param_00 scripts\mp\_damagefeedback::updatedamagefeedback("hittacresist",undefined,undefined,undefined,1);
		}

		if(scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_03,var_04)))
		{
			param_01 scripts\mp\_missions::resistedstun(var_03);
		}
	}

	return param_02;
}

//Function Number: 40
setweaponlaser()
{
	if(isagent(self))
	{
		return;
	}

	self endon("unsetWeaponLaser");
	wait(0.5);
	thread setweaponlaser_internal();
}

//Function Number: 41
unsetweaponlaser()
{
	self notify("unsetWeaponLaser");
	if(isdefined(self.perkweaponlaseron) && self.perkweaponlaseron)
	{
		scripts\mp\_utility::disableweaponlaser();
	}

	self.perkweaponlaseron = undefined;
	self.perkweaponlaseroffforswitchstart = undefined;
}

//Function Number: 42
setweaponlaser_waitforlaserweapon(param_00)
{
	for(;;)
	{
		param_00 = getweaponbasename(param_00);
		if(isdefined(param_00) && param_00 == "iw6_kac_mp" || param_00 == "iw6_arx160_mp")
		{
			break;
		}

		self waittill("weapon_change",param_00);
	}
}

//Function Number: 43
setweaponlaser_internal()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetWeaponLaser");
	self.perkweaponlaseron = 0;
	var_00 = self getcurrentweapon();
	for(;;)
	{
		setweaponlaser_waitforlaserweapon(var_00);
		if(self.perkweaponlaseron == 0)
		{
			self.perkweaponlaseron = 1;
			scripts\mp\_utility::enableweaponlaser();
		}

		childthread setweaponlaser_monitorads();
		childthread setweaponlaser_monitorweaponswitchstart(1);
		self.perkweaponlaseroffforswitchstart = undefined;
		self waittill("weapon_change",var_00);
		if(self.perkweaponlaseron == 1)
		{
			self.perkweaponlaseron = 0;
			scripts\mp\_utility::disableweaponlaser();
		}
	}
}

//Function Number: 44
setweaponlaser_monitorweaponswitchstart(param_00)
{
	self endon("weapon_change");
	for(;;)
	{
		self waittill("weapon_switch_started");
		childthread setweaponlaser_onweaponswitchstart(param_00);
	}
}

//Function Number: 45
setweaponlaser_onweaponswitchstart(param_00)
{
	self notify("setWeaponLaser_onWeaponSwitchStart");
	self endon("setWeaponLaser_onWeaponSwitchStart");
	if(self.perkweaponlaseron == 1)
	{
		self.perkweaponlaseroffforswitchstart = 1;
		self.perkweaponlaseron = 0;
		scripts\mp\_utility::disableweaponlaser();
	}

	wait(param_00);
	self.perkweaponlaseroffforswitchstart = undefined;
	if(self.perkweaponlaseron == 0 && self getweaponrankinfominxp() <= 0.6)
	{
		self.perkweaponlaseron = 1;
		scripts\mp\_utility::enableweaponlaser();
	}
}

//Function Number: 46
setweaponlaser_monitorads()
{
	self endon("weapon_change");
	for(;;)
	{
		if(!isdefined(self.perkweaponlaseroffforswitchstart) || self.perkweaponlaseroffforswitchstart == 0)
		{
			if(self getweaponrankinfominxp() > 0.6)
			{
				if(self.perkweaponlaseron == 1)
				{
					self.perkweaponlaseron = 0;
					scripts\mp\_utility::disableweaponlaser();
				}
			}
			else if(self.perkweaponlaseron == 0)
			{
				self.perkweaponlaseron = 1;
				scripts\mp\_utility::enableweaponlaser();
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 47
setsteadyaimpro()
{
	self setaimspreadmovementscale(0.5);
}

//Function Number: 48
unsetsteadyaimpro()
{
	self notify("end_SteadyAimPro");
	self setaimspreadmovementscale(1);
}

//Function Number: 49
blastshieldusetracker(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	self endon("end_perkUseTracker");
	level endon("game_ended");
	for(;;)
	{
		self waittill("empty_offhand");
		if(!scripts\engine\utility::isoffhandweaponsallowed())
		{
			continue;
		}

		self [[ param_01 ]](scripts\mp\_utility::_hasperk("specialty_blastshield"));
	}
}

//Function Number: 50
perkusedeathtracker()
{
	self endon("disconnect");
	self waittill("death");
	self._useperkenabled = undefined;
}

//Function Number: 51
setendgame()
{
	if(isdefined(self.endgame))
	{
		return;
	}

	self.maxhealth = scripts\mp\_tweakables::gettweakablevalue("player","maxhealth") * 4;
	self.health = self.maxhealth;
	self.endgame = 1;
	self.attackertable[0] = "";
	self visionsetnakedforplayer("end_game",5);
	thread endgamedeath(7);
	scripts\mp\_gamelogic::sethasdonecombat(self,1);
}

//Function Number: 52
unsetendgame()
{
	self notify("stopEndGame");
	self.endgame = undefined;
	scripts\mp\_utility::restorebasevisionset(1);
	if(!isdefined(self.endgametimer))
	{
		return;
	}

	self.endgametimer scripts\mp\_hud_util::destroyelem();
	self.endgameicon scripts\mp\_hud_util::destroyelem();
}

//Function Number: 53
endgamedeath(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	level endon("game_ended");
	self endon("stopEndGame");
	wait(param_00 + 1);
	scripts\mp\_utility::_suicide();
}

//Function Number: 54
setsaboteur()
{
	self.objectivescaler = 1.2;
}

//Function Number: 55
unsetsaboteur()
{
	self.objectivescaler = 1;
}

//Function Number: 56
setcombatspeed()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetCombatSpeed");
	self.incombatspeed = 0;
	unsetcombatspeedscalar();
	for(;;)
	{
		self waittill("damage",var_00,var_01);
		if(!isdefined(var_01.team))
		{
			continue;
		}

		if(level.teambased && var_01.team == self.team)
		{
			continue;
		}

		if(self.incombatspeed)
		{
			continue;
		}

		setcombatspeedscalar();
		self.incombatspeed = 1;
		thread func_636C();
	}
}

//Function Number: 57
func_636C()
{
	self notify("endOfSpeedWatcher");
	self endon("endOfSpeedWatcher");
	self endon("death");
	self endon("disconnect");
	self waittill("healed");
	unsetcombatspeedscalar();
	self.incombatspeed = 0;
}

//Function Number: 58
setcombatspeedscalar()
{
	if(isdefined(self.isjuggernaut) && self.isjuggernaut)
	{
		return;
	}

	if(self.weaponspeed <= 0.8)
	{
		self.combatspeedscalar = 1.4;
	}
	else if(self.weaponspeed <= 0.9)
	{
		self.combatspeedscalar = 1.3;
	}
	else
	{
		self.combatspeedscalar = 1.2;
	}

	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 59
unsetcombatspeedscalar()
{
	self.combatspeedscalar = 1;
	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 60
unsetcombatspeed()
{
	unsetcombatspeedscalar();
	self notify("unsetCombatSpeed");
}

//Function Number: 61
setlightweight()
{
	if(!isdefined(self.cranked))
	{
		self.movespeedscaler = scripts\mp\_utility::lightweightscalar();
		scripts\mp\_weapons::updatemovespeedscale();
	}
}

//Function Number: 62
unsetlightweight()
{
	self.movespeedscaler = 1;
	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 63
setblackbox()
{
	self.killstreakscaler = 1.5;
}

//Function Number: 64
unsetblackbox()
{
	self.killstreakscaler = 1;
}

//Function Number: 65
setsteelnerves()
{
	scripts\mp\_utility::giveperk("specialty_bulletaccuracy");
	scripts\mp\_utility::giveperk("specialty_holdbreath");
}

//Function Number: 66
unsetsteelnerves()
{
	scripts\mp\_utility::removeperk("specialty_bulletaccuracy");
	scripts\mp\_utility::removeperk("specialty_holdbreath");
}

//Function Number: 67
setdelaymine()
{
}

//Function Number: 68
unsetdelaymine()
{
}

//Function Number: 69
setlocaljammer()
{
	if(!scripts\mp\killstreaks\_emp_common::isemped())
	{
		self makescrambler();
	}
}

//Function Number: 70
unsetlocaljammer()
{
	self clearscrambler();
}

//Function Number: 71
setthermal()
{
	self thermalvisionon();
}

//Function Number: 72
unsetthermal()
{
	self thermalvisionoff();
}

//Function Number: 73
setonemanarmy()
{
	thread onemanarmyweaponchangetracker();
}

//Function Number: 74
unsetonemanarmy()
{
	self notify("stop_oneManArmyTracker");
}

//Function Number: 75
onemanarmyweaponchangetracker()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("stop_oneManArmyTracker");
	for(;;)
	{
		self waittill("weapon_change",var_00);
		if(var_00 != "onemanarmy_mp")
		{
			continue;
		}

		thread selectonemanarmyclass();
	}
}

//Function Number: 76
isonemanarmymenu(param_00)
{
	if(param_00 == game["menu_onemanarmy"])
	{
		return 1;
	}

	if(isdefined(game["menu_onemanarmy_defaults_splitscreen"]) && param_00 == game["menu_onemanarmy_defaults_splitscreen"])
	{
		return 1;
	}

	if(isdefined(game["menu_onemanarmy_custom_splitscreen"]) && param_00 == game["menu_onemanarmy_custom_splitscreen"])
	{
		return 1;
	}

	return 0;
}

//Function Number: 77
selectonemanarmyclass()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	scripts\engine\utility::allow_weapon_switch(0);
	scripts\engine\utility::allow_offhand_weapons(0);
	scripts\engine\utility::allow_usability(0);
	thread closeomamenuondeath();
	self waittill("menuresponse",var_00,var_01);
	scripts\engine\utility::allow_weapon_switch(1);
	scripts\engine\utility::allow_offhand_weapons(1);
	scripts\engine\utility::allow_usability(1);
	if(var_01 == "back" || !isonemanarmymenu(var_00) || scripts\mp\_utility::isusingremote())
	{
		if(self getcurrentweapon() == "onemanarmy_mp")
		{
			scripts\engine\utility::allow_weapon_switch(0);
			scripts\engine\utility::allow_offhand_weapons(0);
			scripts\engine\utility::allow_usability(0);
			scripts\mp\_utility::_switchtoweapon(scripts\engine\utility::getlastweapon());
			self waittill("weapon_change");
			scripts\engine\utility::allow_weapon_switch(1);
			scripts\engine\utility::allow_offhand_weapons(1);
			scripts\engine\utility::allow_usability(1);
		}

		return;
	}

	thread giveonemanarmyclass(var_01);
}

//Function Number: 78
closeomamenuondeath()
{
	self endon("menuresponse");
	self endon("disconnect");
	level endon("game_ended");
	self waittill("death");
	scripts\engine\utility::allow_weapon_switch(1);
	scripts\engine\utility::allow_offhand_weapons(1);
	scripts\engine\utility::allow_usability(1);
}

//Function Number: 79
giveonemanarmyclass(param_00)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	if(scripts\mp\_utility::_hasperk("specialty_omaquickchange"))
	{
		var_01 = 3;
		scripts\mp\_utility::playplayerandnpcsounds(self,"foly_onemanarmy_bag3_plr","foly_onemanarmy_bag3_npc");
	}
	else
	{
		var_01 = 6;
		scripts\mp\_utility::playplayerandnpcsounds(self,"foly_onemanarmy_bag6_plr","foly_onemanarmy_bag6_npc");
	}

	thread omausebar(var_01);
	scripts\engine\utility::allow_weapon(0);
	scripts\engine\utility::allow_offhand_weapons(0);
	scripts\engine\utility::allow_usability(0);
	wait(var_01);
	scripts\engine\utility::allow_weapon(1);
	scripts\engine\utility::allow_offhand_weapons(1);
	scripts\engine\utility::allow_usability(1);
	self.var_C47E = 1;
	scripts\mp\_class::giveloadout(self.pers["team"],param_00);
	if(isdefined(self.carryflag))
	{
		self attach(self.carryflag,"J_spine4",1);
	}

	self notify("changed_kit");
	level notify("changed_kit");
}

//Function Number: 80
omausebar(param_00)
{
	self endon("disconnect");
	var_01 = scripts\mp\_hud_util::createprimaryprogressbar();
	var_02 = scripts\mp\_hud_util::createprimaryprogressbartext();
	var_02 settext(&"MPUI_CHANGING_KIT");
	var_01 scripts\mp\_hud_util::updatebar(0,1 / param_00);
	var_03 = 0;
	while(var_03 < param_00 && isalive(self) && !level.gameended)
	{
		wait(0.05);
		var_03 = var_03 + 0.05;
	}

	var_01 scripts\mp\_hud_util::destroyelem();
	var_02 scripts\mp\_hud_util::destroyelem();
}

//Function Number: 81
setafterburner()
{
	self.trait = "specialty_afterburner";
	self goalflag(0,scripts\engine\utility::ter_op(scripts\mp\_utility::isanymlgmatch(),600,650));
	self goal_type(0,scripts\engine\utility::ter_op(scripts\mp\_utility::isanymlgmatch(),900,900));
}

//Function Number: 82
unsetafterburner()
{
	self.trait = undefined;
	self goalflag(0,400);
	self goal_type(0,900);
}

//Function Number: 83
setblastshield()
{
	self _meth_8376("primaryoffhand","icon_perks_blast_shield");
}

//Function Number: 84
unsetblastshield()
{
	self _meth_8376("primaryoffhand","none");
}

//Function Number: 85
setfreefall()
{
}

//Function Number: 86
unsetfreefall()
{
}

//Function Number: 87
settacticalinsertion()
{
	var_00 = "secondary";
	var_01 = scripts\mp\_powers::getcurrentequipment(var_00);
	if(isdefined(var_01))
	{
		scripts\mp\_powers::removepower(var_01);
	}

	scripts\mp\_powers::givepower("power_tacInsert",var_00,0);
	thread func_BA34();
}

//Function Number: 88
unsettacticalinsertion()
{
	self notify("end_monitorTIUse");
}

//Function Number: 89
func_41D2()
{
	scripts\engine\utility::waittill_any_3("disconnect","joined_team","joined_spectators");
	if(isdefined(self.setspawnpoint))
	{
		deleteti(self.setspawnpoint);
	}
}

//Function Number: 90
func_12F47()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("end_monitorTIUse");
	while(scripts\mp\_utility::isreallyalive(self))
	{
		if(func_9FE9())
		{
			self.var_11947 = self.origin;
		}

		wait(0.05);
	}
}

//Function Number: 91
func_9FE9()
{
	if(canspawn(self.origin) && self isonground() && !scripts\mp\_utility::func_11A44())
	{
		return 1;
	}

	return 0;
}

//Function Number: 92
func_11899(param_00)
{
	if(scripts\mp\_utility::isreallyalive(param_00.triggerportableradarping))
	{
		param_00.triggerportableradarping deleteti(self);
	}
}

//Function Number: 93
func_BA34()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("end_monitorTIUse");
	thread func_12F47();
	thread func_41D2();
	for(;;)
	{
		self waittill("grenade_fire",var_00,var_01);
		if(var_01 != "flare_mp")
		{
			continue;
		}

		if(isdefined(self.setspawnpoint))
		{
			deleteti(self.setspawnpoint);
		}

		if(!isdefined(self.var_11947))
		{
			continue;
		}

		if(scripts\mp\_utility::touchingbadtrigger())
		{
			continue;
		}

		var_02 = self.var_11947 + (0,0,16);
		var_03 = self.var_11947 - (0,0,2048);
		var_04 = playerphysicstrace(var_02,var_03) + (0,0,1);
		var_05 = [];
		var_05[0] = self;
		var_06 = scripts\common\trace::create_contents(1,1,1,1,0,1,1);
		var_07 = scripts\common\trace::ray_trace(var_02,var_03,var_05,var_06,0);
		var_08 = spawn("script_model",var_04);
		var_08.angles = self.angles;
		var_08.team = self.team;
		var_08.triggerportableradarping = self;
		var_08.enemytrigger = spawn("script_origin",var_04);
		var_08 thread _meth_83EC(self);
		var_08.playerspawnpos = self.var_11947;
		var_08 setotherent(self);
		var_08 scripts\mp\sentientpoolmanager::registersentient("Tactical_Static",self);
		var_08 scripts\mp\_weapons::explosivehandlemovers(var_07["entity"]);
		scripts\mp\_weapons::ontacticalequipmentplanted(var_08);
		self.setspawnpoint = var_08;
	}
}

//Function Number: 94
_meth_83EC(param_00)
{
	self setmodel(level.var_108D3["enemy"]);
	if(level.teambased)
	{
		scripts\mp\_entityheadicons::setteamheadicon(self.team,(0,0,20));
	}
	else
	{
		scripts\mp\_entityheadicons::setplayerheadicon(param_00,(0,0,20));
	}

	thread _meth_83E8(param_00);
	thread _meth_83E9(param_00);
	thread _meth_83EE(param_00);
	thread _meth_83EF(param_00);
	var_01 = spawn("script_model",self.origin);
	var_01.angles = self.angles;
	var_01 setmodel(level.var_108D3["friendly"]);
	var_01 setcontents(0);
	var_01 linkto(self);
	var_01 playloopsound("tactical_insert_lp");
	thread _meth_83ED(self,var_01,param_00);
	self waittill("death");
	var_01 stoploopsound();
	var_01 delete();
}

//Function Number: 95
_meth_83ED(param_00,param_01,param_02)
{
	param_00 endon("death");
	wait(0.05);
	var_03 = [];
	var_03["enemy"] = param_00;
	var_03["friendly"] = param_01;
	for(;;)
	{
		foreach(var_05 in var_03)
		{
			var_05 hide();
		}

		foreach(var_08 in level.players)
		{
			var_09 = "friendly";
			if(param_02 scripts\mp\_utility::isenemy(var_08))
			{
				var_09 = "enemy";
			}

			var_05 = var_03[var_09];
			var_05 show();
			scripts\engine\utility::waitframe();
			playfxontagforclients(level.var_108D2[var_09],var_05,"tag_fx",var_08);
		}

		level waittill("joined_team");
		foreach(var_09, var_05 in var_03)
		{
			stopfxontag(level.var_108D2[var_09],var_05,"tag_fx");
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 96
deleteondeath(param_00)
{
	self waittill("death");
	if(isdefined(param_00))
	{
		param_00 delete();
	}
}

//Function Number: 97
_meth_83E8(param_00)
{
	scripts\mp\_damage::monitordamage(100,"tactical_insertion",::_meth_83EB,::_meth_83EA,1);
}

//Function Number: 98
_meth_83EB(param_00,param_01,param_02,param_03,param_04)
{
	return scripts\mp\_damage::handlemeleedamage(param_01,param_02);
}

//Function Number: 99
_meth_83EA(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(self.triggerportableradarping) && param_00 != self.triggerportableradarping)
	{
		param_00 notify("destroyed_insertion",self.triggerportableradarping);
		param_00 notify("destroyed_equipment");
		self.triggerportableradarping thread scripts\mp\_utility::leaderdialogonplayer("ti_destroyed",undefined,undefined,self.origin);
	}

	param_00 thread deleteti(self);
}

//Function Number: 100
_meth_83EE(param_00)
{
	self endon("death");
	level endon("game_ended");
	param_00 endon("disconnect");
	self setcursorhint("HINT_NOICON");
	self sethintstring(&"MP_PATCH_PICKUP_TI");
	thread func_12E8B(param_00);
	for(;;)
	{
		self waittill("trigger",var_01);
		var_01 playsound("tactical_insert_flare_pu");
		if(!var_01 scripts\mp\_utility::isjuggernaut())
		{
			var_01 thread settacticalinsertion();
		}

		var_01 thread deleteti(self);
	}
}

//Function Number: 101
func_12E8B(param_00)
{
	self endon("death");
	for(;;)
	{
		scripts\mp\_utility::setselfusable(param_00);
		level scripts\engine\utility::waittill_either("joined_team","player_spawned");
	}
}

//Function Number: 102
_meth_83EF(param_00)
{
	self endon("death");
	param_00 waittill("disconnect");
	thread deleteti(self);
}

//Function Number: 103
deleteti(param_00)
{
	if(isdefined(param_00.enemytrigger))
	{
		param_00.enemytrigger delete();
	}

	var_01 = param_00.origin;
	var_02 = param_00.angles;
	var_03 = param_00 getlinkedparent();
	param_00 delete();
	var_04 = spawn("script_model",var_01);
	var_04.angles = var_02;
	var_04 setmodel(level.var_108D3["friendly"]);
	var_04 setcontents(0);
	if(isdefined(var_03))
	{
		var_04 linkto(var_03);
	}

	thread func_5F2B(var_04);
}

//Function Number: 104
func_5F2B(param_00)
{
	wait(1);
	stopfxontag(level.var_108D2["friendly"],param_00,"tag_fx");
	stopfxontag(level.var_108D2["enemy"],param_00,"tag_fx");
	param_00 delete();
}

//Function Number: 105
_meth_83E9(param_00)
{
	self endon("death");
	level endon("game_ended");
	param_00 endon("disconnect");
	self.enemytrigger setcursorhint("HINT_NOICON");
	self.enemytrigger sethintstring(&"MP_PATCH_DESTROY_TI");
	self.enemytrigger scripts\mp\_utility::makeenemyusable(param_00);
	for(;;)
	{
		self.enemytrigger waittill("trigger",var_01);
		var_01 notify("destroyed_insertion",param_00);
		var_01 notify("destroyed_equipment");
		if(isdefined(param_00) && var_01 != param_00)
		{
			param_00 thread scripts\mp\_utility::leaderdialogonplayer("ti_destroyed",undefined,undefined,self.origin);
		}

		var_01 thread deleteti(self);
	}
}

//Function Number: 106
setpainted(param_00)
{
	if(isplayer(self))
	{
		var_01 = 0.5;
		if(!scripts\mp\_utility::_hasperk("specialty_engineer") && !scripts\mp\_utility::_hasperk("specialty_noscopeoutline"))
		{
			self.painted = 1;
			var_02 = scripts\mp\_utility::outlineenableforplayer(self,"orange",param_00,0,0,"perk");
			thread watchpainted(var_02,var_01);
			thread watchpaintedagain(var_02);
		}
	}
}

//Function Number: 107
watchpainted(param_00,param_01)
{
	self notify("painted_again");
	self endon("painted_again");
	self endon("disconnect");
	level endon("game_ended");
	scripts\engine\utility::waittill_any_timeout_1(param_01,"death");
	self.painted = 0;
	scripts\mp\_utility::outlinedisable(param_00,self);
	self notify("painted_end");
}

//Function Number: 108
watchpaintedagain(param_00)
{
	self endon("disconnect");
	level endon("game_ended");
	scripts\engine\utility::waittill_any_3("painted_again","painted_end");
	scripts\mp\_utility::outlinedisable(param_00,self);
}

//Function Number: 109
ispainted()
{
	return isdefined(self.painted) && self.painted;
}

//Function Number: 110
setassists()
{
}

//Function Number: 111
unsetassists()
{
}

//Function Number: 112
setrefillgrenades()
{
	if(isdefined(self.primarygrenade))
	{
		self givemaxammo(self.primarygrenade);
	}

	if(isdefined(self.secondarygrenade))
	{
		self givemaxammo(self.secondarygrenade);
	}
}

//Function Number: 113
unsetrefillgrenades()
{
}

//Function Number: 114
setrefillammo()
{
	if(isdefined(self.primaryweapon))
	{
		self givemaxammo(self.primaryweapon);
	}

	if(isdefined(self.secondaryweapon))
	{
		self givemaxammo(self.secondaryweapon);
	}
}

//Function Number: 115
unsetrefillammo()
{
}

//Function Number: 116
func_F737()
{
	thread func_F738();
}

//Function Number: 117
func_F738()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	self endon("unsetGunsmith");
	self waittill("giveLoadout");
	if(self.loadoutprimaryattachments.size == 0 && self.loadoutsecondaryattachments.size == 0)
	{
		return;
	}

	for(;;)
	{
		self waittill("weapon_change",var_00);
		if(var_00 == "none")
		{
			continue;
		}

		if(scripts\mp\_utility::iskillstreakweapon(var_00))
		{
			continue;
		}

		if(!scripts\mp\_utility::isstrstart(var_00,"iw6_") && !scripts\mp\_utility::isstrstart(var_00,"iw7_"))
		{
			continue;
		}

		var_01 = undefined;
		if(scripts\mp\_utility::getweapongroup(var_00) == "weapon_pistol")
		{
			if(self.loadoutsecondaryattachments.size > 0)
			{
				var_01 = self.loadoutsecondaryattachments;
			}
		}
		else if(self.loadoutprimaryattachments.size > 0)
		{
			var_01 = self.loadoutprimaryattachments;
		}

		if(!isdefined(var_01))
		{
			continue;
		}

		var_02 = 0;
		var_03 = scripts\mp\_utility::getweaponattachmentsbasenames(var_00);
		if(var_03.size == 0)
		{
			var_02 = 1;
		}
		else
		{
			foreach(var_05 in var_01)
			{
				if(!scripts\engine\utility::array_contains(var_03,var_05))
				{
					var_02 = 1;
					break;
				}
			}
		}

		if(!var_02)
		{
			continue;
		}

		var_07 = [];
		var_08 = scripts\mp\_utility::getweaponattachmentarrayfromstats(var_00);
		foreach(var_05 in var_01)
		{
			if(scripts\engine\utility::array_contains(var_08,var_05))
			{
				var_07[var_07.size] = var_05;
			}
		}

		var_01 = var_07;
		var_0B = [];
		foreach(var_0D in var_03)
		{
			var_0E = 1;
			foreach(var_10 in var_01)
			{
				if(!scripts\mp\_utility::attachmentscompatible(var_10,var_0D))
				{
					var_0E = 0;
					break;
				}
			}

			if(var_0E)
			{
				var_0B[var_0B.size] = var_0D;
			}
		}

		var_03 = var_0B;
		var_13 = var_01.size + var_03.size;
		if(var_13 > 4)
		{
			var_03 = scripts\engine\utility::array_randomize(var_03);
		}

		for(var_14 = 0;var_01.size < 4 && var_14 < var_03.size;var_14++)
		{
			var_01[var_01.size] = var_03[var_14];
		}

		var_15 = getweaponbasename(var_00);
		var_16 = var_15;
		foreach(var_14, var_05 in var_01)
		{
			var_18 = scripts\mp\_utility::attachmentmap_tounique(var_05,var_00);
			var_01[var_14] = var_18;
		}

		var_01 = scripts\engine\utility::alphabetize(var_01);
		foreach(var_05 in var_01)
		{
			var_16 = var_16 + "_" + var_05;
		}

		if(var_16 != var_15)
		{
			var_1B = self getweaponammoclip(var_00);
			var_1C = self getweaponammostock(var_00);
			scripts\mp\_utility::_takeweapon(var_00);
			self giveweapon(var_16);
			self setweaponammoclip(var_16,var_1B);
			self setweaponammostock(var_16,var_1C);
			scripts\mp\_utility::_switchtoweapon(var_16);
		}
	}
}

//Function Number: 118
func_12CCB()
{
	self notify("unsetGunsmith");
}

//Function Number: 119
func_F71F()
{
	self setclientomnvar("ui_gambler_show",-1);
	func_F720();
}

//Function Number: 120
func_F720()
{
}

//Function Number: 121
func_765A()
{
	if(!isai(self))
	{
		return self getplayerdata(level.loadoutsgroup,"squadMembers","loadouts",self.class_num,"abilitiesPicked",scripts\mp\_utility::func_7D91(6,0));
	}
	else
	{
		var_00 = [];
		if(isdefined(self.pers["loadoutPerks"]))
		{
			var_00 = scripts\engine\utility::array_combine(var_00,self.pers["loadoutPerks"]);
		}

		foreach(var_02 in var_00)
		{
			if(scripts\mp\_utility::getbaseperkname(var_02) == "specialty_gambler")
			{
				return 1;
			}
		}
	}

	return 0;
}

//Function Number: 122
givefriendlyperks(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetGambler");
	level endon("game_ended");
	if(!scripts\mp\_utility::gameflag("prematch_done"))
	{
		scripts\mp\_utility::gameflagwait("prematch_done");
	}
	else if(scripts\mp\_utility::gameflag("prematch_done") && self.streaktype != "specialist")
	{
		self waittill("giveLoadout");
	}

	if(!isdefined(self.var_1519))
	{
		self.var_1519 = 0;
	}

	if(!self.var_1519)
	{
		var_01 = getrandom_spammodel(param_00);
		self.var_7658 = var_01;
	}
	else
	{
		var_01 = self.var_7658;
	}

	scripts\mp\_utility::giveperk(var_01.id);
	if(var_01.id == "specialty_hardline")
	{
		scripts\mp\killstreaks\_killstreaks::func_F866();
	}

	if(func_1012B())
	{
		self playlocalsound("mp_suitcase_pickup");
		self setclientomnvar("ui_gambler_show",var_01.var_E76D);
		thread func_7659();
	}

	if(level.gametype != "infect")
	{
		self.var_1519 = 1;
	}
}

//Function Number: 123
func_1012B()
{
	var_00 = 1;
	if(!level.ingraceperiod && self.var_1519)
	{
		var_00 = 0;
	}

	if(!scripts\mp\_utility::allowclasschoice() && level.gametype != "infect")
	{
		var_00 = 0;
	}

	return var_00;
}

//Function Number: 124
func_7659()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetGambler");
	level endon("game_ended");
	self waittill("luinotifyserver",var_00,var_01);
	if(var_00 == "gambler_anim_complete")
	{
		self setclientomnvar("ui_gambler_show",-1);
	}
}

//Function Number: 125
getrandom_spammodel(param_00)
{
	var_01 = [];
	var_01 = thread sortbyweight(param_00);
	var_01 = thread setbucketval(var_01);
	var_02 = randomint(level.var_151A["sum"]);
	var_03 = undefined;
	foreach(var_05 in var_01)
	{
		if(!var_05.weight || var_05.id == "specialty_gambler")
		{
			continue;
		}

		if(var_05.weight > var_02)
		{
			var_03 = var_05;
			break;
		}
	}

	return var_03;
}

//Function Number: 126
sortbyweight(param_00)
{
	var_01 = [];
	var_02 = [];
	for(var_03 = 1;var_03 < param_00.size;var_03++)
	{
		var_04 = param_00[var_03].weight;
		var_01 = param_00[var_03];
		for(var_05 = var_03 - 1;var_05 >= 0 && is_weight_a_less_than_b(param_00[var_05].weight,var_04);var_05--)
		{
			var_02 = param_00[var_05];
			param_00[var_05] = var_01;
			param_00[var_05 + 1] = var_02;
		}
	}

	return param_00;
}

//Function Number: 127
is_weight_a_less_than_b(param_00,param_01)
{
	return param_00 < param_01;
}

//Function Number: 128
setbucketval(param_00)
{
	level.var_151A["sum"] = 0;
	foreach(var_02 in param_00)
	{
		if(!var_02.weight)
		{
			continue;
		}

		level.var_151A["sum"] = level.var_151A["sum"] + var_02.weight;
		var_02.weight = level.var_151A["sum"];
	}

	return param_00;
}

//Function Number: 129
func_12CC5()
{
	self notify("unsetGambler");
}

//Function Number: 130
setcomexp()
{
}

//Function Number: 131
unsetcomexp()
{
}

//Function Number: 132
settagger()
{
	thread settaggerinternal();
}

//Function Number: 133
settaggerinternal()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetTagger");
	level endon("game_ended");
	for(;;)
	{
		self waittill("eyesOn");
		var_00 = self _meth_8156();
		foreach(var_02 in var_00)
		{
			if(level.teambased && var_02.team == self.team)
			{
				continue;
			}

			if(isalive(var_02) && var_02.sessionstate == "playing")
			{
				if(!isdefined(var_02.perkoutlined))
				{
					var_02.perkoutlined = 0;
				}

				if(!var_02.perkoutlined)
				{
					var_02.perkoutlined = 1;
				}

				var_02 thread outlinewatcher(self);
			}
		}
	}
}

//Function Number: 134
outlinewatcher(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("eyesOff");
	level endon("game_ended");
	for(;;)
	{
		var_01 = 1;
		var_02 = param_00 _meth_8156();
		foreach(var_04 in var_02)
		{
			if(var_04 == self)
			{
				var_01 = 0;
				break;
			}
		}

		if(var_01)
		{
			self.perkoutlined = 0;
			self notify("eyesOff");
		}

		wait(0.5);
	}
}

//Function Number: 135
unsettagger()
{
	self notify("unsetTagger");
}

//Function Number: 136
setpitcher()
{
	thread setpitcherinternal();
}

//Function Number: 137
setpitcherinternal()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetPitcher");
	level endon("game_ended");
	scripts\mp\_utility::giveperk("specialty_throwback");
	self setgrenadecookscale(1.5);
	for(;;)
	{
		self setgrenadethrowscale(1.25);
		self waittill("grenade_pullback",var_00);
		if(var_00 == "airdrop_marker_mp" || var_00 == "killstreak_uplink_mp" || var_00 == "deployable_vest_marker_mp" || var_00 == "deployable_weapon_crate_marker_mp" || var_00 == "airdrop_juggernaut_mp")
		{
			self setgrenadethrowscale(1);
		}

		self waittill("grenade_fire",var_01,var_02);
	}
}

//Function Number: 138
func_12D0C()
{
	self setgrenadecookscale(1);
	self setgrenadethrowscale(1);
	scripts\mp\_utility::removeperk("specialty_throwback");
	self notify("unsetPitcher");
}

//Function Number: 139
setboom()
{
	self.trait = "specialty_boom";
}

//Function Number: 140
setboominternal(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetBoom");
	level endon("game_ended");
	param_00 endon("death");
	param_00 endon("disconnect");
	scripts\engine\utility::waitframe();
	function_0222(self.origin,param_00,800,1500);
	param_00 boomtrackplayers(self.origin,self);
}

//Function Number: 141
boomtrackplayers(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(param_01 == var_03)
		{
			continue;
		}

		if(scripts\mp\_utility::isenemy(var_03) && isalive(var_03) && !var_03 scripts\mp\_utility::_hasperk("specialty_gpsjammer") && distancesquared(param_00,var_03.origin) <= 490000)
		{
			scripts\mp\_missions::func_D991("ch_trait_ping");
		}
	}
}

//Function Number: 142
boomtrackplayerdeath(param_00,param_01)
{
	self endon("disconnect");
	param_00 endon("removearchetype");
	var_02 = scripts\engine\utility::waittill_any_timeout_1(7,"death");
	if(var_02 == "timeout" && isdefined(self.markedbyboomperk[param_01]))
	{
		self.markedbyboomperk[param_01] = undefined;
		return;
	}

	self waittill("spawned_player");
	self.markedbyboomperk = undefined;
}

//Function Number: 143
unsetboom()
{
	self.trait = undefined;
	self notify("unsetBoom");
}

//Function Number: 144
customjuiced(param_00)
{
	self endon("death");
	self endon("faux_spawn");
	self endon("disconnect");
	self endon("unset_custom_juiced");
	level endon("game_ended");
	self.isjuiced = 1;
	self.movespeedscaler = 1.1;
	scripts\mp\_weapons::updatemovespeedscale();
	scripts\mp\_utility::giveperk("specialty_fastreload");
	scripts\mp\_utility::giveperk("specialty_quickdraw");
	scripts\mp\_utility::giveperk("specialty_stalker");
	scripts\mp\_utility::giveperk("specialty_fastoffhand");
	scripts\mp\_utility::giveperk("specialty_fastsprintrecovery");
	scripts\mp\_utility::giveperk("specialty_quickswap");
	thread unsetcustomjuicedondeath();
	thread unsetcustomjuicedonride();
	thread unsetcustomjuicedonmatchend();
	var_01 = param_00 * 1000 + gettime();
	if(!isai(self))
	{
		self setclientomnvar("ui_juiced_end_milliseconds",var_01);
	}

	wait(param_00);
	unsetcustomjuiced();
}

//Function Number: 145
unsetcustomjuiced(param_00)
{
	if(!isdefined(param_00))
	{
		if(scripts\mp\_utility::isjuggernaut())
		{
			if(isdefined(self.var_A4AA))
			{
				self.movespeedscaler = self.var_A4AA;
			}
			else
			{
				self.movespeedscaler = 0.7;
			}
		}
		else
		{
			self.movespeedscaler = 1;
			if(scripts\mp\_utility::_hasperk("specialty_lightweight"))
			{
				self.movespeedscaler = scripts\mp\_utility::lightweightscalar();
			}
		}

		scripts\mp\_weapons::updatemovespeedscale();
	}

	scripts\mp\_utility::removeperk("specialty_fastreload");
	scripts\mp\_utility::removeperk("specialty_quickdraw");
	scripts\mp\_utility::removeperk("specialty_stalker");
	scripts\mp\_utility::removeperk("specialty_fastoffhand");
	scripts\mp\_utility::removeperk("specialty_fastsprintrecovery");
	scripts\mp\_utility::removeperk("specialty_quickswap");
	self.isjuiced = undefined;
	if(!isai(self))
	{
		self setclientomnvar("ui_juiced_end_milliseconds",0);
	}

	self notify("unset_custom_juiced");
}

//Function Number: 146
unsetcustomjuicedonride()
{
	self endon("disconnect");
	self endon("unset_custom_juiced");
	for(;;)
	{
		wait(0.05);
		if(scripts\mp\_utility::isusingremote())
		{
			thread unsetcustomjuiced();
			break;
		}
	}
}

//Function Number: 147
unsetcustomjuicedondeath()
{
	self endon("disconnect");
	self endon("unset_custom_juiced");
	scripts\engine\utility::waittill_any_3("death","faux_spawn");
	thread unsetcustomjuiced(1);
}

//Function Number: 148
unsetcustomjuicedonmatchend()
{
	self endon("disconnect");
	self endon("unset_custom_juiced");
	level scripts\engine\utility::waittill_any_3("round_end_finished","game_ended");
	thread unsetcustomjuiced();
}

//Function Number: 149
settriggerhappy()
{
}

//Function Number: 150
settriggerhappyinternal()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetTriggerHappy");
	level endon("game_ended");
	var_00 = self.lastdroppableweaponobj;
	var_01 = self getweaponammostock(var_00);
	var_02 = self getweaponammoclip(var_00);
	self givestartammo(var_00);
	var_03 = self getweaponammoclip(var_00);
	var_04 = var_03 - var_02;
	var_05 = var_01 - var_04;
	if(var_04 > var_01)
	{
		self setweaponammoclip(var_00,var_02 + var_01);
		var_05 = 0;
	}

	self setweaponammostock(var_00,var_05);
	self playlocalsound("ammo_crate_use");
	self setclientomnvar("ui_trigger_happy",1);
	wait(0.2);
	self setclientomnvar("ui_trigger_happy",0);
}

//Function Number: 151
unsettriggerhappy()
{
	self setclientomnvar("ui_trigger_happy",0);
	self notify("unsetTriggerHappy");
}

//Function Number: 152
setincog()
{
}

//Function Number: 153
unsetincog()
{
}

//Function Number: 154
setblindeye()
{
}

//Function Number: 155
unsetblindeye()
{
}

//Function Number: 156
setquickswap()
{
}

//Function Number: 157
unsetquickswap()
{
}

//Function Number: 158
setextraammo()
{
	self endon("death");
	self endon("disconnect");
	self endon("unset_extraammo");
	level endon("game_ended");
	if(self.gettingloadout)
	{
		self waittill("giveLoadout");
	}

	var_00 = scripts\mp\_utility::getvalidextraammoweapons();
	foreach(var_02 in var_00)
	{
		if(isdefined(var_02) && var_02 != "none")
		{
			self givemaxammo(var_02);
		}
	}
}

//Function Number: 159
unsetextraammo()
{
	self notify("unset_extraammo");
}

//Function Number: 160
setextraequipment()
{
	self endon("death");
	self endon("disconnect");
	self endon("unset_extraequipment");
	level endon("game_ended");
	if(self.gettingloadout)
	{
		self waittill("giveLoadout");
	}

	var_00 = self.loadoutperkoffhand;
	if(isdefined(var_00) && var_00 != "specialty_null")
	{
		if(var_00 != "specialty_tacticalinsertion" && var_00 != "smoke_grenade_mp" && var_00 != "player_trophy_system_mp" && var_00 != "shoulder_cannon_mp")
		{
			self setweaponammoclip(var_00,2);
		}
	}
}

//Function Number: 161
unsetextraequipment()
{
	self notify("unset_extraequipment");
}

//Function Number: 162
setextradeadly()
{
	self endon("death");
	self endon("disconnect");
	self endon("unset_extradeadly");
	level endon("game_ended");
}

//Function Number: 163
unsetextradeadly()
{
	self notify("unset_extradeadly");
}

//Function Number: 164
func_10D79(param_00)
{
	if(isdefined(param_00) && param_00 != self)
	{
		var_01 = self getweaponslistoffhands();
		var_02 = 1;
		var_03 = 0;
		foreach(var_05 in var_01)
		{
			if(var_05 != "throwingknife_mp")
			{
				var_03 = self getweaponammoclip(var_05);
				var_02 = var_02 + var_03;
			}
		}

		var_07 = 1;
		var_08 = spawn("script_origin",self.origin);
		var_08.triggerportableradarping = param_00;
		if(!isdefined(var_08.team))
		{
			var_08.team = param_00.team;
		}

		var_08.clusterticks = var_02;
		var_08 thread scripts\mp\_weapons::func_42D8(var_07);
		var_08 notify("explode",var_08.origin);
		var_08 delete();
	}
}

//Function Number: 165
setbattleslide()
{
	scripts/mp/archetypes/archcommon::_allowbattleslide(1);
	scripts/mp/equipment/battle_slide::func_28F2();
}

//Function Number: 166
unsetbattleslide()
{
	scripts/mp/archetypes/archcommon::_allowbattleslide(0);
	scripts/mp/equipment/battle_slide::func_28F6();
}

//Function Number: 167
setoverkill()
{
}

//Function Number: 168
unsetoverkill()
{
}

//Function Number: 169
setactivereload()
{
	scripts/mp/perks/perk_activereload::func_1664();
}

//Function Number: 170
unsetactivereload()
{
	scripts/mp/perks/perk_activereload::func_1667();
}

//Function Number: 171
setlifepack()
{
	if(!isdefined(level._effect["life_pack_pickup"]))
	{
		level._effect["life_pack_pickup"] = loadfx("vfx/iw7/_requests/mp/vfx_health_pickup");
	}

	thread watchlifepackkills();
}

//Function Number: 172
watchlifepackkills()
{
	self endon("death");
	self endon("disconnect");
	self notify("unset_lifepack");
	self endon("unset_lifepack");
	for(;;)
	{
		self waittill("got_a_kill",var_00,var_01,var_02);
		var_03 = self.origin;
		var_04 = 20;
		var_05 = 20;
		var_06 = spawn("script_model",self.origin + (0,0,10));
		var_06 setmodel("weapon_life_pack");
		var_06.triggerportableradarping = self;
		var_06.team = self.team;
		var_06 hidefromplayer(self);
		var_07 = spawn("trigger_radius",self.origin,0,var_04,var_05);
		var_07 thread watchlifepackuse(var_06);
		var_07 thread watchlifepackdeath(var_06);
		var_06 thread hoverlifepack();
		var_06 rotateyaw(1000,30,0.2,0.2);
		var_06 thread watchlifepacklifetime(10,var_07);
		var_06 thread watchlifepackowner();
		foreach(var_09 in level.players)
		{
			var_06 setlifepackvisualforplayer(var_09);
		}
	}
}

//Function Number: 173
activatelifepackboost(param_00,param_01,param_02)
{
	self.lifeboostactive = 1;
	if(isdefined(param_01) && param_01 > 0)
	{
		thread watchlifepackboostlifetime(param_01);
	}

	if(isdefined(param_02) && param_02)
	{
		thread watchlifepackuserdeath();
	}

	scripts\mp\_utility::giveperk("specialty_regenfaster");
	self setclientomnvar("ui_life_link",1);
	self notify("enabled_life_pack_boost");
	self.lifepackowner = param_00;
	scripts\mp\_gamescore::trackbuffassist(param_00,self,"medic_lifepack");
}

//Function Number: 174
watchlifepackboostlifetime(param_00)
{
	self endon("death");
	self endon("disconnect");
	wait(param_00);
	if(isdefined(self.lifeboostactive))
	{
		disablelifepackboost();
	}
}

//Function Number: 175
disablelifepackboost()
{
	if(isdefined(self) && isdefined(self.lifeboostactive))
	{
		self.lifeboostactive = undefined;
		self setclientomnvar("ui_life_link",0);
		self notify("disabled_life_pack_boost");
		scripts\mp\_utility::removeperk("specialty_regenfaster");
		scripts\mp\_gamescore::untrackbuffassist(self.lifepackowner,self,"medic_lifepack");
		self.lifepackowner = undefined;
	}
}

//Function Number: 176
setlifepackvisualforplayer(param_00)
{
	if(level.teambased && param_00.team == self.team && param_00 != self.triggerportableradarping)
	{
		setlifepackoutlinestate(param_00);
		self showtoplayer(param_00);
		thread watchlifepackoutlinestate(param_00);
		return;
	}

	self hidefromplayer(param_00);
}

//Function Number: 177
setlifepackoutlinestate(param_00)
{
	if(isdefined(param_00.lifeboostactive))
	{
		if(isdefined(param_00.lifepackoutlines) && param_00.lifepackoutlines.size > 0)
		{
			foreach(var_02 in param_00.lifepackoutlines)
			{
				if(self == var_02.pack)
				{
					scripts\mp\_utility::outlinedisable(var_02.id,var_02.pack);
					param_00.lifepackoutlines = scripts\engine\utility::array_remove(param_00.lifepackoutlines,var_02);
					var_02 = undefined;
				}
			}

			return;
		}

		return;
	}

	if(!isdefined(var_03.lifepackoutlines))
	{
		var_03.lifepackoutlines = [];
	}

	var_04 = spawnstruct();
	var_04.id = scripts\mp\_utility::outlineenableforplayer(self,"cyan",var_03,1,0,"equipment");
	var_04.pack = self;
	var_03.lifepackoutlines = scripts\engine\utility::array_add_safe(var_03.lifepackoutlines,var_04);
}

//Function Number: 178
watchlifepackoutlinestate(param_00)
{
	self endon("death");
	for(;;)
	{
		param_00 scripts\engine\utility::waittill_any_3("enabled_life_pack_boost","disabled_life_pack_boost");
		setlifepackoutlinestate(param_00);
	}
}

//Function Number: 179
hoverlifepack()
{
	self endon("death");
	self endon("phase_resource_pickup");
	var_00 = self.origin;
	for(;;)
	{
		self moveto(var_00 + (0,0,15),1,0.2,0.2);
		wait(1);
		self moveto(var_00,1,0.2,0.2);
		wait(1);
	}
}

//Function Number: 180
watchlifepackuse(param_00)
{
	self endon("death");
	for(;;)
	{
		self waittill("trigger",var_01);
		if(!isplayer(var_01))
		{
			continue;
		}

		if(var_01.team != param_00.team)
		{
			continue;
		}

		if(isdefined(var_01.lifeboostactive))
		{
			continue;
		}

		if(var_01 == param_00.triggerportableradarping)
		{
			continue;
		}

		var_01 activatelifepackboost(param_00.triggerportableradarping,5,1);
		var_01 playlocalsound("scavenger_pack_pickup");
		var_02 = spawnfx(scripts\engine\utility::getfx("life_pack_pickup"),self.origin);
		triggerfx(var_02);
		var_02 thread scripts\mp\_utility::delayentdelete(2);
		foreach(var_04 in level.players)
		{
			if(var_04.team == var_01.team)
			{
				continue;
			}

			var_02 hidefromplayer(var_04);
		}

		param_00 delete();
	}
}

//Function Number: 181
watchlifepackdeath(param_00)
{
	self endon("death");
	param_00 waittill("death");
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 182
watchlifepacklifetime(param_00,param_01)
{
	self endon("death");
	wait(param_00);
	param_01 delete();
	self delete();
}

//Function Number: 183
watchlifepackowner()
{
	self endon("death");
	self.triggerportableradarping waittill("disconnect");
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 184
watchlifepackuserdeath()
{
	self endon("disconnect");
	self waittill("death");
	disablelifepackboost();
}

//Function Number: 185
unsetlifepack()
{
	disablelifepackboost();
	self notify("unset_lifepack");
}

//Function Number: 186
settoughenup()
{
	if(!isdefined(level._effect["toughen_up_screen"]))
	{
		level._effect["toughen_up_screen"] = loadfx("vfx/iw7/_requests/mp/vfx_toughen_up_scrn");
	}

	thread watchtoughenup();
}

//Function Number: 187
watchtoughenup()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetToughenUp");
	level endon("game_ended");
	var_00 = 0;
	var_01 = 15;
	var_02 = 7.5;
	var_03 = 4;
	var_04 = 5;
	var_05 = 2;
	var_06 = [];
	var_06 = scripts\engine\utility::array_add_safe(var_06,(35,0,10));
	var_06 = scripts\engine\utility::array_add_safe(var_06,(0,35,10));
	var_06 = scripts\engine\utility::array_add_safe(var_06,(-35,0,10));
	var_06 = scripts\engine\utility::array_add_safe(var_06,(0,-35,10));
	self waittill("spawned_player");
	for(;;)
	{
		self waittill("got_a_kill",var_07,var_08,var_09);
		if(!isdefined(self.toughenedup))
		{
			self.toughenedup = 1;
			var_0A = function_01E1(scripts\engine\utility::getfx("toughen_up_screen"),self geteye(),self);
			triggerfx(var_0A);
			thread attachtoughenuparmor("j_forehead",level.bulletstormshield["section"].friendlymodel);
			thread attachtoughenuparmor("tag_reflector_arm_le",level.bulletstormshield["section"].friendlymodel);
			thread attachtoughenuparmor("tag_reflector_arm_ri",level.bulletstormshield["section"].friendlymodel);
			thread attachtoughenuparmor("j_spineupper",level.bulletstormshield["section"].friendlymodel);
			thread attachtoughenuparmor("tag_shield_back",level.bulletstormshield["section"].friendlymodel);
			thread attachtoughenuparmor("j_hip_le",level.bulletstormshield["section"].friendlymodel);
			thread attachtoughenuparmor("j_hip_ri",level.bulletstormshield["section"].friendlymodel);
			if(var_05 == 1)
			{
				scripts\mp\_utility::func_F741(var_01);
				thread watchtoughenuplifetime(var_04);
			}
			else
			{
				scripts\mp\_lightarmor::setlightarmorvalue(self,100);
				thread watchtoughenuplightarmorend();
			}

			var_0A thread watchtoughenupplayerend(self);
			continue;
		}

		if(var_05 == 1)
		{
			self notify("toughen_up_reset");
			thread watchtoughenuplifetime(var_04);
		}
	}
}

//Function Number: 188
attachtoughenuparmor(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = self gettagorigin(param_00);
	var_06 = spawn("script_model",var_05);
	var_06 setmodel(param_01);
	var_07 = (0,0,0);
	var_08 = (0,0,0);
	if(isdefined(param_02))
	{
		var_07 = param_02;
	}

	if(isdefined(param_03))
	{
		var_08 = param_03;
	}

	var_06.angles = self.angles;
	var_06 linkto(self,param_00,var_07,var_08);
	var_06 thread watchtoughenupplayerend(self);
	var_06 thread watchtoughenupgameend();
	return var_06;
}

//Function Number: 189
settoughenupmodel(param_00,param_01,param_02,param_03)
{
	var_04 = spawn("script_model",self.origin + (0,0,50));
	var_04.team = self.triggerportableradarping.team;
	if(param_03 == "friendly")
	{
		var_04 setmodel(level.bulletstormshield["section"].friendlymodel);
	}
	else
	{
		var_04 setmodel(level.bulletstormshield["section"].enemymodel);
	}

	var_04 linkto(self,"tag_origin",param_01,(0,90 * param_02 + 1,0));
	var_04 hide();
	var_04 thread watchtoughenupplayerend(self.triggerportableradarping);
	var_04 thread watchtoughenupgameend();
	var_04 thread settoughenupvisiblestate(param_03,self.triggerportableradarping);
}

//Function Number: 190
watchtoughenuplightarmorend()
{
	self endon("disconnect");
	self waittill("remove_light_armor");
}

//Function Number: 191
watchtoughenupplayerend(param_00)
{
	self endon("death");
	param_00 scripts\engine\utility::waittill_any_3("death","disconnect","toughen_up_end");
	param_00.toughenedup = undefined;
	if(param_00 scripts\mp\_lightarmor::haslightarmor(param_00))
	{
		param_00 unsetlightarmor();
	}

	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 192
watchtoughenupgameend()
{
	self endon("death");
	level waittill("game_ended");
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 193
watchtoughenuplifetime(param_00)
{
	self endon("death");
	self endon("toughen_up_reset");
	while(param_00 > 0)
	{
		param_00 = param_00 - 1;
		wait(1);
	}

	self notify("toughen_up_end");
}

//Function Number: 194
settoughenupvisiblestate(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(!isdefined(var_03))
		{
			continue;
		}

		if(var_03 == param_01)
		{
			continue;
		}

		if(!scripts/mp/equipment/phase_shift::isentityphaseshifted(var_03))
		{
			if(canshowtoughenupshield(var_03,param_00))
			{
				self showtoplayer(var_03);
			}
		}

		thread watchtoughenupplayerbegin(var_03,param_00);
		thread watchtoughenupplayer(var_03,param_00);
	}
}

//Function Number: 195
watchtoughenupplayerbegin(param_00,param_01)
{
	param_00 endon("disconnect");
	level endon("game_ended");
	self endon("death");
	for(;;)
	{
		param_00 waittill("spawned_player");
		self hidefromplayer(param_00);
		if(canshowtoughenupshield(param_00,param_01))
		{
			self showtoplayer(param_00);
		}

		thread watchtoughenupplayer(param_00,param_01);
	}
}

//Function Number: 196
canshowtoughenupshield(param_00,param_01)
{
	var_02 = 0;
	if((param_01 == "friendly" && param_00.team == self.team) || param_01 == "enemy" && param_00.team != self.team)
	{
		var_02 = 1;
	}

	return var_02;
}

//Function Number: 197
watchtoughenupplayer(param_00,param_01)
{
}

//Function Number: 198
unsettoughenup()
{
	scripts\mp\_utility::clearhealthshield();
	unsetlightarmor();
	self notify("unsetToughenUp");
}

//Function Number: 199
setscoutping()
{
	thread scripts/mp/archetypes/archscout::func_13B32();
	thread updatescoutping();
}

//Function Number: 200
updatescoutping()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetScoutPing");
	var_00 = 50;
	var_01 = 1200;
	for(;;)
	{
		var_02 = var_00;
		var_03 = var_01;
		if(isdefined(self.scoutpingradius))
		{
			var_02 = self.scoutpingradius;
		}

		if(isdefined(self.scoutsweeptime))
		{
			var_03 = self.scoutsweeptime;
		}

		var_02 = int(var_02);
		var_03 = int(var_03);
		if(var_02 != var_00)
		{
			function_02A1(self.origin,self.team,var_02,var_03);
		}

		wait(var_01 / 1200);
	}
}

//Function Number: 201
updatescoutpingvalues(param_00)
{
	var_01 = 0;
	var_02 = 150;
	var_03 = 3000;
	if(isdefined(self.scoutpingmod))
	{
		var_01 = self.scoutpingmod;
	}

	if(isdefined(self.scoutpingpreviousstage))
	{
		if(param_00 > self.scoutpingpreviousstage)
		{
			var_04 = param_00 - self.scoutpingpreviousstage;
			var_01 = var_01 + var_04 / 10;
		}
		else if(param_00 < self.scoutpingpreviousstage)
		{
			var_04 = self.scoutpingpreviousstage - param_00;
			var_01 = var_01 - var_04 / 10;
		}
	}

	if(isdefined(self.scoutpingmod))
	{
		if(var_01 > self.scoutpingmod || var_01 < self.scoutpingmod)
		{
			var_02 = var_02 + var_02 * var_01 * 1.5;
			var_03 = var_03 - var_03 * var_01 / 1.5;
			self.scoutpingradius = var_02;
			self.scoutsweeptime = var_03;
		}
	}

	if(param_00 == 0)
	{
		self.scoutpingradius = undefined;
		self.scoutsweeptime = undefined;
	}

	self.scoutpingmod = var_01;
	self.scoutpingpreviousstage = param_00;
}

//Function Number: 202
unsetscoutping()
{
	self.scoutpingradius = undefined;
	self.scoutsweeptime = undefined;
	self.scoutpingmod = undefined;
	self.scoutpingpreviousstage = undefined;
	self notify("unsetScoutPing");
	thread scripts/mp/archetypes/archscout::func_3886();
}

//Function Number: 203
setphasespeed()
{
	thread func_139D8();
}

//Function Number: 204
unsetcritchance()
{
}

//Function Number: 205
func_3E41()
{
	self endon("disconnect");
	self waittill("spawned_player");
	thread func_139D8();
}

//Function Number: 206
func_139D8()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	for(;;)
	{
		self waittill("got_a_kill",var_00,var_01,var_02);
		var_03 = var_00 _meth_8113();
		var_04 = "primary";
		var_05 = "none";
		var_06 = getarraykeys(var_00.powers);
		foreach(var_08 in var_06)
		{
			if(var_00.powers[var_08].slot == var_04)
			{
				var_05 = var_08;
			}
		}

		if(var_05 == "none")
		{
			continue;
		}

		var_0A = 20;
		var_0B = 20;
		var_0C = spawn("script_model",var_03.origin + (0,0,10));
		var_0C.triggerportableradarping = self;
		var_0C.team = self.team;
		var_0D = spawn("trigger_radius",var_03.origin,0,var_0A,var_0B);
		var_0D thread func_139D9(var_0C);
		var_0C thread func_139DA(30,var_0D);
		var_0C thread func_139DB();
		var_0C func_B29E(var_05);
	}
}

//Function Number: 207
updatetriggerposition()
{
	self endon("death");
	for(;;)
	{
		if(isdefined(self))
		{
			self.origin = self.origin;
			if(isdefined(self.bombsquadmodel))
			{
				self.bombsquadmodel.origin = self.origin;
			}
		}
		else
		{
			return;
		}

		wait(0.05);
	}
}

//Function Number: 208
func_4650(param_00,param_01,param_02)
{
	self endon("spawned_player");
	self endon("disconnect");
	self endon("death");
	self.trigger setcursorhint("HINT_NOICON");
	switch(param_02)
	{
		case "power_c4":
			self.trigger sethintstring(&"MP_PICKUP_C4");
			break;

		case "power_biospike":
			self.trigger sethintstring(&"MP_PICKUP_BIOSPIKE");
			break;

		case "power_bouncingBetty":
			self.trigger sethintstring(&"MP_PICKUP_BOUNCING_BETTY");
			break;

		case "power_semtex":
			self.trigger sethintstring(&"MP_PICKUP_SEMTEX");
			break;

		case "power_smokeGrenade":
			self.trigger sethintstring(&"MP_PICKUP_SMOKE_GRENADE");
			break;

		case "power_domeshield":
			self.trigger sethintstring(&"MP_PICKUP_DOME_SHIELD");
			break;

		case "power_shardBall":
			self.trigger sethintstring(&"MP_PICKUP_SHARD_BALL");
			break;

		case "power_splashGrenade":
			self.trigger sethintstring(&"MP_PICKUP_SPLASH_GRENADE");
			break;

		case "power_clusterGrenade":
			self.trigger sethintstring(&"MP_PICKUP_CLUSTER_GRENADE");
			break;

		case "power_smokeWall":
			self.trigger sethintstring(&"MP_PICKUP_SMOKE_WALL");
			break;

		case "power_empGrenade":
			self.trigger sethintstring(&"MP_PICKUP_EMP_GRENADE");
			break;

		case "power_blackholeGrenade":
			self.trigger sethintstring(&"MP_PICKUP_BLACKHOLE_GRENADE");
			break;

		case "power_blinkKnife":
			self.trigger sethintstring(&"MP_PICKUP_TELEPORT_KNIFE");
			break;

		case "power_throwingReap":
			self.trigger sethintstring(&"MP_PICKUP_THROWING_REAP");
			break;

		case "power_thermobaric":
			self.trigger sethintstring(&"MP_PICKUP_THERMOBARIC");
			break;

		case "power_playerTrophySystem":
			self.trigger sethintstring(&"MP_PICKUP_PLAYER_TROPHY");
			break;

		case "power_discMarker":
			self.trigger sethintstring(&"MP_PICKUP_DISC_MARKER");
			break;

		case "power_caseBomb":
			self.trigger sethintstring(&"MP_PICKUP_CASE_BOMB");
			break;

		case "power_transponder":
			self.trigger sethintstring(&"MP_PICKUP_TRANSPONDER");
			break;

		case "power_gasGrenade":
			self.trigger sethintstring(&"MP_PICKUP_GAS_GRENADE");
			break;

		case "power_blackoutGrenade":
			self.trigger sethintstring(&"MP_PICKUP_BLACKOUT_GRENADE");
			break;

		case "power_copycatGrenade":
			self.trigger sethintstring(&"MP_PICKUP_COPYCAT_GRENADE");
			break;

		case "power_arcGrenade":
			self.trigger sethintstring(&"MP_PICKUP_ARC_MINE");
			break;
	}

	self.trigger makeusable();
	foreach(var_04 in level.players)
	{
		if(var_04 == param_00)
		{
			self.trigger enableplayeruse(var_04);
			continue;
		}

		self.trigger disableplayeruse(var_04);
	}

	self.trigger thread scripts\mp\_utility::notusableforjoiningplayers(param_00);
	if(isdefined(param_01) && param_01)
	{
		thread updatetriggerposition();
	}

	for(;;)
	{
		self.trigger waittill("trigger",param_00);
		param_00 playlocalsound("scavenger_pack_pickup");
		var_06 = param_02;
		var_07 = "primary";
		param_00 notify("start_copycat");
		param_00 notify("corpse_steal");
		var_08 = "none";
		var_09 = getarraykeys(param_00.powers);
		foreach(var_0B in var_09)
		{
			if(param_00.powers[var_0B].slot == var_07)
			{
				var_08 = var_0B;
			}
		}

		param_00 scripts\mp\_powers::removepower(var_08);
		param_00 scripts\mp\_powers::givepower(var_06,var_07,1);
		param_00 thread scripts\mp\_weapons::func_139D7(var_06,var_07);
		self.trigger delete();
		self delete();
		self notify("death");
	}
}

//Function Number: 209
func_B29E(param_00)
{
	if(scripts\mp\_utility::isreallyalive(self.triggerportableradarping))
	{
		self setotherent(self.triggerportableradarping);
		self.trigger = spawn("script_origin",self.origin,0,1,1);
		self.trigger.triggerportableradarping = self;
		thread func_4650(self.triggerportableradarping,1,param_00);
	}
}

//Function Number: 210
func_139D9(param_00)
{
	self endon("death");
	param_00 waittill("death");
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 211
func_139DA(param_00,param_01)
{
	self endon("death");
	wait(param_00);
	self.trigger delete();
	param_01 delete();
	self delete();
}

//Function Number: 212
func_139DB()
{
	self endon("death");
	self.triggerportableradarping waittill("disconnect");
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 213
setphasespeed()
{
	thread watchphasespeedshift();
	thread watchphasespeedendshift();
}

//Function Number: 214
watchphasespeedshift()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		self waittill("phase_shift_start");
		self.phasespeedmod = 0.2;
		scripts\mp\_weapons::updatemovespeedscale();
	}
}

//Function Number: 215
watchphasespeedendshift()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		self waittill("phase_shift_completed");
		self.phasespeedmod = undefined;
		scripts\mp\_weapons::updatemovespeedscale();
	}
}

//Function Number: 216
unsetphasespeed()
{
	self.phasespeedmod = undefined;
}

//Function Number: 217
setdodge()
{
	self.trait = "specialty_dodge";
	self allowdodge(1);
	if(scripts\mp\_utility::isanymlgmatch())
	{
		self _meth_8454(6);
	}
	else
	{
		self _meth_8454(3);
	}

	scripts/mp/perks/perk_dodgedefense::func_139F9();
}

//Function Number: 218
unsetdodge()
{
	self.trait = undefined;
	self allowdodge(0);
}

//Function Number: 219
setextradodge()
{
	self energy_setmax(1,100);
	self goal_radius(1,100);
}

//Function Number: 220
unsetextradodge()
{
	self energy_setmax(1,50);
	self goal_radius(1,50);
}

//Function Number: 221
setsixthsense()
{
	self.trait = "specialty_sixth_sense";
	updatesixthsensevfx(0,0);
	thread func_10225();
}

//Function Number: 222
unsetsixthsense()
{
	self.trait = undefined;
	self.var_10224 = undefined;
	self notify("removeSixthSense");
	updatesixthsensevfx(0,0);
}

//Function Number: 223
func_F6E9()
{
}

//Function Number: 224
func_12CAD()
{
}

//Function Number: 225
func_10225()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeSixthSense");
	self endon("round_switch");
	thread watchdeathsixthsense();
	for(;;)
	{
		var_00 = 0;
		var_01 = level.players;
		var_02 = 0;
		var_03 = scripts\mp\_utility::_hasperk("specialty_enhanced_sixth_sense");
		if(!scripts\mp\killstreaks\_emp_common::isemped())
		{
			foreach(var_05 in var_01)
			{
				if(!isdefined(var_05) || !scripts\mp\_utility::isreallyalive(var_05))
				{
					continue;
				}

				if(var_05.team == self.team)
				{
					continue;
				}

				if(var_05 scripts\mp\_utility::_hasperk("specialty_coldblooded"))
				{
					continue;
				}

				if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_05))
				{
					continue;
				}

				var_06 = self.origin - var_05.origin;
				var_07 = anglestoforward(var_05 getplayerangles());
				var_08 = vectordot(var_06,var_07);
				if(var_08 <= 0)
				{
					continue;
				}

				var_09 = vectornormalize(var_06);
				var_0A = vectornormalize(var_07);
				var_08 = vectordot(var_09,var_0A);
				if(var_08 < 0.9659258)
				{
					continue;
				}

				var_00++;
				var_0B = var_05 geteye();
				var_0C = self geteye();
				if(bullettracepassed(var_0B,var_0C,0,self))
				{
					thread watchperceptionchallengedeath();
					thread watchperceptionchallengeprogress();
					var_02 = var_02 | getsixthsensedirection(var_05);
					thread markassixthsensesource(var_05);
					continue;
				}

				if(var_00 >= 3)
				{
					scripts\engine\utility::waitframe();
					var_00 = 0;
				}
			}
		}

		if(var_02 > 4)
		{
			var_02 = 255;
		}
		else
		{
			var_02 = 0;
		}

		updatesixthsensevfx(var_02,var_03);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 226
watchperceptionchallengedeath()
{
	self endon("disconnect");
	if(scripts\mp\_utility::istrue(self.startperceptionchallengewatch))
	{
		return;
	}

	scripts\engine\utility::waittill_any_3("removesixthsense","death","perceptionChallengeCheckDone");
	self.startperceptionchallengewatch = 0;
}

//Function Number: 227
watchperceptionchallengeprogress()
{
	self endon("disconnect");
	self endon("removesixthsense");
	self endon("death");
	if(scripts\mp\_utility::istrue(self.startperceptionchallengewatch))
	{
		return;
	}

	self.startperceptionchallengewatch = 1;
	wait(10);
	scripts\mp\_missions::func_D991("ch_trait_perception");
	self notify("perceptionChallengeCheckDone");
}

//Function Number: 228
watchdeathsixthsense()
{
	self endon("disconnect");
	self endon("removesixthsense");
	self waittill("death");
	self setclientomnvar("ui_edge_glow",0);
}

//Function Number: 229
updatesixthsensevfx(param_00,param_01)
{
	var_02 = 0;
	if(isdefined(self.var_10224))
	{
		var_02 = self.var_10224;
	}

	if(isdefined(param_01) && param_01)
	{
		if(var_02 != param_00)
		{
			self.var_10224 = param_00;
		}
	}

	self setclientomnvar("ui_edge_glow",param_00);
}

//Function Number: 230
getsixthsensedirection(param_00)
{
	var_01 = anglestoforward(self getplayerangles());
	var_02 = (var_01[0],var_01[1],var_01[2]);
	var_02 = vectornormalize(var_02);
	var_03 = param_00.origin - self.origin;
	var_04 = (var_03[0],var_03[1],var_03[2]);
	var_04 = vectornormalize(var_04);
	var_05 = vectordot(var_02,var_04);
	if(var_05 >= 0.9238795)
	{
		return 2;
	}

	if(var_05 >= 0.3826834)
	{
		return scripts\engine\utility::ter_op(scripts\mp\_utility::isleft2d(self.origin,var_02,param_00.origin),4,1);
	}

	if(var_05 >= -0.3826834)
	{
		return scripts\engine\utility::ter_op(scripts\mp\_utility::isleft2d(self.origin,var_02,param_00.origin),128,64);
	}

	if(var_05 >= -0.9238795)
	{
		return scripts\engine\utility::ter_op(scripts\mp\_utility::isleft2d(self.origin,var_02,param_00.origin),32,8);
	}

	return 16;
}

//Function Number: 231
markassixthsensesource(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	var_01 = param_00 getentitynumber();
	if(!isdefined(self.sixthsensesource))
	{
		self.sixthsensesource = [];
	}
	else if(isdefined(self.sixthsensesource[var_01]))
	{
		self notify("markAsSixthSenseSource");
		self endon("markAsSixthSenseSource");
	}

	self.sixthsensesource[var_01] = 1;
	param_00 scripts\engine\utility::waittill_any_timeout_1(10,"death");
	self.sixthsensesource[var_01] = 0;
}

//Function Number: 232
setcamoelite()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	for(;;)
	{
		var_00 = 0;
		var_01 = level.players;
		var_02 = 0;
		if(!scripts\mp\killstreaks\_emp_common::isemped())
		{
			foreach(var_04 in var_01)
			{
				if(!isdefined(var_04) || !scripts\mp\_utility::isreallyalive(var_04))
				{
					continue;
				}

				if(var_04.team == self.team)
				{
					continue;
				}

				if(var_04 scripts\mp\_utility::_hasperk("specialty_empimmune"))
				{
					continue;
				}

				if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_04))
				{
					continue;
				}

				var_05 = self.origin - var_04.origin;
				var_06 = anglestoforward(var_04 getplayerangles());
				var_07 = vectordot(var_05,var_06);
				if(var_07 <= 0)
				{
					continue;
				}

				var_08 = vectornormalize(var_05);
				var_09 = vectornormalize(var_06);
				var_07 = vectordot(var_08,var_09);
				if(var_07 < 0.9659258)
				{
					continue;
				}

				var_00++;
				var_0A = var_04 geteye();
				var_0B = self geteye();
				if(bullettracepassed(var_0A,var_0B,0,self))
				{
					var_02 = 1;
					break;
				}

				if(var_00 >= 3)
				{
					scripts\engine\utility::waitframe();
					var_00 = 0;
				}
			}

			scripts\engine\utility::waitframe();
		}

		updatecamoeliteoverlay(var_02);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 233
updatecamoeliteoverlay(param_00)
{
}

//Function Number: 234
unsetcamoelite()
{
}

//Function Number: 235
func_F704()
{
	scripts\mp\_utility::giveperk("specialty_pistoldeath");
}

//Function Number: 236
func_12CBD()
{
	scripts\mp\_utility::removeperk("specialty_pistoldeath");
}

//Function Number: 237
setcarepackage()
{
	thread scripts\mp\killstreaks\_killstreaks::givekillstreak("airdrop_assault",0,0,self);
}

//Function Number: 238
unsetcarepackage()
{
}

//Function Number: 239
setuav()
{
	thread scripts\mp\killstreaks\_killstreaks::givekillstreak("uav",0,0,self);
}

//Function Number: 240
unsetuav()
{
}

//Function Number: 241
func_F864()
{
	scripts\mp\_utility::giveperk("specialty_bulletdamage");
	thread func_13B63();
}

//Function Number: 242
func_13B63()
{
	self notify("watchStoppingPowerKill");
	self endon("watchStoppingPowerKill");
	self endon("disconnect");
	level endon("game_ended");
	self waittill("killed_enemy");
	func_12D3A();
}

//Function Number: 243
func_12D3A()
{
	scripts\mp\_utility::removeperk("specialty_bulletdamage");
	self notify("watchStoppingPowerKill");
}

//Function Number: 244
func_F678()
{
	scripts\mp\_utility::giveperk("specialty_pistoldeath");
}

//Function Number: 245
func_12C8A()
{
	if(scripts\mp\_utility::_hasperk("specialty_pistoldeath"))
	{
		scripts\mp\_utility::removeperk("specialty_pistoldeath");
	}
}

//Function Number: 246
setjuiced(param_00)
{
	self endon("death");
	self endon("faux_spawn");
	self endon("disconnect");
	self endon("unset_juiced");
	level endon("game_ended");
	self.isjuiced = 1;
	self.movespeedscaler = 1.25;
	scripts\mp\_weapons::updatemovespeedscale();
	scripts\mp\_utility::giveperk("specialty_fastreload");
	scripts\mp\_utility::giveperk("specialty_quickdraw");
	scripts\mp\_utility::giveperk("specialty_stalker");
	scripts\mp\_utility::giveperk("specialty_fastoffhand");
	scripts\mp\_utility::giveperk("specialty_fastsprintrecovery");
	scripts\mp\_utility::giveperk("specialty_quickswap");
	thread unsetjuicedondeath();
	thread unsetjuicedonride();
	thread unsetjuicedonmatchend();
	if(!isdefined(param_00))
	{
		param_00 = 10;
	}

	var_01 = param_00 * 1000 + gettime();
	if(!isai(self))
	{
		self setclientomnvar("ui_juiced_end_milliseconds",var_01);
	}

	wait(param_00);
	unsetjuiced();
}

//Function Number: 247
unsetjuiced(param_00)
{
	if(!isdefined(param_00))
	{
		if(scripts\mp\_utility::isjuggernaut())
		{
			if(isdefined(self.var_A4AA))
			{
				self.movespeedscaler = self.var_A4AA;
			}
			else
			{
				self.movespeedscaler = 0.7;
			}
		}
		else
		{
			self.movespeedscaler = 1;
			if(scripts\mp\_utility::_hasperk("specialty_lightweight"))
			{
				self.movespeedscaler = scripts\mp\_utility::lightweightscalar();
			}
		}

		scripts\mp\_weapons::updatemovespeedscale();
	}

	scripts\mp\_utility::removeperk("specialty_fastreload");
	scripts\mp\_utility::removeperk("specialty_quickdraw");
	scripts\mp\_utility::removeperk("specialty_stalker");
	scripts\mp\_utility::removeperk("specialty_fastoffhand");
	scripts\mp\_utility::removeperk("specialty_fastsprintrecovery");
	scripts\mp\_utility::removeperk("specialty_quickswap");
	self.isjuiced = undefined;
	if(!isai(self))
	{
		self setclientomnvar("ui_juiced_end_milliseconds",0);
	}

	self notify("unset_juiced");
}

//Function Number: 248
unsetjuicedonride()
{
	self endon("disconnect");
	self endon("unset_juiced");
	for(;;)
	{
		wait(0.05);
		if(scripts\mp\_utility::isusingremote())
		{
			thread unsetjuiced();
			break;
		}
	}
}

//Function Number: 249
unsetjuicedondeath()
{
	self endon("disconnect");
	self endon("unset_juiced");
	scripts\engine\utility::waittill_any_3("death","faux_spawn");
	thread unsetjuiced(1);
}

//Function Number: 250
unsetjuicedonmatchend()
{
	self endon("disconnect");
	self endon("unset_juiced");
	level scripts\engine\utility::waittill_any_3("round_end_finished","game_ended");
	thread unsetjuiced();
}

//Function Number: 251
hasjuiced()
{
	return isdefined(self.isjuiced);
}

//Function Number: 252
setcombathigh()
{
	self endon("death");
	self endon("disconnect");
	self endon("unset_combathigh");
	level endon("end_game");
	self.damageblockedtotal = 0;
	if(level.splitscreen)
	{
		var_00 = 56;
		var_01 = 21;
	}
	else
	{
		var_00 = 112;
		var_01 = 32;
	}

	if(isdefined(self.juicedtimer))
	{
		self.juicedtimer destroy();
	}

	if(isdefined(self.juicedicon))
	{
		self.juicedicon destroy();
	}

	self.combathighoverlay = newclienthudelem(self);
	self.combathighoverlay.x = 0;
	self.combathighoverlay.y = 0;
	self.combathighoverlay.alignx = "left";
	self.combathighoverlay.aligny = "top";
	self.combathighoverlay.horzalign = "fullscreen";
	self.combathighoverlay.vertalign = "fullscreen";
	self.combathighoverlay setshader("combathigh_overlay",640,480);
	self.combathighoverlay.sort = -10;
	self.combathighoverlay.archived = 1;
	self.combathightimer = scripts\mp\_hud_util::createtimer("hudsmall",1);
	self.combathightimer scripts\mp\_hud_util::setpoint("CENTER","CENTER",0,var_00);
	self.combathightimer settimer(10);
	self.combathightimer.color = (0.8,0.8,0);
	self.combathightimer.archived = 0;
	self.combathightimer.foreground = 1;
	self.combathighicon = scripts\mp\_hud_util::createicon("specialty_painkiller",var_01,var_01);
	self.combathighicon.alpha = 0;
	self.combathighicon scripts\mp\_hud_util::setparent(self.combathightimer);
	self.combathighicon scripts\mp\_hud_util::setpoint("BOTTOM","TOP");
	self.combathighicon.archived = 1;
	self.combathighicon.sort = 1;
	self.combathighicon.foreground = 1;
	self.combathighoverlay.alpha = 0;
	self.combathighoverlay fadeovertime(1);
	self.combathighicon fadeovertime(1);
	self.combathighoverlay.alpha = 1;
	self.combathighicon.alpha = 0.85;
	thread unsetcombathighondeath();
	thread unsetcombathighonride();
	wait(8);
	self.combathighicon fadeovertime(2);
	self.combathighicon.alpha = 0;
	self.combathighoverlay fadeovertime(2);
	self.combathighoverlay.alpha = 0;
	self.combathightimer fadeovertime(2);
	self.combathightimer.alpha = 0;
	wait(2);
	self.damageblockedtotal = undefined;
	scripts\mp\_utility::removeperk("specialty_combathigh");
}

//Function Number: 253
unsetcombathighondeath()
{
	self endon("disconnect");
	self endon("unset_combathigh");
	self waittill("death");
	thread scripts\mp\_utility::removeperk("specialty_combathigh");
}

//Function Number: 254
unsetcombathighonride()
{
	self endon("disconnect");
	self endon("unset_combathigh");
	for(;;)
	{
		wait(0.05);
		if(scripts\mp\_utility::isusingremote())
		{
			thread scripts\mp\_utility::removeperk("specialty_combathigh");
			break;
		}
	}
}

//Function Number: 255
unsetcombathigh()
{
	self notify("unset_combathigh");
	self.combathighoverlay destroy();
	self.combathighicon destroy();
	self.combathightimer destroy();
}

//Function Number: 256
setlightarmor()
{
	scripts\mp\_lightarmor::setlightarmorvalue(self,150);
}

//Function Number: 257
unsetlightarmor()
{
	scripts\mp\_lightarmor::lightarmor_unset();
}

//Function Number: 258
setrevenge()
{
	self notify("stopRevenge");
	wait(0.05);
	if(!isdefined(self.lastkilledby))
	{
		return;
	}

	if(level.teambased && self.team == self.lastkilledby.team)
	{
		return;
	}

	var_00 = spawnstruct();
	var_00.showto = self;
	var_00.icon = "compassping_revenge";
	var_00.offset = (0,0,64);
	var_00.width = 10;
	var_00.height = 10;
	var_00.archived = 0;
	var_00.delay = 1.5;
	var_00.constantsize = 0;
	var_00.pintoscreenedge = 1;
	var_00.fadeoutpinnedicon = 0;
	var_00.is3d = 0;
	self.revengeparams = var_00;
	self.lastkilledby scripts\mp\_entityheadicons::setheadicon(var_00.showto,var_00.icon,var_00.offset,var_00.width,var_00.height,var_00.archived,var_00.delay,var_00.constantsize,var_00.pintoscreenedge,var_00.fadeoutpinnedicon,var_00.is3d);
	thread watchrevengedeath();
	thread watchrevengekill();
	thread watchrevengedisconnected();
	thread watchrevengevictimdisconnected();
	thread watchstoprevenge();
}

//Function Number: 259
watchrevengedeath()
{
	self endon("stopRevenge");
	self endon("disconnect");
	var_00 = self.lastkilledby;
	for(;;)
	{
		var_00 waittill("spawned_player");
		var_00 scripts\mp\_entityheadicons::setheadicon(self.revengeparams.showto,self.revengeparams.icon,self.revengeparams.offset,self.revengeparams.width,self.revengeparams.height,self.revengeparams.archived,self.revengeparams.delay,self.revengeparams.constantsize,self.revengeparams.pintoscreenedge,self.revengeparams.fadeoutpinnedicon,self.revengeparams.is3d);
	}
}

//Function Number: 260
watchrevengekill()
{
	self endon("stopRevenge");
	self waittill("killed_enemy");
	self notify("stopRevenge");
}

//Function Number: 261
watchrevengedisconnected()
{
	self endon("stopRevenge");
	self.lastkilledby waittill("disconnect");
	self notify("stopRevenge");
}

//Function Number: 262
watchstoprevenge()
{
	var_00 = self.lastkilledby;
	self waittill("stopRevenge");
	if(!isdefined(var_00))
	{
		return;
	}

	foreach(var_02 in var_00.entityheadicons)
	{
		if(!isdefined(var_02))
		{
			continue;
		}

		var_02 destroy();
	}
}

//Function Number: 263
watchrevengevictimdisconnected()
{
	var_00 = self.objidfriendly;
	var_01 = self.lastkilledby;
	var_01 endon("disconnect");
	level endon("game_ended");
	self endon("stopRevenge");
	self waittill("disconnect");
	if(!isdefined(var_01))
	{
		return;
	}

	foreach(var_03 in var_01.entityheadicons)
	{
		if(!isdefined(var_03))
		{
			continue;
		}

		var_03 destroy();
	}
}

//Function Number: 264
unsetrevenge()
{
	self notify("stopRevenge");
}

//Function Number: 265
setphaseslide()
{
	self.canphaseslide = 1;
	thread scripts/mp/archetypes/archassassin::func_CAAF();
}

//Function Number: 266
unsetphaseslide()
{
	self.canphaseslide = 0;
}

//Function Number: 267
setteleslide()
{
	self.canteleslide = 1;
	thread scripts/mp/archetypes/archassassin::func_1166B();
}

//Function Number: 268
unsetteleslide()
{
	self.canteleslide = 0;
}

//Function Number: 269
setphaseslashrephase()
{
	self.hasrephase = 1;
	thread scripts/mp/archetypes/archassassin::func_E88E();
}

//Function Number: 270
unsetphaseslashrephase()
{
	self.hasrephase = 0;
}

//Function Number: 271
func_F7E0()
{
	scripts/mp/equipment/ground_pound::func_8659("phase");
}

//Function Number: 272
func_12D05()
{
	scripts/mp/equipment/ground_pound::func_865A();
}

//Function Number: 273
func_F62F()
{
	self.var_8BC2 = 1;
}

//Function Number: 274
func_12C68()
{
	self.var_8BC2 = 0;
}

//Function Number: 275
func_F630()
{
	self.var_8BC3 = 1;
	self notify("force_regeneration");
}

//Function Number: 276
func_12C69()
{
	self.var_8BC3 = 1;
}

//Function Number: 277
func_F6F1()
{
	scripts/mp/archetypes/archscout::func_F6F2();
}

//Function Number: 278
func_12CB1()
{
}

//Function Number: 279
func_F64E()
{
	scripts/mp/archetypes/archheavy::func_261D();
}

//Function Number: 280
func_12C74()
{
}

//Function Number: 281
func_F64D()
{
	scripts/mp/archetypes/archassault::auraquickswap_run();
}

//Function Number: 282
func_12C73()
{
}

//Function Number: 283
func_F64F()
{
	scripts/mp/archetypes/archscout::func_2620();
}

//Function Number: 284
func_12C75()
{
}

//Function Number: 285
func_F790()
{
	self.var_11B2E = "specialty_mark_targets";
	scripts\mp\perks\_perk_mark_targets::marktarget_init();
}

//Function Number: 286
func_12CED()
{
	self.trait = undefined;
}

//Function Number: 287
func_F65A()
{
	scripts/mp/archetypes/archengineer::func_F6E6("battery");
}

//Function Number: 288
func_12C7A()
{
}

//Function Number: 289
func_F67A()
{
}

//Function Number: 290
func_12C8B()
{
}

//Function Number: 291
setblockhealthregen()
{
	self.healthregendisabled = 1;
	self notify("force_regen");
}

//Function Number: 292
unsetblockhealthregen()
{
	self.healthregendisabled = undefined;
	self notify("force_regen");
}

//Function Number: 293
setscorestreakpack()
{
	scripts/mp/archetypes/archengineer::func_F6E6("scorestreak");
}

//Function Number: 294
unsetscorestreakpack()
{
}

//Function Number: 295
setsuperpack()
{
	self.trait = "specialty_superpack";
	scripts/mp/archetypes/archengineer::func_F6E6("super");
}

//Function Number: 296
unsetsuperpack()
{
	self.trait = undefined;
}

//Function Number: 297
setspawncloak()
{
}

//Function Number: 298
unsetspawncloak()
{
}

//Function Number: 299
setdodgedefense()
{
	scripts\mp\_utility::adddamagemodifier("dodgeDefense",0.5,0,::dodgedefenseignorefunc);
}

//Function Number: 300
unsetdodgedefense()
{
	scripts\mp\_utility::removedamagemodifier("dodgeDefense",0);
}

//Function Number: 301
dodgedefenseignorefunc(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(!isdefined(param_02.dodging) && param_02.dodging && param_02 scripts\mp\_utility::_hasperk("specialty_dodge_defense"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 302
setdodgewave()
{
}

//Function Number: 303
unsetdodgewave()
{
}

//Function Number: 304
setgroundpound()
{
	self.trait = "specialty_ground_pound";
	scripts/mp/equipment/ground_pound::func_8659();
}

//Function Number: 305
unsetgroundpound()
{
	self.trait = undefined;
	scripts/mp/equipment/ground_pound::func_865A();
}

//Function Number: 306
setmeleekill()
{
	self giveweapon("iw7_fistsperk_mp");
	self assignweaponmeleeslot("iw7_fistsperk_mp");
	if(self hasweapon("iw7_fists_mp"))
	{
		var_00 = self getcurrentweapon();
		scripts\mp\_utility::_takeweapon("iw7_fists_mp");
		self giveweapon("iw7_fistslethal_mp");
		if(var_00 == "iw7_fists_mp")
		{
			scripts\mp\_utility::_switchtoweapon("iw7_fistslethal_mp");
			if(isdefined(self.gettingloadout) && self.gettingloadout && isdefined(self.spawnweaponobj) && self.spawnweaponobj == "iw7_fists_mp")
			{
				self setspawnweapon("iw7_fistslethal_mp");
				self.spawnweaponobj = "iw7_fistslethal_mp";
				return;
			}
		}
	}
}

//Function Number: 307
unsetmeleekill()
{
	scripts\mp\_utility::_takeweapon("iw7_fistsperk_mp");
	if(self hasweapon("iw7_fistslethal_mp"))
	{
		var_00 = self getcurrentweapon();
		scripts\mp\_utility::_takeweapon("iw7_fistslethal_mp");
		self giveweapon("iw7_fists_mp");
		if(var_00 == "iw7_fistslethal_mp")
		{
			scripts\mp\_utility::_switchtoweapon("iw7_fists_mp");
		}
	}
}

//Function Number: 308
setpowercell()
{
}

//Function Number: 309
unsetpowercell()
{
}

//Function Number: 310
sethardline()
{
	self endon("death");
	self endon("disconnect");
	self endon("perk_end_hardline");
	self.hardlineactive["kills"] = 0;
	self.hardlineactive["assists"] = 0;
	thread watchhardlineassists();
	while(self.hardlineactive["kills"] < 8)
	{
		self waittill("got_a_kill",var_00,var_01,var_02);
		if(isdefined(var_01) && !scripts\mp\_utility::iskillstreakweapon(var_01))
		{
			self.hardlineactive["kills"] = self.hardlineactive["kills"] + 1;
		}
	}

	self.hardlineactive = undefined;
}

//Function Number: 311
watchhardlineassists()
{
	self endon("death");
	self endon("disconnect");
	self endon("perk_end_hardline");
	for(;;)
	{
		self waittill("assist_hardline");
		if(self.hardlineactive["assists"] == 1)
		{
			self.hardlineactive["kills"] = self.hardlineactive["kills"] + 1;
			self.hardlineactive["assists"] = 0;
			continue;
		}

		self.hardlineactive["assists"] = self.hardlineactive["assists"] + 1;
	}
}

//Function Number: 312
unsethardline()
{
	self.hardlineactive = undefined;
	self notify("perk_end_hardline");
}

//Function Number: 313
func_F74A()
{
	for(;;)
	{
		foreach(var_01 in level.players)
		{
			if(!scripts\mp\_utility::isreallyalive(var_01))
			{
				continue;
			}

			if(var_01.team == self.team)
			{
				continue;
			}

			if(var_01 scripts\mp\_utility::_hasperk("specialty_coldblooded"))
			{
				continue;
			}

			if(var_01 scripts\mp\_utility::_hasperk("specialty_gpsjammer"))
			{
				continue;
			}

			if(length2d(var_01 getvelocity()) < 150 && !isdefined(var_01.campfire_temp_dialog) && distance2d(self.origin,var_01.origin) < 1024)
			{
				thread func_49EE(var_01);
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 314
func_49EE(param_00)
{
	param_00 endon("death");
	param_00 endon("disconnect");
	if(!isdefined(self) || !scripts\mp\_utility::isreallyalive(self))
	{
		return;
	}

	param_00.campfire_temp_dialog = 1;
	var_01 = scripts\mp\objidpoolmanager::requestminimapid(1);
	if(var_01 != -1)
	{
		scripts\mp\objidpoolmanager::minimap_objective_add(var_01,"active",param_00.origin,"cb_compassping_sniper_enemy",self);
		scripts\mp\objidpoolmanager::minimap_objective_team(var_01,self.team);
		param_00 thread watchfordeath(var_01);
	}

	while(length2d(param_00 getvelocity()) < 150)
	{
		wait(2);
	}

	scripts\mp\objidpoolmanager::returnminimapid(var_01);
	param_00.campfire_temp_dialog = undefined;
}

//Function Number: 315
watchfordeath(param_00)
{
	scripts\engine\utility::waittill_any_3("death","disconnect");
	scripts\mp\objidpoolmanager::returnminimapid(param_00);
	self.campfire_temp_dialog = undefined;
}

//Function Number: 316
func_12CD3()
{
}

//Function Number: 317
func_F7CD()
{
}

//Function Number: 318
unsetoverclock()
{
}

//Function Number: 319
func_F894()
{
	thread func_E8A9();
	thread func_E8AA();
}

//Function Number: 320
func_12D4E()
{
}

//Function Number: 321
func_F7DE()
{
	self.trait = "specialty_personal_trophy";
	thread scripts\mp\_playertrophy_system::func_D446();
}

//Function Number: 322
func_12D04()
{
	self.trait = undefined;
	thread scripts\mp\_playertrophy_system::func_D448();
}

//Function Number: 323
func_F6CA()
{
	thread scripts/mp/archetypes/archheavy::func_56E7();
}

//Function Number: 324
func_12CA3()
{
}

//Function Number: 325
setequipmentping()
{
	self.trait = "specialty_equipment_ping";
}

//Function Number: 326
unsetequipmentping()
{
	self.trait = undefined;
}

//Function Number: 327
setruggedeqp()
{
	self.trait = "specialty_rugged_eqp";
}

//Function Number: 328
unsetruggedeqp()
{
	self.trait = undefined;
	thread scripts/mp/supers/super_supertrophy::supertrophy_onruggedequipmentunset();
	thread scripts/mp/equipment/micro_turret::microturret_onruggedequipmentunset();
}

//Function Number: 329
feedbackruggedeqp(param_00,param_01)
{
}

//Function Number: 330
setmanatarms()
{
	self.trait = "specialty_man_at_arms";
}

//Function Number: 331
unsetmanatarms()
{
	self.trait = undefined;
}

//Function Number: 332
func_F7CB()
{
	self endon("disconnect");
	self endon("unsetOutlineKillstreaks");
	self.engstructks = engineer_createengstruct();
	var_00 = self.engstructks;
	thread engineer_watchownerdisconnect(var_00,"unsetOutlineKillstreaks");
	for(;;)
	{
		var_01 = level.var_1655;
		if(isdefined(var_01))
		{
			foreach(var_03 in var_01)
			{
				if(isdefined(var_03.model))
				{
					if(engineer_shouldoutlineent(var_03,var_00))
					{
						engineer_addoutlinedent(var_03,var_00);
					}
				}
			}
		}

		wait(0.1);
	}
}

//Function Number: 333
func_12CFC()
{
	self notify("unsetOutlineKillstreaks");
	if(isdefined(self.engstructks))
	{
		thread engineer_clearoutlinedents(self.engstructks);
	}

	self.engstructks = undefined;
}

//Function Number: 334
setengineer()
{
	self endon("disconnect");
	self endon("unsetEngineer");
	self.engstructeqp = engineer_createengstruct();
	var_00 = self.engstructeqp;
	thread engineer_watchownerdisconnect(var_00,"unsetEngineer");
	for(;;)
	{
		var_01 = func_7D96();
		foreach(var_03 in var_01)
		{
			if(engineer_shouldoutlineent(var_03,var_00))
			{
				engineer_addoutlinedent(var_03,var_00);
			}
		}

		wait(0.1);
	}
}

//Function Number: 335
unsetengineer()
{
	self notify("unsetEngineer");
	if(isdefined(self.engstructeqp))
	{
		thread engineer_clearoutlinedents(self.engstructeqp);
	}

	self.engstructeqp = undefined;
}

//Function Number: 336
engineer_createengstruct()
{
	var_00 = spawnstruct();
	var_00.triggerportableradarping = self;
	var_00.var_C78E = [];
	var_00.outlinedids = [];
	return var_00;
}

//Function Number: 337
engineer_addoutlinedent(param_00,param_01)
{
	var_02 = param_00 getentitynumber();
	var_03 = param_01.outlinedids[var_02];
	if(isdefined(var_03))
	{
		thread engineer_removeoutlinedent(var_02,param_01);
	}

	var_03 = scripts\mp\_utility::outlineenableforplayer(param_00,"red",param_01.triggerportableradarping,0,1,"level_script");
	param_01.var_C78E[var_02] = param_00;
	param_01.outlinedids[var_02] = var_03;
	thread engineer_removeoutlinedentondeath(var_02,param_01);
}

//Function Number: 338
engineer_removeoutlinedent(param_00,param_01)
{
	param_01 notify("engineer_removeOutlinedEnt_" + param_00);
	var_02 = param_01.var_C78E[param_00];
	var_03 = param_01.outlinedids[param_00];
	scripts\mp\_utility::outlinedisable(var_03,var_02);
	param_01.var_C78E[param_00] = undefined;
	param_01.outlinedids[param_00] = undefined;
}

//Function Number: 339
engineer_removeoutlinedentondeath(param_00,param_01)
{
	param_01 endon("engineer_clearOutlinedEnts");
	param_01 endon("engineer_removeOutlinedEnt_" + param_00);
	var_02 = param_01.var_C78E[param_00];
	var_02 waittill("death");
	thread engineer_removeoutlinedent(param_00,param_01);
}

//Function Number: 340
engineer_clearoutlinedents(param_00)
{
	param_00 notify("engineer_clearOutlinedEnts");
	foreach(var_03, var_02 in param_00.outlinedids)
	{
		scripts\mp\_utility::outlinedisable(var_02,param_00.var_C78E[var_03]);
	}
}

//Function Number: 341
engineer_shouldoutlineent(param_00,param_01)
{
	var_02 = param_00 getentitynumber();
	if(isdefined(param_01.outlinedids[var_02]))
	{
		return 0;
	}

	var_03 = param_00.triggerportableradarping;
	if(!scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_03,param_01.triggerportableradarping)))
	{
		return 0;
	}

	return 1;
}

//Function Number: 342
engineer_watchownerdisconnect(param_00,param_01)
{
	if(isdefined(param_01))
	{
		param_00.triggerportableradarping endon(param_01);
	}

	param_00 endon("engineer_clearOutlinedEnts");
	param_00.triggerportableradarping waittill("disconnect");
	thread engineer_clearoutlinedents(param_00);
}

//Function Number: 343
func_7D96()
{
	return scripts\engine\utility::array_remove_duplicates(scripts\engine\utility::array_combine_multiple([level.mines,level.microturrets,level.var_69D6,level.supertrophy.trophies,level.var_590F,level.var_2ABD,level.spidergrenade.activeagents,level.spidergrenade.proxies]));
}

//Function Number: 344
setcloak()
{
}

//Function Number: 345
unsetcloak()
{
}

//Function Number: 346
setwalllock()
{
	self.trait = "specialty_wall_lock";
	thread scripts/mp/archetypes/archsniper::func_E8AC();
}

//Function Number: 347
unsetwalllock()
{
	self.trait = undefined;
}

//Function Number: 348
setrush()
{
	self.trait = "specialty_rush";
	thread scripts/mp/archetypes/archscout::func_B947();
}

//Function Number: 349
unsetrush()
{
	self notify("removeCombatHigh");
	self.speedonkillmod = undefined;
	self.trait = undefined;
}

//Function Number: 350
sethover()
{
	thread runhover();
}

//Function Number: 351
unsethover()
{
}

//Function Number: 352
setmomentum()
{
	self.trait = "specialty_momentum";
	thread func_E863();
}

//Function Number: 353
func_E863()
{
	self endon("death");
	self endon("disconnect");
	self endon("momentum_unset");
	for(;;)
	{
		if(self issprinting())
		{
			_meth_848B();
			self.movespeedscaler = 1;
			scripts\mp\_weapons::updatemovespeedscale();
		}

		wait(0.1);
	}
}

//Function Number: 354
_meth_848B()
{
	self endon("death");
	self endon("disconnect");
	self endon("game_ended");
	self endon("momentum_reset");
	self endon("momentum_unset");
	thread func_B944();
	thread func_B943();
	var_00 = 0;
	while(var_00 < 0.06)
	{
		self.movespeedscaler = self.movespeedscaler + 0.01;
		scripts\mp\_weapons::updatemovespeedscale();
		wait(0.2083333);
		var_00 = var_00 + 0.01;
	}

	self notify("momentum_max_speed");
	thread momentum_endaftermax();
	self waittill("momentum_reset");
}

//Function Number: 355
momentum_endaftermax()
{
	self endon("momentum_unset");
	self waittill("momentum_reset");
}

//Function Number: 356
func_B944()
{
	self endon("death");
	self endon("disconnect");
	self endon("momentum_unset");
	for(;;)
	{
		if(!self issprinting() || self issprintsliding() || !self isonground() || self gold_teeth_hint_func())
		{
			wait(0.4);
			if(!self issprinting() || self issprintsliding() || !self isonground() || self gold_teeth_hint_func())
			{
				self notify("momentum_reset");
				break;
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 357
func_B943()
{
	self endon("death");
	self endon("disconnect");
	self waittill("damage");
	self notify("momentum_reset");
}

//Function Number: 358
unsetmomentum()
{
	self notify("momentum_unset");
	self.trait = undefined;
}

//Function Number: 359
setscavengereqp()
{
	self.trait = "specialty_scavenger_eqp";
	scripts/mp/archetypes/archengineer::func_F6E6("equipment");
}

//Function Number: 360
unsetscavengereqp()
{
	self.trait = undefined;
}

//Function Number: 361
setspawnview()
{
	thread scripts/mp/archetypes/archassassin::func_1091C();
}

//Function Number: 362
unsetspawnview()
{
	foreach(var_01 in level.players)
	{
		var_01 notify("end_spawnview");
	}
}

//Function Number: 363
setheadgear()
{
	thread scripts/mp/equipment/headgear::func_E855();
}

//Function Number: 364
unsetheadgear()
{
}

//Function Number: 365
setftlslide()
{
	self.trait = "specialty_ftlslide";
	if(scripts\mp\_utility::isanymlgmatch() && level.tactical)
	{
		self setsuit("assassin_mlgslide_mp_tactical");
		return;
	}

	if(scripts\mp\_utility::isanymlgmatch())
	{
		self setsuit("assassin_mlgslide_mp");
		return;
	}

	if(level.tactical)
	{
		self setsuit("assassin_slide_mp_tactical");
		return;
	}

	self setsuit("assassin_slide_mp");
}

//Function Number: 366
unsetftlslide()
{
	self.trait = undefined;
}

//Function Number: 367
func_F753()
{
	thread scripts/mp/archetypes/archsniper::func_E7FE();
}

//Function Number: 368
func_12CD6()
{
}

//Function Number: 369
setghost()
{
	thread updategpsjammer();
}

//Function Number: 370
unsetghost()
{
	thread removegpsjammer();
}

//Function Number: 371
setsupportkillstreaks()
{
	self endon("disconnect");
	self.trait = "specialty_support_killstreaks";
	self waittill("equipKillstreaksFinished");
	if(!isdefined(self.pers["killstreaks"][1]))
	{
		foreach(var_01 in self.pers["killstreaks"])
		{
			var_01.earned = 0;
		}
	}
}

//Function Number: 372
unsetsupportkillstreaks()
{
	self notify("end_support_killstreaks");
	self.trait = undefined;
}

//Function Number: 373
func_F7D2()
{
	self.overrideweaponspeed_speedscale = 0.98;
	scripts\mp\_weapons::updatemovespeedscale();
}

//Function Number: 374
unsetoverrideweaponspeed()
{
	self.overrideweaponspeed_speedscale = undefined;
}

//Function Number: 375
func_F657()
{
	self setclientomnvar("ui_uplink_carrier_hud",1);
	if(level.armormod == 0)
	{
		self setclientomnvar("ui_uplink_carrier_armor_max",100);
	}
	else
	{
		self setclientomnvar("ui_uplink_carrier_armor_max",level.carrierarmor);
	}

	if(level.possessionresetcondition != 0)
	{
		self setclientomnvar("ui_uplink_timer_hud",1);
	}
}

//Function Number: 376
func_12C77()
{
	self notify("unsetBallCarrier");
	self setclientomnvar("ui_uplink_carrier_hud",0);
	self setclientomnvar("ui_uplink_carrier_armor",-1);
	if(level.possessionresetcondition != 0)
	{
		self setclientomnvar("ui_uplink_timer_hud",0);
	}
}

//Function Number: 377
setcloakaerial()
{
	self.trait = "specialty_cloak_aerial";
}

//Function Number: 378
unsetcloakaerial()
{
	self.trait = undefined;
}

//Function Number: 379
setspawnradar()
{
	self.trait = "specialty_spawn_radar";
	self.hasspawnradar = 1;
}

//Function Number: 380
unsetspawnradar()
{
	self.trait = undefined;
	self.hasspawnradar = 1;
}

//Function Number: 381
setimprovedmelee()
{
}

//Function Number: 382
unsetimprovedmelee()
{
}

//Function Number: 383
setthief()
{
}

//Function Number: 384
unsetthief()
{
}

//Function Number: 385
setadsawareness()
{
	self.trait = "specialty_ads_awareness";
	thread runadsawareness();
	self setscriptablepartstate("heightened_senses","default");
}

//Function Number: 386
runadsawareness()
{
	self endon("death");
	self endon("disconnect");
	self endon("unsetADSAwareness");
	self.awarenessradius = 256;
	self.awarenessqueryrate = 2;
	thread awarenessmonitorstance();
	for(;;)
	{
		wait(self.awarenessqueryrate);
		foreach(var_01 in level.players)
		{
			if(var_01.team == self.team)
			{
				continue;
			}

			if(var_01 scripts\mp\_utility::_hasperk("specialty_coldblooded"))
			{
				continue;
			}

			if(var_01 isonground() && !var_01 issprinting() && !var_01 gold_teeth_hint_func() && !var_01 issprintsliding())
			{
				continue;
			}

			if(distance2d(var_01.origin,self.origin) < self.awarenessradius)
			{
				thread playincomingwarning(var_01);
			}
		}
	}
}

//Function Number: 387
playincomingwarning(param_00)
{
	self setscriptablepartstate("heightened_senses","scrn_pulse");
	self playrumbleonentity("damage_heavy");
	param_00 playsoundtoplayer("ghost_senses_ping",self);
	wait(0.2);
	if(isdefined(self))
	{
		self setscriptablepartstate("heightened_senses","default");
		if(scripts\mp\_utility::isreallyalive(self))
		{
			self playrumbleonentity("damage_heavy");
			if(isdefined(param_00) && scripts\mp\_utility::isreallyalive(param_00))
			{
				param_00 playsoundtoplayer("ghost_senses_ping",self);
				return;
			}
		}
	}
}

//Function Number: 388
awarenessmonitorstance()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		var_00 = self getstance();
		var_01 = self getvelocity();
		switch(var_00)
		{
			case "stand":
				self.awarenessradius = 400;
				self.awarenessqueryrate = 2;
				break;
	
			case "crouch":
				self.awarenessradius = 650;
				self.awarenessqueryrate = 1;
				break;
	
			case "prone":
				self.awarenessradius = 700;
				self.awarenessqueryrate = 0.5;
				break;
		}

		wait(0.01);
	}
}

//Function Number: 389
awarenessaudiopulse()
{
	self endon("death");
	self endon("disconnect");
	self endon("stop_awareness");
	for(;;)
	{
		playsoundatpos(self.origin + (0,0,5),"ghost_senses_ping");
		wait(2);
	}
}

//Function Number: 390
unsetadsawareness()
{
	self notify("unsetADSAwareness");
	self.trait = undefined;
	self setscriptablepartstate("heightened_senses","default");
}

//Function Number: 391
setrearguard()
{
	self.trait = "specialty_rearguard";
	scripts\mp\perks\_perk_rearguard_shield::func_E814();
}

//Function Number: 392
unsetrearguard()
{
	self.trait = undefined;
	self.hasrearguardshield = undefined;
}

//Function Number: 393
setbulletoutline()
{
	self.bulletoutline = spawnstruct();
	self.bulletoutline.player = self;
	self.bulletoutline.enemies = [];
	self.bulletoutline.enemyids = [];
	self.bulletoutline.enemyendtimes = [];
	self.bulletoutline thread watchbulletoutline();
	self.bulletoutline thread watchbulletoutlinecleanup();
}

//Function Number: 394
unsetbulletoutline()
{
	self notify("unsetBulletOutline");
	self.bulletoutline = undefined;
}

//Function Number: 395
watchbulletoutline()
{
	self.player endon("death");
	self.player endon("disconnect");
	self.player endon("unsetBulletOutline");
	while(isdefined(self.player))
	{
		var_00 = gettime();
		foreach(var_03, var_02 in self.enemies)
		{
			if(!isdefined(var_02))
			{
				bulletoutlineremoveenemy(undefined,var_03);
				continue;
			}

			if(var_02 scripts\mp\_utility::_hasperk("specialty_noscopeoutline"))
			{
				bulletoutlineremoveenemy(var_02,var_03);
				continue;
			}

			if(var_00 >= self.enemyendtimes[var_03])
			{
				bulletoutlineremoveenemy(var_02,var_03);
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 396
watchbulletoutlinecleanup()
{
	self.player scripts\engine\utility::waittill_any_3("disconnect","unsetBulletOutline");
	foreach(var_02, var_01 in self.enemies)
	{
		if(isdefined(var_01))
		{
			bulletoutlineremoveenemy(var_01,var_02);
		}
	}
}

//Function Number: 397
bulletoutlineaddenemy(param_00,param_01,param_02)
{
	var_03 = param_00 getentitynumber();
	var_04 = gettime() + param_01 * 1000;
	self.enemies[var_03] = param_00;
	if(!isdefined(self.enemyids[var_03]))
	{
		self.enemyids[var_03] = scripts\mp\_utility::outlineenableforplayer(param_00,"red",self.player,1,0,"perk");
	}

	if(!isdefined(self.enemyendtimes[var_03]) || !isdefined(param_02) || param_02)
	{
		self.enemyendtimes[var_03] = var_04;
	}
}

//Function Number: 398
bulletoutlineremoveenemy(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = param_00 getentitynumber();
	}

	self.enemies[param_01] = undefined;
	self.enemyendtimes[param_01] = undefined;
	if(isdefined(param_00))
	{
		scripts\mp\_utility::outlinedisable(self.enemyids[param_01],param_00);
	}

	self.enemyids[param_01] = undefined;
}

//Function Number: 399
bulletoutlinecheck(param_00,param_01,param_02,param_03)
{
	if(!param_03 == "MOD_HEAD_SHOT" || param_03 == "MOD_RIFLE_BULLET" || param_03 == "MOD_PISTOL_BULLET" || param_03 == "MOD_EXPLOSIVE_BULLET")
	{
		return;
	}

	if(!isdefined(param_00) || !isdefined(param_01))
	{
		return;
	}

	if(!isplayer(param_00) || scripts\mp\_utility::func_9F22(param_00) || !isplayer(param_01) || scripts\mp\_utility::func_9F22(param_01))
	{
		return;
	}

	var_04 = param_00;
	if(isdefined(param_00.triggerportableradarping))
	{
		var_04 = param_00.triggerportableradarping;
	}

	var_05 = param_01;
	if(isdefined(param_01.triggerportableradarping))
	{
		var_05 = param_01.triggerportableradarping;
	}

	if(!scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_04,var_05)))
	{
		return;
	}

	if(isplayer(param_00) && isplayer(param_01) && scripts\mp\_utility::func_C7A0(param_00 geteye(),param_01 geteye()))
	{
		return;
	}

	if(isdefined(param_00.bulletoutline) && !param_01 scripts\mp\_utility::_hasperk("specialty_noscopeoutline"))
	{
		param_00.bulletoutline bulletoutlineaddenemy(param_01,1);
	}

	if(isdefined(param_01.bulletoutline) && !param_00 scripts\mp\_utility::_hasperk("specialty_noscopeoutline"))
	{
		param_01.bulletoutline bulletoutlineaddenemy(param_00,2,0);
	}
}

//Function Number: 400
func_E8A9()
{
	self endon("death");
	self endon("disconnect");
	var_00 = scripts\mp\_utility::getuniqueid();
	for(;;)
	{
		foreach(var_02 in level.players)
		{
			if(!isdefined(var_02) || !scripts\mp\_utility::isreallyalive(var_02))
			{
				continue;
			}

			if(var_02.team == self.team || var_02 == self)
			{
				continue;
			}

			if(var_02 scripts\mp\_utility::_hasperk("specialty_empimmune"))
			{
				continue;
			}

			if(var_02 scripts/mp/equipment/cloak::func_9FC1())
			{
				thread markempsignatures(var_02,var_00);
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 401
func_E8AA()
{
	self endon("death");
	self endon("disconnect");
	self endon("track_killstreak_end");
	for(;;)
	{
		if(scripts\mp\_utility::isusingremote())
		{
			scripts\engine\utility::waitframe();
			scripts\mp\_utility::removeperk("specialty_tracker");
			while(scripts\mp\_utility::isusingremote())
			{
				scripts\engine\utility::waitframe();
			}

			scripts\mp\_utility::giveperk("specialty_tracker");
			break;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 402
markempsignatures(param_00,param_01)
{
	if(!isdefined(param_00.empmarked))
	{
		param_00.empmarked = [];
	}

	if(isdefined(param_00.empmarked[param_01]) && param_00.empmarked[param_01] == "active")
	{
		return;
	}

	param_00.empmarked[param_01] = "active";
	thread empvfx(param_00,param_01);
	param_00 scripts\engine\utility::waittill_any_3("death","cloak_end");
	param_00.empmarked[param_01] = undefined;
}

//Function Number: 403
empvfx(param_00,param_01)
{
	var_02 = ["j_shoulder_ri","j_shoulder_le","j_hip_ri","j_hip_le","j_spine4","j_wrist_ri","j_wrist_le"];
	while(param_00 scripts/mp/equipment/cloak::func_9FC1())
	{
		playfxontagforclients(scripts\engine\utility::getfx("tracker_cloak_tag"),param_00,var_02[randomint(var_02.size - 1)],self);
		wait(0.25);
	}

	param_00.empmarked[param_01] = undefined;
}

//Function Number: 404
updategpsjammer()
{
	self endon("remove_gpsjammer");
	self endon("death");
	self endon("disconnect");
	if(isai(self))
	{
		while(isdefined(self.avoidkillstreakonspawntimer) && self.avoidkillstreakonspawntimer > 0)
		{
			scripts\engine\utility::waitframe();
		}
	}

	if(level.minspeedsq == 0)
	{
		return;
	}

	if(level.timeperiod < 0.05)
	{
		return;
	}

	var_00 = 1;
	var_01 = 0;
	var_02 = 0;
	var_03 = 0;
	var_04 = 0;
	var_05 = 0;
	var_06 = self.origin;
	var_07 = 0;
	if(1)
	{
		var_07 = 1;
		self setplayerghost(1);
		thread ghostadvanceduavwatcher();
		return;
	}

	thread ghostadvanceduavwatcher();
	for(;;)
	{
		var_07 = 0;
		if(scripts\mp\_utility::isusingremote() || scripts\engine\utility::istrue(self.isplanting) || scripts\engine\utility::istrue(self.isdefusing) || self ismantling())
		{
			var_07 = 1;
		}
		else
		{
			if(var_05 > 1)
			{
				var_05 = 0;
				if(distancesquared(var_06,self.origin) < level.var_B75E)
				{
					var_02 = 1;
				}
				else
				{
					var_02 = 0;
				}

				var_06 = self.origin;
			}

			var_08 = self getvelocity();
			var_09 = lengthsquared(var_08);
			if(var_09 > level.minspeedsq && var_02 == 0)
			{
				var_07 = 1;
			}
		}

		if(var_07 == 1)
		{
			var_03 = 0;
			if(var_00 == 0)
			{
				var_01 = 0;
				var_00 = 1;
				self setplayerghost(1);
			}
		}
		else
		{
			var_03++;
			if(var_00 == 1 && var_03 >= level._meth_848A)
			{
				var_01 = 1;
				var_00 = 0;
				self setplayerghost(0);
			}
		}

		if(var_01 == 1)
		{
			level notify("radar_status_change");
		}

		var_05 = var_05 + level.timeperiod;
		wait(level.timeperiod);
	}
}

//Function Number: 405
ghostadvanceduavwatcher()
{
	self endon("death");
	self endon("disconnect");
	self endon("remove_gpsjammer");
	for(;;)
	{
		if(level.teambased)
		{
			if(isdefined(level.activeadvanceduavs) && scripts\mp\_utility::istrue(level.activeadvanceduavs[scripts\mp\_utility::getotherteam(self.team)]))
			{
				self setplayerghost(0);
				while(scripts\mp\_utility::istrue(level.activeadvanceduavs[scripts\mp\_utility::getotherteam(self.team)]))
				{
					scripts\engine\utility::waitframe();
				}

				self setplayerghost(1);
			}
		}
		else
		{
			foreach(var_01 in level.players)
			{
				if(var_01 == self)
				{
					continue;
				}

				if(scripts\mp\_utility::istrue(level.activeadvanceduavs[var_01.guid]) && level.activeadvanceduavs[var_01.guid] > 0)
				{
					self setplayerghost(0);
					while(scripts\mp\_utility::istrue(level.activeadvanceduavs[var_01.guid]) && level.activeadvanceduavs[var_01.guid] > 0)
					{
						level waittill("uav_update");
					}

					self setplayerghost(1);
				}
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 406
removegpsjammer()
{
	self notify("remove_gpsjammer");
	self setplayerghost(0);
}

//Function Number: 407
setgroundpoundshield()
{
	level._effect["groundPoundShield_impact"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	thread scripts/mp/equipment/ground_pound::func_8655(6,8,::groundpoundshield_onimpact,"groundPoundShield_unset");
}

//Function Number: 408
unsetgroundpoundshield()
{
	self notify("groundPoundShield_unset");
}

//Function Number: 409
groundpoundshield_onimpact(param_00)
{
	thread groundpoundshield_raiseondelay();
}

//Function Number: 410
groundpoundshield_raiseondelay()
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundLand");
	wait(0.25);
	groundpoundshield_raise();
}

//Function Number: 411
groundpoundshield_raise()
{
	if(isdefined(self.groundpoundshield))
	{
		thread groundpoundshield_lower(self.groundpoundshield);
	}

	var_00 = self.origin + anglestoforward(self.angles) * 5;
	var_01 = self.angles + (0,90,0);
	var_02 = spawn("script_model",var_00);
	var_02.angles = var_01;
	var_02 setmodel("weapon_shinguard_col_wm");
	var_03 = spawn("script_model",var_00);
	var_03.angles = var_01;
	var_03 setmodel("weapon_shinguard_fr_wm");
	var_03.outlineid = scripts\mp\_utility::func_C793(var_03,"cyan",0,0,"equipment");
	var_04 = spawn("script_model",var_00);
	var_04.angles = var_01;
	var_04 setmodel("weapon_shinguard_en_wm");
	var_04.outlineid = scripts\mp\_utility::func_C793(var_04,"orange",0,0,"equipment");
	var_02.visfr = var_03;
	var_02.visen = var_04;
	var_02.triggerportableradarping = self;
	var_02 setcandamage(1);
	var_02 _meth_847F(1);
	var_02.health = 9999;
	var_02.shieldhealth = 210;
	self.groundpoundshield = var_02;
	var_05 = level.characters;
	foreach(var_07 in var_05)
	{
		if(!isdefined(var_07))
		{
			continue;
		}

		if(level.teambased && var_07.team == self.team)
		{
			var_04 hidefromplayer(var_07);
			continue;
		}

		var_03 hidefromplayer(var_07);
	}

	thread groundpoundshield_monitorjoinedteam(var_02);
	thread groundpoundshield_loweronleavearea(var_02);
	thread groundpoundshield_lowerontime(var_02,3.25);
	thread groundpoundshield_loweronjump(var_02);
	thread groundpoundshield_deleteondisconnect(var_02);
	thread groundpoundshield_monitorhealth(var_02);
	thread groundpound_raisefx();
	return var_02;
}

//Function Number: 412
groundpoundshield_lower(param_00)
{
	self notify("groundPoundShield_end");
	if(!isdefined(param_00))
	{
		return;
	}

	thread groundpoundshield_lowerfx();
	thread groundpoundshield_deleteshield(param_00);
}

//Function Number: 413
groundpoundshield_break(param_00)
{
	self notify("groundPoundShield_end");
	if(!isdefined(param_00))
	{
		return;
	}

	thread func_865E();
	thread groundpoundshield_deleteshield(param_00);
}

//Function Number: 414
groundpoundshield_monitorhealth(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	for(;;)
	{
		param_00 waittill("damage",var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09,var_0A);
		if(isdefined(var_02))
		{
			if(var_02 == self || var_02.team != self.team)
			{
				param_00.shieldhealth = param_00.shieldhealth - var_01;
			}
		}

		param_00.health = 9999;
		thread groundpoundshield_damagedfx(var_02,var_04,var_03);
		if(param_00.shieldhealth <= 0)
		{
			thread groundpoundshield_break(param_00);
			return;
		}
		else if(param_00.shieldhealth <= 105)
		{
			if(param_00.visfr.model != "weapon_shinguard_dam_wm")
			{
				param_00.visfr setmodel("weapon_shinguard_dam_wm");
				scripts\mp\_utility::func_C7AA(param_00.visfr);
			}

			if(param_00.visen.model != "weapon_shinguard_dam_wm")
			{
				param_00.visen setmodel("weapon_shinguard_dam_wm");
				scripts\mp\_utility::func_C7AA(param_00.visen);
			}
		}
	}
}

//Function Number: 415
groundpoundshield_loweronjump(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	var_01 = self isjumping();
	var_02 = undefined;
	for(;;)
	{
		var_02 = var_01;
		var_01 = self isjumping();
		if(!var_02 && var_01)
		{
			thread groundpoundshield_lower(param_00);
			return;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 416
groundpoundshield_lowerontime(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	wait(param_01);
	thread groundpoundshield_lower(param_00);
}

//Function Number: 417
groundpoundshield_loweronleavearea(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	while(isdefined(param_00))
	{
		if(lengthsquared(param_00.origin - self.origin) > 11664)
		{
			thread groundpoundshield_lower(param_00);
			return;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 418
groundpoundshield_deleteondisconnect(param_00)
{
	self endon("groundPoundShield_deleteShield");
	scripts\engine\utility::waittill_any_3("death","disconnect","groundPound_unset");
	thread groundpoundshield_deleteshield(param_00);
}

//Function Number: 419
groundpoundshield_monitorjoinedteam(param_00)
{
	self endon("groundPoundShield_deleteShield");
	var_01 = self.team;
	for(;;)
	{
		level waittill("joined_team",var_02);
		if(level.teambased && var_02.team == var_01)
		{
			param_00.visfr showtoplayer(var_02);
			param_00.visen hidefromplayer(var_02);
			continue;
		}

		param_00.visfr hidefromplayer(var_02);
		param_00.visen showtoplayer(var_02);
	}
}

//Function Number: 420
groundpoundshield_deleteshield(param_00)
{
	self notify("groundPoundShield_deleteShield");
	scripts\mp\_utility::outlinedisable(param_00.visfr.outlineid,param_00.visfr);
	scripts\mp\_utility::outlinedisable(param_00.visen.outlineid,param_00.visen);
	param_00.visfr delete();
	param_00.visen delete();
	param_00 delete();
}

//Function Number: 421
groundpound_raisefx()
{
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	self playlocalsound("heavy_shield_up");
	self playsoundtoteam("heavy_shield_up_npc","axis",self);
	self playsoundtoteam("heavy_shield_up_npc","allies",self);
}

//Function Number: 422
groundpoundshield_lowerfx()
{
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	self playlocalsound("heavy_shield_down");
	self playsoundtoteam("heavy_shield_down_npc","axis",self);
	self playsoundtoteam("heavy_shield_down_npc","allies",self);
}

//Function Number: 423
groundpoundshield_damagedfx(param_00,param_01,param_02)
{
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
	playfx(scripts\engine\utility::getfx("groundPoundShield_impact"),param_01,-1 * param_02);
	playsoundatpos(param_01,"ds_shield_impact");
	param_00 scripts\mp\_damagefeedback::updatedamagefeedback("hitbulletstorm");
}

//Function Number: 424
func_865E()
{
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShield_end");
	self endon("groundPoundShield_deleteShield");
}

//Function Number: 425
setgroundpoundshock()
{
	level._effect["groundPoundShock_impact_sm"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	level._effect["groundPoundShock_impact_lrg"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	thread scripts/mp/equipment/ground_pound::func_8655(7,8,::groundpoundshock_onimpact,"groundPoundShock_unset");
}

//Function Number: 426
unsetgroundpoundshock()
{
	self notify("groundPoundShock_unset");
}

//Function Number: 427
groundpoundshock_onimpact(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("groundPound_unset");
	self endon("groundPoundShock_unset");
	var_01 = undefined;
	var_02 = undefined;
	switch(param_00)
	{
		case "groundPoundLandTier0":
			var_02 = scripts\engine\utility::getfx("groundPoundShock_impact_sm");
			var_01 = 144;
			break;

		case "groundPoundLandTier1":
			var_02 = scripts\engine\utility::getfx("groundPoundShock_impact_sm");
			var_01 = 180;
			break;

		case "groundPoundLandTier2":
			var_02 = scripts\engine\utility::getfx("groundPoundShock_impact_lrg");
			var_01 = 216;
			break;
	}

	thread groundpoundshock_onimpactfx(var_01,var_02);
	var_03 = undefined;
	if(level.teambased)
	{
		var_03 = scripts\mp\_utility::getteamarray(scripts\mp\_utility::getotherteam(self.team));
	}
	else
	{
		var_03 = level.characters;
	}

	var_04 = var_01 * var_01;
	var_05 = scripts\common\trace::create_contents(0,1,0,0,1,0,0);
	foreach(var_07 in var_03)
	{
		if(!isdefined(var_07) || var_07 == self || !var_07 scripts\mp\killstreaks\_emp_common::func_FFC5())
		{
			continue;
		}

		if(lengthsquared(var_07 geteye() - self geteye()) > var_04)
		{
			continue;
		}

		var_08 = function_0287(self geteye(),var_07 geteye(),var_05,undefined,0,"physicsquery_closest");
		if(isdefined(var_08) && var_08.size > 0)
		{
			continue;
		}

		thread groundpoundshock_empplayer(var_07);
	}

	var_0A = scripts\mp\_weapons::getempdamageents(self.origin,var_01,0,undefined);
	foreach(var_0C in var_0A)
	{
		if(isdefined(var_0C.triggerportableradarping) && !scripts\mp\_weapons::friendlyfirecheck(self,var_0C.triggerportableradarping))
		{
			continue;
		}

		var_0C notify("emp_damage",self,3);
	}
}

//Function Number: 428
groundpoundshock_empplayer(param_00)
{
	param_00 endon("death");
	param_00 endon("disconnect");
	param_00 scripts\mp\killstreaks\_emp_common::func_20C3();
	scripts\mp\_gamescore::func_11ACE(self,param_00,"groundpound_mp");
	param_00 shellshock("concussion_grenade_mp",3);
	wait(3);
	param_00 scripts\mp\killstreaks\_emp_common::func_E0F3();
	if(isdefined(self))
	{
		scripts\mp\_gamescore::untrackdebuffassist(self,param_00,"groundpound_mp");
	}
}

//Function Number: 429
groundpoundshock_onimpactfx(param_00,param_01)
{
	playfx(param_01,self.origin + (0,0,20),(0,0,1));
}

//Function Number: 430
setgroundpoundboost()
{
	thread scripts/mp/equipment/ground_pound::func_8655(8,8,::groundpoundboost_onimpact,"groundPoundBoost_unset");
}

//Function Number: 431
unsetgroundpoundboost()
{
	self notify("groundPoundBoost_unset");
}

//Function Number: 432
groundpoundboost_onimpact(param_00)
{
	scripts\engine\utility::set_doublejumpenergy(self energy_getmax(0));
}

//Function Number: 433
setbattleslideshield()
{
	level._effect["battleSlideShield_damage"] = loadfx("vfx/iw7/_requests/mp/vfx_debug_warning.vfx");
	thread battleslideshield_monitor();
}

//Function Number: 434
unsetbattleslideshield()
{
	self notify("battleSlideShield_unset");
}

//Function Number: 435
battleslideshield_monitor()
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self notify("battleSlideShield_monitor");
	self endon("battleSlideShield_monitor");
	for(;;)
	{
		self waittill("sprint_slide_begin");
		thread battleslideshield_raise();
	}
}

//Function Number: 436
battleslideshield_monitorhealth(param_00)
{
	self endon("disconnect");
	self endon("battleSlide_unset");
	while(isdefined(param_00))
	{
		param_00 waittill("damage",var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09,var_0A);
		thread battleslideshield_damagedfx(param_00,var_02,var_04,var_03);
		if(param_00.health <= 0)
		{
			thread battleslideshield_break(param_00);
			param_00 delete();
			continue;
		}

		if(param_00.health <= 125)
		{
			if(param_00.model != "weapon_shinguard_dam_wm")
			{
				param_00 setmodel("weapon_shinguard_dam_wm");
			}

			continue;
		}

		if(param_00.model != "weapon_shinguard_wm")
		{
			param_00 setmodel("weapon_shinguard_wm");
		}
	}
}

//Function Number: 437
battleslideshield_raise()
{
	if(isdefined(self.battleslideshield))
	{
		thread battleslideshield_lower(self.battleslideshield);
	}

	var_00 = scripts\engine\utility::spawn_tag_origin();
	var_00 setmodel("weapon_shinguard_wm");
	var_00 setcandamage(1);
	var_00.health = 250;
	var_00 linkto(self,"tag_origin",(30,0,0),(0,90,0));
	var_00 show();
	self.battleslideshield = var_00;
	thread battleslideshield_killonjumpfall(var_00);
	thread battleslideshield_killonsprint(var_00);
	thread battleslideshield_killontime(var_00);
	thread battleslideshield_unlinkonstop(var_00);
	thread battleslideshield_monitorhealth(var_00);
	thread battleslideshield_killondeathdisconnectunset(var_00);
	thread battleslideshield_raisefx(var_00);
	return var_00;
}

//Function Number: 438
battleslideshield_lower(param_00)
{
	self notify("battleSlideShield_end");
	if(!isdefined(param_00))
	{
		return;
	}

	thread battleslideshield_lowerfx(param_00);
	param_00 delete();
}

//Function Number: 439
battleslideshield_killondeathdisconnectunset(param_00)
{
	param_00 endon("death");
	scripts\engine\utility::waittill_any_3("death","disconnect","battleSlide_unset");
	param_00 delete();
}

//Function Number: 440
battleslideshield_killonjumpfall(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self endon("battleSlideShield_unlink");
	self endon("battleSlideShield_end");
	param_00 endon("death");
	for(;;)
	{
		if(!self isonground())
		{
			param_00 delete();
			self notify("battleSlideShield_end");
			return;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 441
battleslideshield_killonsprint(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self endon("battleSlideShield_unlink");
	self endon("battleSlideShield_end");
	param_00 endon("death");
	self waittill("sprint_begin");
	param_00 delete();
	self notify("battleSlideShield_end");
}

//Function Number: 442
battleslideshield_loweronleavearea(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self endon("battleSlideShield_end");
	param_00 endon("death");
	for(;;)
	{
		if(lengthsquared(param_00.origin - self.origin) > 11664)
		{
			thread battleslideshield_lower(param_00);
			return;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 443
battleslideshield_lowerontime(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self endon("battleSlideShield_end");
	param_00 endon("death");
	wait(3.5);
	thread battleslideshield_lower(param_00);
}

//Function Number: 444
battleslideshield_unlink(param_00)
{
	if(!isdefined(param_00))
	{
		return;
	}

	param_00 unlink();
	self notify("battleSlideShield_unlink");
	thread battleslideshield_lowerontime(param_00);
	thread battleslideshield_loweronleavearea(param_00);
	self notify("battleSlideShield_unlink");
}

//Function Number: 445
battleslideshield_killontime(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self endon("battleSlideShield_unlink");
	self endon("battleSlideShield_end");
	param_00 endon("death");
	self waittill("sprint_slide_end");
	wait(0.75);
	param_00 delete();
	self notify("battleSlideShield_end");
}

//Function Number: 446
battleslideshield_unlinkonstop(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("battleSlide_unset");
	self endon("battleSlideShield_unlink");
	self endon("battleSlideShield_end");
	param_00 endon("death");
	self waittill("sprint_slide_end");
	for(;;)
	{
		if(lengthsquared(self getvelocity()) < 100)
		{
			thread battleslideshield_unlink(param_00);
			return;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 447
battleslideshield_break(param_00)
{
	if(!isdefined(param_00))
	{
		return;
	}

	thread battleslideshield_breakfx(param_00);
	self notify("battleSlideShield_end");
}

//Function Number: 448
battleslideshield_raisefx(param_00)
{
	self endon("disconnect");
	self endon("battleSlide_unset");
	param_00 endon("death");
	self playlocalsound("heavy_shield_up");
	self playsoundtoteam("heavy_shield_up_npc","axis",self);
	self playsoundtoteam("heavy_shield_up_npc","allies",self);
}

//Function Number: 449
battleslideshield_lowerfx(param_00)
{
	self endon("disconnect");
	self endon("battleSlide_unset");
	param_00 endon("death");
	self playlocalsound("heavy_shield_down");
	self playsoundtoteam("heavy_shield_down_npc","axis",self);
	self playsoundtoteam("heavy_shield_down_npc","allies",self);
}

//Function Number: 450
battleslideshield_damagedfx(param_00,param_01,param_02,param_03)
{
	self endon("disconnect");
	self endon("battleSlide_unset");
	param_00 endon("death");
	playfx(scripts\engine\utility::getfx("battleSlideShield_damage"),param_02,-1 * param_03);
	playsoundatpos(param_02,"ds_shield_impact");
	param_01 scripts\mp\_damagefeedback::updatedamagefeedback("hitbulletstorm");
}

//Function Number: 451
battleslideshield_breakfx(param_00)
{
}

//Function Number: 452
setbattleslideoffense()
{
}

//Function Number: 453
unsetbattleslideoffense()
{
}

//Function Number: 454
getbattleslideoffensedamage()
{
	return 100;
}

//Function Number: 455
setthruster()
{
	level._effect["thrusterRadFr"] = loadfx("vfx/iw7/core/mp/powers/thrust_blast/vfx_thrust_blast_radius_fr");
	level._effect["thrusterRadEn"] = loadfx("vfx/iw7/core/mp/powers/thrust_blast/vfx_thrust_blast_radius_en");
	thrusterwatchdoublejump();
}

//Function Number: 456
unsetthruster()
{
	if(isdefined(self.thrustfxent))
	{
		self.thrustfxent delete();
	}

	self notify("thruster_unset");
}

//Function Number: 457
thrusterwatchdoublejump()
{
	self endon("death");
	self endon("disconnect");
	self endon("thruster_unset");
	level endon("game_ended");
	for(;;)
	{
		self waittill("doubleJumpBoostBegin");
		thread thrusterloop();
		thread thrusterdamageloop();
	}
}

//Function Number: 458
thrusterloop()
{
	self endon("death");
	self endon("disconnect");
	self endon("thruster_unset");
	level endon("game_ended");
	self endon("doubleJumpBoostEnd");
	if(!scripts\mp\_utility::_hasperk("specialty_quieter"))
	{
		self playsoundonmovingent("demolition_jump_expl");
	}

	thread thrusterstopfx();
	if(!isdefined(self.thrustfxent))
	{
		self.thrustfxent = spawn("script_model",self.origin);
		self.thrustfxent setmodel("tag_origin");
	}
	else
	{
		self.thrustfxent.origin = self.origin;
	}

	wait(0.05);
	for(;;)
	{
		self playrumbleonentity("damage_light");
		scripts\mp\_shellshock::_earthquake(0.1,0.3,self.origin,120);
		var_00 = playerphysicstrace(self.origin + (0,0,10),self.origin - (0,0,600)) + (0,0,1);
		self.thrustfxent.origin = var_00;
		self.thrustfxent.angles = (90,0,0);
		wait(0.05);
		scripts\mp\_utility::func_D486(self.thrustfxent,"tag_origin",self.team,scripts\engine\utility::getfx("thrusterRadFr"),scripts\engine\utility::getfx("thrusterRadEn"));
		wait(0.33);
	}
}

//Function Number: 459
thrusterdamageloop()
{
	self endon("death");
	self endon("disconnect");
	self endon("thruster_unset");
	level endon("game_ended");
	self endon("doubleJumpBoostEnd");
	for(;;)
	{
		scripts\mp\_utility::radiusplayerdamage(self.origin,12,64,5,12,self,undefined,"MOD_IMPACT","thruster_mp",1);
		wait(0.05);
	}
}

//Function Number: 460
thrusterstopfx()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	scripts\engine\utility::waittill_any_3("doubleJumpBoostEnd","thruster_unset");
	wait(0.05);
}

//Function Number: 461
runhover()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	level endon("game_ended");
	for(;;)
	{
		if(self ishighjumping() && self getweaponrankinfominxp() > 0.3 && self goal_position(0) > 0)
		{
			executehover();
			thread watchhoverend();
			self waittill("hover_ended");
			endhover();
		}

		wait(0.1);
	}
}

//Function Number: 462
watchhoverend()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	level endon("game_ended");
	self endon("walllock_ended");
	while(self getweaponrankinfominxp() > 0.3)
	{
		wait(0.05);
	}

	self notify("hover_ended");
}

//Function Number: 463
executehover()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	level endon("game_ended");
	self.ishovering = 1;
	self allowmovement(0);
	self allowjump(0);
	self playlocalsound("ghost_wall_attach");
	var_00 = scripts\engine\utility::spawn_tag_origin();
	self playerlinkto(var_00);
	thread managetimeout(var_00);
}

//Function Number: 464
managetimeout(param_00)
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	level endon("game_ended");
	var_01 = self energy_getrestorerate(0);
	self goalflag(0,1);
	wait(2);
	self notify("hover_ended");
	self goalflag(0,var_01);
	self goal_radius(0,0);
}

//Function Number: 465
endhover()
{
	self endon("death");
	self endon("disconnect");
	self endon("removeArchetype");
	level endon("game_ended");
	self.ishovering = undefined;
	self allowmovement(1);
	self allowjump(1);
	self playlocalsound("ghost_wall_detach");
	self unlink();
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_remotetank.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 46
 * Decompile Time: 2347 ms
 * Timestamp: 10/27/2023 12:29:30 AM
*******************************************************************/

//Function Number: 1
init()
{
	scripts\mp\killstreaks\_killstreaks::registerkillstreak("remote_tank",::func_128FE);
	level.tanksettings = [];
	level.tanksettings["remote_tank"] = spawnstruct();
	level.tanksettings["remote_tank"].timeout = 60;
	level.tanksettings["remote_tank"].health = 99999;
	level.tanksettings["remote_tank"].maxhealth = 1000;
	level.tanksettings["remote_tank"].streakname = "remote_tank";
	level.tanksettings["remote_tank"].mgturretinfo = "ugv_turret_mp";
	level.tanksettings["remote_tank"].var_B88D = "remote_tank_projectile_mp";
	level.tanksettings["remote_tank"].sentrymodeoff = "sentry_offline";
	level.tanksettings["remote_tank"].vehicleinfo = "remote_ugv_mp";
	level.tanksettings["remote_tank"].modelbase = "vehicle_ugv_talon_mp";
	level.tanksettings["remote_tank"].var_B922 = "vehicle_ugv_talon_gun_mp";
	level.tanksettings["remote_tank"].modelplacement = "vehicle_ugv_talon_obj";
	level.tanksettings["remote_tank"].modelplacementfailed = "vehicle_ugv_talon_obj_red";
	level.tanksettings["remote_tank"].modeldestroyed = "vehicle_ugv_talon_mp";
	level.tanksettings["remote_tank"].var_1114D = &"KILLSTREAKS_REMOTE_TANK_PLACE";
	level.tanksettings["remote_tank"].var_1114C = &"KILLSTREAKS_REMOTE_TANK_CANNOT_PLACE";
	level.tanksettings["remote_tank"].var_A84D = "killstreak_remote_tank_laptop_mp";
	level.tanksettings["remote_tank"].remotedetonatethink = "killstreak_remote_tank_remote_mp";
	level._effect["remote_tank_dying"] = loadfx("vfx/core/expl/killstreak_explosion_quick");
	level._effect["remote_tank_explode"] = loadfx("vfx/core/expl/bouncing_betty_explosion");
	level._effect["remote_tank_spark"] = loadfx("vfx/core/impacts/large_metal_painted_hit");
	level._effect["remote_tank_antenna_light_mp"] = loadfx("vfx/core/vehicles/aircraft_light_red_blink");
	level._effect["remote_tank_camera_light_mp"] = loadfx("vfx/core/vehicles/aircraft_light_wingtip_green");
	level.remote_tank_armor_bulletdamage = 0.5;
}

//Function Number: 2
func_128FE(param_00,param_01)
{
	var_02 = 1;
	if(scripts\mp\_utility::currentactivevehiclecount() >= scripts\mp\_utility::maxvehiclesallowed() || level.fauxvehiclecount + var_02 >= scripts\mp\_utility::maxvehiclesallowed())
	{
		self iprintlnbold(&"KILLSTREAKS_TOO_MANY_VEHICLES");
		return 0;
	}

	scripts\mp\_utility::incrementfauxvehiclecount();
	var_03 = _meth_83AC(param_00,"remote_tank");
	if(var_03)
	{
		scripts\mp\_matchdata::logkillstreakevent("remote_tank",self.origin);
		thread scripts\mp\_utility::teamplayercardsplash("used_remote_tank",self);
		func_1146D("remote_tank");
	}
	else
	{
		scripts\mp\_utility::decrementfauxvehiclecount();
	}

	self.iscarrying = 0;
	return var_03;
}

//Function Number: 3
func_1146D(param_00)
{
	var_01 = scripts\mp\_utility::getkillstreakweapon(level.tanksettings[param_00].streakname);
	scripts\mp\killstreaks\_killstreaks::func_1146C(var_01);
	scripts\mp\_utility::_takeweapon(level.tanksettings[param_00].var_A84D);
	scripts\mp\_utility::_takeweapon(level.tanksettings[param_00].remotedetonatethink);
}

//Function Number: 4
removeperks()
{
	if(scripts\mp\_utility::_hasperk("specialty_explosivebullets"))
	{
		self.restoreperk = "specialty_explosivebullets";
		scripts\mp\_utility::removeperk("specialty_explosivebullets");
	}
}

//Function Number: 5
restoreperks()
{
	if(isdefined(self.restoreperk))
	{
		scripts\mp\_utility::giveperk(self.restoreperk);
		self.restoreperk = undefined;
	}
}

//Function Number: 6
waitrestoreperks()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	wait(0.05);
	restoreperks();
}

//Function Number: 7
removeweapons()
{
	var_00 = self getweaponslistprimaries();
	foreach(var_02 in var_00)
	{
		var_03 = strtok(var_02,"_");
		if(var_03[0] == "alt")
		{
			self.restoreweaponclipammo[var_02] = self getweaponammoclip(var_02);
			self.var_E2E9[var_02] = self getweaponammostock(var_02);
			continue;
		}

		self.restoreweaponclipammo[var_02] = self getweaponammoclip(var_02);
		self.var_E2E9[var_02] = self getweaponammostock(var_02);
	}

	self.var_13CD2 = [];
	foreach(var_02 in var_00)
	{
		var_03 = strtok(var_02,"_");
		self.var_13CD2[self.var_13CD2.size] = var_02;
		if(var_03[0] == "alt")
		{
			continue;
		}

		scripts\mp\_utility::_takeweapon(var_02);
	}
}

//Function Number: 8
restoreweapons()
{
	if(!isdefined(self.restoreweaponclipammo) || !isdefined(self.var_E2E9) || !isdefined(self.var_13CD2))
	{
		return;
	}

	var_00 = [];
	foreach(var_02 in self.var_13CD2)
	{
		var_03 = strtok(var_02,"_");
		if(var_03[0] == "alt")
		{
			var_00[var_00.size] = var_02;
			continue;
		}

		scripts\mp\_utility::_giveweapon(var_02);
		if(isdefined(self.restoreweaponclipammo[var_02]))
		{
			self setweaponammoclip(var_02,self.restoreweaponclipammo[var_02]);
		}

		if(isdefined(self.var_E2E9[var_02]))
		{
			self setweaponammostock(var_02,self.var_E2E9[var_02]);
		}
	}

	foreach(var_06 in var_00)
	{
		if(isdefined(self.restoreweaponclipammo[var_06]))
		{
			self setweaponammoclip(var_06,self.restoreweaponclipammo[var_06]);
		}

		if(isdefined(self.var_E2E9[var_06]))
		{
			self setweaponammostock(var_06,self.var_E2E9[var_06]);
		}
	}

	self.restoreweaponclipammo = undefined;
	self.var_E2E9 = undefined;
}

//Function Number: 9
func_13710()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	wait(0.05);
	restoreweapons();
}

//Function Number: 10
_meth_83AC(param_00,param_01)
{
	var_02 = func_4A20(param_01,self);
	var_02.lifeid = param_00;
	removeperks();
	removeweapons();
	var_03 = func_F689(var_02,1);
	thread restoreperks();
	thread restoreweapons();
	if(!isdefined(var_03))
	{
		var_03 = 0;
	}

	return var_03;
}

//Function Number: 11
func_4A20(param_00,param_01)
{
	var_02 = spawnturret("misc_turret",param_01.origin + (0,0,25),level.tanksettings[param_00].mgturretinfo);
	var_02.angles = param_01.angles;
	var_02.tanktype = param_00;
	var_02.triggerportableradarping = param_01;
	var_02 setmodel(level.tanksettings[param_00].modelbase);
	var_02 getvalidattachments();
	var_02 setturretmodechangewait(1);
	var_02 give_player_session_tokens("sentry_offline");
	var_02 makeunusable();
	var_02 setsentryowner(param_01);
	return var_02;
}

//Function Number: 12
func_F689(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	param_00 thread func_114CE(self);
	scripts\engine\utility::allow_weapon(0);
	self notifyonplayercommand("place_tank","+attack");
	self notifyonplayercommand("place_tank","+attack_akimbo_accessible");
	self notifyonplayercommand("cancel_tank","+actionslot 4");
	if(!level.console)
	{
		self notifyonplayercommand("cancel_tank","+actionslot 5");
		self notifyonplayercommand("cancel_tank","+actionslot 6");
		self notifyonplayercommand("cancel_tank","+actionslot 7");
	}

	for(;;)
	{
		var_02 = scripts\engine\utility::waittill_any_return("place_tank","cancel_tank","force_cancel_placement");
		if(var_02 == "cancel_tank" || var_02 == "force_cancel_placement")
		{
			if(!param_01 && var_02 == "cancel_tank")
			{
				continue;
			}

			if(level.console)
			{
				var_03 = scripts\mp\_utility::getkillstreakweapon(level.tanksettings[param_00.tanktype].streakname);
				if(isdefined(self.var_A6A1) && var_03 == scripts\mp\_utility::getkillstreakweapon(self.pers["killstreaks"][self.var_A6A1].streakname) && !self getweaponslistitems().size)
				{
					scripts\mp\_utility::_giveweapon(var_03,0);
					scripts\mp\_utility::_setactionslot(4,"weapon",var_03);
				}
			}

			param_00 func_114CD();
			scripts\engine\utility::allow_weapon(1);
			return 0;
		}

		if(!param_00.canbeplaced)
		{
			continue;
		}

		param_00 thread func_114D0();
		scripts\engine\utility::allow_weapon(1);
		return 1;
	}
}

//Function Number: 13
func_114CE(param_00)
{
	self setmodel(level.tanksettings[self.tanktype].modelplacement);
	self setsentrycarrier(param_00);
	self setcontents(0);
	self setcandamage(0);
	self.carriedby = param_00;
	param_00.iscarrying = 1;
	param_00 thread func_12F34(self);
	thread func_114C6(param_00);
	thread func_114C7(param_00);
	thread func_114C8();
	self notify("carried");
}

//Function Number: 14
func_12F34(param_00)
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	param_00 endon("placed");
	param_00 endon("death");
	param_00.canbeplaced = 1;
	var_01 = -1;
	for(;;)
	{
		var_02 = self canplayerplacetank(25,25,50,40,80,0.7);
		param_00.origin = var_02["origin"];
		param_00.angles = var_02["angles"];
		param_00.canbeplaced = self isonground() && var_02["result"] && abs(var_02["origin"][2] - self.origin[2]) < 20;
		if(param_00.canbeplaced != var_01)
		{
			if(param_00.canbeplaced)
			{
				param_00 setmodel(level.tanksettings[param_00.tanktype].modelplacement);
				if(self.team != "spectator")
				{
					self forceusehinton(level.tanksettings[param_00.tanktype].var_1114D);
				}
			}
			else
			{
				param_00 setmodel(level.tanksettings[param_00.tanktype].modelplacementfailed);
				if(self.team != "spectator")
				{
					self forceusehinton(level.tanksettings[param_00.tanktype].var_1114C);
				}
			}
		}

		var_01 = param_00.canbeplaced;
		wait(0.05);
	}
}

//Function Number: 15
func_114C6(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 waittill("death");
	func_114CD();
}

//Function Number: 16
func_114C7(param_00)
{
	self endon("placed");
	self endon("death");
	param_00 waittill("disconnect");
	func_114CD();
}

//Function Number: 17
func_114C8(param_00)
{
	self endon("placed");
	self endon("death");
	level waittill("game_ended");
	func_114CD();
}

//Function Number: 18
func_114CD()
{
	if(isdefined(self.carriedby))
	{
		self.carriedby getrigindexfromarchetyperef();
	}

	if(isdefined(self.triggerportableradarping))
	{
		self.triggerportableradarping.iscarrying = 0;
	}

	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 19
func_114D0()
{
	self endon("death");
	level endon("game_ended");
	self notify("placed");
	self.carriedby getrigindexfromarchetyperef();
	self.carriedby = undefined;
	if(!isdefined(self.triggerportableradarping))
	{
		return 0;
	}

	var_00 = self.triggerportableradarping;
	var_00.iscarrying = 0;
	var_01 = func_4A1F(self);
	if(!isdefined(var_01))
	{
		return 0;
	}

	var_01 playsound("sentry_gun_plant");
	var_01 notify("placed");
	var_01 thread func_114CC();
	self delete();
}

//Function Number: 20
func_114BB()
{
	self endon("death");
	level endon("game_ended");
	if(!isdefined(self.triggerportableradarping))
	{
		return;
	}

	var_00 = self.triggerportableradarping;
	var_00 endon("death");
	self waittill("placed");
	var_00 func_1146D(self.tanktype);
	var_00 scripts\mp\_utility::_giveweapon(level.tanksettings[self.tanktype].var_A84D);
	var_00 scripts\mp\_utility::_switchtoweaponimmediate(level.tanksettings[self.tanktype].var_A84D);
}

//Function Number: 21
func_4A1F(param_00)
{
	var_01 = param_00.triggerportableradarping;
	var_02 = param_00.tanktype;
	var_03 = param_00.lifeid;
	var_04 = spawnvehicle(level.tanksettings[var_02].modelbase,var_02,level.tanksettings[var_02].vehicleinfo,param_00.origin,param_00.angles,var_01);
	if(!isdefined(var_04))
	{
		return undefined;
	}

	var_05 = var_04 gettagorigin("tag_turret_attach");
	var_06 = spawnturret("misc_turret",var_05,level.tanksettings[var_02].mgturretinfo,0);
	var_06 linkto(var_04,"tag_turret_attach",(0,0,0),(0,0,0));
	var_06 setmodel(level.tanksettings[var_02].var_B922);
	var_06.health = level.tanksettings[var_02].health;
	var_06.triggerportableradarping = var_01;
	var_06.angles = var_01.angles;
	var_06.var_10955 = ::func_3758;
	var_06.var_114B1 = var_04;
	var_06 makeunusable();
	var_06 setdefaultdroppitch(0);
	var_06 setcandamage(0);
	var_04.var_10955 = ::func_3758;
	var_04.lifeid = var_03;
	var_04.team = var_01.team;
	var_04.triggerportableradarping = var_01;
	var_04 setotherent(var_01);
	var_04.mgturret = var_06;
	var_04.health = level.tanksettings[var_02].health;
	var_04.maxhealth = level.tanksettings[var_02].maxhealth;
	var_04.var_E1 = 0;
	var_04.var_52D0 = 0;
	var_04 setcandamage(0);
	var_04.tanktype = var_02;
	var_04 scripts\mp\sentientpoolmanager::registersentient("Killstreak_Ground",var_01,1);
	var_06 setturretmodechangewait(1);
	var_04 func_114CF();
	var_06 setsentryowner(var_01);
	var_01.using_remote_tank = 0;
	var_04.empgrenaded = 0;
	var_04.var_4D49 = 1;
	var_04 thread func_114C5();
	var_04 thread func_114D7();
	var_04 thread func_114BB();
	return var_04;
}

//Function Number: 22
func_114CC()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	level endon("game_ended");
	self makeunusable();
	self.mgturret getvalidlocation();
	self makevehiclesolidcapsule(23,23,23);
	if(!isdefined(self.triggerportableradarping))
	{
		return;
	}

	var_00 = self.triggerportableradarping;
	var_01 = (0,0,20);
	if(level.teambased)
	{
		self.team = var_00.team;
		self.mgturret.team = var_00.team;
		self.mgturret setturretteam(var_00.team);
		foreach(var_03 in level.players)
		{
			if(var_03 != var_00 && var_03.team == var_00.team)
			{
				var_04 = self.mgturret scripts\mp\_entityheadicons::setheadicon(var_03,scripts\mp\_teams::_meth_81B0(self.team),var_01,10,10,0,0.05,0,1,0,1);
				if(isdefined(var_04))
				{
					var_04 settargetent(self);
				}
			}
		}
	}

	thread func_114BF();
	thread func_114C0();
	thread func_114BC();
	thread func_114BE();
	thread func_114C1();
	thread func_114B2();
	thread func_114B3();
	func_10E09();
}

//Function Number: 23
func_10E09()
{
	var_00 = self.triggerportableradarping;
	var_00 scripts\mp\_utility::setusingremote(self.tanktype);
	if(getdvarint("camera_thirdPerson"))
	{
		var_00 scripts\mp\_utility::setthirdpersondof(0);
	}

	var_00.restoreangles = var_00.angles;
	var_00 scripts\mp\_utility::freezecontrolswrapper(1);
	var_01 = var_00 scripts\mp\killstreaks\_killstreaks::initridekillstreak("remote_tank");
	if(var_01 != "success")
	{
		if(var_01 != "disconnect")
		{
			var_00 scripts\mp\_utility::clearusingremote();
		}

		if(isdefined(var_00.disabledweapon) && var_00.disabledweapon)
		{
			var_00 scripts\engine\utility::allow_weapon(1);
		}

		self notify("death");
		return 0;
	}

	var_00 scripts\mp\_utility::freezecontrolswrapper(0);
	self.mgturret setcandamage(1);
	self setcandamage(1);
	var_02 = spawnstruct();
	var_02.playdeathfx = 1;
	var_02.deathoverridecallback = ::func_114C9;
	thread scripts\mp\_movers::handle_moving_platforms(var_02);
	var_00 remotecontrolvehicle(self);
	var_00 remotecontrolturret(self.mgturret);
	var_00 thread tank_watchfiring(self);
	var_00 thread func_114B9(self);
	thread func_114B7();
	thread func_114CA();
	var_00.using_remote_tank = 1;
	var_00 scripts\mp\_utility::_giveweapon(level.tanksettings[self.tanktype].remotedetonatethink);
	var_00 scripts\mp\_utility::_switchtoweaponimmediate(level.tanksettings[self.tanktype].remotedetonatethink);
	thread func_114BD();
	self.mgturret thread func_114D5();
}

//Function Number: 24
func_114B2()
{
	self endon("death");
	for(;;)
	{
		playfxontag(scripts\engine\utility::getfx("remote_tank_antenna_light_mp"),self.mgturret,"tag_headlight_right");
		wait(1);
		stopfxontag(scripts\engine\utility::getfx("remote_tank_antenna_light_mp"),self.mgturret,"tag_headlight_right");
	}
}

//Function Number: 25
func_114B3()
{
	self endon("death");
	for(;;)
	{
		playfxontag(scripts\engine\utility::getfx("remote_tank_camera_light_mp"),self.mgturret,"tag_tail_light_right");
		wait(2);
		stopfxontag(scripts\engine\utility::getfx("remote_tank_camera_light_mp"),self.mgturret,"tag_tail_light_right");
	}
}

//Function Number: 26
func_114CF()
{
	self.mgturret give_player_session_tokens(level.tanksettings[self.tanktype].sentrymodeoff);
	if(level.teambased)
	{
		scripts\mp\_entityheadicons::setteamheadicon("none",(0,0,0));
	}
	else if(isdefined(self.triggerportableradarping))
	{
		scripts\mp\_entityheadicons::setplayerheadicon(undefined,(0,0,0));
	}

	if(!isdefined(self.triggerportableradarping))
	{
		return;
	}

	var_00 = self.triggerportableradarping;
	if(isdefined(var_00.using_remote_tank) && var_00.using_remote_tank)
	{
		var_00 notify("end_remote");
		var_00 remotecontrolvehicleoff(self);
		var_00 geysers_and_boatride(self.mgturret);
		var_00 scripts\mp\_utility::_switchtoweapon(var_00 scripts\engine\utility::getlastweapon());
		var_00 scripts\mp\_utility::clearusingremote();
		var_00 setplayerangles(var_00.restoreangles);
		if(getdvarint("camera_thirdPerson"))
		{
			var_00 scripts\mp\_utility::setthirdpersondof(1);
		}

		if(isdefined(var_00.disabledusability) && var_00.disabledusability)
		{
			var_00 scripts\engine\utility::allow_usability(1);
		}

		var_00 func_1146D(level.tanksettings[self.tanktype].streakname);
		var_00.using_remote_tank = 0;
		var_00 thread func_114BA();
	}
}

//Function Number: 27
func_114BA()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	scripts\mp\_utility::freezecontrolswrapper(1);
	wait(0.5);
	scripts\mp\_utility::freezecontrolswrapper(0);
}

//Function Number: 28
func_114BF()
{
	self endon("death");
	self.triggerportableradarping waittill("disconnect");
	if(isdefined(self.mgturret))
	{
		self.mgturret notify("death");
	}

	self notify("death");
}

//Function Number: 29
func_114C0()
{
	self endon("death");
	self.triggerportableradarping waittill("stop_using_remote");
	self notify("death");
}

//Function Number: 30
func_114BC()
{
	self endon("death");
	self.triggerportableradarping scripts\engine\utility::waittill_any_3("joined_team","joined_spectators");
	self notify("death");
}

//Function Number: 31
func_114C1()
{
	self endon("death");
	var_00 = level.tanksettings[self.tanktype].timeout;
	scripts\mp\_hostmigration::waitlongdurationwithhostmigrationpause(var_00);
	self notify("death");
}

//Function Number: 32
func_114C9(param_00)
{
	self notify("death");
}

//Function Number: 33
func_114BE()
{
	level endon("game_ended");
	var_00 = self getentitynumber();
	addtougvlist(var_00);
	self waittill("death");
	self playsound("talon_destroyed");
	removefromugvlist(var_00);
	self setmodel(level.tanksettings[self.tanktype].modeldestroyed);
	if(isdefined(self.triggerportableradarping) && self.triggerportableradarping.using_remote_tank || self.triggerportableradarping scripts\mp\_utility::isusingremote())
	{
		func_114CF();
		self.triggerportableradarping.using_remote_tank = 0;
	}

	self.mgturret setdefaultdroppitch(40);
	self.mgturret setsentryowner(undefined);
	self playsound("sentry_explode");
	playfxontag(level._effect["remote_tank_dying"],self.mgturret,"tag_aim");
	wait(2);
	playfx(level._effect["remote_tank_explode"],self.origin);
	self.mgturret delete();
	scripts\mp\_utility::decrementfauxvehiclecount();
	self delete();
}

//Function Number: 34
func_3758(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09,param_0A,param_0B)
{
	var_0C = self;
	if(isdefined(self.var_114B1))
	{
		var_0C = self.var_114B1;
	}

	if(isdefined(var_0C.var_1D41) && var_0C.var_1D41)
	{
		return;
	}

	if(!scripts\mp\_weapons::friendlyfirecheck(var_0C.triggerportableradarping,param_01))
	{
		return;
	}

	if(isdefined(param_03) && param_03 & level.idflags_penetration)
	{
		var_0C.wasdamagedfrombulletpenetration = 1;
	}

	if(isdefined(param_03) && param_03 & level.idflags_ricochet)
	{
		var_0C.wasdamagedfrombulletricochet = 1;
	}

	var_0C.wasdamaged = 1;
	var_0C.var_4D49 = 0;
	playfxontagforclients(level._effect["remote_tank_spark"],var_0C,"tag_player",var_0C.triggerportableradarping);
	if(isdefined(param_05))
	{
		switch(param_05)
		{
			case "stealth_bomb_mp":
			case "artillery_mp":
				param_02 = param_02 * 4;
				break;
		}
	}

	if(param_04 == "MOD_MELEE")
	{
		param_02 = var_0C.maxhealth * 0.5;
	}

	var_0D = param_02;
	if(isplayer(param_01))
	{
		param_01 scripts\mp\_damagefeedback::updatedamagefeedback("remote_tank");
		if(param_04 == "MOD_RIFLE_BULLET" || param_04 == "MOD_PISTOL_BULLET")
		{
			if(param_01 scripts\mp\_utility::_hasperk("specialty_armorpiercing"))
			{
				var_0D = var_0D + param_02 * level.armorpiercingmod;
			}
		}

		if(function_0107(param_04))
		{
			var_0D = var_0D + param_02;
		}
	}

	if(function_0107(param_04) && isdefined(param_05) && param_05 == "destructible_car")
	{
		var_0D = var_0C.maxhealth;
	}

	if(isdefined(param_01.triggerportableradarping) && isplayer(param_01.triggerportableradarping))
	{
		param_01.triggerportableradarping scripts\mp\_damagefeedback::updatedamagefeedback("remote_tank");
	}

	if(isdefined(param_05))
	{
		switch(param_05)
		{
			case "remotemissile_projectile_mp":
			case "javelin_mp":
			case "remote_mortar_missile_mp":
			case "stinger_mp":
			case "ac130_40mm_mp":
			case "ac130_105mm_mp":
				var_0C.largeprojectiledamage = 1;
				var_0D = var_0C.maxhealth + 1;
				break;

			case "stealth_bomb_mp":
			case "artillery_mp":
				var_0C.largeprojectiledamage = 0;
				var_0D = var_0C.maxhealth * 0.5;
				break;

			case "bomb_site_mp":
				var_0C.largeprojectiledamage = 0;
				var_0D = var_0C.maxhealth + 1;
				break;

			case "emp_grenade_mp":
				var_0D = 0;
				var_0C thread func_114B8();
				break;

			case "ims_projectile_mp":
				var_0C.largeprojectiledamage = 1;
				var_0D = var_0C.maxhealth * 0.5;
				break;
		}

		scripts\mp\killstreaks\_killstreaks::killstreakhit(param_01,param_05,self);
	}

	var_0C.var_E1 = var_0C.var_E1 + var_0D;
	var_0C playsound("talon_damaged");
	if(var_0C.var_E1 >= var_0C.maxhealth)
	{
		if(isplayer(param_01) && !isdefined(var_0C.triggerportableradarping) || param_01 != var_0C.triggerportableradarping)
		{
			var_0C.var_1D41 = 1;
			param_01 notify("destroyed_killstreak",param_05);
			thread scripts\mp\_utility::teamplayercardsplash("callout_destroyed_remote_tank",param_01);
			param_01 thread scripts\mp\_utility::giveunifiedpoints("kill",param_05,300);
		}

		var_0C notify("death");
	}
}

//Function Number: 35
func_114B8()
{
	self notify("tank_EMPGrenaded");
	self endon("tank_EMPGrenaded");
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	level endon("game_ended");
	self.empgrenaded = 1;
	self.mgturret turretfiredisable();
	wait(3.5);
	self.empgrenaded = 0;
	self.mgturret turretfireenable();
}

//Function Number: 36
func_114C5()
{
	self endon("death");
	level endon("game_ended");
	var_00 = 0;
	for(;;)
	{
		if(!self.empgrenaded)
		{
			if(self.var_4D49 < 1)
			{
				self.var_4D49 = self.var_4D49 + 0.1;
				var_00 = 1;
			}
			else if(var_00)
			{
				self.var_4D49 = 1;
				var_00 = 0;
			}
		}

		wait(0.1);
	}
}

//Function Number: 37
func_114D7()
{
	self endon("death");
	level endon("game_ended");
	var_00 = 0.1;
	var_01 = 1;
	var_02 = 1;
	for(;;)
	{
		if(var_02)
		{
			if(self.var_E1 > 0)
			{
				var_02 = 0;
				var_01++;
			}
		}
		else if(self.var_E1 >= self.maxhealth * var_00 * var_01)
		{
			var_01++;
		}

		wait(0.05);
	}
}

//Function Number: 38
func_114BD()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("damage",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
		if(isdefined(self.var_10955))
		{
			self [[ self.var_10955 ]](undefined,var_01,var_00,var_08,var_04,var_09,var_03,var_02,undefined,undefined,var_05,var_07);
		}
	}
}

//Function Number: 39
func_114D5()
{
	self endon("death");
	level endon("game_ended");
	for(;;)
	{
		self waittill("damage",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08,var_09);
		if(isdefined(self.var_10955) && isdefined(self.var_114B1) && !function_0107(var_04) || isdefined(var_09) && function_0107(var_04) && var_09 == "stealth_bomb_mp" || var_09 == "artillery_mp")
		{
			self.var_114B1 [[ self.var_10955 ]](undefined,var_01,var_00,var_08,var_04,var_09,var_03,var_02,undefined,undefined,var_05,var_07);
		}
	}
}

//Function Number: 40
tank_watchfiring(param_00)
{
	self endon("disconnect");
	self endon("end_remote");
	param_00 endon("death");
	var_01 = 50;
	var_02 = var_01;
	var_03 = function_0240(level.tanksettings[param_00.tanktype].mgturretinfo);
	for(;;)
	{
		if(param_00.mgturret isfiringvehicleturret())
		{
			var_02--;
			if(var_02 <= 0)
			{
				param_00.mgturret turretfiredisable();
				wait(2.5);
				param_00 playsound("talon_reload");
				self playlocalsound("talon_reload_plr");
				var_02 = var_01;
				param_00.mgturret turretfireenable();
			}
		}

		wait(var_03);
	}
}

//Function Number: 41
func_114B9(param_00)
{
	self endon("disconnect");
	self endon("end_remote");
	level endon("game_ended");
	param_00 endon("death");
	var_01 = 0;
	for(;;)
	{
		if(self fragbuttonpressed() && !param_00.empgrenaded)
		{
			var_02 = param_00.mgturret.origin;
			var_03 = param_00.mgturret.angles;
			switch(var_01)
			{
				case 0:
					var_02 = param_00.mgturret gettagorigin("tag_missile1");
					var_03 = param_00.mgturret gettagangles("tag_player");
					break;
	
				case 1:
					var_02 = param_00.mgturret gettagorigin("tag_missile2");
					var_03 = param_00.mgturret gettagangles("tag_player");
					break;
			}

			param_00 playsound("talon_missile_fire");
			self playlocalsound("talon_missile_fire_plr");
			var_04 = var_02 + anglestoforward(var_03) * 100;
			var_05 = scripts\mp\_utility::_magicbullet(level.tanksettings[param_00.tanktype].var_B88D,var_02,var_04,self);
			var_01 = var_01 + 1 % 2;
			wait(5);
			param_00 playsound("talon_rocket_reload");
			self playlocalsound("talon_rocket_reload_plr");
			continue;
		}

		wait(0.05);
	}
}

//Function Number: 42
func_114B6(param_00)
{
	self endon("disconnect");
	self endon("end_remote");
	level endon("game_ended");
	param_00 endon("death");
	for(;;)
	{
		if(self secondaryoffhandbuttonpressed())
		{
			var_01 = bullettrace(param_00.origin + (0,0,4),param_00.origin - (0,0,4),0,param_00);
			var_02 = vectornormalize(var_01["normal"]);
			var_03 = vectortoangles(var_02);
			var_03 = var_03 + (90,0,0);
			var_04 = scripts\mp\_weapons::spawnmine(param_00.origin,self,"equipment",var_03);
			param_00 playsound("item_blast_shield_on");
			wait(8);
			continue;
		}

		wait(0.05);
	}
}

//Function Number: 43
func_114B7()
{
	self endon("death");
	self.triggerportableradarping endon("end_remote");
	for(;;)
	{
		earthquake(0.1,0.25,self.mgturret gettagorigin("tag_player"),50);
		wait(0.25);
	}
}

//Function Number: 44
addtougvlist(param_00)
{
	level.ugvs[param_00] = self;
}

//Function Number: 45
removefromugvlist(param_00)
{
	level.ugvs[param_00] = undefined;
}

//Function Number: 46
func_114CA()
{
	if(!isdefined(self.triggerportableradarping))
	{
		return;
	}

	var_00 = self.triggerportableradarping;
	level endon("game_ended");
	var_00 endon("disconnect");
	var_00 endon("end_remote");
	self endon("death");
	for(;;)
	{
		var_01 = 0;
		while(var_00 usebuttonpressed())
		{
			var_01 = var_01 + 0.05;
			if(var_01 > 0.75)
			{
				self notify("death");
				return;
			}

			wait(0.05);
		}

		wait(0.05);
	}
}
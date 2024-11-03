/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3118.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 69
 * Decompile Time: 14 ms
 * Timestamp: 10/27/2023 12:26:09 AM
*******************************************************************/

//Function Number: 1
zombiegreymayshoot(param_00)
{
	if(!isdefined(self.var_394))
	{
		return level.failure;
	}

	if(isdefined(self.dontevershoot) && self.dontevershoot)
	{
		return level.failure;
	}

	if(!shouldshoot())
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 2
shouldshoot()
{
	if(isdefined(self.dontevershoot) && self.dontevershoot)
	{
		return 0;
	}

	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(self.bulletsinclip == 0)
	{
		return 0;
	}

	if(self getpersstat(self.isnodeoccupied))
	{
		scripts\anim\utility_common::dontgiveuponsuppressionyet();
		self.goodshootpos = self.isnodeoccupied getshootatpos();
		return 1;
	}

	return 0;
}

//Function Number: 3
zombiegreyshouldmelee(param_00)
{
	if(!isgreymeleeallowed())
	{
		return level.failure;
	}

	if(![[ self.fnismeleevalid ]](self.isnodeoccupied,1))
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 4
isgreymeleeallowed(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = self.isnodeoccupied;
	}

	if(isdefined(self.dontmelee))
	{
		return 0;
	}

	if(isdefined(self.bt.cannotmelee))
	{
		return 0;
	}

	if(!isdefined(param_00))
	{
		return 0;
	}

	if(isdefined(param_00.dontmelee))
	{
		return 0;
	}

	if(isdefined(self._stealth) && !scripts/aitypes/melee::canmeleeduringstealth())
	{
		return 0;
	}

	if(gettime() < self.next_melee_time)
	{
		return 0;
	}

	return 1;
}

//Function Number: 5
zombiegreyinitmelee(param_00)
{
	self.acceptablemeleefraction = 0.95;
	self.fnismeleevalid = ::ismeleevalid;
	self.fnmeleecharge_init = ::meleecharge_init_mp;
	self.fnmeleecharge_terminate = ::meleecharge_terminate_mp;
	self.fnmeleevsplayer_init = ::meleevsplayer_init_mp;
	self.fnmeleevsplayer_terminate = ::meleevsplayer_terminate_mp;
	self.fncanmovefrompointtopoint = ::canmovefrompointtopoint;
	set_next_melee_time(self);
	return level.success;
}

//Function Number: 6
zombiegreyinitteleporttoloner(param_00)
{
	set_can_do_teleport_to_loner(self,0);
	set_next_teleport_to_loner_time(self);
	return level.success;
}

//Function Number: 7
zombiegreyinitteleportattack(param_00)
{
	set_can_do_teleport_attack(self,0);
	set_next_teleport_attack_time(self);
	reset_recent_damage_data(self);
	return level.success;
}

//Function Number: 8
zombiegreyinitteleportsummon(param_00)
{
	set_can_do_teleport_summon(self,1);
	set_next_teleport_summon_time(self);
	return level.success;
}

//Function Number: 9
zombiegreyinitteleportdash(param_00)
{
	set_can_do_teleport_dash(self,1);
	set_next_teleport_dash_time(self);
	return level.success;
}

//Function Number: 10
zombiegreyinitduplicatingattack(param_00)
{
	self.can_do_duplicating_attack = 0;
	self.trigger_clone_health = self.maxhealth * 0.33;
	return level.success;
}

//Function Number: 11
zombiegreyinithealthregen(param_00)
{
	self.activate_health_regen_threshold = int(self.health * 0.2);
	self.current_max_health_regen_level = self.maxhealth;
	self.max_health_regen_level_penalty = int(self.maxhealth * 0.33);
	self.min_health_regen_level = int(self.maxhealth * 0.33);
	self.health_regen_minimum = 0;
	self.can_do_health_regen = 1;
	var_01 = self.maxhealth - self.activate_health_regen_threshold;
	var_02 = 120;
	self.health_addition_per_regen_segement = int(var_01 / var_02);
	return level.success;
}

//Function Number: 12
zombiegreyshouldduplicatingattack(param_00)
{
	if(!self.can_do_duplicating_attack)
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.i_am_clone))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.is_regening_health))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_attack))
	{
		return level.failure;
	}

	if(self.health < self.trigger_clone_health)
	{
		setduplicatingattackdata(self,max(level.players.size,2));
		return level.success;
	}

	return level.failure;
}

//Function Number: 13
setduplicatingattackdata(param_00,param_01)
{
	param_00 setscriptablepartstate("health_light","no_light");
	scripts/asm/zombie_grey/zombie_grey_asm::set_grey_clone(param_00);
	param_00.doing_duplicating_attack = 1;
	param_00.num_of_clones = param_01;
	level.clone_health = int(param_00.maxhealth / param_01);
	level.damage_to_clones = 0;
}

//Function Number: 14
zombiegreydoduplicatingattack(param_00)
{
	if(scripts\engine\utility::istrue(self.doing_duplicating_attack))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 15
zombiegreyshouldteleportattack(param_00)
{
	if(!scripts\engine\utility::istrue(self.can_do_teleport_attack))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.i_am_clone))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.is_regening_health))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_summon))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_dash))
	{
		return level.failure;
	}

	if(isdefined(self.teleport_loner_target_player))
	{
		return level.failure;
	}

	var_01 = gettime();
	if(var_01 < self.next_teleport_time)
	{
		return level.failure;
	}

	if(var_01 < self.next_teleport_attack_time)
	{
		return level.failure;
	}

	if(var_01 < self.next_check_recent_damage_time)
	{
		return level.failure;
	}

	if(!meet_recent_damage_threshold_check(self))
	{
		reset_recent_damage_data(self);
		return level.failure;
	}

	reset_recent_damage_data(self);
	self.doing_teleport_attack = 1;
	return level.success;
}

//Function Number: 16
zombiegreyshouldteleportsummon(param_00)
{
	if(!scripts\engine\utility::istrue(self.can_do_teleport_summon))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.i_am_clone))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_attack))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_dash))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.is_regening_health))
	{
		return level.failure;
	}

	if(isdefined(self.teleport_loner_target_player))
	{
		return level.failure;
	}

	var_01 = gettime();
	if(var_01 < self.next_teleport_time)
	{
		return level.failure;
	}

	if(var_01 < self.next_teleport_summon_time)
	{
		return level.failure;
	}

	self.doing_teleport_summon = 1;
	return level.success;
}

//Function Number: 17
zombiegreyshouldteleportdash(param_00)
{
	if(!scripts\engine\utility::istrue(self.can_do_teleport_dash))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.i_am_clone))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_attack))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_summon))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.is_regening_health))
	{
		return level.failure;
	}

	if(isdefined(self.teleport_loner_target_player))
	{
		return level.failure;
	}

	var_01 = gettime();
	if(var_01 < self.next_teleport_time)
	{
		return level.failure;
	}

	if(var_01 < self.next_teleport_dash_time)
	{
		return level.failure;
	}

	if(isdefined(self.target_player) && distancesquared(self.origin,self.target_player.origin) > 1000000)
	{
		return level.failure;
	}

	self.doing_teleport_dash = 1;
	return level.success;
}

//Function Number: 18
zombiegreydoteleportattack(param_00)
{
	if(scripts\engine\utility::istrue(self.doing_teleport_attack))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 19
zombiegreydoteleportsummon(param_00)
{
	if(scripts\engine\utility::istrue(self.doing_teleport_summon))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 20
zombiegreydoteleportdash(param_00)
{
	if(scripts\engine\utility::istrue(self.doing_teleport_dash))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 21
zombiegreyshouldteleporttoloner(param_00)
{
	if(!scripts\engine\utility::istrue(self.can_do_teleport_to_loner))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.i_am_clone))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.is_regening_health))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.doing_teleport_attack))
	{
		return level.failure;
	}

	var_01 = gettime();
	if(var_01 < self.next_teleport_to_loner_time)
	{
		return level.failure;
	}

	var_02 = getteleportlonertargetplayer(self);
	if(isdefined(var_02))
	{
		self.teleport_loner_target_player = var_02;
		set_next_teleport_to_loner_time(self);
		return level.success;
	}

	return level.failure;
}

//Function Number: 22
zombiegreydoteleporttoloner(param_00)
{
	if(isdefined(self.teleport_loner_target_player))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 23
getteleportlonertargetplayer(param_00)
{
	var_01 = [];
	foreach(var_03 in level.players)
	{
		if(!isdefined(var_03.num_teleport_loner_encountered))
		{
			var_03.num_teleport_loner_encountered = 0;
		}

		if(distancesquared(param_00.origin,var_03.origin) < 250000)
		{
			continue;
		}

		if(scripts\cp\cp_laststand::player_in_laststand(var_03))
		{
			continue;
		}

		var_01[var_01.size] = var_03;
	}

	if(var_01.size == 0)
	{
		return undefined;
	}

	var_05 = undefined;
	var_06 = 999;
	foreach(var_03 in var_01)
	{
		if(var_03.num_teleport_loner_encountered < var_06)
		{
			var_06 = var_03.num_teleport_loner_encountered;
			var_05 = var_03;
		}
	}

	var_05.var_C205++;
	return var_05;
}

//Function Number: 24
zombiegreycheckhealthregen(param_00)
{
	if(scripts\engine\utility::istrue(self.i_am_clone))
	{
		return level.failure;
	}

	if(scripts\engine\utility::istrue(self.is_regening_health))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 25
zombiegreyassigntargetplayer(param_00)
{
	if(isdefined(self.favorite_target_player) && !scripts\cp\cp_laststand::player_in_laststand(self.favorite_target_player))
	{
		assigntargetplayer(self,self.favorite_target_player);
		return level.failure;
	}
	else
	{
		var_01 = level.players;
		var_01 = scripts\engine\utility::array_remove(var_01,self.favorite_target_player);
		var_01 = scripts\engine\utility::array_randomize(var_01);
		foreach(var_03 in var_01)
		{
			if(isdefined(var_03) && !scripts\cp\cp_laststand::player_in_laststand(var_03))
			{
				assigntargetplayer(self,var_03);
				return level.failure;
			}

			assigntargetplayer(self,self.favorite_target_player);
			return level.failure;
		}
	}

	return level.failure;
}

//Function Number: 26
assigntargetplayer(param_00,param_01)
{
	param_00.target_player = param_01;
}

//Function Number: 27
ismeleevalid(param_00,param_01)
{
	if(distancesquared(self.origin,param_00.origin) > self.meleerangesq)
	{
		return 0;
	}

	if(scripts/asm/asm_bb::bb_ismissingaleg())
	{
		return 0;
	}

	if(!scripts/aitypes/melee::ismeleevalid_common(param_00,param_01))
	{
		return 0;
	}

	var_02 = scripts/aitypes/melee::gettargetchargepos(param_00);
	if(!isdefined(var_02))
	{
		return 0;
	}

	if(!canmovefrompointtopoint(self.origin,var_02))
	{
		return 0;
	}

	return 1;
}

//Function Number: 28
meleecharge_init_mp(param_00)
{
	self scragentsetscripted(1);
}

//Function Number: 29
meleecharge_terminate_mp(param_00)
{
	self scragentsetscripted(0);
}

//Function Number: 30
meleevsplayer_init_mp(param_00)
{
	self scragentsetscripted(1);
}

//Function Number: 31
meleevsplayer_terminate_mp(param_00)
{
	self scragentsetscripted(0);
}

//Function Number: 32
canmovefrompointtopoint(param_00,param_01)
{
	var_02 = navtrace(param_00,param_01,self,1);
	var_03 = var_02["fraction"];
	if(var_03 >= self.acceptablemeleefraction)
	{
		var_04 = 0;
	}
	else
	{
		var_04 = 1;
	}

	return !var_04;
}

//Function Number: 33
zombiegreyhasweapon(param_00)
{
	if(isdefined(self.var_394))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 34
is_vector_in_front_cone_of_grey(param_00,param_01)
{
	var_02 = anglestoforward(param_01.angles);
	var_02 = (var_02[0],var_02[1],0);
	return vectordot(param_00,var_02) > 0.5;
}

//Function Number: 35
try_regen_health(param_00)
{
	if(!can_regen_health(param_00))
	{
		return;
	}

	param_00 thread regen_health_sequence(param_00);
}

//Function Number: 36
can_regen_health(param_00)
{
	if(!scripts\engine\utility::istrue(param_00.can_do_health_regen))
	{
		return 0;
	}

	if(param_00.health > param_00.activate_health_regen_threshold)
	{
		return 0;
	}

	if(isdefined(level.last_health_regen_time) && gettime() - level.last_health_regen_time < 50)
	{
		return 0;
	}

	if(scripts\engine\utility::istrue(param_00.i_am_clone))
	{
		return 0;
	}

	return 1;
}

//Function Number: 37
regen_health_sequence(param_00)
{
	param_00 endon("death");
	param_00.alien_fuse_exposed = undefined;
	param_00.is_regening_health = 1;
	param_00 notify("update_mobile_shield_visibility",0);
	param_00 waittill("grey play regen");
	regen_health_internal(param_00);
}

//Function Number: 38
regen_health_internal(param_00)
{
	level.last_health_regen_time = gettime();
	param_00.should_shock_wave = 0;
	param_00.alien_fuse_exposed = scripts\engine\utility::random(param_00.available_fuse);
	if(isdefined(level.pre_grey_regen_func))
	{
		[[ level.pre_grey_regen_func ]](param_00);
	}

	scripts/asm/zombie_grey/zombie_grey_asm::drop_max_ammo();
	param_00.health = param_00.maxhealth;
	param_00 notify("update_health_light");
	var_01 = scripts\engine\utility::waittill_any_timeout_1(6,"stop_regen_health");
	if(var_01 == "stop_regen_health")
	{
		process_stop_regen_health_action(param_00);
		param_00.should_shock_wave = 1;
		if(isdefined(level.greygetmeleedamagedfunc))
		{
			[[ level.greygetmeleedamagedfunc ]](param_00.melee_attacker,param_00.alien_fuse_exposed);
		}
	}

	param_00.is_regening_health = 0;
	param_00.actually_doing_regen = 0;
	if(isdefined(level.post_grey_regen_func))
	{
		[[ level.post_grey_regen_func ]]();
	}
}

//Function Number: 39
process_stop_regen_health_action(param_00)
{
	if(!isdefined(param_00.num_of_times_stop_regen_health))
	{
		param_00.num_of_times_stop_regen_health = 0;
	}

	param_00.var_C1FA++;
	if(param_00.num_of_times_stop_regen_health == 1)
	{
		param_00.health_regen_minimum = int(param_00.maxhealth * 0.33);
		param_00.should_regen_summon = 1;
		return;
	}

	if(param_00.num_of_times_stop_regen_health >= 2)
	{
		param_00.can_do_health_regen = 0;
	}
}

//Function Number: 40
meet_recent_damage_threshold_check(param_00)
{
	if(param_00.sum_of_recent_damage > 500)
	{
		return 1;
	}

	if(param_00.recent_player_attackers.size >= 2)
	{
		return 1;
	}

	return 0;
}

//Function Number: 41
get_recent_damage_amount_threshold()
{
	return 500;
}

//Function Number: 42
reset_recent_damage_data(param_00)
{
	param_00.next_check_recent_damage_time = gettime() + 1000;
	param_00.sum_of_recent_damage = 0;
	param_00.recent_player_attackers = [];
}

//Function Number: 43
set_next_teleport_attack_time(param_00)
{
	param_00.next_teleport_attack_time = gettime() + randomintrange(2000,5000);
	set_next_teleport_time(param_00);
}

//Function Number: 44
set_next_teleport_summon_time(param_00)
{
	param_00.next_teleport_summon_time = gettime() + randomintrange(12000,15000);
	set_next_teleport_time(param_00);
}

//Function Number: 45
set_next_teleport_dash_time(param_00)
{
	param_00.next_teleport_dash_time = gettime() + randomintrange(6000,9000);
	set_next_teleport_time(param_00);
}

//Function Number: 46
set_next_melee_time(param_00)
{
	var_01 = 3;
	if(scripts\cp\zombies\direct_boss_fight::should_directly_go_to_boss_fight())
	{
		var_01 = 0.5;
	}

	param_00.next_melee_time = gettime() + var_01 * 1000;
}

//Function Number: 47
set_next_teleport_time(param_00)
{
	param_00.next_teleport_time = gettime() + randomintrange(2000,3000);
}

//Function Number: 48
set_next_teleport_to_loner_time(param_00)
{
	param_00.next_teleport_to_loner_time = gettime() + randomintrange(12000,18000);
}

//Function Number: 49
greymeleevsplayer_init(param_00)
{
	melee_init(param_00);
	if(isdefined(self.fnmeleevsplayer_init))
	{
		self [[ self.fnmeleevsplayer_init ]](param_00);
	}

	thread scripts/aitypes/melee::meleedeathhandler(self.isnodeoccupied);
}

//Function Number: 50
melee_init(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = self.isnodeoccupied;
	}

	if(isdefined(self.melee))
	{
		scripts/aitypes/melee::melee_destroy();
	}

	scripts/asm/asm_bb::bb_setmeleetarget(param_01);
	self.melee.taskid = param_00;
	param_01.melee.taskid = param_00;
	return level.success;
}

//Function Number: 51
greymeleevsplayer_update(param_00)
{
	return scripts/aitypes/melee::meleevsplayer_update(param_00);
}

//Function Number: 52
greymeleevsplayer_terminate(param_00)
{
	scripts/aitypes/melee::meleevsplayer_terminate(param_00);
}

//Function Number: 53
set_can_do_teleport_attack(param_00,param_01)
{
	param_00.can_do_teleport_attack = param_01;
}

//Function Number: 54
set_can_do_teleport_summon(param_00,param_01)
{
	param_00.can_do_teleport_summon = param_01;
}

//Function Number: 55
set_can_do_teleport_dash(param_00,param_01)
{
	param_00.can_do_teleport_dash = param_01;
}

//Function Number: 56
set_can_do_teleport_to_loner(param_00,param_01)
{
	param_00.can_do_teleport_to_loner = param_01;
}

//Function Number: 57
deactivate_mobile_shields(param_00)
{
	foreach(var_02 in param_00.mobile_shields)
	{
		var_02 delete();
	}

	param_00.mobile_shields = undefined;
}

//Function Number: 58
activate_mobile_shields(param_00)
{
	param_00 endon("death");
	level endon("game_ended");
	param_00 waittill("shockwave_deploy");
	param_00.mobile_shields = [];
	foreach(var_03, var_02 in level.players)
	{
		activate_mobile_shield_designated_for(var_02,param_00,80 + var_03 * 20);
	}
}

//Function Number: 59
activate_mobile_shield_designated_for(param_00,param_01,param_02)
{
	var_03 = calculate_mobile_shield_pos(param_00,param_01,param_02);
	var_04 = spawnhelicopter(level.players[0],var_03.mobile_shield_pos,vectortoangles(var_03.mobile_shield_face_dir),"zombie_grey_shield","zmb_temp_grey_shield_des");
	var_04 getvalidpointtopointmovelocation(1);
	var_04 vehicle_setspeed(100,200,200);
	var_04 setturningability(1);
	var_04 setneargoalnotifydist(10);
	var_04 sethoverparams(1,0,0);
	var_04 givelastonteamwarning(360,360);
	var_05 = spawn("script_model",var_03.mobile_shield_look_at_pos);
	var_04 setlookatent(var_05);
	var_04.mobile_shield_look_at_ent = var_05;
	var_04.distance_from_grey = param_02;
	var_04.designated_player = param_00;
	var_04.in_delay_update_next_hide_time = 0;
	var_04 thread mobile_shield_clean_up_monitor(param_01,var_04);
	var_04 thread mobile_shield_damage_monitor(var_04);
	var_04 thread mobile_shield_update_pos(var_04,param_00,param_01);
	var_04 thread mobile_shield_visibility_monitor(param_01,var_04);
	var_05 thread mobile_shield_look_at_ent_clean_up_monitor(var_04,var_05);
	param_01.mobile_shields[param_01.mobile_shields.size] = var_04;
}

//Function Number: 60
calculate_mobile_shield_pos(param_00,param_01,param_02)
{
	var_03 = param_01.origin + (0,0,45);
	var_04 = vectornormalize(param_00 geteye() - var_03);
	var_05 = spawnstruct();
	var_05.mobile_shield_pos = var_03 + var_04 * param_02;
	var_05.mobile_shield_look_at_pos = var_05.mobile_shield_pos + var_04 * 10;
	var_05.mobile_shield_face_dir = var_04;
	return var_05;
}

//Function Number: 61
mobile_shield_clean_up_monitor(param_00,param_01)
{
	param_01 endon("death");
	param_00 waittill("death");
	param_01 delete();
}

//Function Number: 62
mobile_shield_look_at_ent_clean_up_monitor(param_00,param_01)
{
	param_00 waittill("death");
	param_01 delete();
}

//Function Number: 63
mobile_shield_update_pos(param_00,param_01,param_02)
{
	param_00 endon("death");
	param_02 endon("death");
	param_01 endon("disconnect");
	for(;;)
	{
		var_03 = calculate_mobile_shield_pos(param_01,param_02,param_00.distance_from_grey);
		param_00 setvehgoalpos(var_03.mobile_shield_pos,1);
		param_00.mobile_shield_look_at_ent.origin = var_03.mobile_shield_look_at_pos;
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 64
mobile_shield_visibility_monitor(param_00,param_01)
{
	param_00 endon("death");
	param_01 endon("death");
	update_next_hide_time(param_01,5);
	for(;;)
	{
		var_02 = check_is_in_front_of(param_01,param_00);
		if(var_02 && scripts\engine\utility::istrue(param_00.is_shooting))
		{
			param_01 hide();
		}
		else
		{
			var_03 = gettime();
			if(var_03 < param_01.next_hide_time)
			{
				param_01 show();
			}
			else
			{
				param_01 hide();
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 65
check_is_in_front_of(param_00,param_01)
{
	var_02 = param_00.origin - param_01.origin;
	var_02 = (var_02[0],var_02[1],0);
	var_02 = vectornormalize(var_02);
	var_03 = anglestoforward(param_01.angles);
	return vectordot(var_02,var_03) > 0.525;
}

//Function Number: 66
update_next_hide_time(param_00,param_01)
{
	param_00.next_hide_time = gettime() + param_01 * 1000;
}

//Function Number: 67
mobile_shield_damage_monitor(param_00)
{
	param_00 endon("death");
	param_00 setcandamage(1);
	param_00.health = 99999999;
	for(;;)
	{
		param_00 waittill("damage",var_01);
		param_00.health = param_00.health + var_01;
		update_next_hide_time(param_00,2);
	}
}

//Function Number: 68
try_update_mobile_shield(param_00,param_01)
{
	if(!isdefined(param_01) && isplayer(param_01))
	{
		return;
	}

	if(!isdefined(param_00.mobile_shields))
	{
		return;
	}

	foreach(var_03 in param_00.mobile_shields)
	{
		if(var_03.designated_player == param_01)
		{
			var_03 thread delay_update_next_hide_time(var_03);
		}
	}
}

//Function Number: 69
delay_update_next_hide_time(param_00)
{
	param_00 endon("death");
	if(scripts\engine\utility::istrue(param_00.in_delay_update_next_hide_time))
	{
		return;
	}

	param_00.in_delay_update_next_hide_time = 1;
	wait(1.5);
	update_next_hide_time(param_00,3);
	param_00.in_delay_update_next_hide_time = 0;
}
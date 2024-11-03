/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\aitypes\crab_mini\behaviors.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 26
 * Decompile Time: 1048 ms
 * Timestamp: 10\26\2023 11:58:34 PM
*******************************************************************/

//Function Number: 1
initbehaviors(param_00)
{
	setupbehaviorstates();
	self.desiredaction = undefined;
	self.lastenemyengagetime = 0;
	self.myenemy = undefined;
	scripts\asm\asm_bb::bb_requestmovetype("sprint");
	return level.success;
}

//Function Number: 2
setupbehaviorstates()
{
	scripts\aitypes\dlc3\bt_action_api::setupbtaction("stand_melee",::melee_begin,::melee_tick,::melee_end);
	scripts\aitypes\dlc3\bt_action_api::setupbtaction("moving_melee",::movingmelee_begin,::movingmelee_tick,::movingmelee_end);
	scripts\aitypes\dlc3\bt_action_api::setupbtaction("stuck",::stuck_begin,::stuck_tick,::stuck_end);
}

//Function Number: 3
pickbetterenemy(param_00,param_01)
{
	var_02 = self getpersstat(param_00);
	var_03 = self getpersstat(param_01);
	if(var_02 != var_03)
	{
		if(var_02)
		{
			return param_00;
		}

		return param_01;
	}

	var_04 = distancesquared(self.origin,param_00.origin);
	var_05 = distancesquared(self.origin,param_01.origin);
	if(var_04 < var_05)
	{
		return param_00;
	}

	return param_01;
}

//Function Number: 4
shouldignoreenemy(param_00)
{
	if(!isalive(param_00))
	{
		return 1;
	}

	if(param_00.ignoreme || isdefined(param_00.triggerportableradarping) && param_00.var_222.ignoreme)
	{
		return 1;
	}

	if(scripts\mp\agents\zombie\zombie_util::shouldignoreent(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
updateenemy()
{
	if(isdefined(self.myenemy) && !shouldignoreenemy(self.myenemy))
	{
		if(gettime() - self.myenemystarttime < 3000)
		{
			return self.myenemy;
		}
	}

	var_00 = undefined;
	foreach(var_02 in level.players)
	{
		if(shouldignoreenemy(var_02))
		{
			continue;
		}

		if(scripts\common\utility::istrue(var_02.isfasttravelling))
		{
			continue;
		}

		if(!isdefined(var_00))
		{
			var_00 = var_02;
			continue;
		}

		var_00 = pickbetterenemy(var_00,var_02);
	}

	if(!isdefined(var_00))
	{
		self.myenemy = undefined;
		return undefined;
	}

	if(!isdefined(self.myenemy) || var_00 != self.myenemy)
	{
		self.myenemy = var_00;
		self.myenemystarttime = gettime();
	}
}

//Function Number: 6
updateeveryframe(param_00)
{
	updateenemy();
	return level.failure;
}

//Function Number: 7
stuck_begin(param_00)
{
	var_01 = scripts\mp\agents\crab_mini\crab_mini_tunedata::gettunedata();
	var_02 = randomintrange(var_01.stuck_min_time_ms,var_01.stuck_max_time_ms);
	scripts\aitypes\dlc3\bt_state_api::asm_wait_state_setup(param_00,"stuck","stuck_loop",::stuck_stopbeingstuck,undefined,var_02);
	scripts\aitypes\dlc3\bt_state_api::btstate_transitionstate(param_00,"stuck");
}

//Function Number: 8
stuck_tick(param_00)
{
	if(scripts\aitypes\dlc3\bt_state_api::btstate_tickstates(param_00))
	{
		return level.running;
	}

	return level.success;
}

//Function Number: 9
stuck_end(param_00)
{
	scripts\mp\agents\crab_mini\crab_mini_agent::setisstuck(undefined);
	scripts\asm\crab_mini\crab_mini_asm::clearaction();
}

//Function Number: 10
stuck_stopbeingstuck(param_00,param_01)
{
	scripts\mp\agents\crab_mini\crab_mini_agent::setisstuck(undefined);
	scripts\aitypes\dlc3\bt_state_api::asm_wait_state_setup(param_00,"stuck_done","stuck_exit",::stuck_decideturn);
	scripts\aitypes\dlc3\bt_state_api::btstate_transitionstate(param_00,"stuck_done");
	return 1;
}

//Function Number: 11
facepoint(param_00,param_01)
{
	var_02 = scripts\common\utility::getyawtospot(param_01);
	if(abs(var_02) < 22.5)
	{
		return;
	}

	self.desiredyaw = var_02;
}

//Function Number: 12
stuck_decideturn(param_00,param_01)
{
	var_02 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	if(!isdefined(var_02))
	{
		return 0;
	}

	var_03 = distancesquared(self.origin,var_02.origin);
	var_04 = scripts\mp\agents\crab_mini\crab_mini_tunedata::gettunedata();
	if(var_03 < var_04.min_dist_to_enemy_to_allow_turn_sq)
	{
		return 0;
	}

	if(var_03 > var_04.max_dist_to_enemy_to_allow_turn_sq)
	{
		return 0;
	}

	if(!navisstraightlinereachable(self.origin,var_02.origin,self))
	{
		return 0;
	}

	var_05 = scripts\common\utility::getyawtospot(var_02.origin);
	if(abs(var_05) < 45)
	{
		return 0;
	}

	self.desiredyaw = var_05;
	return 1;
}

//Function Number: 13
melee_begin(param_00)
{
	var_01 = scripts\aitypes\dlc3\bt_action_api::getcurrentdesiredaction(param_00);
	scripts\asm\crab_mini\crab_mini_asm::setaction(var_01);
	var_02 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	self.curmeleetarget = var_02;
	self.bmovingmelee = undefined;
	scripts\mp\agents\crab_mini\crab_mini_agent::setisstuck(undefined);
	scripts\aitypes\dlc3\bt_state_api::asm_wait_state_setup(param_00,var_01,var_01);
	scripts\aitypes\dlc3\bt_state_api::btstate_transitionstate(param_00,var_01);
}

//Function Number: 14
melee_tick(param_00)
{
	self clearpath();
	if(scripts\aitypes\dlc3\bt_state_api::btstate_tickstates(param_00))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 15
melee_end(param_00)
{
	self.curmeleetarget = undefined;
	scripts\asm\crab_mini\crab_mini_asm::clearaction();
	scripts\aitypes\dlc3\bt_state_api::btstate_endstates(param_00);
}

//Function Number: 16
movingmelee_begin(param_00)
{
	var_01 = scripts\aitypes\dlc3\bt_action_api::getcurrentdesiredaction(param_00);
	scripts\asm\crab_mini\crab_mini_asm::setaction(var_01);
	var_02 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	self.curmeleetarget = var_02;
	self.bmovingmelee = 1;
	var_03 = scripts\aitypes\dlc3\bt_state_api::btstate_getinstancedata(param_00);
	var_03.bfacingenemy = 1;
	scripts\mp\agents\crab_mini\crab_mini_agent::setisstuck(1);
	scripts\aitypes\dlc3\bt_state_api::asm_wait_state_setup(param_00,var_01,var_01,::movingmelee_attackdone);
	scripts\aitypes\dlc3\bt_state_api::btstate_transitionstate(param_00,var_01);
}

//Function Number: 17
movingmelee_tick(param_00)
{
	self clearpath();
	if(scripts\aitypes\dlc3\bt_state_api::btstate_tickstates(param_00))
	{
		return level.running;
	}

	return level.failure;
}

//Function Number: 18
movingmelee_end(param_00)
{
	self.curmeleetarget = undefined;
	var_01 = scripts\aitypes\dlc3\bt_state_api::btstate_getinstancedata(param_00);
	var_01.bfacingenemy = undefined;
	scripts\asm\crab_mini\crab_mini_asm::clearaction();
	scripts\aitypes\dlc3\bt_state_api::btstate_endstates(param_00);
}

//Function Number: 19
movingmelee_attackdone(param_00,param_01)
{
	if(scripts\mp\agents\crab_mini\crab_mini_agent::iscrabministuck())
	{
		scripts\aitypes\dlc3\bt_action_api::setdesiredaction(param_00,"stuck");
		return 0;
	}

	return 0;
}

//Function Number: 20
getpredictedenemypos(param_00,param_01)
{
	var_02 = param_00 getvelocity();
	var_03 = length2d(var_02);
	var_04 = param_00.origin + var_02 * param_01.avg_time_to_impact;
	return var_04;
}

//Function Number: 21
trymeleeattacks(param_00)
{
	var_01 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	if(!isdefined(var_01))
	{
		return level.failure;
	}

	var_02 = scripts\mp\agents\crab_mini\crab_mini_tunedata::gettunedata();
	if(abs(var_01.origin[2] - self.origin[2]) > var_02.melee_max_z_diff)
	{
		return level.failure;
	}

	var_03 = var_01.origin;
	if(isdefined(self.vehicle_getspawnerarray))
	{
		var_03 = getpredictedenemypos(var_01,var_02);
	}

	var_04 = distancesquared(var_03,self.origin);
	if(var_04 < var_02.stand_melee_dist_sq)
	{
		scripts\aitypes\dlc3\bt_action_api::setdesiredaction(param_00,"stand_melee");
		return 1;
	}

	var_05 = distancesquared(self.origin,var_01.origin);
	if(var_05 > var_02.non_predicted_move_melee_dist_sq)
	{
		if(var_04 > var_02.move_melee_dist_sq)
		{
			return 0;
		}
	}

	if(var_05 > var_02.check_reachable_dist_sq)
	{
		var_06 = self _meth_84AC();
		var_07 = getclosestpointonnavmesh(var_01.origin,self);
		if(!navisstraightlinereachable(var_06,var_07,self))
		{
			return 0;
		}
	}

	scripts\aitypes\dlc3\bt_action_api::setdesiredaction(param_00,"moving_melee");
	return 1;
}

//Function Number: 22
trymeleeattacks_old(param_00,param_01)
{
	var_02 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	if(!isdefined(param_01))
	{
		param_01 = distancesquared(self.origin,var_02.origin);
	}

	var_03 = scripts\mp\agents\crab_mini\crab_mini_tunedata::gettunedata();
	if(param_01 > var_03.move_melee_dist_sq)
	{
		return 0;
	}

	var_04 = var_02.origin - self.origin * (1,1,0);
	var_05 = anglestoforward(self.angles);
	var_06 = vectornormalize(var_04);
	var_07 = vectordot(var_05,var_06);
	if(var_07 < var_03.stand_melee_attack_dot)
	{
		return 0;
	}

	if(param_01 < var_03.stand_melee_dist_sq)
	{
		scripts\aitypes\dlc3\bt_action_api::setdesiredaction(param_00,"stand_melee");
	}
	else
	{
		scripts\aitypes\dlc3\bt_action_api::setdesiredaction(param_00,"moving_melee");
	}

	return 1;
}

//Function Number: 23
decideaction(param_00)
{
	var_01 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	if(!isdefined(var_01))
	{
		return level.failure;
	}

	var_02 = gettime();
	if(trymeleeattacks(param_00))
	{
		self.lastenemyengagetime = var_02;
		return level.success;
	}

	return level.failure;
}

//Function Number: 24
followenemy_begin(param_00)
{
	self.var_3135.instancedata[param_00] = spawnstruct();
}

//Function Number: 25
followenemy_tick(param_00)
{
	var_01 = scripts\mp\agents\crab_mini\crab_mini_agent::getenemy();
	if(!isdefined(var_01))
	{
		return level.failure;
	}

	var_02 = getclosestpointonnavmesh(var_01.origin,self);
	self ghostskulls_complete_status(var_02);
	if(!self getpersstat(var_01))
	{
		return level.running;
	}

	return level.success;
}

//Function Number: 26
followenemy_end(param_00)
{
	self.var_3135.instancedata[param_00] = undefined;
}
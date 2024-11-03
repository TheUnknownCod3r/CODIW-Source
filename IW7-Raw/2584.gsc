/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2584.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 17
 * Decompile Time: 2 ms
 * Timestamp: 10/27/2023 12:23:24 AM
*******************************************************************/

//Function Number: 1
func_1180F(param_00)
{
	scripts/asm/asm_bb::bb_requestthrowgrenade(1,self.isnodeoccupied);
	self.bt.instancedata[param_00] = gettime() + 4000;
}

//Function Number: 2
func_11811(param_00)
{
	scripts/asm/asm_bb::bb_requestthrowgrenade(0);
	self.bt.instancedata[param_00] = undefined;
}

//Function Number: 3
func_11812(param_00)
{
	var_01 = scripts/asm/asm_bb::bb_getthrowgrenadetarget();
	if(!isdefined(var_01))
	{
		return level.failure;
	}

	if(self.a.pose != self.a.var_85E2)
	{
		return level.failure;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("throwgrenade","start",0))
	{
		self.bt.instancedata[param_00] = self.bt.instancedata[param_00] + 10000;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("throwgrenade","end"))
	{
		return level.success;
	}

	if(gettime() > self.bt.instancedata[param_00])
	{
		return level.failure;
	}

	return level.running;
}

//Function Number: 4
func_8BF7(param_00)
{
	if(func_BE18() && gettime() >= 10000 || isdefined(level.var_932B) && level.var_932B)
	{
		self.a.nextgrenadetrytime = gettime() + 500;
		return level.success;
	}

	return level.failure;
}

//Function Number: 5
func_3928(param_00)
{
	if(isdefined(self.vehicle_getspawnerarray) || isdefined(self.script) && self.script == "cover_arrival")
	{
		return level.failure;
	}

	if(self.objective_team == "none")
	{
		return level.failure;
	}

	if(isdefined(self.isnodeoccupied) && isdefined(self.isnodeoccupied.var_5963) && self.isnodeoccupied.var_5963)
	{
		return level.failure;
	}

	if(isdefined(self.dontevershoot) && self.dontevershoot)
	{
		return level.failure;
	}

	if(scripts\engine\utility::actor_is3d())
	{
		return level.failure;
	}

	if(scripts\anim\utility_common::usingmg())
	{
		return level.failure;
	}

	if(isdefined(level.var_11813) && isalive(level.player))
	{
		if(func_85E3(level.player,200))
		{
			return level.success;
		}
	}

	if(isdefined(self.isnodeoccupied) && func_85E3(self.isnodeoccupied,self.var_B781))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 6
func_85E3(param_00,param_01)
{
	var_02 = param_00.origin;
	if(!self getpersstat(param_00))
	{
		if(isdefined(self.isnodeoccupied) && param_00 == self.isnodeoccupied && isdefined(self.var_FECF))
		{
			var_02 = self.var_FECF;
		}

		param_01 = 100;
	}
	else if(!isdefined(param_01))
	{
		param_01 = 100;
	}

	if(distancesquared(self.origin,var_02) < param_01 * param_01)
	{
		return 0;
	}

	if(self.a.pose != self.a.var_85E2)
	{
		return 0;
	}

	func_F62B(param_00);
	if(!_meth_85B5(param_00))
	{
		return 0;
	}

	var_03 = scripts\engine\utility::getyawtospot(var_02);
	if(abs(var_03) > 60)
	{
		return 0;
	}

	if(self.var_394 == "mg42" || self.objective_state <= 0)
	{
		return 0;
	}

	if(isdefined(self.isnodeoccupied) && param_00 == self.isnodeoccupied)
	{
		if(!func_3E1C())
		{
			return 0;
		}

		if(scripts\anim\utility_common::canseeenemyfromexposed())
		{
			if(!self _meth_81A2(param_00,param_00.origin))
			{
				return 0;
			}

			return 1;
		}

		if(scripts\anim\utility_common::cansuppressenemyfromexposed())
		{
			return 1;
		}

		if(!self _meth_81A2(param_00,param_00.origin))
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 7
func_BE18()
{
	return gettime() >= self.a.nextgrenadetrytime;
}

//Function Number: 8
func_3E1C()
{
	var_00 = self.isnodeoccupied.origin - self.origin;
	var_01 = lengthsquared((var_00[0],var_00[1],0));
	if(self.objective_team == "flash_grenade")
	{
		return var_01 < 589824;
	}

	return var_01 >= -25536 && var_01 <= 1562500;
}

//Function Number: 9
func_D022()
{
	if(isdefined(self.var_71C7))
	{
		return [[ self.var_71C7 ]]();
	}

	return 0;
}

//Function Number: 10
_meth_85B5(param_00)
{
	if(func_D022())
	{
		return 0;
	}

	if(isdefined(self.script_forcegrenade) && self.script_forcegrenade == 1)
	{
		return 1;
	}

	if(gettime() >= func_7EE9(self.var_1652))
	{
		return 1;
	}

	if(self.var_1652.isplayertimer && self.var_1652.timername == "fraggrenade")
	{
		return func_B4EF(param_00);
	}

	return 0;
}

//Function Number: 11
func_F62B(param_00)
{
	self.var_1652 = spawnstruct();
	if(isplayer(param_00) && isdefined(param_00.grenadetimers))
	{
		self.var_1652.isplayertimer = 1;
		self.var_1652.player = param_00;
		self.var_1652.timername = self.objective_team;
		return;
	}

	self.var_1652.isplayertimer = 0;
	self.var_1652.timername = "AI_" + self.objective_team;
}

//Function Number: 12
func_B4EF(param_00)
{
	if(func_D022())
	{
		return 0;
	}

	if(!param_00.gs.double_grenades_allowed)
	{
		return 0;
	}

	var_01 = gettime();
	if(var_01 < param_00.grenadetimers["double_grenade"])
	{
		return 0;
	}

	if(var_01 > param_00.lastfraggrenadetoplayerstart + 3000)
	{
		return 0;
	}

	if(var_01 < param_00.lastfraggrenadetoplayerstart + 500)
	{
		return 0;
	}

	return param_00.numgrenadesinprogresstowardsplayer < 2;
}

//Function Number: 13
func_7EE9(param_00)
{
	if(param_00.isplayertimer)
	{
		return param_00.player.grenadetimers[param_00.timername];
	}

	return level.grenadetimers[param_00.timername];
}

//Function Number: 14
func_1182C(param_00)
{
	scripts/asm/asm_bb::bb_requestfire(1,self.isnodeoccupied);
	self.bt.instancedata[param_00] = gettime() + 4000;
}

//Function Number: 15
func_1182D(param_00)
{
	scripts/asm/asm_bb::bb_requestfire(0);
	self.bt.instancedata[param_00] = undefined;
}

//Function Number: 16
func_1182E(param_00)
{
	var_01 = scripts/asm/asm_bb::func_2931();
	if(!isdefined(var_01))
	{
		return level.failure;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("throwSeeker","start",0))
	{
		self.bt.instancedata[param_00] = self.bt.instancedata[param_00] + 10000;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("throwSeeker","end"))
	{
		return level.success;
	}

	if(gettime() > self.bt.instancedata[param_00])
	{
		return level.failure;
	}

	return level.running;
}

//Function Number: 17
func_3929(param_00)
{
	if(isdefined(self.vehicle_getspawnerarray))
	{
		return level.failure;
	}

	if(self.objective_team == "none")
	{
		return level.failure;
	}

	if(isdefined(self.isnodeoccupied) && isdefined(self.isnodeoccupied.var_5963) && self.isnodeoccupied.var_5963)
	{
		return level.failure;
	}

	if(isdefined(self.dontevershoot) && self.dontevershoot)
	{
		return level.failure;
	}

	if(scripts\engine\utility::actor_is3d())
	{
		return level.failure;
	}

	func_F62B(self.isnodeoccupied);
	if(!_meth_85B5(self.isnodeoccupied))
	{
		return 0;
	}

	return level.success;
}
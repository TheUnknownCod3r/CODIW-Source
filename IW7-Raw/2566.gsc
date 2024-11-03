/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2566.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 68
 * Decompile Time: 13 ms
 * Timestamp: 10/27/2023 12:23:21 AM
*******************************************************************/

//Function Number: 1
func_12E91(param_00)
{
	scripts/asm/asm_bb::bb_requestweapon(weaponclass(self.primaryweapon));
	func_12F28(param_00);
	var_01 = scripts/asm/asm::func_233E("ai_notify","bulletwhizby");
	if(isdefined(var_01))
	{
		if(!isdefined(self.disablebulletwhizbyreaction))
		{
			var_02 = var_01.params[0];
			var_03 = isdefined(var_02) && distancesquared(self.origin,var_02.origin) < 160000;
			if(var_03 || scripts\engine\utility::cointoss())
			{
				scripts/asm/asm_bb::bb_requestwhizby(var_01);
			}
		}
	}
	else
	{
		var_04 = 100;
		var_01 = scripts/asm/asm_bb::bb_getrequestedwhizby();
		if(!isdefined(var_01) || gettime() > var_01.var_7686 + var_04)
		{
			scripts/asm/asm_bb::bb_requestwhizby(undefined);
		}
	}

	self.doentitiessharehierarchy = undefined;
	return level.success;
}

//Function Number: 2
func_FFC8()
{
	if(isdefined(self.var_7360))
	{
		return self.var_7360;
	}

	return 0;
}

//Function Number: 3
func_12E90(param_00)
{
	if(!isalive(self))
	{
		self.a.state = "death";
		return level.failure;
	}

	scripts/asm/asm_bb::bb_setisincombat(func_8BEC(undefined) == level.success);
	if(scripts\anim\utility_common::isasniper())
	{
		self._blackboard.var_32D2 = 1;
	}
	else
	{
		self._blackboard.var_32D2 = undefined;
	}

	if(weaponclass(self.var_394) == "pistol")
	{
		lib_0A19::func_12F5C(param_00);
	}

	var_01 = func_7FD3();
	scripts/asm/asm_bb::bb_requestmovetype(var_01);
	if(scripts/asm/asm_bb::bb_moverequested())
	{
		self.a.state = "move";
	}
	else if(isdefined(scripts/asm/asm_bb::bb_getcovernode()))
	{
		self.a.state = "cover";
	}
	else if(scripts/asm/asm_bb::bb_isincombat())
	{
		self.a.state = "combat";
	}
	else
	{
		self.a.state = "stop";
	}

	return level.success;
}

//Function Number: 4
func_12F64(param_00)
{
	var_01 = scripts/asm/asm::func_233E("ai_notify","bulletwhizby");
	if(isdefined(var_01) && isdefined(self.a))
	{
		if(randomfloat(1) < self.a.reacttobulletchance)
		{
			scripts/asm/asm_bb::bb_requestwhizby(var_01);
		}
	}
	else
	{
		var_02 = 100;
		var_01 = scripts/asm/asm_bb::bb_getrequestedwhizby();
		if(!isdefined(var_01) || gettime() > var_01.var_7686 + var_02)
		{
			scripts/asm/asm_bb::bb_requestwhizby(undefined);
		}
	}

	return level.success;
}

//Function Number: 5
func_12F28(param_00)
{
	var_01 = self [[ self.var_71A6 ]]();
	var_02 = scripts/asm/asm_bb::func_292C();
	var_03 = [];
	var_03["prone"] = 0;
	var_03["crouch"] = 1;
	var_03["stand"] = 2;
	var_04 = scripts/aitypes/bt_util::func_75();
	if(isdefined(self.vehicle_getspawnerarray))
	{
		var_02 = "stand";
	}

	if(!isdefined(var_01))
	{
		var_01 = var_02;
	}

	if(var_04 == "casual" || var_04 == "casual_gun")
	{
		scripts/asm/asm_bb::bb_requestsmartobject("stand");
	}
	else if(var_01 == "prone" && self.unittype == "c6")
	{
		scripts/asm/asm_bb::bb_requestsmartobject("crouch");
	}
	else
	{
		if(var_03[var_01] < var_03[var_02])
		{
			var_02 = var_01;
		}
		else if(var_02 == "crouch" && var_03[var_01] > var_03["crouch"])
		{
			if(scripts/asm/asm_bb::bb_isinbadcrouchspot())
			{
				var_02 = "stand";
			}
		}

		scripts/asm/asm_bb::bb_requestsmartobject(var_02);
	}

	return level.success;
}

//Function Number: 6
func_12E93(param_00)
{
	if(!isdefined(self.var_71D5))
	{
		return level.success;
	}

	var_01 = self [[ self.var_71D5 ]]();
	return var_01;
}

//Function Number: 7
func_7FD3()
{
	var_00 = self [[ self.var_71A8 ]]();
	return var_00;
}

//Function Number: 8
func_9E40(param_00)
{
	return func_8BEC(param_00);
}

//Function Number: 9
func_8BEC(param_00)
{
	if(isdefined(self.isnodeoccupied))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 10
func_8C0B(param_00)
{
	if(!isdefined(self.isnodeoccupied))
	{
		return level.failure;
	}

	if(self getpersstat(self.isnodeoccupied))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 11
hasammoinclip()
{
	var_00 = makescrambler();
	if(isdefined(var_00))
	{
		return 1;
	}

	if(!isdefined(self.var_394))
	{
		return 0;
	}

	if(self.bulletsinclip > 0 || isdefined(self.var_C08B))
	{
		return 1;
	}

	return 0;
}

//Function Number: 12
func_8BC6(param_00)
{
	if(hasammoinclip())
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 13
func_9E8B(param_00,param_01)
{
	if(scripts\anim\utility_common::needtoreload(param_01))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 14
func_13D98(param_00,param_01)
{
	if(!isdefined(self.isnodeoccupied))
	{
		return level.failure;
	}

	if(distancesquared(self.origin,self.isnodeoccupied.origin) <= param_01 * param_01)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 15
func_8BF6(param_00)
{
	if(self.objective_state > 0)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 16
func_8C24(param_00)
{
	if(isdefined(self.objective_team) && self.objective_team == "seeker")
	{
		if(self.objective_state > 0)
		{
			return level.success;
		}
	}

	return level.failure;
}

//Function Number: 17
func_B4EB(param_00)
{
	if(!isdefined(self.var_394))
	{
		return level.failure;
	}

	if(!shouldshoot())
	{
		return level.failure;
	}

	return level.success;
}

//Function Number: 18
func_12EC2(param_00)
{
	if(!isdefined(self.doentitiessharehierarchy) || self.doentitiessharehierarchy != self.isnodeoccupied)
	{
		self.doentitiessharehierarchy = self.isnodeoccupied;
	}

	return level.success;
}

//Function Number: 19
func_FE5A(param_00)
{
	param_00.var_29AF = undefined;
}

//Function Number: 20
func_FE5D(param_00)
{
	param_00.var_29AF = 1;
}

//Function Number: 21
func_FE6E(param_00)
{
	self.bt.shootparams = spawnstruct();
	self.bt.shootparams.taskid = param_00;
	self.bt.shootparams.starttime = gettime();
	self.bt.m_bfiring = 0;
	self.doentitiessharehierarchy = self.isnodeoccupied;
	self.var_299D = self.isnodeoccupied;
	var_01 = scripts\anim\utility_common::isasniper();
	if(var_01)
	{
		func_FE5D(self.bt.shootparams);
		self.var_103BF = 0;
		self.var_103BA = 0;
	}
}

//Function Number: 22
func_FE83(param_00)
{
	if(isdefined(self.bt.shootparams) && self.bt.shootparams.taskid == param_00)
	{
		self.bt.shootparams = undefined;
	}

	self.bt.m_bfiring = 0;
	self.var_299D = undefined;
	scripts/asm/asm_bb::bb_requestfire(0);
}

//Function Number: 23
isaimedataimtarget()
{
	if(isdefined(self.var_71AE))
	{
		return self [[ self.var_71AE ]]();
	}

	return 0;
}

//Function Number: 24
resetmisstime_code()
{
	if(isdefined(self.var_71CA))
	{
		return self [[ self.var_71CA ]]();
	}
}

//Function Number: 25
_meth_811C()
{
	if(isdefined(self.var_71A9))
	{
		return self [[ self.var_71A9 ]]();
	}

	return 0;
}

//Function Number: 26
_meth_81E2(param_00)
{
	if(isdefined(self.var_71AA))
	{
		return self [[ self.var_71AA ]](param_00);
	}

	return 0;
}

//Function Number: 27
func_FE88(param_00)
{
	if(scripts/asm/asm::asm_ephemeraleventfired("shoot","shoot_finished"))
	{
		return level.success;
	}

	var_01 = self.bt.shootparams;
	var_02 = makescrambler();
	if(isdefined(self.isnodeoccupied) && !isplayer(self.isnodeoccupied) && var_01.starttime < gettime())
	{
		var_03 = int(gettime() / 50);
		if(self getentitynumber() % 4 != var_03 % 4)
		{
			return level.running;
		}
	}

	if(isdefined(var_02))
	{
		var_04 = _meth_81E2(var_02);
		var_05 = anglestoforward(var_04);
		var_05 = rotatevector(var_05,self.angles);
		var_06 = _meth_811C();
		var_01.pos = var_06 + var_05 * 512;
		var_01.ent = undefined;
	}
	else if(isdefined(self.goodshootpos))
	{
		var_01.pos = self.goodshootpos;
		var_01.ent = undefined;
	}
	else if(self getpersstat(self.isnodeoccupied))
	{
		var_01.pos = self.isnodeoccupied getshootatpos();
		var_01.ent = self.isnodeoccupied;
	}
	else
	{
		return level.success;
	}

	if(!isdefined(var_01.objective))
	{
		var_01.objective = "normal";
	}

	scripts/asm/asm_bb::bb_setshootparams(var_01,self.isnodeoccupied);
	if(isaimedataimtarget())
	{
		if(!self.bt.m_bfiring)
		{
			resetmisstime_code();
			chooseshootstyle(var_01);
			choosenumshotsandbursts(var_01);
		}

		func_3EF8(var_01);
		self.bt.m_bfiring = 1;
	}
	else
	{
		self.bt.m_bfiring = 0;
	}

	if(!isdefined(var_01.pos) && !isdefined(var_01.ent))
	{
		return level.success;
	}

	scripts/asm/asm_bb::bb_requestfire(self.bt.m_bfiring);
	return level.running;
}

//Function Number: 28
func_8BCE(param_00)
{
	if(self.var_394 == "none")
	{
		return 0;
	}

	return self.bulletsinclip >= weaponclipsize(self.var_394) * param_00;
}

//Function Number: 29
func_43EB(param_00)
{
	if(!isdefined(self.var_394) || self.var_394 == "none")
	{
		return level.failure;
	}

	if(!isdefined(self.isnodeoccupied))
	{
		if(!func_8BCE(0.5))
		{
			return level.success;
		}
	}

	if(!hasammoinclip())
	{
		return level.success;
	}

	if(func_8BCE(0.1))
	{
		return level.failure;
	}

	if(isdefined(self.vehicle_getspawnerarray))
	{
		if(isdefined(self.var_C0A0) && self.var_C0A0)
		{
			return level.failure;
		}

		if(isdefined(self.var_C0AD) && self.var_C0AD)
		{
			return level.failure;
		}

		if(!scripts\anim\utility_common::usingriflelikeweapon())
		{
			return level.failure;
		}

		if(self pathdisttogoal() < 256)
		{
			return level.failure;
		}
	}

	if(isdefined(self.isnodeoccupied) && isdefined(self.var_101B4) && !scripts\engine\utility::istrue(self.var_C009))
	{
		var_01 = 409;
		var_02 = distancesquared(self.origin,self.isnodeoccupied.origin);
		if(var_02 < var_01 * var_01)
		{
			return level.failure;
		}
	}

	return level.success;
}

//Function Number: 30
func_DF53(param_00)
{
	scripts/asm/asm_bb::bb_requestreload(1);
	self.bt.instancedata[param_00] = spawnstruct();
	self.bt.instancedata[param_00].var_2AB1 = isdefined(self.vehicle_getspawnerarray);
	self.bt.instancedata[param_00].timeout = gettime() + 5000;
}

//Function Number: 31
func_DF55(param_00)
{
	scripts/asm/asm_bb::bb_requestreload(0);
	self.bt.instancedata[param_00] = undefined;
}

//Function Number: 32
func_DF4E()
{
	var_00 = weaponclipsize(self.var_394);
	self.bulletsinclip = int(var_00 * 0.5);
	self.bulletsinclip = int(clamp(self.bulletsinclip,0,var_00));
}

//Function Number: 33
func_DF56(param_00)
{
	if(scripts/asm/asm::asm_ephemeraleventfired("reload","end"))
	{
		return level.success;
	}

	if(gettime() > self.bt.instancedata[param_00].timeout)
	{
		return level.success;
	}

	var_01 = weaponclipsize(self.var_394);
	var_02 = isdefined(self._blackboard.var_32D2);
	if(!var_02 && self.bulletsinclip == var_01)
	{
		return level.success;
	}

	if(isdefined(self.var_C08B))
	{
		func_DF4E();
		return level.success;
	}

	if(isdefined(self.vehicle_getspawnerarray) && !self.livestreamingenable && !scripts\engine\utility::actor_is3d())
	{
		func_DF4E();
		return level.success;
	}

	var_03 = self.bt.instancedata[param_00].var_2AB1;
	if(!var_03 && isdefined(self.vehicle_getspawnerarray))
	{
		func_DF4E();
		return level.success;
	}

	return level.running;
}

//Function Number: 34
chooseshootstyle(param_00)
{
	var_01 = -3036;
	var_02 = 810000;
	var_03 = 2560000;
	var_04 = weaponclass(self.var_394);
	var_05 = makescrambler();
	var_06 = isdefined(var_05);
	if(isdefined(self.bt.var_FEDB))
	{
		var_07 = 0;
		if(isdefined(self.bt.var_FED8))
		{
			var_07 = self.bt.var_FED8;
		}

		return func_F840(param_00,self.bt.var_FEDB,var_07);
	}

	if(var_05 == "mg" || var_07)
	{
		return func_F840(var_01,"mg",0);
	}

	if(isdefined(var_01.ent) && isdefined(var_01.ent.isnodeoccupied) && isdefined(var_01.ent.isnodeoccupied.physics_setgravityragdollscalar))
	{
		return func_F840(var_01,"single",0);
	}

	if(scripts\anim\utility_common::isasniper())
	{
		return func_F840(var_01,"single",0);
	}

	if(var_05 == "rocketlauncher" || var_05 == "pistol")
	{
		return func_F840(var_01,"single",0);
	}

	if(scripts\anim\utility_common::isshotgun(self.var_394))
	{
		if(scripts\anim\utility_common::weapon_pump_action_shotgun())
		{
			return func_F840(var_01,"single",0);
		}
		else
		{
			return func_F840(var_01,"semi",0);
		}
	}

	if(var_05 == "grenade")
	{
		return func_F840(var_01,"single",0);
	}

	if(function_023C(self.var_394) > 0)
	{
		return func_F840(var_01,"burst",0);
	}

	var_08 = distancesquared(self getshootatpos(),var_01.pos);
	if(var_08 < var_02)
	{
		if(isdefined(var_01.ent) && isdefined(var_01.ent.var_B14F))
		{
			return func_F840(var_01,"single",0);
		}
		else
		{
			return func_F840(var_01,"full",0);
		}
	}
	else if(var_08 < var_03 || func_FFC6())
	{
		if(function_0248(self.var_394) || func_FFF6())
		{
			return func_F840(var_01,"semi",1);
		}
		else
		{
			return func_F840(var_01,"burst",1);
		}
	}
	else if(self.assertmsg || var_08 < var_04)
	{
		if(func_FFF6())
		{
			return func_F840(var_01,"semi",0);
		}
		else
		{
			return func_F840(var_01,"burst",0);
		}
	}

	return func_F840(var_01,"single",0);
}

//Function Number: 35
func_F840(param_00,param_01,param_02)
{
	param_00.var_1119D = param_01;
	param_00.var_6B92 = param_02;
}

//Function Number: 36
func_FFC6()
{
	if(!isdefined(level.var_7683))
	{
		return 0;
	}

	return level.var_7683 == 3 && isplayer(self.isnodeoccupied);
}

//Function Number: 37
func_FFF6()
{
	if(weaponclass(self.var_394) != "rifle")
	{
		return 0;
	}

	if(self.team != "allies")
	{
		return 0;
	}

	var_00 = scripts\anim\utility_common::safemod(int(self.origin[1]),10000) + 2000;
	var_01 = int(self.origin[0]) + gettime();
	return var_01 % 2 * var_00 > var_00;
}

//Function Number: 38
makescrambler()
{
	if(isdefined(self.var_71AB))
	{
		return [[ self.var_71AB ]]();
	}
}

//Function Number: 39
func_4F68()
{
	var_00 = makescrambler();
	var_01 = isdefined(var_00);
	if(var_01 && isdefined(var_00.var_ED26))
	{
		var_02 = var_00.var_ED26;
	}
	else
	{
		var_02 = 0.5;
	}

	if(var_01 && isdefined(var_00.var_ED25))
	{
		var_03 = var_00.var_ED25 - var_02;
	}
	else
	{
		var_03 = 1.5;
	}

	var_04 = var_02 + randomfloat(var_03);
	return int(var_04 * 10);
}

//Function Number: 40
func_4F66()
{
	if(isdefined(self.var_71A0))
	{
		return [[ self.var_71A0 ]]();
	}
}

//Function Number: 41
choosenumshotsandbursts(param_00)
{
	if(isdefined(self.isnodeoccupied) && distancesquared(self.origin,self.isnodeoccupied.origin) > 160000)
	{
		param_00.var_32BD = randomintrange(1,5);
	}
	else
	{
		param_00.var_32BD = 10;
	}

	if(param_00.var_1119D == "full")
	{
		param_00.var_FF0B = func_4F66();
		return;
	}

	if(param_00.var_1119D == "burst" || param_00.var_1119D == "semi")
	{
		param_00.var_FF0B = func_4F65(param_00);
		return;
	}

	if(param_00.var_1119D == "single")
	{
		param_00.var_FF0B = 1;
		return;
	}

	if(param_00.var_1119D == "mg")
	{
		param_00.var_FF0B = func_4F68();
		return;
	}
}

//Function Number: 42
func_4F65(param_00)
{
	var_01 = 0;
	var_02 = function_023C(self.var_394);
	if(var_02)
	{
		var_01 = var_02;
	}
	else if(scripts\anim\weaponlist::usingsemiautoweapon())
	{
		var_01 = level.var_F217[randomint(level.var_F217.size)];
	}
	else if(param_00.var_6B92)
	{
		var_01 = level.var_6B93[randomint(level.var_6B93.size)];
	}
	else
	{
		var_01 = level.var_32BF[randomint(level.var_32BF.size)];
	}

	if(var_01 <= self.bulletsinclip)
	{
		return var_01;
	}

	if(self.bulletsinclip <= 0)
	{
		return 1;
	}

	return self.bulletsinclip;
}

//Function Number: 43
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

	if(!isdefined(self.var_394) || self.var_394 == "")
	{
		return 0;
	}

	if(self getpersstat(self.isnodeoccupied))
	{
		scripts\anim\utility_common::dontgiveuponsuppressionyet();
		self.goodshootpos = self.isnodeoccupied getshootatpos();
		return 1;
	}

	return scripts\anim\utility_common::cansuppressenemy();
}

//Function Number: 44
func_3EF8(param_00)
{
	if(isdefined(self.var_FED1))
	{
		if(!isdefined(self.isnodeoccupied))
		{
			param_00.pos = self.var_FED1;
			self.var_FED1 = undefined;
		}
		else
		{
			self.var_FED1 = undefined;
		}
	}

	var_01 = func_FECA(param_00);
	if(isdefined(var_01) && var_01 == "retry")
	{
		var_01 = func_FECA(param_00);
	}
}

//Function Number: 45
func_FECA(param_00)
{
	if(param_00.objective == "normal")
	{
		var_01 = func_FECB(param_00);
		return var_01;
	}

	if(scripts\anim\utility_common::shouldshootenemyent())
	{
		var_01.objective = "normal";
		return "retry";
	}

	var_02 = scripts\anim\utility_common::cansuppressenemy();
	if(var_01.objective == "suppress" || self.team == "allies" && !isdefined(self.isnodeoccupied) && !var_02)
	{
		func_FECC(var_01,var_02);
	}
}

//Function Number: 46
func_FECB(param_00)
{
	if(!scripts\anim\utility_common::shouldshootenemyent())
	{
		if(!isdefined(self.isnodeoccupied))
		{
			func_8C4D(param_00);
			return;
		}

		if((self.assertmsg || randomint(5) > 0) && func_100A4())
		{
			param_00.objective = "suppress";
		}
		else
		{
			param_00.objective = "ambush";
		}

		return "retry";
	}

	func_F83F(param_00);
}

//Function Number: 47
func_100A4()
{
	return 1;
}

//Function Number: 48
func_F83F(param_00)
{
	param_00.ent = self.isnodeoccupied;
	param_00.pos = param_00.ent getshootatpos();
}

//Function Number: 49
func_FECC(param_00,param_01)
{
	if(!param_01)
	{
		func_8C4D(param_00);
		return;
	}

	param_00.ent = undefined;
	param_00.pos = func_7E90();
}

//Function Number: 50
func_7E90()
{
	return self.goodshootpos;
}

//Function Number: 51
func_8C4D(param_00)
{
	param_00.ent = undefined;
	param_00.pos = undefined;
	param_00.var_1119D = "none";
	if(self.var_FC)
	{
		param_00.objective = "ambush";
	}
}

//Function Number: 52
func_10026()
{
	if(level.var_18D5[self.team] > 0 && level.var_18D5[self.team] < level.var_18D6)
	{
		if(gettime() - level.var_A936[self.team] > 4000)
		{
			return 0;
		}

		var_00 = level.var_A933[self.team];
		if(var_00 == self)
		{
			return 0;
		}

		var_01 = isdefined(var_00) && distancesquared(self.origin,var_00.origin) < 65536;
		if((var_01 || distancesquared(self.origin,level.var_A935[self.team]) < 65536) && !isdefined(self.isnodeoccupied) || distancesquared(self.isnodeoccupied.origin,level.var_A934[self.team]) < 262144)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 53
func_FFC2()
{
	if(self.logstring)
	{
		return 0;
	}

	if(scripts\engine\utility::actor_is3d())
	{
		return 0;
	}

	if(!isdefined(self.isnodeoccupied))
	{
		return 0;
	}

	if(isdefined(self.vehicle_getspawnerarray))
	{
		return 0;
	}

	if(weaponclass(self.var_394) == "mg")
	{
		return 0;
	}

	if(self.var_BC == "ambush" || self.var_BC == "ambush_nodes_only")
	{
		return 0;
	}

	if(isdefined(self.bt.var_C2))
	{
		return 0;
	}

	if(isdefined(self.script) && self.script == "cover_arrival")
	{
		return 0;
	}

	var_00 = vectornormalize(self.isnodeoccupied.origin - self.origin);
	var_01 = anglestoforward(self.angles);
	if(vectordot(var_00,var_01) < 0.5)
	{
		return 0;
	}

	if(self getpersstat(self.isnodeoccupied) && self canshootenemy())
	{
		return 0;
	}

	return 1;
}

//Function Number: 54
func_2544(param_00)
{
	self.bt.instancedata[param_00] = 0;
}

//Function Number: 55
func_2542(param_00)
{
	if(isdefined(self.var_7196))
	{
		return self [[ self.var_7196 ]](param_00);
	}

	return level.failure;
}

//Function Number: 56
func_2545(param_00)
{
	self.bt.instancedata[param_00] = undefined;
}

//Function Number: 57
func_93B6(param_00)
{
	if(self _meth_8531())
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 58
func_2753(param_00)
{
	if(scripts/asm/asm_bb::bb_moverequested())
	{
		return level.failure;
	}

	var_01 = self _meth_8530(128);
	if(isdefined(var_01))
	{
		self _meth_8481(var_01);
		self._blackboard.var_2754 = gettime();
		return level.success;
	}

	return level.failure;
}

//Function Number: 59
func_1384E(param_00)
{
	var_01 = gettime();
	if(var_01 > self._blackboard.var_2754 + 100 && !isdefined(self.vehicle_getspawnerarray))
	{
		return level.failure;
	}

	if(var_01 > self._blackboard.var_2754 + 5000)
	{
		return level.failure;
	}

	return level.running;
}

//Function Number: 60
func_275A(param_00)
{
	self _meth_8484();
	self._blackboard.var_2754 = undefined;
}

//Function Number: 61
func_24D4(param_00)
{
	if(!isdefined(self.var_F126))
	{
		return level.failure;
	}

	if(self.precacheleaderboards)
	{
		return level.failure;
	}

	var_01 = distancesquared(self.var_F126.origin,self.origin);
	if(self getpersstat(self.var_F126) && var_01 < 122500)
	{
		return level.success;
	}

	if(var_01 < 22500)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 62
func_E84E(param_00)
{
	func_FE6E(param_00);
	self.var_C3BB = self.loadstartpointtransients;
	self.var_C3B6 = self.var_BC;
	self.loadstartpointtransients = self.var_F126;
	self.doentitiessharehierarchy = self.var_F126;
	self.var_299D = self.var_F126;
	self.var_F126.bt.var_1152B = 1;
}

//Function Number: 63
func_13132(param_00)
{
	switch(param_00)
	{
		case "w2":
		case "w1":
		case "w0":
		case "omr":
		case "slt":
		case "5":
		case "4":
		case "3":
		case "2":
		case "0":
		case "1":
			return 1;
	}

	return 0;
}

//Function Number: 64
func_E84D(param_00)
{
	if(!isdefined(self.var_F126))
	{
		return level.failure;
	}

	if(self.unittype == "soldier")
	{
		var_01 = self.var_F126.origin;
		var_02 = vectornormalize(self.origin - var_01);
		var_03 = self.origin + var_02 * 200;
		var_04 = getclosestpointonnavmesh(var_03);
		self.var_BC = "no_cover";
		self _meth_8481(var_04);
	}
	else
	{
		self.var_BC = "no_cover";
		self _meth_8481(self.origin);
	}

	if(!isdefined(self.loadstartpointtransients) || !isalive(self.loadstartpointtransients) || self.loadstartpointtransients != self.var_F126)
	{
		return level.success;
	}

	if(!isdefined(self.isnodeoccupied) || self.isnodeoccupied != self.loadstartpointtransients)
	{
		return level.running;
	}

	var_05 = self.bt.shootparams;
	if(self getpersstat(self.isnodeoccupied))
	{
		var_05.pos = self.isnodeoccupied getshootatpos();
		var_05.ent = self.isnodeoccupied;
	}
	else
	{
		return level.running;
	}

	if(!isdefined(self.var_F184))
	{
		self.var_F184 = 1;
		if(isdefined(self.var_46BC) && isdefined(self.npcid) && self.var_46BC == "UN" || self.var_46BC == "SD")
		{
			if(func_13132(self.npcid))
			{
				var_06 = self.var_46BC + "_" + self.npcid + "_reaction_seeker_attack";
				self playsound(var_06);
			}
		}

		func_DF4E();
	}

	if(!isdefined(var_05.objective))
	{
		var_05.objective = "normal";
	}

	scripts/asm/asm_bb::bb_setshootparams(var_05,self.isnodeoccupied);
	if(isaimedataimtarget())
	{
		if(!self.bt.m_bfiring)
		{
			resetmisstime_code();
			chooseshootstyle(var_05);
			choosenumshotsandbursts(var_05);
		}

		func_3EF8(var_05);
		self.bt.m_bfiring = 1;
	}
	else
	{
		self.bt.m_bfiring = 0;
	}

	if(!isdefined(var_05.pos) && !isdefined(var_05.ent))
	{
		return level.success;
	}

	scripts/asm/asm_bb::bb_requestfire(self.bt.m_bfiring);
	return level.running;
}

//Function Number: 65
func_E84F(param_00)
{
	self _meth_8484();
	self.loadstartpointtransients = self.var_C3BB;
	self.var_C3BB = undefined;
	self.var_BC = self.var_C3B6;
	self.var_C3B6 = undefined;
	self.var_F184 = undefined;
	func_FE83(param_00);
}

//Function Number: 66
func_12A82(param_00)
{
	if(isdefined(scripts/asm/asm_bb::bb_getrequestedturret()))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 67
_meth_8082()
{
	var_00 = self geteye();
	foreach(var_02 in level.players)
	{
		if(!self getpersstat(var_02))
		{
			continue;
		}

		var_03 = var_02 geteye();
		var_04 = vectortoangles(var_00 - var_03);
		var_05 = anglestoforward(var_04);
		var_06 = var_02 getplayerangles();
		var_07 = anglestoforward(var_06);
		var_08 = vectordot(var_05,var_07);
		if(var_08 < 0.805)
		{
			continue;
		}

		if(scripts\engine\utility::cointoss() && var_08 >= 0.996)
		{
			continue;
		}

		return var_02;
	}

	return undefined;
}

//Function Number: 68
func_12F1D(param_00)
{
	if(self.team != "axis")
	{
		return level.success;
	}

	if(isdefined(self.var_5583) && self.var_5583)
	{
		return level.success;
	}

	if(!scripts\anim\utility_common::isasniper())
	{
		return level.success;
	}

	var_01 = level.var_7649["sniper_glint"];
	if(!isdefined(var_01))
	{
		return level.success;
	}

	if(!isdefined(self.var_BF5C))
	{
		self.var_BF5C = gettime() + randomintrange(3000,5000);
	}

	if(!isdefined(self.isnodeoccupied) || !isalive(self.isnodeoccupied))
	{
		return level.success;
	}

	if(gettime() < self.var_BF5C)
	{
		return level.success;
	}

	self.var_BF5C = gettime() + 200;
	if(self.var_394 != self.primaryweapon)
	{
		return level.success;
	}

	var_02 = _meth_8082();
	if(!isdefined(var_02))
	{
		return level.success;
	}

	if(distancesquared(self.origin,var_02.origin) < 65536)
	{
		return level.success;
	}

	if(scripts/asm/asm_bb::func_2985() && isdefined(self._blackboard.shootparams.pos))
	{
		var_03 = self _meth_853C();
		var_04 = vectornormalize(self._blackboard.shootparams.pos - self geteye());
		var_05 = vectordot(var_03,var_04);
		if(var_05 < 0.906)
		{
			self.var_BF5C = undefined;
			return level.success;
		}
	}
	else
	{
		self.var_BF5C = undefined;
		return level.success;
	}

	playfxontag(var_01,self,"tag_flash");
	self.var_BF5C = gettime() + randomintrange(3000,5000);
	return level.success;
}
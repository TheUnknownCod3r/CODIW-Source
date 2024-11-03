/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2572.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 5 ms
 * Timestamp: 10/27/2023 12:23:22 AM
*******************************************************************/

//Function Number: 1
func_10020(param_00)
{
	if(scripts/asm/asm::asm_ephemeraleventfired("grenade response","return throw",0))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 2
func_85D3(param_00)
{
	if(scripts/asm/asm::asm_ephemeraleventfired("grenade response","return throw complete"))
	{
		return level.success;
	}

	scripts/asm/asm_bb::func_2964(1);
	return level.running;
}

//Function Number: 3
func_85D4(param_00)
{
	scripts/asm/asm_bb::func_2964(undefined);
}

//Function Number: 4
func_1001E(param_00)
{
	if(scripts/asm/asm::asm_ephemeraleventfired("grenade response","avoid",0))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 5
spectateclientnum(param_00)
{
	var_01 = spawnstruct();
	var_01.var_6393 = gettime() + 10000;
	var_01.var_4767 = 0;
	self.bt.instancedata[param_00] = var_01;
	scripts/asm/asm_bb::func_2963(1);
	lib_0A0A::func_41A3(param_00);
}

//Function Number: 6
_meth_85B1(param_00)
{
	self.bt.instancedata[param_00] = undefined;
	scripts/asm/asm_bb::func_2963(undefined);
}

//Function Number: 7
isspectatingplayer(param_00)
{
	var_01 = self.bt.instancedata[param_00];
	var_02 = gettime();
	if(!isdefined(var_01._meth_85BA) && !isdefined(self.objective_position))
	{
		var_01._meth_85BA = var_02;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("grenade dive","end"))
	{
		return level.success;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("grenade cower","end"))
	{
		var_01.var_4767 = 1;
		if(isdefined(var_01._meth_85BA))
		{
			var_01.var_6393 = var_02;
		}
		else
		{
			var_03 = 3000;
			var_01.var_6393 = var_02 + var_03;
		}
	}

	if(var_01.var_4767)
	{
		if(isdefined(var_01._meth_85BA) && var_02 - var_01._meth_85BA > 500)
		{
			return level.success;
		}
	}
	else if(!isdefined(self.objective_position))
	{
		return level.success;
	}

	if(var_02 > var_01.var_6393)
	{
		return level.success;
	}

	return level.running;
}
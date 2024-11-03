/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2569.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 14
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:23:21 AM
*******************************************************************/

//Function Number: 1
func_E477(param_00)
{
	return level.success;
}

//Function Number: 2
func_E470(param_00)
{
	return level.failure;
}

//Function Number: 3
func_E475(param_00)
{
	return level.running;
}

//Function Number: 4
func_E478(param_00,param_01)
{
	if(param_01 == 1)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 5
func_9FEE(param_00,param_01)
{
	if(isdefined(param_01))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 6
func_FAF6(param_00)
{
	self.bt.instancedata[param_00] = [];
	self.bt.instancedata[param_00]["waitStartTime"] = gettime();
}

//Function Number: 7
func_5AEA(param_00,param_01)
{
	var_02 = self.bt.instancedata[param_00]["waitStartTime"];
	if(gettime() - var_02 < param_01)
	{
		return level.running;
	}

	return level.success;
}

//Function Number: 8
func_8C0A(param_00,param_01)
{
	var_02 = param_01;
	if(self getpersstat(var_02))
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 9
func_13157(param_00,param_01)
{
	var_02 = param_01[0];
	var_03 = param_01[1];
	var_04 = param_01[2];
	if(var_03 <= var_02 && var_02 <= var_04)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 10
func_DC6A(param_00,param_01)
{
	var_02 = param_01[0];
	var_03 = param_01[1];
	if(randomint(var_02) < var_03)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 11
cointoss(param_00)
{
	if(randomint(100) < 50)
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 12
func_9309(param_00,param_01)
{
	if(isdefined(param_01))
	{
		var_02 = param_01;
	}
	else
	{
		var_02 = self;
	}

	return isalive(var_02);
}

//Function Number: 13
func_9307(param_00)
{
	if(scripts/asm/asm_bb::bb_isanimscripted())
	{
		return level.success;
	}

	return level.failure;
}

//Function Number: 14
func_930C(param_00)
{
	if(scripts/asm/asm_bb::bb_isselfdestruct())
	{
		return level.success;
	}

	return level.failure;
}
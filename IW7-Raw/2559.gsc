/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2559.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 3 ms
 * Timestamp: 10/27/2023 12:23:20 AM
*******************************************************************/

//Function Number: 1
func_006E(param_00,param_01,param_02,param_03)
{
	var_04 = level.invalid;
	var_05 = undefined;
	var_06 = level.var_119E[param_00];
	var_07 = var_06.var_1581[param_01];
	var_04 = [[ var_07 ]](param_02);
	if(!isdefined(var_04))
	{
		var_04 = 3;
	}

	return var_04;
}

//Function Number: 2
bt_nativesetregistrar(param_00)
{
	function_02BA(param_00);
}

//Function Number: 3
bt_nativeregistertree(param_00,param_01,param_02,param_03)
{
	function_02B8(param_00,param_01,param_02,param_03);
}

//Function Number: 4
bt_nativeistreeregistered(param_00)
{
	return function_02BC(param_00);
}

//Function Number: 5
bt_nativeregisterbehavior(param_00,param_01,param_02,param_03,param_04)
{
	function_02B9(param_00,param_01,param_02,param_03,param_04);
}

//Function Number: 6
bt_nativeregisterbehaviortotree(param_00,param_01,param_02,param_03,param_04)
{
	function_02B9(param_00,param_01,param_02,param_03,param_04);
}

//Function Number: 7
bt_nativefinalizeregistrar()
{
	function_02BB();
}

//Function Number: 8
bt_nativetick()
{
	self _meth_84B3();
}

//Function Number: 9
bt_nativeregisteraction(param_00,param_01,param_02,param_03,param_04,param_05)
{
	function_02BD(param_00,param_01,param_02,param_03,param_04,param_05);
}

//Function Number: 10
bt_nativeexecaction(param_00,param_01,param_02,param_03)
{
	var_04 = level.invalid;
	var_05 = gettime();
	if(isdefined(param_03))
	{
		var_06 = [[ param_03 ]]();
		var_04 = [[ param_01 ]](param_02,var_06);
	}
	else
	{
		var_04 = [[ param_01 ]](param_02);
	}

	if(!isdefined(var_04))
	{
		return 3;
	}

	if(var_04 == level.failure)
	{
		return 0;
	}

	if(var_04 == level.success)
	{
		return 1;
	}

	if(var_04 == level.running)
	{
		return 2;
	}

	return 3;
}

//Function Number: 11
bt_nativecopyaction(param_00)
{
}

//Function Number: 12
bt_nativecopybehavior(param_00)
{
}
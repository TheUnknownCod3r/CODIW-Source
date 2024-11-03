/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3065.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 10
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:26:05 AM
*******************************************************************/

//Function Number: 1
func_33FF(param_00)
{
	self.var_87F6 = 1;
	lib_0BFE::func_97F9();
	lib_0A10::func_3376();
	self.bt.var_71CC = ::lib_0BFE::func_F1F1;
	return level.success;
}

//Function Number: 2
func_336F(param_00)
{
	scripts/asm/asm_bb::bb_requestsmartobject("crouch");
}

//Function Number: 3
func_336E(param_00)
{
	if(!isdefined(self.objective_position))
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 4
func_3370(param_00)
{
	scripts/asm/asm_bb::bb_requestsmartobject("stand");
}

//Function Number: 5
_meth_846E(param_00)
{
	if(!isdefined(self.objective_position))
	{
		return level.failure;
	}

	if(!isdefined(self.vehicle_getspawnerarray))
	{
		return level.success;
	}

	if(scripts/asm/asm::asm_ephemeraleventfired("grenade response","return throw"))
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 6
forceplaygestureviewmodel(param_00)
{
}

//Function Number: 7
_meth_85C1(param_00)
{
	scripts/asm/asm_bb::func_2964(1);
}

//Function Number: 8
_meth_85C3(param_00)
{
	if(scripts/asm/asm::asm_ephemeraleventfired("grenade response","return throw complete"))
	{
		return level.success;
	}

	if(!isdefined(self.objective_position))
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 9
_meth_85C2(param_00)
{
	scripts/asm/asm_bb::func_2964(undefined);
}

//Function Number: 10
func_335B(param_00)
{
	if(lib_0A0B::func_7C35("torso") == "dismember")
	{
		return level.failure;
	}

	return lib_0A18::func_3928(param_00);
}
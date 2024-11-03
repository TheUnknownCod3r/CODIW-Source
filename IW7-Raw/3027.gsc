/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3027.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:26:04 AM
*******************************************************************/

//Function Number: 1
main(param_00,param_01,param_02)
{
	var_03 = spawnstruct();
	var_03.var_B8F9 = "mp";
	var_03.dvarfuncs = ::dvarfuncs;
	var_03.init = ::func_963C;
	lib_0BCE::main(var_03);
}

//Function Number: 2
func_963C()
{
	playfxontag(level.var_A3B9.var_11888,self,"tag_engine_left");
	playfxontag(level.var_A3B9.var_11888,self,"tag_engine_right");
}

//Function Number: 3
init_location()
{
}

//Function Number: 4
dvarfuncs(param_00,param_01)
{
	setdvar(param_00,param_01);
}

//Function Number: 5
func_D31A(param_00,param_01,param_02)
{
	self getweaponrankxpmultiplier();
	if(isdefined(param_02) && param_02)
	{
		var_03 = "hover";
	}
	else
	{
		var_03 = "fly";
	}

	lib_0BCE::func_A2B2(param_00,param_01,var_03);
}

//Function Number: 6
func_D05B()
{
	lib_0BCE::func_A2B1();
	self gold_teeth_pickup();
}
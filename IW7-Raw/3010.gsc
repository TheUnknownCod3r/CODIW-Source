/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3010.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:26:03 AM
*******************************************************************/

//Function Number: 1
main(param_00,param_01,param_02)
{
	scripts/sp/vehicle_build::func_31C5(param_01,param_00,undefined,param_02);
	scripts/sp/vehicle_build::func_31A6(::init_location);
	scripts/sp/vehicle_build::func_31A3(90000);
	scripts/sp/vehicle_build::func_319F();
}

//Function Number: 2
init_location()
{
	self.var_55A4 = 1;
	self _meth_8184();
}
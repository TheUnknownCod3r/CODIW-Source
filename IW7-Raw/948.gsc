/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 948.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:32:12 AM
*******************************************************************/

//Function Number: 1
func_2AD0()
{
	if(isdefined(level.var_119E["zombie_ghost"]))
	{
		return;
	}

	var_00 = spawnstruct();
	var_00.var_1581 = [];
	var_00.var_1581[0] = ::scripts/aitypes/zombie_ghost/behaviors::initzombieghost;
	var_00.var_1581[1] = ::lib_0C2B::func_3E48;
	var_00.var_1581[2] = ::scripts/aitypes/zombie_ghost/behaviors::ghostlaunched;
	var_00.var_1581[3] = ::scripts/aitypes/zombie_ghost/behaviors::ghostentangled;
	var_00.var_1581[4] = ::scripts/aitypes/zombie_ghost/behaviors::ghosthover;
	var_00.var_1581[5] = ::scripts/aitypes/zombie_ghost/behaviors::checkattack;
	var_00.var_1581[6] = ::scripts/aitypes/zombie_ghost/behaviors::chaseenemy;
	var_00.var_1581[7] = ::scripts/aitypes/zombie_ghost/behaviors::seekenemy;
	var_00.var_1581[8] = ::scripts/aitypes/zombie_ghost/behaviors::ghosthide;
	var_00.var_1581[9] = ::scripts/aitypes/zombie_ghost/behaviors::notargetfound;
	level.var_119E["zombie_ghost"] = var_00;
}

//Function Number: 2
func_DEE8()
{
	func_2AD0();
	function_02D8("zombie_ghost");
}
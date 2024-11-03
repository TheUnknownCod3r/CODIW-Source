/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 2863.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:24:20 AM
*******************************************************************/

//Function Number: 1
func_9752()
{
	if(!isdefined(level.flag))
	{
		scripts\common\flags::init_flags();
	}
	else
	{
		var_00 = getarraykeys(level.flag);
		scripts\engine\utility::array_levelthread(var_00,::func_3D74);
	}

	scripts\engine\utility::flag_init("auto_adjust_initialized");
	if(!scripts\engine\utility::flag_exist("load_finished"))
	{
		scripts\engine\utility::flag_init("load_finished");
	}

	if(!scripts\engine\utility::flag_exist("scriptables_ready"))
	{
		scripts\engine\utility::flag_init("scriptables_ready");
	}
}

//Function Number: 2
func_3D74(param_00)
{
	if(getsubstr(param_00,0,3) != "aa_")
	{
		return;
	}

	[[ level.func["sp_stat_tracking_func"] ]](param_00);
}
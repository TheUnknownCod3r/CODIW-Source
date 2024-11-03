/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\common\scriptable.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 67 ms
 * Timestamp: 10/27/2023 12:23:27 AM
*******************************************************************/

//Function Number: 1
func_EF33(param_00)
{
	level.var_EF2E = param_00;
}

//Function Number: 2
func_028A()
{
	if(isdefined(level.var_EF2E))
	{
		[[ level.var_EF2E ]]();
	}

	if(scripts\engine\utility::issp())
	{
		if(!scripts\engine\utility::flag_exist("scriptables_ready"))
		{
			scripts\engine\utility::flag_init("scriptables_ready");
		}

		scripts\engine\utility::flag_set("scriptables_ready");
	}
}
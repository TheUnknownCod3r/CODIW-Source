/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\engine\_flags.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 143 ms
 * Timestamp: 10/27/2023 12:10:48 AM
*******************************************************************/

//Function Number: 1
init_flags()
{
	if(!scripts\engine\utility::add_init_script("init_flags",::init_flags))
	{
		return;
	}

	level.flag = [];
	level.flags_lock = [];
	level.generic_index = 0;
	scripts\engine\utility::init_empty_func_ref_MAYBE("sp_stat_tracking_func");
	level.flag_struct = spawnstruct();
	level.flag_struct assign_unique_id();
}

//Function Number: 2
assign_unique_id()
{
	self.unique_id = "generic" + level.generic_index;
	level.var_7763++;
}
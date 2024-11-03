/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\_alien_agents.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 35 ms
 * Timestamp: 10/27/2023 12:23:14 AM
*******************************************************************/

//Function Number: 1
main()
{
	if(isdefined(level.createfx_enabled) && level.createfx_enabled)
	{
		return;
	}

	level.badplace_cylinder_func = ::badplace_cylinder;
	level.badplace_delete_func = ::badplace_delete;
	level thread scripts\mp\agents\_agent_common::init();
	level.var_10A2A = 0;
}
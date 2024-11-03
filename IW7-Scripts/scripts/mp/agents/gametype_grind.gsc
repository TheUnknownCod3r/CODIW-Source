/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\gametype_grind.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 134 ms
 * Timestamp: 10/27/2023 12:11:34 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
}

//Function Number: 2
setup_callbacks()
{
	level.agent_funcs["squadmate"]["gametype_update"] = ::scripts\mp\agents\gametype_conf::agent_squadmember_conf_think;
	level.agent_funcs["player"]["think"] = ::scripts\mp\agents\gametype_conf::agent_player_conf_think;
}
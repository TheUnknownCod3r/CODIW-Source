/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\gametype_sd.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 3
 * Decompile Time: 185 ms
 * Timestamp: 10/27/2023 12:11:38 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
}

//Function Number: 2
setup_callbacks()
{
	level.agent_funcs["player"]["think"] = ::agent_player_sd_think;
}

//Function Number: 3
agent_player_sd_think()
{
	scripts\engine\utility::allow_usability(1);
	thread scripts\mp\bots\gametype_sd::bot_sd_think();
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 4307.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 1
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:32:04 AM
*******************************************************************/

//Function Number: 1
main()
{
	var_00 = scripts\engine\utility::createoneshoteffect("vfx_front_end_steam_flyby");
	var_00 scripts\common\createfx::set_origin_and_angles((35.0684,-6289.31,333.622),(0,96,0));
	var_00.v["fxid"] = "vfx_front_end_steam_flyby";
	var_00.v["delay"] = -4;
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\bots\gametype_gun.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 142 ms
 * Timestamp: 10/27/2023 12:11:59 AM
*******************************************************************/

//Function Number: 1
main()
{
	level.bot_funcs["gametype_think"] = ::bot_gun_think;
}

//Function Number: 2
bot_gun_think()
{
	var_00 = self botgetdifficultysetting("throwKnifeChance");
	if(var_00 < 0.25)
	{
		self getpassivestruct("throwKnifeChance",0.25);
	}

	self getpassivestruct("allowGrenades",1);
}
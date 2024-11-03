/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\playercards.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 100 ms
 * Timestamp: 10/27/2023 12:21:12 AM
*******************************************************************/

//Function Number: 1
init()
{
	level thread onplayerconnect();
}

//Function Number: 2
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		if(!isai(var_00))
		{
			var_00.weaponfiretime = var_00 getplayerdata(level.loadoutsgroup,"squadMembers","patch");
			var_00.weaponhasthermalscope = var_00 getplayerdata(level.loadoutsgroup,"squadMembers","patchbacking");
			var_00.weaponfightdist = var_00 getplayerdata(level.loadoutsgroup,"squadMembers","background");
		}
	}
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\code\struct.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 2
 * Decompile Time: 131 ms
 * Timestamp: 10/27/2023 12:03:07 AM
*******************************************************************/

//Function Number: 1
initstructs()
{
	level.struct = [];
}

//Function Number: 2
createstruct()
{
	var_00 = spawnstruct();
	level.struct[level.struct.size] = var_00;
	return var_00;
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3414.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 0 ms
 * Timestamp: 10/27/2023 12:27:08 AM
*******************************************************************/

//Function Number: 1
init()
{
	if(!isdefined(game["clientMatchDataDef"]))
	{
		game["clientMatchDataDef"] = "mp/zombieclientmatchdata.ddl";
		function_01A9(game["clientMatchDataDef"]);
		setclientmatchdata("map",level.script);
	}

	level.maxdeathlogs = 50;
}

//Function Number: 2
canlogclient(param_00)
{
	if(isagent(param_00))
	{
		return 0;
	}

	return param_00.clientid < level.maxlogclients;
}

//Function Number: 3
canlogdeath(param_00)
{
	return param_00 < level.maxdeathlogs;
}

//Function Number: 4
logplayerdeath()
{
	var_00 = function_0080("deathCount");
	if(!canlogclient(self) || !canlogdeath(var_00))
	{
	}
}
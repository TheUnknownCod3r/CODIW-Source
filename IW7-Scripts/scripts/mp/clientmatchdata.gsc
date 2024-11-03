/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\clientmatchdata.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 247 ms
 * Timestamp: 10/27/2023 12:14:52 AM
*******************************************************************/

//Function Number: 1
init()
{
	if(!isdefined(game["clientMatchDataDef"]))
	{
		game["clientMatchDataDef"] = "mp/clientmatchdata.ddl";
		function_01A9(game["clientMatchDataDef"]);
		setclientmatchdata("map",level.script);
	}

	level.maxdeathlogs = 200;
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
logplayerdeath(param_00)
{
	var_01 = function_0080("deathCount");
	if(!canlogclient(self) || !canlogdeath(var_01))
	{
		return;
	}

	if(isplayer(param_00) && canlogclient(param_00))
	{
		self getufolightcolor(var_01,self.clientid,param_00,param_00.clientid);
		return;
	}

	self getufolightcolor(var_01,self.clientid,undefined,undefined);
}
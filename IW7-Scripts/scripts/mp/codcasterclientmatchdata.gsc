/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\codcasterclientmatchdata.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 10
 * Decompile Time: 930 ms
 * Timestamp: 10/27/2023 12:14:53 AM
*******************************************************************/

//Function Number: 1
shouldlogcodcasterclientmatchdata()
{
	return getdvarint("com_codcasterEnabled",0) == 1 && getdvarint("systemlink");
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
createcodcastermatchdataforplayer(param_00)
{
	var_01 = [];
	foreach(var_03 in level.codcastermatchdata.playerfields)
	{
		var_01[var_03[0]] = var_03[1];
	}

	return var_01;
}

//Function Number: 4
removeplayerdataafterleavinggame(param_00)
{
	level endon("game_ended");
	param_00 waittill("disconnect");
	if(!isdefined(level.codcastermatchdata.players[param_00.clientid]))
	{
		return;
	}

	level.codcastermatchdata.players[param_00.clientid] = undefined;
}

//Function Number: 5
checkcodcasterplayerdataexists(param_00)
{
	if(!isdefined(level.codcastermatchdata.players[param_00.clientid]))
	{
		var_01 = createcodcastermatchdataforplayer(param_00);
		level.codcastermatchdata.players[param_00.clientid] = var_01;
		thread removeplayerdataafterleavinggame(param_00);
	}
}

//Function Number: 6
init()
{
	function_0310("map",level.script);
	var_00 = spawnstruct();
	var_00.playerfields = [["damageDone",0],["longestKillstreak",0],["shutdowns",0],["gametypePoints",0]];
	var_00.players = [];
	level.codcastermatchdata = var_00;
}

//Function Number: 7
setddlfieldsforplayer(param_00)
{
	foreach(var_02 in level.codcastermatchdata.playerfields)
	{
		function_0310("players",param_00.codcastermatchdataid,var_02[0],level.codcastermatchdata.players[param_00.clientid][var_02[0]]);
	}

	function_0310("players",param_00.codcastermatchdataid,"username",param_00.name);
}

//Function Number: 8
sendcodcastermatchdata()
{
	var_00 = 0;
	foreach(var_02 in level.players)
	{
		checkcodcasterplayerdataexists(var_02);
		var_02.codcastermatchdataid = var_00;
		setddlfieldsforplayer(var_02);
		var_00++;
	}

	function_0312();
}

//Function Number: 9
setcodcasterplayervalue(param_00,param_01,param_02)
{
	if(!canlogclient(param_00))
	{
		return;
	}

	checkcodcasterplayerdataexists(param_00);
	var_03 = level.codcastermatchdata.players[param_00.clientid];
	if(!isdefined(var_03) || !isdefined(var_03[param_01]))
	{
		return;
	}

	level.codcastermatchdata.players[param_00.clientid][param_01] = param_02;
}

//Function Number: 10
getcodcasterplayervalue(param_00,param_01)
{
	if(!canlogclient(param_00))
	{
		return;
	}

	checkcodcasterplayerdataexists(param_00);
	var_02 = level.codcastermatchdata.players[param_00.clientid];
	if(!isdefined(var_02) || !isdefined(var_02[param_01]))
	{
		return;
	}

	return var_02[param_01];
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\agents\gametype_assault.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 240 ms
 * Timestamp: 10/27/2023 12:11:31 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
}

//Function Number: 2
setup_callbacks()
{
	level.agent_funcs["squadmate"]["gametype_update"] = ::agent_squadmember_dom_think;
	level.agent_funcs["player"]["think"] = ::agent_player_dom_think;
}

//Function Number: 3
agent_player_dom_think()
{
	thread scripts\mp\bots\gametype_dom::bot_dom_think();
}

//Function Number: 4
agent_squadmember_dom_think()
{
	var_00 = undefined;
	foreach(var_02 in self.triggerportableradarping.touchtriggers)
	{
		if(var_02.useobj.id == "domFlag")
		{
			var_00 = var_02;
		}
	}

	if(isdefined(var_00))
	{
		var_04 = var_00 scripts\mp\gametypes\dom::getflagteam();
		if(var_04 != self.team)
		{
			if(!scripts\mp\bots\gametype_dom::bot_is_capturing_flag(var_00))
			{
				scripts\mp\bots\gametype_dom::capture_flag(var_00,"critical",1);
			}

			return 1;
		}
	}

	return 0;
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\bots\gametype_grnd.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 414 ms
 * Timestamp: 10/27/2023 12:11:59 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
	setup_bot_grnd();
}

//Function Number: 2
setup_callbacks()
{
	level.bot_funcs["gametype_think"] = ::bot_grnd_think;
}

//Function Number: 3
setup_bot_grnd()
{
	scripts\mp\bots\_bots_util::bot_waittill_bots_enabled(1);
	level.protect_radius = 128;
	level.bot_gametype_precaching_done = 1;
}

//Function Number: 4
bot_grnd_think()
{
	self notify("bot_grnd_think");
	self endon("bot_grnd_think");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self botclearscriptgoal();
	while(!isdefined(level.bot_gametype_precaching_done))
	{
		wait(0.05);
	}

	self botsetflag("separation",0);
	thread clear_defend();
	for(;;)
	{
		wait(0.05);
		if(scripts\mp\bots\_bots_strategy::bot_has_tactical_goal())
		{
			continue;
		}

		if(!self bothasscriptgoal())
		{
			var_00 = getnodeinzone();
			if(isdefined(var_00))
			{
				self botsetscriptgoal(var_00.origin,0,"objective");
			}

			continue;
		}

		if(!scripts\mp\bots\_bots_util::bot_is_defending())
		{
			self botclearscriptgoal();
			var_00 = getnodeinzone();
			if(isdefined(var_00))
			{
				scripts\mp\bots\_bots_strategy::bot_protect_point(var_00.origin,level.protect_radius);
			}
		}
	}
}

//Function Number: 5
clear_defend()
{
	for(;;)
	{
		level waittill("zone_reset");
		if(scripts\mp\bots\_bots_util::bot_is_defending())
		{
			scripts\mp\bots\_bots_strategy::bot_defend_stop();
		}
	}
}

//Function Number: 6
getnodeinzone()
{
	var_00 = function_00B7(level.zone.gameobject.trigger);
	if(var_00.size == 0 || !isdefined(var_00))
	{
		return undefined;
	}

	var_01 = randomintrange(0,var_00.size);
	var_02 = var_00[var_01];
	return var_02;
}

//Function Number: 7
temp()
{
}
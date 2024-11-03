/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\serversettings.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 4
 * Decompile Time: 208 ms
 * Timestamp: 10/27/2023 12:21:29 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.var_90AE = function_02D2();
	setfriendlyfire(scripts\mp\tweakables::gettweakablevalue("team","fftype"));
	constraingametype(getdvar("g_gametype"));
	for(;;)
	{
		updateserversettings();
		wait(5);
	}
}

//Function Number: 2
updateserversettings()
{
	var_00 = scripts\mp\tweakables::gettweakablevalue("team","fftype");
	if(level.friendlyfire != var_00)
	{
		setfriendlyfire(var_00);
	}
}

//Function Number: 3
constraingametype(param_00)
{
	var_01 = getentarray();
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		var_03 = var_01[var_02];
		if(param_00 == "dm")
		{
			if(isdefined(var_03.script_gametype_dm) && var_03.script_gametype_dm != "1")
			{
				var_03 delete();
			}

			continue;
		}

		if(param_00 == "tdm")
		{
			if(isdefined(var_03.script_gametype_tdm) && var_03.script_gametype_tdm != "1")
			{
				var_03 delete();
			}

			continue;
		}

		if(param_00 == "ctf")
		{
			if(isdefined(var_03.script_gametype_ctf) && var_03.script_gametype_ctf != "1")
			{
				var_03 delete();
			}

			continue;
		}

		if(param_00 == "hq")
		{
			if(isdefined(var_03.script_gametype_hq) && var_03.script_gametype_hq != "1")
			{
				var_03 delete();
			}

			continue;
		}

		if(param_00 == "sd")
		{
			if(isdefined(var_03.script_gametype_sd) && var_03.script_gametype_sd != "1")
			{
				var_03 delete();
			}

			continue;
		}

		if(param_00 == "koth")
		{
			if(isdefined(var_03.script_gametype_koth) && var_03.script_gametype_koth != "1")
			{
				var_03 delete();
			}
		}
	}
}

//Function Number: 4
setfriendlyfire(param_00)
{
	level.friendlyfire = param_00;
	setdvar("ui_friendlyfire",param_00);
	setdvar("cg_drawFriendlyHUDGrenades",param_00);
}
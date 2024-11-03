/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\friendicons.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 282 ms
 * Timestamp: 10/27/2023 12:20:17 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.drawfriend = 0;
	game["headicon_allies"] = scripts\mp\teams::_meth_81B0("allies");
	game["headicon_axis"] = scripts\mp\teams::_meth_81B0("axis");
	precacheheadicon(game["headicon_allies"]);
	precacheheadicon(game["headicon_axis"]);
	precacheshader("waypoint_revive");
	level thread onplayerconnect();
	for(;;)
	{
		updatefriendiconsettings();
		wait(5);
	}
}

//Function Number: 2
onplayerconnect()
{
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 thread onplayerspawned();
		var_00 thread onplayerkilled();
	}
}

//Function Number: 3
onplayerspawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		thread showfriendicon();
	}
}

//Function Number: 4
onplayerkilled()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("killed_player");
		self.playerphysicstrace = "";
	}
}

//Function Number: 5
showfriendicon()
{
	if(level.drawfriend)
	{
		if(self.pers["team"] == "allies")
		{
			self.playerphysicstrace = game["headicon_allies"];
			self.playfx = "allies";
			return;
		}

		self.playerphysicstrace = game["headicon_axis"];
		self.playfx = "axis";
	}
}

//Function Number: 6
updatefriendiconsettings()
{
	var_00 = scripts\mp\utility::getintproperty("scr_drawfriend",level.drawfriend);
	if(level.drawfriend != var_00)
	{
		level.drawfriend = var_00;
		updatefriendicons();
	}
}

//Function Number: 7
updatefriendicons()
{
	var_00 = level.players;
	for(var_01 = 0;var_01 < var_00.size;var_01++)
	{
		var_02 = var_00[var_01];
		if(isdefined(var_02.pers["team"]) && var_02.pers["team"] != "spectator" && var_02.sessionstate == "playing")
		{
			if(level.drawfriend)
			{
				if(var_02.pers["team"] == "allies")
				{
					var_02.playerphysicstrace = game["headicon_allies"];
					var_02.playfx = "allies";
				}
				else
				{
					var_02.playerphysicstrace = game["headicon_axis"];
					var_02.playfx = "axis";
				}

				continue;
			}

			var_00 = level.players;
			for(var_01 = 0;var_01 < var_00.size;var_01++)
			{
				var_02 = var_00[var_01];
				if(isdefined(var_02.pers["team"]) && var_02.pers["team"] != "spectator" && var_02.sessionstate == "playing")
				{
					var_02.playerphysicstrace = "";
				}
			}
		}
	}
}
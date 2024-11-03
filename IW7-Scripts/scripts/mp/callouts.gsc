/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\callouts.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 511 ms
 * Timestamp: 10/27/2023 12:14:42 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.calloutglobals = spawnstruct();
	level.calloutglobals.callouttable = "mp/map_callouts/" + level.mapname + "_callouts.csv";
	createcalloutareaidmap();
	level.calloutglobals.areatriggers = getentarray("callout_area","targetname");
	foreach(var_01 in level.calloutglobals.areatriggers)
	{
		var_01 thread calloutareathink();
	}

	thread monitorplayers();
}

//Function Number: 2
createcalloutareaidmap()
{
	var_00 = level.calloutglobals;
	var_00.areaidmap = [];
	var_00.areaidmap["none"] = -1;
	var_01 = 0;
	for(;;)
	{
		var_02 = tablelookupbyrow(level.calloutglobals.callouttable,var_01,0);
		if(!isdefined(var_02) || var_02 == "")
		{
			break;
		}

		var_02 = int(var_02);
		var_03 = tablelookupbyrow(level.calloutglobals.callouttable,var_01,3);
		if(var_03 != "area")
		{
		}
		else
		{
			var_04 = tablelookupbyrow(level.calloutglobals.callouttable,var_01,1);
			var_00.areaidmap[var_04] = var_02;
		}

		var_01++;
	}
}

//Function Number: 3
monitorplayers()
{
	level endon("game_ended");
	for(;;)
	{
		level waittill("connected",var_00);
		var_00 setplayercalloutarea("none");
	}
}

//Function Number: 4
calloutareathink()
{
	level endon("game_ended");
	for(;;)
	{
		self waittill("trigger",var_00);
		if(!isplayer(var_00))
		{
			continue;
		}

		var_00 setplayercalloutarea(self.script_noteworthy,self);
	}
}

//Function Number: 5
setplayercalloutarea(param_00,param_01)
{
	if(isdefined(self.calloutarea) && self.calloutarea == param_00)
	{
		return;
	}

	if(isdefined(self.calloutarea) && param_00 != "none" && self.calloutarea != "none")
	{
		return;
	}

	self.calloutarea = param_00;
	if(isdefined(param_01))
	{
		thread watchplayerleavingcalloutarea(param_01,param_01.script_noteworthy);
	}

	var_02 = level.calloutglobals.areaidmap[param_00];
	if(isdefined(var_02))
	{
		self setclientomnvar("ui_callout_area_id",var_02);
		var_03 = scripts\mp\utility::get_players_watching(1,0);
		foreach(var_05 in var_03)
		{
			if(var_05 ismlgspectator())
			{
				var_05 setclientomnvar("ui_callout_area_id",var_02);
			}
		}

		return;
	}

	if(param_00 != "none")
	{
	}
}

//Function Number: 6
watchplayerleavingcalloutarea(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	thread clearcalloutareaondeath();
	for(;;)
	{
		if(self.calloutarea != param_01)
		{
			return;
		}

		if(!self istouching(param_00))
		{
			setplayercalloutarea("none");
			return;
		}

		wait(0.5);
	}
}

//Function Number: 7
clearcalloutareaondeath()
{
	self endon("disconnect");
	self waittill("death");
	setplayercalloutarea("none");
}
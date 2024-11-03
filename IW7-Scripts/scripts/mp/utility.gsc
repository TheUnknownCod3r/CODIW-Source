/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\utility.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 586
 * Decompile Time: 22083 ms
 * Timestamp: 10/27/2023 12:22:13 AM
*******************************************************************/

//Function Number: 1
exploder_sound()
{
	if(isdefined(self.script_delay))
	{
		wait(self.script_delay);
	}

	self playsound(level.scr_sound[self.script_sound]);
}

//Function Number: 2
_beginlocationselection(param_00,param_01,param_02,param_03)
{
	self beginlocationselection(param_01,param_02,0,param_03);
	self.selectinglocation = 1;
	self setblurforplayer(10.3,0.3);
	thread endselectiononaction("cancel_location");
	thread endselectiononaction("death");
	thread endselectiononaction("disconnect");
	thread endselectiononaction("used");
	thread endselectiononaction("weapon_change");
	self endon("stop_location_selection");
	thread endselectiononendgame();
	thread endselectiononemp();
	if(isdefined(param_00) && self.team != "spectator")
	{
		if(isdefined(self.var_110E9))
		{
			self.var_110E9 destroy();
		}

		if(self issplitscreenplayer())
		{
			self.var_110E9 = scripts\mp\hud_util::createfontstring("default",1.3);
			self.var_110E9 scripts\mp\hud_util::setpoint("CENTER","CENTER",0,-98);
		}
		else
		{
			self.var_110E9 = scripts\mp\hud_util::createfontstring("default",1.6);
			self.var_110E9 scripts\mp\hud_util::setpoint("CENTER","CENTER",0,-190);
		}

		var_04 = func_7F47(param_00);
		self.var_110E9 settext(var_04);
	}
}

//Function Number: 3
stoplocationselection(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = "generic";
	}

	if(!param_00)
	{
		self setblurforplayer(0,0.3);
		self _meth_80DE();
		self.selectinglocation = undefined;
		if(isdefined(self.var_110E9))
		{
			self.var_110E9 destroy();
		}
	}

	self notify("stop_location_selection",param_01);
}

//Function Number: 4
endselectiononemp()
{
	self endon("stop_location_selection");
	for(;;)
	{
		level waittill("emp_update");
		if(!scripts\mp\killstreaks\_emp_common::isemped())
		{
			continue;
		}

		thread stoplocationselection(0,"emp");
	}
}

//Function Number: 5
endselectiononaction(param_00)
{
	self endon("stop_location_selection");
	self waittill(param_00);
	thread stoplocationselection(param_00 == "disconnect",param_00);
}

//Function Number: 6
endselectiononendgame()
{
	self endon("stop_location_selection");
	level waittill("game_ended");
	thread stoplocationselection(0,"end_game");
}

//Function Number: 7
isattachment(param_00)
{
	var_01 = tablelookup("mp/attachmentTable.csv",4,param_00,0);
	if(isdefined(var_01) && var_01 != "")
	{
		return 1;
	}

	return 0;
}

//Function Number: 8
getattachmenttype(param_00)
{
	var_01 = tablelookup("mp/attachmentTable.csv",4,param_00,2);
	return var_01;
}

//Function Number: 9
func_2287(param_00,param_01)
{
	foreach(var_04, var_03 in param_00)
	{
		if(var_04 == param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 10
getplant()
{
	var_00 = self.origin + (0,0,10);
	var_01 = 11;
	var_02 = anglestoforward(self.angles);
	var_02 = var_02 * var_01;
	var_03[0] = var_00 + var_02;
	var_03[1] = var_00;
	var_04 = bullettrace(var_03[0],var_03[0] + (0,0,-18),0,undefined);
	if(var_04["fraction"] < 1)
	{
		var_05 = spawnstruct();
		var_05.origin = var_04["position"];
		var_05.angles = orienttonormal(var_04["normal"]);
		return var_05;
	}

	var_05 = bullettrace(var_04[1],var_04[1] + (0,0,-18),0,undefined);
	if(var_05["fraction"] < 1)
	{
		var_05 = spawnstruct();
		var_05.origin = var_04["position"];
		var_05.angles = orienttonormal(var_04["normal"]);
		return var_05;
	}

	var_04[2] = var_01 + (16,16,0);
	var_04[3] = var_01 + (16,-16,0);
	var_04[4] = var_01 + (-16,-16,0);
	var_04[5] = var_01 + (-16,16,0);
	var_06 = undefined;
	var_07 = undefined;
	for(var_08 = 0;var_08 < var_04.size;var_08++)
	{
		var_05 = bullettrace(var_04[var_08],var_04[var_08] + (0,0,-1000),0,undefined);
		if(!isdefined(var_06) || var_05["fraction"] < var_06)
		{
			var_06 = var_05["fraction"];
			var_07 = var_05["position"];
		}
	}

	if(var_06 == 1)
	{
		var_07 = self.origin;
	}

	var_05 = spawnstruct();
	var_08.origin = var_06;
	var_08.angles = orienttonormal(var_04["normal"]);
	return var_08;
}

//Function Number: 11
orienttonormal(param_00)
{
	var_01 = (param_00[0],param_00[1],0);
	var_02 = length(var_01);
	if(!var_02)
	{
		return (0,0,0);
	}

	var_03 = vectornormalize(var_01);
	var_04 = param_00[2] * -1;
	var_05 = (var_03[0] * var_04,var_03[1] * var_04,var_02);
	var_06 = vectortoangles(var_05);
	return var_06;
}

//Function Number: 12
deleteplacedentity(param_00)
{
	var_01 = getentarray(param_00,"classname");
	for(var_02 = 0;var_02 < var_01.size;var_02++)
	{
		var_01[var_02] delete();
	}
}

//Function Number: 13
playsoundonplayers(param_00,param_01,param_02)
{
	if(level.splitscreen)
	{
		if(isdefined(level.players[0]))
		{
			level.players[0] playlocalsound(param_00);
			return;
		}

		return;
	}

	if(isdefined(param_01))
	{
		if(isdefined(param_02))
		{
			for(var_03 = 0;var_03 < level.players.size;var_03++)
			{
				var_04 = level.players[var_03];
				if(var_04 issplitscreenplayer() && !var_04 issplitscreenplayerprimary())
				{
					continue;
				}

				if(isdefined(var_04.pers["team"]) && var_04.pers["team"] == param_01 && !isexcluded(var_04,param_02))
				{
					var_04 playlocalsound(param_00);
				}
			}

			return;
		}

		for(var_03 = 0;var_03 < level.players.size;var_03++)
		{
			var_04 = level.players[var_03];
			if(var_04 issplitscreenplayer() && !var_04 issplitscreenplayerprimary())
			{
				continue;
			}

			if(isdefined(var_04.pers["team"]) && var_04.pers["team"] == param_01)
			{
				var_04 playlocalsound(param_00);
			}
		}

		return;
	}

	if(isdefined(var_03))
	{
		for(var_03 = 0;var_03 < level.players.size;var_03++)
		{
			if(level.players[var_03] issplitscreenplayer() && !level.players[var_03] issplitscreenplayerprimary())
			{
				continue;
			}

			if(!isexcluded(level.players[var_03],param_02))
			{
				level.players[var_03] playlocalsound(param_00);
			}
		}

		return;
	}

	for(var_03 = 0;var_03 < level.players.size;var_03++)
	{
		if(level.players[var_03] issplitscreenplayer() && !level.players[var_03] issplitscreenplayerprimary())
		{
			continue;
		}

		level.players[var_03] playlocalsound(param_00);
	}
}

//Function Number: 14
sortlowermessages()
{
	for(var_00 = 1;var_00 < self.lowermessages.size;var_00++)
	{
		var_01 = self.lowermessages[var_00];
		var_02 = var_01.priority;
		for(var_03 = var_00 - 1;var_03 >= 0 && var_02 > self.lowermessages[var_03].priority;var_03--)
		{
			self.lowermessages[var_03 + 1] = self.lowermessages[var_03];
		}

		self.lowermessages[var_03 + 1] = var_01;
	}
}

//Function Number: 15
addlowermessage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	var_0A = undefined;
	foreach(var_0C in self.lowermessages)
	{
		if(var_0C.name == param_00)
		{
			if(var_0C.text == param_01 && var_0C.priority == param_03)
			{
				return;
			}

			var_0A = var_0C;
			break;
		}
	}

	if(!isdefined(var_0A))
	{
		var_0A = spawnstruct();
		self.lowermessages[self.lowermessages.size] = var_0A;
	}

	var_0A.name = param_00;
	var_0A.text = param_01;
	var_0A.time = param_02;
	var_0A.addtime = gettime();
	var_0A.priority = param_03;
	var_0A.showtimer = param_04;
	var_0A.shouldfade = param_05;
	var_0A.fadetoalphatime = param_06;
	var_0A.fadetoalphatime = param_07;
	var_0A.hidewhenindemo = param_08;
	var_0A.hidewheninmenu = param_09;
	sortlowermessages();
}

//Function Number: 16
removelowermessage(param_00)
{
	if(isdefined(self.lowermessages))
	{
		for(var_01 = self.lowermessages.size;var_01 > 0;var_01--)
		{
			if(self.lowermessages[var_01 - 1].name != param_00)
			{
				continue;
			}

			var_02 = self.lowermessages[var_01 - 1];
			for(var_03 = var_01;var_03 < self.lowermessages.size;var_03++)
			{
				if(isdefined(self.lowermessages[var_03]))
				{
					self.lowermessages[var_03 - 1] = self.lowermessages[var_03];
				}
			}

			self.lowermessages[self.lowermessages.size - 1] = undefined;
		}

		sortlowermessages();
	}
}

//Function Number: 17
getlowermessage()
{
	if(!isdefined(self.lowermessages))
	{
		return undefined;
	}

	return self.lowermessages[0];
}

//Function Number: 18
setlowermessage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(!isdefined(param_03))
	{
		param_03 = 1;
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	if(!isdefined(param_04))
	{
		param_04 = 0;
	}

	if(!isdefined(param_05))
	{
		param_05 = 0;
	}

	if(!isdefined(param_06))
	{
		param_06 = 0.85;
	}

	if(!isdefined(param_07))
	{
		param_07 = 3;
	}

	if(!isdefined(param_08))
	{
		param_08 = 0;
	}

	if(!isdefined(param_09))
	{
		param_09 = 1;
	}

	addlowermessage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09);
	updatelowermessage();
}

//Function Number: 19
updatelowermessage()
{
	if(!isdefined(self))
	{
		return;
	}

	var_00 = getlowermessage();
	if(!isdefined(var_00))
	{
		if(isdefined(self.lowermessage) && isdefined(self.lowertimer))
		{
			self.lowermessage.alpha = 0;
			self.lowertimer.alpha = 0;
		}

		return;
	}

	self.lowermessage settext(var_00.text);
	self.lowermessage.alpha = 0.85;
	self.lowertimer.alpha = 1;
	self.lowermessage.hidewhenindemo = var_00.hidewhenindemo;
	self.lowermessage.hidewheninmenu = var_00.hidewheninmenu;
	if(var_00.shouldfade)
	{
		self.lowermessage fadeovertime(min(var_00.fadetoalphatime,60));
		self.lowermessage.alpha = var_00.fadetoalphatime;
	}

	if(var_00.time > 0 && var_00.showtimer)
	{
		self.lowertimer settimer(max(var_00.time - gettime() - var_00.addtime / 1000,0.1));
		return;
	}

	if(var_00.time > 0 && !var_00.showtimer)
	{
		self.lowertimer settext("");
		self.lowermessage fadeovertime(min(var_00.time,60));
		self.lowermessage.alpha = 0;
		thread clearondeath(var_00);
		thread clearafterfade(var_00);
		return;
	}

	self.lowertimer settext("");
}

//Function Number: 20
clearondeath(param_00)
{
	self notify("message_cleared");
	self endon("message_cleared");
	self endon("disconnect");
	level endon("game_ended");
	self waittill("death");
	clearlowermessage(param_00.name);
}

//Function Number: 21
clearafterfade(param_00)
{
	wait(param_00.time);
	clearlowermessage(param_00.name);
	self notify("message_cleared");
}

//Function Number: 22
clearlowermessage(param_00)
{
	removelowermessage(param_00);
	updatelowermessage();
}

//Function Number: 23
clearlowermessages()
{
	for(var_00 = 0;var_00 < self.lowermessages.size;var_00++)
	{
		self.lowermessages[var_00] = undefined;
	}

	if(!isdefined(self.lowermessage))
	{
		return;
	}

	updatelowermessage();
}

//Function Number: 24
printonteam(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(var_03.team != param_01)
		{
			continue;
		}

		var_03 iprintln(param_00);
	}
}

//Function Number: 25
printboldonteam(param_00,param_01)
{
	for(var_02 = 0;var_02 < level.players.size;var_02++)
	{
		var_03 = level.players[var_02];
		if(isdefined(var_03.pers["team"]) && var_03.pers["team"] == param_01)
		{
			var_03 iprintlnbold(param_00);
		}
	}
}

//Function Number: 26
printboldonteamarg(param_00,param_01,param_02)
{
	for(var_03 = 0;var_03 < level.players.size;var_03++)
	{
		var_04 = level.players[var_03];
		if(isdefined(var_04.pers["team"]) && var_04.pers["team"] == param_01)
		{
			var_04 iprintlnbold(param_00,param_02);
		}
	}
}

//Function Number: 27
printonteamarg(param_00,param_01,param_02)
{
	for(var_03 = 0;var_03 < level.players.size;var_03++)
	{
		var_04 = level.players[var_03];
		if(isdefined(var_04.pers["team"]) && var_04.pers["team"] == param_01)
		{
			var_04 iprintln(param_00,param_02);
		}
	}
}

//Function Number: 28
printonplayers(param_00,param_01)
{
	var_02 = level.players;
	for(var_03 = 0;var_03 < var_02.size;var_03++)
	{
		if(isdefined(param_01))
		{
			if(isdefined(var_02[var_03].pers["team"]) && var_02[var_03].pers["team"] == param_01)
			{
				var_02[var_03] iprintln(param_00);
			}

			continue;
		}

		var_02[var_03] iprintln(param_00);
	}
}

//Function Number: 29
printandsoundoneveryone(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = isdefined(param_04);
	var_08 = 0;
	if(isdefined(param_05))
	{
		var_08 = 1;
	}

	if(level.splitscreen || !var_07)
	{
		for(var_09 = 0;var_09 < level.players.size;var_09++)
		{
			var_0A = level.players[var_09];
			var_0B = var_0A.team;
			if(isdefined(var_0B))
			{
				if(var_0B == param_00 && isdefined(param_02))
				{
					var_0A iprintln(param_02,param_06);
					continue;
				}

				if(var_0B == param_01 && isdefined(param_03))
				{
					var_0A iprintln(param_03,param_06);
				}
			}
		}

		if(var_07)
		{
			level.players[0] playlocalsound(param_04);
			return;
		}

		return;
	}

	if(var_0B)
	{
		for(var_09 = 0;var_09 < level.players.size;var_09++)
		{
			var_0A = level.players[var_09];
			var_0B = var_0A.team;
			if(isdefined(var_0B))
			{
				if(var_0B == param_00)
				{
					if(isdefined(param_02))
					{
						var_0A iprintln(param_02,param_06);
					}

					var_0A playlocalsound(param_04);
					continue;
				}

				if(var_0B == param_01)
				{
					if(isdefined(param_03))
					{
						var_0A iprintln(param_03,param_06);
					}

					var_0A playlocalsound(param_05);
				}
			}
		}

		return;
	}

	for(var_09 = 0;var_09 < level.players.size;var_09++)
	{
		var_0A = level.players[var_09];
		var_0B = var_0A.team;
		if(isdefined(var_0B))
		{
			if(var_0B == param_00)
			{
				if(isdefined(param_02))
				{
					var_0A iprintln(param_02,param_06);
				}

				var_0A playlocalsound(param_04);
				continue;
			}

			if(var_0B == param_01)
			{
				if(isdefined(param_03))
				{
					var_0A iprintln(param_03,param_06);
				}
			}
		}
	}
}

//Function Number: 30
printandsoundonteam(param_00,param_01,param_02)
{
	foreach(var_04 in level.players)
	{
		if(var_04.team != param_00)
		{
			continue;
		}

		var_04 printandsoundonplayer(param_01,param_02);
	}
}

//Function Number: 31
printandsoundonplayer(param_00,param_01)
{
	self iprintln(param_00);
	self playlocalsound(param_01);
}

//Function Number: 32
_playlocalsound(param_00)
{
	if(level.splitscreen && self getentitynumber() != 0)
	{
		return;
	}

	self playlocalsound(param_00);
}

//Function Number: 33
dvarintvalue(param_00,param_01,param_02,param_03)
{
	param_00 = "scr_" + level.gametype + "_" + param_00;
	if(getdvar(param_00) == "")
	{
		setdvar(param_00,param_01);
		return param_01;
	}

	var_04 = getdvarint(param_00);
	if(var_04 > param_03)
	{
		var_04 = param_03;
	}
	else if(var_04 < param_02)
	{
		var_04 = param_02;
	}
	else
	{
		return var_04;
	}

	setdvar(param_00,var_04);
	return var_04;
}

//Function Number: 34
dvarfloatvalue(param_00,param_01,param_02,param_03)
{
	param_00 = "scr_" + level.gametype + "_" + param_00;
	if(getdvar(param_00) == "")
	{
		setdvar(param_00,param_01);
		return param_01;
	}

	var_04 = getdvarfloat(param_00);
	if(var_04 > param_03)
	{
		var_04 = param_03;
	}
	else if(var_04 < param_02)
	{
		var_04 = param_02;
	}
	else
	{
		return var_04;
	}

	setdvar(param_00,var_04);
	return var_04;
}

//Function Number: 35
play_sound_on_tag(param_00,param_01)
{
	if(isdefined(param_01))
	{
		playsoundatpos(self gettagorigin(param_01),param_00);
		return;
	}

	playsoundatpos(self.origin,param_00);
}

//Function Number: 36
func_D526(param_00,param_01)
{
	if(isdefined(param_01))
	{
		playsoundatpos(param_01,param_00);
		var_02 = lookupsoundlength(param_00) / 1000;
		wait(var_02);
		return;
	}

	self playsound(param_01);
	var_02 = lookupsoundlength(param_01) / 1000;
	wait(var_02);
}

//Function Number: 37
getotherteam(param_00)
{
	if(level.multiteambased)
	{
	}

	if(param_00 == "allies")
	{
		return "axis";
	}
	else if(param_00 == "axis")
	{
		return "allies";
	}
	else
	{
		return "none";
	}
}

//Function Number: 38
wait_endon(param_00,param_01,param_02,param_03)
{
	self endon(param_01);
	if(isdefined(param_02))
	{
		self endon(param_02);
	}

	if(isdefined(param_03))
	{
		self endon(param_03);
	}

	wait(param_00);
}

//Function Number: 39
initpersstat(param_00)
{
	if(!isdefined(self.pers[param_00]))
	{
		self.pers[param_00] = 0;
	}
}

//Function Number: 40
getpersstat(param_00)
{
	return self.pers[param_00];
}

//Function Number: 41
incperstat(param_00,param_01,param_02)
{
	if(isdefined(self) && isdefined(self.pers) && isdefined(self.pers[param_00]))
	{
		self.pers[param_00] = self.pers[param_00] + param_01;
		if(!isdefined(param_02) || param_02 == 0)
		{
			scripts\mp\persistence::statadd(param_00,param_01);
		}
	}
}

//Function Number: 42
setpersstat(param_00,param_01)
{
	self.pers[param_00] = param_01;
}

//Function Number: 43
updatepersratio(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_03) || !rankingenabled())
	{
		return;
	}

	var_04 = scripts\mp\persistence::statget(param_01);
	var_05 = scripts\mp\persistence::statget(param_02);
	if(var_05 == 0)
	{
		var_05 = 1;
	}

	scripts\mp\persistence::func_10E54(param_00,int(var_04 * 1000 / var_05));
}

//Function Number: 44
func_12EE9(param_00,param_01,param_02)
{
	if(!rankingenabled())
	{
		return;
	}

	var_03 = scripts\mp\persistence::statgetbuffered(param_01);
	var_04 = scripts\mp\persistence::statgetbuffered(param_02);
	if(var_04 == 0)
	{
		var_04 = 1;
	}

	scripts\mp\persistence::func_10E55(param_00,int(var_03 * 1000 / var_04));
}

//Function Number: 45
func_13842(param_00)
{
	if(level.var_A9F1 == gettime())
	{
		if(isdefined(param_00) && param_00)
		{
			while(level.var_A9F1 == gettime())
			{
				wait(0.05);
			}
		}
		else
		{
			wait(0.05);
			if(level.var_A9F1 == gettime())
			{
				wait(0.05);
				if(level.var_A9F1 == gettime())
				{
					wait(0.05);
					if(level.var_A9F1 == gettime())
					{
						wait(0.05);
					}
				}
			}
		}
	}

	level.var_A9F1 = gettime();
}

//Function Number: 46
waitfortimeornotify(param_00,param_01)
{
	self endon(param_01);
	wait(param_00);
}

//Function Number: 47
isexcluded(param_00,param_01)
{
	for(var_02 = 0;var_02 < param_01.size;var_02++)
	{
		if(param_00 == param_01[var_02])
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 48
leaderdialog(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(game["dialog"][param_00]))
	{
		return;
	}

	if(level.teambased && !isdefined(param_01))
	{
		return;
	}

	for(var_05 = 0;var_05 < level.players.size;var_05++)
	{
		var_06 = level.players[var_05];
		if(isdefined(param_03) && isexcluded(var_06,param_03))
		{
			continue;
		}

		if(var_06 issplitscreenplayer() && !var_06 issplitscreenplayerprimary())
		{
			continue;
		}

		if(level.teambased && !isdefined(var_06.pers["team"]) || var_06.pers["team"] != param_01)
		{
			continue;
		}

		var_06 leaderdialogonplayer_internal(param_00,param_02,undefined,param_04);
	}
}

//Function Number: 49
func_98D3()
{
	level.var_AA1D["allies"] = 0;
	level.var_AA1D["axis"] = 0;
}

//Function Number: 50
statusdialog(param_00,param_01,param_02)
{
	if(istrue(level.gameended))
	{
		return;
	}

	var_03 = gettime();
	if(gettime() < level.var_AA1D[param_01] + 5000 && !isdefined(param_02) || !param_02)
	{
		return;
	}

	thread func_5100(param_00,param_01);
	level.var_AA1D[param_01] = gettime();
}

//Function Number: 51
func_5100(param_00,param_01)
{
	level endon("game_ended");
	wait(0.1);
	func_13842();
	leaderdialog(param_00,param_01);
}

//Function Number: 52
leaderdialogonplayers(param_00,param_01,param_02,param_03)
{
	foreach(var_05 in param_01)
	{
		var_05 leaderdialogonplayer(param_00,param_02,undefined,param_03);
	}
}

//Function Number: 53
leaderdialogonplayer(param_00,param_01,param_02,param_03,param_04)
{
	if(!isdefined(game["dialog"][param_00]))
	{
		return;
	}

	leaderdialogonplayer_internal(param_00,param_01,param_02,param_03,param_04);
}

//Function Number: 54
leaderdialogonplayer_internal(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(param_04))
	{
		param_04 = param_04 * 1000;
		if(gettime() < self.var_AA1D["time"] + param_04 && self.var_AA1D["dialog"] == param_00)
		{
			return;
		}

		self.var_AA1D["time"] = gettime();
		self.var_AA1D["dialog"] = param_00;
	}

	var_05 = self.pers["team"];
	if(isdefined(var_05) && var_05 == "axis" || var_05 == "allies")
	{
		var_06 = self getplayerdata("common","mp_announcer_type");
		if(var_06 > 0)
		{
			var_07 = tablelookupistringbyrow("mp/announcervoicedata.csv",var_06,3);
			var_08 = var_07 + "_1mc_" + game["dialog"][param_00];
		}
		else
		{
			var_08 = game["voice"][var_06] + "1mc_" + game["dialog"][param_01];
		}

		var_08 = tolower(var_08);
		self _meth_8252(var_08,param_00,2,param_01,param_02,param_03);
	}
}

//Function Number: 55
func_98D4()
{
	self.var_AA1D["time"] = 0;
	self.var_AA1D["dialog"] = "";
}

//Function Number: 56
func_D4B7(param_00)
{
	var_01 = self.team;
	var_02 = [self];
	var_03 = self getothersplitscreenplayer();
	if(isdefined(var_03))
	{
		var_02[var_02.size] = var_03;
	}

	func_C638(param_00 + "_use");
	if(level.teambased)
	{
		leaderdialog(var_01 + "_friendly_" + param_00 + "_inbound",var_01,undefined,var_02);
		if(func_7F40(param_00))
		{
			leaderdialog(var_01 + "_enemy_" + param_00 + "_inbound",level.otherteam[var_01],undefined,var_02);
			return;
		}

		return;
	}

	if(func_7F40(param_00))
	{
		leaderdialog(var_01 + "_enemy_" + param_00 + "_inbound",undefined,undefined,var_02);
	}
}

//Function Number: 57
playkillstreakdialogonplayer(param_00,param_01,param_02,param_03)
{
	if(level.showingfinalkillcam)
	{
		return;
	}

	param_00 = getbasekillstreakdialog(param_00);
	if(!isdefined(game["dialog"][param_00]))
	{
		return;
	}

	var_04 = game["dialog"][param_00];
	if(issubstr(var_04,"op_" + param_00) || var_04 == "op_" + param_00)
	{
		func_C638(param_00,param_01,param_02,param_03);
		return;
	}

	leaderdialogonplayer(param_00,param_01,param_02,param_03);
}

//Function Number: 58
getbasekillstreakdialog(param_00)
{
	var_01 = strtok(param_00,"_");
	var_02 = undefined;
	foreach(var_06, var_04 in var_01)
	{
		if(!isdefined(var_02))
		{
			var_02 = var_04;
		}
		else
		{
			var_02 = var_02 + var_04;
		}

		var_05 = var_01[var_06 + 1];
		if(isdefined(var_05))
		{
			if(var_05 == "rare" || var_05 == "legend" || var_05 == "epic")
			{
				break;
			}
			else
			{
				var_02 = var_02 + "_";
			}
		}
	}

	return var_02;
}

//Function Number: 59
func_C638(param_00,param_01,param_02,param_03)
{
	if(!isdefined(game["dialog"][param_00]))
	{
		return;
	}

	var_04 = game["dialog"][param_00];
	self _meth_8252(var_04,param_00,2,param_01,param_02,param_03);
}

//Function Number: 60
func_7FEB()
{
	for(var_00 = 0;var_00 < self.leaderdialogqueue.size;var_00++)
	{
		if(issubstr(self.leaderdialogqueue[var_00],"losing"))
		{
			if(self.team == "allies")
			{
				if(issubstr(level.axiscapturing,self.leaderdialogqueue[var_00]))
				{
					return self.leaderdialogqueue[var_00];
				}
				else
				{
					scripts\engine\utility::array_remove(self.leaderdialogqueue,self.leaderdialogqueue[var_00]);
				}
			}
			else if(issubstr(level.alliescapturing,self.leaderdialogqueue[var_00]))
			{
				return self.leaderdialogqueue[var_00];
			}
			else
			{
				scripts\engine\utility::array_remove(self.leaderdialogqueue,self.leaderdialogqueue[var_00]);
			}

			continue;
		}

		return level.alliescapturing[self.leaderdialogqueue];
	}
}

//Function Number: 61
func_C6E4()
{
	self endon("disconnect");
	var_00 = [];
	var_00 = self.leaderdialogqueue;
	for(var_01 = 0;var_01 < self.leaderdialogqueue.size;var_01++)
	{
		if(issubstr(self.leaderdialogqueue[var_01],"losing"))
		{
			for(var_02 = var_01;var_02 >= 0;var_02--)
			{
				if(!issubstr(self.leaderdialogqueue[var_02],"losing") && var_02 != 0)
				{
					continue;
				}

				if(var_02 != var_01)
				{
					func_22DB(var_00,self.leaderdialogqueue[var_01],var_02);
					scripts\engine\utility::array_remove(var_00,self.leaderdialogqueue[var_01]);
					break;
				}
			}
		}
	}

	self.leaderdialogqueue = var_00;
}

//Function Number: 62
updatemainmenu()
{
	if(self.pers["team"] == "spectator")
	{
		self setclientdvar("g_scriptMainMenu",game["menu_team"]);
		return;
	}

	self setclientdvar("g_scriptMainMenu",game["menu_class_" + self.pers["team"]]);
}

//Function Number: 63
updateobjectivetext()
{
	if(self.pers["team"] == "spectator")
	{
		self setclientdvar("cg_objectiveText","");
		return;
	}

	if(level.roundscorelimit > 0 && !isobjectivebased())
	{
		if(isdefined(getobjectivescoretext(self.pers["team"])))
		{
			if(level.splitscreen)
			{
				self setclientdvar("cg_objectiveText",getobjectivescoretext(self.pers["team"]));
				return;
			}

			self setclientdvar("cg_objectiveText",getobjectivescoretext(self.pers["team"]),level.roundscorelimit);
			return;
		}

		return;
	}

	if(isdefined(getobjectivetext(self.pers["team"])))
	{
		self setclientdvar("cg_objectiveText",getobjectivetext(self.pers["team"]));
	}
}

//Function Number: 64
setobjectivetext(param_00,param_01)
{
	game["strings"]["objective_" + param_00] = param_01;
}

//Function Number: 65
setobjectivescoretext(param_00,param_01)
{
	game["strings"]["objective_score_" + param_00] = param_01;
}

//Function Number: 66
setobjectivehinttext(param_00,param_01)
{
	game["strings"]["objective_hint_" + param_00] = param_01;
}

//Function Number: 67
getobjectivetext(param_00)
{
	return game["strings"]["objective_" + param_00];
}

//Function Number: 68
getobjectivescoretext(param_00)
{
	return game["strings"]["objective_score_" + param_00];
}

//Function Number: 69
getobjectivehinttext(param_00)
{
	return game["strings"]["objective_hint_" + param_00];
}

//Function Number: 70
gettimepassed()
{
	if(!isdefined(level.starttime) || !isdefined(level.var_561F))
	{
		return 0;
	}

	if(level.var_1191F)
	{
		return level.var_1191E - level.starttime - level.var_561F;
	}

	return gettime() - level.starttime - level.var_561F;
}

//Function Number: 71
gettimepassedpercentage()
{
	var_00 = gettimelimit();
	if(var_00 == 0)
	{
		return 0;
	}

	return gettimepassed() / gettimelimit() * 60 * 1000 * 100;
}

//Function Number: 72
getsecondspassed()
{
	return gettimepassed() / 1000;
}

//Function Number: 73
getminutespassed()
{
	return getsecondspassed() / 60;
}

//Function Number: 74
clearkillcamstate()
{
	self.missile_createrepulsorent = -1;
	self.setclientmatchdatadef = -1;
	self.var_4A = 0;
	self.box = 0;
	self.clearstartpointtransients = 0;
}

//Function Number: 75
isinkillcam()
{
	if(isai(self))
	{
		return 0;
	}

	if(self.clearstartpointtransients)
	{
		if(self.missile_createrepulsorent == -1 && self.setclientmatchdatadef == -1)
		{
			return 0;
		}
	}

	return self.clearstartpointtransients;
}

//Function Number: 76
func_F8A0(param_00,param_01)
{
	self endon("disconnect");
	if(!isdefined(self.var_6AB3))
	{
		self.var_6AB3 = 0;
	}

	if(self.var_6AB3 == param_00)
	{
		return;
	}

	if(isdefined(param_01))
	{
		wait(param_01);
	}

	self notify("setUIPostGameFade");
	self endon("setUIPostGameFade");
	if(self.var_6AB3 < param_00)
	{
		self.var_6AB3 = clamp(self.var_6AB3 + 0.5 * abs(self.var_6AB3 - param_00),0,1);
	}
	else
	{
		self.var_6AB3 = clamp(self.var_6AB3 - 0.5 * abs(self.var_6AB3 - param_00),0,1);
	}

	self setclientomnvar("ui_post_game_fade",self.var_6AB3);
	wait(0.1);
	self.var_6AB3 = param_00;
	self setclientomnvar("ui_post_game_fade",self.var_6AB3);
}

//Function Number: 77
isvalidclass(param_00)
{
	return isdefined(param_00) && param_00 != "";
}

//Function Number: 78
makevehiclesolidcapsule(param_00,param_01,param_02)
{
	if(param_00 > param_02)
	{
		return param_02;
	}

	if(param_00 < param_01)
	{
		return param_01;
	}

	return param_00;
}

//Function Number: 79
func_136EE(param_00)
{
	var_01 = gettime();
	var_02 = gettime() - var_01 / 1000;
	if(var_02 < param_00)
	{
		wait(param_00 - var_02);
		return param_00;
	}

	return var_02;
}

//Function Number: 80
registerroundswitchdvar(param_00,param_01,param_02,param_03)
{
	registerwatchdvarint("roundswitch",param_01);
	param_00 = "scr_" + param_00 + "_roundswitch";
	level.var_E766 = param_00;
	level.var_E768 = param_02;
	level.var_E767 = param_03;
	level.var_E765 = getdvarint(param_00,param_01);
	if(level.var_E765 < param_02)
	{
		level.var_E765 = param_02;
		return;
	}

	if(level.var_E765 > param_03)
	{
		level.var_E765 = param_03;
	}
}

//Function Number: 81
registerroundlimitdvar(param_00,param_01)
{
	registerwatchdvarint("roundlimit",param_01);
}

//Function Number: 82
func_DF03(param_00,param_01)
{
	registerwatchdvarint("numTeams",param_01);
}

//Function Number: 83
registerwinlimitdvar(param_00,param_01)
{
	registerwatchdvarint("winlimit",param_01);
}

//Function Number: 84
registerwinbytwoenableddvar(param_00,param_01)
{
	registerwatchdvarint("winbytwoenabled",param_01);
}

//Function Number: 85
registerwinbytwomaxroundsdvar(param_00,param_01)
{
	registerwatchdvarint("winbytwomaxrounds",param_01);
}

//Function Number: 86
registerdogtagsenableddvar(param_00,param_01)
{
	registerwatchdvarint("dogtags",param_01);
}

//Function Number: 87
registerscorelimitdvar(param_00,param_01)
{
	registerwatchdvarint("scorelimit",param_01);
}

//Function Number: 88
registertimelimitdvar(param_00,param_01)
{
	registerwatchdvarfloat("timelimit",param_01);
	setdvar("ui_timelimit",gettimelimit());
}

//Function Number: 89
registerhalftimedvar(param_00,param_01)
{
	registerwatchdvarint("halftime",param_01);
	setdvar("ui_halftime",func_7EEF());
}

//Function Number: 90
registernumlivesdvar(param_00,param_01)
{
	registerwatchdvarint("numlives",param_01);
}

//Function Number: 91
botgetworldsize(param_00,param_01)
{
	return getdvarint(param_00,getdvarint(param_01));
}

//Function Number: 92
_meth_803B(param_00,param_01)
{
	return getdvarfloat(param_00,getdvarfloat(param_01));
}

//Function Number: 93
func_F7D3(param_00)
{
	setdvar("overtimeTimeLimit",param_00);
}

//Function Number: 94
func_7920(param_00,param_01)
{
	var_02 = spawnstruct();
	var_02.isplayer = 1;
	var_02.var_9D26 = 0;
	var_02.issplitscreen = param_00;
	var_02.damagecenter = param_01;
	return var_02;
}

//Function Number: 95
func_7922(param_00,param_01)
{
	var_02 = spawnstruct();
	var_02.isplayer = 0;
	var_02.var_9D26 = 0;
	var_02.issentry = 1;
	var_02.issplitscreen = param_00;
	var_02.damagecenter = param_01;
	return var_02;
}

//Function Number: 96
func_791D(param_00,param_01)
{
	var_02 = spawnstruct();
	var_02.isplayer = 0;
	var_02.var_9D26 = 0;
	var_02.issplitscreen = param_00;
	var_02.damagecenter = param_01;
	return var_02;
}

//Function Number: 97
func_791F(param_00,param_01)
{
	var_02 = spawnstruct();
	var_02.isplayer = 0;
	var_02.var_9D26 = 0;
	var_02.issplitscreen = param_00;
	var_02.damagecenter = param_01;
	return var_02;
}

//Function Number: 98
func_7921(param_00)
{
	return param_00.origin + (0,0,32);
}

//Function Number: 99
getstancecenter()
{
	if(self getstance() == "crouch")
	{
		var_00 = self.origin + (0,0,24);
	}
	else if(self getstance() == "prone")
	{
		var_00 = self.origin + (0,0,10);
	}
	else
	{
		var_00 = self.origin + (0,0,32);
	}

	return var_00;
}

//Function Number: 100
func_791E(param_00)
{
	return param_00.origin;
}

//Function Number: 101
func_7E8A(param_00)
{
	var_01 = getdvar(param_00);
	if(var_01 == "")
	{
		return (0,0,0);
	}

	var_02 = strtok(var_01," ");
	if(var_02.size < 3)
	{
		return (0,0,0);
	}

	setdvar("tempR",var_02[0]);
	setdvar("tempG",var_02[1]);
	setdvar("tempB",var_02[2]);
	return (getdvarfloat("tempR"),getdvarfloat("tempG"),getdvarfloat("tempB"));
}

//Function Number: 102
strip_suffix(param_00,param_01)
{
	if(param_00.size <= param_01.size)
	{
		return param_00;
	}

	if(getsubstr(param_00,param_00.size - param_01.size,param_00.size) == param_01)
	{
		return getsubstr(param_00,0,param_00.size - param_01.size);
	}

	return param_00;
}

//Function Number: 103
_takeweaponsexcept(param_00)
{
	var_01 = self getweaponslistall();
	foreach(var_03 in var_01)
	{
		if(var_03 == param_00)
		{
			continue;
		}
		else
		{
			_takeweapon(var_03);
		}
	}
}

//Function Number: 104
_setactionslot(param_00,param_01,param_02)
{
	self.saved_actionslotdata[param_00].type = param_01;
	self.saved_actionslotdata[param_00].randomintrange = param_02;
	self setactionslot(param_00,param_01,param_02);
}

//Function Number: 105
isfloat(param_00)
{
	if(int(param_00) != param_00)
	{
		return 1;
	}

	return 0;
}

//Function Number: 106
registerwatchdvarint(param_00,param_01)
{
	var_02 = "scr_" + level.gametype + "_" + param_00;
	level.var_13A08[var_02] = spawnstruct();
	level.var_13A08[var_02].value = getdvarint(var_02,param_01);
	level.var_13A08[var_02].type = "int";
	level.var_13A08[var_02].var_C174 = "update_" + param_00;
}

//Function Number: 107
registerwatchdvarfloat(param_00,param_01)
{
	var_02 = "scr_" + level.gametype + "_" + param_00;
	level.var_13A08[var_02] = spawnstruct();
	level.var_13A08[var_02].value = getdvarfloat(var_02,param_01);
	level.var_13A08[var_02].type = "float";
	level.var_13A08[var_02].var_C174 = "update_" + param_00;
}

//Function Number: 108
registerwatchdvar(param_00,param_01)
{
	var_02 = "scr_" + level.gametype + "_" + param_00;
	level.var_13A08[var_02] = spawnstruct();
	level.var_13A08[var_02].value = getdvar(var_02,param_01);
	level.var_13A08[var_02].type = "string";
	level.var_13A08[var_02].var_C174 = "update_" + param_00;
}

//Function Number: 109
setoverridewatchdvar(param_00,param_01)
{
	param_00 = "scr_" + level.gametype + "_" + param_00;
	level.var_C827[param_00] = param_01;
}

//Function Number: 110
getwatcheddvar(param_00)
{
	param_00 = "scr_" + level.gametype + "_" + param_00;
	if(isdefined(level.var_C827) && isdefined(level.var_C827[param_00]))
	{
		return level.var_C827[param_00];
	}

	return level.var_13A08[param_00].value;
}

//Function Number: 111
func_12F5B()
{
	while(game["state"] == "playing")
	{
		var_00 = getarraykeys(level.var_13A08);
		foreach(var_02 in var_00)
		{
			if(level.var_13A08[var_02].type == "string")
			{
				var_03 = _meth_80A2(var_02,level.var_13A08[var_02].value);
			}
			else if(level.var_13A08[var_02].type == "float")
			{
				var_03 = func_7EBF(var_02,level.var_13A08[var_02].value);
			}
			else
			{
				var_03 = getintproperty(var_02,level.var_13A08[var_02].value);
			}

			if(var_03 != level.var_13A08[var_02].value)
			{
				level.var_13A08[var_02].value = var_03;
				level notify(level.var_13A08[var_02].var_C174,var_03);
			}
		}

		wait(1);
	}
}

//Function Number: 112
isroundbased()
{
	if(!level.teambased)
	{
		return 0;
	}

	if(level.winlimit != 1 && level.roundlimit != 1)
	{
		return 1;
	}

	if(level.gametype == "sr" || level.gametype == "sd" || level.gametype == "siege")
	{
		return 1;
	}

	return 0;
}

//Function Number: 113
func_9DF6()
{
	if(!level.teambased)
	{
		return 1;
	}

	if(level.roundlimit > 1 && game["roundsPlayed"] == 0)
	{
		return 1;
	}

	if(level.winlimit > 1 && game["roundsWon"]["allies"] == 0 && game["roundsWon"]["axis"] == 0)
	{
		return 1;
	}

	return 0;
}

//Function Number: 114
nextroundisfinalround()
{
	if(level.var_72B3)
	{
		return 1;
	}

	if(!level.teambased)
	{
		return 1;
	}

	if(level.roundlimit > 1 && game["roundsPlayed"] >= level.roundlimit - 1 && !istimetobeatrulegametype())
	{
		return 1;
	}

	if(func_9ECF() && hitroundlimit() || hitwinlimit())
	{
		if(shouldplaywinbytwo() && islastwinbytwo())
		{
			return 1;
		}
		else if(istimetobeatrulegametype())
		{
			if(game["overtimeRoundsPlayed"] == 1)
			{
				return 1;
			}
		}
		else if(!level.playovertime)
		{
			return 1;
		}
	}

	var_00 = level.winlimit > 0 && getroundswon("allies") == level.winlimit - 1 || getroundswon("axis") == level.winlimit - 1;
	var_01 = abs(getroundswon("allies") - getroundswon("axis"));
	if(var_00 && var_01 == 0)
	{
		if(func_9ECF())
		{
			return 0;
		}
		else
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 115
wasonlyround()
{
	if(level.playovertime)
	{
		return 0;
	}

	if(!level.teambased)
	{
		return 1;
	}

	if(isdefined(level.onlyroundoverride))
	{
		return 0;
	}

	if(level.winlimit == 1 && hitwinlimit())
	{
		return 1;
	}

	if(level.roundlimit == 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 116
waslastround()
{
	if(level.var_72B3)
	{
		return 1;
	}

	if(wasonlyround())
	{
		return 1;
	}

	if(!level.teambased)
	{
		return 1;
	}

	if(hitroundlimit() || hitwinlimit())
	{
		return !level.playovertime;
	}

	return 0;
}

//Function Number: 117
iswinbytworulegametype()
{
	switch(level.gametype)
	{
		case "sd":
		case "sr":
		case "siege":
			return getdvarint("scr_" + level.gametype + "_winByTwoEnabled",0) == 1;
	}

	return 0;
}

//Function Number: 118
getmaxwinbytworounds()
{
	return getdvarint("scr_" + level.gametype + "_winByTwoMaxRounds",level.winlimit);
}

//Function Number: 119
shouldplaywinbytwo()
{
	var_00 = game["roundsWon"]["allies"];
	var_01 = game["roundsWon"]["axis"];
	return iswinbytworulegametype() && abs(var_00 - var_01) < 2 && game["overtimeRoundsPlayed"] < getmaxwinbytworounds();
}

//Function Number: 120
islastwinbytwo()
{
	return shouldplaywinbytwo() && game["overtimeRoundsPlayed"] == getmaxwinbytworounds() - 1;
}

//Function Number: 121
istimetobeatrulegametype()
{
	switch(level.gametype)
	{
		case "ball":
		case "ctf":
			return 1;
	}

	return 0;
}

//Function Number: 122
settimetobeat(param_00)
{
	if(!istimetobeatrulegametype())
	{
		return 0;
	}

	var_01 = getsecondspassed();
	var_02 = scripts\mp\gamescore::_getteamscore(param_00);
	if(!istimetobeatvalid() || var_01 < game["timeToBeat"] && var_02 >= game["timeToBeatScore"])
	{
		if(game["timeToBeatTeam"] != "none" && game["timeToBeatTeam"] != param_00)
		{
			game["timeToBeatOld"] = game["timeToBeat"];
		}

		game["timeToBeat"] = var_01;
		game["timeToBeatTeam"] = param_00;
		game["timeToBeatScore"] = var_02;
		return 1;
	}

	return 0;
}

//Function Number: 123
istimetobeatvalid()
{
	return game["timeToBeat"] != 0;
}

//Function Number: 124
forceplaytimetobeat()
{
	return function_0303() && game["timeToBeat"] == 0;
}

//Function Number: 125
func_1005B()
{
	if(function_0303() && game["overtimeRoundsPlayed"] == 1)
	{
		return 1;
	}
	else if(istimetobeatvalid() && game["overtimeRoundsPlayed"] == 1)
	{
		return 1;
	}
	else if(forceplaytimetobeat() && game["overtimeRoundsPlayed"] > 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 126
func_9ECF()
{
	if(function_0303() && !iswinbytworulegametype())
	{
		return 1;
	}

	switch(level.gametype)
	{
		case "ball":
		case "ctf":
			return 1;

		case "sd":
		case "dd":
		case "sr":
		case "siege":
			return iswinbytworulegametype();
	}

	return 0;
}

//Function Number: 127
func_7F9C()
{
	if(function_0303() && !iswinbytworulegametype())
	{
		return -1;
	}

	var_00 = 0;
	switch(level.gametype)
	{
		case "ball":
		case "ctf":
		case "sd":
		case "sr":
		case "siege":
			var_00 = 2;
			break;

		case "dd":
			var_00 = 1;
			break;
	}

	if(isanymlgmatch() && !istimetobeatrulegametype())
	{
		return -1;
	}

	return var_00;
}

//Function Number: 128
getwingamebytype()
{
	if(!isdefined(level.wingamebytype))
	{
		if(!isroundbased() || !isobjectivebased() || ismoddedroundgame())
		{
			level.wingamebytype = "teamScores";
		}
		else
		{
			level.wingamebytype = "roundsWon";
		}
	}

	return level.wingamebytype;
}

//Function Number: 129
issimultaneouskillenabled()
{
	if(!isdefined(level.simultaneouskillenabled))
	{
		level.simultaneouskillenabled = getdvarint("killswitch_simultaneous_deaths",0) == 0;
	}

	if(function_0303())
	{
		level.simultaneouskillenabled = 0;
	}

	return level.simultaneouskillenabled;
}

//Function Number: 130
cantiebysimultaneouskill()
{
	if(!issimultaneouskillenabled())
	{
		return 0;
	}

	var_00 = 0;
	switch(level.gametype)
	{
		case "gun":
		case "dm":
		case "war":
		case "front":
			var_00 = 1;
			break;
	}

	return var_00;
}

//Function Number: 131
func_1004B()
{
	if(!hitroundlimit() && !hitwinlimit())
	{
		return 0;
	}

	if(!func_9ECF())
	{
		return 0;
	}

	var_00 = getwingamebytype();
	var_01 = game[var_00]["allies"];
	var_02 = game[var_00]["axis"];
	var_03 = var_01 == var_02;
	if(var_03 && inovertime())
	{
		var_04 = func_7F9C();
		var_03 = scripts\engine\utility::ter_op(var_04 == -1,1,game["overtimeRoundsPlayed"] < var_04);
	}

	var_05 = shouldplaywinbytwo();
	var_06 = func_1005B();
	if(function_0303() && istimetobeatrulegametype())
	{
		if(game["overtimeRoundsPlayed"] == 0)
		{
			var_03 = 0;
			if(var_01 == var_02)
			{
				var_03 = 1;
			}
		}
		else if(!var_06)
		{
			var_03 = 0;
		}
	}

	return !level.var_72B3 && var_03 || var_05 || var_06;
}

//Function Number: 132
func_E269()
{
	return level.gametype == "ctf" && !inovertime() && getwingamebytype() == "roundsWon";
}

//Function Number: 133
func_38F3()
{
	if(!isdefined(level.didhalfscorevoboost))
	{
		level.didhalfscorevoboost = 0;
	}

	if(level.didhalfscorevoboost)
	{
		return 0;
	}

	switch(level.gametype)
	{
		case "tdef":
		case "conf":
		case "dm":
		case "war":
		case "ball":
		case "grnd":
		case "koth":
		case "front":
		case "dd":
		case "grind":
		case "dom":
			return 1;

		case "mp_zomb":
		case "gun":
		case "ctf":
		case "sd":
		case "sr":
		case "siege":
		case "infect":
			return 0;

		default:
			return 0;
	}
}

//Function Number: 134
hittimelimit()
{
	if(getwatcheddvar("timelimit") <= 0)
	{
		return 0;
	}

	var_00 = scripts\mp\gamelogic::gettimeremaining();
	if(var_00 > 0)
	{
		return 0;
	}

	return 1;
}

//Function Number: 135
hitroundlimit()
{
	if(level.roundlimit <= 0)
	{
		return 0;
	}

	return game["roundsPlayed"] >= level.roundlimit;
}

//Function Number: 136
hitscorelimit()
{
	if(isobjectivebased())
	{
		return 0;
	}

	if(level.roundscorelimit <= 0)
	{
		return 0;
	}

	if(level.teambased)
	{
		if(game["teamScores"]["allies"] >= level.roundscorelimit || game["teamScores"]["axis"] >= level.roundscorelimit)
		{
			return 1;
		}
	}
	else
	{
		for(var_00 = 0;var_00 < level.players.size;var_00++)
		{
			var_01 = level.players[var_00];
			if(isdefined(var_01.destroynavrepulsor) && var_01.destroynavrepulsor >= level.roundscorelimit)
			{
				return 1;
			}
		}
	}

	return 0;
}

//Function Number: 137
hitwinlimit()
{
	if(level.winlimit <= 0)
	{
		return 0;
	}

	if(!level.teambased)
	{
		return 1;
	}

	if(getroundswon("allies") >= level.winlimit || getroundswon("axis") >= level.winlimit)
	{
		return 1;
	}

	return 0;
}

//Function Number: 138
getscorelimit()
{
	if(isroundbased())
	{
		if(level.roundlimit)
		{
			return level.roundlimit;
		}

		return level.winlimit;
	}

	return level.roundscorelimit;
}

//Function Number: 139
getroundswon(param_00)
{
	return game["roundsWon"][param_00];
}

//Function Number: 140
isobjectivebased()
{
	return level.objectivebased;
}

//Function Number: 141
gettimelimit()
{
	if(inovertime() && !isdefined(game["inNukeOvertime"]) || !game["inNukeOvertime"])
	{
		if(istrue(game["timeToBeat"]))
		{
			return game["timeToBeat"] / 60;
		}

		var_00 = getdvarfloat("overtimeTimeLimit");
		if(var_00 > 0)
		{
			return var_00;
		}

		return getwatcheddvar("timelimit");
	}

	if(isdefined(level.extratime) && level.extratime > 0)
	{
		return getwatcheddvar("timelimit") + level.extratime;
	}

	return getwatcheddvar("timelimit");
}

//Function Number: 142
func_7EEF()
{
	if(inovertime())
	{
		return 0;
	}

	if(isdefined(game["inNukeOvertime"]) && game["inNukeOvertime"])
	{
		return 0;
	}

	return getwatcheddvar("halftime");
}

//Function Number: 143
inovertime()
{
	return isdefined(game["status"]) && game["status"] == "overtime";
}

//Function Number: 144
gamehasstarted()
{
	if(isdefined(level.gamehasstarted))
	{
		return level.gamehasstarted;
	}

	if(level.teambased)
	{
		return level.hasspawned["axis"] && level.hasspawned["allies"];
	}

	return level.maxplayercount > 1;
}

//Function Number: 145
func_7DEA(param_00)
{
	var_01 = (0,0,0);
	if(!param_00.size)
	{
		return undefined;
	}

	foreach(var_03 in param_00)
	{
		var_01 = var_01 + var_03.origin;
	}

	var_05 = int(var_01[0] / param_00.size);
	var_06 = int(var_01[1] / param_00.size);
	var_07 = int(var_01[2] / param_00.size);
	var_01 = (var_05,var_06,var_07);
	return var_01;
}

//Function Number: 146
getlivingplayers(param_00)
{
	var_01 = [];
	foreach(var_03 in level.players)
	{
		if(!isalive(var_03))
		{
			continue;
		}

		if(level.teambased && isdefined(param_00))
		{
			if(param_00 == var_03.pers["team"])
			{
				var_01[var_01.size] = var_03;
			}

			continue;
		}

		var_01[var_01.size] = var_03;
	}

	return var_01;
}

//Function Number: 147
setusingremote(param_00)
{
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 0;
	}

	self.usingremote = param_00;
	scripts\engine\utility::allow_offhand_weapons(0);
	self setclientomnvar("ui_using_killstreak_remote",1);
	self playlocalsound("mp_killstreak_screen_start");
	self notify("using_remote");
}

//Function Number: 148
_meth_80E8()
{
	return self.usingremote;
}

//Function Number: 149
freezecontrolswrapper(param_00,param_01)
{
	if(!isdefined(self.pers))
	{
		return;
	}

	if(!isdefined(self.pers["controllerFreezeStack"]))
	{
		self.pers["controllerFreezeStack"] = 0;
	}

	if(param_00)
	{
		self.pers["controllerFreezeStack"]++;
	}
	else if(scripts\engine\utility::istrue(param_01))
	{
		self.pers["controllerFreezeStack"] = 0;
	}
	else
	{
		self.pers["controllerFreezeStack"]--;
	}

	if(self.pers["controllerFreezeStack"] <= 0)
	{
		self.pers["controllerFreezeStack"] = 0;
		self freezecontrols(0);
		self.controlsfrozen = 0;
		return;
	}

	self freezecontrols(1);
	self.controlsfrozen = 1;
}

//Function Number: 150
clearusingremote(param_00)
{
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 1;
	}

	self.usingremote = undefined;
	if(!isdefined(param_00))
	{
		scripts\engine\utility::allow_offhand_weapons(1);
		freezecontrolswrapper(0);
	}

	self setclientomnvar("ui_using_killstreak_remote",0);
	self playlocalsound("mp_killstreak_screen_end");
	self notify("stopped_using_remote");
}

//Function Number: 151
isusingremote()
{
	return isdefined(self.usingremote);
}

//Function Number: 152
istryingtousekillstreak()
{
	return isdefined(self.tryingtousekillstreak);
}

//Function Number: 153
func_DB8D(param_00)
{
	if(!isdefined(level.var_DB95))
	{
		level.var_DB95 = [];
	}

	level.var_DB95[param_00] = [];
}

//Function Number: 154
func_DB8B(param_00,param_01)
{
	level.var_DB95[param_00][level.var_DB95[param_00].size] = param_01;
}

//Function Number: 155
func_DB94(param_00)
{
	var_01 = undefined;
	var_02 = [];
	foreach(var_04 in level.var_DB95[param_00])
	{
		if(!isdefined(var_04))
		{
			continue;
		}

		if(!isdefined(var_01))
		{
			var_01 = var_04;
			continue;
		}

		var_02[var_02.size] = var_04;
	}

	level.var_DB95[param_00] = var_02;
	return var_01;
}

//Function Number: 156
_giveweapon(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_01))
	{
		param_01 = -1;
	}

	if(!isdefined(param_03))
	{
		param_03 = 0;
	}

	if(issubstr(param_00,"_akimbo") || isdefined(param_02) && param_02 == 1)
	{
		self giveweapon(param_00,param_01,1,-1,param_03);
		return;
	}

	self giveweapon(param_00,param_01,0,-1,param_03);
}

//Function Number: 157
_switchtoweapon(param_00)
{
	func_4F5B("___ SwitchToWeapon() - " + param_00);
	self switchtoweapon(param_00);
}

//Function Number: 158
_switchtoweaponimmediate(param_00)
{
	func_4F5B("___ SwitchToWeaponImmediate() - " + param_00);
	self switchtoweaponimmediate(param_00);
}

//Function Number: 159
_takeweapon(param_00)
{
	if(self _meth_856D() == param_00)
	{
		self _meth_8570(param_00);
	}

	self takeweapon(param_00);
}

//Function Number: 160
takeweaponwhensafe(param_00)
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		if(!iscurrentweapon(param_00))
		{
			break;
		}

		scripts\engine\utility::waitframe();
	}

	_takeweapon(param_00);
}

//Function Number: 161
perksenabled()
{
	return level.allowperks;
}

//Function Number: 162
_hasperk(param_00)
{
	return isdefined(self.perks) && isdefined(self.perks[param_00]);
}

//Function Number: 163
giveperk(param_00)
{
	scripts\mp\perks\_perks::_setperk(param_00);
	scripts\mp\perks\_perks::_setextraperks(param_00);
}

//Function Number: 164
removeperk(param_00)
{
	scripts\mp\perks\_perks::_unsetperk(param_00);
	scripts\mp\perks\_perks::func_142F(param_00);
}

//Function Number: 165
blockperkfunction(param_00)
{
	if(!isdefined(self.perksblocked[param_00]))
	{
		self.perksblocked[param_00] = 1;
	}
	else
	{
		self.perksblocked[param_00]++;
	}

	if(self.perksblocked[param_00] == 1 && _hasperk(param_00))
	{
		scripts\mp\perks\_perks::func_1431(param_00);
		foreach(var_06, var_02 in level.extraperkmap)
		{
			if(param_00 == var_06)
			{
				foreach(var_04 in var_02)
				{
					if(!isdefined(self.perksblocked[var_04]))
					{
						self.perksblocked[var_04] = 1;
					}
					else
					{
						self.perksblocked[var_04]++;
					}

					if(self.perksblocked[var_04] == 1)
					{
						scripts\mp\perks\_perks::func_1431(var_04);
					}
				}

				break;
			}
		}
	}
}

//Function Number: 166
unblockperkfunction(param_00)
{
	self.perksblocked[param_00]--;
	if(self.perksblocked[param_00] == 0)
	{
		self.perksblocked[param_00] = undefined;
		if(_hasperk(param_00))
		{
			scripts\mp\perks\_perks::func_13D2(param_00);
			foreach(var_06, var_02 in level.extraperkmap)
			{
				if(param_00 == var_06)
				{
					foreach(var_04 in var_02)
					{
						self.perksblocked[var_04]--;
						if(self.perksblocked[var_04] == 0)
						{
							scripts\mp\perks\_perks::func_13D2(var_04);
							self.perksblocked[var_04] = undefined;
						}
					}

					break;
				}
			}
		}
	}
}

//Function Number: 167
quicksort(param_00,param_01)
{
	return func_DBA1(param_00,0,param_00.size - 1,param_01);
}

//Function Number: 168
func_DBA1(param_00,param_01,param_02,param_03)
{
	var_04 = param_01;
	var_05 = param_02;
	if(!isdefined(param_03))
	{
		param_03 = ::func_DBA0;
	}

	if(param_02 - param_01 >= 1)
	{
		var_06 = param_00[param_01];
		while(var_05 > var_04)
		{
			while([[ param_03 ]](param_00[var_04],var_06) && var_04 <= param_02 && var_05 > var_04)
			{
				var_04++;
			}

			while(![[ param_03 ]](param_00[var_05],var_06) && var_05 >= param_01 && var_05 >= var_04)
			{
				var_05--;
			}

			if(var_05 > var_04)
			{
				param_00 = func_11304(param_00,var_04,var_05);
			}
		}

		param_00 = func_11304(param_00,param_01,var_05);
		param_00 = func_DBA1(param_00,param_01,var_05 - 1,param_03);
		param_00 = func_DBA1(param_00,var_05 + 1,param_02,param_03);
	}
	else
	{
		return param_01;
	}

	return param_00;
}

//Function Number: 169
func_DBA0(param_00,param_01)
{
	return param_00 <= param_01;
}

//Function Number: 170
func_11304(param_00,param_01,param_02)
{
	var_03 = param_00[param_01];
	param_00[param_01] = param_00[param_02];
	param_00[param_02] = var_03;
	return param_00;
}

//Function Number: 171
_suicide()
{
	if(isusingremote() && !isdefined(self.fauxdeath))
	{
		thread scripts\mp\damage::playerkilled_internal(self,self,self,10000,0,"MOD_SUICIDE","none",(0,0,0),"none",0,1116,1);
		return;
	}

	if(!isusingremote() && !isdefined(self.fauxdeath))
	{
		self suicide();
	}
}

//Function Number: 172
isreallyalive(param_00)
{
	if(isalive(param_00) && !isdefined(param_00.fauxdeath))
	{
		return 1;
	}

	return 0;
}

//Function Number: 173
waittill_any_timeout_pause_on_death_and_prematch(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = spawnstruct();
	if(isdefined(param_01))
	{
		thread scripts\engine\utility::waittill_string_no_endon_death(param_01,var_06);
	}

	if(isdefined(param_02))
	{
		thread scripts\engine\utility::waittill_string_no_endon_death(param_02,var_06);
	}

	if(isdefined(param_03))
	{
		thread scripts\engine\utility::waittill_string_no_endon_death(param_03,var_06);
	}

	if(isdefined(param_04))
	{
		thread scripts\engine\utility::waittill_string_no_endon_death(param_04,var_06);
	}

	if(isdefined(param_05))
	{
		thread scripts\engine\utility::waittill_string_no_endon_death(param_05,var_06);
	}

	var_06 thread func_1429(param_00,self);
	var_06 waittill("returned",var_07);
	var_06 notify("die");
	return var_07;
}

//Function Number: 174
func_1429(param_00,param_01)
{
	self endon("die");
	var_02 = 0.05;
	while(param_00 > 0)
	{
		if(isplayer(param_01) && !isreallyalive(param_01))
		{
			param_01 waittill("spawned_player");
		}

		if(getomnvar("ui_prematch_period"))
		{
			level waittill("prematch_over");
		}

		wait(var_02);
		param_00 = param_00 - var_02;
	}

	self notify("returned","timeout");
}

//Function Number: 175
playdeathsound()
{
	var_00 = randomintrange(1,8);
	var_01 = "generic";
	if(isfemale())
	{
		var_01 = "female";
	}

	if(func_9D48("archetype_scout"))
	{
		self playsound("c6_death_vox");
		return;
	}

	if(self.team == "axis")
	{
		self playsound(var_01 + "_death_russian_" + var_00);
		return;
	}

	self playsound(var_01 + "_death_american_" + var_00);
}

//Function Number: 176
rankingenabled()
{
	if(!isplayer(self))
	{
		return 0;
	}

	return level.rankedmatch && !self.usingonlinedataoffline;
}

//Function Number: 177
func_D957()
{
	return level.onlinegame && getdvarint("xblive_privatematch");
}

//Function Number: 178
lobbyteamselectenabled()
{
	return getdvarint("systemlink") || func_D957() && getdvarint("lobby_team_select",0);
}

//Function Number: 179
matchmakinggame()
{
	return level.onlinegame && !getdvarint("xblive_privatematch");
}

//Function Number: 180
setaltsceneobj(param_00,param_01,param_02,param_03)
{
}

//Function Number: 181
func_6383(param_00)
{
	self endon("altscene");
	param_00 waittill("death");
	self notify("end_altScene");
}

//Function Number: 182
getgametypenumlives()
{
	return getwatcheddvar("numlives");
}

//Function Number: 183
setturretminimapvisible(param_00)
{
	self.combathigh = param_00;
}

//Function Number: 184
func_22DB(param_00,param_01,param_02)
{
	if(param_00.size != 0)
	{
		for(var_03 = param_00.size;var_03 >= param_02;var_03--)
		{
			param_00[var_03 + 1] = param_00[var_03];
		}
	}

	param_00[param_02] = param_01;
}

//Function Number: 185
_meth_80A2(param_00,param_01)
{
	var_02 = param_01;
	var_02 = getdvar(param_00,param_01);
	return var_02;
}

//Function Number: 186
getintproperty(param_00,param_01)
{
	var_02 = param_01;
	var_02 = getdvarint(param_00,param_01);
	return var_02;
}

//Function Number: 187
func_7EBF(param_00,param_01)
{
	var_02 = param_01;
	var_02 = getdvarfloat(param_00,param_01);
	return var_02;
}

//Function Number: 188
func_A679(param_00)
{
	if(param_00 == "venomxgun_mp" || param_00 == "venomxproj_mp")
	{
		return 1;
	}

	if(_hasperk("specialty_explosivebullets"))
	{
		return 0;
	}

	if(isdefined(self.isjuggernautrecon) && self.isjuggernautrecon == 1)
	{
		return 0;
	}

	var_01 = self.pers["killstreaks"];
	if(isdefined(level.killstreakweildweapons[param_00]) && isdefined(self.streaktype) && self.streaktype != "support")
	{
		for(var_02 = 1;var_02 < 4;var_02++)
		{
			if(isdefined(var_01[var_02]) && isdefined(var_01[var_02].streakname) && var_01[var_02].streakname == level.killstreakweildweapons[param_00] && isdefined(var_01[var_02].lifeid) && var_01[var_02].lifeid == self.pers["deaths"])
			{
				return streakstate(level.killstreakweildweapons[param_00]);
			}
		}

		return 0;
	}

	return !iskillstreakweapon(var_01);
}

//Function Number: 189
streakstate(param_00)
{
	var_01 = scripts\mp\killstreaks\_killstreaks::getstreakcost(param_00);
	var_02 = scripts\mp\killstreaks\_killstreaks::func_7FEE();
	var_03 = scripts\mp\killstreaks\_killstreaks::getstreakcost(var_02);
	return var_01 < var_03;
}

//Function Number: 190
func_9D48(param_00)
{
	return isdefined(self.loadoutarchetype) && param_00 == self.loadoutarchetype;
}

//Function Number: 191
isjuggernaut()
{
	if(isdefined(self.isjuggernaut) && self.isjuggernaut == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautdef) && self.isjuggernautdef == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautgl) && self.isjuggernautgl == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautrecon) && self.isjuggernautrecon == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautmaniac) && self.isjuggernautmaniac == 1)
	{
		return 1;
	}

	if(isdefined(self.isjuggernautlevelcustom) && self.isjuggernautlevelcustom == 1)
	{
		return 1;
	}

	return 0;
}

//Function Number: 192
_meth_8238(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(isrc8weapon(param_00))
	{
		return "killstreak";
	}

	if(iscacprimaryweapon(param_00))
	{
		return "primary";
	}

	if(iscacsecondaryweapon(param_00))
	{
		return "secondary";
	}

	if(iskillstreakweapon(param_00))
	{
		return "killstreak";
	}

	if(scripts\mp\powers::func_9F0A(param_00))
	{
		return "power";
	}

	if(issuperweapon(param_00))
	{
		return "super";
	}

	if(func_9E0D(param_00))
	{
		return "gamemode";
	}

	if(isstrstart(param_00,"destructible_"))
	{
		return "destructible";
	}

	var_01 = getequipmenttype(param_00);
	if(isdefined(var_01))
	{
		return var_01;
	}

	if(param_00 == "none")
	{
		return "worldspawn";
	}

	if(param_00 == "bomb_site_mp")
	{
		return param_00;
	}

	if(isstrstart(param_00,"spaceship_"))
	{
		return "spaceship";
	}
}

//Function Number: 193
getequipmenttype(param_00)
{
	switch(param_00)
	{
		case "throwingknife_mp":
		case "wristrocket_proj_mp":
		case "power_exploding_drone_mp":
		case "split_grenade_mp":
		case "trip_mine_mp":
		case "power_spider_grenade_mp":
		case "wristrocket_mp":
		case "splash_grenade_mp":
		case "blackhole_grenade_mp":
		case "throwingknifec4_mp":
		case "cluster_grenade_mp":
		case "c4_mp":
			var_01 = "lethal";
			break;

		case "flare_mp":
		case "deployable_cover_mp":
		case "blackout_grenade_mp":
		case "trophy_mp":
		case "concussion_grenade_mp":
		case "smoke_grenade_mp":
		case "domeshield_mp":
		case "cryo_mine_mp":
			var_01 = "tactical";
			break;

		case "groundpound_mp":
		case "player_trophy_system_mp":
			var_01 = "trait";
			break;

		case "kineticpulse_emp_mp":
		case "kineticpulse_concuss_mp":
		case "kineticpulse_mp":
		case "super_trophy_mp":
		case "blackhat_mp":
		case "coneflash_mp":
		case "distortionfield_grenade_mp":
		case "fear_grenade_mp":
		case "virus_grenade_mp":
		case "ammo_box_mp":
		case "sonic_sensor_mp":
		case "transponder_mp":
		case "portal_generator_mp":
		case "forcepush_mp":
		case "speed_strip_mp":
		case "copycat_grenade_mp":
		case "adrenaline_mist_mp":
		case "proxy_bomb_mp":
		case "gas_grenade_mp":
		case "bulletstorm_device_mp":
		case "proto_ricochet_device_mp":
		case "emp_grenade_mp":
		case "mobile_radar_mp":
		case "motion_sensor_mp":
		case "gravity_grenade_mp":
		case "sensor_grenade_mp":
		case "smoke_grenadejugg_mp":
		case "flash_grenade_mp":
		case "chargemode_mp":
		case "phaseslash_grenade_mp":
		case "power_attack_drone_mp":
		case "armorup_mp":
		case "eng_drone_gun_mp":
		case "portal_grenade_mp":
		case "micro_turret_gun_mp":
		case "pulse_grenade_mp":
		case "thruster_mp":
		case "battleslide_mp":
		case "mortarmount_mp":
		case "shard_ball_mp":
		case "case_bomb_mp":
		case "disc_marker_mp":
		case "frag_grenade_short_mp":
		case "mortar_shelljugg_mp":
		case "proximity_explosive_mp":
		case "bouncingbetty_mp":
		case "throwingreaper_mp":
		case "throwingknifehack_mp":
		case "throwingknifesiphon_mp":
		case "throwingknifesmokewall_mp":
		case "throwingknifeteleport_mp":
		case "claymore_mp":
		case "semtex_mp":
		case "frag_grenade_mp":
			var_01 = "equipment_other";
			break;

		default:
			var_01 = undefined;
			break;
	}

	return var_01;
}

//Function Number: 194
func_9F93(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(!isdefined(param_01) || param_01 == "MOD_IMPACT")
	{
		return 0;
	}

	switch(param_00)
	{
		case "blackout_grenade_mp":
		case "concussion_grenade_mp":
		case "smoke_grenade_mp":
		case "cryo_mine_mp":
			return 1;

		case "deployable_cover_mp":
		case "trophy_mp":
		case "domeshield_mp":
			return 0;

		default:
			return 0;
	}
}

//Function Number: 195
func_24ED()
{
	if(!isdefined(self))
	{
		return 0;
	}

	if(isdefined(level.ac130player) && self == level.ac130player)
	{
		return 1;
	}

	if(isdefined(level.chopper) && isdefined(level.chopper.gunner) && self == level.chopper.gunner)
	{
		return 1;
	}

	if(isdefined(level.reminder_reaction_pointat) && isdefined(level.reminder_reaction_pointat.triggerportableradarping) && self == level.reminder_reaction_pointat.triggerportableradarping)
	{
		return 1;
	}

	if(isdefined(self.using_remote_turret) && self.using_remote_turret)
	{
		return 1;
	}

	if(isdefined(self.using_remote_tank) && self.using_remote_tank)
	{
		return 1;
	}
	else if(isdefined(self.using_remote_a10))
	{
		return 1;
	}

	return 0;
}

//Function Number: 196
isenvironmentweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(param_00 == "turret_minigun_mp")
	{
		return 1;
	}

	return 0;
}

//Function Number: 197
isjuggernautweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	switch(param_00)
	{
		case "iw6_axe_mp":
		case "throwingknifejugg_mp":
		case "iw6_riotshieldjugg_mp":
		case "iw6_p226jugg_mp":
		case "iw6_magnumjugg_mp":
		case "iw6_minigunjugg_mp":
		case "smoke_grenadejugg_mp":
		case "mortar_shelljugg_mp":
			return 1;
	}

	return 0;
}

//Function Number: 198
issuperweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	param_00 = getweaponrootname(param_00);
	if(isdefined(level.superweapons) && isdefined(level.superweapons[param_00]))
	{
		return 1;
	}

	return 0;
}

//Function Number: 199
issuperdamagesource(param_00)
{
	if(issuperweapon(param_00))
	{
		return 1;
	}

	if(param_00 == "chargemode_mp")
	{
		return 1;
	}

	if(param_00 == "micro_turret_gun_mp")
	{
		return 1;
	}

	if(param_00 == "super_trophy_mp")
	{
		return 1;
	}

	return 0;
}

//Function Number: 200
func_9E0D(param_00)
{
	if(isbombsiteweapon(param_00))
	{
		return 1;
	}

	switch(param_00)
	{
		case "iw7_tdefball_mp":
		case "iw7_uplinkball_mp":
			return 1;

		default:
			return 0;
	}

	return 0;
}

//Function Number: 201
isrc8weapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	switch(param_00)
	{
		case "iw7_minigun_c8_mp":
		case "iw7_chargeshot_c8_mp":
		case "iw7_c8offhandshield_mp":
		case "iw7_c8landing_mp":
		case "iw7_c8shutdown_mp":
		case "iw7_c8destruct_mp":
			return 1;

		default:
			return 0;
	}

	return 0;
}

//Function Number: 202
getweapongroup(param_00)
{
	if(param_00 == "none" || param_00 == "alt_none")
	{
		return "other";
	}

	var_01 = getweaponrootname(param_00);
	var_02 = weapongroupmap(var_01);
	if(!isdefined(var_02))
	{
		if(issuperweapon(param_00))
		{
			var_02 = "super";
		}
		else if(isenvironmentweapon(param_00))
		{
			var_02 = "weapon_mg";
		}
		else if(iskillstreakweapon(param_00))
		{
			var_02 = "killstreak";
		}
		else if(func_9E0D(param_00))
		{
			var_02 = "gamemode";
		}
		else
		{
			var_02 = "other";
		}
	}

	return var_02;
}

//Function Number: 203
getweaponattachmentarrayfromstats(param_00)
{
	param_00 = getweaponrootname(param_00);
	if(!isdefined(level.weaponattachments))
	{
		level.weaponattachments = [];
	}

	if(!isdefined(level.weaponattachments[param_00]))
	{
		var_01 = [];
		for(var_02 = 0;var_02 <= 19;var_02++)
		{
			var_03 = tablelookup("mp/statsTable.csv",4,param_00,10 + var_02);
			if(var_03 == "")
			{
				break;
			}

			var_01[var_01.size] = var_03;
		}

		level.weaponattachments[param_00] = var_01;
	}

	return level.weaponattachments[param_00];
}

//Function Number: 204
getweaponbarsize(param_00,param_01)
{
	var_02 = getweaponattachmentarrayfromstats(param_00);
	var_03 = [];
	foreach(var_05 in var_02)
	{
		if(getattachmenttype(var_05) == param_01)
		{
			var_03[var_03.size] = var_05;
		}
	}

	return var_03;
}

//Function Number: 205
getweaponattachmentfromstats(param_00,param_01)
{
	param_00 = getweaponrootname(param_00);
	return tablelookup("mp/statsTable.csv",4,param_00,10 + param_01);
}

//Function Number: 206
attachmentscompatible(param_00,param_01)
{
	if(func_248E(param_00) && func_248E(param_01))
	{
		return 0;
	}

	param_00 = attachmentmap_tobase(param_00);
	param_01 = attachmentmap_tobase(param_01);
	var_02 = 1;
	if(param_00 == param_01)
	{
		var_02 = 0;
	}
	else if(isdefined(level.attachmentmap_conflicts))
	{
		var_03 = scripts\engine\utility::alphabetize([param_00,param_01]);
		var_02 = !isdefined(level.attachmentmap_conflicts[var_03[0] + "_" + var_03[1]]);
	}
	else if(param_00 != "none" && param_01 != "none")
	{
		var_04 = tablelookuprownum("mp/attachmentcombos.csv",0,param_01);
		if(tablelookup("mp/attachmentcombos.csv",0,param_00,var_04) == "no")
		{
			var_02 = 0;
		}
	}

	return var_02;
}

//Function Number: 207
getweaponrootname(param_00)
{
	var_01 = strtok(param_00,"_");
	if(var_01[0] == "iw6" || var_01[0] == "iw7")
	{
		param_00 = var_01[0] + "_" + var_01[1];
		if(var_01[1] == "chargeshot" && isdefined(var_01[2]) && var_01[2] == "c8")
		{
			param_00 = var_01[0] + "_" + var_01[1] + "_" + var_01[2];
		}
	}
	else if(var_01[0] == "alt")
	{
		param_00 = var_01[1] + "_" + var_01[2];
	}

	return param_00;
}

//Function Number: 208
getweaponbasedsmokegrenadecount(param_00)
{
	if(param_00 != "none")
	{
		param_00 = getweaponbasename(param_00);
	}

	return param_00;
}

//Function Number: 209
func_E0CF(param_00)
{
	if(scripts\mp\weapons::isaltmodeweapon(param_00))
	{
		param_00 = getsubstr(param_00,4);
	}

	return param_00;
}

//Function Number: 210
isclassicweapon(param_00)
{
	var_01 = getweaponrootname(param_00);
	if(var_01 == "iw7_g18c" || var_01 == "iw7_ump45c" || var_01 == "iw7_cheytacc" || var_01 == "iw7_m1c" || var_01 == "iw7_spasc" || var_01 == "iw7_arclassic")
	{
		return 1;
	}

	return 0;
}

//Function Number: 211
isburstfireweapon(param_00)
{
	var_01 = getweaponrootname(param_00);
	if(var_01 == "iw7_rvn" || var_01 == "iw7_cheytac" || var_01 == "iw7_tacburst")
	{
		return 1;
	}

	var_02 = function_02C4(param_00);
	if(isdefined(var_02))
	{
		if(var_01 == "iw7_sdfar" && var_02 != 3 && var_02 != 35)
		{
			return 1;
		}

		if(var_01 == "iw7_revolver" && var_02 != 3 && var_02 != 35)
		{
			return 1;
		}

		if(var_01 == "iw7_gauss" && var_02 == 1 || var_02 == 33 || var_02 == 2 || var_02 == 34 || var_02 == 3 || var_02 == 35)
		{
			return 1;
		}

		if(var_01 == "iw7_sonic" && var_02 == 4 || var_02 == 36)
		{
			return 1;
		}

		if(var_01 == "iw7_m8" && var_02 == 4 || var_02 == 36)
		{
			return 1;
		}

		if(var_01 == "iw7_emc" && var_02 == 3 || var_02 == 35)
		{
			return 1;
		}
	}
	else if(var_01 == "iw7_sdfar" || var_01 == "iw7_revolver")
	{
		return 1;
	}

	return 0;
}

//Function Number: 212
getbaseperkname(param_00)
{
	if(isendstr(param_00,"_ks"))
	{
		param_00 = getsubstr(param_00,0,param_00.size - 3);
	}

	return param_00;
}

//Function Number: 213
getvalidextraammoweapons()
{
	var_00 = [];
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		var_04 = weaponclass(var_03);
		if(!iskillstreakweapon(var_03) && var_04 != "grenade" && var_04 != "rocketlauncher" && self getweaponammostock(var_03) != 0)
		{
			var_00[var_00.size] = var_03;
		}
	}

	return var_00;
}

//Function Number: 214
riotshield_hasweapon()
{
	var_00 = 0;
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		if(scripts\mp\weapons::isriotshield(var_03))
		{
			var_00 = 1;
			break;
		}
	}

	return var_00;
}

//Function Number: 215
riotshield_hastwo()
{
	var_00 = 0;
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		if(scripts\mp\weapons::isriotshield(var_03))
		{
			var_00++;
		}

		if(var_00 == 2)
		{
			break;
		}
	}

	return var_00 == 2;
}

//Function Number: 216
riotshield_attach(param_00,param_01)
{
	var_02 = undefined;
	if(param_00)
	{
		self.riotshieldmodel = param_01;
		var_02 = "tag_weapon_right";
	}
	else
	{
		self.riotshieldmodelstowed = param_01;
		var_02 = "tag_shield_back";
	}

	self attachshieldmodel(param_01,var_02);
	self.hasriotshield = riotshield_hasweapon();
}

//Function Number: 217
riotshield_detach(param_00)
{
	var_01 = undefined;
	var_02 = undefined;
	if(param_00)
	{
		var_01 = self.riotshieldmodel;
		var_02 = "tag_weapon_right";
	}
	else
	{
		var_01 = self.riotshieldmodelstowed;
		var_02 = "tag_shield_back";
	}

	self detachshieldmodel(var_01,var_02);
	if(param_00)
	{
		self.riotshieldmodel = undefined;
	}
	else
	{
		self.riotshieldmodelstowed = undefined;
	}

	self.hasriotshield = riotshield_hasweapon();
}

//Function Number: 218
riotshield_move(param_00)
{
	var_01 = undefined;
	var_02 = undefined;
	var_03 = undefined;
	if(param_00)
	{
		var_03 = self.riotshieldmodel;
		var_01 = "tag_weapon_right";
		var_02 = "tag_shield_back";
	}
	else
	{
		var_03 = self.riotshieldmodelstowed;
		var_01 = "tag_shield_back";
		var_02 = "tag_weapon_right";
	}

	self moveshieldmodel(var_03,var_01,var_02);
	if(param_00)
	{
		self.riotshieldmodelstowed = var_03;
		self.riotshieldmodel = undefined;
		return;
	}

	self.riotshieldmodel = var_03;
	self.riotshieldmodelstowed = undefined;
}

//Function Number: 219
riotshield_clear()
{
	self.hasriotshieldequipped = 0;
	self.hasriotshield = 0;
	self.riotshieldmodelstowed = undefined;
	self.riotshieldmodel = undefined;
}

//Function Number: 220
riotshield_getmodel()
{
	return scripts\engine\utility::ter_op(isjuggernaut(),"weapon_riot_shield_jug_iw6","weapon_riot_shield_iw6");
}

//Function Number: 221
func_C793(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = level.players;
	var_06 = scripts\mp\outline::func_C78A(param_01);
	var_07 = scripts\mp\outline::func_C7A9(param_04);
	return scripts\mp\outline::outlineenableinternal(param_00,var_06,var_05,param_02,param_03,var_07,"ALL");
}

//Function Number: 222
outlineenableforteam(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = getteamarray(param_02,0);
	var_07 = scripts\mp\outline::func_C78A(param_01);
	var_08 = scripts\mp\outline::func_C7A9(param_05);
	return scripts\mp\outline::outlineenableinternal(param_00,var_07,var_06,param_03,param_04,var_08,"TEAM",param_02);
}

//Function Number: 223
outlineenableforplayer(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = scripts\mp\outline::func_C78A(param_01);
	var_07 = scripts\mp\outline::func_C7A9(param_05);
	if(isagent(param_02))
	{
		return scripts\mp\outline::outlinegenerateuniqueid();
	}

	return scripts\mp\outline::outlineenableinternal(param_00,var_06,[param_02],param_03,param_04,var_07,"ENTITY");
}

//Function Number: 224
outlinedisable(param_00,param_01)
{
	scripts\mp\outline::outlinedisableinternal(param_00,param_01);
}

//Function Number: 225
func_C7AA(param_00)
{
	scripts\mp\outline::func_C7AB(param_00);
}

//Function Number: 226
func_98AA()
{
	level.var_C7A1 = [];
	level.var_C7A2 = 0;
}

//Function Number: 227
func_180C(param_00,param_01)
{
	var_02 = spawnstruct();
	var_02.weaponisauto = param_00;
	var_02.fgetarg = param_01;
	var_03 = level.var_C7A2;
	level.var_C7A1[var_03] = var_02;
	level.var_C7A2++;
	return var_03;
}

//Function Number: 228
func_E14A(param_00)
{
	level.var_C7A1[param_00] = undefined;
}

//Function Number: 229
func_C7A0(param_00,param_01)
{
	foreach(var_03 in level.var_C7A1)
	{
		if(!isdefined(var_03) || !isdefined(var_03.weaponisauto) || !isdefined(var_03.fgetarg))
		{
			continue;
		}

		if(scripts\engine\utility::segmentvssphere(param_00,param_01,var_03.weaponisauto,var_03.fgetarg))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 230
playsoundinspace(param_00,param_01)
{
	playsoundatpos(param_01,param_00);
}

//Function Number: 231
func_ACDD(param_00,param_01)
{
	var_02 = 1;
	for(var_03 = 0;var_03 < param_01;var_03++)
	{
		var_02 = var_02 * 10;
	}

	var_04 = param_00 * var_02;
	var_04 = int(var_04);
	var_04 = var_04 / var_02;
	return var_04;
}

//Function Number: 232
func_E75C(param_00,param_01,param_02)
{
	if(!isdefined(param_02))
	{
		param_02 = "nearest";
	}

	var_03 = 1;
	for(var_04 = 0;var_04 < param_01;var_04++)
	{
		var_03 = var_03 * 10;
	}

	var_05 = param_00 * var_03;
	if(param_02 == "up")
	{
		var_06 = ceil(var_05);
	}
	else if(var_03 == "down")
	{
		var_06 = floor(var_06);
	}
	else
	{
		var_06 = var_06 + 0.5;
	}

	var_05 = int(var_06);
	var_05 = var_05 / var_03;
	return var_05;
}

//Function Number: 233
func_D38F(param_00)
{
	foreach(var_02 in level.players)
	{
		if(var_02.clientid == param_00)
		{
			return var_02;
		}
	}

	return undefined;
}

//Function Number: 234
func_1114F(param_00)
{
	var_01 = strtok(param_00,".");
	var_02 = int(var_01[0]);
	if(isdefined(var_01[1]))
	{
		var_03 = 1;
		for(var_04 = 0;var_04 < var_01[1].size;var_04++)
		{
			var_03 = var_03 * 0.1;
		}

		var_02 = var_02 + int(var_01[1]) * var_03;
	}

	return var_02;
}

//Function Number: 235
setselfusable(param_00)
{
	self makeusable();
	foreach(var_02 in level.players)
	{
		if(var_02 != param_00)
		{
			self disableplayeruse(var_02);
			continue;
		}

		self enableplayeruse(var_02);
	}
}

//Function Number: 236
func_F63C()
{
	foreach(var_01 in level.players)
	{
		self disableplayeruse(var_01);
	}
}

//Function Number: 237
func_B2B4(param_00)
{
	self makeusable();
	thread func_1438(param_00);
}

//Function Number: 238
func_1438(param_00)
{
	self endon("death");
	for(;;)
	{
		foreach(var_02 in level.players)
		{
			if(var_02.team == param_00)
			{
				self enableplayeruse(var_02);
				continue;
			}

			self disableplayeruse(var_02);
		}

		level waittill("joined_team");
	}
}

//Function Number: 239
makeenemyusable(param_00)
{
	self makeusable();
	thread func_1437(param_00);
}

//Function Number: 240
func_1437(param_00)
{
	self endon("death");
	var_01 = param_00.team;
	for(;;)
	{
		if(level.teambased)
		{
			foreach(var_03 in level.players)
			{
				if(var_03.team != var_01)
				{
					self enableplayeruse(var_03);
					continue;
				}

				self disableplayeruse(var_03);
			}
		}
		else
		{
			foreach(var_03 in level.players)
			{
				if(var_03 != param_00)
				{
					self enableplayeruse(var_03);
					continue;
				}

				self disableplayeruse(var_03);
			}
		}

		level waittill("joined_team");
	}
}

//Function Number: 241
initgameflags()
{
	if(!isdefined(game["flags"]))
	{
		game["flags"] = [];
	}
}

//Function Number: 242
gameflaginit(param_00,param_01)
{
	game["flags"][param_00] = param_01;
}

//Function Number: 243
gameflag(param_00)
{
	return game["flags"][param_00];
}

//Function Number: 244
gameflagset(param_00)
{
	game["flags"][param_00] = 1;
	level notify(param_00);
}

//Function Number: 245
gameflagclear(param_00)
{
	game["flags"][param_00] = 0;
}

//Function Number: 246
gameflagwait(param_00)
{
	while(!gameflag(param_00))
	{
		level waittill(param_00);
	}
}

//Function Number: 247
func_9F0D(param_00)
{
	if(param_00 == "MOD_RIFLE_BULLET" || param_00 == "MOD_PISTOL_BULLET")
	{
		return 1;
	}

	return 0;
}

//Function Number: 248
isfmjdamage(param_00,param_01)
{
	var_02 = 0;
	if(isdefined(param_01) && scripts\engine\utility::isbulletdamage(param_01))
	{
		var_03 = getweaponattachmentsbasenames(param_00);
		foreach(var_05 in var_03)
		{
			if(var_05 == "fmj" || var_05 == "reflect")
			{
				var_02 = 1;
				break;
			}
		}
	}

	return var_02;
}

//Function Number: 249
initlevelflags()
{
	if(!isdefined(level.levelflags))
	{
		level.levelflags = [];
	}
}

//Function Number: 250
levelflaginit(param_00,param_01)
{
	level.levelflags[param_00] = param_01;
}

//Function Number: 251
levelflag(param_00)
{
	return level.levelflags[param_00];
}

//Function Number: 252
func_ABF4(param_00)
{
	level.levelflags[param_00] = 1;
	level notify(param_00);
}

//Function Number: 253
levelflagclear(param_00)
{
	level.levelflags[param_00] = 0;
	level notify(param_00);
}

//Function Number: 254
func_ABF5(param_00)
{
	while(!levelflag(param_00))
	{
		level waittill(param_00);
	}
}

//Function Number: 255
func_ABF6(param_00)
{
	while(levelflag(param_00))
	{
		level waittill(param_00);
	}
}

//Function Number: 256
iskillstreakdenied()
{
	return scripts\mp\killstreaks\_emp_common::isemped() || isairdenied();
}

//Function Number: 257
isairdenied()
{
	if(self.team == "spectator")
	{
		return 0;
	}

	if(level.teambased)
	{
		return level.teamairdenied[self.team];
	}

	return isdefined(level.airdeniedplayer) && level.airdeniedplayer != self;
}

//Function Number: 258
func_9EBB()
{
	if(self.team == "spectator")
	{
		return 0;
	}

	return isdefined(self.nuked);
}

//Function Number: 259
getplayerforguid(param_00)
{
	foreach(var_02 in level.players)
	{
		if(var_02.guid == param_00)
		{
			return var_02;
		}
	}

	return undefined;
}

//Function Number: 260
teamplayercardsplash(param_00,param_01,param_02,param_03)
{
	if(level.hardcoremode)
	{
		return;
	}

	foreach(var_05 in level.players)
	{
		if(var_05 ismlgspectator())
		{
			var_06 = var_05 getspectatingplayer();
			if(isdefined(var_06) && isdefined(param_02) && var_06.team != param_02)
			{
				continue;
			}
		}
		else
		{
			if(isdefined(param_02) && var_05.team != param_02)
			{
				continue;
			}

			if(!isplayer(var_05))
			{
				continue;
			}
		}

		var_05 thread scripts\mp\hud_message::showsplash(param_00,param_03,param_01);
	}
}

//Function Number: 261
ispickedupweapon(param_00)
{
	if(iscacprimaryweapon(param_00) || iscacsecondaryweapon(param_00))
	{
		if(issubstr(param_00,"alt_") && param_00 != "iw7_venomx_mp+venomxalt_burst")
		{
			param_00 = getsubstr(param_00,4,param_00.size);
		}

		var_01 = isdefined(self.pers["primaryWeapon"]) && self.pers["primaryWeapon"] == param_00;
		var_02 = isdefined(self.pers["secondaryWeapon"]) && self.pers["secondaryWeapon"] == param_00;
		if(!var_01 && !var_02)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 262
iscacprimaryweapon(param_00)
{
	switch(getweapongroup(param_00))
	{
		case "weapon_riot":
		case "weapon_shotgun":
		case "weapon_sniper":
		case "weapon_dmr":
		case "weapon_lmg":
		case "weapon_assault":
		case "weapon_smg":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 263
iscacsecondaryweapon(param_00)
{
	switch(getweapongroup(param_00))
	{
		case "weapon_machine_pistol":
		case "weapon_projectile":
		case "weapon_rail":
		case "weapon_beam":
		case "weapon_pistol":
		case "weapon_melee":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 264
iscacmeleeweapon(param_00)
{
	return getweapongroup(param_00) == "weapon_melee";
}

//Function Number: 265
getlastlivingplayer(param_00)
{
	var_01 = undefined;
	foreach(var_03 in level.players)
	{
		if(isdefined(param_00) && var_03.team != param_00)
		{
			continue;
		}

		if(!isreallyalive(var_03) && !var_03 scripts\mp\playerlogic::mayspawn())
		{
			continue;
		}

		if(isdefined(var_03.switching_teams) && var_03.switching_teams)
		{
			continue;
		}

		var_01 = var_03;
	}

	return var_01;
}

//Function Number: 266
getpotentiallivingplayers()
{
	var_00 = [];
	foreach(var_02 in level.players)
	{
		if(!isreallyalive(var_02) && !var_02 scripts\mp\playerlogic::mayspawn())
		{
			continue;
		}

		if(getdvarint("com_codcasterEnabled",0) == 1)
		{
			if(var_02 ismlgspectator())
			{
				continue;
			}
		}

		var_00[var_00.size] = var_02;
	}

	return var_00;
}

//Function Number: 267
waittillrecoveredhealth(param_00,param_01)
{
	self endon("death");
	self endon("disconnect");
	var_02 = 0;
	if(!isdefined(param_01))
	{
		param_01 = 0.05;
	}

	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	for(;;)
	{
		if(self.health != self.maxhealth)
		{
			var_02 = 0;
		}
		else
		{
			var_02 = var_02 + param_01;
		}

		wait(param_01);
		if(self.health == self.maxhealth && var_02 >= param_00)
		{
			break;
		}
	}
}

//Function Number: 268
enableweaponlaser()
{
	if(!isdefined(self.weaponlasercalls))
	{
		self.weaponlasercalls = 0;
	}

	self.var_13C9E++;
	self laseron();
}

//Function Number: 269
disableweaponlaser()
{
	self.var_13C9E--;
	if(self.weaponlasercalls == 0)
	{
		self laseroff();
		self.weaponlasercalls = undefined;
	}
}

//Function Number: 270
attachmentmap_tounique(param_00,param_01)
{
	var_02 = getweaponrootname(param_01);
	if(var_02 != param_01)
	{
		var_03 = getweaponbasename(param_01);
		if(isdefined(level.attachmentmap_basetounique[var_03]) && isdefined(level.attachmentmap_uniquetobase[param_00]) && isdefined(level.attachmentmap_basetounique[var_03][level.attachmentmap_uniquetobase[param_00]]))
		{
			var_04 = level.attachmentmap_uniquetobase[param_00];
			return level.attachmentmap_basetounique[var_03][var_04];
		}
		else if(isdefined(level.attachmentmap_basetounique[var_04]) && isdefined(level.attachmentmap_basetounique[var_04][param_01]))
		{
			return level.attachmentmap_basetounique[var_04][param_01];
		}
		else
		{
			var_05 = strtok(var_04,"_");
			if(var_05.size > 3)
			{
				var_06 = var_05[0] + "_" + var_05[1] + "_" + var_05[2];
				if(isdefined(level.attachmentmap_basetounique[var_06]) && isdefined(level.attachmentmap_basetounique[var_06][param_01]))
				{
					return level.attachmentmap_basetounique[var_06][param_01];
				}
			}
		}
	}

	if(isdefined(level.attachmentmap_basetounique[var_03]) && isdefined(level.attachmentmap_basetounique[var_03][param_01]))
	{
		return level.attachmentmap_basetounique[var_03][param_01];
	}
	else
	{
		var_07 = weapongroupmap(var_03);
		if(isdefined(level.attachmentmap_basetounique[var_07]) && isdefined(level.attachmentmap_basetounique[var_07][param_01]))
		{
			return level.attachmentmap_basetounique[var_07][param_01];
		}
	}

	return param_01;
}

//Function Number: 271
attachmentperkmap(param_00)
{
	if(isdefined(level.attachmentmap_attachtoperk[param_00]))
	{
		return level.attachmentmap_attachtoperk[param_00];
	}

	return undefined;
}

//Function Number: 272
func_13C75(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].var_23B0))
	{
		param_00 = level.weaponmapdata[param_00].var_23B0;
	}

	return param_00;
}

//Function Number: 273
func_13CB4(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].perk))
	{
		return level.weaponmapdata[param_00].perk;
	}

	return undefined;
}

//Function Number: 274
weapongroupmap(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].group))
	{
		return level.weaponmapdata[param_00].group;
	}

	return undefined;
}

//Function Number: 275
func_13CAC(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].number))
	{
		return level.weaponmapdata[param_00].number;
	}
}

//Function Number: 276
weaponattachdefaultmap(param_00)
{
	if(isdefined(level.weaponmapdata[param_00]) && isdefined(level.weaponmapdata[param_00].attachdefaults))
	{
		return level.weaponmapdata[param_00].attachdefaults;
	}

	return undefined;
}

//Function Number: 277
func_13C86(param_00)
{
	return isdefined(level.weaponmapdata[param_00]);
}

//Function Number: 278
weaponattachremoveextraattachments(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		if(isdefined(level.attachmentextralist[var_03]))
		{
			continue;
		}

		var_01[var_01.size] = var_03;
	}

	return var_01;
}

//Function Number: 279
func_9D55(param_00,param_01)
{
	var_02 = strtok(param_00,"_");
	return func_9D56(var_02,param_01);
}

//Function Number: 280
func_9D56(param_00,param_01)
{
	var_02 = 0;
	if(param_00.size && isdefined(param_01))
	{
		var_03 = 0;
		if(param_00[0] == "alt")
		{
			var_03 = 1;
		}

		if(param_00.size >= 3 + var_03 && param_00[var_03] == "iw6" || param_00[var_03] == "iw7")
		{
			if(weaponclass(param_00[var_03] + "_" + param_00[var_03 + 1] + "_" + param_00[var_03 + 2]) == "sniper")
			{
				var_02 = param_00[var_03 + 1] + "scope" == param_01;
			}
		}
	}

	return var_02;
}

//Function Number: 281
getweaponattachmentsbasenames(param_00)
{
	if(param_00 != "none")
	{
		var_01 = function_00E3(param_00);
		foreach(var_04, var_03 in var_01)
		{
			var_01[var_04] = attachmentmap_tobase(var_03);
		}

		return var_01;
	}

	return [];
}

//Function Number: 282
getattachmentlistbasenames()
{
	var_00 = [];
	var_01 = 0;
	var_02 = tablelookup("mp/attachmentTable.csv",0,var_01,5);
	while(var_02 != "")
	{
		var_03 = tablelookup("mp/attachmentTable.csv",0,var_01,2);
		if(var_03 != "none" && !scripts\engine\utility::array_contains(var_00,var_02))
		{
			var_00[var_00.size] = var_02;
		}

		var_01++;
		var_02 = tablelookup("mp/attachmentTable.csv",0,var_01,5);
	}

	return var_00;
}

//Function Number: 283
attachmentmap_tobase(param_00)
{
	if(isdefined(level.attachmentmap_uniquetobase[param_00]))
	{
		param_00 = level.attachmentmap_uniquetobase[param_00];
	}

	return param_00;
}

//Function Number: 284
attachmentmap_toextra(param_00)
{
	var_01 = undefined;
	if(isdefined(level.attachmentmap_uniquetoextra[param_00]))
	{
		var_01 = level.attachmentmap_uniquetoextra[param_00];
	}

	return var_01;
}

//Function Number: 285
func_13CA1(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		switch(param_00)
		{
			case "domeshield_plant_mp":
				param_00 = "domeshield_mp";
				break;

			case "power_exploding_drone_transform_mp":
				param_00 = "power_exploding_drone_mp";
				break;

			case "semtexproj_mp":
				param_00 = "iw6_mk32_mp";
				break;

			case "iw6_semtexshards_mp":
				param_00 = "venomproj_mp";
				break;

			case "globproj_mp":
				param_00 = "splash_grenade_mp";
				break;

			case "niagara_mini_mp":
				param_00 = "iw7_niagara_mp";
				break;

			case "wristrocket_proj_mp":
				param_00 = "wristrocket_mp";
				break;

			case "split_grenade_mini_mp":
				param_00 = "split_grenade_mp";
				break;

			case "destructible_toy":
				if(isdefined(param_01))
				{
					if(isdefined(param_01.weapon_name))
					{
						param_00 = param_01.weapon_name;
					}
					else
					{
						param_00 = "destructible_car";
					}
	
					if(!istrue(param_02))
					{
						param_00 = func_13CA1(param_00,param_01,1);
					}
				}
				break;

			case "iw7_spas_mpr_focus":
				param_00 = "iw7_spas_mpr";
				break;

			case "iw7_erad_mp_jump_spread":
				param_00 = "iw7_erad_mp";
				break;

			case "gltacburst":
				param_00 = "alt_iw7_tacburst_mp";
				break;

			case "gltacburst_regen":
			case "gltacburst_big":
				param_00 = "alt_iw7_tacburst_mpl";
				break;

			default:
				var_03 = self;
				if(param_00 != "alt_none" && getweaponrootname(param_00) == "iw7_axe")
				{
					if(isdefined(param_01))
					{
						var_03 = param_01;
						if(!isplayer(param_01) && isdefined(param_01.triggerportableradarping))
						{
							var_03 = param_01.triggerportableradarping;
						}
	
						if(isdefined(param_01.classname) && param_01.classname != "grenade" && var_03 getweaponammoclip(param_00) == 0)
						{
							param_00 = "iw7_fists_mp";
						}
					}
				}
				break;
		}
	}

	return param_00;
}

//Function Number: 286
func_249F(param_00)
{
	var_01 = [];
	foreach(var_03 in param_00)
	{
		if(func_2490(var_03))
		{
			var_01[var_01.size] = var_03;
		}
	}

	return var_01;
}

//Function Number: 287
func_2490(param_00)
{
	if(func_248F(param_00))
	{
		return 0;
	}

	if(func_248E(param_00))
	{
		return 0;
	}

	switch(param_00)
	{
		case "glmp28_smoke":
		case "glsmoke_slow":
		case "glsmoke":
		case "shotgunlongshot":
		case "meleervn":
		case "axefists":
		case "arripper":
		case "arm8":
		case "gltacburst_regen":
		case "gltacburst_big":
		case "gltacburst":
		case "scope":
			return 0;
	}

	return 1;
}

//Function Number: 288
func_13C94(param_00)
{
	return 0;
}

//Function Number: 289
func_13C9B(param_00)
{
	if(func_13C91(param_00))
	{
		return 1;
	}

	return weaponhasattachment(param_00,"firetypeburst");
}

//Function Number: 290
func_13C9C(param_00)
{
	var_01 = getweaponrootname(param_00);
	return var_01 == "iw7_spas" || var_01 == "iw7_spasc" || var_01 == "iw7_sonic";
}

//Function Number: 291
func_13C91(param_00)
{
	var_01 = getweaponrootname(param_00);
	if(var_01 == "iw7_sdfar")
	{
		var_02 = getweaponattachmentsbasenames(param_00);
		foreach(var_04 in var_02)
		{
			if(var_04 == "firetypeauto" || var_04 == "firetypesingle")
			{
				return 0;
			}
		}

		return 1;
	}

	return 0;
}

//Function Number: 292
func_13C93(param_00)
{
	return param_00 == "iw6_g28";
}

//Function Number: 293
func_13C92(param_00)
{
	return param_00 == "iw6_cbjms";
}

//Function Number: 294
func_13C95(param_00)
{
	var_01 = getweaponrootname(param_00);
	if(var_01 == "iw6_dlcweap03")
	{
		var_02 = function_00E3(param_00);
		foreach(var_04 in var_02)
		{
			if(isstrstart(var_04,"dlcweap03"))
			{
				return 1;
			}
		}
	}

	return 0;
}

//Function Number: 295
weaponhasattachment(param_00,param_01)
{
	var_02 = getweaponattachmentsbasenames(param_00);
	foreach(var_04 in var_02)
	{
		if(var_04 == param_01)
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 296
func_9EE8()
{
	return self getweaponrankinfominxp() > 0.5;
}

//Function Number: 297
touchingbadtrigger()
{
	var_00 = getentarray("trigger_hurt","classname");
	foreach(var_02 in var_00)
	{
		if(self istouching(var_02))
		{
			return 1;
		}
	}

	var_04 = getentarray("radiation","targetname");
	foreach(var_02 in var_04)
	{
		if(self istouching(var_02))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 298
func_11A44()
{
	if(istrue(self.allowedintrigger))
	{
		return 0;
	}

	foreach(var_01 in level.var_C7B3)
	{
		if(self istouching(var_01))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 299
touchingballallowedtrigger()
{
	if(!istrue(level.ballallowedtriggers.size))
	{
		return 0;
	}

	self.allowedintrigger = 0;
	foreach(var_01 in level.ballallowedtriggers)
	{
		if(self istouching(var_01))
		{
			self.allowedintrigger = 1;
			return 1;
		}
	}

	return 0;
}

//Function Number: 300
touchingplayerallowedtrigger()
{
	if(!istrue(level.playerallowedtriggers.size))
	{
		return 0;
	}

	self.allowedintrigger = 0;
	foreach(var_01 in level.playerallowedtriggers)
	{
		if(self istouching(var_01))
		{
			self.allowedintrigger = 1;
			return 1;
		}
	}

	return 0;
}

//Function Number: 301
setthirdpersondof(param_00)
{
	if(param_00)
	{
		self setdepthoffield(0,110,512,4096,6,1.8);
		return;
	}

	self setdepthoffield(0,0,512,512,4,0);
}

//Function Number: 302
killtrigger(param_00,param_01,param_02)
{
	var_03 = spawn("trigger_radius",param_00,0,param_01,param_02);
	for(;;)
	{
		var_03 waittill("trigger",var_04);
		if(!isplayer(var_04))
		{
			continue;
		}

		var_04 suicide();
	}
}

//Function Number: 303
findisfacing(param_00,param_01,param_02)
{
	var_03 = cos(param_02);
	var_04 = anglestoforward(param_00.angles);
	var_05 = param_01.origin - param_00.origin;
	var_04 = var_04 * (1,1,0);
	var_05 = var_05 * (1,1,0);
	var_05 = vectornormalize(var_05);
	var_04 = vectornormalize(var_04);
	var_06 = vectordot(var_05,var_04);
	if(var_06 >= var_03)
	{
		return 1;
	}

	return 0;
}

//Function Number: 304
func_5B75(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = int(param_03 * 20);
	for(var_06 = 0;var_06 < var_05;var_06++)
	{
		wait(0.05);
	}
}

//Function Number: 305
drawline(param_00,param_01,param_02,param_03)
{
	var_04 = int(param_02 * 20);
	for(var_05 = 0;var_05 < var_04;var_05++)
	{
		wait(0.05);
	}
}

//Function Number: 306
drawsphere(param_00,param_01,param_02,param_03)
{
	var_04 = int(param_02 * 20);
	for(var_05 = 0;var_05 < var_04;var_05++)
	{
		wait(0.05);
	}
}

//Function Number: 307
setrecoilscale(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	if(!isdefined(self.recoilscale))
	{
		self.recoilscale = param_00;
	}
	else
	{
		self.recoilscale = self.recoilscale + param_00;
	}

	if(isdefined(param_01))
	{
		if(isdefined(self.recoilscale) && param_01 < self.recoilscale)
		{
			param_01 = self.recoilscale;
		}

		var_02 = 100 - param_01;
	}
	else
	{
		var_02 = 100 - self.recoilscale;
	}

	if(var_02 < 0)
	{
		var_02 = 0;
	}

	if(var_02 > 100)
	{
		var_02 = 100;
	}

	if(var_02 == 100)
	{
		self player_recoilscaleoff();
		return;
	}

	self player_recoilscaleon(var_02);
}

//Function Number: 308
cleanarray(param_00)
{
	var_01 = [];
	foreach(var_04, var_03 in param_00)
	{
		if(!isdefined(var_03))
		{
			continue;
		}

		var_01[var_01.size] = param_00[var_04];
	}

	return var_01;
}

//Function Number: 309
notusableforjoiningplayers(param_00)
{
	self notify("notusablejoiningplayers");
	self endon("death");
	level endon("game_ended");
	param_00 endon("disconnect");
	param_00 endon("death");
	self endon("notusablejoiningplayers");
	self endon("makeExplosiveUnusable");
	for(;;)
	{
		level waittill("player_spawned",var_01);
		if(isdefined(var_01) && var_01 != param_00)
		{
			self disableplayeruse(var_01);
		}
	}
}

//Function Number: 310
isstrstart(param_00,param_01)
{
	return getsubstr(param_00,0,param_01.size) == param_01;
}

//Function Number: 311
disableallstreaks()
{
	level.killstreaksdisabled = 1;
}

//Function Number: 312
enableallstreaks()
{
	level.killstreaksdisabled = undefined;
}

//Function Number: 313
validateusestreak(param_00,param_01)
{
	if(isdefined(level.killstreaksdisabled) && level.killstreaksdisabled)
	{
		return 0;
	}

	if((!self isonground() || self gold_teeth_hint_func()) && func_9F2C(param_00) || func_9D82(param_00) || func_9FB7(param_00) || func_9E90(param_00))
	{
		scripts\mp\hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE");
		return 0;
	}

	if(isusingremote())
	{
		return 0;
	}

	if(isdefined(self.selectinglocation))
	{
		return 0;
	}

	if(scripts\mp\killstreaks\_emp_common::isemped())
	{
		if(iskillstreakaffectedbyemp(param_00))
		{
			if(!isdefined(param_01) && param_01)
			{
				scripts\mp\hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE_WHEN_JAMMED");
			}

			return 0;
		}
	}

	if(isairdenied())
	{
		if(isflyingkillstreak(param_00) && param_00 != "air_superiority")
		{
			if(!isdefined(param_01) && param_01)
			{
				scripts\mp\hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE_WHEN_AA");
			}

			return 0;
		}
	}

	if(self isusingturret() && func_9F2C(param_00) || func_9D82(param_00) || func_9FB7(param_00))
	{
		if(!isdefined(param_01) && param_01)
		{
			scripts\mp\hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE_USING_TURRET");
		}

		return 0;
	}

	if(isdefined(self.setlasermaterial) && !_hasperk("specialty_finalstand"))
	{
		if(!isdefined(level.var_1C99) || !level.var_1C99 || param_00 != "agent")
		{
			if(!isdefined(param_01) && param_01)
			{
				scripts\mp\hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE_IN_LASTSTAND");
			}

			return 0;
		}
	}

	if(!scripts\engine\utility::isweaponallowed())
	{
		return 0;
	}

	if(isdefined(level.var_3FD9) && isflyingkillstreak(param_00))
	{
		if(!isdefined(param_01) && param_01)
		{
			scripts\mp\hud_message::showerrormessage("KILLSTREAKS_CIVILIAN_AIR_TRAFFIC");
		}

		return 0;
	}

	if(isdefined(param_00) && param_00 == "sentry_shock" && isinarbitraryup())
	{
		if(!isdefined(param_01) && param_01)
		{
			scripts\mp\hud_message::showerrormessage("KILLSTREAKS_UNAVAILABLE");
		}

		return 0;
	}

	return 1;
}

//Function Number: 314
func_9F2C(param_00)
{
	switch(param_00)
	{
		case "thor":
		case "minijackal":
		case "drone_hive":
		case "venom":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 315
func_9E90(param_00)
{
	switch(param_00)
	{
		case "bombardment":
		case "precision_airstrike":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 316
func_9EF0(param_00)
{
	if(!isdefined(param_00.var_165A))
	{
		return 0;
	}

	switch(param_00.var_165A)
	{
		case "remote_c8":
		case "spiderbot":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 317
func_9D82(param_00)
{
	switch(param_00)
	{
		case "ims":
		case "deployable_exp_ammo":
		case "deployable_grenades":
		case "deployable_ammo":
		case "deployable_vest":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 318
func_9FBA(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "directional_uav":
		case "counter_uav":
		case "uav":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 319
func_9D35(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "precision_airstrike":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 320
func_9E7F(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "airdrop":
		case "dronedrop":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 321
func_9E2D(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "jammer":
		case "jackal":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 322
func_9F67(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "minijackal":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 323
func_9D61(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "ball_drone_backup":
		case "venom":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 324
func_9FB7(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "super_trophy":
		case "sentry_shock":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 325
func_9F0F(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "bombardment":
		case "thor":
		case "drone_hive":
			var_01 = 1;
			break;
	}

	return var_01;
}

//Function Number: 326
func_9D80(param_00)
{
	return isdefined(param_00) && isdefined(param_00.id) && param_00.id == "care_package";
}

//Function Number: 327
func_10060(param_00)
{
	switch(param_00)
	{
		case "dronedrop":
		case "directional_uav":
		case "counter_uav":
		case "uav":
			return 0;

		default:
			return 1;
	}
}

//Function Number: 328
iskillstreakaffectedbyemp(param_00)
{
	switch(param_00)
	{
		case "fleet_swarm":
		case "zerosub_level_killstreak":
		case "dome_seekers":
		case "guard_dog":
		case "recon_agent":
		case "deployable_ammo":
		case "deployable_vest":
		case "precision_airstrike":
		case "minijackal":
		case "agent":
		case "spiderbot":
			return 0;

		default:
			return 1;
	}
}

//Function Number: 329
iskillstreakaffectedbyjammer(param_00)
{
	return iskillstreakaffectedbyemp(param_00) && !isflyingkillstreak(param_00);
}

//Function Number: 330
func_9E6A(param_00)
{
	switch(param_00)
	{
		case "bombardment":
			return 0;

		default:
			return 1;
	}
}

//Function Number: 331
isflyingkillstreak(param_00)
{
	switch(param_00)
	{
		case "orbital_deployment":
		case "ac130":
		case "ca_a10_strafe":
		case "vanguard":
		case "odin_assault":
		case "odin_support":
		case "heli_pilot":
		case "airdrop_juggernaut_maniac":
		case "airdrop_assault":
		case "heli_sniper":
		case "airdrop_juggernaut_recon":
		case "airdrop_juggernaut":
		case "airdrop_sentry_minigun":
		case "helicopter":
		case "fleet_swarm":
		case "airdrop":
		case "precision_airstrike":
		case "thor":
		case "drone_hive":
		case "air_superiority":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 332
func_7F4D(param_00)
{
	return tablelookuprownum("mp/killstreakTable.csv",1,param_00);
}

//Function Number: 333
getkillstreakindex(param_00)
{
	var_01 = tablelookup("mp/killstreakTable.csv",1,param_00,0);
	if(var_01 == "")
	{
		var_02 = -1;
	}
	else
	{
		var_02 = int(var_02);
	}

	return var_02;
}

//Function Number: 334
func_7F4B(param_00)
{
	return tablelookup("mp/killstreakTable.csv",0,param_00,1);
}

//Function Number: 335
func_7F4C(param_00)
{
	return tablelookup("mp/killstreakTable.csv",12,param_00,1);
}

//Function Number: 336
func_7F47(param_00)
{
	return tablelookupistring("mp/killstreakTable.csv",1,param_00,2);
}

//Function Number: 337
func_7F38(param_00)
{
	return tablelookupistring("mp/killstreakTable.csv",1,param_00,3);
}

//Function Number: 338
func_7F46(param_00)
{
	var_01 = scripts\engine\utility::ter_op(_hasperk("specialty_support_killstreaks"),5,4);
	return tablelookup("mp/killstreakTable.csv",1,param_00,var_01);
}

//Function Number: 339
getenemyinfo(param_00)
{
	var_01 = strtok(param_00,"_");
	return var_01[1];
}

//Function Number: 340
func_7F3C(param_00)
{
	return tablelookupistring("mp/killstreakTable.csv",1,param_00,6);
}

//Function Number: 341
func_7F51(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,7);
}

//Function Number: 342
func_7F3B(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,8);
}

//Function Number: 343
func_7F34(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,9);
}

//Function Number: 344
func_7F3E(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,10);
}

//Function Number: 345
func_7F40(param_00)
{
	return int(tablelookup("mp/killstreakTable.csv",1,param_00,11));
}

//Function Number: 346
getkillstreakweapon(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,12);
}

//Function Number: 347
func_7F4E(param_00)
{
	return int(tablelookup("mp/killstreakTable.csv",1,param_00,13));
}

//Function Number: 348
func_7F43(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,14);
}

//Function Number: 349
getkillstreakoverheadicon(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,15);
}

//Function Number: 350
func_7F39(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,16);
}

//Function Number: 351
func_7F53(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,17);
}

//Function Number: 352
func_7F4F(param_00)
{
	return tablelookup("mp/killstreakTable.csv",1,param_00,18);
}

//Function Number: 353
currentactivevehiclecount(param_00)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	var_01 = param_00;
	if(isdefined(level.helis))
	{
		var_01 = var_01 + level.helis.size;
	}

	if(isdefined(level.littlebirds))
	{
		var_01 = var_01 + level.littlebirds.size;
	}

	if(isdefined(level.ugvs))
	{
		var_01 = var_01 + level.ugvs.size;
	}

	return var_01;
}

//Function Number: 354
maxvehiclesallowed()
{
	return 8;
}

//Function Number: 355
fauxvehiclecount()
{
	return level.fauxvehiclecount;
}

//Function Number: 356
incrementfauxvehiclecount(param_00)
{
	if(!isdefined(param_00))
	{
		level.var_6BAA++;
		return;
	}

	level.fauxvehiclecount = level.fauxvehiclecount + param_00;
}

//Function Number: 357
decrementfauxvehiclecount(param_00)
{
	if(!isdefined(param_00))
	{
		level.var_6BAA--;
	}
	else
	{
		level.fauxvehiclecount = level.fauxvehiclecount - param_00;
	}

	if(level.fauxvehiclecount < 0)
	{
		level.fauxvehiclecount = 0;
	}
}

//Function Number: 358
lightweightscalar()
{
	return 1.06;
}

//Function Number: 359
allowteamassignment()
{
	if(level.gametype == "gun" || level.gametype == "infect")
	{
		return 0;
	}

	if(!isdefined(self.pers["isBot"]))
	{
		if(function_0303())
		{
			return 0;
		}

		if(getdvarint("com_codcasterEnabled",0) > 0)
		{
			return 1;
		}
	}

	if(getdvarint("scr_skipclasschoice",0) > 0 || skiploadout())
	{
		return 0;
	}

	if(level.gametype == "cranked" || level.gametype == "mp_zomb")
	{
		return level.teambased;
	}

	var_00 = int(tablelookup("mp/gametypesTable.csv",0,level.gametype,4));
	return var_00;
}

//Function Number: 360
allowclasschoice()
{
	if(getdvarint("scr_skipclasschoice",0) > 0 || skiploadout())
	{
		return 0;
	}

	var_00 = int(tablelookup("mp/gametypesTable.csv",0,level.gametype,5));
	return var_00;
}

//Function Number: 361
skiploadout()
{
	return istrue(level.aonrules);
}

//Function Number: 362
showfakeloadout()
{
	return 0;
}

//Function Number: 363
func_F6FF(param_00,param_01)
{
	var_02 = getweaponrootname(param_00);
	var_03 = [];
	if(var_02 != "iw7_knife")
	{
		var_03 = function_00E3(param_00);
	}

	if(isdefined(var_02))
	{
		var_04 = tablelookuprownum("mp/statsTable.csv",4,var_02);
	}
	else
	{
	}

	for(var_05 = 0;var_05 < 3;var_05++)
	{
		var_06 = -1;
		if(isdefined(var_03[var_05]))
		{
			if(!func_9D55(param_00,var_03[var_05]))
			{
				var_06 = tablelookuprownum("mp/attachmentTable.csv",4,var_03[var_05]);
			}
		}
	}
}

//Function Number: 364
setcommonrulesfrommatchdata(param_00)
{
	var_01 = getmatchrulesdata("commonOption","timeLimit");
	setdynamicdvar("scr_" + level.gametype + "_timeLimit",var_01);
	registertimelimitdvar(level.gametype,var_01);
	var_02 = getmatchrulesdata("commonOption","scoreLimit");
	setdynamicdvar("scr_" + level.gametype + "_scoreLimit",var_02);
	registerscorelimitdvar(level.gametype,var_02);
	var_03 = getmatchrulesdata("commonOption","winLimit");
	setdynamicdvar("scr_" + level.gametype + "_winLimit",var_03);
	registerwinlimitdvar(level.gametype,var_03);
	var_04 = getmatchrulesdata("commonOption","roundLimit");
	setdynamicdvar("scr_" + level.gametype + "_roundLimit",var_04);
	registerroundlimitdvar(level.gametype,var_04);
	var_05 = getmatchrulesdata("commonOption","roundSwitch");
	setdynamicdvar("scr_" + level.gametype + "_roundSwitch",var_05);
	registerroundswitchdvar(level.gametype,var_05,0,9);
	var_06 = getmatchrulesdata("commonOption","winByTwoEnabled");
	setdynamicdvar("scr_" + level.gametype + "_winByTwoEnabled",var_06);
	registerwinbytwoenableddvar(level.gametype,var_06);
	var_07 = getmatchrulesdata("commonOption","winByTwoMaxRounds");
	setdynamicdvar("scr_" + level.gametype + "_winByTwoMaxRounds",var_07);
	registerwinbytwomaxroundsdvar(level.gametype,var_07);
	var_08 = getmatchrulesdata("commonOption","dogTags");
	setdynamicdvar("scr_" + level.gametype + "_dogTags",var_08);
	registerdogtagsenableddvar(level.gametype,var_08);
	var_09 = getmatchrulesdata("commonOption","spawnProtectionTimer");
	setdynamicdvar("scr_" + level.gametype + "_spawnProtectionTimer",var_09);
	var_0A = getmatchrulesdata("commonOption","numLives");
	setdynamicdvar("scr_" + level.gametype + "_numLives",var_0A);
	registernumlivesdvar(level.gametype,var_0A);
	setdynamicdvar("scr_player_maxhealth",getmatchrulesdata("commonOption","maxHealth"));
	setdynamicdvar("scr_player_healthregentime",getmatchrulesdata("commonOption","healthRegen"));
	level.matchrules_damagemultiplier = 0;
	level.matchrules_vampirism = 0;
	setdynamicdvar("scr_game_spectatetype",getmatchrulesdata("commonOption","spectateModeAllowed"));
	setdynamicdvar("scr_game_allowkillcam",getmatchrulesdata("commonOption","showKillcam"));
	setdvar("camera_allow3rdspectate",getmatchrulesdata("commonOption","spectate3rdAllowed"));
	setdvar("lobby_team_select",getmatchrulesdata("commonOption","teamAssignmentAllowed"));
	setdynamicdvar("scr_game_forceuav",getmatchrulesdata("commonOption","radarAlwaysOn"));
	setdynamicdvar("scr_" + level.gametype + "_playerrespawndelay",getmatchrulesdata("commonOption","respawnDelay"));
	setdynamicdvar("scr_" + level.gametype + "_waverespawndelay",getmatchrulesdata("commonOption","waveRespawnDelay"));
	setdynamicdvar("scr_player_forcerespawn",getmatchrulesdata("commonOption","forceRespawn"));
	level.var_B409 = getmatchrulesdata("commonOption","allowCustomClasses");
	level.supportintel = getmatchrulesdata("commonOption","allowIntel");
	setdynamicdvar("scr_" + level.gametype + "_allowKillstreaks",getmatchrulesdata("commonOption","allowKillstreaks"));
	setdynamicdvar("scr_" + level.gametype + "_allowPerks",getmatchrulesdata("commonOption","allowPerks"));
	setdynamicdvar("scr_" + level.gametype + "_allowSupers",getmatchrulesdata("commonOption","allowSupers"));
	setdynamicdvar("scr_" + level.gametype + "_ffPunishLimit",getmatchrulesdata("commonOption","ffPunishLimit"));
	setdynamicdvar("scr_" + level.gametype + "_doubleJump",getmatchrulesdata("commonOption","doubleJumpEnabled"));
	setdynamicdvar("scr_" + level.gametype + "_wallRun",getmatchrulesdata("commonOption","wallRunEnabled"));
	setdynamicdvar("scr_game_casualScoreStreaks",getmatchrulesdata("commonOption","casualScoreStreaks"));
	setdynamicdvar("scr_game_superFastChargeRate",getmatchrulesdata("commonOption","superFastChargeRate"));
	setdynamicdvar("scr_game_superPointsMod",getmatchrulesdata("commonOption","superPointsMod"));
	setdynamicdvar("scr_game_spawnProtectionTimer",getmatchrulesdata("commonOption","spawnProtectionTimer"));
	level.crankedbombtimer = getmatchrulesdata("commonOption","crankedBombTimer");
	setdynamicdvar("scr_" + level.gametype + "_crankedBombTimer",level.crankedbombtimer);
	func_DEE9(level.gametype,level.crankedbombtimer);
	setdynamicdvar("scr_game_tacticalmode",getmatchrulesdata("commonOption","tacticalMode"));
	setdynamicdvar("scr_game_cwltuning",getmatchrulesdata("commonOption","bulletBounce"));
	setdynamicdvar("scr_game_onlyheadshots",getmatchrulesdata("commonOption","headshotsOnly"));
	if(!isdefined(param_00))
	{
		setdynamicdvar("scr_team_fftype",getmatchrulesdata("commonOption","friendlyFire"));
	}

	setdvar("bg_compassShowEnemies",getdvar("scr_game_forceuav"));
	setdynamicdvar("scr_" + level.gametype + "_pointsPerKill",getmatchrulesdata("commonOption","pointsPerKill"));
	setdynamicdvar("scr_" + level.gametype + "_pointsPerDeath",getmatchrulesdata("commonOption","pointsPerDeath"));
	setdynamicdvar("scr_" + level.gametype + "_pointsHeadshotBonus",getmatchrulesdata("commonOption","pointsHeadshotBonus"));
	setdynamicdvar("scr_modDefense",0);
	setdynamicdvar("scr_devRemoveDomFlag","");
	setdynamicdvar("scr_devPlaceDomFlag","");
	if(func_D957() || getdvarint("systemlink"))
	{
		setdvar("com_codcasterEnabled",getmatchrulesdata("commonOption","codcasterEnabled"));
	}
}

//Function Number: 365
func_DEE9(param_00,param_01)
{
	registerwatchdvarint("crankedBombTimer",param_01);
}

//Function Number: 366
func_F6A7()
{
}

//Function Number: 367
func_B2AC(param_00)
{
	leaderdialogonplayer(param_00);
	setcrankedplayerbombtimer("kill");
	self.cranked = 1;
	giveperk("specialty_fastreload");
	giveperk("specialty_quickdraw");
	giveperk("specialty_fastoffhand");
	giveperk("specialty_fastsprintrecovery");
	giveperk("specialty_marathon");
	giveperk("specialty_quickswap");
	giveperk("specialty_stalker");
	giveperk("specialty_sprintfire");
	self.movespeedscaler = 1.2;
	scripts\mp\weapons::updatemovespeedscale();
}

//Function Number: 368
oncranked(param_00,param_01,param_02)
{
	if(isdefined(param_00))
	{
		param_00 cleanupcrankedplayertimer();
	}

	self setclientomnvar("ui_cranked_bomb_timer_final_seconds",0);
	if(isdefined(param_01.cranked))
	{
		var_03 = "kill_cranked";
		param_01 thread func_C4DD(var_03);
	}
	else if(isreallyalive(param_01))
	{
		param_01 func_B2AC("begin_cranked");
		param_01 thread scripts\mp\rank::scoreeventpopup("begin_cranked");
	}

	param_01 playsoundtoplayer("mp_bodycount_tick_positive",param_01);
	if(isdefined(param_00) && isdefined(param_00.attackers) && !isdefined(level.assists_disabled))
	{
		foreach(var_05 in param_00.attackers)
		{
			if(!isdefined(_validateattacker(var_05)))
			{
				continue;
			}

			if(var_05 == param_01)
			{
				continue;
			}

			if(param_00 == var_05)
			{
				continue;
			}

			if(!isdefined(var_05.cranked))
			{
				continue;
			}

			var_05 thread func_C4DC("assist_cranked");
			var_05 thread scripts\mp\rank::scoreeventpopup("assist_cranked");
			var_05 playsoundtoplayer("mp_bodycount_tick_positive",var_05);
		}
	}
}

//Function Number: 369
cleanupcrankedplayertimer()
{
	self notify("stop_cranked");
	self setclientomnvar("ui_cranked_bomb_timer_final_seconds",0);
	self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",0);
	self.cranked = undefined;
	self.cranked_end_time = undefined;
}

//Function Number: 370
func_C4DD(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	while(!isdefined(self.pers))
	{
		wait(0.05);
	}

	setcrankedplayerbombtimer("kill");
}

//Function Number: 371
func_C4DC(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	setcrankedplayerbombtimer("assist");
}

//Function Number: 372
setcrankedplayerbombtimer(param_00)
{
	var_01 = level.crankedbombtimer;
	var_02 = 0;
	if(level.gametype == "conf" || level.gametype == "grind")
	{
		var_02 = 1;
	}

	if(isdefined(var_02) && var_02)
	{
		if(isdefined(self.cranked) && self.cranked && isdefined(self.cranked_end_time))
		{
			var_01 = int(min(self.cranked_end_time - gettime() / 1000 + level.crankedbombtimer * 0.5,level.crankedbombtimer));
		}
		else
		{
			var_01 = int(var_01 * 0.5);
		}
	}

	if(param_00 == "assist" && !var_02)
	{
		var_01 = int(min(self.cranked_end_time - gettime() / 1000 + level.crankedbombtimer * 0.5,level.crankedbombtimer));
	}

	var_03 = var_01 * 1000 + gettime();
	self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",var_03);
	self.cranked_end_time = var_03;
	thread func_139E3();
	thread func_139E0(var_01);
	thread func_139E1();
}

//Function Number: 373
func_139E3()
{
	self notify("watchCrankedHostMigration");
	self endon("watchCrankedHostMigration");
	level endon("game_ended");
	self endon("death");
	self endon("disconnect");
	self endon("stop_cranked");
	level waittill("host_migration_begin");
	var_00 = scripts\mp\hostmigration::waittillhostmigrationdone();
	if(self.cranked_end_time + var_00 < 5)
	{
		self setclientomnvar("ui_cranked_bomb_timer_final_seconds",1);
	}

	if(var_00 > 0)
	{
		self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",self.cranked_end_time + var_00);
		return;
	}

	self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",self.cranked_end_time);
}

//Function Number: 374
func_139E1()
{
	self notify("watchEndGame");
	self endon("watchEndGame");
	self endon("death");
	self endon("disconnect");
	self endon("stop_cranked");
	for(;;)
	{
		if(game["state"] == "postgame" || level.gameended)
		{
			self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",0);
			break;
		}

		wait(0.1);
	}
}

//Function Number: 375
func_139E0(param_00)
{
	self notify("watchBombTimer");
	self endon("watchBombTimer");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self endon("stop_cranked");
	var_01 = 5;
	scripts\mp\hostmigration::waitlongdurationwithgameendtimeupdate(param_00 - var_01 - 1);
	scripts\mp\hostmigration::waitlongdurationwithgameendtimeupdate(1);
	self setclientomnvar("ui_cranked_bomb_timer_final_seconds",1);
	while(var_01 > 0)
	{
		self playsoundtoplayer("mp_cranked_countdown",self);
		scripts\mp\hostmigration::waitlongdurationwithgameendtimeupdate(1);
		var_01--;
	}

	if(isdefined(self) && isreallyalive(self) && level.gametype != "tdef")
	{
		self playsound("frag_grenade_explode");
		playfx(level.mine_explode,self.origin + (0,0,32));
		_suicide();
		self setclientomnvar("ui_cranked_bomb_timer_end_milliseconds",0);
	}
}

//Function Number: 376
reinitializematchrulesonmigration()
{
	for(;;)
	{
		level waittill("host_migration_begin");
		[[ level.initializematchrules ]]();
	}
}

//Function Number: 377
reinitializethermal(param_00)
{
	self endon("disconnect");
	if(isdefined(param_00))
	{
		param_00 endon("death");
	}

	for(;;)
	{
		level waittill("host_migration_begin");
		if(isdefined(self.lastvisionsetthermal))
		{
			self visionsetthermalforplayer(self.lastvisionsetthermal,0);
		}
	}
}

//Function Number: 378
getmatchrulesspecialclass(param_00,param_01)
{
	var_02 = [];
	var_02["loadoutPrimaryAttachment2"] = "none";
	var_02["loadoutSecondaryAttachment2"] = "none";
	var_03 = [];
	var_02["loadoutPrimary"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",0,"weapon");
	var_02["loadoutPrimaryAttachment"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",0,"attachment",0);
	var_02["loadoutPrimaryAttachment2"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",0,"attachment",1);
	var_02["loadoutPrimaryCamo"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",0,"camo");
	var_02["loadoutPrimaryReticle"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",0,"reticle");
	var_02["loadoutSecondary"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",1,"weapon");
	var_02["loadoutSecondaryAttachment"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",1,"attachment",0);
	var_02["loadoutSecondaryAttachment2"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",1,"attachment",1);
	var_02["loadoutSecondaryCamo"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",1,"camo");
	var_02["loadoutSecondaryReticle"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","weaponSetups",1,"reticle");
	var_02["loadoutPerks"] = var_03;
	var_02["loadoutKillstreak1"] = scripts\mp\class::recipe_getkillstreak(param_00,param_01,0);
	var_02["loadoutKillstreak2"] = scripts\mp\class::recipe_getkillstreak(param_00,param_01,1);
	var_02["loadoutKillstreak3"] = scripts\mp\class::recipe_getkillstreak(param_00,param_01,2);
	var_02["loadoutJuggernaut"] = getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"juggernaut");
	return var_02;
}

//Function Number: 379
func_DDD9(param_00)
{
	level endon("game_ended");
	self endon("disconnect");
	if(level.ingraceperiod && !self.hasdonecombat)
	{
		self waittill("giveLoadout");
	}
	else
	{
		self waittill("spawned_player");
	}

	if(param_00)
	{
		self notify("lost_juggernaut");
		wait(0.5);
	}

	if(!isdefined(self.isjuiced))
	{
		self.movespeedscaler = 0.7;
		scripts\mp\weapons::updatemovespeedscale();
	}

	self.var_A4AA = 0.7;
	self disableweaponpickup();
	if(!getdvarint("camera_thirdPerson"))
	{
		self setclientomnvar("ui_juggernaut",1);
	}

	thread scripts\mp\killstreaks\_juggernaut::func_A4A9();
	if(level.gametype != "jugg" || isdefined(level.matchrules_switchteamdisabled) && level.matchrules_switchteamdisabled)
	{
		self setperk("specialty_radarjuggernaut",1);
	}

	if(isdefined(self.var_9E61) && self.var_9E61)
	{
		self makeportableradar(self);
	}

	level notify("juggernaut_equipped",self);
	thread scripts\mp\killstreaks\_juggernaut::func_A4AC();
}

//Function Number: 380
updatesessionstate(param_00,param_01)
{
	switch(param_00)
	{
		case "intermission":
		case "playing":
			param_01 = "";
			break;

		case "dead":
		case "spectator":
			if(istrue(level.doingbroshot))
			{
				param_01 = "";
			}
			else if(istrue(level.numlifelimited))
			{
				if(istrue(self.tagavailable))
				{
					param_01 = "hud_status_dogtag";
				}
				else
				{
					param_01 = "hud_status_dead";
				}
			}
			else
			{
				param_01 = "hud_status_dead";
			}
			break;
	}

	if(!isdefined(param_01))
	{
		param_01 = "";
	}

	self.sessionstate = param_00;
	self.getgrenadefusetime = param_01;
	self setclientomnvar("ui_session_state",param_00);
}

//Function Number: 381
getclassindex(param_00)
{
	return level.classmap[param_00];
}

//Function Number: 382
isteaminlaststand()
{
	var_00 = getlivingplayers(self.team);
	foreach(var_02 in var_00)
	{
		if(var_02 != self && !isdefined(var_02.setlasermaterial) || !var_02.setlasermaterial)
		{
			return 0;
		}
	}

	return 1;
}

//Function Number: 383
func_A6C7(param_00)
{
	var_01 = getlivingplayers(param_00);
	foreach(var_03 in var_01)
	{
		if(isdefined(var_03.setlasermaterial) && var_03.setlasermaterial)
		{
			var_03 thread scripts\mp\damage::func_54C8(randomintrange(1,3));
		}
	}
}

//Function Number: 384
func_1136C(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	if(!isai(self))
	{
		if(isdefined(param_00) && issuperweapon(param_00))
		{
			param_00 = undefined;
		}

		if(!isdefined(param_00))
		{
			param_00 = scripts\engine\utility::getlastweapon();
			if(!self hasweapon(param_00))
			{
				param_00 = scripts\mp\killstreaks\_utility::getfirstprimaryweapon();
			}

			func_1136C(param_00,param_01);
		}

		if(param_01)
		{
			_switchtoweaponimmediate(param_00);
			return;
		}

		_switchtoweapon(param_00);
		return;
	}

	_switchtoweapon("none");
}

//Function Number: 385
isaiteamparticipant(param_00)
{
	if(isagent(param_00) && param_00.agent_teamparticipant == 1)
	{
		return 1;
	}

	if(isbot(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 386
isteamparticipant(param_00)
{
	if(isaiteamparticipant(param_00))
	{
		return 1;
	}

	if(isplayer(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 387
isaigameparticipant(param_00)
{
	if(isagent(param_00) && isdefined(param_00.agent_gameparticipant) && param_00.agent_gameparticipant == 1)
	{
		return 1;
	}

	if(isbot(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 388
isgameparticipant(param_00)
{
	if(isaigameparticipant(param_00))
	{
		return 1;
	}

	if(isplayer(param_00))
	{
		return 1;
	}

	return 0;
}

//Function Number: 389
isoffhandweaponreadytothrow(param_00)
{
	var_01 = 0;
	if(level.teambased)
	{
		switch(param_00)
		{
			case "axis":
				var_01 = 1;
				break;

			case "allies":
				var_01 = 2;
				break;
		}
	}

	return var_01;
}

//Function Number: 390
getteamarray(param_00,param_01)
{
	var_02 = [];
	if(!isdefined(param_01) || param_01)
	{
		foreach(var_04 in level.characters)
		{
			if(isdefined(var_04.team) && var_04.team == param_00)
			{
				var_02[var_02.size] = var_04;
			}
		}
	}
	else
	{
		foreach(var_04 in level.players)
		{
			if(isdefined(var_04.team) && var_04.team == param_00)
			{
				var_02[var_02.size] = var_04;
			}
		}
	}

	return var_02;
}

//Function Number: 391
isheadshot(param_00,param_01,param_02,param_03)
{
	if(isdefined(param_03))
	{
		if(isdefined(param_03.triggerportableradarping))
		{
			if(param_03.var_9F == "script_vehicle")
			{
				return 0;
			}

			if(param_03.var_9F == "misc_turret")
			{
				return 0;
			}

			if(param_03.var_9F == "script_model")
			{
				return 0;
			}
		}

		if(isdefined(param_03.agent_type))
		{
			if(param_03.agent_type == "dog" || param_03.agent_type == "alien")
			{
				return 0;
			}
		}
	}

	if(param_02 == "MOD_EXPLOSIVE")
	{
		return 0;
	}

	return (param_01 == "head" || param_01 == "helmet") && param_02 != "MOD_MELEE" && param_02 != "MOD_IMPACT" && param_02 != "MOD_SCARAB" && param_02 != "MOD_CRUSH" && !isenvironmentweapon(param_00);
}

//Function Number: 392
func_9E7D(param_00,param_01,param_02,param_03)
{
	if(param_03 != "MOD_MELEE")
	{
		return 0;
	}

	if(!isdefined(param_01) || !isplayer(param_01))
	{
		return 0;
	}

	if(param_01 scripts\mp\heavyarmor::hasheavyarmor())
	{
		return 0;
	}

	if(param_00 _hasperk("passive_meleekill") || param_00 _hasperk("passive_meleekill_silent"))
	{
		return 1;
	}

	if(scripts\mp\weapons::isknifeonly(param_02))
	{
		return 1;
	}

	if(scripts\mp\weapons::isballweapon(param_02))
	{
		return 1;
	}

	if(scripts\mp\weapons::isaxeweapon(param_02) && param_00 getweaponammoclip(param_02) > 0)
	{
		return 1;
	}

	if(param_00 _meth_8519(param_02) && getweaponrootname(param_02) == "iw7_rvn")
	{
		return 1;
	}

	if(issubstr(param_02,"iw7_katana_mp") || issubstr(param_02,"iw7_nunchucks_mp"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 393
attackerishittingteam(param_00,param_01)
{
	if(isdefined(param_01) && isdefined(param_01.triggerportableradarping))
	{
		param_01 = param_01.triggerportableradarping;
	}

	if(!level.teambased)
	{
		return 0;
	}

	if(!isdefined(param_01) || !isdefined(param_00))
	{
		return 0;
	}

	if(!isdefined(param_00.team) || !isdefined(param_01.team))
	{
		return 0;
	}

	if(param_00 == param_01)
	{
		return 0;
	}

	if(level.gametype == "infect" && param_00.pers["team"] == param_01.team && isdefined(param_01.teamchangedthisframe))
	{
		return 0;
	}

	if(level.gametype == "infect" && param_00.pers["team"] != param_01.team && isdefined(param_01.teamchangedthisframe))
	{
		return 1;
	}

	if(isdefined(param_01.scrambled) && param_01.scrambled)
	{
		return 0;
	}

	if(func_9EF6(param_00,param_01))
	{
		return 0;
	}

	if(isagent(param_00) && isdefined(param_00.triggerportableradarping) && param_00.triggerportableradarping == param_01)
	{
		return 0;
	}

	if(param_00.team == param_01.team)
	{
		return 1;
	}

	return 0;
}

//Function Number: 394
func_F401(param_00)
{
	if(!isdefined(self.high_priority_for) && scripts\engine\utility::array_contains(self.high_priority_for,param_00))
	{
		self.high_priority_for = scripts\engine\utility::array_add(self.high_priority_for,param_00);
		param_00 notify("calculate_new_level_targets");
	}
}

//Function Number: 395
func_1758(param_00,param_01)
{
	if(isdefined(level.bot_funcs["bots_add_to_level_targets"]))
	{
		param_00.use_time = param_01;
		param_00.bot_interaction_type = "use";
		[[ level.bot_funcs["bots_add_to_level_targets"] ]](param_00);
	}
}

//Function Number: 396
func_E016(param_00)
{
	if(isdefined(level.bot_funcs["bots_remove_from_level_targets"]))
	{
		[[ level.bot_funcs["bots_remove_from_level_targets"] ]](param_00);
	}
}

//Function Number: 397
func_1757(param_00)
{
	if(isdefined(level.bot_funcs["bots_add_to_level_targets"]))
	{
		param_00.bot_interaction_type = "damage";
		[[ level.bot_funcs["bots_add_to_level_targets"] ]](param_00);
	}
}

//Function Number: 398
func_E015(param_00)
{
	if(isdefined(level.bot_funcs["bots_remove_from_level_targets"]))
	{
		[[ level.bot_funcs["bots_remove_from_level_targets"] ]](param_00);
	}
}

//Function Number: 399
notify_enemy_bots_bomb_used(param_00)
{
	if(isdefined(level.bot_funcs["notify_enemy_bots_bomb_used"]))
	{
		self [[ level.bot_funcs["notify_enemy_bots_bomb_used"] ]](param_00);
	}
}

//Function Number: 400
get_rank_xp_for_bot()
{
	if(isdefined(level.bot_funcs["bot_get_rank_xp"]))
	{
		return self [[ level.bot_funcs["bot_get_rank_xp"] ]]();
	}
}

//Function Number: 401
bot_israndom()
{
	return self getownerteam();
}

//Function Number: 402
isassaultkillstreak(param_00)
{
	switch(param_00)
	{
		case "uplink":
		case "vanguard":
		case "odin_assault":
		case "heli_pilot":
		case "airdrop_juggernaut_maniac":
		case "airdrop_assault":
		case "airdrop_juggernaut":
		case "airdrop_sentry_minigun":
		case "helicopter":
		case "guard_dog":
		case "ball_drone_backup":
		case "directional_uav":
		case "uav":
		case "ims":
		case "minijackal":
		case "drone_hive":
		case "sentry":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 403
func_9F25(param_00)
{
	switch(param_00)
	{
		case "uav_3dping":
		case "aa_launcher":
		case "uplink_support":
		case "ball_drone_radar":
		case "sam_turret":
		case "uplink":
		case "orbital_deployment":
		case "odin_support":
		case "heli_sniper":
		case "airdrop_juggernaut_recon":
		case "recon_agent":
		case "ball_drone_backup":
		case "jammer":
		case "deployable_ammo":
		case "deployable_vest":
		case "air_superiority":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 404
issupportkillstreak(param_00)
{
	switch(param_00)
	{
		case "deployable_adrenaline_mist":
		case "deployable_speed_strip":
		case "uav_3dping":
		case "aa_launcher":
		case "uplink_support":
		case "ball_drone_radar":
		case "sam_turret":
		case "odin_support":
		case "heli_sniper":
		case "airdrop_juggernaut_recon":
		case "recon_agent":
		case "jammer":
		case "deployable_ammo":
		case "deployable_vest":
		case "sentry_shock":
		case "air_superiority":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 405
isspecialistkillstreak(param_00)
{
	switch(param_00)
	{
		case "specialty_chain_reaction_ks":
		case "specialty_deadeye_ks":
		case "specialty_boom_ks":
		case "specialty_twoprimaries_ks":
		case "specialty_hardline_ks":
		case "specialty_gambler_ks":
		case "specialty_explosivedamage_ks":
		case "specialty_extra_attachment_ks":
		case "specialty_extra_deadly_ks":
		case "specialty_extra_equipment_ks":
		case "specialty_extraammo_ks":
		case "specialty_gunsmith_ks":
		case "specialty_blastshield_ks":
		case "specialty_stun_resistance_ks":
		case "specialty_sharp_focus_ks":
		case "specialty_regenfaster_ks":
		case "specialty_falldamage_ks":
		case "specialty_comexp_ks":
		case "specialty_selectivehearing_ks":
		case "specialty_detectexplosive_ks":
		case "specialty_scavenger_ks":
		case "specialty_paint_ks":
		case "specialty_incog_ks":
		case "specialty_quieter_ks":
		case "specialty_gpsjammer_ks":
		case "specialty_blindeye_ks":
		case "specialty_silentkill_ks":
		case "specialty_sprintreload_ks":
		case "specialty_quickdraw_ks":
		case "specialty_bulletaccuracy_ks":
		case "specialty_pitcher_ks":
		case "specialty_quickswap_ks":
		case "specialty_reducedsway_ks":
		case "specialty_stalker_ks":
		case "specialty_marathon_ks":
		case "specialty_lightweight_ks":
		case "specialty_fastreload_ks":
		case "specialty_fastsprintrecovery_ks":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 406
bot_is_fireteam_mode()
{
	var_00 = function_001F() == 2;
	if(var_00)
	{
		if(!level.teambased || level.gametype != "war" && level.gametype != "dom")
		{
			return 0;
		}

		return 1;
	}

	return 0;
}

//Function Number: 407
func_F305()
{
	if(!scripts\engine\utility::add_init_script("platform",::func_F305))
	{
		return;
	}

	if(!isdefined(level.console))
	{
		level.console = getdvar("consoleGame") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_13E0F))
	{
		level.var_13E0F = getdvar("xenonGame") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_DADB))
	{
		level.var_DADB = getdvar("ps3Game") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_13E0E))
	{
		level.var_13E0E = getdvar("xb3Game") == "true";
	}
	else
	{
	}

	if(!isdefined(level.var_DADC))
	{
		level.var_DADC = getdvar("ps4Game") == "true";
	}
}

//Function Number: 408
func_9BEE()
{
	if(level.var_13E0E || level.var_DADC || !level.console)
	{
		return 1;
	}

	return 0;
}

//Function Number: 409
func_F6DB(param_00,param_01,param_02)
{
	if(!isdefined(level.console) || !isdefined(level.var_13E0E) || !isdefined(level.var_DADC))
	{
		func_F305();
	}

	if(func_9BEE())
	{
		setdvar(param_00,param_02);
		return;
	}

	setdvar(param_00,param_01);
}

//Function Number: 410
func_9FE7(param_00,param_01,param_02)
{
	return isdefined(param_02.team) && param_02.team == param_01;
}

//Function Number: 411
func_9FD8(param_00,param_01,param_02)
{
	return isdefined(param_02.triggerportableradarping) && !isdefined(param_00) || param_02.triggerportableradarping != param_00;
}

//Function Number: 412
gethelipilotmeshoffset()
{
	return (0,0,5000);
}

//Function Number: 413
gethelipilottraceoffset()
{
	return (0,0,2500);
}

//Function Number: 414
func_7F78()
{
	var_00 = [];
	if(isdefined(self.script_linkto))
	{
		var_01 = strtok(self.script_linkto," ");
		for(var_02 = 0;var_02 < var_01.size;var_02++)
		{
			var_03 = function_00B3(var_01[var_02],"script_linkname");
			if(isdefined(var_03))
			{
				var_00[var_00.size] = var_03;
			}
		}
	}

	return var_00;
}

//Function Number: 415
get_players_watching(param_00,param_01)
{
	if(!isdefined(param_00))
	{
		param_00 = 0;
	}

	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	var_02 = self getentitynumber();
	var_03 = [];
	foreach(var_05 in level.players)
	{
		if(var_05 == self)
		{
			continue;
		}

		var_06 = 0;
		if(!param_01)
		{
			if(isdefined(var_05.team) && var_05.team == "spectator" || var_05.sessionstate == "spectator")
			{
				var_07 = var_05 getspectatingplayer();
				if(isdefined(var_07) && var_07 == self)
				{
					var_06 = 1;
				}
			}

			if(var_05.missile_createrepulsorent == var_02)
			{
				var_06 = 1;
			}
		}

		if(!param_00)
		{
			if(var_05.setclientmatchdatadef == var_02)
			{
				var_06 = 1;
			}
		}

		if(var_06)
		{
			var_03[var_03.size] = var_05;
		}
	}

	return var_03;
}

//Function Number: 416
set_visionset_for_watching_players(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = get_players_watching(param_04,param_05);
	foreach(var_08 in var_06)
	{
		var_08 notify("changing_watching_visionset");
		if(isdefined(param_03) && param_03)
		{
			var_08 visionsetmissilecamforplayer(param_00,param_01);
		}
		else
		{
			var_08 visionsetnakedforplayer(param_00,param_01);
		}

		if(param_00 != "" && isdefined(param_02))
		{
			var_08 thread reset_visionset_on_team_change(self,param_01 + param_02);
			var_08 thread reset_visionset_on_disconnect(self);
			if(var_08 isinkillcam())
			{
				var_08 thread reset_visionset_on_spawn();
			}
		}
	}
}

//Function Number: 417
reset_visionset_on_spawn()
{
	self endon("disconnect");
	self waittill("spawned");
	self visionsetnakedforplayer("",0);
}

//Function Number: 418
reset_visionset_on_team_change(param_00,param_01)
{
	self endon("changing_watching_visionset");
	var_02 = gettime();
	var_03 = self.team;
	while(gettime() - var_02 < param_01 * 1000)
	{
		if(self.team != var_03 || !scripts\engine\utility::array_contains(param_00 get_players_watching(),self))
		{
			self visionsetnakedforplayer("",0);
			self notify("changing_visionset");
			break;
		}

		wait(0.05);
	}
}

//Function Number: 419
reset_visionset_on_disconnect(param_00)
{
	self endon("changing_watching_visionset");
	param_00 waittill("disconnect");
	self visionsetnakedforplayer("",0);
}

//Function Number: 420
_validateattacker(param_00)
{
	if(isagent(param_00) && !isdefined(param_00.isactive) || !param_00.isactive)
	{
		return undefined;
	}

	if(isagent(param_00) && !isdefined(param_00.classname))
	{
		return undefined;
	}

	return param_00;
}

//Function Number: 421
func_143B(param_00)
{
	if(!isreallyalive(param_00))
	{
		return undefined;
	}

	return param_00;
}

//Function Number: 422
_magicbullet(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = magicbullet(param_00,param_01,param_02,param_03,param_04);
	if(isdefined(var_05) && isdefined(param_03))
	{
		var_05 setotherent(param_03);
	}

	return var_05;
}

//Function Number: 423
_launchgrenade(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = self launchgrenade(param_00,param_01,param_02,param_03,param_05);
	if(!isdefined(param_04))
	{
		var_06.notthrown = 1;
	}
	else
	{
		var_06.notthrown = param_04;
	}

	var_06 setotherent(self);
	return var_06;
}

//Function Number: 424
func_1377B()
{
	for(;;)
	{
		self waittill("grenade_fire",var_00,var_01,var_02,var_03);
		if(!func_85E0(var_00))
		{
			continue;
		}

		_meth_85C6(var_00,var_01,var_02,var_03);
		self notify("grenade_throw");
		return var_00;
	}
}

//Function Number: 425
func_85E0(param_00)
{
	return !isdefined(param_00.notthrown) || !param_00.notthrown;
}

//Function Number: 426
_meth_85C7()
{
	return self _meth_854D() != "none";
}

//Function Number: 427
func_7EE5()
{
	var_00 = self _meth_854D();
	if(isdefined(self.gestureweapon) && var_00 == self.gestureweapon)
	{
		var_00 = "none";
	}

	return var_00;
}

//Function Number: 428
_meth_85C6(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_00.weapon_name))
	{
		param_00.weapon_name = param_01;
	}

	if(!isdefined(param_00.triggerportableradarping))
	{
		param_00.triggerportableradarping = self;
	}

	if(!isdefined(param_00.team))
	{
		param_00.team = self.team;
	}

	if(!isdefined(param_00.tickpercent))
	{
		param_00.tickpercent = param_02;
	}

	if(!isdefined(param_00.ticks) && isdefined(param_00.tickpercent))
	{
		param_00.ticks = roundup(4 * param_02);
	}

	var_04 = scripts\mp\powers::func_D737(param_01);
	if(isdefined(var_04))
	{
		param_00.power = var_04;
		param_00.var_9F07 = 1;
	}

	param_00.threwback = isdefined(param_03);
}

//Function Number: 429
waittill_missile_fire()
{
	self waittill("missile_fire",var_00,var_01);
	if(isdefined(var_00))
	{
		if(!isdefined(var_00.weapon_name))
		{
			var_00.weapon_name = getweaponbasedsmokegrenadecount(var_01);
		}

		if(!isdefined(var_00.triggerportableradarping))
		{
			var_00.triggerportableradarping = self;
		}

		if(!isdefined(var_00.team))
		{
			var_00.team = self.team;
		}
	}

	return var_00;
}

//Function Number: 430
_setnameplatematerial(param_00,param_01)
{
	if(!isdefined(self.var_BE4C))
	{
		self.var_BE4C = [];
		self.var_D8B9 = [];
	}
	else
	{
		self.var_D8B9[0] = self.var_BE4C[0];
		self.var_D8B9[1] = self.var_BE4C[1];
	}

	self.var_BE4C[0] = param_00;
	self.var_BE4C[1] = param_01;
	self _meth_8315(param_00,param_01);
}

//Function Number: 431
func_13B6()
{
	if(isdefined(self.var_D8B9))
	{
		self _meth_8315(self.var_D8B9[0],self.var_D8B9[1]);
	}
	else
	{
		self _meth_8315("","");
	}

	self.var_BE4C = undefined;
	self.var_D8B9 = undefined;
}

//Function Number: 432
isplayeroutsideofanybombsite(param_00)
{
	if(isdefined(level.bombzones))
	{
		foreach(var_02 in level.bombzones)
		{
			if(self istouching(var_02.noweapondropallowedtrigger))
			{
				return 0;
			}
		}
	}

	return 1;
}

//Function Number: 433
func_13C9A(param_00,param_01)
{
	if(issuperweapon(param_00))
	{
		return 1;
	}

	param_00 = getweaponbasedsmokegrenadecount(param_00);
	if(param_00 == "heli_pilot_turret_mp" || param_00 == "bomb_site_mp" || param_00 == "sentry_shock_mp" || param_00 == "portal_grenade_mp" || param_00 == "blackout_grenade_mp" || param_00 == "concussion_grenade_mp" || param_00 == "cryo_mine_mp" || param_00 == "fear_grenade_mp" || param_00 == "chargemode_mp" || param_00 == "emp_grenade_mp" || param_00 == "minijackal_strike_mp" || param_00 == "bombproj_mp" || param_00 == "iw7_blackholegun_mp" || param_00 == "iw7_cheytac_mpr_projectile" || param_00 == "artillery_mp" || param_00 == "groundpound_mp" || param_00 == "drone_hive_projectile_mp" || param_00 == "swtich_blade_child_mp" || param_00 == "thorproj_mp" || param_00 == "thorproj_zoomed_mp" || param_00 == "thorproj_tracking_mp")
	{
		return 1;
	}

	if(param_00 == "iw7_revolver_mpr_explosive" && isdefined(param_01) && param_01 != "none")
	{
		return 1;
	}

	return 0;
}

//Function Number: 434
func_9F7E(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_01))
	{
		return 0;
	}

	if(!isdefined(param_01.stuckenemyentity))
	{
		return 0;
	}

	if(param_01.stuckenemyentity != param_00)
	{
		return 0;
	}

	return 1;
}

//Function Number: 435
func_9F7F(param_00,param_01,param_02,param_03)
{
	if(!func_9F7E(param_00,param_01,param_02,param_03))
	{
		return 0;
	}

	return 1;
}

//Function Number: 436
restorebasevisionset(param_00)
{
	self visionsetnakedforplayer("",param_00);
}

//Function Number: 437
playplayerandnpcsounds(param_00,param_01,param_02)
{
	param_00 playlocalsound(param_01);
	param_00 playsoundtoteam(param_02,"allies",param_00);
	param_00 playsoundtoteam(param_02,"axis",param_00);
}

//Function Number: 438
isenemy(param_00)
{
	if(level.teambased)
	{
		return isplayeronenemyteam(param_00);
	}

	return isplayerffaenemy(param_00);
}

//Function Number: 439
isplayeronenemyteam(param_00)
{
	return param_00.team != self.team;
}

//Function Number: 440
isplayerffaenemy(param_00)
{
	if(isdefined(param_00.triggerportableradarping))
	{
		return param_00.triggerportableradarping != self;
	}

	return param_00 != self;
}

//Function Number: 441
setextrascore0(param_00)
{
	self.istransientqueued = param_00;
	setpersstat("extrascore0",param_00);
}

//Function Number: 442
setextrascore1(param_00)
{
	self.isturretactive = param_00;
	setpersstat("extrascore1",param_00);
}

//Function Number: 443
func_1C9B()
{
	if(level.gametype == "infect")
	{
		return 0;
	}

	return 1;
}

//Function Number: 444
getuniqueid()
{
	if(isdefined(self.pers["guid"]))
	{
		return self.pers["guid"];
	}

	var_00 = self getguid();
	if(var_00 == "0000000000000000")
	{
		if(isdefined(level.guidgen))
		{
			level.var_86BF++;
		}
		else
		{
			level.guidgen = 1;
		}

		var_00 = "script" + level.guidgen;
	}

	self.pers["guid"] = var_00;
	return self.pers["guid"];
}

//Function Number: 445
_meth_80BF()
{
	var_00 = scripts\engine\utility::array_removeundefined(level.players);
	for(;;)
	{
		if(!var_00.size)
		{
			return;
		}

		var_01 = randomintrange(0,var_00.size);
		var_02 = var_00[var_01];
		if(!isreallyalive(var_02) || var_02.sessionstate != "playing")
		{
			var_00 = scripts\engine\utility::array_remove(var_00,var_02);
			continue;
		}

		return var_02;
	}
}

//Function Number: 446
getmapname()
{
	if(!isdefined(level.mapname))
	{
		level.mapname = getdvar("mapname");
	}

	return level.mapname;
}

//Function Number: 447
issinglehitweapon(param_00)
{
	param_00 = getweaponbasedsmokegrenadecount(param_00);
	switch(param_00)
	{
		case "iw7_chargeshot_mp":
		case "iw7_lockon_mp":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 448
gamehasneutralcrateowner(param_00)
{
	switch(param_00)
	{
		case "sotf_ffa":
		case "sotf":
			return 1;

		default:
			return 0;
	}
}

//Function Number: 449
func_22B1(param_00,param_01)
{
	var_02 = [];
	foreach(var_05, var_04 in param_00)
	{
		if(var_04 != param_01)
		{
			var_02[var_05] = var_04;
		}
	}

	return var_02;
}

//Function Number: 450
array_remove_index(param_00,param_01)
{
	var_02 = [];
	for(var_03 = 0;var_03 < param_00.size;var_03++)
	{
		if(var_03 == param_01)
		{
			continue;
		}

		var_02[var_02.size] = param_00[var_03];
	}

	return var_02;
}

//Function Number: 451
isanymlgmatch()
{
	if(getdvarint("xblive_competitionmatch") || getdvarint("scr_game_cwltuning"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 452
ismlgsystemlink()
{
	if(getdvarint("systemlink") && getdvarint("xblive_competitionmatch") || getdvarint("scr_game_cwltuning"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 453
ismlgprivatematch()
{
	if(func_D957() && getdvarint("xblive_competitionmatch") || getdvarint("scr_game_cwltuning"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 454
ismlgmatch()
{
	if(ismlgsystemlink() || ismlgprivatematch())
	{
		return 1;
	}

	return 0;
}

//Function Number: 455
setmlgannouncement(param_00,param_01,param_02,param_03)
{
	if(param_01 == "axis")
	{
		param_00 = param_00 + 2000;
	}
	else if(param_01 == "allies")
	{
		param_00 = param_00 + 1000;
	}

	if(isdefined(param_02))
	{
		param_00 = param_00 + param_02 + 1 * 10000;
	}

	if(isdefined(param_03))
	{
		if(function_027D(param_03))
		{
			param_00 = param_00 + param_03 + 1 * 1000000;
		}
		else
		{
			scripts\engine\utility::error("mlg announcement extra data supports numbers only. Invalid extra data: " + param_03);
		}
	}

	setomnvar("ui_mlg_announcement",param_00);
}

//Function Number: 456
ismoddedroundgame()
{
	if(level.gametype == "ball" || level.gametype == "dom" || level.gametype == "front" || level.gametype == "ctf")
	{
		return 1;
	}

	return 0;
}

//Function Number: 457
isusingdefaultclass(param_00,param_01)
{
	var_02 = 0;
	if(isdefined(param_01))
	{
		if(function_011C() && getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","inUse"))
		{
			var_02 = 1;
		}
	}
	else
	{
		for(param_01 = 0;param_01 < 6;param_01++)
		{
			if(function_011C() && getmatchrulesdatawithteamandindex("defaultClasses",param_00,param_01,"class","inUse"))
			{
				var_02 = 1;
				break;
			}
		}
	}

	return var_02;
}

//Function Number: 458
func_3899(param_00)
{
	var_01 = 1;
	if(isdefined(self.isjuggernautlevelcustom) && self.isjuggernautlevelcustom && isdefined(self.var_3938) && !self [[ self.var_3938 ]](param_00))
	{
		var_01 = 0;
	}

	return var_01;
}

//Function Number: 459
func_D911()
{
	if(isdefined(self.var_A699))
	{
		[[ self.var_A699 ]]();
	}
}

//Function Number: 460
func_F5C6(param_00,param_01,param_02,param_03)
{
	var_04 = self energy_getrestorerate(param_00);
	self.var_116D0 = 1;
	self goalflag(param_00,param_01);
	if(!isdefined(param_03) || !param_03)
	{
		wait(param_02);
	}
	else
	{
		var_05 = self energy_getmax(param_00);
		for(;;)
		{
			if(self goal_position(param_00) >= var_05)
			{
				break;
			}

			wait(0.05);
		}
	}

	self goalflag(param_00,var_04);
	self.var_116D0 = 0;
}

//Function Number: 461
func_F5C5(param_00,param_01,param_02,param_03)
{
	var_04 = self energy_getresttimems(param_00);
	self.var_116D1 = 1;
	self goal_type(param_00,param_01);
	if(!isdefined(param_03) || !param_03)
	{
		wait(param_02);
	}
	else
	{
		var_05 = self energy_getmax(param_00);
		for(;;)
		{
			if(self goal_position(param_00) >= var_05)
			{
				break;
			}

			wait(0.05);
		}
	}

	self goal_type(param_00,var_04);
	self.var_116D1 = 0;
}

//Function Number: 462
func_13AF(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	if(!isdefined(param_07))
	{
		param_07 = 0;
	}

	self radiusdamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06);
}

//Function Number: 463
delayentdelete(param_00)
{
	self endon("death");
	wait(param_00);
	if(isdefined(self))
	{
		self delete();
	}
}

//Function Number: 464
hashealthshield(param_00)
{
	return isdefined(param_00) && isdefined(param_00.var_8CC8);
}

//Function Number: 465
func_7EF7(param_00)
{
	return int(param_00 * self.var_8CC9);
}

//Function Number: 466
func_F741(param_00)
{
	self.var_8CC8 = 1;
	if(!isdefined(self.var_8CC9))
	{
		self.var_8CC9 = 1;
	}

	param_00 = int(clamp(param_00,0,100));
	var_01 = 100 - param_00 / 100;
	if(var_01 < self.var_8CC9)
	{
		self.var_8CC9 = var_01;
	}
}

//Function Number: 467
clearhealthshield()
{
	self.var_8CC8 = undefined;
	self.var_8CC9 = undefined;
}

//Function Number: 468
func_108CB(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = spawnfx(scripts\engine\utility::getfx(param_02),param_01);
	triggerfx(var_05);
	foreach(var_07 in level.players)
	{
		var_08 = scripts\mp\damage::isfriendlyfire(param_00,var_07);
		if(var_07 == param_00 && isdefined(param_04))
		{
			var_08 = param_04;
		}

		if(!var_08)
		{
			var_05 hidefromplayer(var_07);
		}
	}

	var_0A = spawnfx(scripts\engine\utility::getfx(param_03),param_01);
	triggerfx(var_0A);
	foreach(var_07 in level.players)
	{
		var_08 = scripts\mp\damage::isfriendlyfire(param_00,var_07);
		if(var_07 == param_00 && isdefined(param_04))
		{
			var_08 = param_04;
		}

		if(var_08)
		{
			var_0A hidefromplayer(var_07);
		}
	}

	var_0D = [];
	var_0D[0] = var_05;
	var_0D[1] = var_0A;
	return var_0D;
}

//Function Number: 469
func_D486(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	foreach(var_09 in level.players)
	{
		if(!isdefined(var_09))
		{
			continue;
		}

		if(isdefined(param_07) && scripts\engine\utility::array_contains(param_07,var_09))
		{
			continue;
		}

		if(isdefined(param_05) && scripts\engine\utility::array_contains(param_05,var_09))
		{
			var_0A = 1;
		}
		else if(isdefined(param_06) && scripts\engine\utility::array_contains(param_06,var_09))
		{
			var_0A = 0;
		}
		else
		{
			var_0A = func_9E05(param_02,var_09);
		}

		if(var_0A)
		{
			playfxontagforclients(param_03,param_00,param_01,var_09);
			continue;
		}

		playfxontagforclients(param_04,param_00,param_01,var_09);
	}
}

//Function Number: 470
func_11071(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	foreach(var_09 in level.players)
	{
		if(!isdefined(var_09))
		{
			continue;
		}

		if(isdefined(param_07) && scripts\engine\utility::array_contains(param_07,var_09))
		{
			continue;
		}

		if(isdefined(param_05) && scripts\engine\utility::array_contains(param_05,var_09))
		{
			var_0A = 1;
		}
		else if(isdefined(param_06) && scripts\engine\utility::array_contains(param_06,var_09))
		{
			var_0A = 0;
		}
		else
		{
			var_0A = func_9E05(param_02,var_09);
		}

		if(var_0A)
		{
			function_0297(param_03,param_00,param_01,var_09);
			continue;
		}

		function_0297(param_04,param_00,param_01,var_09);
	}
}

//Function Number: 471
playteamfxforclient(param_00,param_01,param_02,param_03,param_04,param_05)
{
	var_06 = undefined;
	if(self.team != param_00)
	{
		var_06 = function_01E1(scripts\engine\utility::getfx(param_03),param_01,self);
	}
	else
	{
		var_06 = function_01E1(scripts\engine\utility::getfx(param_02),param_01,self);
	}

	if(isdefined(var_06))
	{
		triggerfx(var_06);
	}

	var_06 thread delayentdelete(param_04);
	if(isdefined(param_05) && param_05)
	{
		var_06 thread deleteonplayerdeathdisconnect(self);
	}

	return var_06;
}

//Function Number: 472
deleteonplayerdeathdisconnect(param_00)
{
	self endon("death");
	param_00 scripts\engine\utility::waittill_any_3("death","disconnect");
	self delete();
}

//Function Number: 473
getmatchrulesdatawithteamandindex(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	if(param_01 == "axis")
	{
		param_02 = param_02 + 6;
	}

	if(isdefined(param_06))
	{
		return getmatchrulesdata(param_00,param_02,param_03,param_04,param_05,param_06);
	}

	if(isdefined(param_05))
	{
		return getmatchrulesdata(param_00,param_02,param_03,param_04,param_05);
	}

	return getmatchrulesdata(param_00,param_02,param_03,param_04);
}

//Function Number: 474
func_7D91(param_00,param_01)
{
	return param_00 * 5 + param_01;
}

//Function Number: 475
clearscrambler(param_00,param_01,param_02,param_03)
{
	var_04 = ["physicscontents_player"];
	return func_7E9B(param_00,param_01,param_02,param_03,physics_createcontents(var_04));
}

//Function Number: 476
getplayersinradiusview(param_00,param_01,param_02,param_03)
{
	var_04 = ["physicscontents_player"];
	var_05 = [];
	var_06 = func_7E9B(param_00,param_01,param_02,param_03,physics_createcontents(var_04));
	foreach(var_08 in var_06)
	{
		var_09 = undefined;
		var_0A = [var_08 gettagorigin("j_head"),var_08 gettagorigin("j_mainroot"),var_08 gettagorigin("tag_origin")];
		for(var_0B = 0;var_0B < var_0A.size;var_0B++)
		{
			if(!scripts\common\trace::ray_trace_passed(param_00,var_0A[var_0B],level.characters,scripts\common\trace::create_contents(0,1,1,1,1,1)))
			{
				continue;
			}

			if(!isdefined(var_09))
			{
				var_05[var_05.size] = spawnstruct();
				var_05[var_05.size - 1].player = var_08;
				var_05[var_05.size - 1].visiblelocations = [];
				var_09 = 1;
			}

			var_05[var_05.size - 1].visiblelocations[var_05[var_05.size - 1].visiblelocations.size] = var_0A[var_0B];
		}
	}

	return var_05;
}

//Function Number: 477
botpredictseepoint(param_00,param_01,param_02,param_03)
{
	return func_7E9B(param_00,param_01,param_02,param_03,scripts\common\trace::create_character_contents());
}

//Function Number: 478
func_7E9B(param_00,param_01,param_02,param_03,param_04)
{
	if(param_01 <= 0)
	{
		return [];
	}

	var_05 = undefined;
	if(isdefined(param_03))
	{
		if(isarray(param_03))
		{
			var_05 = param_03;
		}
		else
		{
			var_05 = [param_03];
		}
	}

	var_06 = function_028B(param_00,param_01,param_04,var_05,"physicsquery_all");
	var_07 = [];
	if(!isdefined(param_02))
	{
		foreach(var_09 in var_06)
		{
			var_0A = var_09["entity"];
			var_07[var_07.size] = var_0A;
		}
	}
	else
	{
		foreach(var_09 in var_09)
		{
			var_0A = var_09["entity"];
			if(isdefined(var_0A.team) && var_0A.team == param_02)
			{
				var_07[var_07.size] = var_0A;
			}
		}
	}

	return var_07;
}

//Function Number: 479
roundup(param_00)
{
	if(param_00 - int(param_00) >= 0.5)
	{
		return int(param_00 + 1);
	}

	return int(param_00);
}

//Function Number: 480
func_9E05(param_00,param_01)
{
	if(!level.teambased)
	{
		return 0;
	}

	if(!isplayer(param_01) && !isdefined(param_01.team))
	{
		return 0;
	}

	if(param_00 != param_01.team)
	{
		return 0;
	}

	return 1;
}

//Function Number: 481
playersareenemies(param_00,param_01)
{
	if(!isdefined(param_00) || !isdefined(param_01))
	{
		return undefined;
	}

	if(!isdefined(param_00.team) || !isdefined(param_01.team))
	{
		return undefined;
	}

	if(level.teambased)
	{
		return param_00.team != param_01.team;
	}

	return param_00 != param_01;
}

//Function Number: 482
istrue(param_00)
{
	return isdefined(param_00) && param_00;
}

//Function Number: 483
adddamagemodifier(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_02))
	{
		param_02 = 1;
	}

	if(param_02)
	{
		if(!isdefined(self.additivedamagemodifiers))
		{
			self.additivedamagemodifiers = [];
		}

		self.additivedamagemodifiers[param_00] = param_01;
		if(isdefined(param_03))
		{
			if(!isdefined(self.var_17DE))
			{
				self.var_17DE = [];
			}

			self.var_17DE[param_00] = param_03;
			return;
		}

		return;
	}

	if(!isdefined(self.multiplicativedamagemodifiers))
	{
		self.multiplicativedamagemodifiers = [];
	}

	self.multiplicativedamagemodifiers[param_00] = param_01;
	if(isdefined(param_03))
	{
		if(!isdefined(self.var_BDC7))
		{
			self.var_BDC7 = [];
		}

		self.var_BDC7[param_00] = param_03;
	}
}

//Function Number: 484
removedamagemodifier(param_00,param_01)
{
	if(!isdefined(param_01))
	{
		param_01 = 1;
	}

	if(param_01)
	{
		if(!isdefined(self.additivedamagemodifiers))
		{
			return;
		}

		self.additivedamagemodifiers[param_00] = undefined;
		if(!isdefined(self.var_17DE))
		{
			return;
		}

		self.var_17DE[param_00] = undefined;
		return;
	}

	if(!isdefined(self.multiplicativedamagemodifiers))
	{
		return;
	}

	self.multiplicativedamagemodifiers[param_00] = undefined;
	if(!isdefined(self.var_BDC7))
	{
		return;
	}

	self.var_BDC7[param_00] = undefined;
}

//Function Number: 485
getdamagemodifiertotal(param_00,param_01,param_02,param_03,param_04,param_05,param_06)
{
	var_07 = 1;
	if(isdefined(self.additivedamagemodifiers))
	{
		foreach(var_0B, var_09 in self.additivedamagemodifiers)
		{
			var_0A = 0;
			if(isdefined(self.var_17DE) && isdefined(self.var_17DE[var_0B]))
			{
				var_0A = [[ self.var_17DE[var_0B] ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06);
			}

			if(!var_0A)
			{
				var_07 = var_07 + var_09 - 1;
			}
		}
	}

	var_0C = 1;
	if(isdefined(self.multiplicativedamagemodifiers))
	{
		foreach(var_0B, var_09 in self.multiplicativedamagemodifiers)
		{
			var_0A = 0;
			if(isdefined(self.var_BDC7) && isdefined(self.var_BDC7[var_0B]))
			{
				var_0A = [[ self.var_BDC7[var_0B] ]](param_00,param_01,param_02,param_03,param_04,param_05,param_06);
			}

			if(!var_0A)
			{
				var_0C = var_0C * var_09;
			}
		}
	}

	return var_07 * var_0C;
}

//Function Number: 486
cleardamagemodifiers()
{
	self.additivedamagemodifiers = [];
	self.multiplicativedamagemodifiers = [];
	self.var_17DE = [];
	self.var_BDC7 = [];
}

//Function Number: 487
_enablecollisionnotifies(param_00)
{
	if(!isdefined(self.enabledcollisionnotifies))
	{
		self.enabledcollisionnotifies = 0;
	}

	if(param_00)
	{
		if(self.enabledcollisionnotifies == 0)
		{
			self enablecollisionnotifies(1);
		}

		self.var_6262++;
	}
	else
	{
		if(self.enabledcollisionnotifies == 1)
		{
			self enablecollisionnotifies(0);
		}

		self.var_6262--;
	}
}

//Function Number: 488
func_1C4A(param_00)
{
	if(self.loadoutarchetype != "archetype_heavy")
	{
		return;
	}

	if(param_00)
	{
		if(!isdefined(self.var_55CB))
		{
			self.var_55CB = 0;
		}

		self.var_55CB--;
		if(!self.var_55CB)
		{
			self allowgroundpound(1);
			return;
		}

		return;
	}

	if(!isdefined(self.var_55CB))
	{
		self.var_55CB = 0;
	}

	self.var_55CB++;
	self allowgroundpound(0);
}

//Function Number: 489
func_1C41(param_00)
{
	if(self.loadoutarchetype != "archetype_scout")
	{
		return;
	}

	if(param_00)
	{
		if(!isdefined(self.var_55C4))
		{
			self.var_55C4 = 0;
		}

		self.var_55C4--;
		if(!self.var_55C4)
		{
			self allowdodge(1);
			return;
		}

		return;
	}

	if(!isdefined(self.var_55C4))
	{
		self.var_55C4 = 0;
	}

	self.var_55C4++;
	self allowdodge(0);
}

//Function Number: 490
func_1C47(param_00)
{
	if(param_00)
	{
		if(!isdefined(self.var_55C9))
		{
			self.var_55C9 = 0;
		}
		else
		{
			self.var_55C9--;
		}

		if(!self.var_55C9)
		{
			if(scripts\engine\utility::is_player_gamepad_enabled())
			{
				_setactionslot(3,"taunt");
				return;
			}

			_setactionslot(7,"taunt");
			return;
		}

		return;
	}

	if(!isdefined(self.var_55C9))
	{
		self.var_55C9 = 0;
	}

	self.var_55C9++;
	if(scripts\engine\utility::is_player_gamepad_enabled())
	{
		_setactionslot(3,"");
		return;
	}

	_setactionslot(7,"");
}

//Function Number: 491
func_13A1E(param_00,param_01,param_02,param_03,param_04)
{
	self endon("disconnect");
	self endon("end_entities_in_radius");
	level endon("game_ended");
	for(;;)
	{
		if(!isdefined(self))
		{
			return;
		}

		var_05 = undefined;
		if(param_04)
		{
			var_05 = clearscrambler(self.origin,param_00);
		}
		else
		{
			var_05 = func_7E9B(self.origin,param_00);
		}

		if(var_05.size > 0)
		{
			if(!param_03)
			{
				self notify(param_01,var_05);
			}
			else
			{
				var_06 = [];
				foreach(var_08 in var_05)
				{
					var_09 = self getorigin();
					var_0A = scripts\engine\utility::ter_op(param_04,var_08 geteye(),var_08.origin);
					var_0B = physics_createcontents(["physicscontents_solid","physicscontents_structural","physicscontents_vehicleclip","physicscontents_item","physicscontents_canshootclip"]);
					var_0C = function_0287(var_09,var_0A,var_0B,undefined,0,"physicsquery_closest");
					if(var_0C.size <= 0)
					{
						var_06[var_06.size] = var_08;
					}
				}

				self notify(param_01,var_06);
			}
		}

		wait(param_02);
	}
}

//Function Number: 492
func_3880()
{
	self notify("end_entities_in_radius");
}

//Function Number: 493
isleft2d(param_00,param_01,param_02)
{
	var_03 = (param_00[0],param_00[1],0);
	var_04 = (param_02[0],param_02[1],0);
	var_05 = var_04 - var_03;
	var_06 = (param_01[0],param_01[1],0);
	return var_05[0] * var_06[1] - var_05[1] * var_06[0] < 0;
}

//Function Number: 494
radiusplayerdamage(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08,param_09)
{
	if(!isdefined(param_09))
	{
		param_09 = 0;
	}

	var_0A = scripts\common\trace::create_character_contents();
	var_0B = scripts\common\trace::create_contents(0,1,1,0,1,0);
	var_0C = [];
	foreach(var_0E in level.characters)
	{
		if(!isdefined(var_0E))
		{
			continue;
		}

		if(!isreallyalive(var_0E))
		{
			var_0C[var_0C.size] = var_0E;
			continue;
		}

		if(param_09 && var_0E == param_05)
		{
			var_0C[var_0C.size] = var_0E;
			continue;
		}

		if(level.teambased && var_0E.team == param_05.team)
		{
			var_0C[var_0C.size] = var_0E;
		}
	}

	var_10 = function_028B(param_05.origin,param_02,var_0A,var_0C,"physicsquery_all");
	if(isdefined(var_10) && var_10.size > 0)
	{
		for(var_11 = 0;var_11 < var_10.size;var_11++)
		{
			var_12 = var_10[var_11]["entity"];
			var_13 = var_10[var_11]["distance"];
			var_14 = var_10[var_11]["position"];
			var_15 = function_0287(param_00,var_14,var_0B,undefined,0,"physicsquery_closest");
			if(isdefined(var_15) && var_15.size > 0)
			{
				continue;
			}

			var_16 = max(var_13,param_01) / param_02;
			var_17 = param_03 + param_04 - param_03 * var_16;
			var_12 dodamage(var_17,param_00,param_05,param_06,param_07,param_08);
		}
	}
}

//Function Number: 495
func_9EAF(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "orbital_deployment":
			return 1;
	}

	return var_01;
}

//Function Number: 496
func_1824(param_00,param_01,param_02)
{
	func_50A5(param_00,param_02);
	if(isdefined(param_02))
	{
		self.var_EC52[param_00][param_02] = self.var_EC52[param_00][param_02] + param_01;
		return;
	}

	self.var_EC51[param_00] = self.var_EC51[param_00] + param_01;
}

//Function Number: 497
func_E165(param_00,param_01,param_02)
{
	func_50A5(param_00,param_02);
	if(isdefined(param_02))
	{
		self.var_EC52[param_00][param_02] = self.var_EC52[param_00][param_02] - param_01;
		return;
	}

	self.var_EC51[param_00] = self.var_EC51[param_00] - param_01;
}

//Function Number: 498
_meth_8101(param_00,param_01)
{
	func_50A5(param_00,param_01);
	if(isdefined(param_01))
	{
		return self.var_EC52[param_00][param_01];
	}

	return self.var_EC51[param_00];
}

//Function Number: 499
func_50A5(param_00,param_01)
{
	if(!isdefined(self.var_EC52))
	{
		self.var_EC52 = [];
	}

	if(!isdefined(self.var_EC51))
	{
		self.var_EC51 = [];
	}

	if(isdefined(param_01))
	{
		if(!isdefined(self.var_EC52[param_00]))
		{
			self.var_EC52[param_00] = [];
		}

		if(!isdefined(self.var_EC52[param_00][param_01]))
		{
			self.var_EC52[param_00][param_01] = 1;
			return;
		}

		return;
	}

	if(!isdefined(self.var_EC51[param_00]))
	{
		self.var_EC51[param_00] = 1;
	}
}

//Function Number: 500
func_DE39(param_00)
{
	foreach(var_03, var_02 in self.powers)
	{
		func_DE38(var_03,param_00);
	}
}

//Function Number: 501
func_DE38(param_00,param_01)
{
	var_02 = self.powers[param_00];
	var_03 = level.powers[param_00];
	var_04 = var_03.cooldowntime;
	var_05 = var_02.var_4617;
	if(!isdefined(var_04) || !isdefined(var_05) || var_05 <= 0 || var_05 >= var_04)
	{
		return;
	}

	var_05 = var_05 + param_01;
	if(var_05 >= var_04)
	{
		var_05 = var_04;
	}

	scripts\mp\powers::func_D74F(param_00,var_05);
}

//Function Number: 502
pointvscone(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07)
{
	var_08 = param_00 - param_01;
	var_09 = vectordot(var_08,param_02);
	var_0A = vectordot(var_08,param_03);
	if(var_09 > param_04)
	{
		return 0;
	}

	if(var_09 < param_05)
	{
		return 0;
	}

	if(isdefined(param_07))
	{
		if(abs(var_0A) > param_07)
		{
			return 0;
		}
	}

	if(scripts\engine\utility::anglebetweenvectors(param_02,var_08) > param_06)
	{
		return 0;
	}

	return 1;
}

//Function Number: 503
func_D64A(param_00,param_01,param_02,param_03,param_04)
{
	var_05 = param_04 - param_02;
	var_06 = vectordot(var_05,param_03);
	if(var_06 < 0 || var_06 > param_01)
	{
		return 0;
	}

	var_05 = var_05 - var_06 * param_03;
	var_07 = lengthsquared(var_05);
	if(var_07 > param_00)
	{
		return 0;
	}

	return 1;
}

//Function Number: 504
func_1319B(param_00,param_01)
{
	var_02 = vectorcross(param_00,param_01);
	param_01 = vectorcross(var_02,param_00);
	var_03 = axistoangles(param_00,var_02,param_01);
	return var_03;
}

//Function Number: 505
func_9EF6(param_00,param_01)
{
	var_02 = 0;
	if(isagent(param_00) && isdefined(param_00.agent_type) && param_00.agent_type == "playerProxy")
	{
		if(param_00.triggerportableradarping == param_01)
		{
			var_02 = 1;
		}
	}

	return var_02;
}

//Function Number: 506
givestreakpointswithtext(param_00,param_01,param_02)
{
	if(isdefined(level.ignorescoring))
	{
		return;
	}

	if(isdefined(param_02))
	{
		var_03 = param_02;
	}
	else
	{
		var_03 = scripts\mp\rank::getscoreinfovalue(param_01);
	}

	var_03 = func_B93D(param_00,var_03,param_01);
	scripts\mp\killstreaks\_killstreaks::_meth_83A7(param_00,var_03);
	displayscoreeventpoints(var_03,param_00);
	if(param_00 == "assist_hardline")
	{
		scripts\mp\missions::func_D991("ch_hardline_extra_score",var_03);
	}
}

//Function Number: 507
giveunifiedpoints(param_00,param_01,param_02,param_03,param_04,param_05)
{
	if(isdefined(level.ignorescoring) && !issubstr(param_00,"assist"))
	{
		return;
	}

	if(isdefined(param_02))
	{
		var_06 = param_02;
	}
	else
	{
		var_06 = scripts\mp\rank::getscoreinfovalue(param_01);
	}

	var_06 = func_B93D(param_00,var_06,param_01);
	scripts\mp\gamescore::giveplayerscore(param_00,var_06);
	scripts\mp\killstreaks\_killstreaks::_meth_83A7(param_00,var_06);
	if(!istrue(param_05))
	{
		thread scripts\mp\rank::giverankxp(param_00,var_06,param_01);
	}

	if(shouldgivesuperpoints(param_00) && var_06 > 0)
	{
		scripts\mp\supers::stopshellshock(var_06);
	}

	if(!istrue(param_04))
	{
		displayscoreeventpoints(var_06,param_00);
	}
}

//Function Number: 508
displayscoreeventpoints(param_00,param_01)
{
	if(getdvarint("com_codcasterEnabled",0) == 1)
	{
		foreach(var_03 in level.players)
		{
			if(var_03 ismlgspectator())
			{
				var_04 = var_03 getspectatingplayer();
				if(isdefined(var_04))
				{
					var_05 = var_04 getentitynumber();
					var_06 = self getentitynumber();
					if(var_05 == var_06)
					{
						var_03 thread scripts\mp\rank::scorepointspopup(param_00);
						var_03 thread scripts\mp\rank::scoreeventpopup(param_01);
					}
				}
			}
		}
	}

	if(!isdefined(level.var_10269))
	{
		var_08 = 0;
		if(issimultaneouskillenabled())
		{
			var_08 = param_01 == "kill";
		}

		thread scripts\mp\rank::scorepointspopup(param_00,var_08);
	}

	thread scripts\mp\rank::scoreeventpopup(param_01);
}

//Function Number: 509
func_B93D(param_00,param_01,param_02)
{
	var_03 = param_01;
	switch(param_00)
	{
		case "damage":
			return 0;

		default:
			break;
	}

	var_04 = 0;
	var_04 = var_04 + scripts/mp/supers/super_amplify::func_1E58(var_03);
	var_05 = _meth_8101(param_00,param_02);
	var_05 = var_05 - 1;
	var_04 = var_04 + var_03 * var_05;
	param_01 = param_01 + var_04;
	if(isdefined(level.modifyunifiedpointscallback))
	{
		param_01 = [[ level.modifyunifiedpointscallback ]](param_01,param_00,self,param_02);
	}

	return int(param_01);
}

//Function Number: 510
shouldgivesuperpoints(param_00)
{
	switch(param_00)
	{
		case "super_pack":
		case "scorestreak_pack":
		case "battery_pack":
			return 0;

		case "medal_mode_sd_last_defuse_score":
		case "medal_mode_sd_defuse_score":
		case "plant":
			return !isanymlgmatch();

		default:
			return 1;
	}
}

//Function Number: 511
func_248F(param_00)
{
	if(isdefined(param_00) && scripts\engine\utility::string_starts_with(param_00,"mod_"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 512
func_248E(param_00)
{
	return isdefined(param_00) && scripts\engine\utility::string_starts_with(param_00,"cos_");
}

//Function Number: 513
_hudoutlineviewmodeldisable()
{
	if(!isreallyalive(self))
	{
		return;
	}

	self _meth_8192();
}

//Function Number: 514
_hudoutlineviewmodelenable(param_00,param_01,param_02)
{
	if(!isdefined(param_01))
	{
		param_01 = 0;
	}

	if(!isdefined(param_02))
	{
		param_02 = 0;
	}

	if(!isplayer(self))
	{
	}

	if(!param_01 && !isreallyalive(self))
	{
	}

	if(param_01 && !isreallyalive(self))
	{
		thread func_91AE(param_00);
		return;
	}

	self gettag(param_00,param_02);
}

//Function Number: 515
func_91AE(param_00)
{
	level endon("game_ended");
	self waittill("spawned");
	if(!isdefined(self))
	{
		return;
	}

	if(!isreallyalive(self))
	{
		return;
	}

	if(!isplayer(self))
	{
		return;
	}

	self gettag(param_00);
}

//Function Number: 516
func_627A(param_00,param_01)
{
	if(param_00)
	{
		physics_setgravityragdollscalar(param_01);
		level.var_DC24 = 1;
		return;
	}

	physics_setgravityragdollscalar(1);
	level.var_DC24 = undefined;
}

//Function Number: 517
isragdollzerog()
{
	return istrue(level.var_DC24);
}

//Function Number: 518
isbombsiteweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	switch(param_00)
	{
		case "briefcase_bomb_mp":
		case "bomb_site_mp":
			return 1;
	}

	return 0;
}

//Function Number: 519
isgesture(param_00)
{
	if(issubstr(param_00,"ges_plyr"))
	{
		return 1;
	}

	if(issubstr(param_00,"devilhorns_mp"))
	{
		return 1;
	}

	return 0;
}

//Function Number: 520
iskillstreakweapon(param_00)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(param_00 == "none")
	{
		return 0;
	}

	if(scripts\engine\utility::isdestructibleweapon(param_00))
	{
		return 0;
	}

	if(isbombsiteweapon(param_00))
	{
		return 0;
	}

	if(isgesture(param_00))
	{
		return 0;
	}

	if(issubstr(param_00,"killstreak"))
	{
		return 1;
	}

	if(issubstr(param_00,"remote_tank_projectile"))
	{
		return 1;
	}

	if(issubstr(param_00,"minijackal_"))
	{
		return 1;
	}

	if(isdefined(level.killstreakweildweapons) && isdefined(level.killstreakweildweapons[param_00]))
	{
		return 1;
	}

	param_00 = func_1717(param_00);
	if(scripts\engine\utility::isairdropmarker(param_00))
	{
		return 1;
	}

	var_01 = function_0244(param_00);
	if(isdefined(var_01) && var_01 == "exclusive")
	{
		return 1;
	}

	return 0;
}

//Function Number: 521
func_1717(param_00)
{
	if(issubstr(param_00,"iw7") || issubstr(param_00,"iw6"))
	{
		var_01 = getweaponrootname(param_00);
		param_00 = func_13C75(var_01);
		if(param_00 == var_01)
		{
			param_00 = param_00 + "_mp";
		}
	}
	else
	{
		var_02 = strtok(param_00,"_");
		if(!scripts\engine\utility::string_starts_with(var_02[var_02.size - 1],"mp"))
		{
			param_00 = param_00 + "_mp";
		}
	}

	return param_00;
}

//Function Number: 522
placeequipmentfailed(param_00,param_01,param_02,param_03)
{
	self playlocalsound("scavenger_pack_pickup");
	if(istrue(param_01))
	{
		var_04 = undefined;
		if(isdefined(param_03))
		{
			var_04 = function_01E1(scripts\engine\utility::getfx("placeEquipmentFailed"),param_02,self,anglestoforward(param_03),anglestoup(param_03));
		}
		else
		{
			var_04 = function_01E1(scripts\engine\utility::getfx("placeEquipmentFailed"),param_02,self);
		}

		triggerfx(var_04);
		thread placeequipmentfailedcleanup(var_04);
	}

	switch(param_00)
	{
		case "micro_turret_mp":
		case "shard_ball_mp":
		case "deployable_cover_mp":
		case "trophy_mp":
		case "domeshield_mp":
		case "cryo_mine_mp":
		case "trip_mine_mp":
		case "blackhole_grenade_mp":
			if(isplayer(self) && isreallyalive(self))
			{
				self iprintlnbold("Placement Failed");
			}
	
			break;
	}
}

//Function Number: 523
func_CC18()
{
	level._effect["placeEquipmentFailed"] = loadfx("vfx/core/mp/killstreaks/vfx_ballistic_vest_death");
}

//Function Number: 524
placeequipmentfailedcleanup(param_00)
{
	wait(2);
	param_00 delete();
}

//Function Number: 525
bufferednotify(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	thread bufferednotify_internal(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08);
}

//Function Number: 526
bufferednotify_internal(param_00,param_01,param_02,param_03,param_04,param_05,param_06,param_07,param_08)
{
	self endon("disconnect");
	level endon("game_ended");
	var_09 = "bufferedNotify_" + param_00;
	self notify(var_09);
	self endon(var_09);
	if(!isdefined(self.bufferednotifications))
	{
		self.bufferednotifications = [];
	}

	if(!isdefined(self.bufferednotifications[param_00]))
	{
		self.bufferednotifications[param_00] = [];
	}

	var_0A = spawnstruct();
	var_0A.var_C8E5 = param_01;
	var_0A.var_C8E6 = param_02;
	var_0A.var_C8E7 = param_03;
	var_0A.var_C8E8 = param_04;
	var_0A.var_C8E9 = param_05;
	var_0A.var_C8EA = param_06;
	var_0A.var_C8EB = param_07;
	var_0A.var_C8EC = param_08;
	self.bufferednotifications[param_00][self.bufferednotifications[param_00].size] = var_0A;
	waittillframeend;
	while(self.bufferednotifications[param_00].size > 0)
	{
		var_0A = self.bufferednotifications[param_00][0];
		self notify(param_00,var_0A.var_C8E5,var_0A.var_C8E6,var_0A.var_C8E7,var_0A.var_C8E8,var_0A.var_C8E9,var_0A.var_C8EA,var_0A.var_C8EB,var_0A.var_C8EC);
		self.bufferednotifications[param_00] = array_remove_index(self.bufferednotifications[param_00],0);
		wait(0.05);
	}
}

//Function Number: 527
aiclearanim()
{
	if(level.rankedmatch)
	{
		return "mp";
	}

	return "mp_private";
}

//Function Number: 528
clearalltextafterhudelem()
{
	if(level.rankedmatch)
	{
		return "rankedloadouts";
	}

	return "privateloadouts";
}

//Function Number: 529
func_F7F1()
{
	level.var_10E59 = aiclearanim();
	level.loadoutsgroup = clearalltextafterhudelem();
}

//Function Number: 530
func_F751()
{
	self.var_9331 = 1;
}

//Function Number: 531
func_41BA()
{
	self.var_9331 = undefined;
}

//Function Number: 532
notifyafterframeend(param_00,param_01)
{
	self waittill(param_00);
	waittillframeend;
	self notify(param_01);
}

//Function Number: 533
func_7F9B()
{
	return 3;
}

//Function Number: 534
getmaxoutofboundscooldown()
{
	return 3;
}

//Function Number: 535
getcurrentmonitoredweaponswitchweapon()
{
	validatelistener();
	var_00 = self _meth_856D();
	if(!isdefined(var_00) || var_00 == "none")
	{
		return undefined;
	}

	return var_00;
}

//Function Number: 536
isanymonitoredweaponswitchinprogress()
{
	return isdefined(getcurrentmonitoredweaponswitchweapon());
}

//Function Number: 537
isreliablyswitchingtoweapon(param_00)
{
	var_01 = getcurrentmonitoredweaponswitchweapon();
	return isdefined(var_01) && var_01 == param_00 && !iscurrentweapon(param_00);
}

//Function Number: 538
func_391B(param_00)
{
	if(!self hasweapon(param_00))
	{
		return 0;
	}

	var_01 = getcurrentmonitoredweaponswitchweapon();
	if(isdefined(var_01))
	{
		var_02 = 0;
		if(param_00 == "briefcase_bomb_mp" || param_00 == "briefcase_bomb_defuse_mp" || param_00 == "iw7_uplinkball_mp" || param_00 == "iw7_tdefball_mp")
		{
			var_02 = 1;
		}
		else if(function_0244(var_01) == "primary")
		{
			var_02 = 1;
		}

		if(!var_02)
		{
			return 0;
		}
	}

	if(iscurrentweapon(param_00))
	{
		return 0;
	}

	return 1;
}

//Function Number: 539
func_1529(param_00)
{
	func_4F5B("+++ ABORT - " + param_00);
	if(self _meth_856D() == param_00)
	{
		self _meth_8570(param_00);
	}

	_takeweapon(param_00);
}

//Function Number: 540
_visionsetnaked(param_00,param_01)
{
	foreach(var_03 in level.players)
	{
		if(!isdefined(var_03))
		{
			continue;
		}

		if(isai(var_03))
		{
			continue;
		}

		var_03 visionsetnakedforplayer(param_00,param_01);
	}
}

//Function Number: 541
func_11383(param_00,param_01)
{
	self endon("disconnect");
	self endon("death");
	func_4F5B(">>> BEGIN switchToWeaponReliable() - " + param_00);
	if(!func_391B(param_00))
	{
		func_4F5B(">>> FAIL (early) switchToWeaponReliable() - " + param_00);
		return 0;
	}

	if(isanymonitoredweaponswitchinprogress())
	{
		self _meth_8570(getcurrentmonitoredweaponswitchweapon());
	}

	self _meth_856F(param_00);
	if(istrue(param_01))
	{
		_switchtoweaponimmediate(param_00);
	}

	for(;;)
	{
		if(iscurrentweapon(param_00))
		{
			validatelistener();
			func_4F5B(">>> SUCCESS switchToWeaponReliable() - " + param_00);
			return 1;
		}

		if(!self _meth_856E(param_00) || !self hasweapon(param_00))
		{
			func_4F5B(">>> FAIL switchToWeaponReliable() - " + param_00);
			return 0;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 542
validatelistener()
{
	var_00 = self getcurrentweapon();
	if(self _meth_856E(var_00))
	{
		self _meth_8570(var_00);
	}
}

//Function Number: 543
forcethirdpersonwhenfollowing(param_00)
{
	self endon("death");
	self endon("disconnect");
	if(!self hasweapon(param_00))
	{
		return;
	}

	if(!iscurrentweapon(param_00))
	{
		_takeweapon(param_00);
		return;
	}

	while(isanymonitoredweaponswitchinprogress())
	{
		scripts\engine\utility::waitframe();
	}

	if(!iscurrentweapon(param_00))
	{
		_takeweapon(param_00);
		return;
	}

	var_01 = undefined;
	if(isbot(self))
	{
		var_01 = 1;
	}

	var_02 = func_11383(self.lastdroppableweaponobj,var_01);
	_takeweapon(param_00);
	self notify("bomb_allow_offhands");
	if(!var_02)
	{
		func_72ED();
	}
}

//Function Number: 544
func_72ED(param_00)
{
	self endon("death");
	self endon("disconnect");
	while(self getcurrentweapon() == "none")
	{
		if(self isswitchingweapon() || isanymonitoredweaponswitchinprogress())
		{
			scripts\engine\utility::waitframe();
			continue;
		}

		var_01 = param_00;
		if(!isdefined(var_01) || !self hasweapon(var_01))
		{
			if(!isdefined(self.lastdroppableweaponobj) || self.lastdroppableweaponobj == "none")
			{
				break;
			}

			var_01 = self.lastdroppableweaponobj;
		}

		var_02 = getcurrentprimaryweaponsminusalt();
		if(isdefined(var_01) && getweaponbasedsmokegrenadecount(var_01) == "iw7_axe_mp" && self getweaponammoclip(var_01) == 0 && var_02.size == 1)
		{
			var_01 = "iw7_fists_mp";
		}

		func_11383(var_01);
		scripts\engine\utility::waitframe();
	}
}

//Function Number: 545
iscurrentweapon(param_00)
{
	var_01 = self getcurrentweapon();
	if(isstrstart(param_00,"alt_"))
	{
		param_00 = getsubstr(param_00,4);
	}

	if(isstrstart(var_01,"alt_"))
	{
		var_01 = getsubstr(var_01,4);
	}

	return var_01 == param_00;
}

//Function Number: 546
func_9F72(param_00)
{
	return istrue(param_00.var_9F72);
}

//Function Number: 547
func_9F22(param_00)
{
	if(!isdefined(param_00.var_165A))
	{
		return 0;
	}

	return param_00.var_165A == "remote_c8";
}

//Function Number: 548
func_9F8C(param_00)
{
	var_01 = param_00 getentitynumber();
	if(!isdefined(level.supertrophy))
	{
		return 0;
	}

	if(!isdefined(level.supertrophy.trophies))
	{
		return 0;
	}

	if(!isdefined(level.supertrophy.trophies[var_01]))
	{
		return 0;
	}

	return level.supertrophy.trophies[var_01] == param_00;
}

//Function Number: 549
ismicroturret(param_00)
{
	var_01 = param_00 getentitynumber();
	if(!isdefined(level.microturrets))
	{
		return 0;
	}

	if(!isdefined(level.microturrets[var_01]))
	{
		return 0;
	}

	return level.microturrets[var_01] == param_00;
}

//Function Number: 550
isjackal(param_00)
{
	if(!isdefined(param_00.streakinfo))
	{
		return 0;
	}

	if(!isdefined(param_00.streakinfo.streakname))
	{
		return 0;
	}

	return param_00.streakinfo.streakname == "jackal";
}

//Function Number: 551
isturret(param_00)
{
	return isdefined(param_00.classname) && param_00.classname == "misc_turret";
}

//Function Number: 552
isdronepackage(param_00)
{
	return isdefined(param_00.cratetype);
}

//Function Number: 553
_enableignoreme()
{
	if(!isdefined(self.ignorme_count))
	{
		self.ignorme_count = 0;
	}

	if(self.ignorme_count == 0)
	{
		self.ignoreme = 1;
	}

	self.ignorme_count++;
}

//Function Number: 554
_disableignoreme()
{
	if(self.ignorme_count == 1)
	{
		self.ignoreme = 0;
	}

	self.ignorme_count--;
}

//Function Number: 555
_resetenableignoreme()
{
	self.ignorme_count = undefined;
	self.ignoreme = 0;
}

//Function Number: 556
func_1254()
{
	if(!isdefined(self.enabledequipdeployvfx))
	{
		self.enabledequipdeployvfx = 0;
	}

	if(self.enabledequipdeployvfx == 0)
	{
		self getrankinfolevel(1);
	}

	self.var_6263++;
}

//Function Number: 557
func_11DB()
{
	if(self.enabledequipdeployvfx == 1)
	{
		self getrankinfolevel(0);
	}

	self.var_6263--;
}

//Function Number: 558
func_8EC6()
{
	if(!isdefined(self.var_12B1F))
	{
		self.var_8EC7 = 0;
	}

	if(self.var_8EC7 == 0)
	{
		self setclientomnvar("ui_hide_hud",1);
	}

	self.var_8EC7++;
}

//Function Number: 559
func_8EC4()
{
	if(self.var_8EC7 == 1)
	{
		self setclientomnvar("ui_hide_hud",0);
	}

	self.var_8EC7--;
}

//Function Number: 560
func_8ECD()
{
	if(!isdefined(self.var_8ECE))
	{
		self.var_8ECE = 0;
	}

	if(self.var_8ECE == 0)
	{
		self setclientomnvar("ui_hide_minimap",1);
	}

	self.var_8ECE++;
}

//Function Number: 561
func_8ECC()
{
	if(self.var_8ECE == 1)
	{
		self setclientomnvar("ui_hide_minimap",0);
	}

	self.var_8ECE--;
}

//Function Number: 562
func_4F5B(param_00)
{
}

//Function Number: 563
iscontrollingproxyagent()
{
	var_00 = 0;
	if(isdefined(self.playerproxyagent) && isalive(self.playerproxyagent))
	{
		var_00 = 1;
	}

	return var_00;
}

//Function Number: 564
register_physics_collisions()
{
	self endon("death");
	self endon("stop_phys_sounds");
	for(;;)
	{
		self waittill("collision",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07);
		level notify("physSnd",self,var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07);
	}
}

//Function Number: 565
global_physics_sound_monitor()
{
	level notify("physics_monitor");
	level endon("physics_monitor");
	for(;;)
	{
		level waittill("physSnd",var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08);
		if(isdefined(var_00) && isdefined(var_00.phys_sound_func))
		{
			level thread [[ var_00.phys_sound_func ]](var_00,var_01,var_02,var_03,var_04,var_05,var_06,var_07,var_08);
		}
	}
}

//Function Number: 566
register_physics_collision_func(param_00,param_01)
{
	param_00.phys_sound_func = param_01;
}

//Function Number: 567
func_9FAE(param_00)
{
	return istrue(param_00.var_1D44);
}

//Function Number: 568
istouchingboundsnullify(param_00)
{
	var_01 = 0;
	if(isdefined(level.outofboundstriggerpatches) && level.outofboundstriggerpatches.size > 0)
	{
		foreach(var_03 in level.outofboundstriggerpatches)
		{
			if(isplayer(param_00) && param_00 istouching(var_03))
			{
				if(isdefined(var_03.var_336) && var_03.var_336 == "apex_unoutofbounds")
				{
					break;
				}

				var_01 = 1;
				break;
			}
			else if(!isplayer(param_00) && param_00 istouching(var_03))
			{
				var_01 = 1;
				break;
			}
		}
	}

	return var_01;
}

//Function Number: 569
printgameaction(param_00,param_01)
{
	if(getdvarint("scr_suppress_game_actions",0) == 1)
	{
		return;
	}

	var_02 = "";
	if(isdefined(param_01))
	{
		var_02 = "[" + param_01 getentitynumber() + ":" + param_01.name + "] ";
	}
}

//Function Number: 570
delaysetclientomnvar(param_00,param_01,param_02)
{
	self endon("disconnect");
	wait(param_00);
	self setclientomnvar(param_01,param_02);
}

//Function Number: 571
isfemale()
{
	return self.gender == "female";
}

//Function Number: 572
canrecordcombatrecordstats()
{
	return level.rankedmatch && !istrue(level.ignorescoring) && level.gametype != "infect" && !isdefined(level.aonrules) || level.aonrules == 0;
}

//Function Number: 573
getstreakrecordtype(param_00)
{
	if(function_02D9("mp","LethalScorestreakStatItems",param_00))
	{
		return "lethalScorestreakStats";
	}

	if(function_02D9("mp","SupportScorestreakStatItems",param_00))
	{
		return "supportScorestreakStats";
	}

	return undefined;
}

//Function Number: 574
getlowestclientnum(param_00,param_01)
{
	var_02 = undefined;
	foreach(var_04 in param_00)
	{
		if(var_04.team != "spectator" && !param_01 || isreallyalive(var_04))
		{
			if(!isdefined(var_02) || var_04 getentitynumber() < var_02)
			{
				var_02 = var_04 getentitynumber();
			}
		}
	}

	return var_02;
}

//Function Number: 575
isspawnprotected()
{
	return gettime() < self.spawntime + level.killstreakspawnshielddelayms;
}

//Function Number: 576
getcurrentprimaryweaponsminusalt()
{
	var_00 = [];
	var_01 = self getweaponslistprimaries();
	foreach(var_03 in var_01)
	{
		if(!issubstr(var_03,"alt_"))
		{
			var_00[var_00.size] = var_03;
		}
	}

	return var_00;
}

//Function Number: 577
initarbitraryuptriggers()
{
	if(isdefined(level.arbitraryuptriggers))
	{
		return;
	}

	level.arbitraryuptriggers = [];
	level.arbitraryuptriggersstructs = [];
	if(getmapname() == "mp_junk")
	{
		var_00 = getentarray("mag_up","targetname");
		if(!isdefined(var_00) || var_00.size == 0)
		{
			return;
		}

		level.arbitraryuptriggers = var_00;
		foreach(var_02 in var_00)
		{
			var_03 = var_02 getentitynumber();
			var_04 = spawnstruct();
			var_04.trigger = var_02;
			var_04.var_2857 = undefined;
			var_04.entsinside = [];
			if(isdefined(var_02.target))
			{
				var_04.var_2857 = getent(var_02.target,"targetname");
				var_04.blinkloc = var_04.var_2857.origin + (0,0,-175);
			}

			level.arbitraryuptriggersstructs[var_03] = var_04;
			thread watcharbitraryuptriggerenter(var_04);
			thread watcharbitraryuptriggerexit(var_04);
		}
	}
}

//Function Number: 578
watcharbitraryuptriggerenter(param_00)
{
	for(;;)
	{
		param_00.trigger waittill("trigger",var_01);
		if(!isdefined(var_01))
		{
			continue;
		}

		if(!shouldaddtoarbitraryuptrigger(param_00,var_01))
		{
			continue;
		}

		var_02 = var_01 getentitynumber();
		param_00.entsinside[var_02] = var_01;
		var_01.arbitraryuptriggerstruct = param_00;
	}
}

//Function Number: 579
watcharbitraryuptriggerexit(param_00)
{
	for(;;)
	{
		foreach(var_02 in param_00.entsinside)
		{
			if(!isdefined(var_02))
			{
				continue;
			}

			if(!shouldremovefromarbitraryuptrigger(param_00,var_02))
			{
				continue;
			}

			var_03 = var_02 getentitynumber();
			param_00.entsinside[var_03] = undefined;
			if(isdefined(var_02.arbitraryuptriggerstruct) && var_02.arbitraryuptriggerstruct == param_00)
			{
				var_02.arbitraryuptriggerstruct = undefined;
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 580
shouldaddtoarbitraryuptrigger(param_00,param_01)
{
	if(!isplayer(param_01))
	{
		return 0;
	}

	var_02 = param_01 getentitynumber();
	if(isdefined(param_00.entsinside[var_02]))
	{
		return 0;
	}

	return 1;
}

//Function Number: 581
shouldremovefromarbitraryuptrigger(param_00,param_01)
{
	if(!param_01 istouching(param_00.trigger))
	{
		return 1;
	}

	return 0;
}

//Function Number: 582
getarbitraryuptrigger()
{
	if(!isdefined(self.arbitraryuptriggerstruct))
	{
		return undefined;
	}

	return self.arbitraryuptriggerstruct.trigger;
}

//Function Number: 583
getarbitraryuptriggerbase()
{
	if(!isdefined(self.arbitraryuptriggerstruct))
	{
		return undefined;
	}

	return self.arbitraryuptriggerstruct.var_2857;
}

//Function Number: 584
getarbitraryuptriggerblinkloc()
{
	if(!isdefined(self.arbitraryuptriggerstruct))
	{
		return undefined;
	}

	return self.arbitraryuptriggerstruct.blinkloc;
}

//Function Number: 585
isinarbitraryup()
{
	if(isplayer(self))
	{
		if(self getworldupreferenceangles() != (0,0,0))
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 586
isprojectiledamage(param_00)
{
	var_01 = "MOD_PROJECTILE MOD_IMPACT MOD_GRENADE MOD_HEAD_SHOT";
	if(issubstr(var_01,param_00))
	{
		return 1;
	}

	return 0;
}
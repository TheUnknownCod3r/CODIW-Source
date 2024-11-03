/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_proxyagent.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 15
 * Decompile Time: 792 ms
 * Timestamp: 10/27/2023 12:29:21 AM
*******************************************************************/

//Function Number: 1
func_45D0(param_00,param_01,param_02,param_03,param_04,param_05)
{
	self.var_DAD6 = undefined;
	if(param_03 < 3)
	{
		scripts\mp\_hud_message::showerrormessage("KILLSTREAKS_SCORESTREAK_ENDING");
		return 0;
	}

	var_06 = scripts\mp\killstreaks\_killstreaks::func_D507(param_01,1);
	if(!var_06)
	{
		return 0;
	}

	thread watchplayerkillstreakend(param_02);
	thread watchgameend();
	if(!isdefined(param_04) || !param_04)
	{
		thread watchplayerkillstreakearlyexit(param_02);
	}

	if(isalive(param_00) && !scripts\mp\_utility::istrue(param_00.var_5F6F))
	{
		startcontrol(param_00,param_01.streakname,param_02,param_05);
	}
	else
	{
		self notify(param_02);
		return 0;
	}

	return 1;
}

//Function Number: 2
func_13B01(param_00,param_01)
{
	self endon("disconnect");
	self endon(param_00);
	for(;;)
	{
		self waittill("player_killstreak_death",var_02,var_03,var_04,var_05,var_06,var_07);
		if(var_03 != self && isplayer(var_03))
		{
			var_03 notify("destroyed_killstreak",var_07);
			var_03 scripts\mp\_utility::giveunifiedpoints("destroyed_" + param_01);
			thread scripts\mp\_utility::teamplayercardsplash("callout_destroyed_" + param_01,var_03);
			thread scripts\mp\_missions::killstreakkilled(param_01,self,self,undefined,var_03,var_04,var_06,var_07,"destroyed_" + param_01);
			thread scripts\mp\_utility::leaderdialogonplayer(param_01 + "_destroyed",undefined,undefined,self.origin);
		}

		self notify(param_00,1);
	}
}

//Function Number: 3
watchplayerkillstreakdisconnect(param_00)
{
	self endon(param_00);
	self waittill("disconnect");
	self notify(param_00,1);
}

//Function Number: 4
watchplayerkillstreakswitchteam(param_00)
{
	self endon(param_00);
	self waittill("joined_team");
	self notify(param_00,1);
}

//Function Number: 5
watchplayerkillstreakearlyexit(param_00)
{
	self endon("disconnect");
	self endon(param_00);
	for(;;)
	{
		var_01 = 0;
		while(self usebuttonpressed())
		{
			var_01 = var_01 + 0.05;
			if(var_01 > 0.75)
			{
				self.var_D3CB = self.origin;
				self notify(param_00);
				return;
			}

			wait(0.05);
		}

		wait(0.05);
	}
}

//Function Number: 6
watchplayerkillstreaktimeout(param_00,param_01)
{
	self endon("disconnect");
	self endon(param_00);
	wait(param_01);
	self notify(param_00,1);
}

//Function Number: 7
watchplayerkillstreakemp(param_00)
{
	self endon("disconnect");
	self endon(param_00);
	self waittill("emp_damage",var_01,var_02);
}

//Function Number: 8
watchplayerkillstreakend(param_00)
{
	scripts\engine\utility::waittill_any_3(param_00,"level_game_ended");
	stopcontrol();
}

//Function Number: 9
watchgameend()
{
	level waittill("game_ended");
	self notify("level_game_ended");
}

//Function Number: 10
startcontrol(param_00,param_01,param_02,param_03)
{
	if(isdefined(self) && isalive(param_00))
	{
		self controlagent(param_00);
		if(isdefined(param_03))
		{
			self visionsetnakedforplayer(param_03,0);
		}

		self.playerproxyagent = param_00;
	}
}

//Function Number: 11
getplayerlookattarget(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "spiderbot":
			var_01 = 0.45;
			break;

		case "remote_c8":
			var_01 = -0.2;
			break;
	}

	return var_01;
}

//Function Number: 12
stopcontrol()
{
	if(isdefined(self))
	{
		if(scripts\mp\_utility::iscontrollingproxyagent())
		{
			self restorecontrolagent();
			self visionsetnakedforplayer("",0);
		}

		thread scripts\mp\killstreaks\_killstreaks::func_11086(1);
		self.playerproxyagent = undefined;
		self.var_165A = undefined;
	}
}

//Function Number: 13
cleararchetype(param_00)
{
	scripts/mp/archetypes/archcommon::removearchetype(param_00.loadoutarchetype);
	scripts\mp\perks\_perks::_clearperks();
}

//Function Number: 14
func_DDA3(param_00)
{
	var_01 = undefined;
	switch(param_00.loadoutarchetype)
	{
		case "archetype_assault":
			var_01 = ::scripts/mp/archetypes/archassault::applyarchetype;
			break;

		case "archetype_heavy":
			var_01 = ::scripts/mp/archetypes/archheavy::applyarchetype;
			break;

		case "archetype_scout":
			var_01 = ::scripts/mp/archetypes/archscout::applyarchetype;
			break;

		case "archetype_assassin":
			var_01 = ::scripts/mp/archetypes/archassassin::applyarchetype;
			break;

		case "archetype_engineer":
			var_01 = ::scripts/mp/archetypes/archengineer::applyarchetype;
			break;

		case "archetype_sniper":
			var_01 = ::scripts/mp/archetypes/archsniper::applyarchetype;
			break;
	}

	scripts\mp\_class::loadout_updateplayerperks(param_00);
	if(isdefined(var_01))
	{
		self [[ var_01 ]]();
	}
}

//Function Number: 15
func_A670(param_00)
{
}
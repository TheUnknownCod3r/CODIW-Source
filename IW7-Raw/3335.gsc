/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3335.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 15
 * Decompile Time: 2 ms
 * Timestamp: 10/27/2023 12:26:35 AM
*******************************************************************/

//Function Number: 1
c4_used(param_00)
{
	self endon("disconnect");
	param_00 endon("death");
	param_00 thread c4_deleteonownerdisconnect(self);
	param_00.throwtime = gettime();
	c4_addtoarray(param_00);
	thread c4_watchfordetonation();
	thread c4_watchforaltdetonation();
	param_00 thread c4_explodeonnotify();
	param_00 waittill("missile_stuck");
	scripts\cp\cp_weapon::onlethalequipmentplanted(param_00,"power_c4");
	thread scripts\cp\cp_weapon::monitordisownedequipment(self,param_00);
	param_00 setscriptablepartstate("plant","active",0);
}

//Function Number: 2
c4_detonate()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	wait(0.1);
	thread c4_explode(self.triggerportableradarping);
}

//Function Number: 3
c4_explode(param_00)
{
	thread c4_delete(5);
	self setentityowner(param_00);
	self setscriptablepartstate("plant","neutral",0);
	self setscriptablepartstate("explode","active",0);
}

//Function Number: 4
c4_destroy(param_00)
{
	thread c4_delete(2);
	self setscriptablepartstate("plant","neutral",0);
	self setscriptablepartstate("destroy","active",0);
}

//Function Number: 5
c4_delete(param_00)
{
	self notify("death");
	level.mines[self getentitynumber()] = undefined;
	self.exploding = 1;
	var_01 = self.triggerportableradarping;
	if(isdefined(self.triggerportableradarping))
	{
		var_01.plantedlethalequip = scripts\engine\utility::array_remove(var_01.plantedlethalequip,self);
		var_01 notify("c4_update",0);
	}

	wait(param_00);
	self delete();
}

//Function Number: 6
c4_explodeonnotify()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	level endon("game_ended");
	var_00 = self.triggerportableradarping;
	self waittill("detonateExplosive",var_01);
	if(isdefined(var_01))
	{
		thread c4_explode(var_01);
		return;
	}

	thread c4_explode(var_00);
}

//Function Number: 7
c4_destroyonemp()
{
	self endon("death");
	self.triggerportableradarping endon("disconnect");
	self waittill("emp_damage",var_00,var_01);
	if(isdefined(self.triggerportableradarping) && var_00 != self.triggerportableradarping)
	{
		var_00 notify("destroyed_equipment");
	}

	thread c4_destroy();
}

//Function Number: 8
c4_candetonate(param_00)
{
	return gettime() - self.throwtime / 1000 > 0.3 && !isdefined(self.var_53D7);
}

//Function Number: 9
c4_watchfordetonation()
{
	self endon("death");
	self endon("disconnect");
	self endon("c4_unset");
	level endon("game_ended");
	self notify("watchForDetonation");
	self endon("watchForDetonation");
	for(;;)
	{
		self waittillmatch("c4_zm","detonate");
		thread c4_detonateall();
	}
}

//Function Number: 10
c4_watchforaltdetonation()
{
	self endon("death");
	self endon("disconnect");
	self endon("c4_unset");
	level endon("game_ended");
	self notify("watchForAltDetonation");
	self endon("watchForAltDetonation");
	var_00 = 0;
	for(;;)
	{
		if(self usebuttonpressed())
		{
			var_00 = 0;
			while(self usebuttonpressed())
			{
				var_00 = var_00 + 0.05;
				wait(0.05);
			}

			if(var_00 >= 0.5)
			{
				continue;
			}

			var_00 = 0;
			while(!self usebuttonpressed() && var_00 < 0.5)
			{
				var_00 = var_00 + 0.05;
				wait(0.05);
			}

			if(var_00 >= 0.5)
			{
				continue;
			}

			if(!scripts/cp/powers/coop_phaseshift::isentityphaseshifted(self) && !scripts\cp\utility::isusingremote() && scripts\cp\utility::isreallyalive(self))
			{
				thread c4_detonateall();
			}
		}

		wait(0.05);
	}
}

//Function Number: 11
c4_detonateall()
{
	if(isdefined(self.c4s))
	{
		foreach(var_01 in self.c4s)
		{
			if(var_01 c4_candetonate())
			{
				var_01 thread c4_detonate();
			}
		}
	}
}

//Function Number: 12
c4_addtoarray(param_00)
{
	var_01 = self.triggerportableradarping;
	if(!isdefined(self.c4s))
	{
		self.c4s = [];
	}

	self.c4s[param_00 getentitynumber()] = param_00;
	thread c4_removefromarrayondeath(param_00);
}

//Function Number: 13
c4_removefromarray(param_00)
{
	if(!isdefined(self.c4s))
	{
		return;
	}

	self.c4s[param_00] = undefined;
}

//Function Number: 14
c4_removefromarrayondeath(param_00)
{
	self endon("disconnect");
	var_01 = param_00 getentitynumber();
	param_00 waittill("death");
	c4_removefromarray(var_01);
}

//Function Number: 15
c4_deleteonownerdisconnect(param_00)
{
	self endon("death");
	self endon("missile_stuck");
	param_00 waittill("disconnect");
	self delete();
}
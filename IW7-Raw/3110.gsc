/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3110.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 25
 * Decompile Time: 3 ms
 * Timestamp: 10/27/2023 12:26:08 AM
*******************************************************************/

//Function Number: 1
func_98CB(param_00)
{
	if(!isdefined(self.var_9F46))
	{
		return level.running;
	}

	self.nocorpse = 1;
	return level.failure;
}

//Function Number: 2
func_7EA9()
{
	return 1000;
}

//Function Number: 3
func_69F3(param_00)
{
	self.var_69F5 = gettime();
	self setscriptablepartstate("beacon","activeExplode",0);
	self.var_2A9E = 1;
	return level.success;
}

//Function Number: 4
func_69F4(param_00)
{
	if(gettime() - self.var_69F5 > func_7EA9())
	{
		self notify("seeker_detonate");
		return level.running;
	}

	return level.running;
}

//Function Number: 5
func_2A70(param_00)
{
	thread func_13AEB();
	thread func_13B35();
	self notify("entering_passive_mode");
	return level.failure;
}

//Function Number: 6
func_8CA2(param_00)
{
	self ghosts_attack_logic(self.triggerportableradarping);
	return level.success;
}

//Function Number: 7
func_8CA3(param_00)
{
	if(!scripts\mp\_utility::isreallyalive(self.triggerportableradarping))
	{
		return level.success;
	}

	var_01 = distancesquared(self.triggerportableradarping.origin,self.origin);
	if(var_01 <= 10000)
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 8
func_8CA4(param_00)
{
	self clearpath();
}

//Function Number: 9
func_136D0(param_00)
{
	var_01 = distancesquared(self.triggerportableradarping.origin,self.origin);
	if(var_01 >= -25536)
	{
		if(!isdefined(self.var_CB49))
		{
			self.var_CB49 = gettime();
		}
		else if(gettime() - self.var_CB49 > 100)
		{
			return level.failure;
		}
	}
	else
	{
		self.var_CB49 = undefined;
	}

	return level.running;
}

//Function Number: 10
getseekenemytimeout()
{
	return 1000;
}

//Function Number: 11
func_2A73(param_00)
{
	self.var_F109 = gettime();
	return level.success;
}

//Function Number: 12
func_2A74(param_00)
{
	if(!func_9F3B())
	{
		return level.running;
	}

	return level.success;
}

//Function Number: 13
func_7E27()
{
	return 1000;
}

//Function Number: 14
func_3D47(param_00)
{
	self.var_3D49 = gettime();
	return level.success;
}

//Function Number: 15
func_3D48(param_00)
{
	self setscriptablepartstate("beacon","activeChase",0);
	if(!func_9F3B())
	{
		if(!func_9FB2())
		{
			thread scripts/mp/equipment/spider_grenade::spidergrenade_agenttoproxy(self,self.proxy);
			return level.running;
		}

		self clearpath();
	}
	else if(distancesquared(self.var_F181.origin,self.origin) <= 4096)
	{
		self clearpath();
	}
	else
	{
		self ghosts_attack_logic(self.var_F181);
	}

	if(gettime() - self.var_3D49 > 1000)
	{
		return level.success;
	}

	return level.running;
}

//Function Number: 16
func_24D6(param_00)
{
	self.var_24D9 = gettime();
	self ghosts_attack_logic(self.var_F181);
	return level.success;
}

//Function Number: 17
func_24D7(param_00)
{
	if(!func_9F3B())
	{
		if(!func_9FB2())
		{
			thread scripts/mp/equipment/spider_grenade::spidergrenade_agenttoproxy(self,self.proxy);
			return level.running;
		}
	}

	if(distance2dsquared(self.var_F181.origin,self.origin) <= 10000)
	{
		if(!func_9FB2())
		{
			thread scripts/mp/equipment/spider_grenade::spidergrenade_agenttoproxy(self,self.proxy);
			return level.running;
		}
	}

	if(isdefined(self.var_24D9) && gettime() - self.var_24D9 > 2250)
	{
		if(!func_9FB2())
		{
			thread scripts/mp/equipment/spider_grenade::spidergrenade_agenttoproxy(self,self.proxy);
			return level.running;
		}
	}

	return level.running;
}

//Function Number: 18
func_6385(param_00)
{
	self clearpath();
	self.var_F181 = undefined;
	return level.failure;
}

//Function Number: 19
func_7FDB()
{
	var_00 = undefined;
	var_01 = 0;
	foreach(var_03 in level.characters)
	{
		var_04 = var_03;
		if(!isdefined(var_03))
		{
			continue;
		}

		if(scripts/mp/equipment/phase_shift::isentityphaseshifted(var_03))
		{
			continue;
		}

		if(isplayer(var_03) || isagent(var_03))
		{
			if(scripts\mp\_utility::func_9F72(var_03))
			{
				continue;
			}

			if(!scripts\mp\_utility::isreallyalive(var_03))
			{
				continue;
			}

			if(scripts\mp\_utility::func_9F22(var_03))
			{
				var_04 = self.triggerportableradarping;
			}
		}

		if(!scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(self.triggerportableradarping,var_04)))
		{
			continue;
		}

		var_05 = distancesquared(var_03.origin,self.origin);
		if(var_05 >= 65536)
		{
			continue;
		}

		if(!isdefined(var_00) || var_05 < var_01)
		{
			var_00 = var_03;
			var_01 = var_05;
		}
	}

	return var_00;
}

//Function Number: 20
func_9FB2()
{
	return scripts\mp\_utility::istrue(self.var_9FB2);
}

//Function Number: 21
func_13AEB()
{
	self endon("death");
	wait(10);
	func_A6CD();
}

//Function Number: 22
func_13B35()
{
	self endon("death");
	self.var_130F2 = spawn("script_origin",self.origin + (0,0,16));
	self.var_130F2.triggerportableradarping = self;
	self.var_130F2 thread func_4120(self);
	self.var_130F2 setcursorhint("HINT_NOICON");
	self.var_130F2 sethintstring(&"MP_PICKUP_SPIDER_GRENADE");
	self.var_130F2 scripts\mp\_utility::setselfusable(self.triggerportableradarping);
	self.var_130F2 thread scripts\mp\_utility::notusableforjoiningplayers(self.triggerportableradarping);
	self.var_130F2 linkto(self);
	for(;;)
	{
		self.var_130F2 waittill("trigger",var_00);
		self.triggerportableradarping playlocalsound("scavenger_pack_pickup");
		self.triggerportableradarping notify("scavenged_ammo","power_spider_grenade_mp");
		func_A6CD();
	}
}

//Function Number: 23
func_4120(param_00)
{
	param_00 waittill("death");
	self delete();
}

//Function Number: 24
func_A6CD()
{
	scripts/mp/equipment/spider_grenade::func_5856(self.origin);
	self suicide();
}

//Function Number: 25
func_9F3B()
{
	return isdefined(self.var_F181) && scripts\mp\_utility::isreallyalive(self.var_F181);
}
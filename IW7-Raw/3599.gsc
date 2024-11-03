/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3599.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 20
 * Decompile Time: 9 ms
 * Timestamp: 10/27/2023 12:30:52 AM
*******************************************************************/

//Function Number: 1
init()
{
	level.bhgunphysicsvolumes = [];
}

//Function Number: 2
beginuse()
{
	return 1;
}

//Function Number: 3
stopuse()
{
}

//Function Number: 4
missilespawned(param_00,param_01)
{
	self endon("disconnect");
	var_02 = scripts\common\trace::create_contents(0,1,1,1,1,0,0);
	var_03 = param_01.origin;
	var_04 = anglestoforward(param_01.angles);
	var_05 = var_03 + var_04 * 1920;
	var_06 = function_0287(var_03,var_05,var_02,param_01,1,"physicsquery_closest");
	var_07 = isdefined(var_06) && var_06.size > 0;
	if(var_07)
	{
		var_08 = var_06[0]["position"];
		var_09 = distance(var_08,var_03);
		var_0A = vectornormalize(var_03 - var_08);
		var_0B = var_08 + var_0A * 80;
	}
	else
	{
		var_09 = 1920;
		var_0A = anglestoforward(var_03.angles);
		var_0B = var_06;
		var_08 = undefined;
	}

	var_0C = distance(var_0B,var_03);
	if(var_0C < 90)
	{
		var_0D = 1;
		wait(0.3);
		if(isdefined(param_01))
		{
			param_01 delete();
			return;
		}

		return;
	}

	var_0E = max(var_0C / 980,1.05);
	var_0F = spawn("script_model",var_03);
	var_0F setmodel("prop_mp_super_blackholegun_projectile");
	var_0F setotherent(self);
	var_0F moveto(var_0B,var_0E,0.1,0.95);
	var_0F.triggerportableradarping = param_01.triggerportableradarping;
	var_0F setscriptmoverkillcam("rocket");
	var_10 = var_0F.triggerportableradarping scripts\mp\_utility::_launchgrenade("blackholegun_indicator_mp",self.origin,(0,0,0));
	var_10.weapon_name = "blackholegun_indicator_mp";
	var_10 linkto(var_0F);
	var_0F thread watchfordirectplayerdamage(var_10,var_02);
	var_0F thread monitorprojectilearrive(var_0E,self,var_10,var_02);
	var_0F setscriptablepartstate("projectile","on",0);
	waittillframeend;
	if(isdefined(param_01))
	{
		param_01 delete();
	}
}

//Function Number: 5
monitorprojectilearrive(param_00,param_01,param_02,param_03)
{
	self endon("blackhole_projectile_impact");
	self endon("death");
	thread projectiledisconnectwatcher(param_01,param_02);
	wait(param_00);
	self notify("blackhole_projectile_arrive");
	thread projectilearrived(param_02,param_03);
}

//Function Number: 6
projectilearrived(param_00,param_01)
{
	self endon("death");
	self notify("projectile_arrived");
	cleanupprojectile();
	var_02 = function_0287(self.origin,self.origin - (0,0,42),param_01,undefined,1,"physicsquery_closest");
	var_03 = isdefined(var_02) && var_02.size > 0;
	if(var_03)
	{
		var_04 = var_02[0]["position"];
		self.origin = var_04 + (0,0,42);
	}

	var_05 = makeblackholeimpulsefield(param_01);
	self setscriptablepartstate("singularity","singularity",0);
	var_06 = spawnblackholephysicsvolume(2750);
	thread watchforincidentalplayerdamage(var_05);
	thread singularityquake();
	thread singularitydisconnectwatcher(var_05,self.triggerportableradarping,var_06,param_00);
	wait(2);
	thread singularityexplode(self.triggerportableradarping,var_05,var_06,param_00);
}

//Function Number: 7
ownerdisconnectcleanup(param_00)
{
	self endon("death");
	param_00 waittill("disconnect");
	self delete();
}

//Function Number: 8
makeblackholeimpulsefield(param_00)
{
	var_01 = function_02AF(self.triggerportableradarping,"bhgunfield_mp",self.origin);
	var_01 linkto(self);
	return var_01;
}

//Function Number: 9
singularityquake()
{
	self endon("death");
	var_00 = 0.4;
	var_01 = 0.0466;
	for(var_02 = 0;var_02 < 5;var_02++)
	{
		scripts\mp\_shellshock::_earthquake(var_02 + 1 * var_01,var_00 * 2,self.origin,800);
		wait(var_00);
	}
}

//Function Number: 10
trydodamage(param_00,param_01,param_02,param_03)
{
	var_04 = function_0287(self.origin,param_01,param_03,self,0,"physicsquery_closest");
	var_05 = !isdefined(var_04) && var_04.size > 0;
	if(var_05)
	{
		param_00 dodamage(param_02,self.origin,self.triggerportableradarping,self,"MOD_EXPLOSIVE","iw7_blackholegun_mp");
	}
}

//Function Number: 11
watchforincidentalplayerdamage(param_00)
{
	self endon("death");
	self endon("blackhole_die");
	self.triggerportableradarping endon("disconnect");
	var_01 = scripts\common\trace::create_contents(0,1,1,0,1,0);
	var_02 = 5898.24;
	for(;;)
	{
		foreach(var_04 in level.players)
		{
			if(!isdefined(var_04))
			{
				continue;
			}

			if(!scripts\mp\_utility::isreallyalive(var_04))
			{
				continue;
			}

			if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_04))
			{
				continue;
			}

			if(!level.friendlyfire && var_04 != self.triggerportableradarping && !scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_04,self.triggerportableradarping)))
			{
				continue;
			}

			if(distancesquared(var_04 geteye(),self.origin) > var_02)
			{
				continue;
			}

			trydodamage(var_04,var_04 geteye(),1000,var_01);
		}

		var_06 = scripts\mp\_weapons::getempdamageents(self.origin,76.8,0);
		foreach(var_08 in var_06)
		{
			if(!isdefined(var_08) || !isdefined(var_08.triggerportableradarping) || isplayer(var_08))
			{
				continue;
			}

			if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_08))
			{
				continue;
			}

			if(!level.friendlyfire && var_08.triggerportableradarping != self.triggerportableradarping && !scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_08.triggerportableradarping,self.triggerportableradarping)))
			{
				continue;
			}

			if(distancesquared(var_08.origin,self.origin) > var_02)
			{
				continue;
			}

			var_08 dodamage(18.18182,self.origin,self.triggerportableradarping,self,"MOD_EXPLOSIVE","iw7_blackholegun_mp");
		}

		wait(0.2);
	}
}

//Function Number: 12
watchfordirectplayerdamage(param_00,param_01)
{
	self endon("death");
	self endon("blackhole_projectile_arrive");
	self.triggerportableradarping endon("disconnect");
	wait(0.1);
	var_02 = spawn("trigger_radius",self.origin - (0,0,32),0,24,64);
	var_02 enablelinkto();
	var_02 linkto(self);
	var_02 thread cleanuptrigger(self);
	for(;;)
	{
		var_02 waittill("trigger",var_03);
		if(var_03 == self.triggerportableradarping)
		{
			continue;
		}

		if(!isplayer(var_03) && !isagent(var_03))
		{
			continue;
		}

		if(!scripts\mp\_utility::isreallyalive(var_03))
		{
			continue;
		}

		if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_03))
		{
			continue;
		}

		var_04 = var_03;
		if(scripts\mp\_utility::func_9F22(var_03) || scripts\mp\_utility::func_9F72(var_03))
		{
			var_04 = var_03.triggerportableradarping;
		}

		if(!level.friendlyfire && var_04 != self.triggerportableradarping && !scripts\mp\_utility::istrue(scripts\mp\_utility::playersareenemies(var_04,self.triggerportableradarping)))
		{
			continue;
		}

		self notify("blackhole_projectile_impact");
		var_03 dodamage(135,self.origin,self.triggerportableradarping,self,"MOD_EXPLOSIVE","iw7_blackholegun_mp");
		self moveto(self.origin,0.05,0,0);
		thread projectilearrived(param_00,param_01);
		break;
	}
}

//Function Number: 13
singularityexplode(param_00,param_01,param_02,param_03)
{
	self setscriptablepartstate("singularity","explosion",0);
	self radiusdamage(self.origin,235,200,100,self.triggerportableradarping,"MOD_EXPLOSIVE","iw7_blackholegun_mp");
	self notify("singularity_explode");
	self notify("blackhole_die");
	thread cleanupsingularity(param_01,param_02,param_03);
}

//Function Number: 14
spawnblackholephysicsvolume(param_00)
{
	var_01 = physics_volumecreate(self.origin,384);
	var_01 physics_volumesetasfocalforce(1,self.origin,param_00);
	var_01 physics_volumeenable(1);
	var_01.time = gettime();
	level.bhgunphysicsvolumes scripts\engine\utility::array_removeundefined(level.bhgunphysicsvolumes);
	var_02 = undefined;
	var_03 = 0;
	for(var_04 = 0;var_04 < 3;var_04++)
	{
		var_05 = level.bhgunphysicsvolumes[var_04];
		if(!isdefined(var_05))
		{
			var_03 = var_04;
			break;
		}
		else if(!isdefined(var_02) || isdefined(var_02) && var_02.time > var_05.time)
		{
			var_02 = var_05;
			var_03 = var_04;
		}
	}

	if(isdefined(var_02))
	{
		var_02 delete();
	}

	level.bhgunphysicsvolumes[var_03] = var_01;
	var_01 thread blackholephysicsvolumeactivate();
	return var_01;
}

//Function Number: 15
blackholephysicsvolumeactivate()
{
	self endon("death");
	self physics_volumesetactivator(1);
	scripts\engine\utility::waitframe();
	self physics_volumesetactivator(0);
}

//Function Number: 16
cleanuptrigger(param_00)
{
	param_00 scripts\engine\utility::waittill_any_3("death","blackhole_projectile_arrive","blackhole_projectile_impact");
	self delete();
}

//Function Number: 17
cleanupsingularity(param_00,param_01,param_02)
{
	if(isdefined(param_01))
	{
		param_01 delete();
	}

	param_00 delete();
	if(isdefined(param_02))
	{
		param_02 delete();
	}

	wait(3);
	self setscriptablepartstate("singularity","off",0);
	self delete();
}

//Function Number: 18
projectiledisconnectwatcher(param_00,param_01)
{
	self endon("death");
	self endon("projectile_arrived");
	param_00 waittill("disconnect");
	cleanupprojectile();
	if(isdefined(param_01))
	{
		param_01 delete();
	}

	self delete();
}

//Function Number: 19
cleanupprojectile()
{
	self setscriptablepartstate("projectile","off",0);
}

//Function Number: 20
singularitydisconnectwatcher(param_00,param_01,param_02,param_03)
{
	self endon("death");
	param_01 waittill("disconnect");
	thread cleanupsingularity(param_00,param_02,param_03);
}
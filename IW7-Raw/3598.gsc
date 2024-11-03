/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3598.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 8
 * Decompile Time: 1 ms
 * Timestamp: 10/27/2023 12:30:52 AM
*******************************************************************/

//Function Number: 1
func_218F()
{
}

//Function Number: 2
func_2197()
{
	self setscriptablepartstate("armorUp","active",0);
	self setscriptablepartstate("armorUpMaterial","on");
	self.health = self.maxhealth;
	scripts\mp\_heavyarmor::addheavyarmor(getheavyarmorvalue());
	thread func_2196();
	thread func_219C();
	thread func_2199();
	if(!scripts\mp\_utility::isanymlgmatch())
	{
		thread scripts\mp\_supers::watchobjuse(75);
	}

	return 1;
}

//Function Number: 3
func_218E(param_00)
{
	self notify("armorUp_end");
	self notify("obj_drain_end");
	if(scripts\mp\_utility::istrue(param_00))
	{
		self setscriptablepartstate("armorUpMaterial","offImmediate",0);
	}
	else
	{
		self setscriptablepartstate("armorUpMaterial","off",0);
	}

	if(self.loadoutarchetype == "archetype_heavy")
	{
		self setscriptablepartstate("armorUp","neutral",0);
	}

	if(scripts\mp\_heavyarmor::hasheavyarmor() && !scripts\mp\_utility::istrue(self.heavyarmor.invulnerabilityframe))
	{
		scripts\mp\_heavyarmor::removeheavyarmor();
	}
}

//Function Number: 4
func_219C()
{
	self endon("disconnect");
	self endon("armorUp_end");
	level waittill("game_ended");
	scripts\mp\_supers::func_DE3B(9999);
}

//Function Number: 5
func_2199()
{
	self endon("disconnect");
	self endon("armorUp_end");
	self waittill("heavyArmor_broken");
	scripts\mp\_supers::func_DE3B(9999);
}

//Function Number: 6
func_2196()
{
	self endon("disconnect");
	self endon("armorUp_end");
	self.var_219F = [];
	for(;;)
	{
		self waittill("damage",var_00,var_01);
		if(isdefined(var_01))
		{
			self.var_219F[self.var_219F.size] = var_01;
		}
	}
}

//Function Number: 7
func_9FC0()
{
	var_00 = scripts\mp\_supers::getcurrentsuperref();
	if(!isdefined(var_00) || var_00 != "super_armorup")
	{
		return 0;
	}

	return scripts\mp\_supers::issuperinuse();
}

//Function Number: 8
getheavyarmorvalue()
{
	var_00 = scripts\engine\utility::ter_op(scripts\mp\_utility::isanymlgmatch(),100,114);
	return scripts\engine\utility::ter_op(scripts\mp\_utility::istrue(level.hardcoremode),76,var_00);
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\killstreaks\_designator_grenade.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 7
 * Decompile Time: 393 ms
 * Timestamp: 10/27/2023 12:28:25 AM
*******************************************************************/

//Function Number: 1
func_526C(param_00,param_01,param_02)
{
	self endon("death");
	self.marker = undefined;
	if(self getcurrentweapon() == param_01)
	{
		thread func_5268(param_01);
		thread func_526D(param_00,param_01,param_02);
		func_526E(param_01);
		return !self getrunningforwardpainanim(param_01) && self hasweapon(param_01);
	}

	return 0;
}

//Function Number: 2
func_5268(param_00)
{
	self endon("death");
	self endon("disconnect");
	var_01 = "";
	while(var_01 != param_00)
	{
		self waittill("grenade_pullback",var_01);
	}

	scripts\engine\utility::allow_usability(0);
	func_5269();
}

//Function Number: 3
func_5269()
{
	self endon("death");
	self endon("disconnect");
	scripts\engine\utility::waittill_any_3("grenade_fire","weapon_change");
	scripts\engine\utility::allow_usability(1);
}

//Function Number: 4
func_526D(param_00,param_01,param_02)
{
	self endon("designator_finished");
	self endon("spawned_player");
	self endon("disconnect");
	var_03 = undefined;
	var_04 = "";
	while(var_04 != param_01)
	{
		self waittill("grenade_fire",var_03,var_04);
	}

	if(isalive(self))
	{
		var_03.triggerportableradarping = self;
		var_03.var_39C = param_01;
		self.marker = var_03;
		thread func_526A(param_00,var_03,param_02);
	}
	else
	{
		var_03 delete();
	}

	self notify("designator_finished");
}

//Function Number: 5
func_526E(param_00)
{
	self endon("spawned_player");
	self endon("disconnect");
	var_01 = self getcurrentweapon();
	while(var_01 == param_00)
	{
		self waittill("weapon_change",var_01);
	}

	if(self getrunningforwardpainanim(param_00) == 0)
	{
		func_526B(param_00);
	}

	self notify("designator_finished");
}

//Function Number: 6
func_526B(param_00)
{
	if(self hasweapon(param_00))
	{
		scripts\mp\_utility::_takeweapon(param_00);
	}
}

//Function Number: 7
func_526A(param_00,param_01,param_02)
{
	param_01 waittill("missile_stuck",var_03);
	if(isdefined(param_01.triggerportableradarping))
	{
		self thread [[ param_02 ]](param_00,param_01);
	}

	if(isdefined(param_01))
	{
		param_01 delete();
	}
}
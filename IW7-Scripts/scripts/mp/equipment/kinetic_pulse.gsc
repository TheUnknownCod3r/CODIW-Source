/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3565.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 6
 * Decompile Time: 6 ms
 * Timestamp: 10/27/2023 12:30:43 AM
*******************************************************************/

//Function Number: 1
kineticpulse_use()
{
	self setscriptablepartstate("kineticPulse","activeWarmUp");
	scripts\engine\utility::waittill_any_timeout_no_endon_death_2(0.5,"death","disconnect");
	if(!isdefined(self))
	{
		return;
	}

	if(!scripts\mp\_utility::isreallyalive(self))
	{
		self setscriptablepartstate("kineticPulse","neutral");
		return;
	}

	self iprintlnbold("Kinetic Pulse Activated");
	self setclientomnvar("ui_hud_shake",1);
	self setscriptablepartstate("kineticPulse","activeFire");
	var_00 = [];
	var_01 = 0.05;
	var_02 = 120;
	var_03 = 200;
	var_04 = physics_createcontents(["physicscontents_solid","physicscontents_vehicle","physicscontents_glass","physicscontents_water","physicscontents_sky","physicscontents_item"]);
	var_05 = self gettagorigin("j_spineupper");
	for(var_06 = 0;var_06 < 5;var_06++)
	{
		var_07 = undefined;
		if(level.teambased && !level.friendlyfire)
		{
			var_07 = scripts\mp\_utility::clearscrambler(var_05,var_03,scripts\mp\_utility::getotherteam(self.team),undefined);
		}
		else
		{
			var_07 = scripts\mp\_utility::clearscrambler(var_05,var_03,undefined,self);
		}

		foreach(var_09 in var_07)
		{
			var_0A = var_09 getentitynumber();
			if(isdefined(var_00[var_0A]))
			{
				continue;
			}

			if(!scripts\mp\_utility::isreallyalive(var_09))
			{
				continue;
			}

			if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_09))
			{
				continue;
			}

			var_0B = var_05;
			var_0C = var_09.origin;
			var_0D = function_0287(var_0B,var_0C,var_04,undefined,0,"physicsquery_closest",1);
			if(isdefined(var_0D) && var_0D.size > 0)
			{
				var_0C = var_09 geteye();
				var_0D = function_0287(var_0B,var_0C,var_04,undefined,0,"physicsquery_closest",1);
				if(isdefined(var_0D) && var_0D.size > 0)
				{
					continue;
				}
			}

			var_00[var_0A] = var_09;
			kineticpulse_playereffects(var_09,var_05);
		}

		var_07 = scripts\mp\_weapons::getempdamageents(var_05,var_03,0);
		foreach(var_09 in var_07)
		{
			if(!isdefined(var_09))
			{
				continue;
			}

			var_0A = var_09 getentitynumber();
			if(isdefined(var_00[var_0A]))
			{
				continue;
			}

			if(!scripts/mp/equipment/phase_shift::areentitiesinphase(self,var_09))
			{
				continue;
			}

			var_10 = var_09;
			if(isdefined(var_09.triggerportableradarping))
			{
				var_10 = var_09.triggerportableradarping;
			}

			if(!scripts\mp\_weapons::friendlyfirecheck(self,var_10) && var_10 != self)
			{
				continue;
			}

			var_00[var_0A] = var_09;
			kineticpulse_nonplayereffects(var_09,var_05);
		}

		var_03 = var_03 + var_02;
		wait(var_01);
	}
}

//Function Number: 2
kineticpulse_playereffects(param_00,param_01)
{
	thread kineticpulse_playerconcuss(param_00);
	thread kineticpulse_playeremp(param_00);
	param_00 dodamage(1,param_01,self,self,"MOD_EXPLOSIVE","kineticpulse_mp");
}

//Function Number: 3
kineticpulse_playerconcuss(param_00)
{
	scripts\mp\_gamescore::func_11ACE(self,param_00,"kineticpulse_concuss_mp");
	var_01 = scripts\mp\perks\_perkfunctions::applystunresistence(self,param_00,5);
	param_00 shellshock("concussion_grenade_mp",var_01);
	param_00 scripts\engine\utility::waittill_any_timeout_no_endon_death_2(var_01,"death","disconnect");
	if(isdefined(param_00) && scripts\mp\_utility::isreallyalive(param_00))
	{
		if(isdefined(self))
		{
			scripts\mp\_gamescore::untrackdebuffassist(self,param_00,"kineticpulse_concuss_mp");
		}
	}
}

//Function Number: 4
kineticpulse_playeremp(param_00)
{
	if(!scripts\mp\killstreaks\_emp_common::func_FFC5())
	{
		scripts\mp\_damagefeedback::updatedamagefeedback("hiticonempimmune",undefined,undefined,undefined,1);
		return;
	}

	scripts\mp\_gamescore::func_11ACE(self,param_00,"kineticpulse_emp_mp");
	param_00 scripts\mp\killstreaks\_emp_common::func_20C3();
	param_00 scripts\engine\utility::waittill_any_timeout_no_endon_death_2(5,"death","disconnect");
	if(isdefined(param_00) && scripts\mp\_utility::isreallyalive(param_00))
	{
		if(isdefined(self))
		{
			scripts\mp\_gamescore::untrackdebuffassist(self,param_00,"kineticpulse_emp_mp");
		}

		param_00 scripts\mp\killstreaks\_emp_common::func_E0F3();
	}
}

//Function Number: 5
kineticpulse_nonplayereffects(param_00,param_01)
{
	param_00 notify("emp_damage",self,5,param_01,"kineticpulse_emp_mp","MOD_EXPLOSIVE");
}

//Function Number: 6
isplayertaggedbykineticpulse(param_00)
{
	var_01 = scripts\mp\_gamescore::getdebuffattackersbyweapon(param_00,"kineticpulse_concuss_mp");
	if(isdefined(var_01) && scripts\engine\utility::array_contains(var_01,self))
	{
		return 1;
	}

	var_01 = scripts\mp\_gamescore::getdebuffattackersbyweapon(param_00,"kineticpulse_emp_mp");
	if(isdefined(var_01) && scripts\engine\utility::array_contains(var_01,self))
	{
		return 1;
	}

	return 0;
}
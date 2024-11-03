/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: 3611.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 2 ms
 * Timestamp: 10/27/2023 12:30:54 AM
*******************************************************************/

//Function Number: 1
init()
{
	level._effect["visionPulse_ping"] = loadfx("vfx/iw7/_requests/mp/vfx_opticwave.vfx");
}

//Function Number: 2
func_12F9B()
{
	level thread scripts\mp\_battlechatter_mp::saytoself(self,"plr_perk_pulse",undefined,0.75);
	thread func_139A3();
	thread func_13450();
	return 1;
}

//Function Number: 3
func_139A3()
{
	if(!isdefined(self.var_13455))
	{
		self.var_13455 = [];
	}

	self visionsetnakedforplayer("opticwave_mp",0);
	self setscriptablepartstate("visionPulse","active",0);
	self.visionpulsevisionsetactive = 1;
	func_139A4();
	if(isdefined(self))
	{
		if(scripts\mp\_utility::isreallyalive(self))
		{
			self visionsetnakedforplayer("",0.5);
		}
		else
		{
			self visionsetnakedforplayer("",0);
		}

		self setscriptablepartstate("visionPulse","neutral",0);
		self.visionpulsevisionsetactive = undefined;
	}
}

//Function Number: 4
func_139A4()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	var_00 = self.origin;
	var_01 = anglestoforward(self.angles);
	var_02 = 1000;
	var_03 = gettime();
	var_04 = var_03 + var_02;
	while(gettime() <= var_04)
	{
		var_05 = 1 - var_04 - gettime() / var_02 * 4096;
		foreach(var_07 in level.characters)
		{
			if(func_13151(var_07,var_05,var_00,var_01))
			{
				var_07 thread func_13B9F(self);
			}
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 5
func_13B9F(param_00)
{
	var_01 = self getentitynumber();
	param_00.var_13455[var_01] = self;
	if(!isai(self))
	{
		scripts\mp\_utility::_hudoutlineviewmodelenable(5);
	}

	var_02 = scripts\mp\_utility::outlineenableforplayer(self,"orange",param_00,0,1,"killstreak_personal");
	func_13BA0(param_00,5);
	if(isdefined(self))
	{
		if(!isai(self))
		{
			scripts\mp\_utility::_hudoutlineviewmodeldisable();
		}
	}

	if(isdefined(param_00))
	{
		if(isdefined(param_00.var_13455))
		{
			param_00.var_13455[var_01] = undefined;
		}
	}

	scripts\mp\_utility::outlinedisable(var_02,self);
}

//Function Number: 6
func_13BA0(param_00,param_01)
{
	param_00 endon("death");
	param_00 endon("disconnect");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	var_02 = gettime() + param_01 * 1000;
	while(gettime() <= var_02)
	{
		if(scripts\mp\_utility::_hasperk("specialty_noscopeoutline"))
		{
			break;
		}

		if(scripts/mp/equipment/phase_shift::isentityphaseshifted(self))
		{
			break;
		}

		scripts\engine\utility::waitframe();
	}
}

//Function Number: 7
func_13151(param_00,param_01,param_02,param_03)
{
	if(!isdefined(param_00))
	{
		return 0;
	}

	if(param_00 == self)
	{
		return 0;
	}

	if(scripts\mp\_utility::func_9E05(self.team,param_00))
	{
		return 0;
	}

	if(func_9EF9(param_00))
	{
		return 0;
	}

	if(scripts/mp/equipment/phase_shift::isentityphaseshifted(param_00))
	{
		return 0;
	}

	if(!scripts\mp\_utility::isreallyalive(param_00))
	{
		return 0;
	}

	if(param_00 scripts\mp\_utility::_hasperk("specialty_noscopeoutline"))
	{
		return 0;
	}

	var_04 = param_00.origin - param_02 * (1,1,0);
	if(length2dsquared(var_04) > param_01 * param_01)
	{
		return 0;
	}

	return 1;
}

//Function Number: 8
func_9EF9(param_00)
{
	if(isdefined(self.var_13455))
	{
		return isdefined(self.var_13455[param_00 getentitynumber()]);
	}

	return 0;
}

//Function Number: 9
func_13450()
{
	var_00 = self geteye();
	var_01 = anglestoforward(self.angles);
	var_02 = var_00 + var_01 * 4096;
	var_03 = spawn("script_model",var_00);
	var_03.angles = self.angles;
	var_03 setmodel("tag_origin");
	wait(0.1);
	playfxontagforclients(scripts\engine\utility::getfx("visionPulse_ping"),var_03,"tag_origin",self);
	var_03 moveto(var_02,1);
	wait(1);
	var_03 delete();
}
/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\cqb.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 9
 * Decompile Time: 889 ms
 * Timestamp: 10\27\2023 12:00:30 AM
*******************************************************************/

//Function Number: 1
func_BCB1()
{
	scripts\anim\run::func_10B77();
	if(self.var_1491.pose != "stand")
	{
		self aiclearanim(%root,0.2);
		if(self.var_1491.pose == "prone")
		{
			scripts\anim\utility::exitpronewrapper(1);
		}

		self.var_1491.pose = "stand";
	}

	self.var_1491.movement = self.synctransients;
	func_479B();
	if(scripts\anim\run::func_BC1D())
	{
		return;
	}

	self aiclearanim(%stair_transitions,0.2);
	if(scripts\anim\run::func_10B78())
	{
		return;
	}

	if(isdefined(self.timeoflaststatechange))
	{
		var_00 = self.timeoflaststatechange;
	}
	else
	{
		var_00 = 0;
	}

	self.timeoflaststatechange = gettime();
	var_01 = func_53C3();
	if(self.getcsplinepointtargetname == "none")
	{
		var_02 = 0.3;
	}
	else
	{
		var_02 = 0.1;
	}

	var_03 = 0.2;
	var_04 = %walk_and_run_loops;
	if(self.timeoflaststatechange - var_00 > var_03 * 1000)
	{
		var_04 = %stand_and_crouch;
	}

	self _meth_82E3("runanim",var_01,var_04,1,var_02,self.moveplaybackrate,1);
	func_478E(var_01);
	scripts\anim\run::func_F7A9(scripts\anim\utility::func_B027("cqb","move_b"),scripts\anim\utility::func_B027("cqb","move_l"),scripts\anim\utility::func_B027("cqb","move_r"));
	thread scripts\anim\run::setcombatstandmoveanimweights("cqb");
	scripts\anim\notetracks::donotetracksfortime(var_03,"runanim");
}

//Function Number: 2
func_53C3()
{
	if(isdefined(self.custommoveanimset) && isdefined(self.custommoveanimset["cqb"]))
	{
		return scripts\anim\run::getrunningforwardpainanim();
	}

	if(self.getcsplinepointtargetname == "up")
	{
		return scripts\anim\utility::func_B027("cqb","stairs_up");
	}

	if(self.getcsplinepointtargetname == "down")
	{
		return scripts\anim\utility::func_B027("cqb","stairs_down");
	}

	if(self.synctransients == "walk")
	{
		return scripts\anim\utility::func_B027("cqb","move_f");
	}

	if(isdefined(self.var_1491.var_29CE) && self.var_1491.var_29CE)
	{
		return scripts\anim\utility::func_B027("cqb","straight");
	}

	var_00 = scripts\anim\utility::func_B027("cqb","straight_twitch");
	if(!isdefined(var_00) || var_00.size == 0)
	{
		return scripts\anim\utility::func_B027("cqb","straight");
	}

	var_01 = scripts\anim\utility::setclientextrasuper(self.var_1491.var_E860,4);
	if(var_01 == 0)
	{
		var_02 = scripts\anim\utility::setclientextrasuper(self.var_1491.var_E860,var_00.size);
		return var_00[var_02];
	}

	return scripts\anim\utility::func_B027("cqb","straight");
}

//Function Number: 3
func_4790()
{
	self endon("movemode");
	self orientmode("face motion");
	var_00 = "reload_" + scripts\anim\combat_utility::_meth_81EB();
	var_01 = scripts\anim\utility::func_B027("cqb","reload");
	if(isarray(var_01))
	{
		var_01 = var_01[randomint(var_01.size)];
	}

	self _meth_82E4(var_00,var_01,%body,1,0.25);
	func_478E(var_01);
	scripts\anim\run::func_F7A9(scripts\anim\utility::func_B027("cqb","move_b"),scripts\anim\utility::func_B027("cqb","move_l"),scripts\anim\utility::func_B027("cqb","move_r"));
	thread scripts\anim\run::setcombatstandmoveanimweights("cqb");
	scripts\anim\shared::donotetracks(var_00);
}

//Function Number: 4
func_479B()
{
	var_00 = self.getcsplinepointtargetname != "none";
	var_01 = !var_00 && scripts\anim\move::func_B4EC();
	scripts\anim\run::func_F843(var_01);
	if(var_00)
	{
		scripts\anim\run::func_6318();
		return;
	}

	thread scripts\anim\run::func_6A6B();
}

//Function Number: 5
func_FA9F()
{
	level.var_479A = [];
	var_00 = "cqb_point_of_interest";
	var_01 = getentarray(var_00,"targetname");
	foreach(var_03 in var_01)
	{
		level.var_479A[level.var_479A.size] = var_03.origin;
		var_03 delete();
	}

	thread func_FAA0(var_00);
}

//Function Number: 6
func_FAA0(param_00)
{
	waittillframeend;
	var_01 = scripts\common\utility::getstructarray(param_00,"targetname");
	foreach(var_03 in var_01)
	{
		level.var_479A[level.var_479A.size] = var_03.origin;
		scripts\sp\_utility::func_51D4(var_03);
	}
}

//Function Number: 7
func_6CB4()
{
	if(isdefined(level.var_6CB8))
	{
		return;
	}

	anim.var_6CB8 = 1;
	waittillframeend;
	if(!level.var_479A.size)
	{
		return;
	}

	for(;;)
	{
		var_00 = function_0072();
		var_01 = 0;
		foreach(var_03 in var_00)
		{
			if(isalive(var_03) && var_03 scripts\anim\utility::func_9D9B() && !isdefined(var_03.var_5512))
			{
				var_04 = var_03.var_1491.movement != "stop";
				var_05 = (var_03.origin[0],var_03.origin[1],var_03 getshootatpos()[2]);
				var_06 = var_05;
				var_07 = anglestoforward(var_03.angles);
				if(var_04)
				{
					var_08 = bullettrace(var_06,var_06 + var_07 * 128,0,undefined);
					var_06 = var_08["position"];
				}

				var_09 = -1;
				var_0A = 1048576;
				for(var_0B = 0;var_0B < level.var_479A.size;var_0B++)
				{
					var_0C = level.var_479A[var_0B];
					var_0D = distancesquared(var_0C,var_06);
					if(var_0D < var_0A)
					{
						if(var_04)
						{
							if(distancesquared(var_0C,var_05) < 4096)
							{
								continue;
							}

							var_0E = vectordot(vectornormalize(var_0C - var_05),var_07);
							if(var_0E < 0.643 || var_0E > 0.966)
							{
								continue;
							}
						}
						else if(var_0D < 2500)
						{
							continue;
						}

						if(!sighttracepassed(var_06,var_0C,0,undefined))
						{
							continue;
						}

						var_0A = var_0D;
						var_09 = var_0B;
					}
				}

				if(var_09 < 0)
				{
					var_03.var_478F = undefined;
				}
				else
				{
					var_03.var_478F = level.var_479A[var_09];
				}

				wait(0.05);
				var_01 = 1;
			}
		}

		if(!var_01)
		{
			wait(0.25);
		}
	}
}

//Function Number: 8
func_478E(param_00)
{
	self.facialidx = scripts\anim\face::playfacialanim(param_00,"run",self.facialidx);
}

//Function Number: 9
func_4789()
{
	self.facialidx = undefined;
	self aiclearanim(%head,0.2);
}
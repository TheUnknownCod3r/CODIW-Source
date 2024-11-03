/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\asm\shared_utility.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 32
 * Decompile Time: 1462 ms
 * Timestamp: 10\27\2023 12:26:20 AM
*******************************************************************/

//Function Number: 1
chooseanimshoot(param_00,param_01,param_02)
{
	var_03 = param_02;
	var_04 = self.var_1198.shootstate + "_" + var_03;
	if(isdefined(self.var_1198.shootstate) && scripts\asm\asm::asm_hasalias(param_01,var_04))
	{
		return scripts\asm\asm::asm_lookupanimfromalias(param_01,var_04);
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_01,param_02);
}

//Function Number: 2
choosedemeanoranimwithoverride(param_00,param_01,param_02)
{
	var_03 = scripts\asm\asm::asm_getdemeanor();
	if(scripts\asm\asm::asm_hasdemeanoranimoverride(var_03,param_02))
	{
		var_04 = scripts\asm\asm::asm_getdemeanoranimoverride(var_03,param_02);
		if(isarray(var_04))
		{
			return var_04[randomint(var_04.size)];
		}

		return var_04;
	}

	if(!scripts\asm\asm::asm_hasalias(param_02,var_04))
	{
		return scripts\asm\asm::asm_lookupanimfromalias(param_02,"default");
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_02,var_04);
}

//Function Number: 3
choosedemeanoranimwithoverridevariants(param_00,param_01,param_02)
{
	var_03 = scripts\asm\asm::asm_getdemeanor();
	if(scripts\asm\asm::asm_hasdemeanoranimoverride(var_03,param_02))
	{
		var_04 = scripts\asm\asm::asm_getdemeanoranimoverride(var_03,param_02);
		if(isarray(var_04))
		{
			return var_04[randomint(var_04.size)];
		}

		return var_04;
	}

	if(!scripts\asm\asm::asm_hasalias(param_02,var_04))
	{
		var_05 = [];
		var_05[0] = scripts\asm\asm::asm_lookupanimfromalias(param_02,"trans_to_one_hand_run");
		var_05[1] = scripts\asm\asm::asm_lookupanimfromalias(param_02,"one_hand_run");
		var_05[2] = scripts\asm\asm::asm_lookupanimfromalias(param_02,"trans_to_two_hand_run");
		var_05[3] = scripts\asm\asm::asm_lookupanimfromalias(param_02,"two_hand_run");
		return var_05;
	}

	return scripts\asm\asm::asm_lookupanimfromalias(var_03,var_05);
}

//Function Number: 4
func_3EAA(param_00,param_01,param_02)
{
	var_03 = weaponclass(self.var_394);
	if(!scripts\asm\asm::asm_hasalias(param_01,var_03))
	{
		var_03 = "rifle";
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_01,var_03);
}

//Function Number: 5
func_3E9A(param_00,param_01,param_02)
{
	var_03 = param_02;
	if(self.var_2303.var_FECD.var_FF0B == 1)
	{
		var_04 = "single";
	}
	else
	{
		var_04 = var_04 + self.var_2303.var_FECD.var_FF0B;
	}

	if(scripts\asm\asm::asm_hasalias(param_01,var_04))
	{
		var_05 = scripts\asm\asm::asm_lookupanimfromalias(param_01,var_04);
	}
	else
	{
		var_05 = scripts\asm\asm::asm_lookupanimfromalias(param_02,"fire");
	}

	return var_05;
}

//Function Number: 6
chooseanim_weaponswitch(param_00,param_01,param_02)
{
	if(weaponclass(self.var_394) == "rocketlauncher" && scripts\asm\asm::asm_hasalias(param_01,"drop_rpg"))
	{
		return scripts\asm\asm::asm_lookupanimfromalias(param_01,"drop_rpg");
	}

	var_03 = scripts\asm\asm_bb::bb_getrequestedweapon();
	if(!scripts\asm\asm::asm_hasalias(param_01,var_03))
	{
		var_03 = "rifle";
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_01,var_03);
}

//Function Number: 7
func_12668(param_00,param_01,param_02,param_03)
{
	return 1;
}

//Function Number: 8
func_2B58(param_00,param_01,param_02,param_03)
{
}

//Function Number: 9
func_BD25(param_00,param_01,param_02,param_03)
{
	return scripts\asm\asm::asm_getdemeanor() == param_03;
}

//Function Number: 10
func_BD26(param_00,param_01,param_02,param_03)
{
	return scripts\asm\asm::asm_getdemeanor() != param_03;
}

//Function Number: 11
func_BD28(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\asm\asm::asm_getdemeanor();
	return var_04 != "frantic" && var_04 != "combat" && var_04 != "sprint";
}

//Function Number: 12
movetypeisnotcasual(param_00,param_01,param_02,param_03)
{
	var_04 = scripts\asm\asm::asm_getdemeanor();
	return var_04 != "casual" && var_04 != "casual_gun";
}

//Function Number: 13
getnodeforwardyawnodetypelookupoverride(param_00,param_01)
{
	switch(param_01)
	{
		case "stand":
		case "crouch":
		case "prone":
			break;

		default:
			return param_01;
	}

	switch(param_00)
	{
		case "Cover Left":
			if(param_01 == "crouch")
			{
				return "Cover Left Crouch";
			}
			break;

		case "Cover Right":
			if(param_01 == "crouch")
			{
				return "Cover Right Crouch";
			}
			break;

		case "Conceal Crouch":
		case "Cover Crouch Window":
			return "Cover Crouch";

		case "Conceal Stand":
			return "Cover Stand";
	}

	return undefined;
}

//Function Number: 14
getnodeyawfromoffsettable(param_00,param_01,param_02)
{
	var_03 = self.var_1491.pose;
	if(isdefined(param_02))
	{
		var_03 = param_02;
	}
	else if(function_02A7(param_01) && !param_01 getrandomattachments(var_03))
	{
		var_03 = param_01 gethighestnodestance();
	}

	var_04 = getnodeforwardyawnodetypelookupoverride(param_01.type,var_03);
	if(isdefined(var_04) && isdefined(param_00[var_04]))
	{
		return param_00[var_04];
	}

	if(isdefined(param_00[param_01.type]))
	{
		return param_00[param_01.type];
	}

	return undefined;
}

//Function Number: 15
func_1C9C()
{
	var_00 = scripts\common\utility::weaponclass(self.var_394) == "mg";
	return var_00 || isdefined(self.var_1198.var_522F) && isdefined(self.target_getindexoftarget) && self.target_getindexoftarget == self.var_1198.var_522F;
}

//Function Number: 16
getnodeyawoffset(param_00,param_01)
{
	if(function_02A4(param_00) || !isdefined(param_00.type))
	{
		return 0;
	}

	if(getdvarint("ai_iw7",0) == 1)
	{
		if((isdefined(self.var_1198.var_98F4) && self.var_1198.var_98F4) || isdefined(self.var_2303.var_1310E) && self.var_2303.var_1310E)
		{
			return 0;
		}

		if(self.var_2303.var_7360 && isdefined(level.var_7365) && isdefined(level.var_7365[self.asmname]))
		{
			var_02 = getnodeyawfromoffsettable(level.var_7365[self.asmname],param_00,param_01);
			if(isdefined(var_02))
			{
				return var_02;
			}

			return 0;
		}
		else if(isdefined(level.var_C05A) && isdefined(level.var_C05A[self.asmname]))
		{
			var_02 = getnodeyawfromoffsettable(level.var_C05A[self.asmname],param_01,var_02);
			if(isdefined(var_02))
			{
				return var_02;
			}

			return 0;
		}
	}

	if(!isdefined(self.heat))
	{
		if(scripts\common\utility::isnodecoverleft(param_01))
		{
			return 90;
		}
		else if(scripts\common\utility::isnodecoverright(param_01))
		{
			return -90;
		}
	}

	return 0;
}

//Function Number: 17
_meth_812E(param_00,param_01)
{
	if(!isdefined(param_00.angles))
	{
		return 0;
	}

	var_02 = param_00.type;
	if(function_02A7(param_00) && !param_00 getrandomattachments("stand") && !isdefined(param_01))
	{
		switch(var_02)
		{
			case "Cover Left":
				param_01 = "crouch";
				break;

			case "Cover Right":
				param_01 = "crouch";
				break;
		}
	}

	var_03 = getnodeyawoffset(param_00,param_01);
	if(param_00.type == "Cover Left")
	{
		if(self.asmname == "soldier")
		{
			var_03 = var_03 + 45;
		}
	}

	return var_03;
}

//Function Number: 18
getnodeforwardyaw(param_00,param_01)
{
	var_02 = getnodeyawoffset(param_00,param_01);
	return param_00.angles[1] + var_02;
}

//Function Number: 19
gethighestnodestance(param_00,param_01)
{
	var_02 = _meth_812E(param_00,param_01);
	return param_00.angles[1] + var_02;
}

//Function Number: 20
getnodeforwardangles(param_00,param_01)
{
	var_02 = getnodeyawoffset(param_00,param_01);
	return combineangles(param_00.angles,(0,var_02,0));
}

//Function Number: 21
func_7FF1(param_00,param_01,param_02)
{
	var_03 = undefined;
	if(param_02 == "exposed")
	{
		var_03 = level.var_C046[param_00];
	}
	else if(param_02 == "lean" || param_02 == "leanover")
	{
		var_03 = level.var_C04D[param_00];
	}

	if(isdefined(var_03))
	{
		var_04 = getnodeyawfromoffsettable(var_03,param_01,undefined);
		if(isdefined(var_04))
		{
			return var_04;
		}
	}

	return 0;
}

//Function Number: 22
func_7FF2(param_00,param_01,param_02)
{
	var_03 = undefined;
	if(self.var_2303.var_7360)
	{
		if(param_02 == "lean")
		{
			var_03 = level.var_7364[param_00];
		}
		else if(param_02 == "A" || param_02 == "full" || param_02 == "right" || param_02 == "left")
		{
			var_03 = level.var_7363[param_00];
		}
	}
	else if(param_02 == "lean")
	{
		var_03 = level.var_C04E[param_00];
	}

	if(isdefined(var_03))
	{
		var_04 = getnodeyawfromoffsettable(var_03,param_01,undefined);
		if(isdefined(var_04))
		{
			return var_04;
		}
	}

	return 0;
}

//Function Number: 23
func_C04B(param_00)
{
	if(param_00.type == "Cover Stand 3D")
	{
		return !func_C04A(param_00);
	}

	return 0;
}

//Function Number: 24
func_C04A(param_00)
{
	if(param_00.type == "Cover Stand 3D")
	{
		if(isdefined(param_00.script_parameters) && param_00.script_parameters == "exposed")
		{
			return 1;
		}
	}

	return 0;
}

//Function Number: 25
getnodetypename(param_00)
{
	if(isdefined(param_00))
	{
		if(func_C04A(param_00))
		{
			return "Cover Exposed 3D";
		}
		else
		{
			return param_00.type;
		}
	}

	return "undefined";
}

//Function Number: 26
choosestrongdamagedeath(param_00,param_01,param_02)
{
	var_03 = undefined;
	if(abs(self.var_E3) > 150)
	{
		if(scripts\common\utility::damagelocationisany("left_leg_upper","left_leg_lower","right_leg_upper","right_leg_lower","left_foot","right_foot"))
		{
			var_03 = "legs";
		}
		else if(self.var_DD == "torso_lower")
		{
			var_03 = "torso_lower";
		}
		else
		{
			var_03 = "default";
		}
	}
	else if(self.var_E3 < 0)
	{
		var_03 = "right";
	}
	else
	{
		var_03 = "left";
	}

	return scripts\asm\asm::asm_lookupanimfromalias(param_01,var_03);
}

//Function Number: 27
isatcovernode()
{
	return isdefined(scripts\asm\asm_bb::bb_getcovernode());
}

//Function Number: 28
func_93DE(param_00,param_01,param_02,param_03)
{
	return !isdefined(scripts\asm\asm_bb::bb_getcovernode());
}

//Function Number: 29
func_C17A(param_00,param_01,param_02,param_03)
{
	return !isdefined(scripts\asm\asm_bb::bb_getcovernode());
}

//Function Number: 30
setuseanimgoalweight(param_00,param_01)
{
	self endon(param_00 + "_finished");
	self.var_36A = 1;
	thread setuseanimgoalweight_wait(param_00);
	if(param_01 > 0)
	{
		wait(param_01);
	}

	self.var_36A = 0;
	self notify("StopUseAnimGoalWeight");
}

//Function Number: 31
setuseanimgoalweight_wait(param_00)
{
	self notify("StopUseAnimGoalWeight");
	self endon("StopUseAnimGoalWeight");
	self endon("death");
	self endon("entitydeleted");
	self waittill(param_00 + "_finished");
	self.var_36A = 0;
}

//Function Number: 32
randomizepassthroughchildren(param_00,param_01,param_02,param_03)
{
	var_04 = level.asm[param_00].states[param_02];
	if(isdefined(var_04.transitions))
	{
		if(var_04.var_1267B.size == 2)
		{
			if(scripts\common\utility::cointoss())
			{
				var_05 = var_04.transitions[0];
				var_04.transitions[0] = var_04.transitions[1];
				var_04.transitions[1] = var_05;
			}
		}
		else
		{
			var_04.transitions = scripts\common\utility::array_randomize(var_04.transitions);
		}
	}

	return 1;
}
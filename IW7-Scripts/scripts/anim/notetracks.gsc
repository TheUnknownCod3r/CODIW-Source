/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\anim\notetracks.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 91
 * Decompile Time: 4777 ms
 * Timestamp: 10\27\2023 12:00:47 AM
*******************************************************************/

//Function Number: 1
registernotetracks_init()
{
	if(isdefined(level.notetracks))
	{
		return;
	}

	anim.notetracks = [];
	registernotetracks();
}

//Function Number: 2
registernotetracks()
{
	level.notetracks["anim_pose = \"stand\"] = ::notetrackposestand;
	level.notetracks["anim_pose = \"crouch\"] = ::notetrackposecrouch;
	level.notetracks["anim_pose = \"prone\"] = ::notetrackposeprone;
	level.notetracks["anim_pose = \"crawl\"] = ::notetrackposecrawl;
	level.notetracks["anim_pose = \"back\"] = ::notetrackposeback;
	level.notetracks["anim_movement = \"stop\"] = ::notetrackmovementstop;
	level.notetracks["anim_movement = \"walk\"] = ::notetrackmovementwalk;
	level.notetracks["anim_movement = \"run\"] = ::notetrackmovementrun;
	level.notetracks["anim_gunhand = \"left\"] = ::notetrackgunhand;
	level.notetracks["anim_gunhand = \"right\"] = ::notetrackgunhand;
	level.notetracks["anim_gunhand = \"none\"] = ::notetrackgunhand;
	level.notetracks["anim_pose = stand"] = ::notetrackposestand;
	level.notetracks["anim_pose = crouch"] = ::notetrackposecrouch;
	level.notetracks["anim_pose = prone"] = ::notetrackposeprone;
	level.notetracks["anim_pose = crawl"] = ::notetrackposecrawl;
	level.notetracks["anim_pose = back"] = ::notetrackposeback;
	level.notetracks["anim_movement = stop"] = ::notetrackmovementstop;
	level.notetracks["anim_movement = walk"] = ::notetrackmovementwalk;
	level.notetracks["anim_movement = run"] = ::notetrackmovementrun;
	level.notetracks["anim_movement_gun_pose_override = run_gun_down"] = ::notetrackmovementgunposeoverride;
	level.notetracks["anim_aiming = 1"] = ::notetrackalertnessaiming;
	level.notetracks["anim_aiming = 0"] = ::notetrackalertnessalert;
	level.notetracks["anim_alertness = causal"] = ::notetrackalertnesscasual;
	level.notetracks["anim_alertness = alert"] = ::notetrackalertnessalert;
	level.notetracks["anim_alertness = aiming"] = ::notetrackalertnessaiming;
	level.notetracks["gunhand = (gunhand)_left"] = ::notetrackgunhand;
	level.notetracks["anim_gunhand = left"] = ::notetrackgunhand;
	level.notetracks["gunhand = (gunhand)_right"] = ::notetrackgunhand;
	level.notetracks["anim_gunhand = right"] = ::notetrackgunhand;
	level.notetracks["anim_gunhand = none"] = ::notetrackgunhand;
	level.notetracks["gun drop"] = ::notetrackgundrop;
	level.notetracks["dropgun"] = ::notetrackgundrop;
	level.notetracks["gun_2_chest"] = ::notetrackguntochest;
	level.notetracks["gun_2_back"] = ::notetrackguntoback;
	level.notetracks["pistol_pickup"] = ::notetrackpistolpickup;
	level.notetracks["pistol_putaway"] = ::notetrackpistolputaway;
	level.notetracks["drop clip"] = ::notetrackdropclip;
	level.notetracks["refill clip"] = ::notetrackrefillclip;
	level.notetracks["reload done"] = ::notetrackrefillclip;
	level.notetracks["load_shell"] = ::notetrackloadshell;
	level.notetracks["pistol_rechamber"] = ::notetrackpistolrechamber;
	level.notetracks["gravity on"] = ::notetrackgravity;
	level.notetracks["gravity off"] = ::notetrackgravity;
	level.notetracks["footstep_right_large"] = ::notetrackfootstep;
	level.notetracks["footstep_right_small"] = ::notetrackfootstep;
	level.notetracks["footstep_left_large"] = ::notetrackfootstep;
	level.notetracks["footstep_left_small"] = ::notetrackfootstep;
	level.notetracks["handstep_left"] = ::notetrackhandstep;
	level.notetracks["handstep_right"] = ::notetrackhandstep;
	level.notetracks["footscrape"] = ::notetrackfootscrape;
	level.notetracks["land"] = ::notetrackland;
	level.notetracks["bodyfall large"] = ::notetrackbodyfall;
	level.notetracks["bodyfall small"] = ::notetrackbodyfall;
	level.notetracks["code_move"] = ::notetrackcodemove;
	level.notetracks["face_enemy"] = ::notetrackfaceenemy;
	level.notetracks["laser_on"] = ::notetracklaser;
	level.notetracks["laser_off"] = ::notetracklaser;
	level.notetracks["start_ragdoll"] = ::notetrackstartragdoll;
	level.notetracks["ragdollblendinit"] = ::notetrackragdollblendinit;
	level.notetracks["ragdollblendstart"] = ::notetrackragdollblendstart;
	level.notetracks["ragdollblendend"] = ::notetrackragdollblendend;
	level.notetracks["ragdollblendrootanim"] = ::notetrackragdollblendrootanim;
	level.notetracks["ragdollblendrootragdoll"] = ::notetrackragdollblendrootragdoll;
	level.notetracks["fire"] = ::notetrackfire;
	level.notetracks["fire_spray"] = ::notetrackfirespray;
	level.notetracks["bloodpool"] = ::scripts\anim\death::play_blood_pool;
	level.notetracks["space_jet_top"] = ::notetrackspacejet;
	level.notetracks["space_jet_top_1"] = ::notetrackspacejet;
	level.notetracks["space_jet_top_2"] = ::notetrackspacejet;
	level.notetracks["space_jet_bottom"] = ::notetrackspacejet;
	level.notetracks["space_jet_bottom_1"] = ::notetrackspacejet;
	level.notetracks["space_jet_bottom_2"] = ::notetrackspacejet;
	level.notetracks["space_jet_left"] = ::notetrackspacejet;
	level.notetracks["space_jet_left_1"] = ::notetrackspacejet;
	level.notetracks["space_jet_left_2"] = ::notetrackspacejet;
	level.notetracks["space_jet_right"] = ::notetrackspacejet;
	level.notetracks["space_jet_right_1"] = ::notetrackspacejet;
	level.notetracks["space_jet_right_2"] = ::notetrackspacejet;
	level.notetracks["space_jet_front"] = ::notetrackspacejet;
	level.notetracks["space_jet_front_1"] = ::notetrackspacejet;
	level.notetracks["space_jet_front_2"] = ::notetrackspacejet;
	level.notetracks["space_jet_back"] = ::notetrackspacejet;
	level.notetracks["space_jet_back_1"] = ::notetrackspacejet;
	level.notetracks["space_jet_back_2"] = ::notetrackspacejet;
	level.notetracks["space_jet_back_3"] = ::notetrackspacejet;
	level.notetracks["space_jet_back_4"] = ::notetrackspacejet;
	level.notetracks["space_jet_random"] = ::notetrackspacejet;
	level.notetracks["fingers_out_start_left_hand"] = ::notetrackfingerposeoffleft;
	level.notetracks["fingers_out_start_right_hand"] = ::notetrackfingerposeoffright;
	level.notetracks["fingers_in_start_left_hand"] = ::notetrackfingerposeonleft;
	level.notetracks["fingers_in_start_right_hand"] = ::notetrackfingerposeonright;
	level.notetracks["anim_facial = idle"] = ::notetrackfacialidle;
	level.notetracks["anim_facial = run"] = ::notetrackfacialrun;
	level.notetracks["anim_facial = pain"] = ::notetrackfacialpain;
	level.notetracks["anim_facial = death"] = ::notetrackfacialdeath;
	level.notetracks["anim_facial = talk"] = ::notetrackfacialtalk;
	level.notetracks["anim_facial = cheer"] = ::notetrackfacialcheer;
	level.notetracks["anim_facial = happy"] = ::notetrackfacialhappy;
	level.notetracks["anim_facial = angry"] = ::notetrackfacialangry;
	level.notetracks["anim_facial = scared"] = ::notetrackfacialscared;
	level.notetracks["visor_raise"] = ::notetrackvisorraise;
	level.notetracks["visor_lower"] = ::notetrackvisorlower;
	level.notetracks["c12_death_dying"] = ::func_3538;
	level.notetracks["c12_death_bodyfall"] = ::func_3537;
	if(isdefined(level._notetrackfx))
	{
		var_00 = getarraykeys(level._notetrackfx);
		foreach(var_02 in var_00)
		{
			level.notetracks[var_02] = ::customnotetrackfx;
		}
	}
}

//Function Number: 3
func_3538(param_00,param_01)
{
	if(soundexists("generic_death_c12"))
	{
		self playsound("generic_death_c12");
	}
}

//Function Number: 4
func_3537(param_00,param_01)
{
	if(soundexists("c12_death_generic_bf"))
	{
		self playsound("c12_death_generic_bf");
	}
}

//Function Number: 5
notetrackfire(param_00,param_01)
{
	if(isdefined(level.fire_notetrack_functions[self.script]))
	{
		thread [[ level.fire_notetrack_functions[self.script] ]]();
		return;
	}

	thread shootnotetrack();
}

//Function Number: 6
shootnotetrack()
{
	waittillframeend;
	if(isdefined(self) && gettime() > self.var_1491.var_A9ED)
	{
		if(isdefined(self.var_2303.shootparams))
		{
			var_00 = self.var_2303.var_FECD.var_FF0B == 1;
		}
		else
		{
			var_00 = 1;
		}

		scripts\anim\utility_common::shootenemywrapper(var_00);
		scripts\anim\combat_utility::decrementbulletsinclip();
		if(weaponclass(self.var_394) == "rocketlauncher")
		{
			self.var_1491.var_E5DE--;
		}
	}
}

//Function Number: 7
notetracklaser(param_00,param_01)
{
	if(issubstr(param_00,"on"))
	{
		self.var_1491.laseron = 1;
	}
	else
	{
		self.var_1491.laseron = 0;
	}

	scripts\anim\shared::updatelaserstatus();
}

//Function Number: 8
notetrackstopanim(param_00,param_01)
{
}

//Function Number: 9
unlinknextframe()
{
	wait(0.1);
	if(isdefined(self))
	{
		self unlink();
	}
}

//Function Number: 10
notetrackstartragdoll(param_00,param_01)
{
	if(isdefined(self.noragdoll))
	{
		return;
	}

	if(isdefined(self.ragdolltime))
	{
		return;
	}

	if(!isdefined(self.dont_unlink_ragdoll))
	{
		thread unlinknextframe();
	}

	if(isdefined(self._blackboard))
	{
		if(isdefined(self.var_1198.var_26C6) && self.var_1198.var_26C6 == 1)
		{
			scripts\anim\shared::func_5D19();
			self.lastweapon = self.var_394;
		}
	}

	if(isdefined(self.var_71C8))
	{
		self [[ self.var_71C8 ]]();
	}

	if(isdefined(self))
	{
		self giverankxp();
	}
}

//Function Number: 11
notetrackragdollblendinit(param_00,param_01)
{
	if(isdefined(self.noragdoll))
	{
		return;
	}

	if(isdefined(self.ragdolltime))
	{
		return;
	}

	if(!isdefined(self.dont_unlink_ragdoll))
	{
		thread unlinknextframe();
	}

	if(isdefined(self._blackboard))
	{
		if(isdefined(self.var_1198.var_26C6) && self.var_1198.var_26C6 == 1)
		{
			scripts\anim\shared::func_5D19();
			self.lastweapon = self.var_394;
		}
	}

	if(isdefined(self.var_71C8))
	{
		self [[ self.var_71C8 ]]();
	}

	self _meth_8576();
}

//Function Number: 12
notetrackragdollblendstart(param_00,param_01)
{
}

//Function Number: 13
notetrackragdollblendend(param_00,param_01)
{
}

//Function Number: 14
notetrackragdollblendrootanim(param_00,param_01)
{
}

//Function Number: 15
notetrackragdollblendrootragdoll(param_00,param_01)
{
}

//Function Number: 16
notetrackmovementstop(param_00,param_01)
{
	self.var_1491.movement = "stop";
}

//Function Number: 17
notetrackmovementwalk(param_00,param_01)
{
	self.var_1491.movement = "walk";
}

//Function Number: 18
notetrackmovementrun(param_00,param_01)
{
	self.var_1491.movement = "run";
}

//Function Number: 19
notetrackmovementgunposeoverride(param_00,param_01)
{
	self.var_2303.movementgunposeoverride = "run_gun_down";
}

//Function Number: 20
notetrackalertnessaiming(param_00,param_01)
{
}

//Function Number: 21
notetrackalertnesscasual(param_00,param_01)
{
}

//Function Number: 22
notetrackalertnessalert(param_00,param_01)
{
}

//Function Number: 23
stoponback()
{
	scripts\anim\utility::exitpronewrapper(1);
	self.var_1491.onback = undefined;
}

//Function Number: 24
setpose(param_00)
{
	self.var_1491.pose = param_00;
	if(isdefined(self.var_1491.onback))
	{
		stoponback();
	}

	scripts\asm\asm_bb::bb_requestsmartobject(param_00);
	self notify("entered_pose" + param_00);
}

//Function Number: 25
notetrackposestand(param_00,param_01)
{
	if(self.var_1491.pose == "prone")
	{
		scripts\anim\utility::exitpronewrapper(1);
	}

	setpose("stand");
}

//Function Number: 26
notetrackposecrouch(param_00,param_01)
{
	if(self.var_1491.pose == "prone")
	{
		scripts\anim\utility::exitpronewrapper(1);
	}

	setpose("crouch");
}

//Function Number: 27
notetrackposeprone(param_00,param_01)
{
	if(!issentient(self))
	{
		return;
	}

	self give_run_perk(-45,45,%prone_legs_down,%exposed_aiming,%prone_legs_up);
	scripts\anim\utility::enterpronewrapper(1);
	setpose("prone");
	if(isdefined(self.var_1491._meth_8445))
	{
		self.var_1491.proneaiming = 1;
		return;
	}

	self.var_1491.proneaiming = undefined;
}

//Function Number: 28
notetrackposecrawl(param_00,param_01)
{
	if(!issentient(self))
	{
		return;
	}

	self give_run_perk(-45,45,%prone_legs_down,%exposed_aiming,%prone_legs_up);
	scripts\anim\utility::enterpronewrapper(1);
	setpose("prone");
	self.var_1491.proneaiming = undefined;
}

//Function Number: 29
notetrackposeback(param_00,param_01)
{
	if(!issentient(self))
	{
		return;
	}

	setpose("crouch");
	self.var_1491.onback = 1;
	self.var_1491.movement = "stop";
	self give_run_perk(-90,90,%prone_legs_down,%exposed_aiming,%prone_legs_up);
	scripts\anim\utility::enterpronewrapper(1);
}

//Function Number: 30
notetrackgunhand(param_00,param_01)
{
	if(issubstr(param_00,"left"))
	{
		scripts\anim\shared::placeweaponon(self.var_394,"left");
		self notify("weapon_switch_done");
		return;
	}

	if(issubstr(param_00,"right"))
	{
		scripts\anim\shared::placeweaponon(self.var_394,"right");
		self notify("weapon_switch_done");
		return;
	}

	if(issubstr(param_00,"none"))
	{
		scripts\anim\shared::placeweaponon(self.var_394,"none");
		return;
	}
}

//Function Number: 31
notetrackgundrop(param_00,param_01)
{
	scripts\anim\shared::func_5D19();
	self.var_1198.var_26C6 = 0;
	self.lastweapon = self.var_394;
}

//Function Number: 32
notetrackguntochest(param_00,param_01)
{
	scripts\anim\shared::placeweaponon(self.var_394,"chest");
}

//Function Number: 33
notetrackguntoback(param_00,param_01)
{
	scripts\anim\shared::placeweaponon(self.var_394,"back");
	self.var_394 = scripts\anim\utility::detachall();
	self.bulletsinclip = weaponclipsize(self.var_394);
}

//Function Number: 34
notetrackpistolpickup(param_00,param_01)
{
	scripts\anim\shared::placeweaponon(self.var_101B4,"right");
	self.bulletsinclip = weaponclipsize(self.var_394);
	self notify("weapon_switch_done");
}

//Function Number: 35
notetrackpistolputaway(param_00,param_01)
{
	if(isdefined(self.var_110CB))
	{
		scripts\anim\shared::placeweaponon(self.var_394,"thigh");
	}
	else
	{
		scripts\anim\shared::placeweaponon(self.var_394,"none");
	}

	self.var_394 = scripts\anim\utility::detachall();
	self.bulletsinclip = weaponclipsize(self.var_394);
}

//Function Number: 36
notetrackdropclip(param_00,param_01)
{
	thread scripts\anim\shared::handledropclip(param_01);
}

//Function Number: 37
notetrackrefillclip(param_00,param_01)
{
	scripts\anim\weaponlist::refillclip();
	self.var_1491.needstorechamber = 0;
}

//Function Number: 38
notetrackloadshell(param_00,param_01)
{
	self playsound("weap_reload_shotgun_loop_npc");
}

//Function Number: 39
notetrackpistolrechamber(param_00,param_01)
{
	self playsound("weap_reload_pistol_chamber_npc");
}

//Function Number: 40
notetrackgravity(param_00,param_01)
{
	if(issubstr(param_00,"on"))
	{
		self animmode("gravity");
		return;
	}

	if(issubstr(param_00,"off"))
	{
		self animmode("nogravity");
	}
}

//Function Number: 41
notetrackfootstep(param_00,param_01)
{
	var_02 = issubstr(param_00,"left");
	var_03 = issubstr(param_00,"large");
	var_04 = "right";
	if(var_02)
	{
		var_04 = "left";
	}

	if(isai(self))
	{
		self.var_2303.var_7257.foot = var_04;
		self.var_2303.var_7257.time = gettime();
	}

	if(scripts\asm\asm_bb::ispartdismembered("left_leg") || scripts\asm\asm_bb::ispartdismembered("right_leg"))
	{
		return;
	}

	playfootstep(var_02,var_03);
	var_05 = get_notetrack_movement();
	if(isdefined(self.classname) && self.classname != "script_model")
	{
		self _meth_8584(var_05);
		if(isdefined(self.var_394))
		{
			var_06 = self _meth_8583(var_05,self.var_394);
		}
	}
}

//Function Number: 42
notetrackhandstep(param_00,param_01)
{
	var_02 = issubstr(param_00,"left");
	var_03 = issubstr(param_00,"large");
	var_04 = "right";
	if(var_02)
	{
		var_04 = "left";
	}

	if(isai(self))
	{
		self.var_2303.var_7257.foot = var_04;
		self.var_2303.var_7257.time = gettime();
	}

	func_D492(var_02,var_03);
}

//Function Number: 43
get_notetrack_movement()
{
	var_00 = "run";
	if(isdefined(self.var_10AB7))
	{
		var_00 = "sprint";
	}

	if(isdefined(self._blackboard))
	{
		if(self.var_1198.movetype == "walk" || self.var_1198.movetype == "casual_gun" || self.var_1198.movetype == "patrol" || self.var_1198.movetype == "casual")
		{
			var_00 = "walk";
		}

		if(scripts\asm\asm_bb::func_292C() == "prone")
		{
			var_00 = "prone";
		}
	}
	else if(isdefined(self.a))
	{
		if(isdefined(self.var_1491.movement))
		{
			if(self.var_1491.movement == "walk")
			{
				var_00 = "walk";
			}
		}

		if(isdefined(self.var_1491.pose))
		{
			if(self.var_1491.pose == "prone")
			{
				var_00 = "prone";
			}
		}
	}

	return var_00;
}

//Function Number: 44
notetrackspacejet(param_00,param_01)
{
	thread notetrackspacejet_proc(param_00,param_01);
}

//Function Number: 45
notetrackspacejet_proc(param_00,param_01)
{
	self endon("death");
	var_02 = [];
	var_03 = undefined;
	switch(param_00)
	{
		case "space_jet_bottom":
			var_02 = ["tag_jet_bottom_1","tag_jet_bottom_2"];
			break;

		case "space_jet_bottom_1":
			var_02 = ["tag_jet_bottom_1"];
			break;

		case "space_jet_bottom_2":
			var_02 = ["tag_jet_bottom_2"];
			break;

		case "space_jet_top":
			var_02 = ["tag_jet_top_1","tag_jet_top_2"];
			break;

		case "space_jet_top_1":
			var_02 = ["tag_jet_top_1"];
			break;

		case "space_jet_top_2":
			var_02 = ["tag_jet_top_2"];
			break;

		case "space_jet_left":
			var_02 = ["tag_jet_le_1","tag_jet_le_2"];
			break;

		case "space_jet_left_1":
			var_02 = ["tag_jet_le_1"];
			break;

		case "space_jet_left_2":
			var_02 = ["tag_jet_le_2"];
			break;

		case "space_jet_right":
			var_02 = ["tag_jet_ri_1","tag_jet_ri_2"];
			break;

		case "space_jet_right_1":
			var_02 = ["tag_jet_ri_1"];
			break;

		case "space_jet_right_2":
			var_02 = ["tag_jet_ri_2"];
			break;

		case "space_jet_front":
			var_02 = ["tag_jet_front_1","tag_jet_front_2"];
			break;

		case "space_jet_front_1":
			var_02 = ["tag_jet_front_1"];
			break;

		case "space_jet_front_2":
			var_02 = ["tag_jet_front_2"];
			break;

		case "space_jet_back":
			var_02 = ["tag_jet_back_1","tag_jet_back_2","tag_jet_back_3","tag_jet_back_4"];
			break;

		case "space_jet_back_1":
			var_02 = ["tag_jet_back_1"];
			break;

		case "space_jet_back_2":
			var_02 = ["tag_jet_back_2"];
			break;

		case "space_jet_back_3":
			var_02 = ["tag_jet_back_3"];
			break;

		case "space_jet_back_4":
			var_02 = ["tag_jet_back_4"];
			break;

		case "space_jet_random":
			var_02 = ["tag_jet_bottom_1","tag_jet_bottom_2","tag_jet_top_1","tag_jet_top_2","tag_jet_le_1","tag_jet_le_2","tag_jet_ri_1","tag_jet_ri_2"];
			break;
	}

	if(scripts\common\utility::fxexists("space_jet_small") && isdefined(var_02))
	{
		if(isdefined(var_02))
		{
			if(param_00 == "space_jet_random")
			{
				for(var_04 = 0;var_04 < 6;var_04++)
				{
					var_05 = randomint(8);
					var_06 = var_02[var_05];
					if(scripts\sp\_utility::hastag(self.model,var_06))
					{
						if(!isdefined(self.var_25C8))
						{
							self.var_25C8 = 0;
						}

						self.var_25C8++;
						if(self.var_25C8 > 5)
						{
							self.var_25C8 = 0;
						}

						if(self.var_25C8 == 1)
						{
							self playsound("space_npc_jetpack_boost_ss");
						}

						playfxontag(level._effect["space_jet_small"],self,var_06);
					}

					wait(randomfloatrange(0.1,0.3));
				}

				return;
			}

			foreach(var_06 in var_03)
			{
				if(isdefined(var_06) && scripts\sp\_utility::hastag(self.model,var_06))
				{
					if(!isdefined(self.var_25C8))
					{
						self.var_25C8 = 0;
					}

					self.var_25C8++;
					if(self.var_25C8 > 5)
					{
						self.var_25C8 = 0;
					}

					if(self.var_25C8 == 1)
					{
						self playsound("space_npc_jetpack_boost_ss");
					}

					playfxontag(level._effect["space_jet_small"],self,var_06);
					wait(0.1);
				}
			}

			return;
		}
	}
}

//Function Number: 46
notetrackvisorraise(param_00,param_01)
{
	if(!isai(self))
	{
		return;
	}

	self.var_2303.var_DC48 = 1;
	lib_0A1E::func_236E();
}

//Function Number: 47
notetrackvisorlower(param_00,param_01)
{
	if(!isai(self))
	{
		return;
	}

	self.var_2303.var_DC48 = 0;
	lib_0A1E::func_236E();
}

//Function Number: 48
notetrackfingerposeoffleft(param_00,param_01)
{
	lib_0A1E::func_2319("left");
}

//Function Number: 49
notetrackfingerposeonleft(param_00,param_01)
{
	lib_0A1E::func_234C("left");
}

//Function Number: 50
notetrackfingerposeoffright(param_00,param_01)
{
	lib_0A1E::func_2319("left");
}

//Function Number: 51
notetrackfingerposeonright(param_00,param_01)
{
	lib_0A1E::func_234C("right");
}

//Function Number: 52
notetrackfacialidle(param_00,param_01)
{
	lib_0A1E::func_236A("facial_idle");
}

//Function Number: 53
notetrackfacialrun(param_00,param_01)
{
	lib_0A1E::func_236A("facial_run");
}

//Function Number: 54
notetrackfacialpain(param_00,param_01)
{
	lib_0A1E::func_236A("facial_pain");
}

//Function Number: 55
notetrackfacialdeath(param_00,param_01)
{
	lib_0A1E::func_236A("facial_death");
}

//Function Number: 56
notetrackfacialtalk(param_00,param_01)
{
	lib_0A1E::func_236A("facial_talk");
}

//Function Number: 57
notetrackfacialcheer(param_00,param_01)
{
	lib_0A1E::func_236A("facial_cheer");
}

//Function Number: 58
notetrackfacialhappy(param_00,param_01)
{
	lib_0A1E::func_236A("facial_happy");
}

//Function Number: 59
notetrackfacialscared(param_00,param_01)
{
	lib_0A1E::func_236A("facial_scared");
}

//Function Number: 60
notetrackfacialangry(param_00,param_01)
{
	lib_0A1E::func_236A("facial_angry");
}

//Function Number: 61
customnotetrackfx(param_00,param_01)
{
	if(isdefined(self.pausemayhem))
	{
		var_02 = self.pausemayhem;
	}
	else
	{
		var_02 = "dirt";
	}

	var_03 = undefined;
	if(isdefined(level._notetrackfx[param_00][var_02]))
	{
		var_03 = level._notetrackfx[param_00][var_02];
	}
	else if(isdefined(level._notetrackfx[param_00]["all"]))
	{
		var_03 = level._notetrackfx[param_00]["all"];
	}

	if(!isdefined(var_03))
	{
		return;
	}

	if(isai(self) && isdefined(var_03.fx))
	{
		playfxontag(var_03.fx,self,var_03.physics_setgravitydynentscalar);
	}

	if(!isdefined(var_03.sound_prefix) && !isdefined(var_03.sound_suffix))
	{
		return;
	}

	var_04 = "" + var_03.sound_prefix + var_02 + var_03.sound_suffix;
	if(soundexists(var_04))
	{
		self playsound(var_04);
	}
}

//Function Number: 62
notetrackfootscrape(param_00,param_01)
{
	if(isdefined(self.pausemayhem))
	{
		var_02 = self.pausemayhem;
	}
	else
	{
		var_02 = "dirt";
	}

	self playsurfacesound("step_scrape",var_02);
}

//Function Number: 63
notetrackland(param_00,param_01)
{
	if(isdefined(self.pausemayhem))
	{
		var_02 = self.pausemayhem;
	}
	else
	{
		var_02 = "dirt";
	}

	self playsurfacesound("default_step_land",var_02);
	self _meth_8584("land");
	self _meth_8583("land",self.var_394);
}

//Function Number: 64
notetrackcodemove(param_00,param_01)
{
	return "code_move";
}

//Function Number: 65
notetrackfaceenemy(param_00,param_01)
{
	if(self.script != "reactions")
	{
		self orientmode("face enemy");
		return;
	}

	if(isdefined(self.isnodeoccupied) && distancesquared(self.var_10C.origin,self.getreflectionlocs) < 4096)
	{
		self orientmode("face enemy");
		return;
	}

	self orientmode("face point",self.getreflectionlocs);
}

//Function Number: 66
notetrackbodyfall(param_00,param_01)
{
	var_02 = "_small";
	if(issubstr(param_00,"large"))
	{
		var_02 = "_large";
	}

	if(isdefined(self.pausemayhem))
	{
		var_03 = self.pausemayhem;
	}
	else
	{
		var_03 = "dirt";
	}

	if(soundexists("bodyfall_" + var_03 + var_02))
	{
		self playsound("bodyfall_" + var_03 + var_02);
	}
}

//Function Number: 67
handlerocketlauncherammoondeath()
{
	self endon("detached");
	self waittill("death");
	if(isdefined(self.rocketlauncherammo))
	{
		self.rocketlauncherammo delete();
	}
}

//Function Number: 68
notetrackrocketlauncherammoattach()
{
	if(!isalive(self))
	{
		return;
	}

	if(!scripts\anim\utility_common::usingrocketlauncher())
	{
		return;
	}

	self.rocketlauncherammo = spawn("script_model",self.origin);
	if(issubstr(tolower(self.var_394),"lockon"))
	{
		self.rocketlauncherammo setmodel("weapon_launcher_missile_wm");
	}
	else if(issubstr(tolower(self.var_394),"panzerfaust"))
	{
		self.rocketlauncherammo setmodel("weapon_panzerfaust3_missle");
	}
	else
	{
		self.rocketlauncherammo setmodel("projectile_rpg7");
	}

	self.rocketlauncherammo linkto(self,"tag_accessory_right",(0,0,0),(0,0,0));
	thread handlerocketlauncherammoondeath();
}

//Function Number: 69
notetrackrocketlauncherammodelete()
{
	self notify("detached");
	if(isdefined(self.rocketlauncherammo))
	{
		self.rocketlauncherammo delete();
	}

	self.var_1491.rocketvisible = 1;
	if(isai(self) && !isalive(self))
	{
		return;
	}

	if(scripts\sp\_utility::hastag(function_00EA(self.var_394),"tag_rocket"))
	{
		self giveperk("tag_rocket");
	}
}

//Function Number: 70
handlenotetrack(param_00,param_01,param_02,param_03)
{
	var_04 = level.notetracks[param_00];
	if(isdefined(var_04))
	{
		return [[ var_04 ]](param_00,param_01);
	}
	else if(isdefined(self.var_4C93))
	{
		if(isdefined(param_03))
		{
			return [[ self.var_4C93 ]](param_00,param_01,param_02,param_03);
		}
		else
		{
			return [[ self.var_4C93 ]](param_00,param_01,param_02);
		}
	}

	switch(param_00)
	{
		case "undefined":
		case "finish":
		case "end":
			return param_00;

		case "finish early":
			if(isdefined(self.isnodeoccupied))
			{
				return param_00;
			}
			break;

		case "swish small":
			thread scripts\common\utility::play_sound_in_space("melee_swing_small",self gettagorigin("TAG_WEAPON_RIGHT"));
			break;

		case "swish large":
			thread scripts\common\utility::play_sound_in_space("melee_swing_large",self gettagorigin("TAG_WEAPON_RIGHT"));
			break;

		case "rechamber":
			if(scripts\anim\utility_common::weapon_pump_action_shotgun())
			{
				self playsound("weap_reload_shotgun_pump_npc");
			}
	
			self.var_1491.needstorechamber = 0;
			break;

		case "no death":
			self.var_1491.nodeath = 1;
			break;

		case "no pain":
			self.allowpain = 0;
			break;

		case "allow pain":
			self.allowpain = 1;
			break;

		case "anim_melee = \"right\":
		case "anim_melee = right":
			self.var_1491.meleestate = "right";
			break;

		case "anim_melee = \"left\":
		case "anim_melee = left":
			self.var_1491.meleestate = "left";
			break;

		case "swap taghelmet to tagleft":
			if(isdefined(self.hatmodel))
			{
				if(isdefined(self.helmetsidemodel))
				{
					self detach(self.helmetsidemodel,"TAG_HELMETSIDE");
					self.helmetsidemodel = undefined;
				}
	
				self detach(self.hatmodel,"");
				self attach(self.hatmodel,"TAG_WEAPON_LEFT");
				self.hatmodel = undefined;
			}
			break;

		case "stop anim":
			scripts\sp\_utility::anim_stopanimscripted();
			return param_00;

		case "break glass":
			level notify("glass_break",self);
			break;

		case "break_glass":
			level notify("glass_break",self);
			break;

		case "attach clip left":
			if(scripts\anim\utility_common::usingrocketlauncher())
			{
				notetrackrocketlauncherammoattach();
			}
			break;

		case "detach clip left":
			if(scripts\anim\utility_common::usingrocketlauncher())
			{
				notetrackrocketlauncherammodelete();
			}
			break;

		case "jetpack_boost":
			thread func_CCAB("boost_on_up","large");
			break;

		case "boost_on_right":
		case "boost_on_left":
		case "boost_on_down":
		case "boost_on_back":
		case "boost_on_forward":
		case "boost_on_up":
			thread func_CCAB(param_00,"large");
			break;

		case "boost_on_right_short":
		case "boost_on_left_short":
		case "boost_on_down_short":
		case "boost_on_up_short":
		case "boost_on_back_short":
		case "boost_on_forward_short":
			func_CCAB(param_00,"small");
			break;

		case "jetpack_death_fx":
			playfxontag(scripts\common\utility::getfx("zerog_jetpack_death"),self,"tag_fx_bottom");
			break;

		case "start_drift":
			if(!self.logstring)
			{
				self animmode("physics_drift");
			}
			break;

		case "c6_punch":
			self playsound("c6_punch");
			break;

		default:
			if(isdefined(param_02))
			{
				if(isdefined(param_03))
				{
					return [[ param_02 ]](param_00,param_03);
				}
				else
				{
					return [[ param_02 ]](param_00);
				}
			}
			break;
	}
}

//Function Number: 71
donotetracksintercept(param_00,param_01,param_02)
{
	for(;;)
	{
		self waittill(param_00,var_03);
		if(!isdefined(var_03))
		{
			var_03 = ["undefined"];
		}

		if(!isarray(var_03))
		{
			var_03 = [var_03];
		}

		scripts\anim\utility::validatenotetracks(param_00,var_03);
		var_04 = [[ param_01 ]](var_03);
		if(isdefined(var_04) && var_04)
		{
			continue;
		}

		var_05 = undefined;
		foreach(var_07 in var_03)
		{
			var_08 = handlenotetrack(var_07,param_00);
			if(isdefined(var_08))
			{
				var_05 = var_08;
				break;
			}
		}

		if(isdefined(var_05))
		{
			return var_05;
		}
	}
}

//Function Number: 72
donotetrackspostcallback(param_00,param_01)
{
	for(;;)
	{
		self waittill(param_00,var_02);
		if(!isdefined(var_02))
		{
			var_02 = ["undefined"];
		}

		if(!isarray(var_02))
		{
			var_02 = [var_02];
		}

		scripts\anim\utility::validatenotetracks(param_00,var_02);
		var_03 = undefined;
		foreach(var_05 in var_02)
		{
			var_06 = handlenotetrack(var_05,param_00);
			if(isdefined(var_06))
			{
				var_03 = var_06;
				break;
			}
		}

		[[ param_01 ]](var_02);
		if(isdefined(var_03))
		{
			return var_03;
		}
	}
}

//Function Number: 73
donotetracksfortimeout(param_00,param_01,param_02,param_03)
{
	scripts\anim\shared::donotetracks(param_00,param_02,param_03);
}

//Function Number: 74
donotetracksforever(param_00,param_01,param_02,param_03)
{
	donotetracksforeverproc(::scripts\anim\shared::donotetracks,param_00,param_01,param_02,param_03);
}

//Function Number: 75
donotetracksforeverintercept(param_00,param_01,param_02,param_03)
{
	donotetracksforeverproc(::donotetracksintercept,param_00,param_01,param_02,param_03);
}

//Function Number: 76
donotetracksforeverproc(param_00,param_01,param_02,param_03,param_04)
{
	if(isdefined(param_02))
	{
		self endon(param_02);
	}

	self endon("killanimscript");
	if(!isdefined(param_04))
	{
		param_04 = "undefined";
	}

	for(;;)
	{
		var_05 = gettime();
		var_06 = [[ param_00 ]](param_01,param_03,param_04);
		var_07 = gettime() - var_05;
		if(var_07 < 0.05)
		{
			var_05 = gettime();
			var_06 = [[ param_00 ]](param_01,param_03,param_04);
			var_07 = gettime() - var_05;
			if(var_07 < 0.05)
			{
				wait(0.05 - var_07);
			}
		}
	}
}

//Function Number: 77
donotetrackswithtimeout(param_00,param_01,param_02,param_03)
{
	var_04 = spawnstruct();
	var_04 thread donotetracksfortimeendnotify(param_01);
	donotetracksfortimeproc(::donotetracksfortimeout,param_00,param_02,param_03,var_04);
}

//Function Number: 78
donotetracksfortime(param_00,param_01,param_02,param_03)
{
	var_04 = spawnstruct();
	var_04 thread donotetracksfortimeendnotify(param_00);
	donotetracksfortimeproc(::donotetracksforever,param_01,param_02,param_03,var_04);
}

//Function Number: 79
donotetracksfortimeintercept(param_00,param_01,param_02,param_03)
{
	var_04 = spawnstruct();
	var_04 thread donotetracksfortimeendnotify(param_00);
	donotetracksfortimeproc(::donotetracksforeverintercept,param_01,param_02,param_03,var_04);
}

//Function Number: 80
donotetracksfortimeproc(param_00,param_01,param_02,param_03,param_04)
{
	param_04 endon("stop_notetracks");
	[[ param_00 ]](param_01,undefined,param_02,param_03);
}

//Function Number: 81
donotetracksfortimeendnotify(param_00)
{
	wait(param_00);
	self notify("stop_notetracks");
}

//Function Number: 82
playfootstep(param_00,param_01)
{
	if(!isai(self))
	{
		self playsurfacesound("default_step_run","dirt");
		return;
	}

	var_02 = undefined;
	if(!isdefined(self.pausemayhem))
	{
		if(!isdefined(self.var_A995))
		{
			self playsurfacesound("default_step_run","dirt");
			return;
		}

		var_02 = self.var_A995;
	}
	else
	{
		var_02 = self.pausemayhem;
		self.var_A995 = self.pausemayhem;
	}

	var_03 = "J_Ball_RI";
	if(param_00)
	{
		var_03 = "J_Ball_LE";
	}

	var_04 = get_notetrack_movement();
	if(self.unittype == "soldier" || self.unittype == "civilian")
	{
		var_05 = "";
	}
	else
	{
		var_05 = tolower(self.unittype + "_");
	}

	if(self.unittype == "c6i" || self.unittype == "c6" || self.unittype == "c8" || self.unittype == "c12")
	{
		var_06 = var_05 + "step_" + var_04;
	}
	else
	{
		var_06 = var_06 + "default_step_" + var_05;
	}

	if(soundexists(var_06))
	{
		if(self.unittype == "c8")
		{
			if(!isdefined(self.var_6BC7))
			{
				self.var_6BC7 = spawn("script_origin",self.origin);
				self.var_6BC7 linkto(self);
			}

			self.var_6BC7 playsurfacesound(var_06,var_02);
		}
		else
		{
			thread scripts\sp\_utility::func_CE48(var_06,var_02,var_03);
		}
	}

	if(isdefined(self.var_164D[self.asmname].var_4BC0))
	{
		if(issubstr(self.var_164D[self.asmname].var_4BC0,"wall_run"))
		{
			self playsound("wall_run_tech_lyr_npc");
		}

		if(self.unittype == "c8" && self.var_164D[self.asmname].var_4BC0 == "melee_charge")
		{
			thread scripts\sp\_utility::play_sound_on_tag("c8_step_charge_lyr",var_03);
		}
	}

	if(self.unittype == "c12")
	{
		var_07 = "c12_footstep_small";
		var_08 = 450;
		var_09 = 0.3;
		if(var_04 == "run")
		{
			var_07 = "c12_footstep_large";
			var_09 = 0.5;
			var_08 = 900;
		}

		self playrumbleonentity(var_07);
		function_01A2(self.origin,var_09,var_09,var_09,0.3,0,-1,var_08,5,0.2,2);
		var_0A = self gettagorigin(var_03);
		var_0B = self.angles;
		var_0C = anglestoup(var_0B);
		var_0C = var_0C * 0.35;
		function_016C(var_0A,50,25,var_0C);
		var_0D = 100;
		if(!level.player isjumping() && distancesquared(level.player.origin,var_0A) <= squared(var_0D))
		{
			level.player dodamage(level.player.maxhealth * 0.5,var_0A,self);
			level.player viewkick(1,var_0A,0);
			var_0E = vectornormalize(level.player.origin - var_0A);
			level.player setvelocity(150 * var_0E);
		}
	}

	if(param_01)
	{
		if(![[ level.optionalstepeffectfunction ]](var_03,var_02))
		{
			func_D480(var_03,var_02);
			return;
		}

		return;
	}

	if(![[ level.optionalstepeffectsmallfunction ]](var_03,var_02))
	{
		playfootstepeffect(var_03,var_02);
	}
}

//Function Number: 83
func_D492(param_00,param_01)
{
	if(!isai(self))
	{
		self playsurfacesound("c6_handstep","default");
		return;
	}

	if(param_00)
	{
		var_02 = "J_MID_LE_1";
		if(lib_0A0B::func_7C35("left_arm") == "dismember")
		{
			return;
		}
	}
	else
	{
		var_02 = "J_MID_RI_1";
		if(lib_0A0B::func_7C35("right_arm") == "dismember")
		{
			return;
		}
	}

	var_03 = undefined;
	if(!isdefined(self.pausemayhem))
	{
		if(!isdefined(self.var_A995))
		{
			self playsurfacesound("c6_handstep","default");
			return;
		}

		var_03 = self.var_A995;
	}
	else
	{
		var_03 = self.pausemayhem;
		self.var_A995 = self.pausemayhem;
	}

	var_04 = get_notetrack_movement();
	var_05 = "c6_handstep";
	if(soundexists(var_05))
	{
		self playsurfacesound(var_05,var_03);
	}

	if(![[ level.optionalstepeffectsmallfunction ]](var_02,var_03))
	{
		playfootstepeffect(var_02,var_03);
	}
}

//Function Number: 84
playfootstepeffect(param_00,param_01)
{
	if(!isdefined(level.optionalstepeffects[param_01]))
	{
		return 0;
	}

	var_02 = self gettagorigin(param_00);
	var_03 = self.angles;
	var_04 = anglestoforward(var_03);
	var_05 = anglestoup(var_03);
	if(!isdefined(level._effect["step_" + param_01][self.unittype]))
	{
		level._effect["step_" + param_01][self.unittype] = level._effect["step_" + param_01]["soldier"];
	}

	playfx(level._effect["step_" + param_01][self.unittype],var_02,var_04,var_05);
	return 1;
}

//Function Number: 85
func_D480(param_00,param_01)
{
	if(!isdefined(level.optionalstepeffectssmall[param_01]))
	{
		return 0;
	}

	var_02 = self gettagorigin(param_00);
	var_03 = self.angles;
	var_04 = anglestoforward(var_03);
	var_05 = anglestoup(var_03);
	if(!isdefined(level._effect["step_small_" + param_01][self.unittype]))
	{
		level._effect["step_small_" + param_01][self.unittype] = level._effect["step_small_" + param_01]["soldier"];
	}

	playfx(level._effect["step_small_" + param_01][self.unittype],var_02,var_04,var_05);
	return 1;
}

//Function Number: 86
fire_straight()
{
	if(self.var_1491.weaponpos["right"] == "none")
	{
		return;
	}

	if(isdefined(self.dontshootstraight))
	{
		shootnotetrack();
		return;
	}

	if(scripts\sp\_utility::hastag(self.model,"tag_weapon"))
	{
		var_00 = self gettagorigin("tag_weapon");
	}
	else
	{
		var_00 = self gettagorigin("tag_weapon_right");
	}

	var_01 = anglestoforward(self getspawnpointdist());
	var_02 = var_00 + var_01 * 1000;
	self shoot(1,var_02);
	scripts\anim\combat_utility::decrementbulletsinclip();
}

//Function Number: 87
notetrackfirespray(param_00,param_01)
{
	if(!isalive(self) && self gettargetchargepos())
	{
		if(isdefined(self.var_3C55))
		{
			return;
		}

		self.var_3C55 = 1;
		var_02["axis"] = "team3";
		var_02["team3"] = "axis";
		self.team = var_02[self.team];
	}

	if(!issentient(self))
	{
		self notify("fire");
		return;
	}

	if(self.var_1491.weaponpos["right"] == "none")
	{
		return;
	}

	var_03 = self getmuzzlepos();
	var_04 = anglestoforward(self getspawnpointdist());
	var_05 = 10;
	if(isdefined(self.var_9F15))
	{
		var_05 = 20;
	}

	var_06 = 0;
	if(isalive(self.isnodeoccupied) && issentient(self.isnodeoccupied) && self canshootenemy())
	{
		var_07 = vectornormalize(self.isnodeoccupied geteye() - var_03);
		if(vectordot(var_04,var_07) > cos(var_05))
		{
			var_06 = 1;
		}
	}

	if(var_06)
	{
		scripts\anim\utility_common::shootenemywrapper();
	}
	else
	{
		var_04 = var_04 + (randomfloat(2) - 1 * 0.1,randomfloat(2) - 1 * 0.1,randomfloat(2) - 1 * 0.1);
		var_08 = var_03 + var_04 * 1000;
		self [[ level.var_FED3 ]](var_08);
	}

	scripts\anim\combat_utility::decrementbulletsinclip();
}

//Function Number: 88
func_CCAB(param_00,param_01)
{
	var_02 = [];
	if(param_00 == "boost_on_forward" || param_00 == "boost_on_forward_short")
	{
		var_02[var_02.size] = "tag_fx_back";
	}
	else if(param_00 == "boost_on_back" || param_00 == "boost_on_back_short")
	{
		var_02[var_02.size] = "tag_fx_left";
		var_02[var_02.size] = "tag_fx_right";
	}
	else if(param_00 == "boost_on_up" || param_00 == "boost_on_up_short")
	{
		var_02[var_02.size] = "tag_fx_bottom";
	}
	else if(param_00 == "boost_on_down" || param_00 == "boost_on_down_short")
	{
		var_02[var_02.size] = "tag_fx_top";
	}
	else if(param_00 == "boost_on_left" || param_00 == "boost_on_left_short")
	{
		var_02[var_02.size] = "tag_fx_right";
	}
	else if(param_00 == "boost_on_right" || param_00 == "boost_on_right_short")
	{
		var_02[var_02.size] = "tag_fx_left";
	}

	var_03 = undefined;
	if(param_01 == "large")
	{
		var_03 = scripts\common\utility::ter_op(isdefined(level.var_E977),level.var_13EE8,::func_CD6B);
	}
	else if(param_01 == "small")
	{
		var_03 = scripts\common\utility::ter_op(isdefined(level.var_E977),level.var_13EE9,::func_CE13);
	}

	foreach(var_05 in var_02)
	{
		self [[ var_03 ]](var_05);
	}
}

//Function Number: 89
func_CD6B(param_00)
{
	return func_CE37("jetpack_thruster_large","jetpack_thruster_large_allies",param_00);
}

//Function Number: 90
func_CE13(param_00)
{
	return func_CE37("jetpack_thruster_small","jetpack_thruster_small_allies",param_00);
}

//Function Number: 91
func_CE37(param_00,param_01,param_02)
{
	self endon("death");
	if(self.team == "neutral")
	{
		return undefined;
	}

	var_03 = self.team;
	if(var_03 == "dead")
	{
		var_03 = self.var_C733;
	}

	var_04 = undefined;
	if(var_03 == "axis")
	{
		var_04 = scripts\common\utility::getfx(param_00);
	}
	else if(var_03 == "allies")
	{
		var_04 = scripts\common\utility::getfx(param_01);
	}

	var_05 = scripts\common\utility::ter_op(self.team == "axis","double_jump_boost_enemy","double_jump_boost_npc");
	childthread scripts\sp\_utility::play_sound_on_entity(var_05);
	playfxontag(var_04,self,param_02);
	return [var_04,param_02];
}
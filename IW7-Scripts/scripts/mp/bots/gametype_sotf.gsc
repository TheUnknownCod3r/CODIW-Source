/*******************************************************************
 * Decompiled By: Bog
 * Decompiled File: scripts\mp\bots\gametype_sotf.gsc
 * Game: Call of Duty: Infinite Warfare
 * Platform: PC
 * Function Count: 12
 * Decompile Time: 604 ms
 * Timestamp: 10/27/2023 12:12:08 AM
*******************************************************************/

//Function Number: 1
main()
{
	setup_callbacks();
	setup_bot_sotf();
}

//Function Number: 2
setup_callbacks()
{
	level.bot_funcs["dropped_weapon_think"] = ::sotf_bot_think_seek_dropped_weapons;
	level.bot_funcs["dropped_weapon_cancel"] = ::sotf_should_stop_seeking_weapon;
	level.bot_funcs["crate_low_ammo_check"] = ::sotf_crate_low_ammo_check;
	level.bot_funcs["crate_should_claim"] = ::sotf_crate_should_claim;
	level.bot_funcs["crate_wait_use"] = ::sotf_crate_wait_use;
	level.bot_funcs["crate_in_range"] = ::sotf_crate_in_range;
	level.bot_funcs["crate_can_use"] = ::sotf_crate_can_use;
}

//Function Number: 3
setup_bot_sotf()
{
	level.bots_gametype_handles_class_choice = 1;
}

//Function Number: 4
sotf_should_stop_seeking_weapon(param_00)
{
	if(scripts\mp\bots\_bots_util::bot_get_total_gun_ammo() > 0)
	{
		var_01 = scripts\mp\_utility::getweapongroup(self getcurrentweapon());
		if(isdefined(param_00.object))
		{
			var_02 = param_00.object.classname;
			if(scripts\engine\utility::string_starts_with(var_02,"weapon_"))
			{
				var_02 = getsubstr(var_02,7);
			}

			var_03 = scripts\mp\_utility::getweapongroup(var_02);
			if(!bot_weapon_is_better_class(var_01,var_03))
			{
				return 1;
			}
		}
	}

	if(!isdefined(param_00.object))
	{
		return 1;
	}

	return 0;
}

//Function Number: 5
sotf_bot_think_seek_dropped_weapons()
{
	self notify("bot_think_seek_dropped_weapons");
	self endon("bot_think_seek_dropped_weapons");
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		var_00 = 0;
		if(self [[ level.bot_funcs["should_pickup_weapons"] ]]() && !scripts\mp\bots\_bots_util::bot_is_remote_or_linked())
		{
			if(scripts\mp\bots\_bots_util::bot_out_of_ammo())
			{
				var_01 = getentarray("dropped_weapon","targetname");
				var_02 = scripts\engine\utility::get_array_of_closest(self.origin,var_01);
				if(var_02.size > 0)
				{
					var_03 = var_02[0];
					scripts\mp\bots\_bots::bot_seek_dropped_weapon(var_03);
				}
			}
			else
			{
				var_01 = getentarray("dropped_weapon","targetname");
				var_02 = scripts\engine\utility::get_array_of_closest(self.origin,var_02);
				if(var_02.size > 0)
				{
					var_04 = self getnearestnode();
					if(isdefined(var_04))
					{
						var_05 = scripts\mp\_utility::getweapongroup(self getcurrentweapon());
						foreach(var_03 in var_02)
						{
							var_07 = var_03.classname;
							if(scripts\engine\utility::string_starts_with(var_07,"weapon_"))
							{
								var_07 = getsubstr(var_07,7);
							}

							var_08 = scripts\mp\_utility::getweapongroup(var_07);
							if(bot_weapon_is_better_class(var_05,var_08))
							{
								if(!isdefined(var_03.calculated_nearest_node) || !var_03.calculated_nearest_node)
								{
									var_03.nearest_node = getclosestnodeinsight(var_03.origin);
									var_03.calculated_nearest_node = 1;
								}

								if(isdefined(var_03.nearest_node) && nodesvisible(var_04,var_03.nearest_node,1))
								{
									scripts\mp\bots\_bots::bot_seek_dropped_weapon(var_03);
									break;
								}
							}
						}
					}
				}
			}
		}

		wait(randomfloatrange(0.25,0.75));
	}
}

//Function Number: 6
bot_rank_weapon_class(param_00)
{
	var_01 = 0;
	switch(param_00)
	{
		case "weapon_other":
		case "weapon_explosive":
		case "weapon_grenade":
		case "weapon_projectile":
			break;

		case "weapon_pistol":
			var_01 = 1;
			break;

		case "weapon_dmr":
		case "weapon_sniper":
			var_01 = 2;
			break;

		case "weapon_shotgun":
		case "weapon_lmg":
		case "weapon_assault":
		case "weapon_smg":
			var_01 = 3;
			break;
	}

	return var_01;
}

//Function Number: 7
bot_weapon_is_better_class(param_00,param_01)
{
	var_02 = bot_rank_weapon_class(param_00);
	var_03 = bot_rank_weapon_class(param_01);
	return var_03 > var_02;
}

//Function Number: 8
sotf_crate_low_ammo_check()
{
	var_00 = self getcurrentweapon();
	var_01 = self getweaponammoclip(var_00);
	var_02 = self getweaponammostock(var_00);
	var_03 = weaponclipsize(var_00);
	return var_01 + var_02 < var_03 * 0.25;
}

//Function Number: 9
sotf_crate_should_claim()
{
	return 0;
}

//Function Number: 10
sotf_crate_wait_use()
{
	scripts\mp\bots\_bots_util::bot_waittill_out_of_combat_or_time(5000);
}

//Function Number: 11
sotf_crate_in_range(param_00)
{
	return 1;
}

//Function Number: 12
sotf_crate_can_use(param_00)
{
	if(scripts\mp\bots\_bots::crate_can_use_always(param_00))
	{
		if(isdefined(param_00) && isdefined(param_00.bots_used) && scripts\engine\utility::array_contains(param_00.bots_used,self))
		{
			if(scripts\mp\bots\_bots_util::bot_out_of_ammo())
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

		var_01 = scripts\mp\_utility::getweapongroup(self getcurrentweapon());
		if(bot_rank_weapon_class(var_01) <= 1)
		{
			return 1;
		}

		if(sotf_crate_low_ammo_check())
		{
			return 1;
		}

		return 0;
	}

	return 0;
}
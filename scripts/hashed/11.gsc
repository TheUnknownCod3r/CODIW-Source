/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 11.gsc
***************************************/

main() {
  if (isdefined(level.createfx_enabled) && level.createfx_enabled)
  return;

  setup_callbacks();
  scripts\mp\bots\bots_personality::setup_personalities();
  level.badplace_cylinder_func = ::badplace_cylinder;
  level.badplace_delete_func = ::badplace_delete;
  scripts\mp\bots\bots_killstreaks::bot_killstreak_setup();
  scripts\mp\bots\bots_powers::func_2E53();
  scripts\mp\bots\bots_loadout::init();
  level thread init();
}

setup_callbacks() {
  level.bot_funcs = [];
  level.bot_funcs["bots_spawn"] = ::spawn_bots;
  level.bot_funcs["bots_add_scavenger_bag"] = ::bot_add_scavenger_bag;
  level.bot_funcs["bots_add_to_level_targets"] = scripts\mp\bots\bots_util::bot_add_to_bot_level_targets;
  level.bot_funcs["bots_remove_from_level_targets"] = scripts\mp\bots\bots_util::bot_remove_from_bot_level_targets;
  level.bot_funcs["bots_make_entity_sentient"] = ::bot_make_entity_sentient;
  level.bot_funcs["think"] = ::bot_think;
  level.bot_funcs["on_killed"] = ::on_bot_killed;
  level.bot_funcs["should_do_killcam"] = ::bot_should_do_killcam;
  level.bot_funcs["get_attacker_ent"] = scripts\mp\bots\bots_util::bot_get_known_attacker;
  level.bot_funcs["should_pickup_weapons"] = ::bot_should_pickup_weapons;
  level.bot_funcs["on_damaged"] = ::bot_damage_callback;
  level.bot_funcs["gametype_think"] = ::default_gametype_think;
  level.bot_funcs["leader_dialog"] = scripts\mp\bots\bots_util::bot_leader_dialog;
  level.bot_funcs["player_spawned"] = ::bot_player_spawned;
  level.bot_funcs["should_start_cautious_approach"] = scripts\mp\bots\bots_strategy::should_start_cautious_approach_default;
  level.bot_funcs["know_enemies_on_start"] = ::bot_know_enemies_on_start;
  level.bot_funcs["bot_get_rank_xp"] = ::bot_get_rank_xp;
  level.bot_funcs["ai_3d_sighting_model"] = ::bot_3d_sighting_model;
  level.bot_funcs["dropped_weapon_think"] = ::bot_think_seek_dropped_weapons;
  level.bot_funcs["dropped_weapon_cancel"] = ::should_stop_seeking_weapon;
  level.bot_funcs["crate_can_use"] = ::crate_can_use_always;
  level.bot_funcs["crate_low_ammo_check"] = ::crate_low_ammo_check;
  level.bot_funcs["crate_should_claim"] = ::crate_should_claim;
  level.bot_funcs["crate_wait_use"] = ::crate_wait_use;
  level.bot_funcs["crate_in_range"] = ::crate_in_range;
  level.bot_funcs["post_teleport"] = ::bot_post_teleport;
  level.bot_random_path_function = [];
  level.bot_random_path_function["allies"] = scripts\mp\bots\bots_personality::bot_random_path_default;
  level.bot_random_path_function["axis"] = scripts\mp\bots\bots_personality::bot_random_path_default;
  level.bot_can_use_box_by_type["deployable_vest"] = ::bot_should_use_ballistic_vest_crate;
  level.bot_can_use_box_by_type["deployable_ammo"] = ::bot_should_use_ammo_crate;
  level.bot_can_use_box_by_type["scavenger_bag"] = ::bot_should_use_scavenger_bag;
  level.bot_can_use_box_by_type["deployable_grenades"] = ::bot_should_use_grenade_crate;
  level.bot_can_use_box_by_type["deployable_juicebox"] = ::bot_should_use_juicebox_crate;
  level.bot_pre_use_box_of_type["deployable_ammo"] = ::bot_post_use_ammo_crate;
  level.bot_post_use_box_of_type["deployable_ammo"] = ::bot_post_use_ammo_crate;
  level.bot_find_defend_node_func["capture"] = scripts\mp\bots\bots_strategy::find_defend_node_capture;
  level.bot_find_defend_node_func["capture_zone"] = scripts\mp\bots\bots_strategy::find_defend_node_capture_zone;
  level.bot_find_defend_node_func["protect"] = scripts\mp\bots\bots_strategy::find_defend_node_protect;
  level.bot_find_defend_node_func["bodyguard"] = scripts\mp\bots\bots_strategy::find_defend_node_bodyguard;
  level.bot_find_defend_node_func["patrol"] = scripts\mp\bots\bots_strategy::find_defend_node_patrol;
  scripts\mp\bots\gametype_war::setup_callbacks();

  if (scripts\mp\utility\game::bot_is_fireteam_mode())
  scripts\mp\bots\bots_fireteam::bot_fireteam_setup_callbacks();
}

codecallback_leaderdialog(var_00, var_01) {
  if (isdefined(level.bot_funcs) && isdefined(level.bot_funcs["leader_dialog"]))
  self [[level.bot_funcs["leader_dialog"]]](var_00, var_01);
}

init() {
  thread monitor_smoke_grenades();
  thread bot_triggers();
  initbotlevelvariables();

  if (!shouldspawnbots())
  return;

  refresh_existing_bots();
  var_00 = botautoconnectenabled();

  if (var_00 > 0) {
  setmatchdata("hasBots", 1);

  if (scripts\mp\utility\game::bot_is_fireteam_mode()) {
  level thread scripts\mp\bots\bots_fireteam::bot_fireteam_init();
  level thread scripts\mp\bots\bots_fireteam_commander::init();
  }
  else
  level thread bot_connect_monitor();
  }
}

initbotlevelvariables() {
  if (!isdefined(level.crateownerusetime))
  level.crateownerusetime = 500;

  if (!isdefined(level.cratenonownerusetime))
  level.cratenonownerusetime = 3000;

  level.bot_out_of_combat_time = 3000;
  level.bot_respawn_launcher_name = "iw6_panzerfaust3";
  level.bot_fallback_weapon = "iw7_knife";
  level.zonecount = getzonecount();
  level.atk_bomber = undefined;
  initbotmapextents();
}

initbotmapextents() {
  if (isdefined(level.teleportgetactivenodesfunc))
  var_00 = [[level.teleportgetactivenodesfunc]]();
  else
  var_00 = getallnodes();

  level.bot_map_min_x = 0;
  level.bot_map_max_x = 0;
  level.bot_map_min_y = 0;
  level.bot_map_max_y = 0;
  level.bot_map_min_z = 0;
  level.bot_map_max_z = 0;

  if (var_0.size > 1) {
  level.bot_map_min_x = var_0[0].origin[0];
  level.bot_map_max_x = var_0[0].origin[0];
  level.bot_map_min_y = var_0[0].origin[1];
  level.bot_map_max_y = var_0[0].origin[1];
  level.bot_map_min_z = var_0[0].origin[2];
  level.bot_map_max_z = var_0[0].origin[2];

  for (var_01 = 1; var_01 < var_0.size; var_1++) {
  var_02 = var_0[var_01].origin;

  if (var_2[0] < level.bot_map_min_x)
  level.bot_map_min_x = var_2[0];

  if (var_2[0] > level.bot_map_max_x)
  level.bot_map_max_x = var_2[0];

  if (var_2[1] < level.bot_map_min_y)
  level.bot_map_min_y = var_2[1];

  if (var_2[1] > level.bot_map_max_y)
  level.bot_map_max_y = var_2[1];

  if (var_2[2] < level.bot_map_min_z)
  level.bot_map_min_z = var_2[2];

  if (var_2[2] > level.bot_map_max_z)
  level.bot_map_max_z = var_2[2];
  }
  }

  level.bot_map_center = ((level.bot_map_min_x + level.bot_map_max_x) / 2, (level.bot_map_min_y + level.bot_map_max_y) / 2, (level.bot_map_min_z + level.bot_map_max_z) / 2);
  level.bot_variables_initialized = 1;
}

bot_post_teleport() {
  level.bot_variables_initialized = undefined;
  level.bot_initialized_remote_vehicles = undefined;
  initbotmapextents();
  scripts\mp\bots\bots_killstreaks_remote_vehicle::remote_vehicle_setup();
}

shouldspawnbots() {
  return 1;
}

refresh_existing_bots() {
  wait 1;

  foreach (var_01 in level.players) {
  if (isbot(var_01)) {
  if (isalive(var_01)) {
  var_1.equipment_enabled = 1;
  var_1.bot_team = var_1.team;
  var_1.bot_spawned_before = 1;
  var_01 thread [[level.bot_funcs["think"]]]();
  continue;
  }
  }
  }
}

bot_player_spawned() {
  bot_set_loadout_class();

  if (isdefined(self.prev_personality)) {
  scripts\mp\bots\bots_util::bot_set_personality(self.prev_personality);
  self.prev_personality = undefined;
  }
}

bot_set_loadout_class() {
  if (!isdefined(self.bot_class)) {
  if (!bot_gametype_chooses_class()) {
  while (!isdefined(level.bot_loadouts_initialized))
  wait 0.05;

  if (isdefined(self.override_class_function))
  self.bot_class = [[self.override_class_function]]();
  else
  self.bot_class = scripts\mp\bots\bots_personality::bot_setup_callback_class();
  }
  else
  self.bot_class = self.class;
  }
}

watch_players_connecting() {
  for (;;) {
  level waittill("connected", var_00);

  if (!isai(var_00) && level.players.size > 0) {
  level.players_waiting_to_join = scripts\engine\utility::array_add(level.players_waiting_to_join, var_00);
  childthread bots_notify_on_spawn(var_00);
  childthread bots_notify_on_disconnect(var_00);
  childthread bots_remove_from_array_on_notify(var_00);
  }
  }
}

bots_notify_on_spawn(var_00) {
  var_00 endon("bots_human_disconnected");

  while (!scripts\engine\utility::array_contains(level.players, var_00))
  wait 0.05;

  var_00 notify("bots_human_spawned");
}

bots_notify_on_disconnect(var_00) {
  var_00 endon("bots_human_spawned");
  var_00 waittill("disconnect");
  var_00 notify("bots_human_disconnected");
}

bots_remove_from_array_on_notify(var_00) {
  var_00 scripts\engine\utility::waittill_any("bots_human_spawned", "bots_human_disconnected");
  level.players_waiting_to_join = scripts\engine\utility::array_remove(level.players_waiting_to_join, var_00);
}

monitor_pause_spawning() {
  level.players_waiting_to_join = [];
  childthread watch_players_connecting();

  for (;;) {
  if (level.players_waiting_to_join.size > 0)
  level.pausing_bot_connect_monitor = 1;
  else
  level.pausing_bot_connect_monitor = 0;

  wait 0.5;
  }
}

bot_can_join_team(var_00) {
  if (scripts\mp\utility\game::matchmakinggame())
  return 1;

  if (!level.teambased)
  return 1;

  if (scripts\mp\teams::getjointeampermissions(var_00))
  return 1;

  return 0;
}

bot_connect_monitor(var_00, var_01) {
  level endon("game_ended");
  self notify("bot_connect_monitor");
  self endon("bot_connect_monitor");
  level.pausing_bot_connect_monitor = 0;
  childthread monitor_pause_spawning();
  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(0.5);
  var_02 = 1.5;

  if (!isdefined(level.bot_cm_spawned_bots))
  level.bot_cm_spawned_bots = 0;

  if (!isdefined(level.bot_cm_waited_players_time))
  level.bot_cm_waited_players_time = 0;

  if (!isdefined(level.bot_cm_human_picked))
  level.bot_cm_human_picked = 0;

  for (;;) {
  if (level.pausing_bot_connect_monitor) {
  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(var_02);
  continue;
  }

  var_03 = isdefined(level.bots_ignore_team_balance) || !level.teambased;
  var_04 = botgetteamlimit(0);
  var_05 = botgetteamlimit(1);

  if (level.rankedmatch) {
  var_06 = "default";
  var_07 = "default";
  } else {
  var_06 = botgetteamdifficulty(0);
  var_07 = botgetteamdifficulty(1);
  }

  var_08 = "allies";
  var_09 = "axis";
  var_10 = bot_client_counts();
  var_11 = cat_array_get(var_10, "humans");

  if (var_11 > 1) {
  var_12 = bot_get_host_team();

  if (!scripts\mp\utility\game::matchmakinggame() && isdefined(var_12) && var_12 != "spectator") {
  var_08 = var_12;
  var_09 = scripts\mp\utility\game::getotherteam(var_12);
  } else {
  var_13 = cat_array_get(var_10, "humans_allies");
  var_14 = cat_array_get(var_10, "humans_axis");

  if (var_14 > var_13) {
  var_08 = "axis";
  var_09 = "allies";
  }
  }
  } else {
  var_15 = get_human_player();

  if (isdefined(var_15)) {
  var_16 = var_15 bot_get_player_team();

  if (isdefined(var_16) && var_16 != "spectator") {
  var_08 = var_16;
  var_09 = scripts\mp\utility\game::getotherteam(var_16);
  }
  }
  }

  var_17 = scripts\mp\bots\bots_util::bot_get_team_limit();
  var_18 = scripts\mp\bots\bots_util::bot_get_team_limit();

  if (var_17 + var_18 < scripts\mp\bots\bots_util::bot_get_client_limit()) {
  if (var_17 < var_04)
  var_17++;
  else if (var_18 < var_05)
  var_18++;
  }

  var_19 = cat_array_get(var_10, "humans_" + var_08);
  var_20 = cat_array_get(var_10, "humans_" + var_09);
  var_21 = var_19 + var_20;
  var_22 = cat_array_get(var_10, "spectator");
  var_23 = 0;

  for (var_24 = 0; var_22 > 0; var_22--) {
  var_25 = var_19 + var_23 + 1 <= var_17;
  var_26 = var_20 + var_24 + 1 <= var_18;

  if (var_25 && !var_26) {
  var_23++;
  continue;
  }

  if (!var_25 && var_26) {
  var_24++;
  continue;
  }

  if (var_25 && var_26) {
  if (var_22 % 2 == 1) {
  var_23++;
  continue;
  }

  var_24++;
  }
  }

  var_27 = cat_array_get(var_10, "bots_" + var_08);
  var_28 = cat_array_get(var_10, "bots_" + var_09);
  var_29 = var_27 + var_28;

  if (var_29 > 0)
  level.bot_cm_spawned_bots = 1;

  var_30 = 0;

  if (!level.bot_cm_human_picked) {
  var_30 = !bot_get_human_picked_team();

  if (!var_30)
  level.bot_cm_human_picked = 1;
  }

  if (var_30) {
  var_31 = !getdvarint("systemlink") && !getdvarint("onlinegame");
  var_32 = !var_03 && var_05 != var_04 && !level.bot_cm_spawned_bots && (level.bot_cm_waited_players_time < 10 || !scripts\mp\utility\game::gameflag("prematch_done"));

  if (var_31 || var_32) {
  level.bot_cm_waited_players_time = level.bot_cm_waited_players_time + var_02;
  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(var_02);
  continue;
  }
  }

  var_33 = int(min(var_17 - var_19 - var_23, var_04));
  var_34 = int(min(var_18 - var_20 - var_24, var_05));
  var_35 = 1;
  var_36 = var_33 + var_34 + var_11;
  var_37 = var_04 + var_05 + var_11;

  for (var_38 = [-1, -1]; var_36 < scripts\mp\bots\bots_util::bot_get_client_limit() && var_36 < var_37; var_35 = !var_35) {
  if (var_35 && var_33 < var_04 && bot_can_join_team(var_08))
  var_33++;
  else if (!var_35 && var_34 < var_05 && bot_can_join_team(var_09))
  var_34++;

  var_36 = var_33 + var_34 + var_11;

  if (var_38[var_35] == var_36)
  break;

  var_38[var_35] = var_36;
  }

  if (var_04 == var_05 && !var_03 && var_23 == 1 && var_24 == 0 && var_34 > 0) {
  if (!isdefined(level.bot_prematchdonetime) && scripts\mp\utility\game::gameflag("prematch_done"))
  level.bot_prematchdonetime = gettime();

  if (var_30 && (!isdefined(level.bot_prematchdonetime) || gettime() - level.bot_prematchdonetime < 10000))
  var_34--;
  }

  var_39 = var_33 - var_27;
  var_40 = var_34 - var_28;
  var_41 = 1;

  if (var_03) {
  var_42 = var_17 + var_18;
  var_43 = var_04 + var_05;
  var_44 = var_19 + var_20;
  var_45 = var_27 + var_28;
  var_46 = int(min(var_42 - var_44, var_43));
  var_47 = var_46 - var_45;

  if (var_47 == 0)
  var_41 = 0;
  else if (var_47 > 0) {
  var_39 = int(var_47 / 2) + var_47 % 2;
  var_40 = int(var_47 / 2);
  }
  else if (var_47 < 0) {
  var_48 = var_47 * -1;
  var_39 = -1 * int(min(var_48, var_27));
  var_40 = -1 * (var_48 + var_39);
  }
  }
  else if (!scripts\mp\utility\game::matchmakinggame() && (var_39 * var_40 < 0 && scripts\mp\utility\game::gameflag("prematch_done") && !isdefined(level.bots_disable_team_switching))) {
  var_49 = int(min(abs(var_39), abs(var_40)));

  if (var_39 > 0)
  move_bots_from_team_to_team(var_49, var_09, var_08, var_06);
  else if (var_40 > 0)
  move_bots_from_team_to_team(var_49, var_08, var_09, var_07);

  var_41 = 0;
  }

  if (var_41) {
  if (var_40 < 0)
  drop_bots(var_40 * -1, var_09);

  if (var_39 < 0)
  drop_bots(var_39 * -1, var_08);

  if (var_40 > 0)
  level thread spawn_bots(var_40, var_09, undefined, undefined, "spawned_enemies", var_07);

  if (var_39 > 0)
  level thread spawn_bots(var_39, var_08, undefined, undefined, "spawned_allies", var_06);

  if (var_40 > 0 && var_39 > 0)
  level scripts\engine\utility::waittill_multiple("spawned_enemies", "spawned_allies");
  else if (var_40 > 0)
  level waittill("spawned_enemies");
  else if (var_39 > 0)
  level waittill("spawned_allies");
  }

  if (var_07 != var_06) {
  bots_update_difficulty(var_09, var_07);
  bots_update_difficulty(var_08, var_06);
  }

  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(var_02);
  }
}

bot_get_player_team() {
  if (isdefined(self.team))
  return self.team;

  if (isdefined(self.pers["team"]))
  return self.pers["team"];

  return undefined;
}

bot_get_host_team() {
  foreach (var_01 in level.players) {
  if (!isai(var_01) && var_01 ishost())
  return var_01 bot_get_player_team();
  }

  return "spectator";
}

bot_get_human_picked_team() {
  var_00 = 0;
  var_01 = 0;
  var_02 = 0;

  foreach (var_04 in level.players) {
  if (!isai(var_04)) {
  if (var_04 ishost())
  var_00 = 1;

  if (player_picked_team(var_04)) {
  var_01 = 1;

  if (var_04 ishost())
  var_02 = 1;
  }
  }
  }

  return var_02 || var_01 && !var_00;
}

player_picked_team(var_00) {
  if (isdefined(var_0.team) && var_0.team != "spectator")
  return 1;

  if (isdefined(var_0.spectating_actively) && var_0.spectating_actively)
  return 1;

  if (var_00 ismlgspectator() && isdefined(var_0.team) && var_0.team == "spectator")
  return 1;

  return 0;
}

bot_client_counts() {
  var_00 = [];

  for (var_01 = 0; var_01 < level.players.size; var_1++) {
  var_02 = level.players[var_01];

  if (isdefined(var_02) && isdefined(var_2.team)) {
  var_00 = cat_array_add(var_00, "all");
  var_00 = cat_array_add(var_00, var_2.team);

  if (isbot(var_02)) {
  var_00 = cat_array_add(var_00, "bots");
  var_00 = cat_array_add(var_00, "bots_" + var_2.team);
  continue;
  }

  var_00 = cat_array_add(var_00, "humans");
  var_00 = cat_array_add(var_00, "humans_" + var_2.team);
  }
  }

  return var_00;
}

cat_array_add(var_00, var_01) {
  if (!isdefined(var_00))
  var_00 = [];

  if (!isdefined(var_0[var_01]))
  var_0[var_01] = 0;

  var_0[var_01] = var_0[var_01] + 1;
  return var_00;
}

cat_array_get(var_00, var_01) {
  if (!isdefined(var_00))
  return 0;

  if (!isdefined(var_0[var_01]))
  return 0;

  return var_0[var_01];
}

move_bots_from_team_to_team(var_00, var_01, var_02, var_03) {
  foreach (var_05 in level.players) {
  if (!isdefined(var_5.team))
  continue;

  if (isdefined(var_5.connected) && var_5.connected && isbot(var_05) && var_5.team == var_01) {
  var_5.bot_team = var_02;

  if (isdefined(var_03))
  var_05 scripts\mp\bots\bots_util::bot_set_difficulty(var_03);

  var_05 notify("luinotifyserver", "team_select", bot_lui_convert_team_to_int(var_02));
  wait 0.05;
  var_05 notify("luinotifyserver", "class_select", var_5.bot_class);
  var_0--;

  if (var_00 <= 0)
  break;
  else
  wait 0.1;
  }
  }
}

bots_update_difficulty(var_00, var_01) {
  foreach (var_03 in level.players) {
  if (!isdefined(var_3.team))
  continue;

  if (isdefined(var_3.connected) && var_3.connected && isbot(var_03) && var_3.team == var_00) {
  if (var_01 != var_03 botgetdifficulty())
  var_03 scripts\mp\bots\bots_util::bot_set_difficulty(var_01);
  }
  }
}

bot_drop() {
  kick(self.entity_number, "EXE_PLAYERKICKED_BOT_BALANCE");
  wait 0.1;
}

drop_bots(var_00, var_01) {
  var_02 = [];

  foreach (var_04 in level.players) {
  if (isdefined(var_4.connected) && var_4.connected && isbot(var_04) && (!isdefined(var_01) || isdefined(var_4.team) && var_4.team == var_01))
  var_2[var_2.size] = var_04;
  }

  for (var_06 = var_2.size - 1; var_06 >= 0; var_6--) {
  if (var_00 <= 0)
  break;

  if (!scripts\mp\utility\game::isreallyalive(var_2[var_06])) {
  var_2[var_06] bot_drop();
  var_02 = scripts\engine\utility::array_remove(var_02, var_2[var_06]);
  var_0--;
  }
  }

  for (var_06 = var_2.size - 1; var_06 >= 0; var_6--) {
  if (var_00 <= 0)
  break;

  var_2[var_06] bot_drop();
  var_0--;
  }
}

bot_lui_convert_team_to_int(var_00) {
  if (var_00 == "axis")
  return 0;
  else if (var_00 == "allies")
  return 1;
  else if (var_00 == "autoassign" || var_00 == "random")
  return 2;
  else
  return 3;
}

spawn_bot_latent(var_00, var_01, var_02) {
  var_03 = gettime() + 60000;

  while (!self canspawntestclient()) {
  if (gettime() >= var_03) {
  kick(self.entity_number, "EXE_PLAYERKICKED_BOT_BALANCE");
  var_2.abort = 1;
  return;
  }

  wait 0.05;

  if (!isdefined(self)) {
  var_2.abort = 1;
  return;
  }
  }

  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(randomfloatrange(0.25, 2.0));

  if (!isdefined(self)) {
  var_2.abort = 1;
  return;
  }

  self spawntestclient();
  self.pers["isBot"] = 1;
  self.equipment_enabled = 1;
  self.bot_team = var_00;

  if (isdefined(var_2.difficulty))
  scripts\mp\bots\bots_util::bot_set_difficulty(var_2.difficulty);

  if (isdefined(var_01))
  self [[var_01]]();

  self thread [[level.bot_funcs["think"]]]();
  var_2.ready = 1;
}

find_squad_member_index(var_00, var_01) {
  var_02 = 0;
  var_03 = 0;
  var_04 = 0;

  while (var_04 < 10) {
  var_03 = 0;
  var_05 = var_00 getrankedplayerdata("mp", "squadHQ", "aiSquadMembers", var_04);

  if (var_05 == var_02) {
  var_4++;
  continue;
  }

  if (!isdefined(level.human_team_bot_added) || !isdefined(level.human_team_bot_added[var_05]) || level.human_team_bot_added[var_05] == 0)
  return var_05;

  var_4++;
  }

  return -1;
}

spawn_bots(var_00, var_01, var_02, var_03, var_04, var_05) {
  var_06 = gettime() + 10000;
  var_07 = [];
  var_08 = var_7.size;

  while (level.players.size < scripts\mp\bots\bots_util::bot_get_client_limit() && var_7.size < var_00 && gettime() < var_06) {
  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(0.05);
  var_09 = undefined;

  if (isbotmatchmakingenabled()) {
  if (level.teambased)
  var_09 = addmpbottoteam(var_01);
  else
  var_09 = addmpbottoteam("none");
  }
  else
  var_09 = addbot("", 0, 0, 0);

  if (!isdefined(var_09)) {
  if (isdefined(var_03) && var_03) {
  if (isdefined(var_04))
  self notify(var_04);

  return;
  }

  scripts\mp\hostmigration::waitlongdurationwithhostmigrationpause(1);
  continue;
  } else {
  var_10 = spawnstruct();
  var_10.bot = var_09;
  var_10.ready = 0;
  var_10.abort = 0;
  var_10.index = var_08;
  var_10.difficulty = var_05;
  var_7[var_7.size] = var_10;
  var_10.bot thread spawn_bot_latent(var_01, var_02, var_10);
  var_8++;
  }
  }

  var_11 = 0;
  var_06 = gettime() + 60000;

  while (var_11 < var_7.size && gettime() < var_06) {
  var_11 = 0;

  foreach (var_10 in var_07) {
  if (var_10.ready || var_10.abort)
  var_11++;
  }

  wait 0.05;
  }

  if (isdefined(var_04))
  self notify(var_04);
}

bot_gametype_chooses_team() {
  if (!level.teambased)
  return 1;

  if (isdefined(level.bots_gametype_handles_team_choice) && level.bots_gametype_handles_team_choice)
  return 1;

  return 0;
}

bot_gametype_chooses_class() {
  return isdefined(level.bots_gametype_handles_class_choice) && level.bots_gametype_handles_class_choice;
}

bot_is_ready_to_spawn() {
  if (!isdefined(self.classcallback))
  return 0;

  return 1;
}

bot_think() {
  self notify("bot_think");
  self endon("bot_think");
  self endon("disconnect");

  while (!isdefined(self.pers["team"]))
  wait 0.05;

  level.hasbots = 1;

  if (bot_gametype_chooses_team())
  self.bot_team = self.pers["team"];

  var_00 = self.bot_team;

  if (!isdefined(var_00))
  var_00 = self.pers["team"];

  scripts\mp\bots\bots_killstreaks::bot_killstreak_setup();
  self.entity_number = self getentitynumber();
  var_01 = 0;

  if (!isdefined(self.bot_spawned_before)) {
  var_01 = 1;
  self.bot_spawned_before = 1;

  if (!bot_gametype_chooses_team()) {
  self notify("luinotifyserver", "team_select", bot_lui_convert_team_to_int(var_00));
  wait 0.5;

  if (self.pers["team"] == "spectator") {
  bot_drop();
  return;
  }
  }
  }

  for (;;) {
  scripts\mp\bots\bots_util::bot_set_difficulty(self botgetdifficulty());
  var_02 = self botgetdifficultysetting("advancedPersonality");

  if (var_01 && isdefined(var_02) && var_02 != 0)
  scripts\mp\bots\bots_personality::bot_balance_personality();

  scripts\mp\bots\bots_personality::bot_assign_personality_functions();

  if (var_01) {
  bot_set_loadout_class();

  if (!bot_gametype_chooses_class())
  self notify("luinotifyserver", "class_select", self.bot_class);

  if (self.health == 0) {
  self.bwaitingforteamselect = 1;
  self notify("bot_ready_to_spawn");
  self waittill("spawned_player");
  self.bwaitingforteamselect = undefined;
  self.bot_team = var_00;
  }

  if (isdefined(level.bot_funcs) && isdefined(level.bot_funcs["know_enemies_on_start"]))
  self thread [[level.bot_funcs["know_enemies_on_start"]]]();

  var_01 = 0;
  }

  bot_restart_think_threads();
  wait 0.1;
  self waittill("death");
  respawn_watcher();
  self waittill("spawned_player");
  }
}

respawn_watcher() {
  self endon("started_spawnPlayer");

  while (!self.waitingtospawn)
  wait 0.05;

  if (scripts\mp\playerlogic::needsbuttontorespawn()) {
  while (self.waitingtospawn) {
  if (self.sessionstate == "spectator") {
  if (getdvarint("numlives") == 0 || self.pers["lives"] > 0)
  self botpressbutton("use", 0.5);
  }

  wait 1.0;
  }
  }
}

bot_get_rank_xp() {
  if (scripts\mp\utility\game::bot_israndom() == 0) {
  if (!isdefined(self.pers["rankxp"]))
  self.pers["rankxp"] = 0;

  return self.pers["rankxp"];
  }

  var_00 = self botgetdifficulty();
  var_01 = "bot_rank_" + var_00;

  if (isdefined(self.pers[var_01]) && self.pers[var_01] > 0)
  return self.pers[var_01];

  var_02 = bot_random_ranks_for_difficulty(var_00);
  var_03 = var_2["rank"];
  var_04 = var_2["prestige"];
  var_05 = scripts\mp\rank::getrankinfominxp(var_03);
  var_06 = var_05 + scripts\mp\rank::getrankinfoxpamt(var_03);
  var_07 = randomintrange(var_05, var_06 + 1);
  self.pers[var_01] = var_07;
  return var_07;
}

bot_3d_sighting_model(var_00) {
  thread bot_3d_sighting_model_thread(var_00);
}

bot_3d_sighting_model_thread(var_00) {
  var_00 endon("disconnect");
  self endon("disconnect");
  level endon("game_ended");

  for (;;) {
  if (isalive(self) && !self botcanseeentity(var_00) && scripts\engine\utility::within_fov(self.origin, self.angles, var_0.origin, self botgetfovdot()))
  self botgetimperfectenemyinfo(var_00, var_0.origin);

  wait 0.1;
  }
}

bot_random_ranks_for_difficulty(var_00) {
  var_01 = [];
  var_1["rank"] = 0;
  var_1["prestige"] = 0;

  if (var_00 == "default")
  return var_01;

  if (!isdefined(level.bot_rnd_rank)) {
  level.bot_rnd_rank = [];
  level.bot_rnd_rank["recruit"][0] = 0;
  level.bot_rnd_rank["recruit"][1] = 5;
  level.bot_rnd_rank["regular"][0] = 6;
  level.bot_rnd_rank["regular"][1] = 9;
  level.bot_rnd_rank["hardened"][0] = 10;
  level.bot_rnd_rank["hardened"][1] = 19;
  level.bot_rnd_rank["veteran"][0] = 20;
  level.bot_rnd_rank["veteran"][1] = 29;
  }

  if (!isdefined(level.bot_rnd_prestige)) {
  level.bot_rnd_prestige = [];
  level.bot_rnd_prestige["recruit"][0] = 0;
  level.bot_rnd_prestige["recruit"][1] = 0;
  level.bot_rnd_prestige["regular"][0] = 0;
  level.bot_rnd_prestige["regular"][1] = 0;
  level.bot_rnd_prestige["hardened"][0] = 0;
  level.bot_rnd_prestige["hardened"][1] = 0;
  level.bot_rnd_prestige["veteran"][0] = 0;
  level.bot_rnd_prestige["veteran"][1] = 9;
  }

  if (isdefined(level.bot_rnd_rank[var_00][0]) && isdefined(level.bot_rnd_rank[var_00][1]))
  var_1["rank"] = randomintrange(level.bot_rnd_rank[var_00][0], level.bot_rnd_rank[var_00][1] + 1);

  if (isdefined(level.bot_rnd_prestige[var_00][0]) && isdefined(level.bot_rnd_prestige[var_00][1]))
  var_1["prestige"] = randomintrange(level.bot_rnd_prestige[var_00][0], level.bot_rnd_prestige[var_00][1] + 1);

  return var_01;
}

crate_can_use_always(var_00) {
  if (isagent(self) && !isdefined(var_0.boxtype))
  return 0;

  if (isdefined(var_0.cratetype) && !scripts\mp\bots\bots_killstreaks::bot_is_killstreak_supported(var_0.cratetype))
  return 0;

  return 1;
}

get_human_player() {
  var_00 = undefined;
  var_01 = getentarray("player", "classname");

  if (isdefined(var_01)) {
  for (var_02 = 0; var_02 < var_1.size; var_2++) {
  if (isdefined(var_1[var_02]) && isdefined(var_1[var_02].connected) && var_1[var_02].connected && !isai(var_1[var_02]) && (!isdefined(var_00) || var_0.team == "spectator"))
  var_00 = var_1[var_02];
  }
  }

  return var_00;
}

bot_damage_callback(var_00, var_01, var_02, var_03, var_04, var_05) {
  if (!isdefined(self) || !isalive(self))
  return;

  if (var_02 == "MOD_FALLING" || var_02 == "MOD_SUICIDE")
  return;

  if (var_01 <= 0)
  return;

  if (!isdefined(var_04)) {
  if (!isdefined(var_00))
  return;

  var_04 = var_00;
  }

  if (isdefined(var_04)) {
  if (isdefined(self.fnbotdamagecallback))
  self [[self.fnbotdamagecallback]](var_00, var_01, var_02, var_03, var_04, var_05);

  if (level.teambased) {
  if (isdefined(var_4.team) && var_4.team == self.team)
  return;
  else if (isdefined(var_00) && isdefined(var_0.team) && var_0.team == self.team)
  return;
  }

  var_06 = scripts\mp\bots\bots_util::bot_get_known_attacker(var_00, var_04);

  if (isdefined(var_06))
  self botsetattacker(var_06);
  }
}

on_bot_killed(var_00, var_01, var_02, var_03, var_04, var_05, var_06, var_07, var_08, var_09) {
  self botclearscriptenemy();
  self botclearscriptgoal();
  var_10 = scripts\mp\bots\bots_util::bot_get_known_attacker(var_01, var_00);

  if (!scripts\mp\utility\game::bot_is_fireteam_mode() && isdefined(var_10) && var_10.classname == "script_vehicle" && isdefined(var_10.helitype)) {
  var_11 = self botgetdifficultysetting("launcherRespawnChance");

  if (randomfloat(1.0) < var_11)
  self.respawn_with_launcher = 1;
  }
}

bot_should_do_killcam() {
  if (scripts\mp\utility\game::bot_is_fireteam_mode())
  return 0;

  var_00 = 0.0;
  var_01 = self botgetdifficulty();

  if (var_01 == "recruit")
  var_00 = 0.1;
  else if (var_01 == "regular")
  var_00 = 0.4;
  else if (var_01 == "hardened")
  var_00 = 0.7;
  else if (var_01 == "veteran")
  var_00 = 1.0;

  return randomfloat(1.0) < 1.0 - var_00;
}

bot_should_pickup_weapons() {
  if (scripts\mp\utility\game::isjuggernaut())
  return 0;

  return 1;
}

bot_restart_think_threads() {
  thread bot_think_watch_enemy();
  thread scripts\mp\bots\bots_strategy::bot_think_tactical_goals();
  self thread [[level.bot_funcs["dropped_weapon_think"]]]();
  thread bot_think_level_acrtions();
  thread bot_think_crate();
  thread scripts\mp\bots\bots_supers::bot_think_supers();
  thread scripts\mp\bots\bots_powers::bot_think_powers();
  thread bot_think_crate_blocking_path();
  thread scripts\mp\bots\bots_killstreaks::bot_think_killstreak();
  thread scripts\mp\bots\bots_killstreaks::bot_think_watch_aerial_killstreak();
  thread bot_think_gametype();
}

bot_think_watch_enemy(var_00) {
  var_01 = "spawned_player";

  if (isdefined(var_00) && var_00)
  var_01 = "death";

  self notify("bot_think_watch_enemy");
  self endon("bot_think_watch_enemy");
  self endon(var_01);
  self endon("disconnect");
  level endon("game_ended");
  self.last_enemy_sight_time = gettime();

  for (;;) {
  if (isdefined(self.enemy)) {
  if (self botcanseeentity(self.enemy))
  self.last_enemy_sight_time = gettime();
  }

  wait 0.05;
  }
}

bot_think_seek_dropped_weapons() {
  self notify("bot_think_seek_dropped_weapons");
  self endon("bot_think_seek_dropped_weapons");
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");
  var_00 = "throwingknife_mp";

  for (;;) {
  var_01 = 0;

  if (scripts\mp\bots\bots_util::bot_out_of_ammo() && self [[level.bot_funcs["should_pickup_weapons"]]]() && !scripts\mp\bots\bots_util::bot_is_remote_or_linked()) {
  var_02 = getentarray("dropped_weapon", "targetname");
  var_03 = scripts\engine\utility::get_array_of_closest(self.origin, var_02);

  if (var_3.size > 0) {
  var_04 = var_3[0];
  bot_seek_dropped_weapon(var_04);
  }
  }

  if (!scripts\mp\bots\bots_util::bot_in_combat() && !scripts\mp\bots\bots_util::bot_is_remote_or_linked() && self botgetdifficultysetting("strategyLevel") > 0) {
  var_05 = self hasweapon(var_00);
  var_06 = var_05 && self getammocount(var_00) == 0;

  if (var_06) {
  if (isdefined(self.going_for_knife)) {
  wait 5.0;
  continue;
  }

  var_07 = getentarray("dropped_knife", "targetname");
  var_08 = scripts\engine\utility::get_array_of_closest(self.origin, var_07);

  foreach (var_10 in var_08) {
  if (!isdefined(var_10))
  continue;

  if (!isdefined(var_10.calculated_closest_point)) {
  var_11 = scripts\mp\bots\bots_util::bot_queued_process("BotGetClosestNavigablePoint", scripts\mp\bots\bots_util::func_bot_get_closest_navigable_point, var_10.origin, 32, self);

  if (isdefined(var_10)) {
  var_10.closest_point_on_grid = var_11;
  var_10.calculated_closest_point = 1;
  }
  else
  continue;
  }

  if (isdefined(var_10.closest_point_on_grid)) {
  self.going_for_knife = 1;
  bot_seek_dropped_weapon(var_10);
  }
  }
  }
  else if (var_05)
  self.going_for_knife = undefined;
  }

  wait(randomfloatrange(0.25, 0.75));
  }
}

bot_seek_dropped_weapon(var_00) {
  if (scripts\mp\bots\bots_strategy::bot_has_tactical_goal("seek_dropped_weapon", var_00) == 0) {
  var_01 = undefined;

  if (var_0.targetname == "dropped_weapon") {
  var_02 = 1;
  var_03 = self getweaponslistprimaries();

  foreach (var_05 in var_03) {
  if (var_0.model == getweaponmodel(var_05))
  var_02 = 0;
  }

  if (var_02)
  var_01 = ::bot_pickup_weapon;
  }

  var_07 = spawnstruct();
  var_7.object = var_00;
  var_7.script_goal_radius = 12;
  var_7.should_abort = level.bot_funcs["dropped_weapon_cancel"];
  var_7.action_thread = var_01;
  scripts\mp\bots\bots_strategy::bot_new_tactical_goal("seek_dropped_weapon", var_0.origin, 100, var_07);
  }
}

bot_pickup_weapon(var_00) {
  self botpressbutton("use", 2);
  wait 2;
}

should_stop_seeking_weapon(var_00) {
  if (!isdefined(var_0.object))
  return 1;

  if (var_0.object.targetname == "dropped_weapon") {
  if (scripts\mp\bots\bots_util::bot_get_total_gun_ammo() > 0)
  return 1;
  }
  else if (var_0.object.targetname == "dropped_knife") {
  if (scripts\mp\bots\bots_util::bot_in_combat()) {
  self.going_for_knife = undefined;
  return 1;
  }
  }

  return 0;
}

bot_think_level_acrtions(var_00) {
  self notify("bot_think_level_actions");
  self endon("bot_think_level_actions");
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");

  for (;;) {
  scripts\engine\utility::waittill_notify_or_timeout("calculate_new_level_targets", randomfloatrange(2, 10));

  if (!isdefined(level.level_specific_bot_targets) || level.level_specific_bot_targets.size == 0)
  continue;

  if (scripts\mp\bots\bots_strategy::bot_has_tactical_goal("map_interactive_object"))
  continue;

  if (scripts\mp\bots\bots_util::bot_in_combat() || scripts\mp\bots\bots_util::bot_is_remote_or_linked())
  continue;

  var_01 = undefined;

  foreach (var_03 in level.level_specific_bot_targets) {
  if (scripts\engine\utility::array_contains(var_3.high_priority_for, self)) {
  var_01 = var_03;
  break;
  }
  }

  if (!isdefined(var_01)) {
  if (randomint(100) > 25)
  continue;

  var_05 = scripts\engine\utility::get_array_of_closest(self.origin, level.level_specific_bot_targets);
  var_06 = 256;

  if (isdefined(var_00))
  var_06 = var_00;
  else if (self botgetscriptgoaltype() == "hunt" && self botpursuingscriptgoal())
  var_06 = 512;

  if (distancesquared(self.origin, var_5[0].origin) > var_06 * var_06)
  continue;

  var_01 = var_5[0];
  }

  var_07 = 0;

  if (var_1.bot_interaction_type == "damage") {
  var_07 = bot_should_melee_level_damage_target(var_01);

  if (var_07) {
  var_08 = var_1.origin[2] - (var_1.bot_targets[0].origin[2] + 55);
  var_09 = var_1.origin[2] - (var_1.bot_targets[1].origin[2] + 55);

  if (var_08 > 55 && var_09 > 55) {
  if (scripts\engine\utility::array_contains(var_1.high_priority_for, self))
  var_1.high_priority_for = scripts\engine\utility::array_remove(var_1.high_priority_for, self);

  continue;
  }
  }

  var_10 = weaponclass(self getcurrentweapon());

  if (var_10 == "spread") {
  var_11 = var_1.bot_targets[0].origin - var_1.origin;
  var_12 = var_1.bot_targets[1].origin - var_1.origin;
  var_13 = lengthsquared(var_11);
  var_14 = lengthsquared(var_12);

  if (var_13 > 22500 && var_14 > 22500) {
  if (scripts\engine\utility::array_contains(var_1.high_priority_for, self))
  var_1.high_priority_for = scripts\engine\utility::array_remove(var_1.high_priority_for, self);

  continue;
  }
  }
  }

  var_15 = spawnstruct();
  var_15.object = var_01;

  if (var_1.bot_interaction_type == "damage") {
  if (var_07)
  var_15.should_abort = ::level_trigger_should_abort_melee;
  else
  var_15.should_abort = ::level_trigger_should_abort_ranged;
  }

  if (var_1.bot_interaction_type == "use") {
  var_15.action_thread = ::use_use_trigger;
  var_15.should_abort = ::level_trigger_should_abort;
  var_15.script_goal_yaw = vectortoangles(var_1.origin - var_1.bot_target.origin)[1];
  scripts\mp\bots\bots_strategy::bot_new_tactical_goal("map_interactive_object", var_1.bot_target.origin, 10, var_15);
  continue;
  }

  if (var_1.bot_interaction_type == "damage") {
  if (var_07) {
  var_15.action_thread = ::melee_damage_trigger;
  var_15.script_goal_radius = 20;
  } else {
  var_15.action_thread = ::attack_damage_trigger;
  var_15.script_goal_radius = 50;
  }

  var_16 = undefined;
  var_17 = scripts\mp\bots\bots_util::bot_queued_process("GetPathDistLevelAction", scripts\mp\bots\bots_util::func_get_path_dist, self.origin, var_1.bot_targets[0].origin);
  var_18 = scripts\mp\bots\bots_util::bot_queued_process("GetPathDistLevelAction", scripts\mp\bots\bots_util::func_get_path_dist, self.origin, var_1.bot_targets[1].origin);

  if (!isdefined(var_01))
  continue;

  if (var_17 <= 0 && var_18 <= 0)
  continue;

  if (var_17 > 0) {
  if (var_18 < 0 || var_17 <= var_18)
  var_16 = var_1.bot_targets[0];
  }

  if (var_18 > 0) {
  if (var_17 < 0 || var_18 <= var_17)
  var_16 = var_1.bot_targets[1];
  }

  if (!var_07)
  childthread monitor_node_visible(var_16);

  scripts\mp\bots\bots_strategy::bot_new_tactical_goal("map_interactive_object", var_16.origin, 10, var_15);
  }
  }
}

bot_should_melee_level_damage_target(var_00) {
  var_01 = self getcurrentweapon();
  var_02 = scripts\mp\bots\bots_util::bot_out_of_ammo() || self.hasriotshieldequipped || isdefined(self.isjuggernautmaniac) && self.isjuggernautmaniac == 1 || weaponclass(var_01) == "grenade" || scripts\mp\weapons::isknifeonly(var_01);
  return var_02;
}

monitor_node_visible(var_00) {
  self endon("goal");
  wait 0.1;

  for (;;) {
  if (weaponclass(self getcurrentweapon()) == "spread") {
  if (distancesquared(self.origin, var_0.origin) > 90000) {
  wait 0.05;
  continue;
  }
  }

  var_01 = self getnearestnode();

  if (isdefined(var_01)) {
  if (nodesvisible(var_01, var_00)) {
  if (sighttracepassed(self.origin + (0, 0, 55), var_0.origin + (0, 0, 55), 0, self))
  self notify("goal");
  }
  }

  wait 0.05;
  }
}

attack_damage_trigger(var_00) {
  if (var_0.object.origin[2] - self geteye()[2] > 55) {
  if (distance2dsquared(var_0.object.origin, self.origin) < 225)
  return;
  }

  self botsetflag("disable_movement", 1);
  look_at_damage_trigger(var_0.object, 0.3);
  self botpressbutton("ads", 0.3);
  wait 0.25;
  var_01 = gettime();

  while (isdefined(var_0.object) && !isdefined(var_0.object.already_used) && gettime() - var_01 < 5000) {
  look_at_damage_trigger(var_0.object, 0.15);
  self botpressbutton("ads", 0.15);
  self botpressbutton("attack");
  wait 0.1;
  }

  self botsetflag("disable_movement", 0);
}

melee_damage_trigger(var_00) {
  self botsetflag("disable_movement", 1);
  look_at_damage_trigger(var_0.object, 0.3);
  wait 0.25;
  var_01 = gettime();

  while (isdefined(var_0.object) && !isdefined(var_0.object.already_used) && gettime() - var_01 < 5000) {
  look_at_damage_trigger(var_0.object, 0.15);
  self botpressbutton("melee");
  wait 0.1;
  }

  self botsetflag("disable_movement", 0);
}

look_at_damage_trigger(var_00, var_01) {
  var_02 = var_0.origin;

  if (distance2dsquared(self.origin, var_02) < 100)
  var_02 = (var_2[0], var_2[1], self geteye()[2]);

  self botlookatpoint(var_02, var_01, "script_forced");
}

use_use_trigger(var_00) {
  if (isagent(self)) {
  scripts\engine\utility::allow_usability(1);
  var_0.object enableplayeruse(self);
  wait 0.05;
  }

  var_01 = var_0.object.use_time;
  self botpressbutton("use", var_01);
  wait(var_01);

  if (isagent(self)) {
  scripts\engine\utility::allow_usability(0);

  if (isdefined(var_0.object))
  var_0.object disableplayeruse(self);
  }
}

level_trigger_should_abort_melee(var_00) {
  if (level_trigger_should_abort(var_00))
  return 1;

  if (!bot_should_melee_level_damage_target(var_0.object))
  return 1;

  return 0;
}

level_trigger_should_abort_ranged(var_00) {
  if (level_trigger_should_abort(var_00))
  return 1;

  if (bot_should_melee_level_damage_target(var_0.object))
  return 1;

  return 0;
}

level_trigger_should_abort(var_00) {
  if (!isdefined(var_0.object))
  return 1;

  if (isdefined(var_0.object.already_used))
  return 1;

  if (scripts\mp\bots\bots_util::bot_in_combat())
  return 1;

  return 0;
}

crate_in_range(var_00) {
  if (!isdefined(var_0.owner) || var_0.owner != self) {
  if (distancesquared(self.origin, var_0.origin) > 4194304)
  return 0;
  }

  return 1;
}

bot_crate_valid(var_00) {
  if (!isdefined(var_00))
  return 0;

  var_01 = self [[level.bot_funcs["crate_can_use"]]](var_00);

  if (!var_01) {
  if (level.gametype == "grnd")
  var_01 = 1;
  }

  if (!var_01)
  return 0;

  if (!crate_landed_and_on_path_grid(var_00))
  return 0;

  if (level.teambased && isdefined(var_0.bomb) && isdefined(var_0.team) && var_0.team == self.team)
  return 0;

  if (!self [[level.bot_funcs["crate_in_range"]]](var_00))
  return 0;

  if (isdefined(var_0.boxtype)) {
  if (isdefined(level.boxsettings[var_0.boxtype]) && ![[level.boxsettings[var_0.boxtype].canusecallback]]())
  return 0;

  if (isdefined(var_0.disabled_use_for) && isdefined(var_0.disabled_use_for[self getentitynumber()]) && var_0.disabled_use_for[self getentitynumber()])
  return 0;

  if (!self [[level.bot_can_use_box_by_type[var_0.boxtype]]](var_00))
  return 0;
  }

  return isdefined(var_00);
}

crate_landed_and_on_path_grid(var_00) {
  if (!crate_has_landed(var_00))
  return 0;

  if (!crate_is_on_path_grid(var_00))
  return 0;

  return isdefined(var_00);
}

crate_has_landed(var_00) {
  if (isdefined(var_0.boxtype))
  return gettime() > var_0.birthtime + 1000;
  else
  return isdefined(var_0.droppingtoground) && !var_0.droppingtoground;
}

crate_is_on_path_grid(var_00) {
  if (!isdefined(var_0.on_path_grid))
  crate_calculate_on_path_grid(var_00);

  return isdefined(var_00) && var_0.on_path_grid;
}

node_within_use_radius_of_crate(var_00, var_01) {
  if (isdefined(var_1.boxtype) && var_1.boxtype == "scavenger_bag")
  return abs(var_0.origin[0] - var_1.origin[0]) < 36 && abs(var_0.origin[0] - var_1.origin[0]) < 36 && abs(var_0.origin[0] - var_1.origin[0]) < 18;
  else
  {
  var_02 = getdvarfloat("player_useRadius");
  var_03 = distancesquared(var_1.origin, var_0.origin + (0, 0, 40));
  return var_03 <= var_02 * var_02;
  }
}

crate_calculate_on_path_grid(var_00) {
  var_00 thread crate_monitor_position();
  var_0.on_path_grid = 0;
  var_01 = undefined;
  var_02 = undefined;

  if (isdefined(var_0.forcedisconnectuntil)) {
  var_01 = var_0.forcedisconnectuntil;
  var_02 = gettime() + 30000;
  var_0.forcedisconnectuntil = var_02;
  var_00 notify("path_disconnect");
  }

  wait 0.05;

  if (!isdefined(var_00))
  return;

  var_03 = crate_get_nearest_valid_nodes(var_00);

  if (!isdefined(var_00))
  return;

  if (isdefined(var_03) && var_3.size > 0) {
  var_0.nearest_nodes = var_03;
  var_0.on_path_grid = 1;
  } else {
  var_04 = getdvarfloat("player_useRadius");
  var_05 = getnodesinradiussorted(var_0.origin, var_04 * 2, 0)[0];
  var_06 = var_00 getpointinbounds(0, 0, -1);
  var_07 = undefined;

  if (isdefined(var_0.boxtype) && var_0.boxtype == "scavenger_bag") {
  if (scripts\mp\bots\bots_util::bot_point_is_on_pathgrid(var_0.origin))
  var_07 = var_0.origin;
  }
  else
  var_07 = botgetclosestnavigablepoint(var_0.origin, var_04);

  if (isdefined(var_05) && !var_05 nodeisdisconnected() && isdefined(var_07) && abs(var_5.origin[2] - var_6[2]) < 30) {
  var_0.nearest_points = [var_07];
  var_0.nearest_nodes = [var_05];
  var_0.on_path_grid = 1;
  }
  }

  if (isdefined(var_0.forcedisconnectuntil)) {
  if (var_0.forcedisconnectuntil == var_02)
  var_0.forcedisconnectuntil = var_01;
  }
}

crate_get_nearest_valid_nodes(var_00) {
  var_01 = getnodesinradiussorted(var_0.origin, 256, 0);

  for (var_02 = var_1.size; var_02 > 0; var_2--)
  var_1[var_02] = var_1[var_02 - 1];

  var_1[0] = getclosestnodeinsight(var_0.origin);
  var_03 = undefined;

  if (isdefined(var_0.forcedisconnectuntil))
  var_03 = getallnodes();

  var_04 = [];
  var_05 = 1;

  if (!isdefined(var_0.boxtype))
  var_05 = 2;

  for (var_02 = 0; var_02 < var_1.size; var_2++) {
  var_06 = var_1[var_02];

  if (!isdefined(var_06) || !isdefined(var_00))
  continue;

  if (var_06 nodeisdisconnected())
  continue;

  if (!node_within_use_radius_of_crate(var_06, var_00)) {
  if (var_02 == 0)
  continue;
  else
  break;
  }

  wait 0.05;

  if (!isdefined(var_00))
  break;

  if (sighttracepassed(var_0.origin, var_6.origin + (0, 0, 55), 0, var_00)) {
  wait 0.05;

  if (!isdefined(var_00))
  break;

  if (!isdefined(var_0.forcedisconnectuntil)) {
  var_4[var_4.size] = var_06;

  if (var_4.size == var_05)
  return var_04;
  else
  continue;
  }

  var_07 = undefined;
  var_08 = 0;

  while (!isdefined(var_07) && var_08 < 100) {
  var_8++;
  var_09 = scripts\engine\utility::random(var_03);

  if (distancesquared(var_6.origin, var_9.origin) > 250000)
  var_07 = var_09;
  }

  if (isdefined(var_07)) {
  var_10 = scripts\mp\bots\bots_util::bot_queued_process("GetNodesOnPathCrate", scripts\mp\bots\bots_util::func_get_nodes_on_path, var_6.origin, var_7.origin);

  if (isdefined(var_10)) {
  var_4[var_4.size] = var_06;

  if (var_4.size == var_05)
  return var_04;
  else
  continue;
  }
  }
  }
  }

  return undefined;
}

crate_get_bot_target(var_00) {
  if (isdefined(var_0.nearest_points))
  return var_0.nearest_points[0];

  if (isdefined(var_0.nearest_nodes)) {
  if (var_0.nearest_nodes.size > 1) {
  var_01 = scripts\engine\utility::array_reverse(self botnodescoremultiple(var_0.nearest_nodes, "node_exposed"));
  return scripts\engine\utility::random_weight_sorted(var_01).origin;
  }
  else
  return var_0.nearest_nodes[0].origin;
  }
}

crate_get_bot_target_check_distance(var_00, var_01) {
  var_02 = crate_get_bot_target(var_00);
  var_02 = getclosestpointonnavmesh(var_02, self);
  var_03 = var_01 * 0.9;
  var_03 = var_03 * var_03;

  if (distancesquared(var_0.origin, var_02) <= var_03)
  return var_02;
  else
  return undefined;
}

bot_think_crate() {
  self notify("bot_think_crate");
  self endon("bot_think_crate");
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");
  var_00 = getdvarfloat("player_useRadius");

  for (;;) {
  var_01 = randomfloatrange(2, 4);
  scripts\engine\utility::waittill_notify_or_timeout("new_crate_to_take", var_01);

  if (isdefined(self.boxes) && self.boxes.size == 0)
  self.boxes = undefined;

  var_02 = level.carepackages;

  if (!scripts\mp\bots\bots_util::bot_in_combat() && isdefined(self.boxes))
  var_02 = scripts\engine\utility::array_combine(var_02, self.boxes);

  if (isdefined(level.bot_scavenger_bags) && scripts\mp\utility\game::_hasperk("specialty_scavenger"))
  var_02 = scripts\engine\utility::array_combine(var_02, level.bot_scavenger_bags);

  var_02 = scripts\engine\utility::array_removeundefined(var_02);

  if (var_2.size == 0)
  continue;

  if (scripts\mp\bots\bots_strategy::bot_has_tactical_goal("airdrop_crate") || self botgetscriptgoaltype() == "tactical" || scripts\mp\bots\bots_util::bot_is_remote_or_linked())
  continue;

  var_03 = [];

  foreach (var_05 in var_02) {
  if (bot_crate_valid(var_05))
  var_3[var_3.size] = var_05;
  }

  var_03 = scripts\engine\utility::array_remove_duplicates(var_03);

  if (var_3.size == 0)
  continue;

  var_03 = scripts\engine\utility::get_array_of_closest(self.origin, var_03);
  var_07 = self getnearestnode();

  if (!isdefined(var_07))
  continue;

  var_08 = self [[level.bot_funcs["crate_low_ammo_check"]]]();
  var_09 = (var_08 || randomint(100) < 50) && !scripts\mp\killstreaks\emp_common::isemped();
  var_10 = undefined;

  foreach (var_05 in var_03) {
  var_12 = 0;

  if ((!isdefined(var_5.owner) || var_5.owner != self) && !isdefined(var_5.boxtype)) {
  var_13 = [];

  foreach (var_15 in level.players) {
  if (!isdefined(var_15.team))
  continue;

  if (!isai(var_15) && level.teambased && var_15.team == self.team) {
  if (distancesquared(var_15.origin, var_5.origin) < 490000)
  var_13[var_13.size] = var_15;
  }
  }

  if (var_13.size > 0) {
  var_17 = var_13[0] getnearestnode();

  if (isdefined(var_17)) {
  var_12 = 0;

  foreach (var_19 in var_5.nearest_nodes)
  var_12 = var_12 | nodesvisible(var_17, var_19, 1);
  }
  }
  }

  if (!var_12) {
  var_21 = isdefined(var_5.bots) && isdefined(var_5.bots[self.team]) && var_5.bots[self.team] > 0;
  var_22 = 0;

  foreach (var_19 in var_5.nearest_nodes)
  var_22 = var_22 | nodesvisible(var_07, var_19, 1);

  if (var_22 || var_09 && !var_21) {
  var_10 = var_05;
  break;
  }
  }
  }

  if (isdefined(var_10)) {
  if (self [[level.bot_funcs["crate_should_claim"]]]()) {
  if (!isdefined(var_10.boxtype)) {
  if (!isdefined(var_10.bots))
  var_10.bots = [];

  var_10.bots[self.team] = 1;
  }
  }

  var_26 = spawnstruct();
  var_26.object = var_10;
  var_26.start_thread = ::watch_bot_died_during_crate;
  var_26.should_abort = ::crate_picked_up;
  var_27 = undefined;

  if (isdefined(var_10.boxtype)) {
  if (isdefined(var_10.boxtouchonly) && var_10.boxtouchonly) {
  var_26.script_goal_radius = 16;
  var_26.action_thread = undefined;
  var_27 = var_10.origin;
  } else {
  var_26.script_goal_radius = 50;
  var_26.action_thread = ::use_box;
  var_28 = crate_get_bot_target_check_distance(var_10, var_00);

  if (!isdefined(var_28))
  continue;

  var_28 = var_28 - var_10.origin;
  var_29 = length(var_28) * randomfloat(1.0);
  var_27 = var_10.origin + vectornormalize(var_28) * var_29 + (0, 0, 12);
  }
  } else {
  var_26.action_thread = ::use_crate;
  var_26.end_thread = ::stop_using_crate;
  var_27 = crate_get_bot_target_check_distance(var_10, var_00);

  if (!isdefined(var_27))
  continue;

  var_26.script_goal_radius = var_00 - distance(var_10.origin, var_27 + (0, 0, 40));
  var_27 = var_27 + (0, 0, 24);
  }

  if (isdefined(var_26.script_goal_radius)) {}

  var_10 notify("path_disconnect");
  wait 0.05;

  if (!isdefined(var_10))
  continue;

  scripts\mp\bots\bots_strategy::bot_new_tactical_goal("airdrop_crate", var_27, 30, var_26);
  }
  }
}

bot_should_use_ballistic_vest_crate(var_00) {
  return 1;
}

crate_should_claim() {
  return 1;
}

crate_low_ammo_check() {
  return 0;
}

bot_should_use_ammo_crate(var_00) {
  if (self getcurrentweapon() == level.boxsettings[var_0.boxtype].minigunweapon)
  return 0;

  return 1;
}

bot_post_use_ammo_crate(var_00) {
  scripts\mp\utility\game::_switchtoweapon(self.secondaryweapon);
  wait 1.0;
}

bot_post_use_ammo_crate(var_00) {
  scripts\mp\utility\game::_switchtoweapon("none");
  self.secondaryweapon = self getcurrentweapon();
}

bot_should_use_scavenger_bag(var_00) {
  if (scripts\mp\bots\bots_util::bot_get_low_on_ammo(0.66)) {
  var_01 = self getnearestnode();

  if (isdefined(var_0.nearest_nodes) && isdefined(var_0.nearest_nodes[0]) && isdefined(var_01)) {
  if (nodesvisible(var_01, var_0.nearest_nodes[0], 1)) {
  if (scripts\engine\utility::within_fov(self.origin, self.angles, var_0.origin, self botgetfovdot()))
  return 1;
  }
  }
  }

  return 0;
}

bot_should_use_grenade_crate(var_00) {
  var_01 = self getweaponslistall();

  foreach (var_03 in var_01) {
  if (self getweaponammostock(var_03) == 0)
  return 1;
  }

  return 0;
}

bot_should_use_juicebox_crate(var_00) {
  return 1;
}

crate_monitor_position() {
  self notify("crate_monitor_position");
  self endon("crate_monitor_position");
  self endon("death");
  level endon("game_ended");

  for (;;) {
  var_00 = self.origin;
  wait 0.5;

  if (!isalive(self))
  return;

  if (!scripts\mp\bots\bots_util::bot_vectors_are_equal(self.origin, var_00)) {
  self.on_path_grid = undefined;
  self.nearest_nodes = undefined;
  self.nearest_points = undefined;
  }
  }
}

crate_wait_use() {}

crate_picked_up(var_00) {
  if (!isdefined(var_0.object))
  return 1;

  return 0;
}

use_crate(var_00) {
  if (isagent(self)) {
  scripts\engine\utility::allow_usability(1);
  var_0.object enableplayeruse(self);
  wait 0.05;
  }

  self [[level.bot_funcs["crate_wait_use"]]]();

  if (isdefined(var_0.object.owner) && var_0.object.owner == self)
  var_01 = level.crateownerusetime / 1000 + 0.5;
  else
  var_01 = level.cratenonownerusetime / 1000 + 1.0;

  self botpressbutton("use", var_01);
  wait(var_01);

  if (isagent(self)) {
  scripts\engine\utility::allow_usability(0);

  if (isdefined(var_0.object))
  var_0.object disableplayeruse(self);
  }

  if (isdefined(var_0.object)) {
  if (!isdefined(var_0.object.bots_used))
  var_0.object.bots_used = [];

  var_0.object.bots_used[var_0.object.bots_used.size] = self;
  }
}

use_box(var_00) {
  if (isagent(self)) {
  scripts\engine\utility::allow_usability(1);
  var_0.object enableplayeruse(self);
  wait 0.05;
  }

  if (isdefined(var_0.object) && isdefined(var_0.object.boxtype)) {
  var_01 = var_0.object.boxtype;

  if (isdefined(level.bot_pre_use_box_of_type[var_01]))
  self [[level.bot_pre_use_box_of_type[var_01]]](var_0.object);

  if (isdefined(var_0.object)) {
  var_02 = level.boxsettings[var_0.object.boxtype].usetime / 1000 + 0.5;
  self botpressbutton("use", var_02);
  wait(var_02);

  if (isdefined(level.bot_post_use_box_of_type[var_01]))
  self [[level.bot_post_use_box_of_type[var_01]]](var_0.object);
  }
  }

  if (isagent(self)) {
  scripts\engine\utility::allow_usability(0);

  if (isdefined(var_0.object))
  var_0.object disableplayeruse(self);
  }
}

watch_bot_died_during_crate(var_00) {
  thread bot_watch_for_death(var_0.object);
}

stop_using_crate(var_00) {
  if (isdefined(var_0.object))
  var_0.object.bots[self.team] = 0;
}

bot_watch_for_death(var_00) {
  var_00 endon("death");
  var_00 endon("revived");
  var_00 endon("disconnect");
  level endon("game_ended");
  var_01 = self.team;
  scripts\engine\utility::waittill_any("death", "disconnect");

  if (isdefined(var_00))
  var_0.bots[var_01] = 0;
}

bot_think_crate_blocking_path() {
  self notify("bot_think_crate_blocking_path");
  self endon("bot_think_crate_blocking_path");
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");
  var_00 = getdvarfloat("player_useRadius");

  for (;;) {
  wait 3;

  if (self usebuttonpressed())
  continue;

  if (scripts\mp\utility\game::isusingremote())
  continue;

  var_01 = level.carepackages;

  for (var_02 = 0; var_02 < var_1.size; var_2++) {
  var_03 = var_1[var_02];

  if (!isdefined(var_03))
  continue;

  if (distancesquared(self.origin, var_3.origin) < var_00 * var_00) {
  if (var_3.owner == self) {
  self botpressbutton("use", level.crateownerusetime / 1000 + 0.5);
  continue;
  }

  self botpressbutton("use", level.cratenonownerusetime / 1000 + 0.5);
  }
  }
  }
}

bot_think_revive() {
  self notify("bot_think_revive");
  self endon("bot_think_revive");
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");

  if (!level.teambased)
  return;

  for (;;) {
  var_00 = 2.0;
  var_01 = getentarray("revive_trigger", "targetname");

  if (var_1.size > 0)
  var_00 = 0.05;

  level scripts\engine\utility::waittill_notify_or_timeout("player_last_stand", var_00);

  if (!bot_can_revive())
  continue;

  var_01 = getentarray("revive_trigger", "targetname");

  if (var_1.size > 1) {
  var_01 = sortbydistance(var_01, self.origin);

  if (isdefined(self.owner)) {
  for (var_02 = 0; var_02 < var_1.size; var_2++) {
  if (var_1[var_02].owner != self.owner)
  continue;

  if (var_02 == 0)
  break;

  var_03 = var_1[var_02];
  var_1[var_02] = var_1[0];
  var_1[0] = var_03;
  break;
  }
  }
  }

  for (var_02 = 0; var_02 < var_1.size; var_2++) {
  var_04 = var_1[var_02];
  var_05 = var_4.owner;

  if (!isdefined(var_05))
  continue;

  if (var_05 == self)
  continue;

  if (!isalive(var_05))
  continue;

  if (var_5.team != self.team)
  continue;

  if (!isdefined(var_5.inlaststand) || !var_5.inlaststand)
  continue;

  if (isdefined(var_5.bots) && isdefined(var_5.bots[self.team]) && var_5.bots[self.team] > 0)
  continue;

  if (distancesquared(self.origin, var_5.origin) < 4194304) {
  var_06 = spawnstruct();
  var_6.object = var_04;
  var_6.script_goal_radius = 64;

  if (isdefined(self.last_revive_fail_time) && gettime() - self.last_revive_fail_time < 1000)
  var_6.script_goal_radius = 32;

  var_6.start_thread = ::watch_bot_died_during_revive;
  var_6.end_thread = ::stop_reviving;
  var_6.should_abort = ::player_revived_or_dead;
  var_6.action_thread = ::revive_player;
  scripts\mp\bots\bots_strategy::bot_new_tactical_goal("revive", var_5.origin, 60, var_06);
  break;
  }
  }
  }
}

watch_bot_died_during_revive(var_00) {
  thread bot_watch_for_death(var_0.object.owner);
}

stop_reviving(var_00) {
  if (isdefined(var_0.object.owner))
  var_0.object.owner.bots[self.team] = 0;
}

player_revived_or_dead(var_00) {
  if (!isdefined(var_0.object.owner) || var_0.object.owner.health <= 0)
  return 1;

  if (!isdefined(var_0.object.owner.inlaststand) || !var_0.object.owner.inlaststand)
  return 1;

  return 0;
}

revive_player(var_00) {
  if (distancesquared(self.origin, var_0.object.owner.origin) > 4096) {
  self.last_revive_fail_time = gettime();
  return;
  }

  if (isagent(self)) {
  scripts\engine\utility::allow_usability(1);
  var_0.object enableplayeruse(self);
  wait 0.05;
  }

  var_01 = self.team;
  self botpressbutton("use", level.laststandrevivetimer / 1000 + 0.5);
  wait(level.laststandrevivetimer / 1000 + 1.5);

  if (isdefined(var_0.object.owner))
  var_0.object.bots[var_01] = 0;

  if (isagent(self)) {
  scripts\engine\utility::allow_usability(0);

  if (isdefined(var_0.object))
  var_0.object disableplayeruse(self);
  }
}

bot_can_revive() {
  if (isdefined(self.laststand) && self.laststand == 1)
  return 0;

  if (scripts\mp\bots\bots_strategy::bot_has_tactical_goal("revive"))
  return 0;

  if (scripts\mp\bots\bots_util::bot_is_remote_or_linked())
  return 0;

  if (scripts\mp\bots\bots_util::bot_is_bodyguarding())
  return 1;

  var_00 = self botgetscriptgoaltype();

  if (var_00 == "none" || var_00 == "hunt" || var_00 == "guard")
  return 1;

  return 0;
}

revive_watch_for_finished(var_00) {
  self endon("death");
  self endon("disconnect");
  self endon("bad_path");
  self endon("goal");
  var_00 scripts\engine\utility::waittill_any("death", "revived");
  self notify("bad_path");
}

bot_know_enemies_on_start() {
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");

  if (gettime() > 15000)
  return;

  while (!scripts\mp\utility\game::gamehasstarted() || !scripts\mp\utility\game::gameflag("prematch_done"))
  wait 0.05;

  var_00 = undefined;
  var_01 = undefined;

  for (var_02 = 0; var_02 < level.players.size; var_2++) {
  var_03 = level.players[var_02];

  if (isdefined(var_03) && isdefined(self.team) && isdefined(var_3.team) && isenemyteam(self.team, var_3.team)) {
  if (!isdefined(var_3.bot_start_known_by_enemy))
  var_00 = var_03;

  if (isai(var_03) && !isdefined(var_3.bot_start_know_enemy))
  var_01 = var_03;
  }
  }

  if (isdefined(var_00)) {
  self.bot_start_know_enemy = 1;
  var_0.bot_start_known_by_enemy = 1;
  self getenemyinfo(var_00);
  }

  if (isdefined(var_01)) {
  var_1.bot_start_know_enemy = 1;
  self.bot_start_known_by_enemy = 1;
  var_01 getenemyinfo(self);
  }
}

bot_make_entity_sentient(var_00, var_01) {
  if (isdefined(var_01))
  return self makeentitysentient(var_00, var_01);
  else
  return self makeentitysentient(var_00);
}

bot_think_gametype() {
  self notify("bot_think_gametype");
  self endon("bot_think_gametype");
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");
  scripts\mp\utility\game::gameflagwait("prematch_done");
  self thread [[level.bot_funcs["gametype_think"]]]();
}

default_gametype_think() {}

monitor_smoke_grenades() {
  for (;;) {
  level waittill("smoke", var_00, var_01);

  if (var_01 == "smoke_grenade_mp")
  var_00 thread monitor_smoke_grenade();
  }
}

monitor_smoke_grenade() {
  self endon("late_death");
  thread smoke_grenade_late_death();
  self waittill("explode", var_00);
  wait 1;
  var_01 = spawn("script_model", var_00);
  var_01 show();
  var_02 = getent("smoke_grenade_sight_clip_256", "targetname");

  if (isdefined(var_02))
  var_01 clonebrushmodeltoscriptmodel(var_02);

  wait 9.25;
  var_01 delete();
}

smoke_grenade_late_death() {
  self endon("explode");
  self waittill("death");
  waittillframeend;
  self notify("late_death");
}

bot_add_scavenger_bag(var_00) {
  var_01 = 0;
  var_0.boxtype = "scavenger_bag";
  var_0.boxtouchonly = 1;

  if (!isdefined(level.bot_scavenger_bags))
  level.bot_scavenger_bags = [];

  foreach (var_04, var_03 in level.bot_scavenger_bags) {
  if (!isdefined(var_03)) {
  var_01 = 1;
  level.bot_scavenger_bags[var_04] = var_00;
  break;
  }
  }

  if (!var_01)
  level.bot_scavenger_bags[level.bot_scavenger_bags.size] = var_00;

  foreach (var_06 in level.participants) {
  if (isai(var_06) && var_06 scripts\mp\utility\game::_hasperk("specialty_scavenger"))
  var_06 notify("new_crate_to_take");
  }
}

bot_triggers() {
  var_00 = getentarray("bot_flag_set", "targetname");

  foreach (var_02 in var_00) {
  if (!isdefined(var_2.script_noteworthy))
  continue;

  var_02 thread bot_flag_trigger(var_2.script_noteworthy);
  }
}

bot_flag_trigger(var_00) {
  self endon("death");

  for (;;) {
  self waittill("trigger", var_01);

  if (scripts\mp\utility\game::isaigameparticipant(var_01)) {
  var_01 notify("flag_trigger_set_" + var_00);
  var_01 botsetflag(var_00, 1);
  var_01 thread bot_flag_trigger_clear(var_00);
  }
  }
}

bot_flag_trigger_clear(var_00) {
  self endon("flag_trigger_set_" + var_00);
  self endon("death");
  self endon("disconnect");
  level endon("game_ended");
  scripts\engine\utility::waitframe();
  waittillframeend;
  self botsetflag(var_00, 0);
}

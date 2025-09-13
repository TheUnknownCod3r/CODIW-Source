/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 2610.gsc
***************************************/

createeffect(var_00, var_01) {
  var_02 = spawnstruct();

  if (!isdefined(level.createfxent))
  level.createfxent = [];

  level.createfxent[level.createfxent.size] = var_02;
  var_2.v = [];
  var_2.v["type"] = var_00;
  var_2.v["fxid"] = var_01;
  var_2.v["angles"] = (0, 0, 0);
  var_2.v["origin"] = (0, 0, 0);
  return var_02;
}

getloopeffectdelaydefault() {
  return 0.5;
}

getoneshoteffectdelaydefault() {
  return -4;
}

getexploderdelaydefault() {
  return 0;
}

getintervalsounddelaymindefault() {
  return 0.75;
}

getintervalsounddelaymaxdefault() {
  return 2;
}

createloopsound() {
  var_00 = spawnstruct();

  if (!isdefined(level.createfxent))
  level.createfxent = [];

  level.createfxent[level.createfxent.size] = var_00;
  var_0.v = [];
  var_0.v["type"] = "soundfx";
  var_0.v["fxid"] = "No FX";
  var_0.v["soundalias"] = "nil";
  var_0.v["angles"] = (0, 0, 0);
  var_0.v["origin"] = (0, 0, 0);
  var_0.v["server_culled"] = 1;

  if (getdvar("serverCulledSounds") != "1")
  var_0.v["server_culled"] = 0;

  return var_00;
}

createintervalsound() {
  var_00 = createloopsound();
  var_0.v["type"] = "soundfx_interval";
  var_0.v["delay_min"] = getintervalsounddelaymindefault();
  var_0.v["delay_max"] = getintervalsounddelaymaxdefault();
  return var_00;
}

createnewexploder() {
  if (!isdefined(level.createfxent))
  level.createfxent = [];

  var_00 = createnewexploder_internal();
  level.createfxent[level.createfxent.size] = var_00;
  return var_00;
}

createnewexploder_internal(var_00) {
  if (!isdefined(var_00)) {
  var_00 = spawnstruct();
  var_0.v = [];
  }

  var_0.v["type"] = "exploder";
  var_0.v["exploder_type"] = "normal";

  if (!isdefined(var_0.v["fxid"]))
  var_0.v["fxid"] = "No FX";

  if (!isdefined(var_0.v["soundalias"]))
  var_0.v["soundalias"] = "nil";

  if (!isdefined(var_0.v["loopsound"]))
  var_0.v["loopsound"] = "nil";

  if (!isdefined(var_0.v["angles"]))
  var_0.v["angles"] = (0, 0, 0);

  if (!isdefined(var_0.v["origin"]))
  var_0.v["origin"] = (0, 0, 0);

  if (!isdefined(var_0.v["exploder"]))
  var_0.v["exploder"] = 1;

  if (!isdefined(var_0.v["flag"]))
  var_0.v["flag"] = "nil";

  if (!isdefined(var_0.v["delay"]) || var_0.v["delay"] < 0)
  var_0.v["delay"] = getexploderdelaydefault();

  return var_00;
}

createexploderex(var_00, var_01) {
  var_02 = scripts\engine\utility::createexploder(var_00);
  var_2.v["exploder"] = var_01;
  return var_02;
}

createreactiveent(var_00) {
  var_01 = spawnstruct();

  if (!isdefined(level.createfxent))
  level.createfxent = [];

  level.createfxent[level.createfxent.size] = var_01;
  var_1.v = [];
  var_1.v["origin"] = (0, 0, 0);
  var_1.v["reactive_radius"] = 350;

  if (isdefined(var_00))
  var_1.v["fxid"] = var_00;
  else
  var_1.v["fxid"] = "No FX";

  var_1.v["type"] = "reactive_fx";
  var_1.v["soundalias"] = "nil";
  return var_01;
}

set_origin_and_angles(var_00, var_01) {
  if (isdefined(level.createfx_offset))
  var_00 = var_00 + level.createfx_offset;

  self.v["origin"] = var_00;
  self.v["angles"] = var_01;
}

set_forward_and_up_vectors() {
  self.v["up"] = anglestoup(self.v["angles"]);
  self.v["forward"] = anglestoforward(self.v["angles"]);
}

createfx_common() {
  precacheshader("black");
  level._createfx = spawnstruct();
  level._createfx.grenade = spawn("script_origin", (0, 0, 0));
  level._createfx.grenade.fx = loadfx("vfx\core\expl\grenadeexp_default");
  level._createfx.grenade.sound = "frag_grenade_explode";
  level._createfx.grenade.radius = 256;
  precachemodel("axis_guide_createfx_rot");
  precachemodel("axis_guide_createfx");
  scripts\engine\utility::flag_init("createfx_saving");
  scripts\engine\utility::flag_init("createfx_started");

  if (!isdefined(level.createfx))
  level.createfx = [];

  level.createfx_loopcounter = 0;
  wait 0.05;
  level notify("createfx_common_done");
}

init_level_variables() {
  level._createfx.selectedmove_up = 0;
  level._createfx.selectedmove_forward = 0;
  level._createfx.selectedmove_right = 0;
  level._createfx.selectedrotate_pitch = 0;
  level._createfx.selectedrotate_roll = 0;
  level._createfx.selectedrotate_yaw = 0;
  level._createfx.selected_fx = [];
  level._createfx.selected_fx_ents = [];
  level._createfx.rate = 1;
  level._createfx.snap2normal = 0;
  level._createfx.snap2angle = 0;
  level._createfx.snap2anglesnaps = [0, 90, 45, 15];
  level._createfx.axismode = 0;
  level._createfx.select_by_name = 0;
  level._createfx.drawaxis = 1;
  level._createfx.player_speed = getdvarfloat("g_speed");
  set_player_speed_hud();
}

init_locked_list() {
  level._createfx.lockedlist = [];
  level._createfx.lockedlist["escape"] = 1;
  level._createfx.lockedlist["BUTTON_LSHLDR"] = 1;
  level._createfx.lockedlist["BUTTON_RSHLDR"] = 1;
  level._createfx.lockedlist["mouse1"] = 1;
  level._createfx.lockedlist["ctrl"] = 1;
}

init_colors() {
  var_00 = [];
  var_0["loopfx"]["selected"] = (1, 1, 0.2);
  var_0["loopfx"]["highlighted"] = (0.4, 0.95, 1);
  var_0["loopfx"]["default"] = (0.3, 0.8, 1);
  var_0["oneshotfx"]["selected"] = (1, 1, 0.2);
  var_0["oneshotfx"]["highlighted"] = (0.4, 0.95, 1);
  var_0["oneshotfx"]["default"] = (0.3, 0.8, 1);
  var_0["exploder"]["selected"] = (1, 1, 0.2);
  var_0["exploder"]["highlighted"] = (1, 0.2, 0.2);
  var_0["exploder"]["default"] = (1, 0.1, 0.1);
  var_0["rainfx"]["selected"] = (1, 1, 0.2);
  var_0["rainfx"]["highlighted"] = (0.95, 0.4, 0.95);
  var_0["rainfx"]["default"] = (0.78, 0, 0.73);
  var_0["soundfx"]["selected"] = (1, 1, 0.2);
  var_0["soundfx"]["highlighted"] = (0.5, 1, 0.75);
  var_0["soundfx"]["default"] = (0.2, 0.9, 0.2);
  var_0["soundfx_interval"]["selected"] = (1, 1, 0.2);
  var_0["soundfx_interval"]["highlighted"] = (0.5, 1, 0.75);
  var_0["soundfx_interval"]["default"] = (0.2, 0.9, 0.2);
  var_0["reactive_fx"]["selected"] = (1, 1, 0.2);
  var_0["reactive_fx"]["highlighted"] = (0.5, 1, 0.75);
  var_0["reactive_fx"]["default"] = (0.2, 0.9, 0.2);
  level._createfx.colors = var_00;
}

createfxlogic() {
  waittillframeend;
  wait 0.05;

  if (!isdefined(level._effect))
  level._effect = [];

  if (getdvar("createfx_map") == "") {}
  else if (getdvar("createfx_map") == scripts\engine\utility::get_template_script_MAYBE())
  [[level.func_position_player]]();

  init_crosshair();
  scripts\common\createfxmenu::init_menu();
  init_huds();
  init_tool_hud();
  init_level_variables();
  init_locked_list();
  init_colors();
  level.player setclientomnvar("ui_hide_hud", 1);
  setdvarifuninitialized("createfx_filter", "");
  setdvarifuninitialized("createfx_vfxonly", "0");

  if (getdvar("createfx_use_f4") == "") {}

  if (getdvar("createfx_no_autosave") == "") {}

  level.createfx_draw_enabled = 1;
  level.last_displayed_ent = undefined;
  level.buttonisheld = [];
  var_00 = (0, 0, 0);
  scripts\engine\utility::flag_set("createfx_started");

  if (!level.mp_createfx)
  var_00 = level.player.origin;

  var_01 = undefined;
  level.fx_rotating = 0;
  scripts\common\createfxmenu::setmenu("none");
  level.createfx_selecting = 0;
  level.createfx_inputlocked = 0;

  foreach (var_03 in level.createfxent)
  var_03 post_entity_creation_function();

  thread draw_distance();
  var_05 = undefined;
  thread createfx_autosave();

  for (;;) {
  var_06 = 0;
  var_07 = anglestoright(level.player getplayerangles());
  var_08 = anglestoforward(level.player getplayerangles());
  var_09 = anglestoup(level.player getplayerangles());
  var_10 = 0.85;
  var_11 = var_08 * 750;
  level.createfxcursor = bullettrace(level.player geteye(), level.player geteye() + var_11, 0, undefined);
  var_12 = undefined;
  level.buttonclick = [];
  level.button_is_kb = [];
  process_button_held_and_clicked();
  var_13 = button_is_held("ctrl", "BUTTON_LSHLDR");
  var_14 = button_is_held("shift");
  var_15 = button_is_clicked("mouse1", "BUTTON_A");
  var_16 = button_is_held("mouse1", "BUTTON_A");
  scripts\common\createfxmenu::create_fx_menu();
  var_17 = "F5";

  if (getdvarint("createfx_use_f4"))
  var_17 = "F4";

  if (button_is_clicked(var_17)) {}

  if (getdvarint("scr_createfx_dump"))
  generate_fx_log();

  if (button_is_clicked("F2"))
  toggle_createfx_drawing();

  if (button_is_clicked("z"))
  toggle_createfx_axis();

  if (button_is_clicked("ins"))
  insert_effect();

  if (button_is_clicked("del"))
  delete_pressed();

  if (button_is_clicked("escape"))
  clear_settable_fx();

  if (button_is_clicked("space"))
  set_off_exploders();

  if (button_is_clicked("u"))
  select_by_name_list();

  modify_player_speed();

  if (!var_13 && !var_14 && button_is_clicked("g")) {
  select_all_exploders_of_currently_selected("exploder");
  select_all_exploders_of_currently_selected("flag");
  }

  if (var_14) {
  if (button_is_clicked("g"))
  goto_selected();
  }

  if (button_is_held("h", "F1") && !level.mp_createfx) {
  show_help();
  wait 0.05;
  continue;
  }

  if (button_is_clicked("BUTTON_LSTICK"))
  copy_ents();

  if (button_is_clicked("BUTTON_RSTICK"))
  paste_ents();

  if (var_13) {
  if (button_is_clicked("c"))
  copy_ents();

  if (button_is_clicked("v"))
  paste_ents();

  if (button_is_clicked("g"))
  spawn_grenade();
  }

  if (isdefined(level._createfx.selected_fx_option_index))
  scripts\common\createfxmenu::menu_fx_option_set();

  for (var_18 = 0; var_18 < level.createfxent.size; var_18++) {
  var_03 = level.createfxent[var_18];
  var_19 = vectornormalize(var_3.v["origin"] - (level.player.origin + (0, 0, 55)));
  var_20 = vectordot(var_08, var_19);

  if (var_20 < var_10)
  continue;

  var_10 = var_20;
  var_12 = var_03;
  }

  level.fx_highlightedent = var_12;

  if (isdefined(var_12)) {
  if (isdefined(var_01)) {
  if (var_01 != var_12) {
  if (!ent_is_selected(var_01))
  var_01 thread entity_highlight_disable();

  if (!ent_is_selected(var_12))
  var_12 thread entity_highlight_enable();
  }
  }
  else if (!ent_is_selected(var_12))
  var_12 thread entity_highlight_enable();
  }

  manipulate_createfx_ents(var_12, var_15, var_16, var_13, var_07);
  var_06 = handle_selected_ents(var_06);
  wait 0.05;

  if (var_06)
  update_selected_entities();

  if (!level.mp_createfx)
  var_00 = [[level.func_position_player_get]](var_00);

  var_01 = var_12;

  if (last_selected_entity_has_changed(var_05)) {
  level.effect_list_offset = 0;
  clear_settable_fx();
  scripts\common\createfxmenu::setmenu("none");
  }

  if (level._createfx.selected_fx_ents.size) {
  var_05 = level._createfx.selected_fx_ents[level._createfx.selected_fx_ents.size - 1];
  continue;
  }

  var_05 = undefined;
  }
}

modify_player_speed() {
  var_00 = 0;
  var_01 = button_is_held("ctrl");

  if (button_is_held(".")) {
  if (var_01) {
  if (level._createfx.player_speed < 190)
  level._createfx.player_speed = 190;
  else
  level._createfx.player_speed = level._createfx.player_speed + 10;
  }
  else
  level._createfx.player_speed = level._createfx.player_speed + 5;

  var_00 = 1;
  }
  else if (button_is_held(",")) {
  if (var_01) {
  if (level._createfx.player_speed > 190)
  level._createfx.player_speed = 190;
  else
  level._createfx.player_speed = level._createfx.player_speed - 10;
  }
  else
  level._createfx.player_speed = level._createfx.player_speed - 5;

  var_00 = 1;
  }

  if (var_00) {
  level._createfx.player_speed = clamp(level._createfx.player_speed, 5, 500);
  [[level.func_player_speed]]();
  set_player_speed_hud();
  }
}

set_player_speed_hud() {
  if (level.mp_createfx)
  return;

  if (!isdefined(level._createfx.player_speed_hud)) {
  var_00 = newhudelem();
  var_0.alignx = "right";
  var_0.foreground = 1;
  var_0.fontscale = 1.2;
  var_0.alpha = 0.2;
  var_0.x = 320;
  var_0.y = 420;
  var_01 = newhudelem();
  var_1.alignx = "left";
  var_1.foreground = 1;
  var_1.fontscale = 1.2;
  var_1.alpha = 0.2;
  var_1.x = 320;
  var_1.y = 420;
  var_0.hud_value = var_01;
  level._createfx.player_speed_hud = var_00;
  }

  level._createfx.player_speed_hud.hud_value setvalue(level._createfx.player_speed);
}

toggle_createfx_drawing() {
  level.createfx_draw_enabled = !level.createfx_draw_enabled;
}

insert_effect() {
  scripts\common\createfxmenu::setmenu("creation");
  level.effect_list_offset = 0;
  clear_fx_hudelements();
  set_fx_hudelement("Pick effect type to create:");
  set_fx_hudelement("1. One Shot FX");

  if (!level.mp_createfx) {
  set_fx_hudelement("2. Looping FX");
  set_fx_hudelement("3. Looping sound");
  set_fx_hudelement("4. Exploder");
  set_fx_hudelement("5. One Shot Sound");
  set_fx_hudelement("6. Reactive FX");
  } else {
  set_fx_hudelement("2. Looping sound");
  set_fx_hudelement("3. Exploder");
  set_fx_hudelement("4. One Shot Sound");
  set_fx_hudelement("5. Reactive FX");
  }

  set_fx_hudelement("(c) Cancel >");
  set_fx_hudelement("(x) Exit >");
}

is_ent_filtered_out(var_00, var_01) {
  if (var_01 != "") {
  if (isdefined(var_0.v["type"]) && issubstr(var_0.v["type"], var_01))
  return 0;
  else if (isdefined(var_0.v["fxid"]) && issubstr(var_0.v["fxid"], var_01))
  return 0;
  else if (isdefined(var_0.v["soundalias"]) && issubstr(var_0.v["soundalias"], var_01))
  return 0;

  return 1;
  }

  return 0;
}

manipulate_createfx_ents(var_00, var_01, var_02, var_03, var_04) {
  if (!level.createfx_draw_enabled)
  return;

  if (level._createfx.select_by_name) {
  level._createfx.select_by_name = 0;
  var_00 = undefined;
  }
  else if (select_by_substring())
  var_00 = undefined;

  for (var_05 = 0; var_05 < level.createfxent.size; var_5++) {
  var_06 = level.createfxent[var_05];

  if (!var_6.drawn)
  continue;

  if (is_ent_filtered_out(var_06, getdvar("createfx_filter")))
  continue;

  var_07 = getdvarfloat("createfx_scaleid");

  if (isdefined(var_00) && var_06 == var_00) {
  if (!scripts\common\createfxmenu::entities_are_selected())
  scripts\common\createfxmenu::display_fx_info(var_06);

  if (var_01) {
  var_08 = index_is_selected(var_05);
  level.createfx_selecting = !var_08;

  if (!var_03) {
  var_09 = level._createfx.selected_fx_ents.size;
  clear_entity_selection();

  if (var_08 && var_09 == 1)
  select_entity(var_05, var_06);
  }

  toggle_entity_selection(var_05, var_06);
  }
  else if (var_02) {
  if (var_03) {
  if (level.createfx_selecting)
  select_entity(var_05, var_06);

  if (!level.createfx_selecting)
  deselect_entity(var_05, var_06);
  }
  }

  var_10 = "highlighted";
  }
  else
  var_10 = "default";

  if (index_is_selected(var_05))
  var_10 = "selected";

  var_06 createfx_print3d(var_10, var_07, var_04);
  }
}

draw_origin(var_00, var_01) {
  var_02 = level.player getvieworigin();
  var_03 = level.player getplayerangles();
  var_04 = level._createfx.colors[self.v["type"]][var_01];
  var_05 = 0;
  var_06 = 1;
  var_07 = (0, 0, 0);
  var_08 = distancesquared(var_02, self.v["origin"]) < 36864;

  if (var_08) {
  var_09 = distance(var_02, self.v["origin"]);
  var_10 = var_09 / 176;
  var_05 = 1 - clamp(var_10, 0.0, 1.0);
  var_06 = clamp(var_10, 0.333, 1.0);
  var_11 = anglestoright(var_03) * -4;
  var_12 = anglestoup(var_03) * -4.666;
  var_07 = var_11 + var_12;
  }

  if (var_05 > 0) {
  var_13 = scripts\engine\utility::within_fov(var_02, var_03, self.v["origin"], 0.422618);

  if (var_13) {
  var_14 = 2.0;
  var_15 = 4.0;
  var_16 = anglestoforward(self.v["angles"]);
  var_16 = var_16 * (var_15 * var_00);
  var_17 = anglestoright(self.v["angles"]) * -1;
  var_17 = var_17 * (var_15 * var_00);
  var_18 = anglestoup(self.v["angles"]);
  var_18 = var_18 * (var_15 * var_00);
  }
  }
}

createfx_print3d(var_00, var_01, var_02) {
  draw_origin(var_01, var_00);

  if (self.textalpha > 0) {
  var_03 = get_print3d_text();
  var_04 = var_02 * (var_3[0].size * -2.93);
  var_05 = level._createfx.colors[self.v["type"]][var_00];

  if (isdefined(self.is_playing))
  var_05 = (1, 0.5, 0);

  var_06 = 15;

  foreach (var_08 in var_03)
  var_06 = var_06 - 13;

  if (isdefined(self.v["reactive_radius"])) {
  if (self.v["fxid"] == "No FX" && !getdvarint("createfx_vfxonly"))
  return;
  }
  }
}

get_print3d_text() {
  switch (self.v["type"]) {
  case "reactive_fx":
  var_0[0] = "reactive sound: " + self.v["soundalias"];

  if (!level.mp_createfx)
  var_0[1] = "reactive FX: " + self.v["fxid"];

  return var_00;
  case "soundfx_interval":
  case "soundfx":
  return [self.v["soundalias"]];
  default:
  return [self.v["fxid"]];
  }
}

select_by_name_list() {
  level.effect_list_offset = 0;
  clear_fx_hudelements();
  scripts\common\createfxmenu::setmenu("select_by_name");
  scripts\common\createfxmenu::draw_effects_list();
}

handle_selected_ents(var_00) {
  if (level._createfx.selected_fx_ents.size > 0) {
  var_00 = selected_ent_buttons(var_00);

  if (!current_mode_hud("selected_ents")) {
  new_tool_hud("selected_ents");
  set_tool_hudelem("Selected Ent Mode");
  set_tool_hudelem("Mode:", "move");
  set_tool_hudelem("Rate:", level._createfx.rate);
  set_tool_hudelem("Snap2Normal:", level._createfx.snap2normal);
  set_tool_hudelem("Snap2Angle:", level._createfx.snap2anglesnaps[level._createfx.snap2angle]);
  }

  if (level._createfx.axismode && level._createfx.selected_fx_ents.size > 0) {
  set_tool_hudelem("Mode:", "rotate");
  thread [[level.func_process_fx_rotater]]();

  if (button_is_clicked("enter", "p"))
  reset_axis_of_selected_ents();

  if (button_is_clicked("v"))
  copy_angles_of_selected_ents();

  for (var_01 = 0; var_01 < level._createfx.selected_fx_ents.size; var_1++)
  level._createfx.selected_fx_ents[var_01] draw_axis();

  if (level.selectedrotate_pitch != 0 || level.selectedrotate_yaw != 0 || level.selectedrotate_roll != 0)
  var_00 = 1;
  } else {
  set_tool_hudelem("Mode:", "move");
  var_02 = get_selected_move_vector();

  for (var_01 = 0; var_01 < level._createfx.selected_fx_ents.size; var_1++) {
  var_03 = level._createfx.selected_fx_ents[var_01];

  if (isdefined(var_3.model))
  continue;

  var_03 draw_cross();
  var_3.v["origin"] = var_3.v["origin"] + var_02;
  }

  if (distance((0, 0, 0), var_02) > 0)
  var_00 = 1;
  }
  }
  else
  clear_tool_hud();

  return var_00;
}

selected_ent_buttons(var_00) {
  if (button_is_clicked("shift", "BUTTON_X"))
  toggle_axismode();

  modify_rate();

  if (button_is_clicked("s"))
  toggle_snap2normal();

  if (button_is_clicked("r"))
  toggle_snap2angle();

  if (button_is_clicked("end", "l")) {
  drop_selection_to_ground();
  var_00 = 1;
  }

  if (button_is_clicked("tab", "BUTTON_RSHLDR")) {
  move_selection_to_cursor();
  var_00 = 1;
  }

  if (button_is_clicked("e")) {
  convert_selection_to_exploder();
  var_00 = 1;
  }

  return var_00;
}

modify_rate() {
  var_00 = button_is_held("shift");
  var_01 = button_is_held("ctrl");

  if (button_is_clicked("=")) {
  if (var_00)
  level._createfx.rate = level._createfx.rate + 1;
  else if (var_01) {
  if (level._createfx.rate < 1)
  level._createfx.rate = 1;
  else
  level._createfx.rate = level._createfx.rate + 10;
  }
  else
  level._createfx.rate = level._createfx.rate + 0.1;
  }
  else if (button_is_clicked("-")) {
  if (var_00)
  level._createfx.rate = level._createfx.rate - 1;
  else if (var_01) {
  if (level._createfx.rate > 1)
  level._createfx.rate = 1;
  else
  level._createfx.rate = 0.1;
  }
  else
  level._createfx.rate = level._createfx.rate - 0.1;
  }

  level._createfx.rate = clamp(level._createfx.rate, 0.1, 100);
  set_tool_hudelem("Rate:", level._createfx.rate);
}

toggle_axismode() {
  level._createfx.axismode = !level._createfx.axismode;
}

toggle_snap2normal() {
  level._createfx.snap2normal = !level._createfx.snap2normal;
  set_tool_hudelem("Snap2Normal:", level._createfx.snap2normal);
}

toggle_snap2angle() {
  level._createfx.snap2angle = level._createfx.snap2angle + 1;

  if (level._createfx.snap2angle >= level._createfx.snap2anglesnaps.size)
  level._createfx.snap2angle = 0;

  set_tool_hudelem("Snap2Angle:", level._createfx.snap2anglesnaps[level._createfx.snap2angle]);
}

copy_angles_of_selected_ents() {
  level notify("new_ent_selection");

  for (var_00 = 0; var_00 < level._createfx.selected_fx_ents.size; var_0++) {
  var_01 = level._createfx.selected_fx_ents[var_00];
  var_1.v["angles"] = level._createfx.selected_fx_ents[level._createfx.selected_fx_ents.size - 1].v["angles"];
  var_01 set_forward_and_up_vectors();
  }

  update_selected_entities();
}

reset_axis_of_selected_ents() {
  level notify("new_ent_selection");

  for (var_00 = 0; var_00 < level._createfx.selected_fx_ents.size; var_0++) {
  var_01 = level._createfx.selected_fx_ents[var_00];
  var_1.v["angles"] = (0, 0, 0);
  var_01 set_forward_and_up_vectors();
  }

  update_selected_entities();
}

last_selected_entity_has_changed(var_00) {
  if (isdefined(var_00)) {
  if (!scripts\common\createfxmenu::entities_are_selected())
  return 1;
  }
  else
  return scripts\common\createfxmenu::entities_are_selected();

  return var_00 != level._createfx.selected_fx_ents[level._createfx.selected_fx_ents.size - 1];
}

drop_selection_to_ground() {
  for (var_00 = 0; var_00 < level._createfx.selected_fx_ents.size; var_0++) {
  var_01 = level._createfx.selected_fx_ents[var_00];
  var_02 = bullettrace(var_1.v["origin"], var_1.v["origin"] + (0, 0, -2048), 0, undefined);
  var_1.v["origin"] = var_2["position"];
  }
}

set_off_exploders() {
  level notify("createfx_exploder_reset");
  var_00 = [];

  for (var_01 = 0; var_01 < level._createfx.selected_fx_ents.size; var_1++) {
  var_02 = level._createfx.selected_fx_ents[var_01];

  if (isdefined(var_2.v["exploder"]))
  var_0[var_2.v["exploder"]] = 1;
  }

  var_03 = getarraykeys(var_00);

  for (var_01 = 0; var_01 < var_3.size; var_1++)
  scripts\engine\utility::exploder(var_3[var_01]);
}

draw_distance() {
  var_00 = 0;

  if (getdvarint("createfx_drawdist") == 0) {}

  for (;;) {
  var_01 = getdvarint("createfx_drawdist");
  var_01 = var_01 * var_01;

  for (var_02 = 0; var_02 < level.createfxent.size; var_2++) {
  var_03 = level.createfxent[var_02];
  var_3.drawn = distancesquared(level.player.origin, var_3.v["origin"]) <= var_01;
  var_0++;

  if (var_00 > 100) {
  var_00 = 0;
  wait 0.05;
  }
  }

  if (level.createfxent.size == 0)
  wait 0.05;
  }
}

createfx_autosave() {
  setdvarifuninitialized("createfx_autosave_time", "300");

  for (;;) {
  wait(getdvarint("createfx_autosave_time"));
  scripts\engine\utility::flag_waitopen("createfx_saving");

  if (getdvarint("createfx_no_autosave"))
  continue;

  generate_fx_log(1);
  }
}

rotate_over_time(var_00, var_01) {
  level endon("new_ent_selection");
  var_02 = 0.1;

  for (var_03 = 0; var_03 < var_02 * 20; var_3++) {
  if (level.selectedrotate_pitch != 0)
  var_00 addpitch(level.selectedrotate_pitch);
  else if (level.selectedrotate_yaw != 0)
  var_00 addyaw(level.selectedrotate_yaw);
  else
  var_00 addroll(level.selectedrotate_roll);

  wait 0.05;
  var_00 draw_axis();

  for (var_04 = 0; var_04 < level._createfx.selected_fx_ents.size; var_4++) {
  var_05 = level._createfx.selected_fx_ents[var_04];

  if (isdefined(var_5.model))
  continue;

  var_5.v["origin"] = var_1[var_04].origin;
  var_5.v["angles"] = var_1[var_04].angles;
  }
  }
}

delete_pressed() {
  if (level.createfx_inputlocked) {
  remove_selected_option();
  return;
  }

  delete_selection();
}

remove_selected_option() {
  if (!isdefined(level._createfx.selected_fx_option_index))
  return;

  var_00 = level._createfx.options[level._createfx.selected_fx_option_index]["name"];

  for (var_01 = 0; var_01 < level.createfxent.size; var_1++) {
  var_02 = level.createfxent[var_01];

  if (!ent_is_selected(var_02))
  continue;

  var_02 remove_option(var_00);
  }

  update_selected_entities();
  clear_settable_fx();
}

remove_option(var_00) {
  self.v[var_00] = undefined;
}

delete_selection() {
  var_00 = [];

  for (var_01 = 0; var_01 < level.createfxent.size; var_1++) {
  var_02 = level.createfxent[var_01];

  if (ent_is_selected(var_02)) {
  if (isdefined(var_2.loopsound_ent)) {
  var_2.loopsound_ent stoploopsound();
  var_2.loopsound_ent delete();
  }

  if (isdefined(var_2.looper))
  var_2.looper delete();

  var_02 notify("stop_loop");
  continue;
  }

  var_0[var_0.size] = var_02;
  }

  level.createfxent = var_00;
  level._createfx.selected_fx = [];
  level._createfx.selected_fx_ents = [];
  clear_fx_hudelements();
  remove_axis_model();
}

move_selection_to_cursor() {
  var_00 = level.createfxcursor["position"];

  if (level._createfx.selected_fx_ents.size <= 0)
  return;

  var_01 = get_center_of_array(level._createfx.selected_fx_ents);
  var_02 = var_01 - var_00;

  for (var_03 = 0; var_03 < level._createfx.selected_fx_ents.size; var_3++) {
  var_04 = level._createfx.selected_fx_ents[var_03];

  if (isdefined(var_4.model))
  continue;

  var_4.v["origin"] = var_4.v["origin"] - var_02;

  if (level._createfx.snap2normal) {
  if (isdefined(level.createfxcursor["normal"]))
  var_4.v["angles"] = vectortoangles(level.createfxcursor["normal"]);
  }
  }
}

convert_selection_to_exploder() {
  if (level._createfx.selected_fx_ents.size < 1)
  return;

  var_00 = 0;

  foreach (var_02 in level._createfx.selected_fx_ents) {
  if (var_2.v["type"] == "oneshotfx") {
  var_00 = 1;
  createnewexploder_internal(var_02);
  continue;
  }
  }

  if (var_00) {
  scripts\common\createfxmenu::setmenu("none");
  scripts\common\createfxmenu::display_fx_info(scripts\common\createfxmenu::get_last_selected_ent());
  }
}

select_last_entity() {
  select_entity(level.createfxent.size - 1, level.createfxent[level.createfxent.size - 1]);
}

select_all_exploders_of_currently_selected(var_00) {
  var_01 = [];

  foreach (var_03 in level._createfx.selected_fx_ents) {
  if (!isdefined(var_3.v[var_00]))
  continue;

  var_04 = var_3.v[var_00];
  var_1[var_04] = 1;
  }

  foreach (var_04, var_07 in var_01) {
  foreach (var_09, var_03 in level.createfxent) {
  if (index_is_selected(var_09))
  continue;

  if (!isdefined(var_3.v[var_00]))
  continue;

  if (var_3.v[var_00] != var_04)
  continue;

  select_entity(var_09, var_03);
  }
  }

  update_selected_entities();
}

copy_ents() {
  if (level._createfx.selected_fx_ents.size <= 0)
  return;

  var_00 = [];

  for (var_01 = 0; var_01 < level._createfx.selected_fx_ents.size; var_1++) {
  var_02 = level._createfx.selected_fx_ents[var_01];
  var_03 = spawnstruct();
  var_3.v = var_2.v;
  var_03 post_entity_creation_function();
  var_0[var_0.size] = var_03;
  }

  level.stored_ents = var_00;
}

post_entity_creation_function() {
  self.textalpha = 0;
  self.drawn = 1;
}

paste_ents() {
  if (!isdefined(level.stored_ents))
  return;

  clear_entity_selection();

  for (var_00 = 0; var_00 < level.stored_ents.size; var_0++)
  add_and_select_entity(level.stored_ents[var_00]);

  move_selection_to_cursor();
  update_selected_entities();
  level.stored_ents = [];
  copy_ents();
}

add_and_select_entity(var_00) {
  level.createfxent[level.createfxent.size] = var_00;
  select_last_entity();
}

get_center_of_array(var_00) {
  var_01 = (0, 0, 0);

  for (var_02 = 0; var_02 < var_0.size; var_2++)
  var_01 = (var_1[0] + var_0[var_02].v["origin"][0], var_1[1] + var_0[var_02].v["origin"][1], var_1[2] + var_0[var_02].v["origin"][2]);

  return (var_1[0] / var_0.size, var_1[1] / var_0.size, var_1[2] / var_0.size);
}

goto_selected() {
  var_00 = undefined;

  if (level._createfx.selected_fx_ents.size > 0)
  var_00 = get_center_of_array(level._createfx.selected_fx_ents);
  else if (isdefined(level.fx_highlightedent))
  var_00 = level.fx_highlightedent.v["origin"];

  if (!isdefined(var_00))
  return;

  var_01 = vectortoangles(level.player.origin - var_00);
  var_02 = var_00 + anglestoforward(var_01) * 200;
  level.player setorigin(var_02 + (0, 0, -60));
  level.player setplayerangles(vectortoangles(var_00 - var_02));
}

ent_draw_axis() {
  self endon("death");

  for (;;) {
  draw_axis();
  wait 0.05;
  }
}

rotation_is_occuring() {
  if (level.selectedrotate_roll != 0)
  return 1;

  if (level.selectedrotate_pitch != 0)
  return 1;

  return level.selectedrotate_yaw != 0;
}

print_fx_options(var_00, var_01, var_02) {
  for (var_03 = 0; var_03 < level._createfx.options.size; var_3++) {
  var_04 = level._createfx.options[var_03];
  var_05 = var_4["name"];

  if (!isdefined(var_0.v[var_05]))
  continue;

  if (!scripts\common\createfxmenu::mask(var_4["mask"], var_0.v["type"]))
  continue;

  if (!level.mp_createfx) {
  if (scripts\common\createfxmenu::mask("fx", var_0.v["type"]) && var_05 == "fxid")
  continue;

  if (var_0.v["type"] == "exploder" && var_05 == "exploder")
  continue;

  var_06 = var_0.v["type"] + "\" + var_05;

  if (isdefined(level._createfx.defaults[var_06]) && level._createfx.defaults[var_06] == var_0.v[var_05])
  continue;
  }

  if (var_4["type"] == "string") {
  var_07 = var_0.v[var_05] + "";

  if (var_07 == "nil")
  continue;

  cfxprintln(var_01 + "ent.v[\"" + var_05 + "\"] = \"" + var_0.v[var_05] + "\";");
  continue;
  }

  cfxprintln(var_01 + "ent.v[\"" + var_05 + "\"] = " + var_0.v[var_05] + ";");
  }
}

entity_highlight_disable() {
  self notify("highlight change");
  self endon("highlight change");

  for (;;) {
  self.textalpha = self.textalpha * 0.85;
  self.textalpha = self.textalpha - 0.05;

  if (self.textalpha < 0)
  break;

  wait 0.05;
  }

  self.textalpha = 0;
}

entity_highlight_enable() {
  self notify("highlight change");
  self endon("highlight change");

  for (;;) {
  self.textalpha = self.textalpha + 0.05;
  self.textalpha = self.textalpha * 1.25;

  if (self.textalpha > 1)
  break;

  wait 0.05;
  }

  self.textalpha = 1;
}

clear_settable_fx() {
  level.createfx_inputlocked = 0;
  level._createfx.selected_fx_option_index = undefined;
  reset_fx_hud_colors();
}

reset_fx_hud_colors() {
  for (var_00 = 0; var_00 < level._createfx.hudelem_count; var_0++)
  level._createfx.hudelems[var_00][0].color = (1, 1, 1);
}

toggle_entity_selection(var_00, var_01) {
  if (isdefined(level._createfx.selected_fx[var_00]))
  deselect_entity(var_00, var_01);
  else
  select_entity(var_00, var_01);
}

select_entity(var_00, var_01) {
  if (isdefined(level._createfx.selected_fx[var_00]))
  return;

  clear_settable_fx();
  level notify("new_ent_selection");
  var_01 thread entity_highlight_enable();
  level._createfx.selected_fx[var_00] = 1;
  level._createfx.selected_fx_ents[level._createfx.selected_fx_ents.size] = var_01;
}

ent_is_highlighted(var_00) {
  if (!isdefined(level.fx_highlightedent))
  return 0;

  return var_00 == level.fx_highlightedent;
}

deselect_entity(var_00, var_01) {
  if (!isdefined(level._createfx.selected_fx[var_00]))
  return;

  clear_settable_fx();
  level notify("new_ent_selection");
  level._createfx.selected_fx[var_00] = undefined;

  if (!ent_is_highlighted(var_01))
  var_01 thread entity_highlight_disable();

  var_02 = [];

  for (var_03 = 0; var_03 < level._createfx.selected_fx_ents.size; var_3++) {
  if (level._createfx.selected_fx_ents[var_03] != var_01)
  var_2[var_2.size] = level._createfx.selected_fx_ents[var_03];
  }

  level._createfx.selected_fx_ents = var_02;
}

index_is_selected(var_00) {
  return isdefined(level._createfx.selected_fx[var_00]);
}

ent_is_selected(var_00) {
  for (var_01 = 0; var_01 < level._createfx.selected_fx_ents.size; var_1++) {
  if (level._createfx.selected_fx_ents[var_01] == var_00)
  return 1;
  }

  return 0;
}

clear_entity_selection() {
  for (var_00 = 0; var_00 < level._createfx.selected_fx_ents.size; var_0++) {
  if (!ent_is_highlighted(level._createfx.selected_fx_ents[var_00]))
  level._createfx.selected_fx_ents[var_00] thread entity_highlight_disable();
  }

  level._createfx.selected_fx = [];
  level._createfx.selected_fx_ents = [];
}

draw_axis() {}

set_axis_model(var_00) {
  if (!isdefined(level._createfx.axis))
  level._createfx.axis = spawn("script_model", (0, 0, 0));
  else if (level._createfx.axis.model != var_00)
  level._createfx.axis setmodel(var_00);
}

remove_axis_model() {
  if (!isdefined(level._createfx.axis))
  return;

  level._createfx.axis delete();
}

draw_cross() {}

toggle_createfx_axis() {
  level._createfx.drawaxis++;

  if (level._createfx.drawaxis > 2)
  level._createfx.drawaxis = 0;

  if (level._createfx.drawaxis != 1)
  remove_axis_model();
}

createfx_centerprint(var_00) {
  thread createfx_centerprint_thread(var_00);
}

createfx_centerprint_thread(var_00) {
  level notify("new_createfx_centerprint");
  level endon("new_createfx_centerprint");
  wait 4.5;
}

get_selected_move_vector() {
  var_00 = level.player getplayerangles()[1];
  var_01 = (0, var_00, 0);
  var_02 = anglestoright(var_01);
  var_03 = anglestoforward(var_01);
  var_04 = anglestoup(var_01);
  var_05 = 0;
  var_06 = level._createfx.rate;

  if (buttondown("kp_uparrow", "DPAD_UP")) {
  if (level.selectedmove_forward < 0)
  level.selectedmove_forward = 0;

  level.selectedmove_forward = level.selectedmove_forward + var_06;
  }
  else if (buttondown("kp_downarrow", "DPAD_DOWN")) {
  if (level.selectedmove_forward > 0)
  level.selectedmove_forward = 0;

  level.selectedmove_forward = level.selectedmove_forward - var_06;
  }
  else
  level.selectedmove_forward = 0;

  if (buttondown("kp_rightarrow", "DPAD_RIGHT")) {
  if (level.selectedmove_right < 0)
  level.selectedmove_right = 0;

  level.selectedmove_right = level.selectedmove_right + var_06;
  }
  else if (buttondown("kp_leftarrow", "DPAD_LEFT")) {
  if (level.selectedmove_right > 0)
  level.selectedmove_right = 0;

  level.selectedmove_right = level.selectedmove_right - var_06;
  }
  else
  level.selectedmove_right = 0;

  if (buttondown("BUTTON_Y")) {
  if (level.selectedmove_up < 0)
  level.selectedmove_up = 0;

  level.selectedmove_up = level.selectedmove_up + var_06;
  }
  else if (buttondown("BUTTON_B")) {
  if (level.selectedmove_up > 0)
  level.selectedmove_up = 0;

  level.selectedmove_up = level.selectedmove_up - var_06;
  }
  else
  level.selectedmove_up = 0;

  var_07 = (0, 0, 0);
  var_07 = var_07 + var_03 * level.selectedmove_forward;
  var_07 = var_07 + var_02 * level.selectedmove_right;
  var_07 = var_07 + var_04 * level.selectedmove_up;
  return var_07;
}

set_anglemod_move_vector() {
  var_00 = level._createfx.rate;
  var_01 = level._createfx.snap2anglesnaps[level._createfx.snap2angle];

  if (var_01 != 0)
  var_00 = 0;

  if (buttondown("kp_uparrow", "DPAD_UP")) {
  if (level.selectedrotate_pitch < 0)
  level.selectedrotate_pitch = 0;

  level.selectedrotate_pitch = level.selectedrotate_pitch + var_01 + var_00;
  }
  else if (buttondown("kp_downarrow", "DPAD_DOWN")) {
  if (level.selectedrotate_pitch > 0)
  level.selectedrotate_pitch = 0;

  level.selectedrotate_pitch = level.selectedrotate_pitch - var_01 - var_00;
  }
  else
  level.selectedrotate_pitch = 0;

  if (buttondown("kp_leftarrow", "DPAD_LEFT")) {
  if (level.selectedrotate_yaw < 0)
  level.selectedrotate_yaw = 0;

  level.selectedrotate_yaw = level.selectedrotate_yaw + var_01 + var_00;
  }
  else if (buttondown("kp_rightarrow", "DPAD_RIGHT")) {
  if (level.selectedrotate_yaw > 0)
  level.selectedrotate_yaw = 0;

  level.selectedrotate_yaw = level.selectedrotate_yaw - var_01 - var_00;
  }
  else
  level.selectedrotate_yaw = 0;

  if (buttondown("BUTTON_Y")) {
  if (level.selectedrotate_roll < 0)
  level.selectedrotate_roll = 0;

  level.selectedrotate_roll = level.selectedrotate_roll + var_01 + var_00;
  }
  else if (buttondown("BUTTON_B")) {
  if (level.selectedrotate_roll > 0)
  level.selectedrotate_roll = 0;

  level.selectedrotate_roll = level.selectedrotate_roll - var_01 - var_00;
  }
  else
  level.selectedrotate_roll = 0;
}

update_selected_entities() {
  var_00 = 0;

  foreach (var_02 in level._createfx.selected_fx_ents) {
  if (var_2.v["type"] == "reactive_fx")
  var_00 = 1;

  var_02 [[level.func_updatefx]]();
  }

  if (var_00)
  refresh_reactive_fx_ents();
}

stop_fx_looper() {
  if (isdefined(self.looper))
  self.looper delete();

  stop_loopsound();
}

stop_loopsound() {
  self notify("stop_loop");
}

func_get_level_fx() {
  if (!isdefined(level._effect_keys))
  var_00 = getarraykeys(level._effect);
  else
  {
  var_00 = getarraykeys(level._effect);

  if (var_0.size == level._effect_keys.size)
  return level._effect_keys;
  }

  var_00 = scripts\engine\utility::alphabetize(var_00);
  level._effect_keys = var_00;
  return var_00;
}

restart_fx_looper() {
  stop_fx_looper();
  set_forward_and_up_vectors();

  switch (self.v["type"]) {
  case "oneshotfx":
  scripts\common\fx::create_triggerfx();
  break;
  case "loopfx":
  scripts\common\fx::create_looper();
  break;
  case "soundfx":
  scripts\common\fx::create_loopsound();
  break;
  case "soundfx_interval":
  scripts\common\fx::create_interval_sound();
  break;
  }
}

refresh_reactive_fx_ents() {
  level._fx.reactive_fx_ents = undefined;

  foreach (var_01 in level.createfxent) {
  if (var_1.v["type"] == "reactive_fx") {
  var_01 set_forward_and_up_vectors();
  var_01 scripts\common\fx::add_reactive_fx();
  }
  }
}

process_fx_rotater() {
  if (level.fx_rotating)
  return;

  set_anglemod_move_vector();

  if (!rotation_is_occuring())
  return;

  level.fx_rotating = 1;

  if (level._createfx.selected_fx_ents.size > 1) {
  var_00 = get_center_of_array(level._createfx.selected_fx_ents);
  var_01 = spawn("script_origin", var_00);
  var_1.v["angles"] = level._createfx.selected_fx_ents[0].v["angles"];
  var_1.v["origin"] = var_00;
  var_02 = [];

  for (var_03 = 0; var_03 < level._createfx.selected_fx_ents.size; var_3++) {
  var_2[var_03] = spawn("script_origin", level._createfx.selected_fx_ents[var_03].v["origin"]);
  var_2[var_03].angles = level._createfx.selected_fx_ents[var_03].v["angles"];
  var_2[var_03] linkto(var_01);
  }

  rotate_over_time(var_01, var_02);
  var_01 delete();

  for (var_03 = 0; var_03 < var_2.size; var_3++)
  var_2[var_03] delete();
  }
  else if (level._createfx.selected_fx_ents.size == 1) {
  var_04 = level._createfx.selected_fx_ents[0];
  var_02 = spawn("script_origin", (0, 0, 0));
  var_2.angles = var_4.v["angles"];

  if (level.selectedrotate_pitch != 0)
  var_02 addpitch(level.selectedrotate_pitch);
  else if (level.selectedrotate_yaw != 0)
  var_02 addyaw(level.selectedrotate_yaw);
  else
  var_02 addroll(level.selectedrotate_roll);

  var_4.v["angles"] = var_2.angles;
  var_02 delete();
  wait 0.05;
  }

  level.fx_rotating = 0;
}

spawn_grenade() {
  playfx(level._createfx.grenade.fx, level.createfxcursor["position"]);
  level._createfx.grenade playsound(level._createfx.grenade.sound);
  radiusdamage(level.createfxcursor["position"], level._createfx.grenade.radius, 50, 5, undefined, "MOD_EXPLOSIVE");
  level notify("code_damageradius", undefined, level._createfx.grenade.radius, level.createfxcursor["position"]);
}

show_help() {
  clear_fx_hudelements();
  set_fx_hudelement("Help:");
  set_fx_hudelement("Insert  Insert entity");
  set_fx_hudelement("L   Drop selected entities to the ground");
  set_fx_hudelement("A   Add option to the selected entities");
  set_fx_hudelement("P   Reset the rotation of the selected entities");
  set_fx_hudelement("V   Copy the angles from the most recently selected fx onto all selected fx.");
  set_fx_hudelement("Delete  Kill the selected entities");
  set_fx_hudelement("ESCAPE  Cancel out of option-modify-mode, must have console open");
  set_fx_hudelement("Ctrl-C  Copy");
  set_fx_hudelement("Ctrl-V  Paste");
  set_fx_hudelement("F2  Toggle createfx dot and text drawing");
  set_fx_hudelement("F5  SAVES your work");
  set_fx_hudelement("Dpad  Move selected entitise on X\Y or rotate pitch\yaw");
  set_fx_hudelement("A button  Toggle the selection of the current entity");
  set_fx_hudelement("X button  Toggle entity rotation mode");
  set_fx_hudelement("Y button  Move selected entites up or rotate roll");
  set_fx_hudelement("B button  Move selected entites down or rotate roll");
  set_fx_hudelement("R Shoulder  Move selected entities to the cursor");
  set_fx_hudelement("L Shoulder  Hold to select multiple entites");
  set_fx_hudelement("L JoyClick  Copy");
  set_fx_hudelement("R JoyClick  Paste");
  set_fx_hudelement("N   UFO");
  set_fx_hudelement("T   Toggle Timescale FAST");
  set_fx_hudelement("Y   Toggle Timescale SLOW");
  set_fx_hudelement("[Toggle FX Visibility");
  set_fx_hudelement("]   Toggle ShowTris");
  set_fx_hudelement("F11   Toggle FX Profile");
}

generate_fx_log(var_00) {}

write_log(var_00, var_01, var_02, var_03) {
  var_04 = "\\t";
  cfxprintlnstart();
  cfxprintln("\\_createfx generated. Do not touch!!");
  cfxprintln("#include scripts\\common\\utility;");
  cfxprintln("#include scripts\\common\\createfx;\\n");
  cfxprintln("");
  cfxprintln("main()");
  cfxprintln("{");
  cfxprintln(var_04 + "\\ CreateFX " + var_01 + " entities placed: " + var_0.size);

  foreach (var_06 in var_00) {
  if (level.createfx_loopcounter > 16) {
  level.createfx_loopcounter = 0;
  wait 0.1;
  }

  level.createfx_loopcounter++;

  if (getdvarint("scr_map_exploder_dump")) {
  if (!isdefined(var_6.model))
  continue;
  }
  else if (isdefined(var_6.model))
  continue;

  if (var_6.v["type"] == "oneshotfx")
  cfxprintln(var_04 + "ent = createOneshotEffect(\"" + var_6.v["fxid"] + "\");");

  if (var_6.v["type"] == "loopfx")
  cfxprintln(var_04 + "ent = createLoopEffect(\"" + var_6.v["fxid"] + "\");");

  if (var_6.v["type"] == "exploder") {
  if (isdefined(var_6.v["exploder"]) && !level.mp_createfx)
  cfxprintln(var_04 + "ent = createExploderEx(\"" + var_6.v["fxid"] + "\", \"" + var_6.v["exploder"] + "\");");
  else
  cfxprintln(var_04 + "ent = createExploder(\"" + var_6.v["fxid"] + "\");");
  }

  if (var_6.v["type"] == "soundfx")
  cfxprintln(var_04 + "ent = createLoopSound();");

  if (var_6.v["type"] == "soundfx_interval")
  cfxprintln(var_04 + "ent = createIntervalSound();");

  if (var_6.v["type"] == "reactive_fx") {
  if (var_01 == "fx" && var_6.v["fxid"] != "No FX" && !level.mp_createfx)
  cfxprintln(var_04 + "ent = createReactiveEnt(\"" + var_6.v["fxid"] + "\");");
  else if (var_01 == "sound" && var_6.v["fxid"] == "No FX")
  cfxprintln(var_04 + "ent = createReactiveEnt();");
  else
  continue;
  }

  cfxprintln(var_04 + "ent set_origin_and_angles(" + var_6.v["origin"] + ", " + var_6.v["angles"] + ");");
  print_fx_options(var_06, var_04, var_02);
  cfxprintln("");
  }

  cfxprintln("}");
  cfxprintln(" ");
  cfxprintlnend(var_02, var_03, var_01);
}

createfx_adjust_array() {
  var_00 = 0.1;

  foreach (var_02 in level.createfxent) {
  var_03 = [];
  var_04 = [];

  for (var_05 = 0; var_05 < 3; var_5++) {
  var_3[var_05] = var_2.v["origin"][var_05];
  var_4[var_05] = var_2.v["angles"][var_05];

  if (var_3[var_05] < var_00 && var_3[var_05] > var_00 * -1)
  var_3[var_05] = 0;

  if (var_4[var_05] < var_00 && var_4[var_05] > var_00 * -1)
  var_4[var_05] = 0;
  }

  var_2.v["origin"] = (var_3[0], var_3[1], var_3[2]);
  var_2.v["angles"] = (var_4[0], var_4[1], var_4[2]);
  }
}

get_createfx_array(var_00) {
  var_01 = get_createfx_types(var_00);
  var_02 = [];

  foreach (var_05, var_04 in var_01)
  var_2[var_05] = [];

  foreach (var_07 in level.createfxent) {
  var_08 = 0;

  foreach (var_05, var_00 in var_01) {
  if (var_7.v["type"] != var_00)
  continue;

  var_08 = 1;
  var_2[var_05][var_2[var_05].size] = var_07;
  break;
  }
  }

  var_11 = [];

  for (var_12 = 0; var_12 < var_1.size; var_12++) {
  foreach (var_07 in var_2[var_12])
  var_11[var_11.size] = var_07;
  }

  return var_11;
}

get_createfx_types(var_00) {
  var_01 = [];

  if (var_00 == "fx") {
  var_1[0] = "oneshotfx";
  var_1[1] = "loopfx";
  var_1[2] = "exploder";
  var_1[3] = "reactive_fx";
  } else {
  var_1[0] = "soundfx";
  var_1[1] = "soundfx_interval";
  var_1[2] = "reactive_fx";
  }

  return var_01;
}

check_reactive_fx_type(var_00, var_01) {
  if (var_0.v["fxid"] != "No FX" && var_01 == "fx")
  return 1;

  if (var_0.v["fxid"] == "No FX" && var_01 == "sound")
  return 1;

  return 0;
}

is_createfx_type(var_00, var_01) {
  var_02 = get_createfx_types(var_01);

  if (var_0.v["type"] == "reactive_fx") {
  if (check_reactive_fx_type(var_00, var_01))
  return 1;
  else
  return 0;
  }

  foreach (var_04 in var_02) {
  if (var_0.v["type"] == var_04)
  return 1;
  }

  return 0;
}

createfx_filter_types() {
  var_00 = [];
  var_0[var_0.size] = "soundfx";
  var_0[var_0.size] = "oneshotfx";
  var_0[var_0.size] = "exploder";
  var_0[var_0.size] = "soundfx_interval";
  var_0[var_0.size] = "reactive_fx";

  if (!level.mp_createfx)
  var_0[var_0.size] = "loopfx";

  var_01 = [];

  foreach (var_04, var_03 in var_00)
  var_1[var_04] = [];

  foreach (var_06 in level.createfxent) {
  var_07 = 0;

  foreach (var_04, var_09 in var_00) {
  if (var_6.v["type"] != var_09)
  continue;

  var_07 = 1;
  var_1[var_04][var_1[var_04].size] = var_06;
  break;
  }
  }

  var_11 = [];

  for (var_12 = 0; var_12 < var_0.size; var_12++) {
  foreach (var_06 in var_1[var_12])
  var_11[var_11.size] = var_06;
  }

  level.createfxent = var_11;
}

cfxprintlnstart() {
  scripts\engine\utility::fileprint_launcher_start_file();
}

cfxprintln(var_00) {
  scripts\engine\utility::fileprint_launcher(var_00);
}

cfxprintlnend(var_00, var_01, var_02) {
  var_03 = 1;

  if (var_01 != "" || var_00)
  var_03 = 0;

  if (scripts\engine\utility::issp()) {
  var_04 = scripts\engine\utility::get_template_script_MAYBE() + var_01 + "_" + var_02 + ".gsc";

  if (var_00)
  var_04 = "backup_" + var_02 + ".gsc";
  } else {
  var_04 = scripts\engine\utility::get_template_script_MAYBE() + var_01 + "_" + var_02 + ".gsc";

  if (var_00)
  var_04 = "backup.gsc";
  }

  var_05 = scripts\engine\utility::get_template_script_MAYBE();
  var_06 = get_raw_or_devraw_subdir();
  var_07 = get_gamemode_subdir();
  scripts\engine\utility::fileprint_launcher_end_file("\share\" + var_06 + "\scripts\" + var_07 + "\maps\" + var_05 + "\gen\" + var_04, var_03);
}

get_raw_or_devraw_subdir() {
  if (isdefined(level.createfx_devraw_map) && level.createfx_devraw_map)
  return "devraw";
  else
  return "raw";
}

get_gamemode_subdir() {
  if (scripts\engine\utility::iscp())
  return "cp";
  else if (scripts\engine\utility::issp())
  return "sp";
  else
  return "mp";
}

process_button_held_and_clicked() {
  add_button("mouse1");
  add_button("BUTTON_RSHLDR");
  add_button("BUTTON_LSHLDR");
  add_button("BUTTON_RSTICK");
  add_button("BUTTON_LSTICK");
  add_button("BUTTON_A");
  add_button("BUTTON_B");
  add_button("BUTTON_X");
  add_button("BUTTON_Y");
  add_button("DPAD_UP");
  add_button("DPAD_LEFT");
  add_button("DPAD_RIGHT");
  add_button("DPAD_DOWN");
  add_kb_button("shift");
  add_kb_button("ctrl");
  add_kb_button("escape");
  add_kb_button("F1");
  add_kb_button("F5");
  add_kb_button("F4");
  add_kb_button("F2");
  add_kb_button("a");
  add_kb_button("e");
  add_kb_button("g");
  add_kb_button("c");
  add_kb_button("h");
  add_kb_button("i");
  add_kb_button("k");
  add_kb_button("l");
  add_kb_button("m");
  add_kb_button("p");
  add_kb_button("r");
  add_kb_button("s");
  add_kb_button("u");
  add_kb_button("v");
  add_kb_button("x");
  add_kb_button("z");
  add_kb_button("del");
  add_kb_button("end");
  add_kb_button("tab");
  add_kb_button("ins");
  add_kb_button("add");
  add_kb_button("space");
  add_kb_button("enter");
  add_kb_button("1");
  add_kb_button("2");
  add_kb_button("3");
  add_kb_button("4");
  add_kb_button("5");
  add_kb_button("6");
  add_kb_button("7");
  add_kb_button("8");
  add_kb_button("9");
  add_kb_button("0");
  add_kb_button("-");
  add_kb_button("=");
  add_kb_button(",");
  add_kb_button(".");
  add_kb_button("[");
  add_kb_button("]");
  add_kb_button("leftarrow");
  add_kb_button("rightarrow");
  add_kb_button("uparrow");
  add_kb_button("downarrow");
}

locked(var_00) {
  if (isdefined(level._createfx.lockedlist[var_00]))
  return 0;

  return kb_locked(var_00);
}

kb_locked(var_00) {
  return level.createfx_inputlocked && isdefined(level.button_is_kb[var_00]);
}

add_button(var_00) {
  if (locked(var_00))
  return;

  if (!isdefined(level.buttonisheld[var_00])) {
  if (level.player buttonpressed(var_00)) {
  level.buttonisheld[var_00] = 1;
  level.buttonclick[var_00] = 1;
  }
  }
  else if (!level.player buttonpressed(var_00))
  level.buttonisheld[var_00] = undefined;
}

add_kb_button(var_00) {
  level.button_is_kb[var_00] = 1;
  add_button(var_00);
}

buttondown(var_00, var_01) {
  return buttonpressed_internal(var_00) || buttonpressed_internal(var_01);
}

buttonpressed_internal(var_00) {
  if (!isdefined(var_00))
  return 0;

  if (kb_locked(var_00))
  return 0;

  return level.player buttonpressed(var_00);
}

button_is_held(var_00, var_01) {
  if (isdefined(var_01)) {
  if (isdefined(level.buttonisheld[var_01]))
  return 1;
  }

  return isdefined(level.buttonisheld[var_00]);
}

button_is_clicked(var_00, var_01) {
  if (isdefined(var_01)) {
  if (isdefined(level.buttonclick[var_01]))
  return 1;
  }

  return isdefined(level.buttonclick[var_00]);
}

init_huds() {
  level._createfx.hudelems = [];
  level._createfx.hudelem_count = 30;

  if (level.mp_createfx)
  level._createfx.hudelem_count = 16;

  var_00 = [];
  var_01 = [];
  var_0[0] = 0;
  var_1[0] = 0;
  var_0[1] = 1;
  var_1[1] = 1;
  var_0[2] = -2;
  var_1[2] = 1;
  var_0[3] = 1;
  var_1[3] = -1;
  var_0[4] = -2;
  var_1[4] = -1;
  level.cleartextmarker = newhudelem();
  level.cleartextmarker.alpha = 0;
  level.cleartextmarker.archived = 0;

  for (var_02 = 0; var_02 < level._createfx.hudelem_count; var_2++) {
  var_03 = [];

  for (var_04 = 0; var_04 < 1; var_4++) {
  var_05 = newhudelem();
  var_5.alignx = "left";
  var_5.archived = 0;
  var_5.location = 0;
  var_5.foreground = 1;
  var_5.fontscale = 1.4;
  var_5.sort = 20 - var_04;
  var_5.alpha = 1;
  var_5.x = 0 + var_0[var_04];
  var_5.y = 60 + var_1[var_04] + var_02 * 15;

  if (var_04 > 0)
  var_5.color = (0, 0, 0);

  var_3[var_3.size] = var_05;
  }

  level._createfx.hudelems[var_02] = var_03;
  }

  var_06 = newhudelem();
  var_6.archived = 0;
  var_6.alignx = "center";
  var_6.location = 0;
  var_6.foreground = 1;
  var_6.fontscale = 1.4;
  var_6.sort = 20;
  var_6.alpha = 1;
  var_6.x = 320;
  var_6.y = 40;
  level.createfx_centerprint = var_06;
}

init_crosshair() {
  var_00 = newhudelem();
  var_0.archived = 0;
  var_0.location = 0;
  var_0.alignx = "center";
  var_0.aligny = "middle";
  var_0.foreground = 1;
  var_0.fontscale = 1;
  var_0.sort = 20;
  var_0.alpha = 1;
  var_0.x = 320;
  var_0.y = 233;
}

clear_fx_hudelements() {
  level.cleartextmarker clearalltextafterhudelem();

  for (var_00 = 0; var_00 < level._createfx.hudelem_count; var_0++) {
  for (var_01 = 0; var_01 < 1; var_1++) {}
  }

  level.fxhudelements = 0;
}

set_fx_hudelement(var_00) {
  for (var_01 = 0; var_01 < 1; var_1++) {}

  level.fxhudelements++;
}

init_tool_hud() {
  if (!isdefined(level._createfx.tool_hudelems))
  level._createfx.tool_hudelems = [];

  if (!isdefined(level._createfx.tool_hud_visible))
  level._createfx.tool_hud_visible = 1;

  if (!isdefined(level._createfx.tool_hud))
  level._createfx.tool_hud = "";
}

new_tool_hud(var_00) {
  foreach (var_03, var_02 in level._createfx.tool_hudelems) {
  if (isdefined(var_2.value_hudelem))
  var_2.value_hudelem destroy();

  var_02 destroy();
  level._createfx.tool_hudelems[var_03] = undefined;
  }

  level._createfx.tool_hud = var_00;
}

current_mode_hud(var_00) {
  return level._createfx.tool_hud == var_00;
}

clear_tool_hud() {
  new_tool_hud("");
}

new_tool_hudelem(var_00) {
  var_01 = newhudelem();
  var_1.archived = 0;
  var_1.alignx = "left";
  var_1.location = 0;
  var_1.foreground = 1;
  var_1.fontscale = 1.2;
  var_1.alpha = 1;
  var_1.x = 0;
  var_1.y = 320 + var_00 * 15;
  return var_01;
}

get_tool_hudelem(var_00) {
  if (isdefined(level._createfx.tool_hudelems[var_00]))
  return level._createfx.tool_hudelems[var_00];

  return undefined;
}

set_tool_hudelem(var_00, var_01) {
  if (level.mp_createfx)
  return;

  var_02 = get_tool_hudelem(var_00);

  if (!isdefined(var_02)) {
  var_02 = new_tool_hudelem(level._createfx.tool_hudelems.size);
  level._createfx.tool_hudelems[var_00] = var_02;
  var_2.text = var_00;
  }

  if (isdefined(var_01)) {
  if (isdefined(var_2.value_hudelem))
  var_03 = var_2.value_hudelem;
  else
  {
  var_03 = new_tool_hudelem(level._createfx.tool_hudelems.size);
  var_3.x = var_3.x + 100;
  var_3.y = var_2.y;
  var_2.value_hudelem = var_03;
  }

  if (isdefined(var_3.text) && var_3.text == var_01)
  return;

  var_3.text = var_01;
  }
}

select_by_substring() {
  var_00 = getdvar("select_by_substring");

  if (var_00 == "")
  return 0;

  setdvar("select_by_substring", "");
  var_01 = [];

  foreach (var_04, var_03 in level.createfxent) {
  if (issubstr(var_3.v["fxid"], var_00))
  var_1[var_1.size] = var_04;
  }

  if (var_1.size == 0)
  return 0;

  deselect_all_ents();
  select_index_array(var_01);

  foreach (var_06 in var_01) {
  var_03 = level.createfxent[var_06];
  select_entity(var_06, var_03);
  }

  return 1;
}

select_index_array(var_00) {
  foreach (var_02 in var_00) {
  var_03 = level.createfxent[var_02];
  select_entity(var_02, var_03);
  }
}

deselect_all_ents() {
  foreach (var_02, var_01 in level._createfx.selected_fx_ents)
  deselect_entity(var_02, var_01);
}

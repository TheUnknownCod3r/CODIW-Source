/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 2808.gsc
***************************************/

gettweakabledvarvalue(var_00, var_01) {
  switch (var_00) {
  case "rule":
  var_02 = level.rules[var_01].dvar;
  break;
  case "game":
  var_02 = level.gametweaks[var_01].dvar;
  break;
  case "team":
  var_02 = level.teamtweaks[var_01].dvar;
  break;
  case "player":
  var_02 = level.playertweaks[var_01].dvar;
  break;
  case "class":
  var_02 = level.classtweaks[var_01].dvar;
  break;
  case "weapon":
  var_02 = level.weapontweaks[var_01].dvar;
  break;
  case "hardpoint":
  var_02 = level.hardpointtweaks[var_01].dvar;
  break;
  case "hud":
  var_02 = level.hudtweaks[var_01].dvar;
  break;
  default:
  var_02 = undefined;
  break;
  }

  var_03 = getdvarint(var_02);
  return var_03;
}

_meth_81E4(var_00, var_01) {
  switch (var_00) {
  case "rule":
  var_02 = level.rules[var_01].dvar;
  break;
  case "game":
  var_02 = level.gametweaks[var_01].dvar;
  break;
  case "team":
  var_02 = level.teamtweaks[var_01].dvar;
  break;
  case "player":
  var_02 = level.playertweaks[var_01].dvar;
  break;
  case "class":
  var_02 = level.classtweaks[var_01].dvar;
  break;
  case "weapon":
  var_02 = level.weapontweaks[var_01].dvar;
  break;
  case "hardpoint":
  var_02 = level.hardpointtweaks[var_01].dvar;
  break;
  case "hud":
  var_02 = level.hudtweaks[var_01].dvar;
  break;
  default:
  var_02 = undefined;
  break;
  }

  return var_02;
}

gettweakablevalue(var_00, var_01) {
  switch (var_00) {
  case "rule":
  var_02 = level.rules[var_01].value;
  break;
  case "game":
  var_02 = level.gametweaks[var_01].value;
  break;
  case "team":
  var_02 = level.teamtweaks[var_01].value;
  break;
  case "player":
  var_02 = level.playertweaks[var_01].value;
  break;
  case "class":
  var_02 = level.classtweaks[var_01].value;
  break;
  case "weapon":
  var_02 = level.weapontweaks[var_01].value;
  break;
  case "hardpoint":
  var_02 = level.hardpointtweaks[var_01].value;
  break;
  case "hud":
  var_02 = level.hudtweaks[var_01].value;
  break;
  default:
  var_02 = undefined;
  break;
  }

  return var_02;
}

gettweakablelastvalue(var_00, var_01) {
  switch (var_00) {
  case "rule":
  var_02 = level.rules[var_01].func_AA40;
  break;
  case "game":
  var_02 = level.gametweaks[var_01].func_AA40;
  break;
  case "team":
  var_02 = level.teamtweaks[var_01].func_AA40;
  break;
  case "player":
  var_02 = level.playertweaks[var_01].func_AA40;
  break;
  case "class":
  var_02 = level.classtweaks[var_01].func_AA40;
  break;
  case "weapon":
  var_02 = level.weapontweaks[var_01].func_AA40;
  break;
  case "hardpoint":
  var_02 = level.hardpointtweaks[var_01].func_AA40;
  break;
  case "hud":
  var_02 = level.hudtweaks[var_01].func_AA40;
  break;
  default:
  var_02 = undefined;
  break;
  }

  return var_02;
}

settweakabledvar(var_00, var_01, var_02) {
  switch (var_00) {
  case "rule":
  var_03 = level.rules[var_01].dvar;
  break;
  case "game":
  var_03 = level.gametweaks[var_01].dvar;
  break;
  case "team":
  var_03 = level.teamtweaks[var_01].dvar;
  break;
  case "player":
  var_03 = level.playertweaks[var_01].dvar;
  break;
  case "class":
  var_03 = level.classtweaks[var_01].dvar;
  break;
  case "weapon":
  var_03 = level.weapontweaks[var_01].dvar;
  break;
  case "hardpoint":
  var_03 = level.hardpointtweaks[var_01].dvar;
  break;
  case "hud":
  var_03 = level.hudtweaks[var_01].dvar;
  break;
  default:
  var_03 = undefined;
  break;
  }

  setdvar(var_03, var_02);
}

settweakablevalue(var_00, var_01, var_02) {
  switch (var_00) {
  case "rule":
  level.rules[var_01].func_AA40 = var_02;
  break;
  case "game":
  level.gametweaks[var_01].func_AA40 = var_02;
  break;
  case "team":
  level.teamtweaks[var_01].func_AA40 = var_02;
  break;
  case "player":
  level.playertweaks[var_01].func_AA40 = var_02;
  break;
  case "class":
  level.classtweaks[var_01].func_AA40 = var_02;
  break;
  case "weapon":
  level.weapontweaks[var_01].func_AA40 = var_02;
  break;
  case "hardpoint":
  level.hardpointtweaks[var_01].func_AA40 = var_02;
  break;
  case "hud":
  level.hudtweaks[var_01].func_AA40 = var_02;
  break;
  default:
  break;
  }
}

registertweakable(var_00, var_01, var_02, var_03) {
  if (isstring(var_03))
  var_03 = getdvar(var_02, var_03);
  else
  var_03 = getdvarint(var_02, var_03);

  switch (var_00) {
  case "rule":
  if (!isdefined(level.rules[var_01]))
  level.rules[var_01] = spawnstruct();

  level.rules[var_01].value = var_03;
  level.rules[var_01].func_AA40 = var_03;
  level.rules[var_01].dvar = var_02;
  break;
  case "game":
  if (!isdefined(level.gametweaks[var_01]))
  level.gametweaks[var_01] = spawnstruct();

  level.gametweaks[var_01].value = var_03;
  level.gametweaks[var_01].func_AA40 = var_03;
  level.gametweaks[var_01].dvar = var_02;
  break;
  case "team":
  if (!isdefined(level.teamtweaks[var_01]))
  level.teamtweaks[var_01] = spawnstruct();

  level.teamtweaks[var_01].value = var_03;
  level.teamtweaks[var_01].func_AA40 = var_03;
  level.teamtweaks[var_01].dvar = var_02;
  break;
  case "player":
  if (!isdefined(level.playertweaks[var_01]))
  level.playertweaks[var_01] = spawnstruct();

  level.playertweaks[var_01].value = var_03;
  level.playertweaks[var_01].func_AA40 = var_03;
  level.playertweaks[var_01].dvar = var_02;
  break;
  case "class":
  if (!isdefined(level.classtweaks[var_01]))
  level.classtweaks[var_01] = spawnstruct();

  level.classtweaks[var_01].value = var_03;
  level.classtweaks[var_01].func_AA40 = var_03;
  level.classtweaks[var_01].dvar = var_02;
  break;
  case "weapon":
  if (!isdefined(level.weapontweaks[var_01]))
  level.weapontweaks[var_01] = spawnstruct();

  level.weapontweaks[var_01].value = var_03;
  level.weapontweaks[var_01].func_AA40 = var_03;
  level.weapontweaks[var_01].dvar = var_02;
  break;
  case "hardpoint":
  if (!isdefined(level.hardpointtweaks[var_01]))
  level.hardpointtweaks[var_01] = spawnstruct();

  level.hardpointtweaks[var_01].value = var_03;
  level.hardpointtweaks[var_01].func_AA40 = var_03;
  level.hardpointtweaks[var_01].dvar = var_02;
  break;
  case "hud":
  if (!isdefined(level.hudtweaks[var_01]))
  level.hudtweaks[var_01] = spawnstruct();

  level.hudtweaks[var_01].value = var_03;
  level.hudtweaks[var_01].func_AA40 = var_03;
  level.hudtweaks[var_01].dvar = var_02;
  break;
  }
}

init() {
  level.func_41F9 = [];
  level.func_12AC9 = 1;
  level.rules = [];
  level.gametweaks = [];
  level.teamtweaks = [];
  level.playertweaks = [];
  level.classtweaks = [];
  level.weapontweaks = [];
  level.hardpointtweaks = [];
  level.hudtweaks = [];

  if (level.console) {
  if (level.func_13E0E || level.func_DADC)
  registertweakable("game", "graceperiod", "scr_game_graceperiod", 20);
  else
  registertweakable("game", "graceperiod", "scr_game_graceperiod", 15);

  registertweakable("game", "graceperiod_comp", "scr_game_graceperiod_comp", 30);
  } else {
  registertweakable("game", "playerwaittime", "scr_game_playerwaittime", 15);
  registertweakable("game", "playerwaittime_comp", "scr_game_playerwaittime_comp", 30);
  }

  registertweakable("game", "matchstarttime", "scr_game_matchstarttime", 15);
  registertweakable("game", "onlyheadshots", "scr_game_onlyheadshots", 0);
  registertweakable("game", "allowkillcam", "scr_game_allowkillcam", 1);
  registertweakable("game", "spectatetype", "scr_game_spectatetype", 2);
  registertweakable("game", "allow3rdspectate", "scr_game_allow3rdspectate", 1);
  registertweakable("game", "deathpointloss", "scr_game_deathpointloss", 0);
  registertweakable("game", "suicidepointloss", "scr_game_suicidepointloss", 0);
  registertweakable("team", "teamkillpointloss", "scr_team_teamkillpointloss", 0);
  registertweakable("team", "fftype", "scr_team_fftype", 0);
  registertweakable("team", "teamkillspawndelay", "scr_team_teamkillspawndelay", 0);
  registertweakable("player", "maxhealth", "scr_player_maxhealth", 100);
  registertweakable("player", "healthregentime", "scr_player_healthregentime", 2);
  registertweakable("player", "forcerespawn", "scr_player_forcerespawn", 1);
  registertweakable("player", "streamingwaittime", "scr_player_streamingwaittime", 5);
  registertweakable("weapon", "allowfrag", "scr_weapon_allowfrags", 1);
  registertweakable("weapon", "allowsmoke", "scr_weapon_allowsmoke", 1);
  registertweakable("weapon", "allowflash", "scr_weapon_allowflash", 1);
  registertweakable("weapon", "allowc4", "scr_weapon_allowc4", 1);
  registertweakable("weapon", "allowclaymores", "scr_weapon_allowclaymores", 1);
  registertweakable("weapon", "allowrpgs", "scr_weapon_allowrpgs", 1);
  registertweakable("weapon", "allowmines", "scr_weapon_allowmines", 1);
  registertweakable("hardpoint", "allowartillery", "scr_hardpoint_allowartillery", 1);
  registertweakable("hardpoint", "allowuav", "scr_hardpoint_allowuav", 1);
  registertweakable("hardpoint", "allowsupply", "scr_hardpoint_allowsupply", 1);
  registertweakable("hardpoint", "allowhelicopter", "scr_hardpoint_allowhelicopter", 1);
  registertweakable("hud", "showobjicons", "ui_hud_showobjicons", 1);
  setdvar("ui_hud_showobjicons", 1);
}

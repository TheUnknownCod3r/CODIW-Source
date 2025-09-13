/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 2700.gsc
***************************************/

init() {
  if (level.teambased && !isdefined(level.nobuddyspawns)) {
  if (!isdefined(level.func_28CE))
  level.func_28CE = [];

  level thread onplayerspawned();
  level thread onplayerconnect();
  }
}

onplayerconnect() {
  for (;;) {
  level waittill("connected", var_00);
  var_00 thread onbegincarrying();
  var_00 thread ondisconnect();
  }
}

onplayerspawned() {
  level endon("game_ended");

  for (;;) {
  level waittill("player_spawned", var_00);

  if (!isai(var_00)) {
  if (isdefined(var_0.isspawningonbattlebuddy)) {
  var_0.isspawningonbattlebuddy = undefined;

  if (isdefined(var_0.battlebuddy) && isalive(var_0.battlebuddy)) {
  if (var_0.battlebuddy getstance() != "stand")
  var_00 setstance("crouch");
  }
  }

  if (var_00 func_138DE()) {
  if (!var_00 func_8BD4()) {
  var_0.firstspawn = 0;
  var_00 finalkillcam_victim();
  }

  continue;
  }

  var_00 func_AB2B();
  }
  }
}

onbegincarrying() {
  self endon("disconnect");
  level endon("game_ended");

  for (;;) {
  self waittill("luinotifyserver", var_00, var_01);

  if (var_00 == "battlebuddy_update") {
  var_02 = !func_138DE();
  self setrankedplayerdata("common", "enableBattleBuddy", var_02);

  if (var_02)
  finalkillcam_victim();
  else
  func_AB2B();

  continue;
  }

  if (var_00 == "team_select" && self.hasspawned) {
  var_03 = func_138DE();
  func_AB2B();
  self setrankedplayerdata("common", "enableBattleBuddy", var_03);
  }
  }
}

ondisconnect() {
  self waittill("disconnect");
  func_AB2C();
}

func_136D6() {
  scripts\mp\utility\game::updatesessionstate("spectator");
  self.forcespectatorclient = self.battlebuddy getentitynumber();
  self forcethirdpersonwhenfollowing();
  self setclientomnvar("cam_scene_name", "over_shoulder");
  self setclientomnvar("cam_scene_lead", self.battlebuddy getentitynumber());
  func_136AE();
}

func_13A5F() {
  self endon("disconnect");
  self endon("abort_battlebuddy_spawn");
  self endon("teamSpawnPressed");
  level endon("game_ended");
  self setclientomnvar("ui_battlebuddy_showButtonPrompt", 1);
  self notifyonplayercommand("respawn_random", "+usereload");
  self notifyonplayercommand("respawn_random", "+activate");
  wait 0.5;
  self waittill("respawn_random");
  self setclientomnvar("ui_battlebuddy_timer_ms", 0);
  self setclientomnvar("ui_battlebuddy_showButtonPrompt", 0);
  func_FAAF();
}

func_FAAF() {
  func_419E();
  self.isspawningonbattlebuddy = undefined;
  self notify("randomSpawnPressed");
  cleanupbuddyspawn();
}

func_136AE() {
  self endon("randomSpawnPressed");
  level endon("game_ended");
  self.isspawningonbattlebuddy = undefined;
  thread func_13A5F();

  if (isdefined(self.func_28CD)) {
  var_00 = 4000 - (gettime() - self.func_28CD);

  if (var_00 < 2000)
  var_00 = 2000;
  }
  else
  var_00 = 4000;

  var_01 = checkbuddyspawn();

  if (var_1.status == 0)
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "incoming");
  else if (var_1.status == -1 || var_1.status == -3)
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "err_combat");
  else
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "err_pos");

  func_12F43(var_00);

  for (var_01 = checkbuddyspawn(); var_1.status != 0; var_01 = checkbuddyspawn()) {
  if (var_1.status == -1 || var_1.status == -3) {
  self setclientomnvar("ui_battlebuddy_status", "wait_combat");
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "err_combat");
  }
  else if (var_1.status == -2) {
  self setclientomnvar("ui_battlebuddy_status", "wait_pos");
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "err_pos");
  }
  else if (var_1.status == -4) {
  cleanupbuddyspawn();
  return;
  }

  wait 0.5;
  }

  self.isspawningonbattlebuddy = 1;
  thread func_56D5();
  self playlocalsound("copycat_steal_class");
  self notify("teamSpawnPressed");
}

func_419E() {
  self setclientomnvar("ui_battlebuddy_status", "none");
  self setclientomnvar("ui_battlebuddy_showButtonPrompt", 0);

  if (isdefined(self.battlebuddy))
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "none");
}

func_56D6(var_00) {
  scripts\mp\utility\game::setlowermessage("waiting_info", var_00, undefined, undefined, undefined, undefined, undefined, undefined, 1);
}

func_56D5() {
  func_419E();

  if (isdefined(self.battlebuddy)) {
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "on_you");
  wait 1.5;
  self.battlebuddy setclientomnvar("ui_battlebuddy_status", "none");
  }
}

checkbuddyspawn() {
  var_00 = spawnstruct();

  if (!isdefined(self.battlebuddy) || !isalive(self.battlebuddy)) {
  var_0.status = -4;
  return var_00;
  }

  return var_00;
}

cleanupbuddyspawn() {
  thread scripts\mp\spectating::setspectatepermissions();
  self.forcespectatorclient = -1;
  scripts\mp\utility\game::updatesessionstate("dead");
  self disableforcethirdpersonwhenfollowing();
  self setclientomnvar("cam_scene_name", "unknown");
  func_419E();
  self notify("abort_battlebuddy_spawn");
}

func_12F43(var_00) {
  self endon("disconnect");
  self endon("abort_battlebuddy_spawn");
  self endon("teamSpawnPressed");
  var_01 = var_00 * 0.001;
  self setclientomnvar("ui_battlebuddy_timer_ms", var_00 + gettime());
  wait(var_01);
  self setclientomnvar("ui_battlebuddy_timer_ms", 0);
}

func_138DE() {
  return self getrankedplayerdata("common", "enableBattleBuddy");
}

func_8BD4() {
  return isdefined(self.battlebuddy);
}

func_BE8E() {
  return func_138DE() && !func_8BD4();
}

func_9FD1(var_00) {
  return self != var_00 && self.team == var_0.team && var_00 func_BE8E();
}

func_3876() {
  return func_8BD4() && scripts\mp\utility\game::isreallyalive(self.battlebuddy);
}

func_C88C(var_00) {
  func_E103(var_00);
  self.battlebuddy = var_00;
  var_0.battlebuddy = self;
  self setclientomnvar("ui_battlebuddy_idx", var_00 getentitynumber());
  var_00 setclientomnvar("ui_battlebuddy_idx", self getentitynumber());
}

motionblurhqenable() {
  return level.func_28CE[self.team];
}

func_1848(var_00) {
  if (!isdefined(level.func_28CE[var_0.team]))
  level.func_28CE[var_0.team] = var_00;
  else if (level.func_28CE[var_0.team] != var_00)
  return;
}

func_E103(var_00) {
  if (isdefined(var_0.team) && isdefined(level.func_28CE[var_0.team]) && var_00 == level.func_28CE[var_0.team])
  level.func_28CE[var_0.team] = undefined;
}

finalkillcam_victim() {
  if (level.onlinegame) {
  self.func_6D95 = self getfireteammembers();

  if (self.func_6D95.size >= 1) {
  foreach (var_01 in self.func_6D95) {
  if (func_9FD1(var_01))
  func_C88C(var_01);
  }
  }
  }

  if (!func_8BD4()) {
  var_01 = motionblurhqenable();

  if (isdefined(var_01) && func_9FD1(var_01))
  func_C88C(var_01);
  else
  {
  func_1848(self);
  self setclientomnvar("ui_battlebuddy_idx", -1);
  }
  }
}

func_419D() {
  if (!isalive(self))
  func_FAAF();

  self setclientomnvar("ui_battlebuddy_idx", -1);
  self.battlebuddy = undefined;
}

func_AB2B() {
  if (func_8BD4()) {
  var_00 = self.battlebuddy;
  func_419D();
  self setrankedplayerdata("common", "enableBattleBuddy", 0);
  var_00 func_419D();
  var_00 finalkillcam_victim();
  } else {
  func_E103(self);
  self setclientomnvar("ui_battlebuddy_idx", -1);
  }
}

func_AB2C() {
  if (func_8BD4()) {
  var_00 = self.battlebuddy;
  var_00 func_419D();
  var_00 finalkillcam_victim();
  var_00 func_419E();
  } else {
  foreach (var_03, var_02 in level.func_28CE) {
  if (var_02 == self) {
  level.func_28CE[var_03] = undefined;
  break;
  }
  }
  }
}

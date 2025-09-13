/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 2800.gsc
***************************************/

init() {
  level.spectateoverride["allies"] = spawnstruct();
  level.spectateoverride["axis"] = spawnstruct();
  level thread onplayerconnect();

  if (getdvarint("cg_mlg_static_cameras", 0) != 0)
  level thread func_7F6C();
}

createmlgcamobject(var_00, var_01) {
  precacheshader(var_00);
  var_02 = spawn("script_model", (0, 0, 0));
  var_02 setmodel("tag_origin");
  var_2.angles = (0, 0, 0);
  return var_02;
}

setlevelmlgcam(var_00, var_01) {
  var_02 = var_00;

  if (var_02 >= 4)
  var_02 = var_02 - 4;

  var_03 = tolower(getdvar("mapname"));
  var_04 = tablelookup(var_01, 0, var_03, var_02 * 2 + 1);

  if (var_04 != "") {
  var_05 = var_00 + 1;

  if (var_00 >= 5)
  var_05 = var_05 - 4;

  level.cameramapobjs[var_00] = createmlgcamobject("compass_icon_codcaster_cam", 1);
  level.numbermapobjs[var_00] = createmlgcamobject("compass_icon_codcaster_num" + var_05, 0);
  var_06 = tablelookup(var_01, 0, var_03, var_02 * 2 + 2);
  level.camerapos[var_00] = getcameravecorang(var_04);
  level.cameraang[var_00] = getcameravecorang(var_06);
  level.camerahighestindex = var_00;
  }
}

func_7F6C() {
  while (!isdefined(level.objidpool))
  wait 0.05;

  var_00 = "mp\CameraPositions";
  var_01 = var_00 + "_" + level.gametype + ".csv";
  var_00 = var_00 + ".csv";
  level.cameramapobjs = [];
  level.numbermapobjs = [];

  for (var_02 = 0; var_02 < 4; var_2++)
  setlevelmlgcam(var_02, var_00);

  for (var_02 = 4; var_02 < 8; var_2++)
  setlevelmlgcam(var_02, var_01);
}

getcameravecorang(var_00) {
  var_01 = strtok(var_00, " ");
  var_02 = (0, 0, 0);

  if (isdefined(var_1[0]) && isdefined(var_1[1]) && isdefined(var_1[2]))
  var_02 = (int(var_1[0]), int(var_1[1]), int(var_1[2]));

  return var_02;
}

onplayerconnect() {
  for (;;) {
  level waittill("connected", var_00);
  var_00 thread func_C541();
  var_00 thread func_C540();
  var_00 thread func_C5A1();
  var_00 thread func_C531();
  var_00 thread func_C5A2();
  }
}

func_C541() {
  self endon("disconnect");

  for (;;) {
  self waittill("joined_team");
  setspectatepermissions();
  }
}

func_C540() {
  self endon("disconnect");

  for (;;) {
  self waittill("joined_spectators");
  setspectatepermissions();
  self setclientomnvar("ui_callout_area_id", -1);

  if (self ismlgspectator() || isdefined(self.pers["mlgSpectator"]) && self.pers["mlgSpectator"]) {
  self setmlgspectator(1);
  self setclientomnvar("ui_use_mlg_hud", 1);
  self _meth_85B1(0);
  thread updatemlgspectator();
  thread autoattachtoplayer();
  }
  }
}

func_C5A1() {
  self endon("disconnect");

  for (;;) {
  self waittill("spectating_cycle");
  var_00 = self getspectatingplayer();

  if (self ismlgspectator() || isdefined(var_00)) {
  var_01 = level.calloutglobals.areaidmap[var_0.calloutarea];
  self setclientomnvar("ui_callout_area_id", var_01);

  if (level.gametype == "ball")
  scripts\mp\gametypes\ball::ball_goal_fx_for_player(self);
  }
  }
}

func_C5A2() {
  self endon("disconnect");

  for (;;) {
  self waittill("spectating_mlg_camera");
  var_00 = self _meth_858E();

  if (self ismlgspectator() || isdefined(self.pers["mlgSpectator"]) && self.pers["mlgSpectator"]) {
  if (isdefined(var_00)) {
  self setclientomnvar("ui_callout_area_id", -1);
  continue;
  }
  }
  }
}

func_C531() {
  self endon("disconnect");

  for (;;) {
  self waittill("luinotifyserver", var_00, var_01);

  if (var_00 == "mlg_view_change")
  scripts\mp\playerlogic::resetuidvarsonconnect();
  }
}

updatespectatesettings() {
  level endon("game_ended");

  for (var_00 = 0; var_00 < level.players.size; var_0++)
  level.players[var_00] setspectatepermissions();
}

linkcameratoball(var_00) {
  self endon("disconnect");
  self endon("joined_team");
  self endon("joined_spectators");

  for (;;) {
  if (!isdefined(self.codcasterballcamfollow))
  break;

  if (self isspectatingplayer()) {
  wait 0.05;
  continue;
  }

  self cameralinkto(self.codcasterballcamfollow, "tag_origin", 1);
  var_01 = level.codcasterball.origin;
  var_02 = (0, 0, 30);
  var_02 = var_02 + -80 * var_00;
  var_03 = var_01 + var_02;
  self.codcasterballcamfollow moveto(var_03, 10.5, 5.2, 5.2);
  self.codcasterballcamfollow.angles = vectortoangles(var_00);
  break;
  }
}

autoattachtoplayer() {
  self endon("disconnect");
  self endon("game_ended");
  self endon("joined_team");
  self endon("joined_spectator");
  self endon("spectating_mlg_camera");

  for (;;) {
  wait 1.0;
  var_00 = undefined;

  if (!self ismlgspectator() || self isspectatingplayer())
  break;

  if (level.players.size > 1) {
  var_01 = scripts\mp\utility\game::getteamarray("allies", 0);

  if (var_1.size > 0)
  var_00 = scripts\mp\utility\game::getlowestclientnum(var_01, 1);

  if (!isdefined(var_00)) {
  var_01 = scripts\mp\utility\game::getteamarray("axis", 0);

  if (var_1.size > 0)
  var_00 = scripts\mp\utility\game::getlowestclientnum(var_01, 1);
  }

  if (isdefined(var_00)) {
  self spectateclientnum(var_00);
  break;
  }
  }
  }
}

updatemlgspectator() {
  self endon("joined_team");
  self endon("disconnect");
  self.iswatchingcodcasterball = 0;
  self.codcasterballcamfollow = undefined;
  self.spectatingplayerbeforeballcam = undefined;

  for (;;) {
  var_00 = isdefined(level.codcasterball);

  if (!var_00 || !self ismlgfollowdroneactive()) {
  if (self.iswatchingcodcasterball) {
  self.iswatchingcodcasterball = 0;
  self.codcasterballcamfollow unlink();
  self.codcasterballcamfollow delete();
  self.codcasterballcamfollow = undefined;

  if (!self isspectatingplayer() && isdefined(self.spectatingplayerbeforeballcam))
  self spectateclientnum(self.spectatingplayerbeforeballcam getentitynumber());
  else
  self cameraunlink();

  self.spectatingplayerbeforeballcam = undefined;
  }
  }
  else if (!self.iswatchingcodcasterball) {
  if (self ismlgfollowdroneactive()) {
  var_01 = self getspectatingplayer();

  if (isdefined(var_01) && isdefined(level.codcasterballowner) && var_01 == level.codcasterballowner) {
  self.iswatchingcodcasterball = 1;
  self.spectatingplayerbeforeballcam = var_01;
  var_02 = vectornormalize(level.codcasterballinitialforcevector);
  var_03 = var_01 getvieworigin();
  self.codcasterballcamfollow = spawn("script_model", var_03);
  self.codcasterballcamfollow.angles = vectortoangles(var_02);
  self.codcasterballcamfollow setmodel("tag_origin");
  stopspectateplayer(self getentitynumber());
  self cameraunlink();
  thread linkcameratoball(var_02);
  }
  }
  }
  else if (isdefined(self.codcasterballcamfollow)) {
  var_04 = level.codcasterball.origin;
  var_05 = self.codcasterballcamfollow.origin;
  var_06 = distance2d(var_04, var_05);
  var_07 = var_04 - var_05;
  var_08 = (var_7[0], var_7[1], 0);
  var_08 = vectornormalize(var_08);
  var_09 = var_04;
  var_10 = (0, 0, 30);
  var_10 = var_10 + -80 * var_08;
  var_11 = var_09 + var_10;

  if (var_06 > 600)
  self.codcasterballcamfollow.origin = var_11;
  else
  self.codcasterballcamfollow moveto(var_11, 0.5, 0, 0.2);

  self.codcasterballcamfollow rotateto(vectortoangles(var_07), 0.15, 0.05, 0.05);
  }

  wait 0.05;
  }
}

setspectatepermissions() {
  if (level.gameended && gettime() - level.gameendtime >= 2000) {
  if (level.multiteambased) {
  for (var_00 = 0; var_00 < level.teamnamelist.size; var_0++)
  self allowspectateteam(level.teamnamelist[var_00], 0);
  } else {
  self allowspectateteam("allies", 0);
  self allowspectateteam("axis", 0);
  }

  self allowspectateteam("freelook", 0);
  self allowspectateteam("none", 1);
  return;
  }

  var_01 = scripts\mp\tweakables::gettweakablevalue("game", "spectatetype");

  if (self ismlgspectator())
  var_01 = 2;

  if (scripts\mp\utility\game::bot_is_fireteam_mode())
  var_01 = 1;

  var_02 = self.sessionteam;

  switch (var_01) {
  case 0:
  func_F6C5();
  break;
  case 1:
  self notify("waitForGameStartSpectate");

  if (var_02 != "spectator")
  func_F87A(var_02);
  else if (isdefined(self.pers["last_team"])) {
  var_02 = self.pers["last_team"];
  func_F87A(var_02);
  }
  else if (scripts\mp\utility\game::gameflag("prematch_done")) {
  if (randomint(2))
  var_02 = "allies";
  else
  var_02 = "axis";

  func_F87A(var_02);
  } else {
  thread waitforgamestartspectate();
  return;
  }

  break;
  case 2:
  func_F71A();
  break;
  case 3:
  if (var_02 == "spectator")
  func_F71A();
  else
  func_F87A(var_02);

  break;
  }

  if (isdefined(var_02) && (var_02 == "axis" || var_02 == "allies")) {
  if (isdefined(level.spectateoverride[var_02].allowfreespectate))
  self allowspectateteam("freelook", 1);

  if (isdefined(level.spectateoverride[var_02].allowenemyspectate))
  self allowspectateteam(scripts\mp\utility\game::getotherteam(var_02), 1);
  }
}

waitforgamestartspectate() {
  self endon("waitForGameStartSpectate");
  level waittill("prematch_over");
  thread setspectatepermissions();
}

func_F6C5() {
  if (level.multiteambased) {
  for (var_00 = 0; var_00 < level.teamnamelist.size; var_0++)
  self allowspectateteam(level.teamnamelist[var_00], 0);
  } else {
  self allowspectateteam("allies", 0);
  self allowspectateteam("axis", 0);
  }

  self allowspectateteam("freelook", 0);
  self allowspectateteam("none", 0);
}

func_F87A(var_00) {
  if (!level.teambased) {
  self allowspectateteam("allies", 1);
  self allowspectateteam("axis", 1);
  self allowspectateteam("none", 1);
  self allowspectateteam("freelook", 0);
  }
  else if (isdefined(var_00) && (var_00 == "allies" || var_00 == "axis") && !level.multiteambased) {
  self allowspectateteam(var_00, 1);
  self allowspectateteam(scripts\mp\utility\game::getotherteam(var_00), 0);
  self allowspectateteam("freelook", 0);
  self allowspectateteam("none", 0);
  }
  else if (isdefined(var_00) && issubstr(var_00, "team_") && level.multiteambased) {
  for (var_01 = 0; var_01 < level.teamnamelist.size; var_1++) {
  if (var_00 == level.teamnamelist[var_01]) {
  self allowspectateteam(level.teamnamelist[var_01], 1);
  continue;
  }

  self allowspectateteam(level.teamnamelist[var_01], 0);
  }

  self allowspectateteam("freelook", 0);
  self allowspectateteam("none", 0);
  } else {
  if (level.multiteambased) {
  for (var_01 = 0; var_01 < level.teamnamelist.size; var_1++)
  self allowspectateteam(level.teamnamelist[var_01], 0);
  } else {
  self allowspectateteam("allies", 0);
  self allowspectateteam("axis", 0);
  }

  self allowspectateteam("freelook", 0);
  self allowspectateteam("none", 0);
  }
}

func_F71A() {
  if (level.multiteambased) {
  for (var_00 = 0; var_00 < level.teamnamelist.size; var_0++)
  self allowspectateteam(level.teamnamelist[var_00], 1);
  } else {
  self allowspectateteam("allies", 1);
  self allowspectateteam("axis", 1);
  }

  self allowspectateteam("freelook", 1);
  self allowspectateteam("none", 1);
}

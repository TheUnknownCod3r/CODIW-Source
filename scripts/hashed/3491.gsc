/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 3491.gsc
***************************************/

init() {
  scripts\mp\killstreaks\helicopter_guard::func_AADA();
  scripts\mp\killstreaks\helicopter_guard::func_AAD8();
  scripts\mp\killstreaks\killstreaks::registerkillstreak("heli_sniper", ::func_128E8);
  var_00 = spawnstruct();
  var_0.scorepopup = "destroyed_helo_scout";
  var_0.callout = "callout_destroyed_helo_scout";
  var_0.samdamagescale = 0.09;
  var_0.enginevfxtag = "tag_engine_right";
  level.heliconfigs["heli_sniper"] = var_00;
}

func_128E8(var_00, var_01) {
  var_02 = func_7E37(self.origin);
  var_03 = func_7E34(self.origin);
  var_04 = vectortoangles(var_3.origin - var_2.origin);

  if (isdefined(self.underwater) && self.underwater)
  return 0;

  if (isdefined(self.isjuggernautlevelcustom) && self.isjuggernautlevelcustom == 1)
  return 0;
  else if (!isdefined(level.func_1A66) || !isdefined(var_02) || !isdefined(var_03)) {
  self iprintlnbold(&"KILLSTREAKS_UNAVAILABLE_IN_LEVEL");
  return 0;
  }

  var_05 = 1;

  if (func_68C2()) {
  self iprintlnbold(&"KILLSTREAKS_AIR_SPACE_TOO_CROWDED");
  return 0;
  }

  if (scripts\mp\utility\game::currentactivevehiclecount() >= scripts\mp\utility\game::maxvehiclesallowed() || level.fauxvehiclecount + var_05 >= scripts\mp\utility\game::maxvehiclesallowed()) {
  self iprintlnbold(&"KILLSTREAKS_TOO_MANY_VEHICLES");
  return 0;
  }

  if (isdefined(self.iscapturingcrate) && self.iscapturingcrate)
  return 0;

  if (isdefined(self.isreviving) && self.isreviving)
  return 0;

  var_06 = func_49D1(self, var_02, var_03, var_04, var_01, var_00);

  if (!isdefined(var_06))
  return 0;

  var_07 = helipathmemory(var_06, var_01);

  if (isdefined(var_07) && var_07 == "fail")
  return 0;

  return 1;
}

func_68C2() {
  return isdefined(level.lbsniper);
}

func_7E37(var_00) {
  var_01 = undefined;
  var_02 = 999999;

  foreach (var_04 in level.air_start_nodes) {
  var_05 = distance(var_4.origin, var_00);

  if (var_05 < var_02) {
  var_01 = var_04;
  var_02 = var_05;
  }
  }

  return var_01;
}

func_49D1(var_00, var_01, var_02, var_03, var_04, var_05) {
  var_06 = getent("airstrikeheight", "targetname");
  var_07 = var_2.origin;
  var_08 = anglestoforward(var_03);
  var_09 = var_1.origin;
  var_10 = spawnhelicopter(var_00, var_09, var_08, "attack_littlebird_mp", "vehicle_aas_72x_killstreak");

  if (!isdefined(var_10))
  return;

  var_11 = scripts\mp\utility\game::gethelipilottraceoffset();
  var_12 = var_07 + (scripts\mp\utility\game::gethelipilotmeshoffset() + var_11);
  var_13 = var_07 + (scripts\mp\utility\game::gethelipilotmeshoffset() - var_11);
  var_14 = bullettrace(var_12, var_13, 0, 0, 0, 0, 1);

  if (isdefined(var_14["entity"]) && var_14["normal"][2] > 0.1)
  var_07 = var_14["position"] - scripts\mp\utility\game::gethelipilotmeshoffset() + (0, 0, 384);

  var_10 scripts\mp\killstreaks\helicopter::addtolittlebirdlist("lbSniper");
  var_10 thread scripts\mp\killstreaks\helicopter::func_E111();
  var_10 thread func_136B6();
  var_10.lifeid = var_05;
  var_10.forward = var_08;
  var_10.func_C973 = var_09;
  var_10.func_C96C = var_07;
  var_10.func_C96B = var_1.origin;
  var_10.func_7003 = var_7[2];
  var_10.maxheight = var_6.origin;
  var_10.func_C537 = var_1.origin;
  var_10.func_CB45 = var_10.func_C537 + (0, 0, 300);
  var_10.func_90F1 = var_10.func_C537 + (0, 0, 600);
  var_10.func_7338 = var_8[1];
  var_10.func_273E = var_8[1] + 180;

  if (var_10.func_273E > 360)
  var_10.func_273E = var_10.func_273E - 360;

  var_10.helitype = "littlebird";
  var_10.func_8DA0 = "littlebird";
  var_10.func_AED3 = var_1.func_C6F9;
  var_10.func_1CA6 = 1;
  var_10.attractor = missile_createattractorent(var_10, level.func_8D2E, level.func_8D2D);
  var_10.isdeserteagle = 0;
  var_10.maxhealth = level.func_8D73;
  var_10 thread scripts\mp\killstreaks\flares::flares_monitor(1);
  var_10 thread scripts\mp\killstreaks\helicopter::heli_damage_monitor("heli_sniper", 1);
  var_10 thread func_8DB4(var_04);
  var_10.owner = var_00;
  var_10.team = var_0.team;
  var_10 thread func_AB2F();
  var_10.speed = 100;
  var_10.func_1E2D = 100;
  var_10.followspeed = 40;
  var_10 setcandamage(1);
  var_10 setmaxpitchroll(45, 45);
  var_10 vehicle_setspeed(var_10.speed, 100, 40);
  var_10 setyawspeed(120, 60);
  var_10 sethoverparams(10, 10, 60);
  var_10 setneargoalnotifydist(512);
  var_10.func_A644 = 0;
  var_10.streakname = "heli_sniper";
  var_10.func_1C79 = 0;
  var_10.func_C834 = 0;
  var_10 hidepart("tag_wings");
  return var_10;
}

func_7DFC(var_00) {
  self endon("death");
  self endon("crashing");
  self endon("helicopter_removed");
  self endon("heightReturned");
  var_01 = getent("airstrikeheight", "targetname");

  if (isdefined(var_01))
  var_02 = var_1.origin[2];
  else if (isdefined(level.airstrikeheightscale))
  var_02 = 850 * level.airstrikeheightscale;
  else
  var_02 = 850;

  var_03 = bullettrace(var_00, var_00 - (0, 0, 10000), 0, self, 0, 0, 0, 0);
  var_04 = var_3["position"][2];
  var_05 = 0;
  var_06 = 0;

  for (var_07 = 0; var_07 < 30; var_7++) {
  wait 0.05;
  var_08 = var_07 % 8;
  var_09 = var_07 * 7;

  switch (var_08) {
  case 0:
  var_05 = var_09;
  var_06 = var_09;
  break;
  case 1:
  var_05 = var_09 * -1;
  var_06 = var_09 * -1;
  break;
  case 2:
  var_05 = var_09 * -1;
  var_06 = var_09;
  break;
  case 3:
  var_05 = var_09;
  var_06 = var_09 * -1;
  break;
  case 4:
  var_05 = 0;
  var_06 = var_09 * -1;
  break;
  case 5:
  var_05 = var_09 * -1;
  var_06 = 0;
  break;
  case 6:
  var_05 = var_09;
  var_06 = 0;
  break;
  case 7:
  var_05 = 0;
  var_06 = var_09;
  break;
  default:
  break;
  }

  var_10 = bullettrace(var_00 + (var_05, var_06, 1000), var_00 - (var_05, var_06, 10000), 0, self, 0, 0, 0, 0, 0);

  if (isdefined(var_10["entity"]))
  continue;

  if (var_10["position"][2] + 145 > var_04)
  var_04 = var_10["position"][2] + 145;
  }

  return var_04;
}

helipathmemory(var_00, var_01) {
  level endon("game_ended");
  var_00 endon("death");
  var_00 endon("crashing");
  var_00 endon("owner_disconnected");
  var_00 endon("killstreakExit");
  var_02 = func_7E37(self.origin);
  level thread scripts\mp\utility\game::teamplayercardsplash("used_heli_sniper", self, self.team);

  if (isdefined(var_2.angles))
  var_03 = var_2.angles;
  else
  var_03 = (0, 0, 0);

  scripts\engine\utility::allow_usability(0);
  var_04 = var_0.func_7003;

  if (isdefined(var_2.neighbors[0]))
  var_05 = var_2.neighbors[0];
  else
  var_05 = func_7E34(self.origin);

  var_06 = anglestoforward(self.angles);
  var_07 = var_5.origin * (1, 1, 0) + (0, 0, 1) * var_04 + var_06 * -100;
  var_0.targetpos = var_07;
  var_0.func_4BF7 = var_05;
  var_08 = func_BCD7(var_00);

  if (isdefined(var_08) && var_08 == "fail") {
  var_00 thread heliisfacing();
  return var_08;
  } else {
  thread func_C53A(var_00);
  return var_08;
  }
}

func_C53A(var_00) {
  level endon("game_ended");
  var_00 endon("death");
  var_00 endon("crashing");
  var_00 endon("owner_disconnected");
  var_00 endon("killstreakExit");

  if (isdefined(self.func_9382))
  func_52CD();

  var_00 thread _meth_835D();
  var_00 setyawspeed(1, 1, 1, 0.1);
  var_00 notify("picked_up_passenger");
  scripts\engine\utility::allow_usability(1);
  var_00 vehicle_setspeed(var_0.speed, 100, 40);
  self.onhelisniper = 1;
  self.func_8DD6 = var_00;
  var_00 endon("owner_death");
  var_00 thread func_DB16();
  var_00 thread func_AB2E();
  var_00 setvehgoalpos(var_0.targetpos, 1);
  var_00 thread func_8DB3();
  var_00 waittill("near_goal");
  var_00 thread helimakedepotwait();
  thread watchearlyexit(var_00);
  wait 45;
  self notify("heli_sniper_timeout");
  func_5820(var_00);
}

func_5820(var_00) {
  var_00 notify("dropping");
  var_00 thread func_8DD1();
  var_00 waittill("at_dropoff");
  var_00 vehicle_setspeed(60);
  var_00 setyawspeed(180, 180, 180, 0.3);
  wait 1;

  if (!scripts\mp\utility\game::isreallyalive(self))
  return;

  thread func_F881();
  self stopridingvehicle();
  self allowjump(1);
  self setstance("stand");
  self.onhelisniper = 0;
  self.func_8DD6 = undefined;
  var_0.func_C834 = 0;
  scripts\mp\utility\game::_takeweapon("iw6_gm6helisnipe_mp_gm6scope");
  self enableweaponswitch();
  scripts\mp\utility\game::setrecoilscale();
  var_01 = scripts\engine\utility::getlastweapon();

  if (!self hasweapon(var_01))
  var_01 = scripts\mp\killstreaks\utility::getfirstprimaryweapon();

  scripts\mp\utility\game::func_1136C(var_01);
  wait 1;

  if (isdefined(var_00))
  var_00 thread heliisfacing();
}

watchearlyexit(var_00) {
  self endon("heli_sniper_timeout");
  var_00 thread scripts\mp\killstreaks\killstreaks::allowridekillstreakplayerexit("dropping");
  var_00 waittill("killstreakExit");
  func_5820(var_00);
}

func_BCD7(var_00) {
  self endon("disconnect");
  self visionsetnakedforplayer("black_bw", 0.5);
  scripts\mp\utility\game::set_visionset_for_watching_players("black_bw", 0.5, 1.0);
  var_01 = scripts\engine\utility::waittill_any_timeout(0.5, "death");
  scripts\mp\hostmigration::waittillhostmigrationdone();

  if (var_01 == "death") {
  thread scripts\mp\killstreaks\killstreaks::clearrideintro(1.0);
  return "fail";
  }

  self cancelmantle();

  if (var_01 != "disconnect") {
  thread scripts\mp\killstreaks\killstreaks::clearrideintro(1.0, 0.75);

  if (self.team == "spectator")
  return "fail";
  }

  var_00 func_24A6();

  if (!isalive(self))
  return "fail";

  level.func_8DD7 = var_00;
  level notify("update_uplink");
}

func_52CD() {
  foreach (var_01 in self.func_9382) {
  if (isdefined(var_1.carriedby) && var_1.carriedby == self) {
  self getrigindexfromarchetyperef();
  self.iscarrying = undefined;
  self.carrieditem = undefined;

  if (isdefined(var_1.bombsquadmodel))
  var_1.bombsquadmodel delete();

  var_01 delete();
  self enableweapons();
  }
  }
}

func_8DB3() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self endon("leaving");
  self.owner endon("death");
  var_00 = self.origin + anglestoright(self.owner.angles) * 1000;
  self.func_B00E = spawn("script_origin", var_00);
  self setlookatent(self.func_B00E);
  self setyawspeed(360, 120);

  for (;;) {
  wait 0.25;
  var_00 = self.origin + anglestoright(self.owner.angles) * 1000;
  self.func_B00E.origin = var_00;
  }
}

func_24A6() {
  self.owner notify("force_cancel_sentry");
  self.owner notify("force_cancel_ims");
  self.owner notify("force_cancel_placement");
  self.owner notify("cancel_carryRemoteUAV");
  self.owner setplayerangles(self gettagangles("TAG_RIDER"));
  self.owner ridevehicle(self, 40, 70, 10, 70, 1);
  self.owner setstance("crouch");
  self.owner allowjump(0);
  thread func_DE3E();
  self.func_C834 = 1;
  self notify("boarded");
  self.owner.chopper = self;
}

func_8DD1() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self endon("owner_disconnected");
  self endon("owner_death");
  var_00 = undefined;
  var_01 = undefined;
  var_02 = undefined;
  var_03 = 0;

  foreach (var_05 in level.func_1A66) {
  if (!isdefined(var_5.script_parameters) || !issubstr(var_5.script_parameters, "pickupNode"))
  continue;

  var_06 = distancesquared(var_5.origin, self.origin);

  if (!isdefined(var_02) || var_06 < var_02) {
  var_01 = var_05;
  var_02 = var_06;

  if (var_5.script_parameters == "pickupNodehigh") {
  var_03 = 1;
  continue;
  }

  var_03 = 0;
  }
  }

  if (scripts\mp\utility\game::getmapname() == "mp_chasm") {
  if (var_1.origin == (-224, -1056, 2376))
  var_1.origin = (-304, -896, 2376);
  }

  if (var_03 && !bullettracepassed(self.origin, var_1.origin, 0, self)) {
  self setvehgoalpos(self.origin + (0, 0, 2300), 1);
  func_137AB("near_goal", "goal", 5);
  var_08 = var_1.origin;
  var_08 = var_08 + (0, 0, 1500);
  }
  else if (var_1.origin[2] > self.origin[2])
  var_08 = var_1.origin;
  else
  {
  var_08 = var_1.origin * (1, 1, 0);
  var_08 = var_08 + (0, 0, self.origin[2]);
  }

  self setvehgoalpos(var_08, 1);
  var_09 = func_7DFC(var_08);
  var_10 = var_08 * (1, 1, 0);
  var_11 = var_10 + (0, 0, var_09);
  func_137AB("near_goal", "goal", 5);
  self.func_BCB4 = 0;
  self setvehgoalpos(var_11 + (0, 0, 200), 1);
  self.func_5D43 = 1;
  func_137AB("near_goal", "goal", 5);
  self.func_BCB4 = 1;
  self notify("at_dropoff");
}

func_137AB(var_00, var_01, var_02) {
  level endon("game_ended");
  self endon(var_00);
  self endon(var_01);
  wait(var_02);
}

helimakedepotwait() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self.owner endon("death");
  self.owner endon("disconnect");
  self endon("dropping");
  self vehicle_setspeed(60, 45, 20);
  self setneargoalnotifydist(8);

  for (;;) {
  var_00 = self.owner getnormalizedmovement();

  if (var_0[0] >= 0.15 || var_0[1] >= 0.15 || var_0[0] <= -0.15 || var_0[1] <= -0.15)
  thread func_B31F(var_00);

  wait 0.05;
  }
}

func_8DB8() {
  self vehicle_setspeed(80, 60, 20);
  self setneargoalnotifydist(8);

  for (;;) {
  var_00 = self.owner getnormalizedmovement();

  if (var_0[0] >= 0.15 || var_0[1] >= 0.15 || var_0[0] <= -0.15 || var_0[1] <= -0.15)
  thread func_B320(var_00);

  wait 0.05;
  }
}

func_B320(var_00) {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self.owner endon("death");
  self.owner endon("disconnect");
  self endon("dropping");
  self notify("manualMove");
  self endon("manualMove");
  var_01 = anglestoforward(self.owner.angles) * (350 * var_0[0]);
  var_02 = anglestoright(self.owner.angles) * (250 * var_0[1]);
  var_03 = var_01 + var_02;
  var_04 = self.origin + var_03;
  var_04 = var_04 * (1, 1, 0);
  var_04 = var_04 + (0, 0, self.maxheight[2]);

  if (distance2dsquared((0, 0, 0), var_04) > 8000000)
  return;

  self setvehgoalpos(var_04, 1);
  self waittill("goal");
}

func_B31F(var_00) {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self.owner endon("death");
  self.owner endon("disconnect");
  self endon("dropping");
  self notify("manualMove");
  self endon("manualMove");
  var_01 = anglestoforward(self.owner.angles) * (250 * var_0[0]);
  var_02 = anglestoright(self.owner.angles) * (250 * var_0[1]);
  var_03 = var_01 + var_02;
  var_04 = 256;
  var_05 = self.origin + var_03;
  var_06 = scripts\mp\utility\game::gethelipilottraceoffset();
  var_07 = var_05 + (scripts\mp\utility\game::gethelipilotmeshoffset() + var_06);
  var_08 = var_05 + (scripts\mp\utility\game::gethelipilotmeshoffset() - var_06);
  var_09 = bullettrace(var_07, var_08, 0, 0, 0, 0, 1);

  if (isdefined(var_9["entity"]) && var_9["normal"][2] > 0.1) {
  var_05 = var_9["position"] - scripts\mp\utility\game::gethelipilotmeshoffset() + (0, 0, var_04);
  var_10 = var_5[2] - self.origin[2];

  if (var_10 > 1000)
  return;

  self setvehgoalpos(var_05, 1);
  self waittill("goal");
  }
}

heliisfacing() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self notify("end_disconnect_check");
  self notify("end_death_check");
  self notify("leaving");

  if (isdefined(self.func_A79F))
  self.func_A79F delete();

  if (isdefined(self.trigger))
  self.trigger delete();

  if (isdefined(self.turret))
  self.turret delete();

  if (isdefined(self.func_BD6D))
  self.func_BD6D scripts\mp\hud_util::destroyelem();

  if (isdefined(self.func_1137A))
  self.func_1137A scripts\mp\hud_util::destroyelem();

  if (isdefined(self.func_BCCF))
  self.func_BCCF scripts\mp\hud_util::destroyelem();

  self getplayerkillstreakcombatmode();
  level.func_8DD7 = undefined;
  level notify("update_uplink");
  self setyawspeed(220, 220, 220, 0.3);
  self vehicle_setspeed(120, 60);
  self setvehgoalpos(self.origin + (0, 0, 1200), 1);
  self waittill("goal");
  var_00 = (self.func_C96B - self.func_C96C) * 5000;
  self setvehgoalpos(var_00, 1);
  self vehicle_setspeed(300, 75);
  self.func_AB32 = 1;
  scripts\engine\utility::waittill_any_timeout(5, "goal");

  if (isdefined(level.lbsniper) && level.lbsniper == self)
  level.lbsniper = undefined;

  self notify("delete");
  self delete();
}

func_8DB4(var_00) {
  level endon("game_ended");
  self endon("leaving");
  self waittill("death");
  scripts\mp\hostmigration::waittillhostmigrationdone();
  thread scripts\mp\killstreaks\helicopter::lbonkilled();

  if (isdefined(self.func_A79F))
  self.func_A79F delete();

  if (isdefined(self.trigger))
  self.trigger delete();

  if (isdefined(self.turret))
  self.turret delete();

  if (isdefined(self.func_BD6D))
  self.func_BD6D scripts\mp\hud_util::destroyelem();

  if (isdefined(self.func_1137A))
  self.func_1137A scripts\mp\hud_util::destroyelem();

  if (isdefined(self.func_BCCF))
  self.func_BCCF scripts\mp\hud_util::destroyelem();

  if (isdefined(self.owner) && isalive(self.owner) && self.func_C834 == 1) {
  self.owner stopridingvehicle();
  var_01 = undefined;
  var_02 = undefined;

  if (isdefined(self.attackers)) {
  var_03 = 0;

  foreach (var_06, var_05 in self.attackers) {
  if (var_05 >= var_03) {
  var_03 = var_05;
  var_01 = var_06;
  }
  }
  }

  if (isdefined(var_01)) {
  foreach (var_08 in level.participants) {
  if (var_08 scripts\mp\utility\game::getuniqueid() == var_01)
  var_02 = var_08;
  }
  }

  var_10 = getdvarint("scr_team_fftype");

  if (isdefined(self.func_A667) && isdefined(self.func_A667.func_9E20))
  self.func_A667 radiusdamage(self.owner.origin, 200, 2600, 2600, self.func_A667);
  else if (isdefined(var_02) && var_10 != 2)
  radiusdamage(self.owner.origin, 200, 2600, 2600, var_02);
  else if (var_10 == 2 && isdefined(var_02) && scripts\mp\utility\game::attackerishittingteam(var_02, self.owner)) {
  radiusdamage(self.owner.origin, 200, 2600, 2600, var_02);
  radiusdamage(self.owner.origin, 200, 2600, 2600);
  }
  else
  radiusdamage(self.owner.origin, 200, 2600, 2600);

  self.owner.onhelisniper = 0;
  self.owner.func_8DD6 = undefined;
  }
}

func_F881() {
  if (!scripts\mp\utility\game::_hasperk("specialty_falldamage")) {
  level endon("game_ended");
  self endon("death");
  self endon("disconnect");
  scripts\mp\utility\game::giveperk("specialty_falldamage");
  wait 2;
  scripts\mp\utility\game::removeperk("specialty_falldamage");
  }
}

func_DE3E() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self.owner endon("death");
  self.owner endon("disconnect");
  self endon("dropping");
  var_00 = 0;

  for (;;) {
  wait 0.05;

  if (!isdefined(self.owner.lightarmorhp) && !self.owner scripts\mp\utility\game::isjuggernaut()) {
  self.owner scripts\mp\perks\perkfunctions::setlightarmor();
  var_0++;

  if (var_00 >= 2)
  break;
  }
  }
}

func_A576() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self.owner endon("death");
  self.owner endon("disconnect");
  self endon("dropping");

  for (;;) {
  if (self.owner getstance() != "crouch")
  self.owner setstance("crouch");

  wait 0.05;
  }
}

_meth_835D() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self endon("dropping");
  self.owner endon("disconnect");

  for (;;) {
  if (!isalive(self.owner))
  return "fail";

  if (self.owner getcurrentprimaryweapon() != "iw6_gm6helisnipe_mp_gm6scope") {
  self.owner giveweapon("iw6_gm6helisnipe_mp_gm6scope");
  self.owner scripts\mp\utility\game::_switchtoweaponimmediate("iw6_gm6helisnipe_mp_gm6scope");
  self.owner getraidspawnpoint();
  self.owner scripts\mp\utility\game::setrecoilscale(0, 100);
  self.owner givemaxammo("iw6_gm6helisnipe_mp_gm6scope");
  }
  else
  return;

  wait 0.05;
  }
}

func_E2B9() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self.owner endon("death");
  self.owner endon("disconnect");
  self.owner endon("dropping");

  for (;;) {
  self.owner waittill("weapon_fired");
  self.owner givemaxammo("iw6_gm6helisnipe_mp_gm6scope");
  }
}

func_DB16() {
  level endon("game_ended");
  self.owner endon("disconnect");
  self endon("death");
  self endon("crashing");
  self.owner waittill("death");
  self.owner.onhelisniper = 0;
  self.owner.func_8DD6 = undefined;
  self.func_C834 = 0;

  if (isdefined(self.origin))
  physicsexplosionsphere(self.origin, 200, 200, 1);
}

func_AB2F() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self endon("end_disconnect_check");
  self.owner waittill("disconnect");
  self notify("owner_disconnected");
  thread heliisfacing();
}

func_AB2E() {
  level endon("game_ended");
  self endon("death");
  self endon("crashing");
  self endon("end_death_check");
  self.owner waittill("death");
  self notify("owner_death");
  thread heliisfacing();
}

func_7E34(var_00) {
  var_01 = undefined;
  var_02 = 999999;

  foreach (var_04 in level.func_1A66) {
  var_05 = distance(var_4.origin, var_00);

  if (var_05 < var_02) {
  var_01 = var_04;
  var_02 = var_05;
  }
  }

  return var_01;
}

func_136B6() {
  var_00 = self getentitynumber();
  self waittill("death");
  level.lbsniper = undefined;

  if (isdefined(level.func_8DD7)) {
  level.func_8DD7 = undefined;
  level notify("update_uplink");
  }
}

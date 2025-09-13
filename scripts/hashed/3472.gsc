/***************************************
 * Decompiled and Edited by SyndiShanX
 * Script: 3472.gsc
***************************************/

init() {
  var_00 = spawnstruct();
  var_0.weaponinfo = "deployable_vest_marker_mp";
  var_0.modelbase = "mil_ammo_case_1_open";
  var_0.hintstring = &"KILLSTREAKS_HINTS_DEPLOYABLE_AMMO_USE";
  var_0.func_3A41 = &"KILLSTREAKS_DEPLOYABLE_AMMO_TAKING";
  var_0.func_67E5 = "deployable_ammo_taken";
  var_0.streakname = "deployable_ammo";
  var_0.func_10A38 = "used_deployable_ammo";
  var_0.shadername = "compass_objpoint_deploy_ammo_friendly";
  var_0.headiconoffset = 25;
  var_0.lifespan = 90.0;
  var_0.usexp = 50;
  var_0.scorepopup = "destroyed_vest";
  var_0.vodestroyed = "ballistic_vest_destroyed";
  var_0.deployedsfx = "mp_vest_deployed_ui";
  var_0.onusesfx = "ammo_crate_use";
  var_0.onusecallback = ::onusedeployable;
  var_0.canusecallback = ::func_3937;
  var_0.usetime = 500;
  var_0.maxhealth = 150;
  var_0.damagefeedback = "deployable_bag";
  var_0.deathweaponinfo = "deployable_ammo_mp";
  var_0.deathvfx = loadfx("vfx\iw7\_requests\mp\vfx_debug_warning.vfx");
  var_0.deathdamageradius = 256;
  var_0.deathdamagemax = 130;
  var_0.deathdamagemin = 50;
  var_0.allowmeleedamage = 1;
  var_0.allowhvtspawn = 1;
  var_0.maxuses = 4;
  level.boxsettings["deployable_ammo"] = var_00;
  scripts\mp\killstreaks\killstreaks::registerkillstreak("deployable_ammo", ::func_128DE);
  level.deployable_box["deployable_ammo"] = [];
}

func_128DE(var_00, var_01) {
  var_02 = scripts\mp\killstreaks\deployablebox::begindeployableviamarker(var_00, "deployable_ammo");

  if (!isdefined(var_02) || !var_02)
  return 0;

  scripts\mp\matchdata::logkillstreakevent("deployable_ammo", self.origin);
  return 1;
}

onusedeployable(var_00) {
  func_17A6();
}

func_17A6() {
  var_00 = self getweaponslistall();

  if (isdefined(var_00)) {
  foreach (var_02 in var_00) {
  if (scripts\mp\weapons::isbulletweapon(var_02)) {
  func_1805(var_02, 2);
  continue;
  }

  if (weaponclass(var_02) == "rocketlauncher")
  func_1805(var_02, 1);
  }
  }
}

func_1805(var_00, var_01) {
  var_02 = weaponclipsize(var_00);
  var_03 = self getweaponammostock(var_00);
  self setweaponammostock(var_00, var_03 + var_01 * var_02);
}

func_1819(var_00) {
  var_01 = self getweaponslistprimaries();

  foreach (var_03 in var_01) {
  if (scripts\mp\weapons::isbulletweapon(var_03)) {
  if (var_03 != "iw6_alienminigun_mp") {
  var_04 = self getweaponammostock(var_03);
  var_05 = weaponmaxammo(var_03);
  var_06 = var_04 + var_05 * var_00;
  self setweaponammostock(var_03, int(min(var_06, var_05)));
  }
  }
  }
}

func_17C6() {
  var_00 = self getweaponslistprimaries();

  foreach (var_02 in var_00) {
  var_03 = weaponclipsize(var_02);
  self setweaponammoclip(var_02, var_03);
  }
}

func_3937(var_00) {
  return !scripts\mp\utility\game::isjuggernaut();
}

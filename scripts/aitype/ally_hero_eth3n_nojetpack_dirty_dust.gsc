/***********************************************************
 * Decompiled and Edited by SyndiShanX
 * Script: aitype\ally_hero_eth3n_nojetpack_dirty_dust.gsc
***********************************************************/

main() {
  self.func_17DB = "";
  self.team = "allies";
  self.type = "human";
  self.unittype = "C6i";
  self.subclass = "regular";
  self.accuracy = 0.2;
  self.health = 200;
  self.grenadeweapon = "frag";
  self.grenadeammo = 0;
  self.secondaryweapon = "";
  self.func_101B4 = func_0A2F::func_7BEC("pistol");
  self.behaviortreeasset = "enemy_combatant";
  self.func_1FA9 = "soldier";

  if (isai(self)) {
  self _meth_82DC(256.0, 0.0);
  self _meth_82DB(768.0, 1024.0);
  }

  self.weapon = func_0A2F::func_7BEC("smg");
  func_08EA::main();
}

spawner() {
  self _meth_833A("allies");
}

precache() {
  func_08EA::precache();
  scripts\aitypes\bt_util::init();
  func_09FD::func_33FB();
  func_03AE::func_DEE8();
  func_0C69::func_2371();
  precacheitem("frag");
}
